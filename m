From: Harsha Sharma <harshasharmaiitr@gmail.com>
Subject: [PATCH] src: extend nft to list set handle and delete set via set handle
Date: Sun, 14 Jan 2018 21:48:46 +0530
Message-ID: <20180114161846.20760-1-harshasharmaiitr@gmail.com>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org, harshasharmaiitr@gmail.com
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:40782 "EHLO
        mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751239AbeANQTI (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 14 Jan 2018 11:19:08 -0500
Received: by mail-pf0-f196.google.com with SMTP id i66so6987594pfd.7
        for <netfilter-devel@vger.kernel.org>; Sun, 14 Jan 2018 08:19:07 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Print 'handle' attribute in sets when listing via '-a' option and
delete sets via their unique set handles listed with '-a' option.
For e.g.

nft delete set [<family>] <table-name> [handle <handle>]

Signed-off-by: Harsha Sharma <harshasharmaiitr@gmail.com>
---
 include/linux/netfilter/nf_tables.h |  2 ++
 src/netlink.c                       |  4 ++++
 src/parser_bison.y                  | 16 ++++++++++++++--
 src/rule.c                          |  6 +++++-
 4 files changed, 25 insertions(+), 3 deletions(-)

diff --git a/include/linux/netfilter/nf_tables.h b/include/linux/netfilter/nf_tables.h
index 6db9130..a4c88ff 100644
--- a/include/linux/netfilter/nf_tables.h
+++ b/include/linux/netfilter/nf_tables.h
@@ -299,6 +299,7 @@ enum nft_set_desc_attributes {
  *
  * @NFTA_SET_TABLE: table name (NLA_STRING)
  * @NFTA_SET_NAME: set name (NLA_STRING)
+ * @NFTA_SET_HANDLE: numeric handle of the set (NLA_U64)
  * @NFTA_SET_FLAGS: bitmask of enum nft_set_flags (NLA_U32)
  * @NFTA_SET_KEY_TYPE: key data type, informational purpose only (NLA_U32)
  * @NFTA_SET_KEY_LEN: key data length (NLA_U32)
@@ -316,6 +317,7 @@ enum nft_set_attributes {
 	NFTA_SET_UNSPEC,
 	NFTA_SET_TABLE,
 	NFTA_SET_NAME,
+	NFTA_SET_HANDLE,
 	NFTA_SET_FLAGS,
 	NFTA_SET_KEY_TYPE,
 	NFTA_SET_KEY_LEN,
diff --git a/src/netlink.c b/src/netlink.c
index 59d7096..ef18a9c 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -192,6 +192,8 @@ struct nftnl_set *alloc_nftnl_set(const struct handle *h)
 		nftnl_set_set_str(nls, NFTNL_SET_NAME, h->set);
 	if (h->set_id)
 		nftnl_set_set_u32(nls, NFTNL_SET_ID, h->set_id);
+	if (h->handle.id)
+		nftnl_set_set_u64(nls, NFTNL_SET_HANDLE, h->handle.id);
 
 	return nls;
 }
@@ -1129,6 +1131,7 @@ static struct set *netlink_delinearize_set(struct netlink_ctx *ctx,
 					   nftnl_set_get_u32(nls, NFTNL_SET_KEY_LEN) * BITS_PER_BYTE,
 					   NULL);
 	set->flags   = nftnl_set_get_u32(nls, NFTNL_SET_FLAGS);
+	set->handle.handle.id = nftnl_set_get_u64(nls, NFTNL_SET_HANDLE);
 
 	set->objtype = objtype;
 
@@ -1334,6 +1337,7 @@ int netlink_list_sets(struct netlink_ctx *ctx, const struct handle *h,
 		return 0;
 	}
 
+	ctx->data = h;
 	err = nftnl_set_list_foreach(set_cache, list_set_cb, ctx);
 	nftnl_set_list_free(set_cache);
 	return err;
diff --git a/src/parser_bison.y b/src/parser_bison.y
index dbe80a5..5290207 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -497,8 +497,8 @@ int nft_lex(void *, void *, void *);
 
 %type <handle>			table_spec tableid_spec chain_spec chainid_spec chain_identifier ruleid_spec handle_spec position_spec rule_position ruleset_spec
 %destructor { handle_free(&$$); } table_spec tableid_spec chain_spec chainid_spec chain_identifier ruleid_spec handle_spec position_spec rule_position ruleset_spec
-%type <handle>			set_spec set_identifier obj_spec obj_identifier
-%destructor { handle_free(&$$); } set_spec set_identifier obj_spec obj_identifier
+%type <handle>			set_spec setid_spec set_identifier obj_spec obj_identifier
+%destructor { handle_free(&$$); } set_spec setid_spec set_identifier obj_spec obj_identifier
 %type <val>			family_spec family_spec_explicit chain_policy prio_spec
 
 %type <string>			dev_spec quota_unit
@@ -998,6 +998,10 @@ delete_cmd		:	TABLE		table_spec
 			{
 				$$ = cmd_alloc(CMD_DELETE, CMD_OBJ_SET, &$2, &@$, NULL);
 			}
+			| 	SET 		setid_spec
+			{
+				$$ = cmd_alloc(CMD_DELETE, CMD_OBJ_SET, &$2, &@$, NULL);
+			}
 			|	MAP		set_spec
 			{
 				$$ = cmd_alloc(CMD_DELETE, CMD_OBJ_SET, &$2, &@$, NULL);
@@ -1706,6 +1710,14 @@ set_spec		:	table_spec	identifier
 			}
 			;
 
+setid_spec 		: 	table_spec 	HANDLE NUM
+			{
+				$$ 			= $1;
+				$$.handle.location 	= @$;
+				$$.handle.id 		= $3;
+			}
+			;
+
 set_identifier		:	identifier
 			{
 				memset(&$$, 0, sizeof($$));
diff --git a/src/rule.c b/src/rule.c
index 7d66c22..35f67b7 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -367,7 +367,11 @@ static void do_set_print(const struct set *set, struct print_fmt_options *opts,
 		expr_print(set->init, octx);
 		nft_print(octx, "%s", opts->nl);
 	}
-	nft_print(octx, "%s}%s", opts->tab, opts->nl);
+	nft_print(octx, "%s}", opts->tab);
+	if (octx->handle > 0)
+		nft_print(octx, " # handle %" PRIu64, set->handle.handle.id);
+	nft_print(octx, "%s", opts->nl);
+
 }
 
 void set_print(const struct set *s, struct output_ctx *octx)
-- 
2.11.0

