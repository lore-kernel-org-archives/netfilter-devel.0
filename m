From: Harsha Sharma <harshasharmaiitr@gmail.com>
Subject: [PATCH] src: extend nft to list object handle and delete objects via handle
Date: Fri, 19 Jan 2018 00:22:56 +0530
Message-ID: <20180118185256.8842-1-harshasharmaiitr@gmail.com>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org, harshasharmaiitr@gmail.com
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pg0-f68.google.com ([74.125.83.68]:38284 "EHLO
        mail-pg0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752368AbeARSxQ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 18 Jan 2018 13:53:16 -0500
Received: by mail-pg0-f68.google.com with SMTP id y27so9019014pgc.5
        for <netfilter-devel@vger.kernel.org>; Thu, 18 Jan 2018 10:53:16 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Print handle attributes in objects when listing via '-a' option and
delete objects via their unique object handles.
For e.g.

nft delete [<object-type>] [<family>] <table-name> [handle <handle>]

Signed-off-by: Harsha Sharma <harshasharmaiitr@gmail.com>
---
 include/linux/netfilter/nf_tables.h |  2 ++
 src/netlink.c                       |  5 +++++
 src/parser_bison.y                  | 24 ++++++++++++++++++++++--
 src/rule.c                          |  5 ++++-
 4 files changed, 33 insertions(+), 3 deletions(-)

diff --git a/include/linux/netfilter/nf_tables.h b/include/linux/netfilter/nf_tables.h
index a4c88ff..8609925 100644
--- a/include/linux/netfilter/nf_tables.h
+++ b/include/linux/netfilter/nf_tables.h
@@ -1291,6 +1291,7 @@ enum nft_ct_helper_attributes {
  *
  * @NFTA_OBJ_TABLE: name of the table containing the expression (NLA_STRING)
  * @NFTA_OBJ_NAME: name of this expression type (NLA_STRING)
+ * @NFTA_OBJ_HANDLE: numeric handle of object (NLA_U64)
  * @NFTA_OBJ_TYPE: stateful object type (NLA_U32)
  * @NFTA_OBJ_DATA: stateful object data (NLA_NESTED)
  * @NFTA_OBJ_USE: number of references to this expression (NLA_U32)
@@ -1302,6 +1303,7 @@ enum nft_object_attributes {
 	NFTA_OBJ_TYPE,
 	NFTA_OBJ_DATA,
 	NFTA_OBJ_USE,
+	NFTA_OBJ_HANDLE,
 	__NFTA_OBJ_MAX
 };
 #define NFTA_OBJ_MAX		(__NFTA_OBJ_MAX - 1)
diff --git a/src/netlink.c b/src/netlink.c
index ef18a9c..740f0ff 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -293,6 +293,8 @@ __alloc_nftnl_obj(const struct handle *h, uint32_t type)
 		nftnl_obj_set_str(nlo, NFTNL_OBJ_NAME, h->obj);
 
 	nftnl_obj_set_u32(nlo, NFTNL_OBJ_TYPE, type);
+	if (h->handle.id)
+		nftnl_obj_set_u64(nlo, NFTNL_OBJ_HANDLE, h->handle.id);
 
 	return nlo;
 }
@@ -1727,6 +1729,8 @@ static struct obj *netlink_delinearize_obj(struct netlink_ctx *ctx,
 		xstrdup(nftnl_obj_get_str(nlo, NFTNL_OBJ_TABLE));
 	obj->handle.obj =
 		xstrdup(nftnl_obj_get_str(nlo, NFTNL_OBJ_NAME));
+	obj->handle.handle.id =
+		nftnl_obj_get_u64(nlo, NFTNL_OBJ_HANDLE);
 
 	type = nftnl_obj_get_u32(nlo, NFTNL_OBJ_TYPE);
 	switch (type) {
@@ -2545,6 +2549,7 @@ static void netlink_events_cache_delobj(struct netlink_mon_handler *monh,
 
 	name     = nftnl_obj_get_str(nlo, NFTNL_OBJ_NAME);
 	type	 = nftnl_obj_get_u32(nlo, NFTNL_OBJ_TYPE);
+	h.handle.id	= nftnl_obj_get_u64(nlo, NFTNL_OBJ_HANDLE);
 
 	t = table_lookup(&h, monh->cache);
 	if (t == NULL) {
diff --git a/src/parser_bison.y b/src/parser_bison.y
index 5290207..2aded4f 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -497,8 +497,8 @@ int nft_lex(void *, void *, void *);
 
 %type <handle>			table_spec tableid_spec chain_spec chainid_spec chain_identifier ruleid_spec handle_spec position_spec rule_position ruleset_spec
 %destructor { handle_free(&$$); } table_spec tableid_spec chain_spec chainid_spec chain_identifier ruleid_spec handle_spec position_spec rule_position ruleset_spec
-%type <handle>			set_spec setid_spec set_identifier obj_spec obj_identifier
-%destructor { handle_free(&$$); } set_spec setid_spec set_identifier obj_spec obj_identifier
+%type <handle>			set_spec setid_spec set_identifier obj_spec objid_spec obj_identifier
+%destructor { handle_free(&$$); } set_spec setid_spec set_identifier obj_spec objid_spec obj_identifier
 %type <val>			family_spec family_spec_explicit chain_policy prio_spec
 
 %type <string>			dev_spec quota_unit
@@ -1014,10 +1014,18 @@ delete_cmd		:	TABLE		table_spec
 			{
 				$$ = cmd_alloc(CMD_DELETE, CMD_OBJ_COUNTER, &$2, &@$, NULL);
 			}
+			|  	COUNTER 	objid_spec
+			{
+				$$ = cmd_alloc(CMD_DELETE, CMD_OBJ_COUNTER, &$2, &@$, NULL);
+			}
 			|	QUOTA		obj_spec
 			{
 				$$ = cmd_alloc(CMD_DELETE, CMD_OBJ_QUOTA, &$2, &@$, NULL);
 			}
+			| 	QUOTA 		objid_spec
+			{
+				$$ = cmd_alloc(CMD_DELETE, CMD_OBJ_QUOTA, &$2, &@$, NULL);
+			}
 			|	CT	ct_obj_type	obj_spec	ct_obj_alloc
 			{
 				$$ = cmd_alloc_obj_ct(CMD_DELETE, $2, &$3, &@$, $4);
@@ -1026,6 +1034,10 @@ delete_cmd		:	TABLE		table_spec
 			{
 				$$ = cmd_alloc(CMD_DELETE, CMD_OBJ_LIMIT, &$2, &@$, NULL);
 			}
+			| 	LIMIT 		objid_spec
+			{
+				$$ = cmd_alloc(CMD_DELETE, CMD_OBJ_LIMIT, &$2, &@$, NULL);
+			}
 			;
 
 list_cmd		:	TABLE		table_spec
@@ -1732,6 +1744,14 @@ obj_spec		:	table_spec	identifier
 			}
 			;
 
+objid_spec		:	table_spec	HANDLE NUM
+			{
+				$$ 			= $1;
+				$$.handle.location	= @$;
+				$$.handle.id		= $3;
+			}
+			;
+
 obj_identifier		:	identifier
 			{
 				memset(&$$, 0, sizeof($$));
diff --git a/src/rule.c b/src/rule.c
index 35f67b7..fd90fa6 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -1397,7 +1397,10 @@ static void obj_print_declaration(const struct obj *obj,
 
 	obj_print_data(obj, opts, octx);
 
-	nft_print(octx, "%s%s}%s", opts->nl, opts->tab, opts->nl);
+	nft_print(octx, "%s%s}", opts->nl, opts->tab);
+	if (octx->handle > 0)
+		nft_print(octx, " # handle %" PRIu64, obj->handle.handle.id);
+	nft_print(octx, "%s", opts->nl);
 }
 
 void obj_print(const struct obj *obj, struct output_ctx *octx)
-- 
2.11.0

