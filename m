Received: from mx04.melco.co.jp (mx04.melco.co.jp [192.218.140.144])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E277D326951;
	Fri, 19 Dec 2025 12:05:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.218.140.144
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766145906; cv=none; b=JraXVgAwXA+jRQS+VeceGVBCNN9UJanMTjJzq5CES2ceWCT1WadBnGeNn4BZp+4UeBzUhwB2sfd/LdhCqMByTJW8+8EyT3vs7urm6zVeClplFZgIVSQPKNk3rB0ogwK7N2K8HaU53lovMtl5+Q97wQw2B2jjIH/ugJnWnKr2u1k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766145906; c=relaxed/simple;
	bh=Py/no0h4h9biLN0454Kyu9lnA1lRRcRx782AVK4YzPY=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=qD+y/izIOP0Ct1BNgDLsvS9yUgrle2o5mvmRqQRYu7FDNIE26rg5RsOVuq3B6zzLhVtkkvRw1s52uFM9k4DToRs8QjpMki5cK+wquA17FlPBR+VAKB8w73AjGHzRGxG6VPjU9gEMbCcu5cqCAVueVv7go22pGmkz4IJQTw93EOA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=da.MitsubishiElectric.co.jp; spf=pass smtp.mailfrom=da.MitsubishiElectric.co.jp; arc=none smtp.client-ip=192.218.140.144
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=da.MitsubishiElectric.co.jp
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=da.MitsubishiElectric.co.jp
Received: from mr06.melco.co.jp (mr06 [133.141.98.164])
	by mx04.melco.co.jp (Postfix) with ESMTP id 4dXmCP2ktdzMvNbL;
	Fri, 19 Dec 2025 20:53:53 +0900 (JST)
Received: from mf04.melco.co.jp (unknown [192.168.20.184])
	by mr06.melco.co.jp (Postfix) with ESMTP id 4dXmCP2gpxzMrL3y;
	Fri, 19 Dec 2025 20:53:53 +0900 (JST)
Received: from elgw.isl.melco.co.jp (unknown [133.141.13.130])
	by mf04.melco.co.jp (Postfix) with ESMTP id 4dXmCP2cV6zMt2LR;
	Fri, 19 Dec 2025 20:53:53 +0900 (JST)
Received: from eliswall.isl.melco.co.jp (eliswall.isl.melco.co.jp [10.74.245.38])
	by elgw.isl.melco.co.jp (Postfix) with ESMTP id 52A8D202EC0C;
	Fri, 19 Dec 2025 20:53:53 +0900 (JST)
Received: from elc1910004.ad.melco.co.jp (c1910004.isl.melco.co.jp [10.74.1.185])
	by eliswall.isl.melco.co.jp (Postfix) with ESMTP id 49967355;
	Fri, 19 Dec 2025 20:53:53 +0900 (JST)
From: Yuto Hamaguchi <Hamaguchi.Yuto@da.MitsubishiElectric.co.jp>
To: pablo@netfilter.org,
	kadlec@netfilter.org,
	netfilter-devel@vger.kernel.org
Cc: coreteam@netfilter.org,
	netdev@vger.kernel.org,
	Hamaguchi.Yuto@da.MitsubishiElectric.co.jp
Subject: [PATCH nf] netfilter: nf_conntrack: Add allow_clash to generic protocol handler
Date: Fri, 19 Dec 2025 20:53:51 +0900
Message-Id: <20251219115351.5662-1-Hamaguchi.Yuto@da.MitsubishiElectric.co.jp>
X-Mailer: git-send-email 2.36.1
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The upstream commit, 71d8c47fc653711c41bc3282e5b0e605b3727956
 ("netfilter: conntrack: introduce clash resolution on insertion race"),
sets allow_clash=true in the UDP/UDPLITE protocol handler
but does not set it in the generic protocol handler.

As a result, packets composed of connectionless protocols at each layer,
such as UDP over IP-in-IP, still drop packets due to conflicts during conntrack insertion.

To resolve this, this patch sets allow_clash in the nf_conntrack_l4proto_generic.

Signed-off-by: Yuto Hamaguchi <Hamaguchi.Yuto@da.MitsubishiElectric.co.jp>
---
 net/netfilter/nf_conntrack_proto_generic.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/netfilter/nf_conntrack_proto_generic.c b/net/netfilter/nf_conntrack_proto_generic.c
index e831637bc8ca..cb260eb3d012 100644
--- a/net/netfilter/nf_conntrack_proto_generic.c
+++ b/net/netfilter/nf_conntrack_proto_generic.c
@@ -67,6 +67,7 @@ void nf_conntrack_generic_init_net(struct net *net)
 const struct nf_conntrack_l4proto nf_conntrack_l4proto_generic =
 {
 	.l4proto		= 255,
+	.allow_clash            = true,
 #ifdef CONFIG_NF_CONNTRACK_TIMEOUT
 	.ctnl_timeout		= {
 		.nlattr_to_obj	= generic_timeout_nlattr_to_obj,
-- 
2.36.1

