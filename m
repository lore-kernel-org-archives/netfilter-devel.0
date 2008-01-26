From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: [PATCH 08/10] [NETFILTER]: annotate nf_{conntrack,nat}_proto_gre
 with const
Date: Sat, 26 Jan 2008 02:37:51 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0801260237480.15243@fbirervta.pbzchgretzou.qr>
References: <fd8d288fb2570e7feabc650d002d36a3070b43a1.1201311315.git.jengelh@computergmbh.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:48225 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754813AbYAZBhx (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 25 Jan 2008 20:37:53 -0500
In-Reply-To: <fd8d288fb2570e7feabc650d002d36a3070b43a1.1201311315.git.jengelh@computergmbh.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>
---
 net/ipv4/netfilter/nf_nat_proto_gre.c  |    2 +-
 net/netfilter/nf_conntrack_proto_gre.c |    6 ++++--
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/net/ipv4/netfilter/nf_nat_proto_gre.c b/net/ipv4/netfilter/nf_nat_proto_gre.c
index 9fa272e..7d95990 100644
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
-- 
1.5.3.4

