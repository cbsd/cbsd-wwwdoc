main={
	start:function()
	{
		var html='';
		var count=0;
		var anchors=document.getElementsByTagName('a');
		for(n=0,nl=anchors.length;n<nl;n++)
		{
			var anchor=anchors[n];
			if(anchor.name!='')
			{
				var name=anchor.name;
				var txt=anchor.innerHTML;
				var html=html+'<a href="#'+name+'">'+txt+'</a>';
				count++;
			}
		}
		if(count<2)
		{
			html='&nbsp;';
		}
		var div=document.getElementById('referat');
		div.innerHTML=html;
	}
}