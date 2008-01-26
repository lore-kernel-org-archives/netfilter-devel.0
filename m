From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: [PATCH 07/10] [NETFILTER]: annotate nf_{conntrack,nat}_proto_udp{,lite}
 with const
Date: Sat, 26 Jan 2008 02:37:45 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0801260237420.15243@fbirervta.pbzchgretzou.qr>
References: <fd8d288fb2570e7feabc650d002d36a3070b43a1.1201311315.git.jengelh@computergmbh.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:48221 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754610AbYAZBhq (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 25 Jan 2008 20:37:46 -0500
In-Reply-To: <fd8d288fb2570e7feabc650d002d36a3070b43a1.1201311315.git.jengelh@computergmbh.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>
---
 net/ipv4/netfilter/nf_nat_proto_udp.c      |    2 +-
 net/netfilter/nf_conntrack_proto_udp.c     |    6 ++++--
 net/netfilter/nf_conntrack_proto_udplite.c |    6 ++++--
 3 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/net/ipv4/netfilter/nf_nat_proto_udp.c b/net/ipv4/netfilter/nf_nat_proto_udp.c
index 10df4db..4b8f499 100644
--- a/net/ipv4/netfilter/nf_nat_proto_udp.c
+++ b/net/ipv4/netfilter/nf_nat_proto_udp.c
@@ -91,7 +91,7 @@ udp_manip_pkt(struct sk_buff *skb,
 	      const struct nf_conntrack_tuple *tuple,
 	      enum nf_nat_manip_type maniptype)
 {
-	struct iphdr *iph = (struct iphdr *)(skb->data + iphdroff);
+	const struct iphdr *iph = (struct iphdr *)(skb->data + iphdroff);
 	struct udphdr *hdr;
 	unsigned int hdroff = iphdroff + iph->ihl*4;
 	__be32 oldip, newip;
diff --git a/net/netfilter/nf_conntrack_proto_udp.c b/net/netfilter/nf_conntrack_proto_udp.c
index 3848754..4a50da8 100644
--- a/net/netfilter/nf_conntrack_proto_udp.c
+++ b/net/netfilter/nf_conntrack_proto_udp.c
@@ -30,7 +30,8 @@ static int udp_pkt_to_tuple(const struct sk_buff *skb,
 			     unsigned int dataoff,
 			     struct nf_conntrack_tuple *tuple)
 {
-	struct udphdr _hdr, *hp;
+	const struct udphdr *hp;
+	struct udphdr _hdr;
 
 	/* Actually only need first 8 bytes. */
 	hp = skb_header_pointer(skb, dataoff, sizeof(_hdr), &_hdr);
@@ -95,7 +96,8 @@ static int udp_error(struct sk_buff *skb, unsigned int dataoff,
 		     unsigned int hooknum)
 {
 	unsigned int udplen = skb->len - dataoff;
-	struct udphdr _hdr, *hdr;
+	const struct udphdr *hdr;
+	struct udphdr _hdr;
 
 	/* Header is too small? */
 	hdr = skb_header_pointer(skb, dataoff, sizeof(_hdr), &_hdr);
diff --git a/net/netfilter/nf_conntrack_proto_udplite.c b/net/netfilter/nf_conntrack_proto_udplite.c
index 070056d..744af01 100644
--- a/net/netfilter/nf_conntrack_proto_udplite.c
+++ b/net/netfilter/nf_conntrack_proto_udplite.c
@@ -31,7 +31,8 @@ static int udplite_pkt_to_tuple(const struct sk_buff *skb,
 				unsigned int dataoff,
 				struct nf_conntrack_tuple *tuple)
 {
-	struct udphdr _hdr, *hp;
+	const struct udphdr *hp;
+	struct udphdr _hdr;
 
 	hp = skb_header_pointer(skb, dataoff, sizeof(_hdr), &_hdr);
 	if (hp == NULL)
@@ -95,7 +96,8 @@ static int udplite_error(struct sk_buff *skb, unsigned int dataoff,
 			 unsigned int hooknum)
 {
 	unsigned int udplen = skb->len - dataoff;
-	struct udphdr _hdr, *hdr;
+	const struct udphdr *hdr;
+	struct udphdr _hdr;
 	unsigned int cscov;
 
 	/* Header is too small? */
-- 
1.5.3.4

