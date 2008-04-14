From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 21/41]: nf_nat: remove unused name from struct nf_nat_protocol
Date: Mon, 14 Apr 2008 12:16:47 +0200 (MEST)
Message-ID: <20080414101643.32717.69530.sendpatchset@localhost.localdomain>
References: <20080414101614.32717.35526.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:36296 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752039AbYDNKQs (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 14 Apr 2008 06:16:48 -0400
In-Reply-To: <20080414101614.32717.35526.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[NETFILTER]: nf_nat: remove unused name from struct nf_nat_protocol

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 0caae257342d590b5dbe846fdb4519286f94bd78
tree 6e4352b90a3d01c00dd98e45e7353da16fb2fa6c
parent 6bc4343f9bea8ef5d8229a98e18f928064fa3f15
author Patrick McHardy <kaber@trash.net> Thu, 20 Mar 2008 15:15:49 +0100
committer Patrick McHardy <kaber@trash.net> Mon, 14 Apr 2008 12:10:51 +0200

 include/net/netfilter/nf_nat_protocol.h   |    3 ---
 net/ipv4/netfilter/nf_nat_proto_gre.c     |    1 -
 net/ipv4/netfilter/nf_nat_proto_icmp.c    |    1 -
 net/ipv4/netfilter/nf_nat_proto_tcp.c     |    1 -
 net/ipv4/netfilter/nf_nat_proto_udp.c     |    1 -
 net/ipv4/netfilter/nf_nat_proto_unknown.c |    1 -
 6 files changed, 0 insertions(+), 8 deletions(-)

diff --git a/include/net/netfilter/nf_nat_protocol.h b/include/net/netfilter/nf_nat_protocol.h
index 8ce2276..fba94a2 100644
--- a/include/net/netfilter/nf_nat_protocol.h
+++ b/include/net/netfilter/nf_nat_protocol.h
@@ -8,9 +8,6 @@ struct nf_nat_range;
 
 struct nf_nat_protocol
 {
-	/* Protocol name */
-	const char *name;
-
 	/* Protocol number. */
 	unsigned int protonum;
 
diff --git a/net/ipv4/netfilter/nf_nat_proto_gre.c b/net/ipv4/netfilter/nf_nat_proto_gre.c
index 71b0935..84bb785 100644
--- a/net/ipv4/netfilter/nf_nat_proto_gre.c
+++ b/net/ipv4/netfilter/nf_nat_proto_gre.c
@@ -118,7 +118,6 @@ gre_manip_pkt(struct sk_buff *skb, unsigned int iphdroff,
 }
 
 static const struct nf_nat_protocol gre = {
-	.name			= "GRE",
 	.protonum		= IPPROTO_GRE,
 	.me			= THIS_MODULE,
 	.manip_pkt		= gre_manip_pkt,
diff --git a/net/ipv4/netfilter/nf_nat_proto_icmp.c b/net/ipv4/netfilter/nf_nat_proto_icmp.c
index ca601f8..ab3a0ec 100644
--- a/net/ipv4/netfilter/nf_nat_proto_icmp.c
+++ b/net/ipv4/netfilter/nf_nat_proto_icmp.c
@@ -72,7 +72,6 @@ icmp_manip_pkt(struct sk_buff *skb,
 }
 
 const struct nf_nat_protocol nf_nat_protocol_icmp = {
-	.name			= "ICMP",
 	.protonum		= IPPROTO_ICMP,
 	.me			= THIS_MODULE,
 	.manip_pkt		= icmp_manip_pkt,
diff --git a/net/ipv4/netfilter/nf_nat_proto_tcp.c b/net/ipv4/netfilter/nf_nat_proto_tcp.c
index 1d73a11..5d4c8a0 100644
--- a/net/ipv4/netfilter/nf_nat_proto_tcp.c
+++ b/net/ipv4/netfilter/nf_nat_proto_tcp.c
@@ -81,7 +81,6 @@ tcp_manip_pkt(struct sk_buff *skb,
 }
 
 const struct nf_nat_protocol nf_nat_protocol_tcp = {
-	.name			= "TCP",
 	.protonum		= IPPROTO_TCP,
 	.me			= THIS_MODULE,
 	.manip_pkt		= tcp_manip_pkt,
diff --git a/net/ipv4/netfilter/nf_nat_proto_udp.c b/net/ipv4/netfilter/nf_nat_proto_udp.c
index f36ce55..74a7e7b 100644
--- a/net/ipv4/netfilter/nf_nat_proto_udp.c
+++ b/net/ipv4/netfilter/nf_nat_proto_udp.c
@@ -72,7 +72,6 @@ udp_manip_pkt(struct sk_buff *skb,
 }
 
 const struct nf_nat_protocol nf_nat_protocol_udp = {
-	.name			= "UDP",
 	.protonum		= IPPROTO_UDP,
 	.me			= THIS_MODULE,
 	.manip_pkt		= udp_manip_pkt,
diff --git a/net/ipv4/netfilter/nf_nat_proto_unknown.c b/net/ipv4/netfilter/nf_nat_proto_unknown.c
index a26efeb..cda21ff 100644
--- a/net/ipv4/netfilter/nf_nat_proto_unknown.c
+++ b/net/ipv4/netfilter/nf_nat_proto_unknown.c
@@ -46,7 +46,6 @@ unknown_manip_pkt(struct sk_buff *skb,
 }
 
 const struct nf_nat_protocol nf_nat_unknown_protocol = {
-	.name			= "unknown",
 	/* .me isn't set: getting a ref to this cannot fail. */
 	.manip_pkt		= unknown_manip_pkt,
 	.in_range		= unknown_in_range,
