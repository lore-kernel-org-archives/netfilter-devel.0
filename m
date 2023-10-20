Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7BC23CDB474
	for <netfilter-devel@archiver.kernel.org>; Fri, 20 Oct 2023 11:46:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377114AbjJTLqj (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 20 Oct 2023 07:46:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377298AbjJTLq3 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 20 Oct 2023 07:46:29 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EE3810C9
        for <netfilter-devel@vger.kernel.org>; Fri, 20 Oct 2023 04:46:05 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1qtnx5-00077U-Mr; Fri, 20 Oct 2023 13:46:03 +0200
Date:   Fri, 20 Oct 2023 13:46:03 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next,RFC 6/8] netfilter: nf_tables: use timestamp to
 check for set element timeout
Message-ID: <20231020114603.GF9493@breakpoint.cc>
References: <20231019141958.653727-1-pablo@netfilter.org>
 <20231019141958.653727-7-pablo@netfilter.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231019141958.653727-7-pablo@netfilter.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> @@ -10435,6 +10435,8 @@ static bool nf_tables_valid_genid(struct net *net, u32 genid)
>  	if (!genid_ok)
>  		mutex_unlock(&nft_net->commit_mutex);
>  
> +	nft_net->tstamp = get_jiffies_64();
> +

I think this should be done while mutex is still held.
Not a big deal because time won't advance by a huge margin
in case another caller comes along right after the (!genid_ok)
unlock.

>  static inline u32 nft_rhash_key(const void *data, u32 len, u32 seed)
> @@ -87,6 +88,7 @@ bool nft_rhash_lookup(const struct net *net, const struct nft_set *set,
>  		.genmask = nft_genmask_cur(net),
>  		.set	 = set,
>  		.key	 = key,
> +		.tstamp  = get_jiffies_64(),

Hmm.  This makes things significantly more complicated,
because of the 'lockless' vs. 'transactional update' problem.

It would help if we had a uniform way to tell which-is-what, e.g.
by passing the nft_ctx for the transactional case or similar.

But that this would be even more code churn, so I think its ok.

