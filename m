From: Florian Westphal <fw@strlen.de>
Subject: [PATCH 01/17] rename struct ct to ct_helper
Date: Wed, 28 Jun 2017 12:06:43 +0200
Message-ID: <20170628100659.26976-2-fw@strlen.de>
References: <20170628100659.26976-1-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:33340 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751469AbdF1KGo (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 28 Jun 2017 06:06:44 -0400
In-Reply-To: <20170628100659.26976-1-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Its misleading, this structure holds members for ct_helper object
infrastructure, rename it.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/rule.h     |  6 +++---
 src/netlink.c      | 14 +++++++-------
 src/parser_bison.y | 12 ++++++------
 src/rule.c         |  6 +++---
 4 files changed, 19 insertions(+), 19 deletions(-)

diff --git a/include/rule.h b/include/rule.h
index 7424b21c6e01..24c73d85f83b 100644
--- a/include/rule.h
+++ b/include/rule.h
@@ -263,8 +263,8 @@ struct quota {
 	uint32_t	flags;
 };
 
-struct ct {
-	char helper_name[16];
+struct ct_helper {
+	char name[16];
 	uint16_t l3proto;
 	uint8_t l4proto;
 };
@@ -287,7 +287,7 @@ struct obj {
 	union {
 		struct counter		counter;
 		struct quota		quota;
-		struct ct		ct;
+		struct ct_helper	ct_helper;
 	};
 };
 
diff --git a/src/netlink.c b/src/netlink.c
index 880502cde20c..b9731a91b9bf 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -319,12 +319,12 @@ alloc_nftnl_obj(const struct handle *h, struct obj *obj)
 		break;
 	case NFT_OBJECT_CT_HELPER:
 		nftnl_obj_set_str(nlo, NFTNL_OBJ_CT_HELPER_NAME,
-				  obj->ct.helper_name);
+				  obj->ct_helper.name);
 		nftnl_obj_set_u8(nlo, NFTNL_OBJ_CT_HELPER_L4PROTO,
-				  obj->ct.l4proto);
-		if (obj->ct.l3proto)
+				  obj->ct_helper.l4proto);
+		if (obj->ct_helper.l3proto)
 			nftnl_obj_set_u16(nlo, NFTNL_OBJ_CT_HELPER_L3PROTO,
-					  obj->ct.l3proto);
+					  obj->ct_helper.l3proto);
 		break;
 	default:
 		BUG("Unknown type %d\n", obj->type);
@@ -1832,10 +1832,10 @@ static struct obj *netlink_delinearize_obj(struct netlink_ctx *ctx,
 			nftnl_obj_get_u32(nlo, NFTNL_OBJ_QUOTA_FLAGS);
 		break;
 	case NFT_OBJECT_CT_HELPER:
-		snprintf(obj->ct.helper_name, sizeof(obj->ct.helper_name), "%s",
+		snprintf(obj->ct_helper.name, sizeof(obj->ct_helper.name), "%s",
 			 nftnl_obj_get_str(nlo, NFTNL_OBJ_CT_HELPER_NAME));
-		obj->ct.l3proto = nftnl_obj_get_u16(nlo, NFTNL_OBJ_CT_HELPER_L3PROTO);
-		obj->ct.l4proto = nftnl_obj_get_u8(nlo, NFTNL_OBJ_CT_HELPER_L4PROTO);
+		obj->ct_helper.l3proto = nftnl_obj_get_u16(nlo, NFTNL_OBJ_CT_HELPER_L3PROTO);
+		obj->ct_helper.l4proto = nftnl_obj_get_u8(nlo, NFTNL_OBJ_CT_HELPER_L4PROTO);
 		break;
 	}
 	obj->type = type;
diff --git a/src/parser_bison.y b/src/parser_bison.y
index a8448e14ef1f..9a9ff6f5ce44 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -2706,14 +2706,14 @@ ct_l4protoname		:	TCP	{ $$ = IPPROTO_TCP; }
 
 ct_config		:	TYPE	QUOTED_STRING	PROTOCOL	ct_l4protoname	stmt_seperator
 			{
-				struct ct *ct;
+				struct ct_helper *ct;
 				int ret;
 
-				ct = &$<obj>0->ct;
+				ct = &$<obj>0->ct_helper;
 
-				ret = snprintf(ct->helper_name, sizeof(ct->helper_name), "%s", $2);
-				if (ret <= 0 || ret >= (int)sizeof(ct->helper_name)) {
-					erec_queue(error(&@2, "invalid name '%s', max length is %u\n", $2, (int)sizeof(ct->helper_name)), state->msgs);
+				ret = snprintf(ct->name, sizeof(ct->name), "%s", $2);
+				if (ret <= 0 || ret >= (int)sizeof(ct->name)) {
+					erec_queue(error(&@2, "invalid name '%s', max length is %u\n", $2, (int)sizeof(ct->name)), state->msgs);
 					YYERROR;
 				}
 
@@ -2721,7 +2721,7 @@ ct_config		:	TYPE	QUOTED_STRING	PROTOCOL	ct_l4protoname	stmt_seperator
 			}
 			|	L3PROTOCOL	family_spec_explicit	stmt_seperator
 			{
-				$<obj>0->ct.l3proto = $2;
+				$<obj>0->ct_helper.l3proto = $2;
 			}
 			;
 
diff --git a/src/rule.c b/src/rule.c
index f65674c0e2d4..ee510fe0123b 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -1258,9 +1258,9 @@ static void obj_print_data(const struct obj *obj,
 		break;
 	case NFT_OBJECT_CT_HELPER: {
 		printf("ct helper %s {\n", obj->handle.obj);
-		printf("\t\ttype \"%s\" protocol ", obj->ct.helper_name);
-		print_proto_name_proto(obj->ct.l4proto);
-		printf("\t\tl3proto %s", family2str(obj->ct.l3proto));
+		printf("\t\ttype \"%s\" protocol ", obj->ct_helper.name);
+		print_proto_name_proto(obj->ct_helper.l4proto);
+		printf("\t\tl3proto %s", family2str(obj->ct_helper.l3proto));
 		break;
 		}
 	default:
-- 
2.13.0

