From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nft] evaluate: fix "list set" unexpected behaviour
Date: Wed, 1 Jun 2016 11:20:56 +0200
Message-ID: <20160601092056.GA2711@salvia>
References: <20160601085117.6717-1-pablombg@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: "Pablo M. Bermudo Garay" <pablombg@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:47233 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753671AbcFAJVM (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 1 Jun 2016 05:21:12 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 78F4D1EFDA7
	for <netfilter-devel@vger.kernel.org>; Wed,  1 Jun 2016 11:21:07 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 53F0C1BDA04
	for <netfilter-devel@vger.kernel.org>; Wed,  1 Jun 2016 11:21:07 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 391A31BDA1C
	for <netfilter-devel@vger.kernel.org>; Wed,  1 Jun 2016 11:21:05 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20160601085117.6717-1-pablombg@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Jun 01, 2016 at 10:51:17AM +0200, Pablo M. Bermudo Garay wrote:
> Special sets like maps and flow tables have their own commands to be
> listed and inspected.
> 
> Before this patch, "nft list set" was able to display these special sets
> content:
> 
>   # nft list set filter test
>   table ip filter {
>           map test {
>                   type ipv4_addr : inet_service
>                   elements = { 192.168.1.101 : http-alt}
>           }
>   }
> 
> Now an error is shown:
> 
>   # nft list set filter test
>   <cmdline>:1:1-20: Error: Could not process rule: Set 'test' does not exist
>   list set filter test
>   ^^^^^^^^^^^^^^^^^^^^
> 
> Signed-off-by: Pablo M. Bermudo Garay <pablombg@gmail.com>
> ---
>  src/evaluate.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/src/evaluate.c b/src/evaluate.c
> index 423523f..86884a2 100644
> --- a/src/evaluate.c
> +++ b/src/evaluate.c
> @@ -2674,7 +2674,9 @@ static int cmd_evaluate_list(struct eval_ctx *ctx, struct cmd *cmd)
>  		if (table == NULL)
>  			return cmd_error(ctx, "Could not process rule: Table '%s' does not exist",
>  					 cmd->handle.table);
> -		if (set_lookup(table, cmd->handle.set) == NULL)
> +		set = set_lookup(table, cmd->handle.set);
> +		if (set == NULL || set->flags & SET_F_MAP ||
> +		    set->flags & SET_F_EVAL)

I'd suggest:

                    set == NULL && set->flags & (SET_F_EVAL | SET_F_MAP)

>  			return cmd_error(ctx, "Could not process rule: Set '%s' does not exist",
>  					 cmd->handle.set);
>  		return 0;
> -- 
> 2.8.3
> 
