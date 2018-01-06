From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] parser_bison: extend nft to delete table via table handle
Date: Sat, 6 Jan 2018 23:59:36 +0100
Message-ID: <20180106225936.xarzjaqu3vl3f4ab@salvia>
References: <20180106182729.11454-1-harshasharmaiitr@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Harsha Sharma <harshasharmaiitr@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:38382 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753698AbeAFW7n (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 6 Jan 2018 17:59:43 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 9E86AC1061
        for <netfilter-devel@vger.kernel.org>; Sat,  6 Jan 2018 23:59:41 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 8EA21DA848
        for <netfilter-devel@vger.kernel.org>; Sat,  6 Jan 2018 23:59:41 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20180106182729.11454-1-harshasharmaiitr@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, Jan 06, 2018 at 11:57:29PM +0530, Harsha Sharma wrote:
> This patch allows deletion of table via unique table handles which can
> be listed with '-a' option.
> For.eg.
> nft delete table handle 4
> 
> Signed-off-by: Harsha Sharma <harshasharmaiitr@gmail.com>
> ---
>  src/parser_bison.y | 14 ++++++++++++--
>  1 file changed, 12 insertions(+), 2 deletions(-)
> 
> diff --git a/src/parser_bison.y b/src/parser_bison.y
> index 6e85a62..a7c8bbf 100644
> --- a/src/parser_bison.y
> +++ b/src/parser_bison.y
> @@ -495,8 +495,8 @@ int nft_lex(void *, void *, void *);
>  %type <cmd>			base_cmd add_cmd replace_cmd create_cmd insert_cmd delete_cmd list_cmd reset_cmd flush_cmd rename_cmd export_cmd monitor_cmd describe_cmd
>  %destructor { cmd_free($$); }	base_cmd add_cmd replace_cmd create_cmd insert_cmd delete_cmd list_cmd reset_cmd flush_cmd rename_cmd export_cmd monitor_cmd describe_cmd
>  
> -%type <handle>			table_spec chain_spec chain_identifier ruleid_spec handle_spec position_spec rule_position ruleset_spec
> -%destructor { handle_free(&$$); } table_spec chain_spec chain_identifier ruleid_spec handle_spec position_spec rule_position ruleset_spec
> +%type <handle>			table_spec tableid_spec chain_spec chain_identifier ruleid_spec handle_spec position_spec rule_position ruleset_spec
> +%destructor { handle_free(&$$); } table_spec tableid_spec chain_spec chain_identifier ruleid_spec handle_spec position_spec rule_position ruleset_spec
>  %type <handle>			set_spec set_identifier obj_spec obj_identifier
>  %destructor { handle_free(&$$); } set_spec set_identifier obj_spec obj_identifier
>  %type <val>			family_spec family_spec_explicit chain_policy prio_spec
> @@ -978,6 +978,10 @@ delete_cmd		:	TABLE		table_spec
>  			{
>  				$$ = cmd_alloc(CMD_DELETE, CMD_OBJ_TABLE, &$2, &@$, NULL);
>  			}
> +			|	TABLE 		tableid_spec

Use handle_spec instead, so we don't need the empty tableid_spec.

BTW, where is the HANDLE token in the grammar? Did you test

        nft delete table handle 4

that really works?
