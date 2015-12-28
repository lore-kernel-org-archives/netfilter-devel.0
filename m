From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 2/3 nft] parser: restrict relational rhs expression recursion
Date: Mon, 28 Dec 2015 12:52:53 +0100
Message-ID: <1451303574-14510-2-git-send-email-pablo@netfilter.org>
References: <1451303574-14510-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:54849 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751413AbbL1LxM (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 28 Dec 2015 06:53:12 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 5B3C61324C3
	for <netfilter-devel@vger.kernel.org>; Mon, 28 Dec 2015 12:53:08 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 4A706DA795
	for <netfilter-devel@vger.kernel.org>; Mon, 28 Dec 2015 12:53:08 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 0D63CDA803
	for <netfilter-devel@vger.kernel.org>; Mon, 28 Dec 2015 12:53:06 +0100 (CET)
In-Reply-To: <1451303574-14510-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The relational expression allows recursion from both sides, this doesn't
allow us to know what hand side the input is coming from. This patch
adds a new expr_rhs rule that specifies what can be found on the
constant side of the relational.

Besides making it easier to understand what is actually supported, this
allows us to use reserve words both as constant and statements. This is
used by the following patch to allow to use redirect as constant from
the icmp payload match.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/parser_bison.y | 267 +++++++++++++++++++++++++++++++----------------------
 1 file changed, 159 insertions(+), 108 deletions(-)

diff --git a/src/parser_bison.y b/src/parser_bison.y
index fbfe7ea..be1c740 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -508,6 +508,11 @@ static void location_update(struct location *loc, struct location *rhs, int n)
 %type <expr>			expr initializer_expr
 %destructor { expr_free($$); }	expr initializer_expr
 
+%type <expr>			rhs_expr concat_rhs_expr basic_rhs_expr
+%destructor { expr_free($$); }	rhs_expr concat_rhs_expr basic_rhs_expr
+%type <expr>			primary_rhs_expr list_rhs_expr
+%destructor { expr_free($$); }	primary_rhs_expr list_rhs_expr
+
 %type <expr>			relational_expr
 %destructor { expr_free($$); }	relational_expr
 %type <val>			relational_op
@@ -1825,13 +1830,13 @@ list_expr		:	basic_expr		COMMA		basic_expr
 			}
 			;
 
-prefix_expr		:	basic_expr		SLASH	NUM
+prefix_expr		:	basic_rhs_expr		SLASH	NUM
 			{
 				$$ = prefix_expr_alloc(&@$, $1, $3);
 			}
 			;
 
-range_expr		:	basic_expr		DASH	basic_expr
+range_expr		:	basic_rhs_expr		DASH	basic_rhs_expr
 			{
 				$$ = range_expr_alloc(&@$, $1, $3);
 			}
@@ -1853,7 +1858,7 @@ multiton_expr		:	prefix_expr
 			|	wildcard_expr
 			;
 
-map_expr		:	concat_expr	MAP	expr
+map_expr		:	concat_expr	MAP	rhs_expr
 			{
 				$$ = map_expr_alloc(&@$, $1, $3);
 			}
@@ -1926,11 +1931,11 @@ set_elem_option		:	TIMEOUT			time_spec
 			}
 			;
 
-set_lhs_expr		:	concat_expr
+set_lhs_expr		:	concat_rhs_expr
 			|	multiton_expr
 			;
 
-set_rhs_expr		:	concat_expr
+set_rhs_expr		:	concat_rhs_expr
 			|	verdict_expr
 			;
 
@@ -1938,20 +1943,166 @@ initializer_expr	:	expr
 			|	list_expr
 			;
 
-relational_expr		:	expr	/* implicit */	expr
+relational_expr		:	expr	/* implicit */	rhs_expr
 			{
 				$$ = relational_expr_alloc(&@$, OP_IMPLICIT, $1, $2);
 			}
-			|	expr	/* implicit */	list_expr
+			|	expr	/* implicit */	list_rhs_expr
 			{
 				$$ = relational_expr_alloc(&@$, OP_FLAGCMP, $1, $2);
 			}
-			|	expr	relational_op	expr
+			|	expr	relational_op	rhs_expr
 			{
 				$$ = relational_expr_alloc(&@2, $2, $1, $3);
 			}
 			;
 
