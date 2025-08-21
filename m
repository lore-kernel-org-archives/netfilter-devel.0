Received: from mailout1.w1.samsung.com (mailout1.w1.samsung.com [210.118.77.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65F1421772A
	for <netfilter-devel@vger.kernel.org>; Thu, 21 Aug 2025 10:39:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.118.77.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755772789; cv=none; b=f+b0CXUA8HU3BLCziYPYvjmo4oZ/6HCsQdR60a1OXVNRnHntO5fRGqGnhdS2R3HFa9LQEkGFAuAWZP5pqz8mxp2rznCIbn860lp0ZRkQ6UVs6R9ge+piDod58easGZu1JMQwDIeP/+mrYfIDCxuNseNWXRvserSBIQf2rlJCxPY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755772789; c=relaxed/simple;
	bh=hllQDp8jur5tI3Qr/EAjhROaqBs/nZsRZxVmoaxNbKE=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type:
	 References; b=YUE2BTOlkxsHPjdphUVBdQmGwjqe910ZwKtlDnrHrmoIPXiAGBS0taZhxHAZKXizXUGtG5dxUqVZHTSR4FNiCJNCSjyPcYh/BKUjrrLQ/AfzheKb+nS1P2W8D1CbiphnmRLqj+PzXKHbdosg2IBQsO6ZrN3WMDv//LfpQNFRb3A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=fonUlfqt; arc=none smtp.client-ip=210.118.77.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="fonUlfqt"
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
	by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20250821103945euoutp01862971185296214c9862c55cbcd649a6~dwgvHCaLF2219522195euoutp01p
	for <netfilter-devel@vger.kernel.org>; Thu, 21 Aug 2025 10:39:45 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20250821103945euoutp01862971185296214c9862c55cbcd649a6~dwgvHCaLF2219522195euoutp01p
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1755772785;
	bh=UE71boRM2lnX0xQfNmkNZcNo+Tb+0u4hwPyFahJyJ8s=;
	h=From:To:Cc:Subject:Date:References:From;
	b=fonUlfqtSVYmWIipbPUM6x9sgBKBhrCabCbgVsTeADiQVMbEfVRNCHoS3ryVITs2H
	 o6ncWBcarTiyGObM+LAxIHRQwi6uYQhriBrTdKeoQdcpT4jBv+UG0D7ae8qshRKMUS
	 wuXYIC+GU+GFupZ5T05x1qXiYvo9RYoW03Mw/OZ4=
Received: from eusmtip1.samsung.com (unknown [203.254.199.221]) by
	eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
	20250821103945eucas1p211e02560c0125f4f0eddae86798b9a01~dwgu7jhl71793617936eucas1p2T;
	Thu, 21 Aug 2025 10:39:45 +0000 (GMT)
Received: from localhost (unknown [106.120.51.111]) by eusmtip1.samsung.com
	(KnoxPortal) with ESMTPA id
	20250821103945eusmtip1b680a13c1f7c8656faa1f50471be4b1d~dwgu3zRhc0310403104eusmtip1g;
	Thu, 21 Aug 2025 10:39:45 +0000 (GMT)
From: =?UTF-8?q?=C5=81ukasz=20Stelmach?= <l.stelmach@samsung.com>
To: netfilter-devel@vger.kernel.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
	=?UTF-8?q?=C5=81ukasz=20Stelmach?= <l.stelmach@samsung.com>
Subject: [iptables PATCH] extensions: man: Add a note about route_localnet
 sysctl
Date: Thu, 21 Aug 2025 12:39:18 +0200
Message-Id: <20250821103918.1855788-1-l.stelmach@samsung.com>
X-Mailer: git-send-email 2.39.5
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Samsung R&D Institute Poland
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20250821103945eucas1p211e02560c0125f4f0eddae86798b9a01
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20250821103945eucas1p211e02560c0125f4f0eddae86798b9a01
X-EPHeader: CA
X-CMS-RootMailID: 20250821103945eucas1p211e02560c0125f4f0eddae86798b9a01
References: <CGME20250821103945eucas1p211e02560c0125f4f0eddae86798b9a01@eucas1p2.samsung.com>

See ip_route_input_slow() in net/ipv4/route.c in the Linux
kernel sources.

Signed-off-by: Łukasz Stelmach <l.stelmach@samsung.com>
---
 extensions/libxt_DNAT.man | 4 ++++
 1 file changed, 4 insertions(+)

diff --git extensions/libxt_DNAT.man extensions/libxt_DNAT.man
index 090ecb42..cbfa5478 100644
--- extensions/libxt_DNAT.man
+++ extensions/libxt_DNAT.man
@@ -23,6 +23,10 @@ its value is used as offset into the mapping port range. This allows one to crea
 shifted portmap ranges and is available since kernel version 4.18.
 For a single port or \fIbaseport\fP, a service name as listed in
 \fB/etc/services\fP may be used.
+If \fIipaddr\fP is an IPv4 loopback address (i.e. 127.0.0.0/8) the
+"net.ipv4.conf.*.route_localnet" sysctl for the input interface needs
+to be set to 1. Otherwise packets will be dropped by the routing code
+as "martians".
 .TP
 \fB\-\-random\fP
 Randomize source port mapping (kernel >= 2.6.22).
-- 
2.39.5

