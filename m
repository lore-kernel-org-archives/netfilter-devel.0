From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 62/69]: nf_{conntrack,nat}_proto_udp{,lite}: annotate with const
Date: Wed, 30 Jan 2008 21:18:29 +0100 (MET)
Message-ID: <20080130201826.29874.53117.sendpatchset@localhost.localdomain>
References: <20080130201650.29874.7456.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:60801 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765314AbYA3USa (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 30 Jan 2008 15:18:30 -0500
In-Reply-To: <20080130201650.29874.7456.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[NETFILTER]: nf_{conntrack,nat}_proto_udp{,lite}: annotate with const

Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 605ba346a8a54fc3c2a6d846a345d4d6c3cd5642
tree 5009903decf0c6ad4c33f80beec18160e29d9282
parent 86b8346c2ce0407e1712aefc6e4f9bb5c24fd238
author Jan Engelhardt <jengelh@computergmbh.de> Wed, 30 Jan 2008 21:03:17 +0100
committer Patrick McHardy <kaber@trash.net> Wed, 30 Jan 2008 21:03:17 +0100

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
index 4c1e67e..b8a35cc 100644
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
@@ -94,7 +95,8 @@ static int udp_error(struct sk_buff *skb, unsigned int dataoff,
 		     unsigned int hooknum)
 {
 	unsigned int udplen = skb->len - dataoff;
-	struct udphdr _hdr, *hdr;
+	const struct udphdr *hdr;
+	struct udphdr _hdr;
 
 	/* Header is too small? */
 	hdr = skb_header_pointer(skb, dataoff, sizeof(_hdr), &_hdr);
diff --git a/net/netfilter/nf_conntrack_proto_udplite.c b/net/netfilter/nf_conntrack_proto_udplite.c
index d9e1532..9dd03c7 100644
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
@@ -94,7 +95,8 @@ static int udplite_error(struct sk_buff *skb, unsigned int dataoff,
 			 unsigned int hooknum)
 {
 	unsigned int udplen = skb->len - dataoff;
-	struct udphdr _hdr, *hdr;
+	const struct udphdr *hdr;
+	struct udphdr _hdr;
 	unsigned int cscov;
 
 	/* Header is too small? */
