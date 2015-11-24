class Transfer < ActiveRecord::Base
	has_many :items, class_name: :TransferItem

	has_many :uploads, class_name: :TransferUpload, foreign_key: :master_id
  

  # default_scope -> {order("id desc")}
  belongs_to :rule
  

	include AboutStatus

  after_create do 
    create_no("TRA", "sn")
  end

  # 附件的类
  def self.upload_model
    TransferUpload
  end



	# 中文意思 状态值 标签颜色 进度 
	def self.status_array
		[
	    ["暂存",0,"orange",50],
	    ["已发布",1,"blue",100],
	    ["已删除",404,"light",0]
    ]
  end

  # 根据不同操作 改变状态
  def change_status_hash
    return {
      "提交" => { 0 => 1 },
      "删除" => { 0 => 404 }
    }
  end


  def self.xml(who='',options={})
    %Q{
      <?xml version='1.0' encoding='UTF-8'?>
      <root>
        <node name='单位名称' column='dep_name'  class='required' display='readonly'/>
        <node name='联系人' column='dep_man'  class='required'/>
        <node name='联系人电话' column='dep_mobile' class='required' />
        <node name='联系电话' column='dep_tel'  class='required' />
        <node name='单位地址' column='dep_addr'  class='required' />
        <node name='备注' column='summary' data_type='textarea' placeholder='不超过800字'/>
        <node column='total' data_type='hidden'/>
      </root>
    }
  end


end
