Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=115.124.28.98
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793028883;
	b=t7Fg0EJNZs8WT4rWqL9oTFtfmBGRC9rMPFaS99xC3adMHvn0e9ArFuBmAGWmsXs7hbk7
	 ffQJKHdzfsUxnyDBXVNFWqpLSXU7S0OZ0BlGCE6w95+zL3X9/ZZp8kNGqaaK7wlybNMW4
	 mqwEeHYYFt3QA8F50oVL64oeBqKtiPrdQjA5PAxeMWdfGIqX/fsHiggO7/g8BCVB42KPP
	 mg8iBqBxyhKbp38Sl8NlA44YCzpHpk/v1teHRcVEuH4sdBzoARlHFdb0IPxCg9LEwcgTM
	 Q6GsVlp8jbEBuAQkAKLMZVDiaPp62Xwrc9bu5h4IRiipCfL77S3hd7E1GmFHcRhsCMQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793028883;
	h=DMARC-Filter:DKIM-Signature:X-Alimail-AntiSpam:Received:From:To:Cc:
	 Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=5WbTE6FtCqbifuziiK1Je8VFGg0z85esmt3ElMO056c=;
	b=inWr6r17vY7Z5h9HJblTkIDHEbq8uLb4yr2CY3hezNx/YgsazLItX3gYZices15IfIKp
	 2v8bQ/+BYYl6x2XQHIJ++ebGA4ZLET0TV5Rytk6vhFvUy56fuT56o1MB5BzUUaTDSJXHf
	 fuXds91nzKeCBl4jtMUDToQeBpyF/iRbjXuoRpCzdPz3CBwujmd8Oz3GcgwVVrrh+RXZw
	 WpBAweFZ/UtnV/HQyUenM4RMHddki+q1JrSShJuwsQP0h5m12T5dGNhDzhPkXfCpY6B2d
	 X4ych/XmDbIQ4Bgb4MVBdSEhqP5IGwS+FO9av90xpnFfYaAR1BerXBIqFcN9wCYlfAQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=xiaopeng.com;
	spf=pass smtp.mailfrom=xiaopeng.com;
	dkim=pass header.d=xiaopeng.com header.i=@xiaopeng.com header.a=rsa-sha256 header.s=default header.b=gycQtTV9;
	arc=none smtp.remote-ip=115.124.28.98
Received: from out28-98.mail.aliyun.com (out28-98.mail.aliyun.com [115.124.28.98])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7715606A31A;
	Mon, 26 Oct 2026 15:34:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C7715606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=xiaopeng.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=xiaopeng.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=xiaopeng.com header.i=@xiaopeng.com header.a=rsa-sha256 header.s=default header.b=gycQtTV9
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=xiaopeng.com; s=default;
	t=1793028871; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=5WbTE6FtCqbifuziiK1Je8VFGg0z85esmt3ElMO056c=;
	b=gycQtTV9gpsNfdC/iZJ3G8/cRmysmvw1+jDwlDzvSw/4Zyd+J08v4LlFzQ2XU2xJ988oYIOFTIhtnm6JrxrkhQHiTikWBl4sEOAN9X0hCUb+aw+LXD+ip2+KpXDSwQVB0iDrtvZqwnY8OnaetBuhvIac2+mXMq2hMtc5d0fEXPU=
X-Alimail-AntiSpam:AC=CONTINUE;BC=0.1212897|-1;CH=green;DM=|CONTINUE|false|;DS=CONTINUE|ham_news_journal|0.0519486-0.00412499-0.943926;FP=18301423795854014354|0|0|0|0|-1|-1|-1;HT=maildocker-contentspam033037034184;MF=fangxy@xiaopeng.com;NM=1;PH=DS;RN=13;RT=13;SR=0;TI=SMTPD_---.jq4ePfq_1793028869;
Received: from localhost.localdomain(mailfrom:fangxy@xiaopeng.com fp:SMTPD_---.jq4ePfq_1793028869 cluster:ay29)
          by smtp.aliyun-inc.com;
          Mon, 26 Oct 2026 23:34:30 +0800
From: Fang Xieyan <fangxy@xiaopeng.com>
To: fw@strlen.de
Cc: pablo@netfilter.org,
	phil@nwl.cc,
	davem@davemloft.net,
	edumazet@kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	horms@kernel.org,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	liuwb@xiaopeng.com
Subject: Re: [PATCH] netfilter: xt_policy: add NULL check for skb_dst() in output policy match
Date: Mon, 26 Oct 2026 23:34:28 +0800
Message-ID: <20261026153428.76698-1-fangxy@xiaopeng.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20261026125313.14810-1-fangxy@xiaopeng.com>
References: <20261026125313.14810-1-fangxy@xiaopeng.com>
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Florian,

Thanks for the explanation. Agreed, I'll drop this patch.

Thanks,
Fang Xieyan
