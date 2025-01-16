Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFCEB86323
	for <netfilter-devel@vger.kernel.org>; Thu, 16 Jan 2025 08:32:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737016340; cv=none; b=qHg2zfaSyzkg0m+0Y4eJ3VM5s8PD19/82/k7aFlbl284J/2LE78p0ThNoAJumTPIywx979J/e+QtggTkEsHJQLVET3GzuoO3Ri+2vCuRMRZh61mZKFRkWZiy3XVQdtslhzN2Qj7amu8nqnWyvJWS81WH/9wm2I9ExtNVOAspA+Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737016340; c=relaxed/simple;
	bh=5t/Pm5rfilNfWGsDTJg0hyiSSOessIZ+WlFnR6+8qw4=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=t6zJuFuJAL3i+bJeyEu6jN1F6HdRnLh52Ij9lm1DqFFUxbFxkJjOtwAg/zFYmscCLiHgOw6AvwhHXO9Qu6/dWIFch24lykHkrAdvAs/mgi1OkSvTo50AuADBj7m7UMNge0HxX8vFcrtdIe5n+RQPMbcs35wko1qDJ6VzKsnCTe4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1tYLIS-0006KL-Rx; Thu, 16 Jan 2025 09:32:12 +0100
From: Florian Westphal <fw@strlen.de>
To: netfilter-devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH nft] parser_bison: compact and simplify list and reset syntax
Date: Thu, 16 Jan 2025 09:32:01 +0100
Message-ID: <20250116083210.250064-1-fw@strlen.de>
X-Mailer: git-send-email 2.48.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Works:
list sets
list sets inet
list sets table inet foo

Doesn't work:
list sets inet foo

Same for "list counters", "list quotas", etc.

"reset" keyword however supports this:
reset counters inet foo

and aliased this to
reset counters table inet foo

This is inconsistent and not inuitive.

Moreover, unlike "list sets", "list maps" only supported "list maps" and
"list maps inet", without the ability to only list maps of a given table.

Compact this to unify the syntax so it becomes possible to omit the "table"
keyword for either reset or list mode.

flowtables, secmarks and synproxys keywords are updated too.  "flow table"
and "meters" are NOT changed since both of these are deprecated in favor
of standard nft sets.

Reported-by: Slavko <linux@slavino.sk>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 doc/nft.txt        | 15 +++------
 src/parser_bison.y | 79 ++++++++++++----------------------------------
 2 files changed, 26 insertions(+), 68 deletions(-)

