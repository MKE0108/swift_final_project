import coremltools as ct

tf_model_path = 'movenet_singlepose_thunder_4'  
input_image_type = ct.ImageType(shape=(1, 256, 256, 3),
                                color_layout='RGB',channel_first=False)  # tf 格式需要channel first
# 转换模型
mlmodel = ct.convert(tf_model_path, inputs=[input_image_type])
# 保存模型
mlmodel.save("movenet_singlepose_thunder_4.mlmodel")



