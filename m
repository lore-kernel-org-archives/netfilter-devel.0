From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER]: nf_nat: remove unused name from struct nf_nat_protocol
Date: Mon, 25 Feb 2008 16:29:32 +0100
Message-ID: <47C2DEDC.7040206@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------030904090703020001000906"
To: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from viefep20-int.chello.at ([62.179.121.40]:39827 "EHLO
	viefep20-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752503AbYBYP3h (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 25 Feb 2008 10:29:37 -0500
Received: from [192.168.0.100] (really [78.42.105.25])
          by viefep20-int.chello.at
          (InterMail vM.7.08.02.00 201-2186-121-20061213) with ESMTP
          id <20080225152934.ZPEM14023.viefep20-int.chello.at@[192.168.0.100]>
          for <netfilter-devel@vger.kernel.org>;
          Mon, 25 Feb 2008 16:29:34 +0100
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multi-part message in MIME format.
--------------030904090703020001000906
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit


--------------030904090703020001000906
Content-Type: text/x-patch;
 name="03.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="03.diff"

[NETFILTER]: nf_nat: remove unused name from struct nf_nat_protocol

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit a12512d2930b16ec0e66f7fceb698109d97aa857
tree d6fc51739bc1a1261d45e8960a3eba03ef98690c
parent bde9b6732e54a36d59a85dcf2fbcc29e202185fb
author Patrick McHardy <kaber@trash.net> Mon, 25 Feb 2008 14:20:29 +0100
committer Patrick McHardy <kaber@trash.net> Mon, 25 Feb 2008 14:20:29 +0100

 include/net/netfilter/nf_nat_protocol.h   |    3 ---
 net/ipv4/netfilter/nf_nat_proto_gre.c     |    1 -
 net/ipv4/netfilter/nf_nat_proto_icmp.c    |    1 -
 net/ipv4/netfilter/nf_nat_proto_tcp.c     |    1 -
 net/ipv4/netfilter/nf_nat_proto_udp.c     |    1 -
 net/ipv4/netfilter/nf_nat_proto_unknown.c |    1 -
 6 files changed, 0 insertions(+), 8 deletions(-)

diff --git a/include/net/netfilter/nf_nat_protocol.h b/include/net/netfilter/nf_nat_protocol.h
index fa06f6d..df3d9df 100644
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
index 87af63d..e5025d6 100644
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
index 03a0296..197f42d 100644
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
index f8c498f..0933f72 100644
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
index a182f5a..d0c930f 100644
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

--------------030904090703020001000906--
