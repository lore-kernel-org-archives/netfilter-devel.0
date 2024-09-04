Received: from out162-62-58-216.mail.qq.com (out162-62-58-216.mail.qq.com [162.62.58.216])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 292EF1D0174
	for <netfilter-devel@vger.kernel.org>; Wed,  4 Sep 2024 12:30:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=162.62.58.216
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725453014; cv=none; b=YabDVEMKSjyWioNzoxP7UHdyZNOOGyfXUFPI7v2syPRzuv7ddMnyg2UuISB3KEWtVolwRr/6rkFOqJplxi6eAvtF9HT86OKJLEIJGFkp1BAogZQ8uXymbQkPnnYjax+cE1L21HxIPYIshrWqSmvZ+X3JS6BX/DcZg4rqKCvcNDM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725453014; c=relaxed/simple;
	bh=BzSR+iF80WBX+uueKwT7tQdRcX9cS6wGP+R5wlC6WBI=;
	h=Message-ID:From:To:Cc:Subject:Date:MIME-Version; b=RUueaWC6s0nY86C3JtoJE+lCzLURTGsAFfR1CJN7h2spVbKJ/ig0T6c7ywmAEHT4ZZ6GT5Xc2aDjA+Ujgah2Iz8nzh/7It+KcJsHeZe6yBRrfZdWD9jIj+AceuvjlqcR7abyBFYICAbl4nzdiXWiaAQXJy3X7l6XE+tC/+EZrmQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=foxmail.com; spf=pass smtp.mailfrom=foxmail.com; dkim=pass (1024-bit key) header.d=foxmail.com header.i=@foxmail.com header.b=jJazSsVu; arc=none smtp.client-ip=162.62.58.216
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=foxmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=foxmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=foxmail.com header.i=@foxmail.com header.b="jJazSsVu"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=foxmail.com;
	s=s201512; t=1725452702;
	bh=mD6Sm4uUq8ujV/RDO5ndOtiCjedlBdoHLSnc4vE9J64=;
	h=From:To:Cc:Subject:Date;
	b=jJazSsVuDFwvW0/yagvg626+sN0F4fuX51X45mN04cZDcYveXUfWndaK241vgstPE
	 sRhzi/Ox/aRhxTMs296dY6Bt6M7NHhpns3fWIqNj8DFM5L5og1eTEUexrDQb+s3Ss3
	 +ifq6l8VqtL0fxTj1L+V9nNhVGorM5HuUqZ6OPEs=
Received: from localhost.localdomain ([114.246.200.160])
	by newxmesmtplogicsvrszb16-1.qq.com (NewEsmtp) with SMTP
	id 4AB12AD4; Wed, 04 Sep 2024 20:18:43 +0800
X-QQ-mid: xmsmtpt1725452323t1inlzbgz
Message-ID: <tencent_DE4D2D0FE82F3CA9294AEEB3A949A44F6008@qq.com>
X-QQ-XMAILINFO: MmpliBmRb3iCZG+tszeXk1rzRTEAY7Bed4qo4m+KlRYfIVoyBGpwOVX4mO77ZY
	 b+Xqy7SLZGWfrwnRHtOZNdCwN0OniQ7xIFUh/h7DIjjwpabvomfISJlDDVQNTPZMEgs5X9jDXHVt
	 EI6aJ0+4YZKMbbgGdZLsivYIdrX6Ntu+8P/CvzP+jBaUBDvJXQ6RbfvFbQuSFD5K5vztokPsFVvP
	 rJx/qdevWPaI1vUP+yng0vTrlBElocp2DV3z/X3ur7ydURKBzJ2kyPsTX07Fn4Y6UmMi2Bo3scwg
	 qoz/FupAX3gyrTLU7nfmAO+aqaZotXR8XUH0s3hv0dhPwm0vfvxMbDrEVPqZTsp9+NFSN5pDCJnR
	 3fFSkfTi3nOaz3ovfcIrnFxXkEqsx0FQkgO4wCNSf48uT9Lel2SfYoo+3QYtnYBewEbzesiQxOVN
	 VtY2RuwN4zCB/IqS7m5FFsWGTi7gC0OFydSJYTtxFuB2r0nC0ak9tVTG0TcEAzHI9vE9I2MIoG4k
	 7jylnykNoETtb3+CTTCoQ6oeMkdb0WuqXpDefxtGJVbl6fCn915yRD1qYi52rsJYLRMNSr15L3/2
	 /qS4sZ5a8X4HdrN0YhSCLrFakVTx9PkZp0Z/+i32jcy2p4eOMHKbCITYZaFg3b0ZL3SUXSJszdl9
	 yJtMYM1jzGtNr2hnYTgvOFNbZc4AvB/IANS21jaYztmeeCizsRnel5+qSDayX/2HAHCFdSzZ/Wq4
	 w3YCvqoEgYv1tc1vIaS+GAScGfAtixgoAToaMdNassMj3OBVNWq9h8IDspXkO/279ix7+zdDL443
	 M4X2oCQvv35/uBifzzqsw3GadbkipXnQISvF+3fN1Iz3I6A8NvvNlDHN+2MGfSMrZbtbxAcce4dd
	 WmNz9LbIGPB+rIbG02VImw0wrspwCZ7wuYbw+LU7ZTdk3n4KWjgTuKgN/R9QZ4gZFN2yF1XijfMK
	 iDKB+CW4LYhfKP1VsnoDgJmhLJr45tN4wEm/Pc2lm7/+DdIbdmfmcU0HKwHOYcGQvGoNEDEWyKme
	 Rs4Y83ST+9oJMc2RwDahIs3S/buMKkJXxGUTYMEalA8PGxdi27g9gagYQ6PS8=
