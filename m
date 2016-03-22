From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nft PATCH 1/2] src/parser_bison: fix ruleid_spec ambiguity
Date: Tue, 22 Mar 2016 19:40:11 +0100
Message-ID: <20160322184011.GA3278@salvia>
References: <145832936930.1466.10807188686798508369.stgit@nfdev2.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, sander.contrib@gmail.com
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:36204 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750728AbcCVSkX (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 22 Mar 2016 14:40:23 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id BF16BC1240
	for <netfilter-devel@vger.kernel.org>; Tue, 22 Mar 2016 19:40:21 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id AFA17DA38E
	for <netfilter-devel@vger.kernel.org>; Tue, 22 Mar 2016 19:40:21 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 78E23DA380
	for <netfilter-devel@vger.kernel.org>; Tue, 22 Mar 2016 19:40:16 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <145832936930.1466.10807188686798508369.stgit@nfdev2.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Arturo,

On Fri, Mar 18, 2016 at 08:29:29PM +0100, Arturo Borrero Gonzalez wrote:
> Currently, parser allows both 'handle' and 'position' as part of the
> same grammar rule. But we don't combine them in any case actually.
> 
> As a result of this, deleting rules using "position" keyword deletes all
> rules for chain.
> 
> Split the ruleid_spec in two types:
>  * one for handles
>  * one for positions
> 
> This change complies with the syntax/grammar described currently in the wiki.
> 
> Netfilter bug: http://bugzilla.netfilter.org/show_bug.cgi?id=965
> Reported-by: Jesper Sander Lindgren <sander.contrib@gmail.com>
> Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
> ---
>  src/parser_bison.y |   26 +++++++++++++++++---------
>  1 file changed, 17 insertions(+), 9 deletions(-)
> 
> diff --git a/src/parser_bison.y b/src/parser_bison.y
> index 9e86f26..5ff69ef 100644
> --- a/src/parser_bison.y
> +++ b/src/parser_bison.y
> @@ -419,8 +419,8 @@ static void location_update(struct location *loc, struct location *rhs, int n)
>  %type <cmd>			base_cmd add_cmd replace_cmd create_cmd insert_cmd delete_cmd list_cmd flush_cmd rename_cmd export_cmd monitor_cmd describe_cmd
>  %destructor { cmd_free($$); }	base_cmd add_cmd replace_cmd create_cmd insert_cmd delete_cmd list_cmd flush_cmd rename_cmd export_cmd monitor_cmd describe_cmd
>  
> -%type <handle>			table_spec chain_spec chain_identifier ruleid_spec ruleset_spec
> -%destructor { handle_free(&$$); } table_spec chain_spec chain_identifier ruleid_spec ruleset_spec
> +%type <handle>			table_spec chain_spec chain_identifier rulehandle_spec ruleposition_spec ruleset_spec
> +%destructor { handle_free(&$$); } table_spec chain_spec chain_identifier rulehandle_spec ruleposition_spec ruleset_spec
>  %type <handle>			set_spec set_identifier
>  %destructor { handle_free(&$$); } set_spec set_identifier
>  %type <val>			handle_spec family_spec family_spec_explicit position_spec chain_policy prio_spec
> @@ -704,11 +704,11 @@ add_cmd			:	TABLE		table_spec
>  				close_scope(state);
>  				$$ = cmd_alloc(CMD_ADD, CMD_OBJ_CHAIN, &$2, &@$, $5);
>  			}
> -			|	RULE		ruleid_spec	rule
> +			|	RULE		ruleposition_spec	rule
>  			{
>  				$$ = cmd_alloc(CMD_ADD, CMD_OBJ_RULE, &$2, &@$, $3);
>  			}
> -			|	/* empty */	ruleid_spec	rule
> +			|	/* empty */	ruleposition_spec	rule
>  			{
>  				$$ = cmd_alloc(CMD_ADD, CMD_OBJ_RULE, &$1, &@$, $2);
>  			}
> @@ -732,7 +732,7 @@ add_cmd			:	TABLE		table_spec
>  			}
>  			;
>  
> -replace_cmd		:	RULE		ruleid_spec	rule
> +replace_cmd		:	RULE		rulehandle_spec	rule
>  			{
>  				$$ = cmd_alloc(CMD_REPLACE, CMD_OBJ_RULE, &$2, &@$, $3);
>  			}
> @@ -763,7 +763,7 @@ create_cmd		:	TABLE		table_spec
>  			}
>  			;
>  
> -insert_cmd		:	RULE		ruleid_spec	rule
> +insert_cmd		:	RULE		ruleposition_spec	rule
>  			{
>  				$$ = cmd_alloc(CMD_INSERT, CMD_OBJ_RULE, &$2, &@$, $3);
>  			}
> @@ -777,7 +777,7 @@ delete_cmd		:	TABLE		table_spec
>  			{
>  				$$ = cmd_alloc(CMD_DELETE, CMD_OBJ_CHAIN, &$2, &@$, NULL);
>  			}
> -			|	RULE		ruleid_spec
> +			|	RULE		rulehandle_spec
>  			{
>  				$$ = cmd_alloc(CMD_DELETE, CMD_OBJ_RULE, &$2, &@$, NULL);
>  			}
> @@ -1236,11 +1236,19 @@ position_spec		:	/* empty */
>  			}
>  			;
>  
> -ruleid_spec		:	chain_spec	handle_spec	position_spec
> +rulehandle_spec		:	chain_spec	handle_spec
>  			{
>  				$$		= $1;
>  				$$.handle	= $2;
> -				$$.position	= $3;
> +				$$.position	= 0;
> +			}
> +			;
> +
> +ruleposition_spec	:	chain_spec	position_spec
> +			{
> +				$$		= $1;
> +				$$.handle	= 0;
> +				$$.position	= $2;

I think this patch will be more simple if you attack this problem from
the evaluation step, ie. from cmd_evaluate_add() and such depending on
the command.

Thanks!
