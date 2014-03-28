From: Ana Rey <anarey@gmail.com>
Subject: [PATCH v2] nftables: Fix list of sets by family
Date: Fri, 28 Mar 2014 12:40:31 +0100
Message-ID: <008e38aa5e97439e7ac8a9e178689c2d666fa554.1396006133.git.anarey@gmail.com>
Cc: Ana Rey <anarey@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wg0-f41.google.com ([74.125.82.41]:53246 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750761AbaC1Lk5 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 28 Mar 2014 07:40:57 -0400
Received: by mail-wg0-f41.google.com with SMTP id n12so3560719wgh.24
        for <netfilter-devel@vger.kernel.org>; Fri, 28 Mar 2014 04:40:56 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Fix the result of command line 'nft list sets FAMILY'. It shows the
following error message:

"Error: syntax error, unexpected end of file, expecting string"

Now, it is possible shows right this information:

$ sudo nft -nna list sets ip
	set set_test {
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
		elements = { 127.0.0.12, 12.11.11.11}
	}

Signed-off-by: Ana Rey <anarey@gmail.com>
---
[Changes in v2]
* Delete all references regarding the indentation in the code.
* Delete all references regarding the indentation in the descriptions.
These changes were spotted by Patrick McHardy.

 src/parser.y | 2 +-
 src/rule.c   | 8 ++++++--
 2 files changed, 7 insertions(+), 3 deletions(-)

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
index b719040..00dedf5 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -668,8 +668,12 @@ static int do_command_list(struct netlink_ctx *ctx, struct cmd *cmd)
 	case CMD_OBJ_SETS:
 		if (netlink_list_sets(ctx, &cmd->handle, &cmd->location) < 0)
 			return -1;
-		list_for_each_entry_safe(set, nset, &ctx->list, list)
-			list_move_tail(&set->list, &table->sets);
+		list_for_each_entry(set, &ctx->list, list){
+			if (netlink_get_setelems(ctx, &set->handle,
+						 &cmd->location, set) < 0)
+				return -1;
+			set_print(set);
+		}
 		break;
 	case CMD_OBJ_SET:
 		if (netlink_get_set(ctx, &cmd->handle, &cmd->location) < 0)
-- 
1.9.0

