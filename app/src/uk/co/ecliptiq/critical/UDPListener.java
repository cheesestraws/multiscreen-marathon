package uk.co.ecliptiq.critical;

import org.apache.cordova.*;
import org.apache.cordova.api.*;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.net.DatagramSocket;
import java.net.DatagramPacket;
import java.io.IOException;
import android.os.AsyncTask;
import android.util.Log;



public class UDPListener extends CordovaPlugin {
	
	private CallbackContext callback = null;
	
	// asynctask
	private static class UDPTask extends AsyncTask<Void, String, Void> {
		private CallbackContext ctx = null;
		private int portNumber = 0;
		private DatagramSocket ds = null;
		private boolean quitting = false;
		
		public UDPTask(int portNumber, CallbackContext ctx) {
			this.portNumber = portNumber;
			this.ctx = ctx;
		}
	
		protected Void doInBackground(Void[] params) {
			try {
				DatagramPacket pack = new DatagramPacket(new byte[1024], 1024);
				
				ds = new DatagramSocket(this.portNumber);
				while (!quitting) {
					Log.d("FOO", "ergh1");
					ds.receive(pack);
					Log.d("FOO", "ergh2");

					// "this is such a silly way for it to..." -- RJ
					byte[] b = new byte[pack.getLength()];
					for (int i = 0; i < pack.getLength(); i++) {
						b[i] = pack.getData()[i];
					}

					String s = new String(b, "UTF-8");
					publishProgress(s, pack.getAddress().getHostAddress());
				}

			} catch (IOException e) {
				; // *incredibly* naughty rob
				Log.d("CritUDPListener", "IOException:" + e.getMessage());
			}
			return null;
		}
		
		protected void onProgressUpdate(String... progress) {
			// this is where the callback needs to happen
			try {
				JSONObject o = new JSONObject();
				o.put("text", progress[0]);
				o.put("ip", progress[1]);
								
				PluginResult res = new PluginResult(PluginResult.Status.OK, o);
				res.setKeepCallback(true);
				ctx.sendPluginResult(res);
			} catch (JSONException e){ 
				// ugh
			}
		}
		
		protected void onPostExecute(Void result) {
			// do nothing
		}
	}
	
	UDPTask t;
	
	public boolean execute(String action, JSONArray args, CallbackContext callbackContext) {
	
		// create thread for udp listener
		if (action.equals("start")) {
			callback = callbackContext;
		
			// create the thread somewhere in here.
			t = new UDPTask(5425, callbackContext);
			t.execute();
		
			// keep our callback and return no immediate result
			PluginResult pluginResult = new PluginResult(PluginResult.Status.NO_RESULT);
			pluginResult.setKeepCallback(true);
			callbackContext.sendPluginResult(pluginResult);
			return true;
		} else if (action.equals("stop")) {
			// kill thread
			
			callbackContext.success();
			return true;
		}
		
		return false;
	}
	
	
	
}