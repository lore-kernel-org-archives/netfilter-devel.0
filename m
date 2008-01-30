From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 63/69]: nf_{conntrack,nat}_proto_gre: annotate with const
Date: Wed, 30 Jan 2008 21:18:30 +0100 (MET)
Message-ID: <20080130201828.29874.20771.sendpatchset@localhost.localdomain>
References: <20080130201650.29874.7456.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:60813 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765311AbYA3USb (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 30 Jan 2008 15:18:31 -0500
In-Reply-To: <20080130201650.29874.7456.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[NETFILTER]: nf_{conntrack,nat}_proto_gre: annotate with const

Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 0d18e97268fb631100b6b7689ac1b75426463d0c
tree ed5370f3ae3ceb58b0963ffc83f9b17f3fa8ff78
parent 605ba346a8a54fc3c2a6d846a345d4d6c3cd5642
author Jan Engelhardt <jengelh@computergmbh.de> Wed, 30 Jan 2008 21:03:17 +0100
committer Patrick McHardy <kaber@trash.net> Wed, 30 Jan 2008 21:03:17 +0100

 net/ipv4/netfilter/nf_nat_proto_gre.c  |    2 +-
 net/netfilter/nf_conntrack_proto_gre.c |    6 ++++--
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/net/ipv4/netfilter/nf_nat_proto_gre.c b/net/ipv4/netfilter/nf_nat_proto_gre.c
index b887ebb..a1e4da1 100644
--- a/net/ipv4/netfilter/nf_nat_proto_gre.c
+++ b/net/ipv4/netfilter/nf_nat_proto_gre.c
@@ -104,7 +104,7 @@ gre_manip_pkt(struct sk_buff *skb, unsigned int iphdroff,
 {
 	struct gre_hdr *greh;
 	struct gre_hdr_pptp *pgreh;
-	struct iphdr *iph = (struct iphdr *)(skb->data + iphdroff);
+	const struct iphdr *iph = (struct iphdr *)(skb->data + iphdroff);
 	unsigned int hdroff = iphdroff + iph->ihl * 4;
 
 	/* pgreh includes two optional 32bit fields which are not required
diff --git a/net/netfilter/nf_conntrack_proto_gre.c b/net/netfilter/nf_conntrack_proto_gre.c
index 4a185f6..e10024a 100644
--- a/net/netfilter/nf_conntrack_proto_gre.c
+++ b/net/netfilter/nf_conntrack_proto_gre.c
@@ -161,9 +161,11 @@ static int gre_pkt_to_tuple(const struct sk_buff *skb,
 			   unsigned int dataoff,
 			   struct nf_conntrack_tuple *tuple)
 {
-	struct gre_hdr_pptp _pgrehdr, *pgrehdr;
+	const struct gre_hdr_pptp *pgrehdr;
+	struct gre_hdr_pptp _pgrehdr;
 	__be16 srckey;
-	struct gre_hdr _grehdr, *grehdr;
+	const struct gre_hdr *grehdr;
+	struct gre_hdr _grehdr;
 
 	/* first only delinearize old RFC1701 GRE header */
 	grehdr = skb_header_pointer(skb, dataoff, sizeof(_grehdr), &_grehdr);
