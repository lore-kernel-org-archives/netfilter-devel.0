Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6484D1474DA
	for <netfilter-devel@vger.kernel.org>; Sat, 11 Jan 2025 16:24:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736612689; cv=none; b=H80kLHddpgd4IYOjtTFPGpdjTj8GQQpnq9u9MeQj0gPtIdPlf9IVVd3spDVjM6wkGPaPiAgkKoa+3BOVQ+g4/GLuJYWZpqJ/b5Ew76W/YQTLkUij7x8Hfp2sqpt6H3Lh6j5ylx7G8mx9gU+eAuaBr8IKcclbZzwrYms45knoesk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736612689; c=relaxed/simple;
	bh=YkpshSjjxJYX6tE1nM7TimsUH4hCuK/Pg0FqiDJsbJU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gNE+ajBi1Pvn25qTjj93Xqt/Ohn6M05rj8n8MnUIFlfWR86jqRh9Sb0mR+uV/QDupa0fLA9gGBXj7tDvmY8xmFS/RsC6wOnhNdr7kl37Kd0pOTWsbvAX4UFhXTjtc/ACC4d+/TZ1YPV3eWFC5RvDu5MBjm84X2KM6GhyzrvVliE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1tWeI1-0005OL-Ag; Sat, 11 Jan 2025 17:24:45 +0100
Date: Sat, 11 Jan 2025 17:24:45 +0100
From: Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, fw@strlen.de, linux@slavino.sk
Subject: Re: [PATCH nft] parser_bison: simplify syntax to list all sets in
 table
Message-ID: <20250111162445.GC14912@breakpoint.cc>
References: <20250111143757.65308-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250111143757.65308-1-pablo@netfilter.org>
User-Agent: Mutt/1.10.1 (2018-07-13)

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> Revisit f99ccda252fa ("parser: allow listing sets in one table") to add
> an alias to list all sets in a given table, eg.

[..]

> diff --git a/src/parser_bison.y b/src/parser_bison.y
> index c8714812532d..ac8de398f8a7 100644
> --- a/src/parser_bison.y
> +++ b/src/parser_bison.y
> @@ -1590,8 +1590,13 @@ list_cmd		:	TABLE		table_spec
>  			{
>  				$$ = cmd_alloc(CMD_LIST, CMD_OBJ_SETS, &$2, &@$, NULL);
>  			}
> +			|	SETS		table_spec
> +			{
> +				$$ = cmd_alloc(CMD_LIST, CMD_OBJ_SETS, &$2, &@$, NULL);
> +			}
>  			|	SETS		TABLE	table_spec
>  			{
> +				/* alias of previous rule. */
>  				$$ = cmd_alloc(CMD_LIST, CMD_OBJ_SETS, &$3, &@$, NULL);
>  			}

I have concerns wrt. to ever expanding list of aliases, it causes divergence as
to what is allowed:

<keyword>
<keyword> inet
<keyword> inet foo
<keyword> table inet foo

In some cases, all of these work  (4 being aliased to 3).
In others, e.g. "counters" or "quotas" "inet foo" won't work.

It would be good to at least be consistent.  What about this?

It would be good to compact it further, this is all because of
copypastry +slow divergence on later addendums to command subsets.

 src/parser_bison.y | 63 +++++++++++++---------------------------------
 1 file changed, 17 insertions(+), 46 deletions(-)

diff --git a/src/parser_bison.y b/src/parser_bison.y
index c8714812532d..1f4e78b1b692 100644
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
@@ -1586,50 +1596,34 @@ list_cmd		:	TABLE		table_spec
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
@@ -1728,36 +1722,18 @@ basehook_spec		:	ruleset_spec
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
@@ -1766,15 +1742,10 @@ reset_cmd		:	COUNTERS	ruleset_spec
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
