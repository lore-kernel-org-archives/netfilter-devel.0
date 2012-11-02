From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Subject: Re: [PATCH 2/2] netfilter: nf_tables: improve deletion performance
Date: Fri, 02 Nov 2012 11:05:32 +0200
Message-ID: <50938CDC.4000902@linux.intel.com>
References: <1351785744-7492-1-git-send-email-pablo@netfilter.org> <1351785744-7492-3-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:55531 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753802Ab2KBJFy (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 2 Nov 2012 05:05:54 -0400
In-Reply-To: <1351785744-7492-3-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Pablo,

> --- a/net/netfilter/nf_tables_api.c
> +++ b/net/netfilter/nf_tables_api.c
> @@ -1289,7 +1289,7 @@ static void nf_tables_rule_destroy(const struct nft_ctx *ctx,
>   		nf_tables_expr_destroy(ctx, expr);
>   		expr = nft_expr_next(expr);
>   	}
> -	kfree(rule);
> +	kfree_rcu(rule, rcu_head);
>   }

Shouldn't it free the expression list at the same moment when the rule 
will actually be freed?
So call_rcu() instead of kfree_rcu().

Tomasz

