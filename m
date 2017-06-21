From: Laurent Fasnacht <l@libres.ch>
Subject: [PATCH] nft: make raw payloads work
Date: Wed, 21 Jun 2017 11:07:00 +0200
Message-ID: <1498036020-22214-1-git-send-email-l@libres.ch>
Cc: Laurent Fasnacht <l@libres.ch>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.o-t.ch ([78.40.74.172]:58919 "EHLO mail.o-t.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751128AbdFUJMv (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 21 Jun 2017 05:12:51 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

In nftables, there is a rather (IMO) undocumented feature, raw payloads.

It would be useful both for development and to quickly extend nftables for corner cases.

Unfortunately, it is broken in current master (syntax is not consistent between print and parse,
and any practical usage doesn't work).

This patch defines a new syntax, and makes it usable in practice:

@<protocol>,<base>,<data type>,<offset>,<length>

Example (rewrite arp packet target hardware address if target protocol address matches a given address):

meta iif enp2s0 arp ptype 0x0800 arp htype 1 arp hlen 6 arp plen 4 @arp,nh,ipv4_addr,192,32 192.168.143.16 @arp,nh,ether_addr,144,48 set 11:22:33:44:55:66 accept;

Signed-off-by: Laurent Fasnacht <l@libres.ch>
---
 include/proto.h    |  2 ++
 src/parser_bison.y | 32 ++++++++++++++++++++++++++------
 src/payload.c      | 15 +++++++++++++--
 3 files changed, 41 insertions(+), 8 deletions(-)

diff --git a/include/proto.h b/include/proto.h
index 01188ab..a7c696f 100644
--- a/include/proto.h
+++ b/include/proto.h
@@ -295,6 +295,8 @@ enum sctp_hdr_fields {
 	SCTPHDR_CHECKSUM,
 };
 
+#define RAWHDR_FIELD 0xffffffff
+
 extern const struct proto_desc proto_icmp;
 extern const struct proto_desc proto_ah;
 extern const struct proto_desc proto_esp;
diff --git a/src/parser_bison.y b/src/parser_bison.y
index a8448e1..c49b589 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -138,6 +138,7 @@ static void location_update(struct location *loc, struct location *rhs, int n)
 	struct quota		*quota;
 	struct ct		*ct;
 	const struct datatype	*datatype;
+	const struct proto_desc	*proto_desc;
 	struct handle_spec	handle_spec;
 	struct position_spec	position_spec;
 	const struct exthdr_desc *exthdr_desc;
@@ -463,6 +464,8 @@ static void location_update(struct location *loc, struct location *rhs, int n)
 %type <val>			type_identifier_list
 %type <datatype>		data_type
 
+%type <proto_desc>		protocol
+
 %type <cmd>			line
 %destructor { cmd_free($$); }	line
 
@@ -1445,6 +1448,23 @@ data_type		:	type_identifier_list
 					$$ = datatype_lookup($1);
 			}
 			;
+			
+protocol		:	ETHER		{ $$ = &proto_eth; }
+			|	VLAN		{ $$ = &proto_vlan; }
+			|	ARP		{ $$ = &proto_arp; }
+			|	IP		{ $$ = &proto_ip; }
+			|	ICMP		{ $$ = &proto_icmp; }
+			|	IP6		{ $$ = &proto_ip6; }
+			|	ICMP6		{ $$ = &proto_icmp6; }
+			|	AH		{ $$ = &proto_ah; }
+			|	ESP		{ $$ = &proto_esp; }
+			|	COMP		{ $$ = &proto_comp; }
+			|	UDP		{ $$ = &proto_udp; }
+			|	UDPLITE		{ $$ = &proto_udplite; }
+			|	TCP		{ $$ = &proto_tcp; }
+			|	DCCP		{ $$ = &proto_dccp; }
+			|	SCTP		{ $$ = &proto_sctp; }
+			;
 
 type_identifier_list	:	type_identifier
 			{
@@ -3260,13 +3280,13 @@ payload_expr		:	payload_raw_expr
 			|	sctp_hdr_expr
 			;
 
-payload_raw_expr	:	AT	payload_base_spec	COMMA	NUM	COMMA	NUM
+payload_raw_expr	:	AT	protocol	COMMA	payload_base_spec	COMMA	data_type	COMMA	NUM	COMMA	NUM
 			{
-				$$ = payload_expr_alloc(&@$, NULL, 0);
-				$$->payload.base	= $2;
-				$$->payload.offset	= $4;
-				$$->len			= $6;
-				$$->dtype		= &integer_type;
+				$$ = payload_expr_alloc(&@$, $2, RAWHDR_FIELD);
+				$$->payload.base   = $4;
+				$$->payload.offset = $8;
+				$$->dtype          = $6;
+				$$->len            = $10;
 			}
 			;
 
diff --git a/src/payload.c b/src/payload.c
index 7f94ff7..e75c83c 100644
--- a/src/payload.c
+++ b/src/payload.c
@@ -48,8 +48,10 @@ static void payload_expr_print(const struct expr *expr, struct output_ctx *octx)
 	if (payload_is_known(expr))
 		printf("%s %s", desc->name, tmpl->token);
 	else
-		printf("payload @%s,%u,%u",
+		printf("@%s,%s,%s,%u,%u",
+		       desc->name,
 		       proto_base_tokens[expr->payload.base],
+		       expr->dtype->name,
 		       expr->payload.offset, expr->len);
 }
 
@@ -149,7 +151,11 @@ struct expr *payload_expr_alloc(const struct location *loc,
 	unsigned int flags = 0;
 
 	if (desc != NULL) {
-		tmpl = &desc->templates[type];
+		if (type == RAWHDR_FIELD) {
+			tmpl = &proto_unknown_template;
+		} else {
+			tmpl = &desc->templates[type];
+		}
 		base = desc->base;
 		if (proto_key_is_protocol(desc, type))
 			flags = EXPR_F_PROTOCOL;
@@ -509,6 +515,9 @@ void payload_expr_complete(struct expr *expr, const struct proto_ctx *ctx)
 		expr->payload.tmpl = tmpl;
 		return;
 	}
+
+	/* This is a raw payload */
+	expr->payload.desc = desc;
 }
 
 static unsigned int mask_to_offset(const struct expr *mask)
@@ -641,6 +650,8 @@ raw:
 	payload_init_raw(new, expr->payload.base, expr->payload.offset,
 			 expr->len);
 	list_add_tail(&new->list, list);
+	if (desc)
+		new->payload.desc = desc;
 }
 
 static bool payload_is_adjacent(const struct expr *e1, const struct expr *e2)
-- 
2.1.4

