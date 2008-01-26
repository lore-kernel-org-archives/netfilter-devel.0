From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: [PATCH 09/10] [NETFILTER]: constify and annotate nf_{conntrack,nat}_icmp
Date: Sat, 26 Jan 2008 02:37:58 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0801260237550.15243@fbirervta.pbzchgretzou.qr>
References: <fd8d288fb2570e7feabc650d002d36a3070b43a1.1201311315.git.jengelh@computergmbh.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:48228 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755274AbYAZBh7 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 25 Jan 2008 20:37:59 -0500
In-Reply-To: <fd8d288fb2570e7feabc650d002d36a3070b43a1.1201311315.git.jengelh@computergmbh.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Constify a few data tables use const qualifiers on variables where
possible in the nf_conntrack_icmp* sources.

Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>
---
 net/ipv4/netfilter/nf_conntrack_proto_icmp.c   |   10 ++++++----
 net/ipv4/netfilter/nf_nat_proto_icmp.c         |    2 +-
 net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c |   14 ++++++++------
 3 files changed, 15 insertions(+), 11 deletions(-)

diff --git a/net/ipv4/netfilter/nf_conntrack_proto_icmp.c b/net/ipv4/netfilter/nf_conntrack_proto_icmp.c
index 4004a04..6d2723b 100644
--- a/net/ipv4/netfilter/nf_conntrack_proto_icmp.c
+++ b/net/ipv4/netfilter/nf_conntrack_proto_icmp.c
@@ -26,7 +26,8 @@ static int icmp_pkt_to_tuple(const struct sk_buff *skb,
 			     unsigned int dataoff,
 			     struct nf_conntrack_tuple *tuple)
 {
-	struct icmphdr _hdr, *hp;
+	const struct icmphdr *hp;
+	struct icmphdr _hdr;
 
 	hp = skb_header_pointer(skb, dataoff, sizeof(_hdr), &_hdr);
 	if (hp == NULL)
@@ -129,8 +130,8 @@ icmp_error_message(struct sk_buff *skb,
 		 unsigned int hooknum)
 {
 	struct nf_conntrack_tuple innertuple, origtuple;
-	struct nf_conntrack_l4proto *innerproto;
-	struct nf_conntrack_tuple_hash *h;
+	const struct nf_conntrack_l4proto *innerproto;
+	const struct nf_conntrack_tuple_hash *h;
 
 	NF_CT_ASSERT(skb->nfct == NULL);
 
@@ -176,7 +177,8 @@ static int
 icmp_error(struct sk_buff *skb, unsigned int dataoff,
 	   enum ip_conntrack_info *ctinfo, int pf, unsigned int hooknum)
 {
-	struct icmphdr _ih, *icmph;
+	const struct icmphdr *icmph;
+	struct icmphdr _ih;
 
 	/* Not enough header? */
 	icmph = skb_header_pointer(skb, ip_hdrlen(skb), sizeof(_ih), &_ih);
diff --git a/net/ipv4/netfilter/nf_nat_proto_icmp.c b/net/ipv4/netfilter/nf_nat_proto_icmp.c
index a0e44c9..03a0296 100644
--- a/net/ipv4/netfilter/nf_nat_proto_icmp.c
+++ b/net/ipv4/netfilter/nf_nat_proto_icmp.c
@@ -57,7 +57,7 @@ icmp_manip_pkt(struct sk_buff *skb,
 	       const struct nf_conntrack_tuple *tuple,
 	       enum nf_nat_manip_type maniptype)
 {
-	struct iphdr *iph = (struct iphdr *)(skb->data + iphdroff);
+	const struct iphdr *iph = (struct iphdr *)(skb->data + iphdroff);
 	struct icmphdr *hdr;
 	unsigned int hdroff = iphdroff + iph->ihl*4;
 
diff --git a/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c b/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c
index da924c6..58fef1e 100644
--- a/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c
+++ b/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c
@@ -32,7 +32,8 @@ static int icmpv6_pkt_to_tuple(const struct sk_buff *skb,
 			       unsigned int dataoff,
 			       struct nf_conntrack_tuple *tuple)
 {
-	struct icmp6hdr _hdr, *hp;
+	const struct icmp6hdr *hp;
+	struct icmp6hdr _hdr;
 
 	hp = skb_header_pointer(skb, dataoff, sizeof(_hdr), &_hdr);
 	if (hp == NULL)
@@ -45,7 +46,7 @@ static int icmpv6_pkt_to_tuple(const struct sk_buff *skb,
 }
 
 /* Add 1; spaces filled with 0. */
-static u_int8_t invmap[] = {
+static const u_int8_t invmap[] = {
 	[ICMPV6_ECHO_REQUEST - 128]	= ICMPV6_ECHO_REPLY + 1,
 	[ICMPV6_ECHO_REPLY - 128]	= ICMPV6_ECHO_REQUEST + 1,
 	[ICMPV6_NI_QUERY - 128]		= ICMPV6_NI_QUERY + 1,
@@ -105,7 +106,7 @@ static int icmpv6_new(struct nf_conn *conntrack,
 		      const struct sk_buff *skb,
 		      unsigned int dataoff)
 {
-	static u_int8_t valid_new[] = {
+	static const u_int8_t valid_new[] = {
 		[ICMPV6_ECHO_REQUEST - 128] = 1,
 		[ICMPV6_NI_QUERY - 128] = 1
 	};
@@ -129,8 +130,8 @@ icmpv6_error_message(struct sk_buff *skb,
 		     unsigned int hooknum)
 {
 	struct nf_conntrack_tuple intuple, origtuple;
-	struct nf_conntrack_tuple_hash *h;
-	struct nf_conntrack_l4proto *inproto;
+	const struct nf_conntrack_tuple_hash *h;
+	const struct nf_conntrack_l4proto *inproto;
 
 	NF_CT_ASSERT(skb->nfct == NULL);
 
@@ -176,7 +177,8 @@ static int
 icmpv6_error(struct sk_buff *skb, unsigned int dataoff,
 	     enum ip_conntrack_info *ctinfo, int pf, unsigned int hooknum)
 {
-	struct icmp6hdr _ih, *icmp6h;
+	const struct icmp6hdr *icmp6h;
+	struct icmp6hdr _ih;
 
 	icmp6h = skb_header_pointer(skb, dataoff, sizeof(_ih), &_ih);
 	if (icmp6h == NULL) {
-- 
1.5.3.4

