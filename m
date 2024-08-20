Received: from out203-205-221-233.mail.qq.com (out203-205-221-233.mail.qq.com [203.205.221.233])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16F9218C02B
	for <netfilter-devel@vger.kernel.org>; Tue, 20 Aug 2024 09:15:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.205.221.233
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724145338; cv=none; b=ZhRssw3WySaTV7cdY5eTXRxdQfB8ZUc/aGP5dSoFLwJh5yFOyvHrh4yFiICeCGc3u0dA4PrK6u314kfNgKIm4yT7Ej/FLU0BVt6tPlI7rmBh8eOa4stOEWGdoDlaDNCd70jQ729lLTW1/QWxvJgO6bs++TtsHmC0UGYWz+pIc1I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724145338; c=relaxed/simple;
	bh=j2ZkFBPH1nuniWjjq4+J93Ntx+IcTRVGPSM3TPrs6Bc=;
	h=Message-ID:From:To:Cc:Subject:Date:MIME-Version:Content-Type; b=atOUH8TJCxNw2tZE9LQZQvK4Hke3vHBTXNrKXuocPfU0BczK8lmTR0LP7B7sMrdc9PCUcoUnGjbQeKrtvDWccunNvskoX2SSFrCYJU/spzg23+YIiWQWVXpW+Tr/UBdieo7CmmYbmudPHpc1ia/3kBzN35hUvrL4whznwNka84Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=Red54.com; spf=pass smtp.mailfrom=red54.com; dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b=mVAd6CuN; arc=none smtp.client-ip=203.205.221.233
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=Red54.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=red54.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b="mVAd6CuN"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1724145328; bh=VkR8jXks6Paq5kClWu/hrj/9bfUgC2aWIy5NUJejmdc=;
	h=From:To:Cc:Subject:Date;
	b=mVAd6CuNA999xQxsI7Pwc92OD5y1yUD32EL26fRfQfjpJ3O/iX5sFiQvyBpm13flp
	 X2eenr2pp+5zswcnNKmk3ElRQreup2NIsmOxiiOxz+jBZQ/zKUnWPGV8l2XmRbQ5JS
	 rKP0UAx0ks9D4CA2mX9TfqLSMUNhPKL+JW+pqHd4=
Received: from mail.red54.com ([2a09:bac1:31a0::16:15f])
	by newxmesmtplogicsvrszb9-0.qq.com (NewEsmtp) with SMTP
	id 3D28F829; Tue, 20 Aug 2024 17:15:18 +0800
X-QQ-mid: xmsmtpt1724145318tiv0svwd3
Message-ID: <tencent_E5B5CB5FC9F34CBBC4CF5CA0176D764FBD06@qq.com>
X-QQ-XMAILINFO: OKkKo7I1HxIebRKxeia8gnZzY5kerGl41GT4a8GqZQtG7LLWZexfw9ezsOC5FA
	 cGDJBYtbj0yfdMYhY2Rl6/jwosZ5yuXEloSBt0F128LeNk0/z7J1Mxs422+UvBlrwC/48VTkMCmG
	 WKqM2IqjGKx/VStZXJ7k7EyIHt4TMIgxnFn9pGgLpM/PAodKBNdSayS4VBSJFmnNIWo7w6OWq94a
	 Gq8tWzuB8qMLODnO0waHhVV4BFunmu/RkTt1B6xt7JyumuXi++tw7oE4AaLRkDw897CA70Zhec8Y
	 6L84VHmD9GsJYeily6tIAW9UNIi2wwi+Oedwz8ock1zl+apVJb8rlJgbMW/toQHaNW1UXco79AmP
	 unvgfwwaodFF2ID4sSRiHM1vhA7PDplojYvhChD75jwA5njSa2eDXgKPriJROZWhKIOFi8UT3bYM
	 +7w1f7c2krGaQXevvmSYkYtFNWNLRfkZh4RdAbPr5CuTgFppBxZJRUReebSdzSC2QC0lpdfZiVBm
	 dLRP3wEOYoqKEFddklULH9Q8pIbCSD8ISxr4kK5gu4GY6z9mYgdaznQ+h4vhgTD8z/ywm0fQouqT
	 7nsT2xZZNJWMOVQbZmslhpQVJDAm2suCCBLP5Ebyf2+t63LSz2sRDbhQTo1OaL4KOaiTJtqb8u4N
	 dSHCxQSBMmg2gs/imm32wBdcLLL92SuJmqsKwNurtZ5fDWO3WHHiGWjaKmz2FcZNUI+4waEmimDa
	 OZF45ycPYhz+N45GaBBpvU0+2qyhJEhjjibCTKVwT0Wd8Pag5dmTN8lsiLukcSD11ISg4cVLg1I4
	 LMUU5hq6/HQmcV8WELDpbf7N9O3YV4NhL2Xy9yOr+5MAfIYRBgmgldXiJ4CXXAkTf6XaOFqgyMKC
	 y743uAPdBY2xJS3dqc0nnlnkt6B5McZcvoBqyP74XqMXcYFMyIqIuv0IJU8H+aHo+lI9BWMxlW5u
	 oXZfTRkpHKZJYX4oaSQQiyBIBm0xWnkM5itkqIDQk2o+DS8FCEZCnE/CZi196/dZ0xAVGyZOHKhG
	 BEtF8GEMEAY5tkC/PdYefTyYzl3QB5zbzYQpnp0CB0APfNt1ik0jOGQ/tccWNvSL6Pr/BizQ==
