From: Florian Westphal <fw@strlen.de>
Subject: [PATCH v2 nftables 1/7] src: add initial ct helper support
Date: Wed, 15 Mar 2017 16:01:05 +0100
Message-ID: <20170315150111.18477-2-fw@strlen.de>
References: <20170315150111.18477-1-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:46442 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752676AbdCOPA6 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 15 Mar 2017 11:00:58 -0400
In-Reply-To: <20170315150111.18477-1-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This adds initial support for defining conntrack helper objects
which can then be assigned to connections using the objref infrastructure:

table ip filter {
  ct helper ftp-standard {
    type "ftp" protocol tcp
  }
  chain y {
	 tcp dport 21 ct helper set "ftp-standard"
  }
}

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 Changes since v1:
   - tweak user syntax
   - minor cleanup
   - fix parsing of l3proto: v1 used to set l4proto instead of l3.

 include/ct.h                        |  1 +
 include/linux/netfilter/nf_tables.h | 12 +++++-
 include/rule.h                      |  7 ++++
 src/ct.c                            | 10 +++++
 src/netlink.c                       | 16 ++++++++
 src/parser_bison.y                  | 74 ++++++++++++++++++++++++++++++++++++-
 src/rule.c                          | 21 ++++++++++-
 src/statement.c                     | 10 ++++-
 8 files changed, 146 insertions(+), 5 deletions(-)

diff --git a/include/ct.h b/include/ct.h
index 03e76e619e23..ae900ee4fb61 100644
--- a/include/ct.h
+++ b/include/ct.h
@@ -31,6 +31,7 @@ extern struct error_record *ct_dir_parse(const struct location *loc,
 					 const char *str, int8_t *dir);
 extern struct error_record *ct_key_parse(const struct location *loc, const char *str,
 					 unsigned int *key);
+extern struct error_record *ct_objtype_parse(const struct location *loc, const char *str, int *type);
 
 extern struct stmt *notrack_stmt_alloc(const struct location *loc);
 
diff --git a/include/linux/netfilter/nf_tables.h b/include/linux/netfilter/nf_tables.h
index a9280a6541ac..8f3842690d17 100644
--- a/include/linux/netfilter/nf_tables.h
+++ b/include/linux/netfilter/nf_tables.h
@@ -1260,10 +1260,20 @@ enum nft_fib_flags {
 	NFTA_FIB_F_PRESENT	= 1 << 5,	/* check existence only */
 };
 
+enum nft_ct_helper_attributes {
+	NFTA_CT_HELPER_UNSPEC,
+	NFTA_CT_HELPER_NAME,
+	NFTA_CT_HELPER_L3PROTO,
+	NFTA_CT_HELPER_L4PROTO,
+	__NFTA_CT_HELPER_MAX,
+};
+#define NFTA_CT_HELPER_MAX	(__NFTA_CT_HELPER_MAX - 1)
+
 #define NFT_OBJECT_UNSPEC	0
 #define NFT_OBJECT_COUNTER	1
 #define NFT_OBJECT_QUOTA	2