X-QQ-XMRINFO: NI4Ajvh11aEj8Xl/2s1/T8w=
From: Jiawei Ye <jiawei.ye@foxmail.com>
To: pablo@netfilter.org,
	kadlec@netfilter.org,
	davem@davemloft.net,
	dsahern@kernel.org,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	fw@strlen.de
Cc: netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] netfilter: tproxy: Add RCU protection in nf_tproxy_laddr4
Date: Wed,  4 Sep 2024 12:18:42 +0000
X-OQ-MSGID: <20240904121842.981264-1-jiawei.ye@foxmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In the `nf_tproxy_laddr4` function, both the `__in_dev_get_rcu()` call
and the `in_dev_for_each_ifa_rcu()` macro are used to access
RCU-protected data structures. Previously, these accesses were not
enclosed within an RCU read-side critical section, which violates RCU
usage rules and can lead to race conditions, data inconsistencies, and
memory corruption issues.

This possible bug was identified using a static analysis tool developed
by myself, specifically designed to detect RCU-related issues.

To address this, `rcu_read_lock()` and `rcu_read_unlock()` are added
around the RCU-protected operations in the `nf_tproxy_laddr4` function by
acquiring the RCU read lock before calling `__in_dev_get_rcu()` and
iterating with `in_dev_for_each_ifa_rcu()`. This change prevents
potential RCU issues and adheres to proper RCU usage patterns.

Fixes: b8d19572367b ("netfilter: use in_dev_for_each_ifa_rcu")
Signed-off-by: Jiawei Ye <jiawei.ye@foxmail.com>
---
 net/ipv4/netfilter/nf_tproxy_ipv4.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/ipv4/netfilter/nf_tproxy_ipv4.c b/net/ipv4/netfilter/nf_tproxy_ipv4.c
index 73e66a088e25..51ff9c337e71 100644
--- a/net/ipv4/netfilter/nf_tproxy_ipv4.c
+++ b/net/ipv4/netfilter/nf_tproxy_ipv4.c
@@ -57,8 +57,10 @@ __be32 nf_tproxy_laddr4(struct sk_buff *skb, __be32 user_laddr, __be32 daddr)
 		return user_laddr;
 
 	laddr = 0;
+	rcu_read_lock();
 	indev = __in_dev_get_rcu(skb->dev);
 	if (!indev)
+		rcu_read_unlock();
 		return daddr;
 
 	in_dev_for_each_ifa_rcu(ifa, indev) {
@@ -68,6 +70,7 @@ __be32 nf_tproxy_laddr4(struct sk_buff *skb, __be32 user_laddr, __be32 daddr)
 		laddr = ifa->ifa_local;
 		break;
 	}
+	rcu_read_unlock();
 
 	return laddr ? laddr : daddr;
 }
-- 
2.34.1

