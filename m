From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH] datatypes: rename some types for more consistency
Date: Mon, 14 Apr 2014 08:09:36 +0200
Message-ID: <1397455776-4041-1-git-send-email-kaber@trash.net>
Cc: fw@strlen.de, netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:57537 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750732AbaDNGJl (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 14 Apr 2014 02:09:41 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Add some more consistency by using _addr for all address types, _proto
for all protocol types and iface_ for all interface types.

Signed-off-by: Patrick McHardy <kaber@trash.net>
---
 src/datatype.c | 10 +++++-----
 src/meta.c     |  8 ++++----
 src/proto.c    |  4 ++--
 3 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/src/datatype.c b/src/datatype.c
index 331f235..55af227 100644
--- a/src/datatype.c
+++ b/src/datatype.c
@@ -216,7 +216,7 @@ static const struct symbol_table nfproto_tbl = {
 
 const struct datatype nfproto_type = {
 	.type		= TYPE_NFPROTO,
-	.name		= "nfproto",
+	.name		= "nf_proto",
 	.desc		= "netfilter protocol",
 	.size		= 1 * BITS_PER_BYTE,
 	.basetype	= &integer_type,
@@ -338,7 +338,7 @@ static struct error_record *lladdr_type_parse(const struct expr *sym,
 
 const struct datatype lladdr_type = {
 	.type		= TYPE_LLADDR,
-	.name		= "lladdr",
+	.name		= "ll_addr",
 	.desc		= "link layer address",
 	.byteorder	= BYTEORDER_HOST_ENDIAN,
 	.basetype	= &integer_type,
@@ -392,7 +392,7 @@ static struct error_record *ipaddr_type_parse(const struct expr *sym,
 
 const struct datatype ipaddr_type = {
 	.type		= TYPE_IPADDR,
-	.name		= "ipv4_address",
+	.name		= "ipv4_addr",
 	.desc		= "IPv4 address",
 	.byteorder	= BYTEORDER_BIG_ENDIAN,
 	.size		= 4 * BITS_PER_BYTE,
@@ -450,7 +450,7 @@ static struct error_record *ip6addr_type_parse(const struct expr *sym,
 
 const struct datatype ip6addr_type = {
 	.type		= TYPE_IP6ADDR,
-	.name		= "ipv6_address",
+	.name		= "ipv6_addr",
 	.desc		= "IPv6 address",
 	.byteorder	= BYTEORDER_BIG_ENDIAN,
 	.size		= 16 * BITS_PER_BYTE,
@@ -505,7 +505,7 @@ static struct error_record *inet_protocol_type_parse(const struct expr *sym,
 
 const struct datatype inet_protocol_type = {
 	.type		= TYPE_INET_PROTOCOL,
-	.name		= "inet_protocol",
+	.name		= "inet_proto",
 	.desc		= "Internet protocol",
 	.size		= BITS_PER_BYTE,
 	.basetype	= &integer_type,
diff --git a/src/meta.c b/src/meta.c
index ebc0c54..173040e 100644
--- a/src/meta.c
+++ b/src/meta.c
@@ -160,8 +160,8 @@ static struct error_record *ifindex_type_parse(const struct expr *sym,
 
 static const struct datatype ifindex_type = {
 	.type		= TYPE_IFINDEX,
-	.name		= "ifindex",
-	.desc		= "interface index",
+	.name		= "iface_index",
+	.desc		= "network interface index",
 	.byteorder	= BYTEORDER_HOST_ENDIAN,
 	.size		= 4 * BITS_PER_BYTE,
 	.basetype	= &integer_type,
@@ -185,8 +185,8 @@ static const struct symbol_table arphrd_tbl = {
 
 const struct datatype arphrd_type = {
 	.type		= TYPE_ARPHRD,
-	.name		= "arphrd",
-	.desc		= "hardware type",
+	.name		= "iface_type",
+	.desc		= "network interface type",
 	.byteorder	= BYTEORDER_HOST_ENDIAN,
 	.size		= 2 * BITS_PER_BYTE,
 	.basetype	= &integer_type,
diff --git a/src/proto.c b/src/proto.c
index 3e62f92..0a37a65 100644
--- a/src/proto.c
+++ b/src/proto.c
@@ -732,7 +732,7 @@ const struct proto_desc proto_vlan = {
 
 const struct datatype etheraddr_type = {
 	.type		= TYPE_ETHERADDR,
-	.name		= "etheraddr",
+	.name		= "ether_addr",
 	.desc		= "Ethernet address",
 	.byteorder	= BYTEORDER_HOST_ENDIAN,
 	.size		= ETH_ALEN * BITS_PER_BYTE,
@@ -769,7 +769,7 @@ static void ethertype_print(const struct expr *expr)
 
 const struct datatype ethertype_type = {
 	.type		= TYPE_ETHERTYPE,
-	.name		= "ethertype",
+	.name		= "ether_type",
 	.desc		= "Ethernet protocol",
 	.byteorder	= BYTEORDER_BIG_ENDIAN,
 	.size		= 2 * BITS_PER_BYTE,
-- 
1.9.0