-#define __NFT_OBJECT_MAX	3
+#define NFT_OBJECT_CT_HELPER	3
+#define __NFT_OBJECT_MAX	4
 #define NFT_OBJECT_MAX		(__NFT_OBJECT_MAX - 1)
 
 /**
diff --git a/include/rule.h b/include/rule.h
index ed12774d0ba7..d89a963dfd05 100644
--- a/include/rule.h
+++ b/include/rule.h
@@ -260,6 +260,12 @@ struct quota {
 	uint32_t	flags;
 };
 
+struct ct {
+	char helper_name[16];
+	uint16_t l3proto;
+	uint8_t l4proto;
+};
+
 /**
  * struct obj - nftables stateful object statement
  *
@@ -277,6 +283,7 @@ struct obj {
 	union {
 		struct counter		counter;
 		struct quota		quota;
+		struct ct		ct;
 	};
 };
 
diff --git a/src/ct.c b/src/ct.c
index 83fceff67139..fd8ca87a21fb 100644
--- a/src/ct.c
+++ b/src/ct.c
@@ -353,6 +353,16 @@ struct error_record *ct_key_parse(const struct location *loc, const char *str,
 	return error(loc, "syntax error, unexpected %s, known keys are %s", str, buf);
 }
 
+struct error_record *ct_objtype_parse(const struct location *loc, const char *str, int *type)
+{
+	if (strcmp(str, "helper") == 0) {
+		*type = NFT_OBJECT_CT_HELPER;
+		return NULL;
+	}
+
+	return error(loc, "unknown ct class '%s', want 'helper'", str);
+}
+
 struct expr *ct_expr_alloc(const struct location *loc, enum nft_ct_keys key,
 			   int8_t direction)
 {
diff --git a/src/netlink.c b/src/netlink.c
index fb6d2876a6f1..6fbb67da7f76 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -317,6 +317,15 @@ alloc_nftnl_obj(const struct handle *h, struct obj *obj)
 		nftnl_obj_set_u32(nlo, NFTNL_OBJ_QUOTA_FLAGS,
 				  obj->quota.flags);
 		break;
+	case NFT_OBJECT_CT_HELPER:
+		nftnl_obj_set_str(nlo, NFTNL_OBJ_CT_HELPER_NAME,
+				  obj->ct.helper_name);
+		nftnl_obj_set_u8(nlo, NFTNL_OBJ_CT_HELPER_L4PROTO,
+				  obj->ct.l4proto);
+		if (obj->ct.l3proto)
+			nftnl_obj_set_u16(nlo, NFTNL_OBJ_CT_HELPER_L3PROTO,
+					  obj->ct.l3proto);
+		break;
 	default:
 		BUG("Unknown type %d\n", obj->type);
 		break;
@@ -1814,6 +1823,13 @@ static struct obj *netlink_delinearize_obj(struct netlink_ctx *ctx,
 			nftnl_obj_get_u64(nlo, NFTNL_OBJ_QUOTA_CONSUMED);
 		obj->quota.flags =
 			nftnl_obj_get_u32(nlo, NFTNL_OBJ_QUOTA_FLAGS);
+		break;
+	case NFT_OBJECT_CT_HELPER:
+		snprintf(obj->ct.helper_name, sizeof(obj->ct.helper_name), "%s",
+			 nftnl_obj_get_str(nlo, NFTNL_OBJ_CT_HELPER_NAME));
+		obj->ct.l3proto = nftnl_obj_get_u16(nlo, NFTNL_OBJ_CT_HELPER_L3PROTO);
+		obj->ct.l4proto = nftnl_obj_get_u8(nlo, NFTNL_OBJ_CT_HELPER_L4PROTO);
+		break;
 	}
 	obj->type = type;
 
diff --git a/src/parser_bison.y b/src/parser_bison.y
index 12a6e64645fa..2cf732ce818f 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -136,6 +136,7 @@ static void location_update(struct location *loc, struct location *rhs, int n)
 	struct obj		*obj;
 	struct counter		*counter;
 	struct quota		*quota;
+	struct ct		*ct;
 	const struct datatype	*datatype;
 	struct handle_spec	handle_spec;
 	struct position_spec	position_spec;
@@ -494,7 +495,7 @@ static void location_update(struct location *loc, struct location *rhs, int n)
 %type <set>			map_block_alloc map_block
 %destructor { set_free($$); }	map_block_alloc
 
-%type <obj>			obj_block_alloc counter_block quota_block
+%type <obj>			obj_block_alloc counter_block quota_block ct_block
 %destructor { obj_free($$); }	obj_block_alloc
 
 %type <list>			stmt_list
@@ -665,6 +666,10 @@ static void location_update(struct location *loc, struct location *rhs, int n)
 %destructor { expr_free($$); }	exthdr_exists_expr
 %type <val>			exthdr_key
 
+%type <val>			ct_l4protoname
+%type <string>			ct_obj_kind
+%destructor { xfree($$); }     	ct_obj_kind
+
 %%
 
 input			:	/* empty */
@@ -1191,6 +1196,24 @@ table_block		:	/* empty */	{ $$ = $<table>-1; }
 				list_add_tail(&$4->list, &$1->objs);
 				$$ = $1;
 			}
+			|	table_block	CT	ct_obj_kind	obj_identifier  obj_block_alloc '{'     ct_block     '}' stmt_seperator
+			{
+				struct error_record *erec;
+				int type;
+
+				erec = ct_objtype_parse(&@$, $3, &type);
+				if (erec != NULL) {
+					erec_queue(erec, state->msgs);
+					YYERROR;
+				}
+
+				$5->location = @4;
+				$5->type = type;
+				handle_merge(&$5->handle, &$4);
+				handle_free(&$4);
+				list_add_tail(&$5->list, &$1->objs);
+				$$ = $1;
+			}
 			;
 
 chain_block_alloc	:	/* empty */
@@ -1385,6 +1408,16 @@ quota_block		:	/* empty */	{ $$ = $<obj>-1; }
 			}
 			;
 
+ct_block		:	/* empty */	{ $$ = $<obj>-1; }
+			|       ct_block     common_block
+			|       ct_block     stmt_seperator
+			|       ct_block     ct_config
+			{
+				$$ = $1;
+			}
+			;
+
+
 type_identifier		:	STRING	{ $$ = $1; }
 			|	MARK	{ $$ = xstrdup("mark"); }
 			|	DSCP	{ $$ = xstrdup("dscp"); }
@@ -2578,6 +2611,34 @@ quota_obj		:	quota_config
 			}
 			;
 
