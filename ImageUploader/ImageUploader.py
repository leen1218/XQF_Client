# -*- coding: utf-8 -*-
# flake8: noqa

from qiniu import Auth, put_file
import os
import inspect

#需要填写你的 Access Key 和 Secret Key
_access_key = 'l1NMMFf-xmqnqwQ3xibbiScwBjjZYHLiFIaTGFod'
_secret_key = 'n0olj_tdl-QUeHRK8LqJ_xeoOKW8vfGEgYWiihvV'

# 要上传的空间
_bucket_name = 'zngj'

def	uploadImageToQiniu(imagepath, imagename):
	# 构建鉴权对象
	q = Auth(_access_key, _secret_key)

	# 上传到七牛后保存的文件名
	key = imagename

	# 生成上传 Token，可以指定过期时间等
	token = q.upload_token(_bucket_name, key, 3600)

	# 要上传文件的本地路径
	localfile = imagepath

	ret, info = put_file(token, key, localfile)
	if key == ret["key"].encode("utf-8"):
		print "Upload: " + key + ", successfully!"

if __name__ == '__main__':
	currentPath = os.path.dirname(os.path.abspath(inspect.getfile(inspect.currentframe())))
	print "current path:" + currentPath
	images = os.listdir(os.path.join(currentPath, "Images"))
	for image in images:
		imagePath = os.path.join(currentPath, "Images") + "/" + image
		uploadImageToQiniu(imagePath, image)


