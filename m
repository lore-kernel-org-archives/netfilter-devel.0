From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: [PATCH 03/10] [NETFILTER]: annotate nf_{conntrack,nat}_tftp with
 const
Date: Sat, 26 Jan 2008 02:37:13 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0801260237070.15243@fbirervta.pbzchgretzou.qr>
References: <fd8d288fb2570e7feabc650d002d36a3070b43a1.1201311315.git.jengelh@computergmbh.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:48214 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752996AbYAZBhO (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 25 Jan 2008 20:37:14 -0500
In-Reply-To: <fd8d288fb2570e7feabc650d002d36a3070b43a1.1201311315.git.jengelh@computergmbh.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>
---
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
index e894aa1..64e3726 100644
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
-- 
1.5.3.4

