From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nft PATCH 2/3] rule: export the ruleset using the new node "add"
Date: Tue, 17 Mar 2015 11:43:58 +0100
Message-ID: <20150317104358.GA4055@salvia>
References: <1426518371-11717-1-git-send-email-alvaroneay@gmail.com>
 <1426518371-11717-2-git-send-email-alvaroneay@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Alvaro Neira Ayuso <alvaroneay@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:58504 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932217AbbCQKkZ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 17 Mar 2015 06:40:25 -0400
Content-Disposition: inline
In-Reply-To: <1426518371-11717-2-git-send-email-alvaroneay@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Please, fix this in the library.

On Mon, Mar 16, 2015 at 04:06:10PM +0100, Alvaro Neira Ayuso wrote:
> Signed-off-by: Alvaro Neira Ayuso <alvaroneay@gmail.com>
> ---
>  src/rule.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/src/rule.c b/src/rule.c
> index 8d76fd0..b392ead 100644
> --- a/src/rule.c
> +++ b/src/rule.c
> @@ -754,7 +754,7 @@ static int do_command_export(struct netlink_ctx *ctx, struct cmd *cmd)
>  	if (rs == NULL)
>  		return -1;
>  
> -	nft_ruleset_fprintf(stdout, rs, cmd->export->format, 0);
> +	nft_ruleset_fprintf(stdout, rs, cmd->export->format, NFT_OF_EVENT_NEW);
>  	fprintf(stdout, "\n");
>  
>  	nft_ruleset_free(rs);
> -- 
> 1.7.10.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe netfilter-devel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
