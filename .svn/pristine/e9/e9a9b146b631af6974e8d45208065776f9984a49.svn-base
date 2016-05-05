package com.moon.android.moonplayer.service;

import java.util.ArrayList;
import java.util.List;

import net.tsz.afinal.FinalHttp;
import net.tsz.afinal.http.AjaxCallBack;
import android.app.ActionBar.Tab;
import android.content.Context;
import android.os.Handler;
import android.os.Message;
import android.util.Log;
import android.view.SubMenu;

import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;
import com.moon.android.iptv.arb.film.Configs;
import com.moon.android.iptv.arb.film.MyApplication;
import com.moon.android.iptv.arb.film.ProgramCache;
import com.moon.android.iptv.arb.film.Configs.Success;
import com.moon.android.model.AllListModel;
import com.moon.android.model.Navigation;
import com.moon.android.model.VodProgram;
import com.moon.android.model.AllListModel.Submenu;
import com.moon.android.model.SeconMenu;
import com.moonclound.android.iptv.util.DbUtil;
import com.moonclound.android.iptv.util.HostUtil;
import com.moonclound.android.iptv.util.Logger;

public class ListCacheService {
	private Logger log = Logger.getInstance();
	private String mPath = Configs.ALL_LIST_CACHE;
	public static List<AllListModel> AllListCache = null;
	public String tag = "LisetCacheService";
    public int ReTryNum=5;//重试取缓存总次数;
    public int TryNumEd=0;//已重试数量
    public Handler mHandel;
    public DbUtil db;
	public ListCacheService(Handler handel) {
		mHandel=handel;
		db=new DbUtil(MyApplication.getApplication());
		start();
	}
    public static List<Navigation> GetNavigation(){
    	if(AllListCache==null) return null;
    	if(AllListCache.size()<=0) return null;
    	List<Navigation> re=new ArrayList<Navigation>();
    	for(int i=0;i<AllListCache.size();i++){
    		AllListModel Item=AllListCache.get(i);
    		re.add(new Navigation(Item.getCid(), Item.getName()));
    	}
    	if(re.size()>0){
    		return re;
    	}else{
    		return null;
    	}
    
    }
	public static List<SeconMenu> GetSecondMenuByCid(String Cid){
    	if(AllListCache==null) return null;
    	if(AllListCache.size()<=0) return null;
//    	Log.d("---","传入ID："+Cid);
    	for(int i=0;i<AllListCache.size();i++){
    		AllListModel Item=AllListCache.get(i);
    		String ItemCid=Item.getCid();
//    		Log.d("---","当前ID："+ItemCid);
    		if(ItemCid.equals(Cid)){
    			return Item.getSubmenu();
    		}
    	}
    	return null;
    }
//    public static List<VodProgram> GetVodPro(String Cid,SeconMenu seconMenu){
//    	GetSecondMenuByCid(Cid);
//    	return null;
//    }
	private void start() {
		// TODO Auto-generated method stub
		getFromNet();
		Log.d(tag, "开启获取所有列表缓存");
		String Alljson=db.GetAllList();
		if (Alljson!=null) {
			String gson =Alljson;
		   
			try {
				AllListCache = new Gson().fromJson(gson,
						new TypeToken<List<AllListModel>>() {
						}.getType());
			} catch (Exception e) {
				// TODO: handle exception
			}
//			 for(int i=0;i<AllListCache.size();i++){
//			 if(i==0){
//			 List<SeconMenu> sm=AllListCache.get(i).getSubmenu();
//			 for(int j=0;j<sm.size();j++){
//			 Log.d(tag,sm.get(j).getClassify());
//			 }
//			 }
//			 }
		} else {
//			getFromNet();
		}

	}

	private void getFromNet() {
		// TODO Auto-generated method stub
        if(ReTryNum>TryNumEd){
        	
        
		FinalHttp finalHttp = new FinalHttp();
		Log.d(tag,"第"+TryNumEd+ "次获取总列表地址：" + Configs.URL.getListCache());
		finalHttp.get(Configs.URL.getListCache(), new AjaxCallBack<String>() {
			@Override
			public void onSuccess(String t) {
				// TODO Auto-generated method stub
				super.onSuccess(t);
				Log.d(tag, "网络获取节目单:" + t);
				try {
					AllListCache = new Gson().fromJson(t,
							new TypeToken<List<AllListModel>>() {
							}.getType());
					Log.d(tag, "左侧菜单数量:" + AllListCache.size());
						if(AllListCache.size()>0){
							//ProgramCache.save(mPath, t);
							db.SaveAllList(t);
							mHandel.sendEmptyMessage(Configs.CACHE_LIST_NEW);
						}
				
				} catch (Exception e) {
					// TODO: handle exception
					TryNumEd++;
					if(TryNumEd==1){
						Configs.URL.HOST=Configs.URL.HOST1;
					}
					if(TryNumEd==2){
						Configs.URL.HOST=Configs.URL.HOST2;
					}
					if(TryNumEd==3){
						Configs.URL.HOST=Configs.URL.HOST3;
					}
					
					getFromNet();
					
				}
               
			
			}

			@Override
			public void onFailure(Throwable t, int errorNo, String strMsg) {
				super.onFailure(t, errorNo, strMsg);
				Log.d(tag, "获取缓存列表网络连接异常,strMsg=" + strMsg + "  errorNo="
						+ errorNo);
				TryNumEd++;
				if(TryNumEd==1){
					Configs.URL.HOST=Configs.URL.HOST1;
				}
				if(TryNumEd==2){
					Configs.URL.HOST=Configs.URL.HOST2;
				}
				if(TryNumEd==3){
					Configs.URL.HOST=Configs.URL.HOST3;
				}
				getFromNet();

			}
		});
        }else{
        	Log.d(tag,"获取缓存失败");
        }
	}
}
