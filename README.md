# JMPhotoAlbum
相册

PhotoKit框架的架构     

<1> 相册管理者    
    PHPhotoLibrary    
    Request Authorization to Access Photos    
      
<2> 资源获取    
    PHObject:资源抽象类   
    PhAsset: 图片库中图像、视频或活动照片的表示形式。 如果直接通过PHAsset获取图片资源，将直接拿到资源。
    PHAssetCollection: 照片资源分组的表示，如瞬间、用户创建的相册或智能相册。通过PHAssetCollection获取资源，先获取到相册集，再通过指定相册通过                             PhAsset获取资源。     
    PHCollectionList: 包含照片资源集合的组，如时刻、年份或用户创建相册的文件夹。通过PHCollectionList获取资源，先获取到相册集，再通过指定相册通过                             PhAsset获取资源。                  
    PHFetchResult: 查询结果.             
 
<3> 资源加载 
    PHImageManager: 可以请求想要的指定资源.        
    PHCachingImageManager: 图片缓存.           

<4> Live Photos 
    PHLivePhotoView:A view that displays a Live Photo—a picture that also includes motion and sound from the moments just before and after its capture.   
    PHLivePhoto: A displayable representation of a Live Photo—a picture that includes motion and sound from the moments just before and after its capture.      
    
<5>资源管理
    PHAssetResource: 与照片库中的照片、视频或活动照片资产相关联的底层数据资源。
    PHAssetResourceManager: 请求从基础数据资源创建新的照片资产，以在照片库更改块中使用。        
    PHAssetCreationRequest:用于照片资产下的数据存储的资源管理器。

# 实现自定义相册的思路                   
    定义图片管理器          
    ～ 获取相册 AssetCollection      
    ～ 获取资源 Asset        
    ～ 获取图片 Photo        
    获取到资源即可展示       
 <1>第一种方法是直接获取到全部图片资源用于展示。但是存在的问题是如果图片资源非常多的情况，获取图片的等待时间很长，造成界面显示延时高。           
 <2>第二种方法是先获取到图片资源类(Asset)，可先用于UI创建，在显示图片的cell中请求对应的图片展示。       
 




     