X-QQ-XMRINFO: NyFYKkN4Ny6FSmKK/uo/jdU=
Sender: yeking@red54.com
From: =?UTF-8?q?=E8=B0=A2=E8=87=B4=E9=82=A6=20=28XIE=20Zhibang=29?= <Yeking@Red54.com>
To: netfilter-devel@vger.kernel.org
Cc: =?UTF-8?q?=E8=B0=A2=E8=87=B4=E9=82=A6=20=28XIE=20Zhibang=29?= <Yeking@Red54.com>
Subject: [nft PATCH] doc: Update outdated info
Date: Tue, 20 Aug 2024 09:15:03 +0000
X-OQ-MSGID: <20240820091503.195-1-Yeking@Red54.com>
X-Mailer: git-send-email 2.43.5
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

inet family supports route type.
unicast pkttype changed to host pkttype.

Signed-off-by: 谢致邦 (XIE Zhibang) <Yeking@Red54.com>
---
 doc/nft.txt        | 2 +-
 doc/statements.txt | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/doc/nft.txt b/doc/nft.txt
index 7e8c8695..846ccfb2 100644
--- a/doc/nft.txt
+++ b/doc/nft.txt
@@ -423,7 +423,7 @@ Chains of this type perform Native Address Translation based on conntrack
 entries. Only the first packet of a connection actually traverses this chain -
 its rules usually define details of the created conntrack entry (NAT
 statements for instance).
-|route | ip, ip6 | output |
+|route | ip, ip6, inet | output |
 If a packet has traversed a chain of this type and is about to be accepted, a
 new route lookup is performed if relevant parts of the IP header have changed.
 This allows one to e.g. implement policy routing selectors in nftables.
diff --git a/doc/statements.txt b/doc/statements.txt
index 39b31fd2..5becf0cb 100644
--- a/doc/statements.txt
+++ b/doc/statements.txt
@@ -56,7 +56,7 @@ set ip DSCP (diffserv) header field or ipv6 flow labels.
 ---------------------------------------
 # redirect tcp:http from 192.160.0.0/16 to local machine for routing instead of bridging
 # assumes 00:11:22:33:44:55 is local MAC address.
-bridge input meta iif eth0 ip saddr 192.168.0.0/16 tcp dport 80 meta pkttype set unicast ether daddr set 00:11:22:33:44:55
+bridge input meta iif eth0 ip saddr 192.168.0.0/16 tcp dport 80 meta pkttype set host ether daddr set 00:11:22:33:44:55
 -------------------------------------------
 
 .Set IPv4 DSCP header field
-- 
2.34.1

