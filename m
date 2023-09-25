Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BDD4ACE7A94
	for <netfilter-devel@archiver.kernel.org>; Mon, 25 Sep 2023 10:47:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229449AbjIYKr1 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 25 Sep 2023 06:47:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229726AbjIYKr0 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 25 Sep 2023 06:47:26 -0400
Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [IPv6:2001:780:45:1d:225:90ff:fe52:c662])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1E2BAB
        for <netfilter-devel@vger.kernel.org>; Mon, 25 Sep 2023 03:47:19 -0700 (PDT)
Received: from [78.30.34.192] (port=51980 helo=gnumonks.org)
        by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <pablo@gnumonks.org>)
        id 1qkj7T-00Fvei-TU; Mon, 25 Sep 2023 12:47:17 +0200
Date:   Mon, 25 Sep 2023 12:47:14 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>
Cc:     netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>
Subject: Re: [nf PATCH 2/5] netfilter: nf_tables: Add locking for
 NFT_MSG_GETRULE_RESET requests
Message-ID: <ZRFlMjFTjKdi/8Zd@calendula>
References: <20230923013807.11398-1-phil@nwl.cc>
 <20230923013807.11398-3-phil@nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230923013807.11398-3-phil@nwl.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Sat, Sep 23, 2023 at 03:38:04AM +0200, Phil Sutter wrote:
[...]
> @@ -3598,60 +3618,107 @@ static int nf_tables_getrule(struct sk_buff *skb, const struct nfnl_info *info,
>  	struct net *net = info->net;
>  	struct nft_table *table;
>  	struct sk_buff *skb2;
> -	bool reset = false;
>  	int err;
>  
> -	if (info->nlh->nlmsg_flags & NLM_F_DUMP) {
> -		struct netlink_dump_control c = {
> -			.start= nf_tables_dump_rules_start,
> -			.dump = nf_tables_dump_rules,
> -			.done = nf_tables_dump_rules_done,
> -			.module = THIS_MODULE,
> -			.data = (void *)nla,
> -		};
> -
> -		return nft_netlink_dump_start_rcu(info->sk, skb, info->nlh, &c);
> -	}
> -
>  	table = nft_table_lookup(net, nla[NFTA_RULE_TABLE], family, genmask, 0);
>  	if (IS_ERR(table)) {
>  		NL_SET_BAD_ATTR(extack, nla[NFTA_RULE_TABLE]);
> -		return PTR_ERR(table);
> +		return ERR_CAST(table);

                return ERR_PTR(table);

for consistency and to make this batch slightly smaller?

>  	}
