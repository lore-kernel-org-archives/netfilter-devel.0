Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3B24E732FD
	for <netfilter-devel@archiver.kernel.org>; Thu, 28 Sep 2023 17:46:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230246AbjI1Rqf (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 28 Sep 2023 13:46:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229478AbjI1Rqe (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 28 Sep 2023 13:46:34 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 616F719D
        for <netfilter-devel@vger.kernel.org>; Thu, 28 Sep 2023 10:46:33 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1qlv5q-0006o9-Ke; Thu, 28 Sep 2023 19:46:30 +0200
Date:   Thu, 28 Sep 2023 19:46:30 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Phil Sutter <phil@nwl.cc>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        netfilter-devel@vger.kernel.org
Subject: Re: [nf PATCH v2 8/8] netfilter: nf_tables: Add locking for
 NFT_MSG_GETSETELEM_RESET requests
Message-ID: <20230928174630.GD19098@breakpoint.cc>
References: <20230928165244.7168-1-phil@nwl.cc>
 <20230928165244.7168-9-phil@nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230928165244.7168-9-phil@nwl.cc>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Phil Sutter <phil@nwl.cc> wrote:
> +static int nf_tables_dumpreset_set(struct sk_buff *skb,
> +				   struct netlink_callback *cb)
> +{
> +	struct nftables_pernet *nft_net = nft_pernet(sock_net(skb->sk));
> +	struct nft_set_dump_ctx *dump_ctx = cb->data;
> +	int ret, skip = cb->args[0];
> +
> +	mutex_lock(&nft_net->commit_mutex);
> +	ret = nf_tables_dump_set(skb, cb);
> +	mutex_unlock(&nft_net->commit_mutex);
> +
> +	if (cb->args[0] > skip)
> +		audit_log_nft_set_reset(dump_ctx->ctx.table, cb->seq,
> +					cb->args[0] - skip);
> +

Once commit_mutex is dropped, parallel user can
delete table, and ctx.table references garbage.

So I think this needs to be done under mutex.

>  		c.data = &dump_ctx;
> @@ -6108,18 +6178,25 @@ static int nf_tables_getsetelem(struct sk_buff *skb,
>  	if (!nla[NFTA_SET_ELEM_LIST_ELEMENTS])
>  		return -EINVAL;
>  
> +	if (!try_module_get(THIS_MODULE))
> +		return -EINVAL;
> +	rcu_read_unlock();
> +	mutex_lock(&nft_net->commit_mutex);
> +	rcu_read_lock();

Why do we need to regain the rcu read lock here?
Are we tripping over a now bogus rcu_derefence check or is there
another reason?