+list_rhs_expr		:	basic_rhs_expr		COMMA		basic_rhs_expr
+			{
+				$$ = list_expr_alloc(&@$);
+				compound_expr_add($$, $1);
+				compound_expr_add($$, $3);
+			}
+			|	list_rhs_expr		COMMA		basic_rhs_expr
+			{
+				$1->location = @$;
+				compound_expr_add($1, $3);
+				$$ = $1;
+			}
+			;
+
+rhs_expr		:	concat_rhs_expr		{ $$ = $1; }
+			|	multiton_expr		{ $$ = $1; }
+			|	set_expr		{ $$ = $1; }
+			;
+
+concat_rhs_expr		:	basic_rhs_expr		{ $$ = $1; }
+			|	concat_rhs_expr	DOT	basic_rhs_expr
+			{
+				if ($$->ops->type != EXPR_CONCAT) {
+					$$ = concat_expr_alloc(&@$);
+					compound_expr_add($$, $1);
+				} else {
+					struct location rhs[] = {
+						[1]	= @2,
+						[2]	= @3,
+					};
+					location_update(&$3->location, rhs, 2);
+
+					$$ = $1;
+					$$->location = @$;
+				}
+				compound_expr_add($$, $3);
+			}
+			;
+
+basic_rhs_expr		:	primary_rhs_expr	{ $$ = $1; }
+			;
+
+primary_rhs_expr	:	symbol_expr		{ $$ = $1; }
+			|	integer_expr		{ $$ = $1; }
+			|	ETHER
+			{
+				$$ = symbol_expr_alloc(&@$, SYMBOL_VALUE,
+						       current_scope(state),
+						       "ether");
+			}
+			|	IP
+			{
+				$$ = symbol_expr_alloc(&@$, SYMBOL_VALUE,
+						       current_scope(state),
+						       "ip");
+			}
+			|	IP6
+			{
+				$$ = symbol_expr_alloc(&@$, SYMBOL_VALUE,
+						       current_scope(state),
+						       "ip6");
+			}
+			|	VLAN
+			{
+				$$ = symbol_expr_alloc(&@$, SYMBOL_VALUE,
+						       current_scope(state),
+						       "vlan");
+			}
+			|	ARP
+			{
+				$$ = symbol_expr_alloc(&@$, SYMBOL_VALUE,
+						       current_scope(state),
+						       "arp");
+			}
+			|	TCP
+			{
+				uint8_t data = IPPROTO_TCP;
+				$$ = constant_expr_alloc(&@$, &inet_protocol_type,
+							 BYTEORDER_HOST_ENDIAN,
+							 sizeof(data) * BITS_PER_BYTE, &data);
+			}
+			|	UDP
+			{
+				uint8_t data = IPPROTO_UDP;
+				$$ = constant_expr_alloc(&@$, &inet_protocol_type,
+							 BYTEORDER_HOST_ENDIAN,
+							 sizeof(data) * BITS_PER_BYTE, &data);
+			}
+			|	UDPLITE
+			{
+				uint8_t data = IPPROTO_UDPLITE;
+				$$ = constant_expr_alloc(&@$, &inet_protocol_type,
+							 BYTEORDER_HOST_ENDIAN,
+							 sizeof(data) * BITS_PER_BYTE, &data);
+			}
+			|	ESP
+			{
+				uint8_t data = IPPROTO_ESP;
+				$$ = constant_expr_alloc(&@$, &inet_protocol_type,
+							 BYTEORDER_HOST_ENDIAN,
+							 sizeof(data) * BITS_PER_BYTE, &data);
+			}
+			|	AH
+			{
+				uint8_t data = IPPROTO_AH;
+				$$ = constant_expr_alloc(&@$, &inet_protocol_type,
+							 BYTEORDER_HOST_ENDIAN,
+							 sizeof(data) * BITS_PER_BYTE, &data);
+			}
+			|	ICMP
+			{
+				uint8_t data = IPPROTO_ICMP;
+				$$ = constant_expr_alloc(&@$, &inet_protocol_type,
+							 BYTEORDER_HOST_ENDIAN,
+							 sizeof(data) * BITS_PER_BYTE, &data);
+			}
+			|	ICMP6
+			{
+				uint8_t data = IPPROTO_ICMPV6;
+				$$ = constant_expr_alloc(&@$, &inet_protocol_type,
+							 BYTEORDER_HOST_ENDIAN,
+							 sizeof(data) * BITS_PER_BYTE, &data);
+			}
+			|	COMP
+			{
+				uint8_t data = IPPROTO_COMP;
+				$$ = constant_expr_alloc(&@$, &inet_protocol_type,
+							 BYTEORDER_HOST_ENDIAN,
+							 sizeof(data) * BITS_PER_BYTE, &data);
+			}
+			|	DCCP
+			{
+				uint8_t data = IPPROTO_DCCP;
+				$$ = constant_expr_alloc(&@$, &inet_protocol_type,
+							 BYTEORDER_HOST_ENDIAN,
+							 sizeof(data) * BITS_PER_BYTE, &data);
+			}
+			|	SCTP
+			{
+				uint8_t data = IPPROTO_SCTP;
+				$$ = constant_expr_alloc(&@$, &inet_protocol_type,
+							 BYTEORDER_HOST_ENDIAN,
+							 sizeof(data) * BITS_PER_BYTE, &data);
+			}
+			;
+
 relational_op		:	EQ		{ $$ = OP_EQ; }
 			|	NEQ		{ $$ = OP_NEQ; }
 			|	LT		{ $$ = OP_LT; }
