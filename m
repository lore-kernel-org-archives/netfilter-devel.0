From: Ana Rey <anarey@gmail.com>
Subject: [PATCH] nftables: Fix list of sets by family
Date: Fri, 28 Mar 2014 08:57:54 +0100
Message-ID: <dfe65abd0921773564be9ebfe55b55233380bd40.1395993386.git.anarey@gmail.com>
Cc: Ana Rey <anarey@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-we0-f177.google.com ([74.125.82.177]:48856 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751145AbaC1H6R (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 28 Mar 2014 03:58:17 -0400
Received: by mail-we0-f177.google.com with SMTP id u57so2301115wes.8
        for <netfilter-devel@vger.kernel.org>; Fri, 28 Mar 2014 00:58:15 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Fix the result of command line 'nft list sets FAMILY'. It shows the
following error message:

"Error: syntax error, unexpected end of file, expecting string"

Use set_print function to show the list of set by family (ip, ip6, arp,
bridge).

The set_print function is used in the following command line:
* sudo nft list table FAMILY table_name
* sudo nft list set FAMILY table_name set_name
* sudo nft list sets FAMILY

In 'nft list table FAMILY table_name' and 'nft list set FAMILY
table_name set_name' command line is necessary a extra indent that is
not necessary in 'nft list sets FAMILY'.

Thus, It fixes this indent problem in the set_print function and now, it is
possible show right this information:

$ sudo nft list sets ip
et set_test {
	type ipv4_address
	elements = { 192.168.3.45, 192.168.3.43, 192.168.3.42, 192.168.3.4}
}
set set_test2 {
	type ipv4_address
	elements = { 192.168.3.43, 192.168.3.42, 192.168.3.4}
}
set set0 {
	type ipv4_address
	flags constant
	elements = { 127.0.0.12, 172.0.0.13}
}

$ sudo nft  list set ip test set_test
set set_test {
	type ipv4_address
	elements = { 192.168.3.45, 192.168.3.43, 192.168.3.42, 192.168.3.4}
}

$ sudo nft list table ip test
table ip test {
	set set_test {
		type ipv4_address
		elements = { 192.168.3.45, 192.168.3.43, 192.168.3.42, 192.168.3.4}
	}

	set set_test2 {
		type ipv4_address
		elements = { 192.168.3.43, 192.168.3.42, 192.168.3.4}
	}

	chain input {
		 ip daddr { 127.0.0.12, 172.0.0.13} drop
	}
}

Signed-off-by: Ana Rey <anarey@gmail.com>
---
 include/rule.h |  2 +-
 src/parser.y   |  2 +-
 src/rule.c     | 26 ++++++++++++++++----------
 3 files changed, 18 insertions(+), 12 deletions(-)

diff --git a/include/rule.h b/include/rule.h
index ecf801f..b283421 100644
--- a/include/rule.h
+++ b/include/rule.h
@@ -194,7 +194,7 @@ extern struct set *set_get(struct set *set);
 extern void set_free(struct set *set);
 extern void set_add_hash(struct set *set, struct table *table);
 extern struct set *set_lookup(const struct table *table, const char *name);
-extern void set_print(const struct set *set);
+extern void set_print(const struct set *set, bool indent);
 
 /**
  * enum cmd_ops - command operations
diff --git a/src/parser.y b/src/parser.y
index db6f493..af34857 100644
--- a/src/parser.y
+++ b/src/parser.y
@@ -719,7 +719,7 @@ list_cmd		:	TABLE		table_spec
 			{
 				$$ = cmd_alloc(CMD_LIST, CMD_OBJ_CHAIN, &$2, &@$, NULL);
 			}
-			|	SETS		table_spec
+			|	SETS		tables_spec
 			{
 				$$ = cmd_alloc(CMD_LIST, CMD_OBJ_SETS, &$2, &@$, NULL);
 			}
diff --git a/src/rule.c b/src/rule.c
index b719040..68f2696 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -93,21 +93,23 @@ struct set *set_lookup(const struct table *table, const char *name)
 	return NULL;
 }
 
-void set_print(const struct set *set)
+void set_print(const struct set *set, bool indent)
 {
 	const char *delim = "";
 	const char *type;
 
 	type = set->flags & SET_F_MAP ? "map" : "set";
-	printf("\t%s %s {\n", type, set->handle.set);
+	printf("%s%s %s {\n", indent ? "\t" : "", type, set->handle.set);
+
+	printf("%s\ttype %s", indent ? "\t" : "", set->keytype->name);
 
-	printf("\t\ttype %s", set->keytype->name);
 	if (set->flags & SET_F_MAP)
 		printf(" : %s", set->datatype->name);
 	printf("\n");
 
 	if (set->flags & (SET_F_CONSTANT | SET_F_INTERVAL)) {
-		printf("\t\tflags ");
+		printf("%s\tflags ", indent ? "\t" : "");
+
 		if (set->flags & SET_F_CONSTANT) {
 			printf("%sconstant", delim);
 			delim = ",";
@@ -120,11 +122,11 @@ void set_print(const struct set *set)
 	}
 
 	if (set->init != NULL && set->init->size > 0) {
-		printf("\t\telements = ");
+		printf("%s\telements = ", indent ? "\t" : "");
 		expr_print(set->init);
 		printf("\n");
 	}
-	printf("\t}\n");
+	printf("%s}\n", indent ? "\t" : "");
 }
 
 struct rule *rule_alloc(const struct location *loc, const struct handle *h)
@@ -414,7 +416,7 @@ static void table_print(const struct table *table)
 		if (set->flags & SET_F_ANONYMOUS)
 			continue;
 		printf("%s", delim);
-		set_print(set);
+		set_print(set, true);
 		delim = "\n";
 	}
 	list_for_each_entry(chain, &table->chains, list) {
@@ -668,8 +670,12 @@ static int do_command_list(struct netlink_ctx *ctx, struct cmd *cmd)
 	case CMD_OBJ_SETS:
 		if (netlink_list_sets(ctx, &cmd->handle, &cmd->location) < 0)
 			return -1;
-		list_for_each_entry_safe(set, nset, &ctx->list, list)
-			list_move_tail(&set->list, &table->sets);
+		list_for_each_entry(set, &ctx->list, list){
+			if (netlink_get_setelems(ctx, &set->handle,
+						 &cmd->location, set) < 0)
+				return -1;
+			set_print(set, false);
+		}
 		break;
 	case CMD_OBJ_SET:
 		if (netlink_get_set(ctx, &cmd->handle, &cmd->location) < 0)
@@ -678,7 +684,7 @@ static int do_command_list(struct netlink_ctx *ctx, struct cmd *cmd)
 			if (netlink_get_setelems(ctx, &cmd->handle,
 						 &cmd->location, set) < 0)
 				return -1;
-			set_print(set);
+			set_print(set, false);
 		}
 		return 0;
 	default:
-- 
1.9.0