+ct_obj_kind		:	STRING		{ $$ = $1; }
+			;
+
+ct_l4protoname		:	TCP	{ $$ = IPPROTO_TCP; }
+			|	UDP	{ $$ = IPPROTO_UDP; }
+			;
+
+ct_config		:	TYPE	QUOTED_STRING	PROTOCOL	ct_l4protoname	stmt_seperator
+			{
+				struct ct *ct;
+				int ret;
+
+				ct = &$<obj>0->ct;
+
+				ret = snprintf(ct->helper_name, sizeof(ct->helper_name), "%s", $2);
+				if (ret <= 0 || ret >= (int)sizeof(ct->helper_name)) {
+					erec_queue(error(&@2, "invalid name '%s', max length is %u\n", $2, (int)sizeof(ct->helper_name)), state->msgs);
+					YYERROR;
+				}
+
+				ct->l4proto = $4;
+			}
+			|	L3PROTOCOL	family_spec_explicit	stmt_seperator
+			{
+				$<obj>0->ct.l3proto = $2;
+			}
+			;
+
 relational_expr		:	expr	/* implicit */	rhs_expr
 			{
 				$$ = relational_expr_alloc(&@$, OP_IMPLICIT, $1, $2);
@@ -3037,7 +3098,16 @@ ct_stmt			:	CT	ct_key		SET	expr
 					YYERROR;
 				}
 
-				$$ = ct_stmt_alloc(&@$, key, -1, $4);
+				switch (key) {
+				case NFT_CT_HELPER:
+					$$ = objref_stmt_alloc(&@$);
+					$$->objref.type = NFT_OBJECT_CT_HELPER;
+					$$->objref.expr = $4;
+					break;
+				default:
+					$$ = ct_stmt_alloc(&@$, key, -1, $4);
+					break;
+				}
 			}
 			|	CT	STRING	ct_key_dir_optional SET	expr
 			{
diff --git a/src/rule.c b/src/rule.c
index 056d5ce8394e..17c20f35398a 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -19,6 +19,7 @@
 #include <statement.h>
 #include <rule.h>
 #include <utils.h>
+#include <netdb.h>
 #include <netlink.h>
 
 #include <libnftnl/common.h>
@@ -1172,6 +1173,16 @@ struct obj *obj_lookup(const struct table *table, const char *name,
 	return NULL;
 }
 
+static void print_proto_name_proto(uint8_t l4)
+{
+	const struct protoent *p = getprotobynumber(l4);
+
+	if (p)
+		printf("%s\n", p->p_name);
+	else
+		printf("%d\n", l4);
+}
+
 static void obj_print_data(const struct obj *obj,
 			   struct print_fmt_options *opts)
 {
@@ -1202,6 +1213,13 @@ static void obj_print_data(const struct obj *obj,
 		}
 		}
 		break;
+	case NFT_OBJECT_CT_HELPER: {
+		printf("ct helper %s {\n", obj->handle.obj);
+		printf("\t\ttype \"%s\" protocol ", obj->ct.helper_name);
+		print_proto_name_proto(obj->ct.l4proto);
+		printf("\t\tl3proto %s", family2str(obj->ct.l3proto));
+		break;
+		}
 	default:
 		printf("unknown {%s", opts->nl);
 		break;
@@ -1211,11 +1229,12 @@ static void obj_print_data(const struct obj *obj,
 static const char *obj_type_name_array[] = {
 	[NFT_OBJECT_COUNTER]	= "counter",
 	[NFT_OBJECT_QUOTA]	= "quota",
+	[NFT_OBJECT_CT_HELPER]	= "",
 };
 
 const char *obj_type_name(enum stmt_types type)
 {
-	assert(type <= NFT_OBJECT_QUOTA && obj_type_name_array[type]);
+	assert(type <= NFT_OBJECT_CT_HELPER && obj_type_name_array[type]);
 
 	return obj_type_name_array[type];
 }
diff --git a/src/statement.c b/src/statement.c
index 7ffd25f98ea6..d824dc0bd91a 100644
--- a/src/statement.c
+++ b/src/statement.c
@@ -174,6 +174,7 @@ struct stmt *counter_stmt_alloc(const struct location *loc)
 static const char *objref_type[NFT_OBJECT_MAX + 1] = {
 	[NFT_OBJECT_COUNTER]	= "counter",
 	[NFT_OBJECT_QUOTA]	= "quota",
+	[NFT_OBJECT_CT_HELPER]	= "cthelper",
 };
 
 static const char *objref_type_name(uint32_t type)
@@ -186,7 +187,14 @@ static const char *objref_type_name(uint32_t type)
 
 static void objref_stmt_print(const struct stmt *stmt)
 {
-	printf("%s name ", objref_type_name(stmt->objref.type));
+	switch (stmt->objref.type) {
+	case NFT_OBJECT_CT_HELPER:
+		printf("ct helper set ");
+		break;
+	default:
+		printf("%s name ", objref_type_name(stmt->objref.type));
+		break;
+	}
 	expr_print(stmt->objref.expr);
 }
 
-- 
2.10.2