@@ -2107,12 +2258,6 @@ eth_hdr_expr		:	ETHER	eth_hdr_field
 			{
 				$$ = payload_expr_alloc(&@$, &proto_eth, $2);
 			}
-			|	ETHER
-			{
-				$$ = symbol_expr_alloc(&@$, SYMBOL_VALUE,
-						       current_scope(state),
-						       "ether");
-			}
 			;
 
 eth_hdr_field		:	SADDR		{ $$ = ETHHDR_SADDR; }
@@ -2124,12 +2269,6 @@ vlan_hdr_expr		:	VLAN	vlan_hdr_field
 			{
 				$$ = payload_expr_alloc(&@$, &proto_vlan, $2);
 			}
-			|	VLAN
-			{
-				$$ = symbol_expr_alloc(&@$, SYMBOL_VALUE,
-						       current_scope(state),
-						       "vlan");
-			}
 			;
 
 vlan_hdr_field		:	ID		{ $$ = VLANHDR_VID; }
@@ -2142,12 +2281,6 @@ arp_hdr_expr		:	ARP	arp_hdr_field
 			{
 				$$ = payload_expr_alloc(&@$, &proto_arp, $2);
 			}
-			|	ARP
-			{
-				$$ = symbol_expr_alloc(&@$, SYMBOL_VALUE,
-						       current_scope(state),
-						       "arp");
-			}
 			;
 
 arp_hdr_field		:	HTYPE		{ $$ = ARPHDR_HRD; }
@@ -2161,12 +2294,6 @@ ip_hdr_expr		:	IP	ip_hdr_field
 			{
 				$$ = payload_expr_alloc(&@$, &proto_ip, $2);
 			}
-			|	IP
-			{
-				$$ = symbol_expr_alloc(&@$, SYMBOL_VALUE,
-						       current_scope(state),
-						       "ip");
-			}
 			;
 
 ip_hdr_field		:	HDRVERSION	{ $$ = IPHDR_VERSION; }
@@ -2186,13 +2313,6 @@ icmp_hdr_expr		:	ICMP	icmp_hdr_field
 			{
 				$$ = payload_expr_alloc(&@$, &proto_icmp, $2);
 			}
-			|	ICMP
-			{
-				uint8_t data = IPPROTO_ICMP;
-				$$ = constant_expr_alloc(&@$, &inet_protocol_type,
-							 BYTEORDER_HOST_ENDIAN,
-							 sizeof(data) * BITS_PER_BYTE, &data);
-			}
 			;
 
 icmp_hdr_field		:	TYPE		{ $$ = ICMPHDR_TYPE; }
@@ -2208,12 +2328,6 @@ ip6_hdr_expr		:	IP6	ip6_hdr_field
 			{
 				$$ = payload_expr_alloc(&@$, &proto_ip6, $2);
 			}
-			|	IP6
-			{
-				$$ = symbol_expr_alloc(&@$, SYMBOL_VALUE,
-						       current_scope(state),
-						       "ip6");
-			}
 			;
 
 ip6_hdr_field		:	HDRVERSION	{ $$ = IP6HDR_VERSION; }
@@ -2229,13 +2343,6 @@ icmp6_hdr_expr		:	ICMP6	icmp6_hdr_field
 			{
 				$$ = payload_expr_alloc(&@$, &proto_icmp6, $2);
 			}
-			|	ICMP6
-			{
-				uint8_t data = IPPROTO_ICMPV6;
-				$$ = constant_expr_alloc(&@$, &inet_protocol_type,
-							 BYTEORDER_HOST_ENDIAN,
-							 sizeof(data) * BITS_PER_BYTE, &data);
-			}
 			;
 
 icmp6_hdr_field		:	TYPE		{ $$ = ICMP6HDR_TYPE; }
@@ -2252,13 +2359,6 @@ auth_hdr_expr		:	AH	auth_hdr_field
 			{
 				$$ = payload_expr_alloc(&@$, &proto_ah, $2);
 			}
