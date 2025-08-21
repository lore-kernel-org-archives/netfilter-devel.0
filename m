Received: from mailout1.w1.samsung.com (mailout1.w1.samsung.com [210.118.77.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5513238DF9
	for <netfilter-devel@vger.kernel.org>; Thu, 21 Aug 2025 10:39:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.118.77.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755772747; cv=none; b=d9VfYF1+moV+4NQI3gu3Erywwz3Tm8zuF5f4QBgvrve8dONPZywAcqVsBWNRpJ9mj48MAwspWiPGE4x2ngAvw0w0ftKhf9XPQ6SHI5RKGRKF2xbIWx8tGIXTMvMyEV8yySmaMm7j0gtCvethZozN0Iy4we7ja3CacunKz3m+F0w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755772747; c=relaxed/simple;
	bh=IlCt+2APS48OVCupZyZi7DCIpJ504p3Js2U6Xa3ExT8=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type:
	 References; b=Bjs6HrMd+uD2eS7hWDjwsPqgCR6myqUsA+vem9s7Or8CRfgw2wgeedwfxr0JeqJobWRk6v+IHr65V+rvvb79KsTsPBJ96t4WSvLWImErac74wcyxFKKid/1KLhJtutvBhY3ZkWY/LNBvlQJDcSG6FG0PguVBeKRZxOCBF09qssg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=u+zx6edH; arc=none smtp.client-ip=210.118.77.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="u+zx6edH"
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
	by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20250821103903euoutp01c0512fc480f1217dec3c9a9bb393a09b~dwgHzH2YC2219922199euoutp01p
	for <netfilter-devel@vger.kernel.org>; Thu, 21 Aug 2025 10:39:03 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20250821103903euoutp01c0512fc480f1217dec3c9a9bb393a09b~dwgHzH2YC2219922199euoutp01p
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1755772743;
	bh=TL1Ubzl6Uo1tLyjhzcVbyfrtpJUsGfGy2n96jJ2JWgI=;
	h=From:To:Cc:Subject:Date:References:From;
	b=u+zx6edHKAdb5kv6jxSuCLiQBeq7u/9ZlC7at1Gb3Lq/wbj996Yp7O7YvBsOMJFsu
	 FEeh0WqWJFJAz4RRscjw4reENI+yYrVrWZ3yuPEqgbGRL607LeIMAYBjJX+JKvAcwQ
	 7EgBahRx4eZBuLzNfqkoV9B33ew0ihnZ1qxnwDlE=
Received: from eusmtip2.samsung.com (unknown [203.254.199.222]) by
	eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
	20250821103902eucas1p106756dd599b2e77f0fdd468d694e94f0~dwgHOrgSi2741727417eucas1p1d;
	Thu, 21 Aug 2025 10:39:02 +0000 (GMT)
Received: from localhost (unknown [106.120.51.111]) by eusmtip2.samsung.com
	(KnoxPortal) with ESMTPA id
	20250821103902eusmtip21858b31b1704bd50ce04f525b27b2541~dwgHLIe8O2736627366eusmtip2n;
	Thu, 21 Aug 2025 10:39:02 +0000 (GMT)
From: =?UTF-8?q?=C5=81ukasz=20Stelmach?= <l.stelmach@samsung.com>
To: netfilter-devel@vger.kernel.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
	=?UTF-8?q?=C5=81ukasz=20Stelmach?= <l.stelmach@samsung.com>
Subject: [PATCH] doc: Add a note about route_localnet sysctl
Date: Thu, 21 Aug 2025 12:38:40 +0200
Message-Id: <20250821103840.1855618-1-l.stelmach@samsung.com>
X-Mailer: git-send-email 2.39.5
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Samsung R&D Institute Poland
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20250821103902eucas1p106756dd599b2e77f0fdd468d694e94f0
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20250821103902eucas1p106756dd599b2e77f0fdd468d694e94f0
X-EPHeader: CA
X-CMS-RootMailID: 20250821103902eucas1p106756dd599b2e77f0fdd468d694e94f0
References: <CGME20250821103902eucas1p106756dd599b2e77f0fdd468d694e94f0@eucas1p1.samsung.com>

See ip_route_input_slow() in net/ipv4/route.c in the Linux
kernel sources.

Signed-off-by: Łukasz Stelmach <l.stelmach@samsung.com>
---
 doc/statements.txt | 5 +++++
 1 file changed, 5 insertions(+)

diff --git doc/statements.txt doc/statements.txt
index 4aeb0a73..6226713b 100644
--- doc/statements.txt
+++ doc/statements.txt
@@ -459,6 +459,11 @@ netfilter and therefore no reverse translation will take place.
 The optional *prefix* keyword allows to map *n* source addresses to *n*
 destination addresses.  See 'Advanced NAT examples' below.
 
+If the 'address' for *dnat* is an IPv4 loopback address
+(i.e. 127.0.0.0/8) the "net.ipv4.conf.*.route_localnet" sysctl for the
+input interface needs to be set to 1. Otherwise packets will be
+dropped by the routing code as "martians".
+
 .NAT statement values
 [options="header"]
 |==================
-- 
2.39.5

