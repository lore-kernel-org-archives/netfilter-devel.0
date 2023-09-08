Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27F9EEE8006
	for <netfilter-devel@archiver.kernel.org>; Fri,  8 Sep 2023 14:01:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232157AbjIHOBS (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 8 Sep 2023 10:01:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236847AbjIHOBR (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 8 Sep 2023 10:01:17 -0400
Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [IPv6:2001:780:45:1d:225:90ff:fe52:c662])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 498B11BF5;
        Fri,  8 Sep 2023 07:01:13 -0700 (PDT)
Received: from [78.30.34.192] (port=52680 helo=gnumonks.org)
        by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <pablo@gnumonks.org>)
        id 1qec2h-00AIWO-Pv; Fri, 08 Sep 2023 16:01:09 +0200
Date:   Fri, 8 Sep 2023 16:01:02 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>
Cc:     Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org,
        audit@vger.kernel.org
Subject: Re: [nf PATCH v2] netfilter: nf_tables: Fix entries val in rule
 reset audit log
Message-ID: <ZPspHp8JTF8I214i@calendula>
References: <20230908081033.30806-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230908081033.30806-1-phil@nwl.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Phil,

On Fri, Sep 08, 2023 at 10:10:33AM +0200, Phil Sutter wrote:
> The value in idx and the number of rules handled in that particular
> __nf_tables_dump_rules() call is not identical. The former is a cursor
> to pick up from if multiple netlink messages are needed, so its value is
> ever increasing.

My (buggy) intention was to display this audit log once per chain, at
the end of the chain dump.

> Fixing this is not just a matter of subtracting s_idx
> from it, though: When resetting rules in multiple chains,
> __nf_tables_dump_rules() is called for each and cb->args[0] is not
> adjusted in between.
> 
> The audit notification in __nf_tables_dump_rules() had another problem:
> If nf_tables_fill_rule_info() failed (e.g. due to buffer exhaustion), no
> notification was sent - despite the rules having been reset already.

Hm. that should not happen, when nf_tables_fill_rule_info() fails,
that means buffer is full and userspace will invoke recvmsg() again.
The next buffer resumes from the last entry that could not fit into
the buffer.

> To catch all the above and return to a single (if possible) notification
> per table again, move audit logging back into the caller but into the
> table loop instead of past it to avoid the potential null-pointer
> deref.
> 
> This requires to trigger the notification in two spots. Care has to be
> taken in the second case as cb->args[0] is also not updated in between
> tables. This requires a helper variable as either it is the first table
> (with potential non-zero cb->args[0] cursor) or a consecutive one (with
> idx holding the current cursor already).

Your intention is to trigger one single audit log per table, right?
Did you test a chain with a large ruleset that needs several buffers
to be delivered to userspace in the netlink dump?

I would be inclined to do this once per-chain, so this can be extended
later on to display the chain. Yes, that means this will send one
audit log per chain, but this is where follow up updates will go?

> Fixes: 9b5ba5c9c5109 ("netfilter: nf_tables: Unbreak audit log reset")
> Signed-off-by: Phil Sutter <phil@nwl.cc>
> ---
> Changes since v1:
> - Use max_t() to eliminate the kernel warning
> ---
>  net/netfilter/nf_tables_api.c | 21 +++++++++++++--------
>  1 file changed, 13 insertions(+), 8 deletions(-)
> 
> diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
> index e429ebba74b3d..5a1ff10d1d2a5 100644
> --- a/net/netfilter/nf_tables_api.c
> +++ b/net/netfilter/nf_tables_api.c
> @@ -3481,9 +3481,6 @@ static int __nf_tables_dump_rules(struct sk_buff *skb,
>  		(*idx)++;
>  	}
>  
> -	if (reset && *idx)
> -		audit_log_rule_reset(table, cb->seq, *idx);
> -
>  	return 0;
>  }
>  
> @@ -3494,11 +3491,12 @@ static int nf_tables_dump_rules(struct sk_buff *skb,
>  	const struct nft_rule_dump_ctx *ctx = cb->data;
>  	struct nft_table *table;
>  	const struct nft_chain *chain;
> -	unsigned int idx = 0;
> +	unsigned int idx = 0, s_idx;
>  	struct net *net = sock_net(skb->sk);
>  	int family = nfmsg->nfgen_family;
>  	struct nftables_pernet *nft_net;
>  	bool reset = false;
> +	int ret;
>  
>  	if (NFNL_MSG_TYPE(cb->nlh->nlmsg_type) == NFT_MSG_GETRULE_RESET)
>  		reset = true;
> @@ -3529,16 +3527,23 @@ static int nf_tables_dump_rules(struct sk_buff *skb,
>  						       cb, table, chain, reset);
>  				break;
>  			}
> +			if (reset && idx > cb->args[0])
> +				audit_log_rule_reset(table, cb->seq,
> +						     idx - cb->args[0]);
>  			goto done;
>  		}
>  
> +		s_idx = max_t(long, idx, cb->args[0]);
>  		list_for_each_entry_rcu(chain, &table->chains, list) {
> -			if (__nf_tables_dump_rules(skb, &idx,
> -						   cb, table, chain, reset))
> -				goto done;
> +			ret = __nf_tables_dump_rules(skb, &idx,
> +						     cb, table, chain, reset);
> +			if (ret)
> +				break;
>  		}
> +		if (reset && idx > s_idx)
> +			audit_log_rule_reset(table, cb->seq, idx - s_idx);
>  
> -		if (ctx && ctx->table)
> +		if ((ctx && ctx->table) || ret)
>  			break;
>  	}
>  done:
> -- 
> 2.41.0
> 