-			|	AH
-			{
-				uint8_t data = IPPROTO_AH;
-				$$ = constant_expr_alloc(&@$, &inet_protocol_type,
-							 BYTEORDER_HOST_ENDIAN,
-							 sizeof(data) * BITS_PER_BYTE, &data);
-			}
 			;
 
 auth_hdr_field		:	NEXTHDR		{ $$ = AHHDR_NEXTHDR; }
@@ -2272,13 +2372,6 @@ esp_hdr_expr		:	ESP	esp_hdr_field
 			{
 				$$ = payload_expr_alloc(&@$, &proto_esp, $2);
 			}
-			|	ESP
-			{
-				uint8_t data = IPPROTO_ESP;
-				$$ = constant_expr_alloc(&@$, &inet_protocol_type,
-							 BYTEORDER_HOST_ENDIAN,
-							 sizeof(data) * BITS_PER_BYTE, &data);
-			}
 			;
 
 esp_hdr_field		:	SPI		{ $$ = ESPHDR_SPI; }
@@ -2289,13 +2382,6 @@ comp_hdr_expr		:	COMP	comp_hdr_field
 			{
 				$$ = payload_expr_alloc(&@$, &proto_comp, $2);
 			}
-			|	COMP
-			{
-				uint8_t data = IPPROTO_COMP;
-				$$ = constant_expr_alloc(&@$, &inet_protocol_type,
-							 BYTEORDER_HOST_ENDIAN,
-							 sizeof(data) * BITS_PER_BYTE, &data);
-			}
 			;
 
 comp_hdr_field		:	NEXTHDR		{ $$ = COMPHDR_NEXTHDR; }
@@ -2307,13 +2393,6 @@ udp_hdr_expr		:	UDP	udp_hdr_field
 			{
 				$$ = payload_expr_alloc(&@$, &proto_udp, $2);
 			}
-			|	UDP
-			{
-				uint8_t data = IPPROTO_UDP;
-				$$ = constant_expr_alloc(&@$, &inet_protocol_type,
-							 BYTEORDER_HOST_ENDIAN,
-							 sizeof(data) * BITS_PER_BYTE, &data);
-			}
 			;
 
 udp_hdr_field		:	SPORT		{ $$ = UDPHDR_SPORT; }
@@ -2326,13 +2405,6 @@ udplite_hdr_expr	:	UDPLITE	udplite_hdr_field
 			{
 				$$ = payload_expr_alloc(&@$, &proto_udplite, $2);
 			}
-			|	UDPLITE
-			{
-				uint8_t data = IPPROTO_UDPLITE;
-				$$ = constant_expr_alloc(&@$, &inet_protocol_type,
-							 BYTEORDER_HOST_ENDIAN,
-							 sizeof(data) * BITS_PER_BYTE, &data);
-			}
 			;
 
 udplite_hdr_field	:	SPORT		{ $$ = UDPHDR_SPORT; }
@@ -2345,13 +2417,6 @@ tcp_hdr_expr		:	TCP	tcp_hdr_field
 			{
 				$$ = payload_expr_alloc(&@$, &proto_tcp, $2);
 			}
-			|	TCP
-			{
-				uint8_t data = IPPROTO_TCP;
-				$$ = constant_expr_alloc(&@$, &inet_protocol_type,
-							 BYTEORDER_HOST_ENDIAN,
-							 sizeof(data) * BITS_PER_BYTE, &data);
-			}
 			;
 
 tcp_hdr_field		:	SPORT		{ $$ = TCPHDR_SPORT; }
@@ -2370,13 +2435,6 @@ dccp_hdr_expr		:	DCCP	dccp_hdr_field
 			{
 				$$ = payload_expr_alloc(&@$, &proto_dccp, $2);
 			}
-			|	DCCP
-			{
-				uint8_t data = IPPROTO_DCCP;
-				$$ = constant_expr_alloc(&@$, &inet_protocol_type,
-							 BYTEORDER_HOST_ENDIAN,
-							 sizeof(data) * BITS_PER_BYTE, &data);
-			}
 			;
 
 dccp_hdr_field		:	SPORT		{ $$ = DCCPHDR_SPORT; }
@@ -2388,13 +2446,6 @@ sctp_hdr_expr		:	SCTP	sctp_hdr_field
 			{
 				$$ = payload_expr_alloc(&@$, &proto_sctp, $2);
 			}
-			|	SCTP
-			{
-				uint8_t data = IPPROTO_SCTP;
-				$$ = constant_expr_alloc(&@$, &inet_protocol_type,
-							 BYTEORDER_HOST_ENDIAN,
-							 sizeof(data) * BITS_PER_BYTE, &data);
-			}
 			;
 
 sctp_hdr_field		:	SPORT		{ $$ = SCTPHDR_SPORT; }
-- 
2.1.4