diff --git a/doc/nft.txt b/doc/nft.txt
index 846ccfb28b92..c1bb49970a22 100644
--- a/doc/nft.txt
+++ b/doc/nft.txt
@@ -587,7 +587,7 @@ section describes nft set syntax in more detail.
 [verse]
 *add set* ['family'] 'table' 'set' *{ type* 'type' | *typeof* 'expression' *;* [*flags* 'flags' *;*] [*timeout* 'timeout' *;*] [*gc-interval* 'gc-interval' *;*] [*elements = {* 'element'[*,* ...] *} ;*] [*size* 'size' *;*] [*comment* 'comment' *;*'] [*policy* 'policy' *;*] [*auto-merge ;*] *}*
 {*delete* | *destroy* | *list* | *flush* | *reset* } *set* ['family'] 'table' 'set'
-*list sets* ['family']
+*list sets* ['family'] ['table']
 *delete set* ['family'] 'table' *handle* 'handle'
 {*add* | *delete* | *destroy* } *element* ['family'] 'table' 'set' *{* 'element'[*,* ...] *}*
 
@@ -641,7 +641,7 @@ MAPS
 [verse]
 *add map* ['family'] 'table' 'map' *{ type* 'type' | *typeof* 'expression' [*flags* 'flags' *;*] [*elements = {* 'element'[*,* ...] *} ;*] [*size* 'size' *;*] [*comment* 'comment' *;*'] [*policy* 'policy' *;*] *}*
 {*delete* | *destroy* | *list* | *flush* | *reset* } *map* ['family'] 'table' 'map'
-*list maps* ['family']
+*list maps* ['family'] ['table']
 
 Maps store data based on some specific key used as input. They are uniquely identified by a user-defined name and attached to tables.
 
@@ -738,7 +738,7 @@ FLOWTABLES
 -----------
 [verse]
 {*add* | *create*} *flowtable* ['family'] 'table' 'flowtable' *{ hook* 'hook' *priority* 'priority' *; devices = {* 'device'[*,* ...] *} ; }*
-*list flowtables* ['family']
+*list flowtables* ['family'] ['table']
 {*delete* | *destroy* | *list*} *flowtable* ['family'] 'table' 'flowtable'
 *delete* *flowtable* ['family'] 'table' *handle* 'handle'
 
@@ -778,13 +778,8 @@ STATEFUL OBJECTS
 *destroy* 'counter' ['family'] 'table' *handle* 'handle'
 *destroy* 'quota' ['family'] 'table' *handle* 'handle'
 *destroy* 'limit' ['family'] 'table' *handle* 'handle'
-*list counters* ['family']
-*list quotas* ['family']
-*list limits* ['family']
-*reset counters* ['family']
-*reset quotas* ['family']
-*reset counters* ['family'] 'table'
-*reset quotas* ['family'] 'table'
+*list* { *counters* | *limits* | *quotas* } ['family'] ['table']
+*reset* { *counters* | *quotas* } ['family'] ['table']
 
 Stateful objects are attached to tables and are identified by a unique name.
 They group stateful information from rules, to reference them in rules the
diff --git a/src/parser_bison.y b/src/parser_bison.y
index c8714812532d..d8b8ef5771e5 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -723,6 +723,9 @@ int nft_lex(void *, void *, void *);
 %type <handle>			basehook_spec
 %destructor { handle_free(&$$); } basehook_spec
 
+%type <handle>			list_cmd_spec_any	list_cmd_spec_table
+%destructor { handle_free(&$$); } list_cmd_spec_any	list_cmd_spec_table
+
 %type <val>			family_spec family_spec_explicit
 %type <val32>			int_num	chain_policy
 %type <prio_spec>		extended_prio_spec prio_spec
@@ -1570,6 +1573,13 @@ get_cmd			:	ELEMENT		set_spec	set_block_expr
 			}
 			;
 
+list_cmd_spec_table	:	TABLE	table_spec	{ $$ = $2; }
+			|	table_spec
+			;
+list_cmd_spec_any	:	list_cmd_spec_table
+			|	ruleset_spec
+			;
+
 list_cmd		:	TABLE		table_spec
 			{
 				$$ = cmd_alloc(CMD_LIST, CMD_OBJ_TABLE, &$2, &@$, NULL);
@@ -1586,74 +1596,50 @@ list_cmd		:	TABLE		table_spec
 			{
 				$$ = cmd_alloc(CMD_LIST, CMD_OBJ_CHAINS, &$2, &@$, NULL);
 			}
-			|	SETS		ruleset_spec
+			|	SETS		list_cmd_spec_any
 			{
 				$$ = cmd_alloc(CMD_LIST, CMD_OBJ_SETS, &$2, &@$, NULL);
 			}
-			|	SETS		TABLE	table_spec
-			{
-				$$ = cmd_alloc(CMD_LIST, CMD_OBJ_SETS, &$3, &@$, NULL);
-			}
 			|	SET		set_spec
 			{
 				$$ = cmd_alloc(CMD_LIST, CMD_OBJ_SET, &$2, &@$, NULL);
 			}
-			|	COUNTERS	ruleset_spec
+			|	COUNTERS	list_cmd_spec_any
 			{
 				$$ = cmd_alloc(CMD_LIST, CMD_OBJ_COUNTERS, &$2, &@$, NULL);
 			}
-			|	COUNTERS	TABLE	table_spec
-			{
-				$$ = cmd_alloc(CMD_LIST, CMD_OBJ_COUNTERS, &$3, &@$, NULL);
-			}
 			|	COUNTER		obj_spec	close_scope_counter
 			{
 				$$ = cmd_alloc(CMD_LIST, CMD_OBJ_COUNTER, &$2, &@$, NULL);
 			}
-			|	QUOTAS		ruleset_spec
+			|	QUOTAS		list_cmd_spec_any
 			{
 				$$ = cmd_alloc(CMD_LIST, CMD_OBJ_QUOTAS, &$2, &@$, NULL);
 			}
-			|	QUOTAS		TABLE	table_spec
-			{
-				$$ = cmd_alloc(CMD_LIST, CMD_OBJ_QUOTAS, &$3, &@$, NULL);
-			}
 			|	QUOTA		obj_spec	close_scope_quota
 			{
 				$$ = cmd_alloc(CMD_LIST, CMD_OBJ_QUOTA, &$2, &@$, NULL);
 			}
-			|	LIMITS		ruleset_spec
+			|	LIMITS		list_cmd_spec_any
 			{
 				$$ = cmd_alloc(CMD_LIST, CMD_OBJ_LIMITS, &$2, &@$, NULL);
 			}
-			|	LIMITS		TABLE	table_spec
-			{
-				$$ = cmd_alloc(CMD_LIST, CMD_OBJ_LIMITS, &$3, &@$, NULL);
-			}
 			|	LIMIT		obj_spec	close_scope_limit
 			{
 				$$ = cmd_alloc(CMD_LIST, CMD_OBJ_LIMIT, &$2, &@$, NULL);
 			}
-			|	SECMARKS	ruleset_spec
+			|	SECMARKS	list_cmd_spec_any
 			{
 				$$ = cmd_alloc(CMD_LIST, CMD_OBJ_SECMARKS, &$2, &@$, NULL);
 			}
-			|	SECMARKS	TABLE	table_spec
-			{
-				$$ = cmd_alloc(CMD_LIST, CMD_OBJ_SECMARKS, &$3, &@$, NULL);
-			}
 			|	SECMARK		obj_spec	close_scope_secmark
 			{
 				$$ = cmd_alloc(CMD_LIST, CMD_OBJ_SECMARK, &$2, &@$, NULL);
 			}
-			|	SYNPROXYS	ruleset_spec
+			|	SYNPROXYS	list_cmd_spec_any
 			{
 				$$ = cmd_alloc(CMD_LIST, CMD_OBJ_SYNPROXYS, &$2, &@$, NULL);
 			}
-			|	SYNPROXYS	TABLE	table_spec
-			{
-				$$ = cmd_alloc(CMD_LIST, CMD_OBJ_SYNPROXYS, &$3, &@$, NULL);
-			}
 			|	SYNPROXY	obj_spec	close_scope_synproxy
 			{
 				$$ = cmd_alloc(CMD_LIST, CMD_OBJ_SYNPROXY, &$2, &@$, NULL);
@@ -1678,7 +1664,7 @@ list_cmd		:	TABLE		table_spec
 			{
 				$$ = cmd_alloc(CMD_LIST, CMD_OBJ_METER, &$2, &@$, NULL);
 			}
-			|       FLOWTABLES      ruleset_spec
+			|       FLOWTABLES      list_cmd_spec_any
 			{
 				$$ = cmd_alloc(CMD_LIST, CMD_OBJ_FLOWTABLES, &$2, &@$, NULL);
 			}
@@ -1686,7 +1672,7 @@ list_cmd		:	TABLE		table_spec
 			{
 				$$ = cmd_alloc(CMD_LIST, CMD_OBJ_FLOWTABLE, &$2, &@$, NULL);
 			}
-			|	MAPS		ruleset_spec
+			|	MAPS		list_cmd_spec_any
 			{
 				$$ = cmd_alloc(CMD_LIST, CMD_OBJ_MAPS, &$2, &@$, NULL);
 			}
@@ -1728,36 +1714,18 @@ basehook_spec		:	ruleset_spec
 			}
 			;
 
-reset_cmd		:	COUNTERS	ruleset_spec
+reset_cmd		:	COUNTERS	list_cmd_spec_any
 			{
 				$$ = cmd_alloc(CMD_RESET, CMD_OBJ_COUNTERS, &$2, &@$, NULL);
 			}
-			|	COUNTERS	table_spec
-			{
-				$$ = cmd_alloc(CMD_RESET, CMD_OBJ_COUNTERS, &$2, &@$, NULL);
-			}
-			|	COUNTERS	TABLE	table_spec
-			{
-				/* alias of previous rule. */
-				$$ = cmd_alloc(CMD_RESET, CMD_OBJ_COUNTERS, &$3, &@$, NULL);
-			}
 			|       COUNTER         obj_spec	close_scope_counter
 			{
 				$$ = cmd_alloc(CMD_RESET, CMD_OBJ_COUNTER, &$2,&@$, NULL);
 			}
-			|	QUOTAS		ruleset_spec
+			|	QUOTAS		list_cmd_spec_any
 			{
 				$$ = cmd_alloc(CMD_RESET, CMD_OBJ_QUOTAS, &$2, &@$, NULL);
 			}
-			|	QUOTAS		TABLE	table_spec
-			{
-				$$ = cmd_alloc(CMD_RESET, CMD_OBJ_QUOTAS, &$3, &@$, NULL);
-			}
-			|	QUOTAS		table_spec
-			{
-				/* alias of previous rule. */
-				$$ = cmd_alloc(CMD_RESET, CMD_OBJ_QUOTAS, &$2, &@$, NULL);
-			}
 			|       QUOTA           obj_spec	close_scope_quota
 			{
 				$$ = cmd_alloc(CMD_RESET, CMD_OBJ_QUOTA, &$2, &@$, NULL);
@@ -1766,15 +1734,10 @@ reset_cmd		:	COUNTERS	ruleset_spec
 			{
 				$$ = cmd_alloc(CMD_RESET, CMD_OBJ_RULES, &$2, &@$, NULL);
 			}
-			|	RULES		table_spec
+			|	RULES		list_cmd_spec_table
 			{
 				$$ = cmd_alloc(CMD_RESET, CMD_OBJ_TABLE, &$2, &@$, NULL);
 			}
-			|	RULES		TABLE	table_spec
-			{
-				/* alias of previous rule. */
-				$$ = cmd_alloc(CMD_RESET, CMD_OBJ_TABLE, &$3, &@$, NULL);
-			}
 			|	RULES		chain_spec
 			{
 				$$ = cmd_alloc(CMD_RESET, CMD_OBJ_CHAIN, &$2, &@$, NULL);
-- 
2.48.0

