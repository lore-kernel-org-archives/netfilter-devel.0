From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 5/5, V2, nft] Implement deleting rule by description
Date: Mon, 8 Aug 2016 16:46:16 +0200
Message-ID: <20160808144616.GA6264@salvia>
References: <20160808111758.4062-1-carlosfg@riseup.net>
 <20160808124235.11135-1-carlosfg@riseup.net>
 <20160808124235.11135-5-carlosfg@riseup.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: netfilter-devel@vger.kernel.org
To: Carlos Falgueras =?iso-8859-1?Q?Garc=EDa?= <carlosfg@riseup.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:42772 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752268AbcHHOqW (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 8 Aug 2016 10:46:22 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 74DAE1D102C
	for <netfilter-devel@vger.kernel.org>; Mon,  8 Aug 2016 16:46:20 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 654EB1B3357
	for <netfilter-devel@vger.kernel.org>; Mon,  8 Aug 2016 16:46:20 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 3283A1B3357
	for <netfilter-devel@vger.kernel.org>; Mon,  8 Aug 2016 16:46:18 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20160808124235.11135-5-carlosfg@riseup.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Aug 08, 2016 at 02:42:35PM +0200, Carlos Falgueras García wrote:
> 	$ nft list -a ruleset
> 	table ip t {
> 		chain c {
> 			ip saddr 1.1.1.1 counter packets 0 bytes 0 # handle 1
> 			ip saddr 1.1.1.2 counter packets 0 bytes 0 # handle 2
> 			ip saddr 1.1.1.2 counter packets 0 bytes 0 # handle 3
> 			ip saddr 1.1.1.4 counter packets 0 bytes 0 # handle 4
> 		}
> 	}
> 
> Before this patch:
> 	$ nft delete rule table chain ip saddr 1.1.1.2 counter
> 	<cmdline>:1:17-18: Error: syntax error, unexpected ip, expecting end of
> 	file or newline or semicolon
> 	delete rule t c ip saddr 1.1.1.2 counter
> 	                ^^
> After this patch:

Please, remove all this above. I suggest a description like:

This patch introduces deletion in a similar fashion as in iptables,
thus, we can delete the first rule that matches our description, for
example:

> 	$ nft delete rule table chain ip saddr 1.1.1.2 counter
> 	$ nft list -a ruleset
> 	table ip t {
> 		chain c {
> 			ip saddr 1.1.1.1 counter packets 0 bytes 0 # handle 1
> 			ip saddr 1.1.1.2 counter packets 0 bytes 0 # handle 3
> 			ip saddr 1.1.1.4 counter packets 0 bytes 0 # handle 4
> 		}
> 	}

More comments below.

> Signed-off-by: Carlos Falgueras García <carlosfg@riseup.net>
> ---
>  src/evaluate.c     |  7 +++++++
>  src/parser_bison.y | 28 +++++++++++++++++++++-------
>  src/rule.c         | 45 +++++++++++++++++++++++++++++++++++++++++++--
>  3 files changed, 71 insertions(+), 9 deletions(-)
> 
> diff --git a/src/evaluate.c b/src/evaluate.c
> index 4611969..efd5f69 100644
> --- a/src/evaluate.c
> +++ b/src/evaluate.c
> @@ -2573,8 +2573,15 @@ static int cmd_evaluate_delete(struct eval_ctx *ctx, struct cmd *cmd)
>  			return ret;
>  
>  		return setelem_evaluate(ctx, &cmd->expr);
> +		break;

Why this new break?

>  	case CMD_OBJ_SET:
>  	case CMD_OBJ_RULE:
> +		// CMD_LIST force caching all ruleset

Please, no C++ comment style, use /* ... */.

> +		ret = cache_update(CMD_LIST, ctx->msgs);
> +		if (ret < 0)
> +			return ret;
> +		return rule_evaluate(ctx, cmd->rule);
> +		break;

No need for break here either.

>  	case CMD_OBJ_CHAIN:
>  	case CMD_OBJ_TABLE:
>  		return 0;
