From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 01/32]: ipt_CLUSTERIP: fix non-existant macro-name
Date: Tue, 25 Mar 2008 15:14:52 +0100 (MET)
Message-ID: <20080325141451.10539.13294.sendpatchset@localhost.localdomain>
References: <20080325141450.10539.58908.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:32888 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752090AbYCYOOx (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 25 Mar 2008 10:14:53 -0400
In-Reply-To: <20080325141450.10539.58908.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[NETFILTER]: ipt_CLUSTERIP: fix non-existant macro-name

With nf_conntrack DUMP_TUPLE got renamed to NF_CT_DUMP_TUPLE, fix
CLUSTERIP to use the proper macro name.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 9f6e380c98a01aa41754fa04ae5b11a11987a69a
tree 42c74ac2a2fe17df5cc61c734bb0462804d35c8c
parent 7cbca67c073263c179f605bdbbdc565ab29d801d
author Patrick McHardy <kaber@trash.net> Tue, 25 Mar 2008 13:44:35 +0100
committer Patrick McHardy <kaber@trash.net> Tue, 25 Mar 2008 13:44:35 +0100

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
