From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 01/32]: ipt_CLUSTERIP: fix non-existant macro-name
Date: Thu, 28 Feb 2008 12:59:58 +0100 (MET)
Message-ID: <20080228115949.29267.34765.sendpatchset@localhost.localdomain>
References: <20080228115948.29267.34361.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:49963 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756869AbYB1L77 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 28 Feb 2008 06:59:59 -0500
In-Reply-To: <20080228115948.29267.34361.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[NETFILTER]: ipt_CLUSTERIP: fix non-existant macro-name

With nf_conntrack DUMP_TUPLE got renamed to NF_CT_DUMP_TUPLE, fix
CLUSTERIP to use the proper macro name.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 64c4eb535c3d06edb1ceb47edc5bfce36348a7c4
tree 05fc830a717f22f694cd10ee41406cb936e1325a
parent d9595a7b9c777d45a74774f1428c263a0a47f4c0
author Patrick McHardy <kaber@trash.net> Thu, 28 Feb 2008 12:08:03 +0100
committer Patrick McHardy <kaber@trash.net> Thu, 28 Feb 2008 12:08:03 +0100

 net/ipv4/netfilter/ipt_CLUSTERIP.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/ipv4/netfilter/ipt_CLUSTERIP.c b/net/ipv4/netfilter/ipt_CLUSTERIP.c
index c6cf84c..1b10f36 100644
--- a/net/ipv4/netfilter/ipt_CLUSTERIP.c
+++ b/net/ipv4/netfilter/ipt_CLUSTERIP.c
@@ -332,7 +332,7 @@ clusterip_tg(struct sk_buff *skb, const struct net_device *in,
 	}
 
 #ifdef DEBUG
-	DUMP_TUPLE(&ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple);
+	NF_CT_DUMP_TUPLE(&ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple);
 #endif
 	pr_debug("hash=%u ct_hash=%u ", hash, ct->mark);
 	if (!clusterip_responsible(cipinfo->config, hash)) {
