Received: from xmbghk7.mail.qq.com (xmbghk7.mail.qq.com [43.163.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35C611A0BDE
	for <netfilter-devel@vger.kernel.org>; Thu, 12 Sep 2024 12:00:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=43.163.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726142416; cv=none; b=XYxjLbqNY8U3d9drCblZEACxhSMYOI/HOd+GF9PWmlGew2VsWB+I3cSL9BzjPWE9j72fuYcalG9GZ6znaPm090I9y+4m9ilSbnSt0hYSLt7suuBaPPSd3W9vUQMsDS87JKHeNCnILPXemQt6wK0nhCcsuwlfrxzBwhXsmiZgkHg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726142416; c=relaxed/simple;
	bh=AxRhtwxdMlouHBvrF6L72y4lg9fwVZJASQ0P/+pHWuE=;
	h=Message-ID:From:To:Cc:Subject:Date:MIME-Version:Content-Type; b=mT+YsnT5jnFNWlT42zoV/JdefYu9Ut9Mjn7plQSmLPIJRZiwJ9BPn/jKxf9vE6pPJGiHY5QIYIc6g2caxexSdG4A7mnHOTX8wfbt4Tv5TuLQ3xQGCFEsRCu1AlZlmo/yqp4qxU77eU+QFvIMHM4vd86dH+vxN4G+72kgFrGC+xU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=Red54.com; spf=pass smtp.mailfrom=red54.com; dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b=z2FIwMWD; arc=none smtp.client-ip=43.163.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=Red54.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=red54.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b="z2FIwMWD"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1726142391; bh=1CL0syZ2OXud57sTgIOA67UtY9dpcF7r1umhDF6Uj6w=;
	h=From:To:Cc:Subject:Date;
	b=z2FIwMWDolAj8W8r8wfXrl3d+6ocCcjNygBaIbRuEvKLQtY//2bbK2sknWGuyg09v
	 zsbz5OgwF7r6cpf2M+pC6l308Ti1g3QnTN29KF9cG0lodOGPlO7Ut6ZFNcQaL+PYbZ
	 kYcPamTuTF8Wkn74SEO7WeeVBs48BgdmpgP9+5BE=
Received: from mail.red54.com ([2a09:bac1:31a0::16:1a0])
	by newxmesmtplogicsvrszc5-2.qq.com (NewEsmtp) with SMTP
	id EEC9F4EE; Thu, 12 Sep 2024 19:59:44 +0800
X-QQ-mid: xmsmtpt1726142384t3zzabzev
Message-ID: <tencent_FABBCCCF4EA018ED7BCF8335E5DFDEB37206@qq.com>
X-QQ-XMAILINFO: Mc9fAEDwzgE3Ha4BhL0ZsqhZC1lJtO66j9xjJz2zg1R9U9OchXqjNrmivu3Zib
	 y8ppJIXuQVijq25kY6ufFNmBUIS55nrMr9KmI8rD4Fczbea+xotRIZCO2/WH4OLz/V257fNp4y+R
	 1j4aKWSxOx8q2ZeMuz+uZywPpK3wVP2OdaIP0/z9EFtDfI2d2DQUK2iYVK1UfAhURU2mnSpV0Qew
	 1Td27GBCEJ+Q2TwAwDooWSXyHl3nnl5z0CBIXmMyF7DK7tPekfi160vRphWvZpqAY5W4enZ/rNMl
	 HT7BpVEg423L1xRnXZ1zaWVWMC8rpF4UHVNcfC82S+YMAt6RG7otFaurtnTtL2N/HYSvs6F8meZt
	 Is6ApJxuujAkci/iMLW4srUrVfVHRz5t5PkMNsymxbn+fFDTbYtiuMBzbbfA0JAfl+YEwjC0b+3I
	 Dj9uuvp3beGc7HD0APQzQGd5aDCmy3pBbA1uZzkE68Y+9233JAaIR72Y29f1/lzxoE2tTHRJF6p9
	 JTiO03eQ2qeBFRujruF9XPbthc833aTGiK58pnTnSS/fCWJ5uhFopdsm6vE13rvJbD0aVFdaikv6
	 C+60b36WmK6VejGlKPXVodXvjJuUwbxGsJ7pcx8uiup/uBChYYGB8Os5J0I5NXLmRj1QpCkjHqpI
	 EEMIq0W/yI3G5R43ljj3VLVKuXq41vmxFo9ovh/b1LKsiP7He7hD4vxT13tWx1imnCBtCU3zHGHi
	 GePymfsufhqNJdhTz5vbpLVwFikcuOCP84YA2HMkyykk/+TnFZcoGZqxsRaYt+uEfmuCPm11vTT4
	 zls3Tg+cpL6zC8y2+h5jnUAPAih1cIVVupn/4vmKfAKhz0CJd9Jmt93uqmuHVtS6Aw61HQI4/s4E
	 IrvC8GvtyHK1G3WaGyHEqogvzNuX0EQ2SGU83qWTfk9OUFcmWd8wyRQKNodgwA0MQ7GBS8TopRrv
	 yvG94E70jegV/vI0/t8PENQffMCvU88s+Z0woHbyWXGPKVbz+M9oA8rK78jR8Qg3IeoTihdzuGq9
	 tsWcQiE/dvQCg0WP+Wq4Jp0rpJd3uT9+DzV8HyInPIdFqckMzW
X-QQ-XMRINFO: NyFYKkN4Ny6FSmKK/uo/jdU=
Sender: yeking@red54.com
From: =?UTF-8?q?=E8=B0=A2=E8=87=B4=E9=82=A6=20=28XIE=20Zhibang=29?= <Yeking@Red54.com>
To: netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org
Cc: =?UTF-8?q?=E8=B0=A2=E8=87=B4=E9=82=A6=20=28XIE=20Zhibang=29?= <Yeking@Red54.com>
Subject: [PATCH] docs: tproxy: ipt: ignore non-transparent sockets
Date: Thu, 12 Sep 2024 11:59:33 +0000
X-OQ-MSGID: <20240912115933.126-1-Yeking@Red54.com>
X-Mailer: git-send-email 2.43.5
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

The iptables example was added in commit d2f26037a38a (netfilter: Add
documentation for tproxy, 2008-10-08), but xt_socket 'transparent'
option was added in commit a31e1ffd2231 (netfilter: xt_socket: added new
revision of the 'socket' match supporting flags, 2009-06-09).

Now add the 'transparent' option to the iptables example to ignore
non-transparent sockets, which is also consistent with the nft example.

Signed-off-by: 谢致邦 (XIE Zhibang) <Yeking@Red54.com>
---
 Documentation/networking/tproxy.rst | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/networking/tproxy.rst b/Documentation/networking/tproxy.rst
index 00dc3a1a66b4..7f7c1ff6f159 100644
--- a/Documentation/networking/tproxy.rst
+++ b/Documentation/networking/tproxy.rst
@@ -17,7 +17,7 @@ The idea is that you identify packets with destination address matching a local
 socket on your box, set the packet mark to a certain value::
 
     # iptables -t mangle -N DIVERT
-    # iptables -t mangle -A PREROUTING -p tcp -m socket -j DIVERT
+    # iptables -t mangle -A PREROUTING -p tcp -m socket --transparent -j DIVERT
     # iptables -t mangle -A DIVERT -j MARK --set-mark 1
     # iptables -t mangle -A DIVERT -j ACCEPT
 
-- 
2.30.2

