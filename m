Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F854CE7A89
	for <netfilter-devel@archiver.kernel.org>; Sat, 23 Sep 2023 11:04:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230173AbjIWLE7 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 23 Sep 2023 07:04:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229655AbjIWLE7 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 23 Sep 2023 07:04:59 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71758124
        for <netfilter-devel@vger.kernel.org>; Sat, 23 Sep 2023 04:04:52 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1qk0RB-0002wh-Th; Sat, 23 Sep 2023 13:04:37 +0200
Date:   Sat, 23 Sep 2023 13:04:37 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Phil Sutter <phil@nwl.cc>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>
Subject: Re: [nf PATCH 2/5] netfilter: nf_tables: Add locking for
 NFT_MSG_GETRULE_RESET requests
Message-ID: <20230923110437.GB22532@breakpoint.cc>
References: <20230923013807.11398-1-phil@nwl.cc>
 <20230923013807.11398-3-phil@nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230923013807.11398-3-phil@nwl.cc>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Phil Sutter <phil@nwl.cc> wrote:
>  	table = nft_table_lookup(net, nla[NFTA_RULE_TABLE], family, genmask, 0);
>  	if (IS_ERR(table)) {
>  		NL_SET_BAD_ATTR(extack, nla[NFTA_RULE_TABLE]);
> -		return PTR_ERR(table);
> +		return ERR_CAST(table);
>  	}

Can you split that into another patch?

> +	if (info->nlh->nlmsg_flags & NLM_F_DUMP) {
> +		struct netlink_dump_control c = {
> +			.start= nf_tables_dumpreset_rules_start,
> +			.dump = nf_tables_dumpreset_rules,
> +			.done = nf_tables_dump_rules_done,
> +			.module = THIS_MODULE,
> +			.data = (void *)nla,
> +		};
> +
> +		return nft_netlink_dump_start_rcu(info->sk, skb, info->nlh, &c);
> +	}
> +
> +	if (!nla[NFTA_RULE_TABLE])
> +		return -EINVAL;
> +
> +	tablename = nla_strdup(nla[NFTA_RULE_TABLE], GFP_ATOMIC);
> +	if (!tablename)
> +		return -ENOMEM;
> +	spin_lock(&nft_net->reset_lock);

Hmm. Stupid question.  Why do we need a spinlock to serialize?
This is now a distinct function, so:

> +	spin_unlock(&nft_net->reset_lock);
> +	if (IS_ERR(skb2))
> +		return PTR_ERR(skb2);

MIssing kfree(tablename)

> +	buf = kasprintf(GFP_ATOMIC, "%s:%u", tablename, nft_net->base_seq);
> +	audit_log_nfcfg(buf, family, 1, AUDIT_NFT_OP_RULE_RESET, GFP_ATOMIC);
> +	kfree(buf);
> +	kfree(tablename);
> +
> +	return nfnetlink_unicast(skb2, info->net, portid);
>  }
>  
>  void nf_tables_rule_destroy(const struct nft_ctx *ctx, struct nft_rule *rule)
> @@ -8950,7 +9017,7 @@ static const struct nfnl_callback nf_tables_cb[NFT_MSG_MAX] = {
>  		.policy		= nft_rule_policy,
>  	},
>  	[NFT_MSG_GETRULE_RESET] = {
> -		.call		= nf_tables_getrule,
> +		.call		= nf_tables_getrule_reset,
>  		.type		= NFNL_CB_RCU,

This can be changed to CB_MUTEX, we can serialize by commit_mutex then.
