Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1E0F2BD587
	for <netfilter-devel@vger.kernel.org>; Wed, 13 Aug 2025 17:06:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755104764; cv=none; b=QYic5vgkgzIF0ivFClpGQ0REpvflZn+o8+YtWVwFvymZZsVt+7N/P2TttyL0mV2a5EzPMeqjJfgrF1L/3Il+vkAmzKTDt7CQuBrzVdfaKuPTTtIaiRoAob1uxIUI8VaxwJiHS/D+cDxBnManLh0RFnBK+sM3mH+UTSbiEVdiR3A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755104764; c=relaxed/simple;
	bh=xyQaCcgK/yJ1X0CJ0629Ffm0TDgPWt4vYY1f4dSydvE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lkwkn+HfXUnOYFyl2pJKsIOF9DpyMyYlLOpw9zUduTwWNckCVW6DyGHJtNBvsoFuCfcUNNaQ5nDQXHkkE6hcLWe6tY/Mv+EAwxmpEdfrspbCwzrSomf7PHdYdJ8W6djARSknGYnjAIvRmUa00oZVduCQ2Mst/AT/RV8Otn+xBtY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=CrTqA0+g; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="CrTqA0+g"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=ifNdeXEco26TosWQwXNl7TcEH8ceYwRGOP4UTUdfs1M=; b=CrTqA0+gaActdlbGmSYpy/thSQ
	sSwTpEAys+fahEPHj1iw/4g4+vHlhW/4wGNER8qG0fHWH0r447s0A2OC/plyAYXVpcUwLra9CxD0/
	1TtZrMZexwyhwnPu6cJWzX7Fd0MnwYewb4L8TDZXByeXkdkWtMSMdxE//7xmkJZP+wQGiqjaQ+mFJ
	n4PIJFggXbC9I8FCziH89Q+CAYTaehtR5vOkWMG4Nx+oCIYPFRDbC+iG0CveMbTbbZI0GZ9j+SM+c
	HuSbc9l3CGbOVCFJs6lbTEFMBSQqJydVTBLXUSKuDh8P+iqcHFO31asnWC0tpXzU3ShadD1bfrG/z
	eBbSk/tw==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1umEvJ-000000003oP-28UN;
	Wed, 13 Aug 2025 19:06:01 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: [nft PATCH 12/14] tests: py: Drop stale entry from ip/snat.t.payload
Date: Wed, 13 Aug 2025 19:05:47 +0200
Message-ID: <20250813170549.27880-13-phil@nwl.cc>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250813170549.27880-1-phil@nwl.cc>
References: <20250813170549.27880-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This payload actually belongs to ip/dnat.t.payload, fixed commit added
it to the wrong file.

Fixes: 8f3048954d40d ("evaluate: postpone transport protocol match check after nat expression evaluation")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 tests/py/ip/snat.t.payload | 14 --------------
 1 file changed, 14 deletions(-)

diff --git a/tests/py/ip/snat.t.payload b/tests/py/ip/snat.t.payload
index 7044d7b023bb7..ef45489959704 100644
--- a/tests/py/ip/snat.t.payload
+++ b/tests/py/ip/snat.t.payload
@@ -135,17 +135,3 @@ ip
   [ payload load 2b @ transport header + 2 => reg 9 ]
   [ lookup reg 1 set __map%d dreg 1 ]
   [ nat snat ip addr_min reg 1 proto_min reg 9 ]
-
-# ip daddr 192.168.0.1 dnat to tcp dport map { 443 : 10.141.10.4 . 8443, 80 : 10.141.10.4 . 8080 }
-__map%d x b size 2
-__map%d x 0
-        element 0000bb01  : 040a8d0a 0000fb20 0 [end]   element 00005000  : 040a8d0a 0000901f 0 [end]
-ip
-  [ payload load 4b @ network header + 16 => reg 1 ]
-  [ cmp eq reg 1 0x0100a8c0 ]
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ lookup reg 1 set __map%d dreg 1 ]
-  [ nat dnat ip addr_min reg 1 proto_min reg 9 ]
-
-- 
2.49.0

