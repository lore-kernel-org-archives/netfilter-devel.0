Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B64C5C6FD1D
	for <netfilter-devel@archiver.kernel.org>; Tue, 14 Mar 2023 22:22:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230263AbjCNWWX (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 14 Mar 2023 18:22:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230045AbjCNWWW (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 14 Mar 2023 18:22:22 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4144D187
        for <netfilter-devel@vger.kernel.org>; Tue, 14 Mar 2023 15:21:48 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     phil@nwl.cc
Subject: [PATCH nft,v3] parser_bison: simplify reset syntax
Date:   Tue, 14 Mar 2023 23:20:33 +0100
Message-Id: <20230314222033.828809-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Simplify:

*reset rules* *chain* ['family'] 'table' ['chain]'
to
*reset rules* ['family'] 'table' 'chain'

*reset rules* *table* ['family'] 'table'
to
*reset rules* ['family'] 'table'

*reset counters* ['family'] *table* 'table'
to
*reset counters* ['family'] 'table'

*reset quotas* ['family'] *table* 'table'
to
*reset quotas* ['family'] 'table'

Previous syntax remains in place for backward compatibility.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v3: use *reset rules* ['family'] ['table' ['chain']] per Phil.

 doc/nft.txt        |  8 +++-----
 src/parser_bison.y | 20 ++++++++++++++++++++
 2 files changed, 23 insertions(+), 5 deletions(-)

diff --git a/doc/nft.txt b/doc/nft.txt
index 0d60c7520d31..83f0f8bb155a 100644
--- a/doc/nft.txt
+++ b/doc/nft.txt
@@ -490,9 +490,7 @@ RULES
 *replace rule* ['family'] 'table' 'chain' *handle* 'handle' 'statement' ... [*comment* 'comment']
 {*delete* | *reset*} *rule* ['family'] 'table' 'chain' *handle* 'handle'
 *destroy rule* ['family'] 'table' 'chain' *handle* 'handle'
-*reset rules* ['family']
-*reset rules* *table* ['family'] 'table'
-*reset rules* *chain* ['family'] 'table' ['chain']
+*reset rules* ['family'] ['table' ['chain']]
 
 Rules are added to chains in the given table. If the family is not specified, the
 ip family is used. Rules are constructed from two kinds of components according
@@ -762,8 +760,8 @@ STATEFUL OBJECTS
 *list limits* ['family']
 *reset counters* ['family']
 *reset quotas* ['family']
-*reset counters* ['family'] *table* 'table'
-*reset quotas* ['family'] *table* 'table'
+*reset counters* ['family'] 'table'
+*reset quotas* ['family'] 'table'
 
 Stateful objects are attached to tables and are identified by a unique name.
 They group stateful information from rules, to reference them in rules the
diff --git a/src/parser_bison.y b/src/parser_bison.y
index ccedfafe1bfa..e4f21ca1a722 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -1650,11 +1650,16 @@ basehook_spec		:	ruleset_spec
 			;
 
 reset_cmd		:	COUNTERS	ruleset_spec
+			{
+				$$ = cmd_alloc(CMD_RESET, CMD_OBJ_COUNTERS, &$2, &@$, NULL);
+			}
+			|	COUNTERS	table_spec
 			{
 				$$ = cmd_alloc(CMD_RESET, CMD_OBJ_COUNTERS, &$2, &@$, NULL);
 			}
 			|	COUNTERS	TABLE	table_spec
 			{
+				/* alias of previous rule. */
 				$$ = cmd_alloc(CMD_RESET, CMD_OBJ_COUNTERS, &$3, &@$, NULL);
 			}
 			|       COUNTER         obj_spec	close_scope_counter
@@ -1669,6 +1674,11 @@ reset_cmd		:	COUNTERS	ruleset_spec
 			{
 				$$ = cmd_alloc(CMD_RESET, CMD_OBJ_QUOTAS, &$3, &@$, NULL);
 			}
+			|	QUOTAS		table_spec
+			{
+				/* alias of previous rule. */
+				$$ = cmd_alloc(CMD_RESET, CMD_OBJ_QUOTAS, &$2, &@$, NULL);
+			}
 			|       QUOTA           obj_spec	close_scope_quota
 			{
 				$$ = cmd_alloc(CMD_RESET, CMD_OBJ_QUOTA, &$2, &@$, NULL);
@@ -1677,12 +1687,22 @@ reset_cmd		:	COUNTERS	ruleset_spec
 			{
 				$$ = cmd_alloc(CMD_RESET, CMD_OBJ_RULES, &$2, &@$, NULL);
 			}
+			|	RULES		table_spec
+			{
+				$$ = cmd_alloc(CMD_RESET, CMD_OBJ_RULES, &$2, &@$, NULL);
+			}
 			|	RULES		TABLE	table_spec
 			{
+				/* alias of previous rule. */
 				$$ = cmd_alloc(CMD_RESET, CMD_OBJ_RULES, &$3, &@$, NULL);
 			}
+			|	RULES		chain_spec
+			{
+				$$ = cmd_alloc(CMD_RESET, CMD_OBJ_RULES, &$2, &@$, NULL);
+			}
 			|	RULES		CHAIN	chain_spec
 			{
+				/* alias of previous rule. */
 				$$ = cmd_alloc(CMD_RESET, CMD_OBJ_RULES, &$3, &@$, NULL);
 			}
 			|	RULE		ruleid_spec
-- 
2.30.2

