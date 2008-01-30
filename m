From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 58/69]: nf_{conntrack,nat}_tftp: annotate TFTP helper with const
Date: Wed, 30 Jan 2008 21:18:23 +0100 (MET)
Message-ID: <20080130201820.29874.43788.sendpatchset@localhost.localdomain>
References: <20080130201650.29874.7456.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:60794 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760151AbYA3USY (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 30 Jan 2008 15:18:24 -0500
In-Reply-To: <20080130201650.29874.7456.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[NETFILTER]: nf_{conntrack,nat}_tftp: annotate TFTP helper with const

Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit c53f4c232b76b97fcdffeef43aae14f3d698f974
tree 42661b45662aba0ace2790184efea9d0c0e52473
parent 82c74083c7bc88bc8bd52e6a150a0812ce97f258
author Jan Engelhardt <jengelh@computergmbh.de> Wed, 30 Jan 2008 21:03:15 +0100
committer Patrick McHardy <kaber@trash.net> Wed, 30 Jan 2008 21:03:15 +0100

 net/ipv4/netfilter/nf_nat_tftp.c  |    2 +-
 net/netfilter/nf_conntrack_tftp.c |    3 ++-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/netfilter/nf_nat_tftp.c b/net/ipv4/netfilter/nf_nat_tftp.c
index 1360a94..b096e81 100644
--- a/net/ipv4/netfilter/nf_nat_tftp.c
+++ b/net/ipv4/netfilter/nf_nat_tftp.c
@@ -24,7 +24,7 @@ static unsigned int help(struct sk_buff *skb,
 			 enum ip_conntrack_info ctinfo,
 			 struct nf_conntrack_expect *exp)
 {
-	struct nf_conn *ct = exp->master;
+	const struct nf_conn *ct = exp->master;
 
 	exp->saved_proto.udp.port
 		= ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.u.udp.port;
diff --git a/net/netfilter/nf_conntrack_tftp.c b/net/netfilter/nf_conntrack_tftp.c
index 176f769..bd2e800 100644
--- a/net/netfilter/nf_conntrack_tftp.c
+++ b/net/netfilter/nf_conntrack_tftp.c
@@ -39,7 +39,8 @@ static int tftp_help(struct sk_buff *skb,
 		     struct nf_conn *ct,
 		     enum ip_conntrack_info ctinfo)
 {
-	struct tftphdr _tftph, *tfh;
+	const struct tftphdr *tfh;
+	struct tftphdr _tftph;
 	struct nf_conntrack_expect *exp;
 	struct nf_conntrack_tuple *tuple;
 	unsigned int ret = NF_ACCEPT;
