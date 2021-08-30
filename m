Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56EBCC432BE
	for <netfilter-devel@archiver.kernel.org>; Mon, 30 Aug 2021 16:40:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3274460E90
	for <netfilter-devel@archiver.kernel.org>; Mon, 30 Aug 2021 16:40:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233637AbhH3Qlj (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 30 Aug 2021 12:41:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233446AbhH3Qli (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 30 Aug 2021 12:41:38 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5E52C061575
        for <netfilter-devel@vger.kernel.org>; Mon, 30 Aug 2021 09:40:44 -0700 (PDT)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1mKkKv-0003gE-1Q; Mon, 30 Aug 2021 18:40:41 +0200
Date:   Mon, 30 Aug 2021 18:40:41 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH nft] netlink_delinearize: incorrect meta protocol
 dependency kill
Message-ID: <20210830164041.GP7616@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>
References: <20210826104952.4812-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210826104952.4812-1-pablo@netfilter.org>
Sender:  <n0-1@orbyte.nwl.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

On Thu, Aug 26, 2021 at 12:49:52PM +0200, Pablo Neira Ayuso wrote:
> meta protocol is meaningful in bridge, netdev and inet familiiess, do
> not remove this.

So you want to avoid dependency killing in above families, but:

[...]
> diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
> index 5b545701e8b7..92617a46df6f 100644
> --- a/src/netlink_delinearize.c
> +++ b/src/netlink_delinearize.c
[...]
> @@ -2005,7 +2005,22 @@ static bool meta_may_dependency_kill(struct payload_dep_ctx *ctx,
>  	case NFPROTO_BRIDGE:
>  		break;
>  	default:
> -		return true;
> +		if (dep->left->etype != EXPR_META ||
> +		    dep->right->etype != EXPR_VALUE)
> +			return false;
> +
> +		if (dep->left->meta.key == NFT_META_PROTOCOL) {
> +			protocol = mpz_get_uint16(dep->right->value);
> +
> +			if (family == NFPROTO_IPV4 &&
> +			    protocol == ETH_P_IP)
> +				return true;
> +			else if (family == NFPROTO_IPV6 &&
> +				 protocol == ETH_P_IPV6)
> +				return true;
> +		}
> +
> +		return false;
>  	}
>  
>  	if (expr->left->meta.key != NFT_META_L4PROTO)

The above code only applies to families other than inet, netdev or
bridge?! Am I missing something?

AFAIU, dependency killing defaults to true and examines the cases where
it should not happen. So the old behaviour was for unexpected dependency
expressions to just drop them instead of keeping them. The code you add
above does the opposite. That's not wrong per se, but I assume there was
a reason why dependency elimination was implemented "greedy", therefore
I kept it that way when refactoring the code.

> @@ -2015,7 +2030,8 @@ static bool meta_may_dependency_kill(struct payload_dep_ctx *ctx,
>  
>  	switch (dep->left->etype) {
>  	case EXPR_META:
> -		if (dep->left->meta.key != NFT_META_NFPROTO)
> +		if (dep->left->meta.key != NFT_META_NFPROTO &&
> +		    dep->left->meta.key != NFT_META_PROTOCOL)
>  			return true;
>  		break;
>  	case EXPR_PAYLOAD:

If we continue evaluation for 'meta protocol' payload dependencies, RHS
values need adjustment: with 'meta nfproto' we'll see NFPROTO_IPV4 or
NFPROTO_IPV6 while with 'meta protocol' we'll see ETH_P_IP or
ETH_P_IPV6. The EXPR_PAYLOAD case has such conversion code.

[...]
> diff --git a/tests/py/ip/meta.t b/tests/py/ip/meta.t
> index f733d22de2c3..fecd0caf71a7 100644
> --- a/tests/py/ip/meta.t
> +++ b/tests/py/ip/meta.t
> @@ -8,6 +8,8 @@ meta l4proto ipv6-icmp icmpv6 type nd-router-advert;ok;icmpv6 type nd-router-adv
>  meta l4proto 58 icmpv6 type nd-router-advert;ok;icmpv6 type nd-router-advert
>  icmpv6 type nd-router-advert;ok
>  
> +meta protocol ip udp dport 67;ok
> +

Hmm. Shouldn't this drop the dependency, i.e. list as 'udp dport 67' as
the family is defined by table family already?

There should also be a case for 'meta protocol ip6 udp dport 67' which
makes sure the dependency is not dropped, right?

>  meta ibrname "br0";fail
>  meta obrname "br0";fail
>  
> diff --git a/tests/py/ip/meta.t.json b/tests/py/ip/meta.t.json
> index f83864f672d5..3df31ce381fc 100644
> --- a/tests/py/ip/meta.t.json
> +++ b/tests/py/ip/meta.t.json
> @@ -140,3 +140,19 @@
>          "accept": null
>      }
>  ]
> +
> +# meta protocol ip udp dport 67
> +[
> +    {
> +        "match": {
> +            "left": {
> +                "payload": {
> +                    "field": "dport",
> +                    "protocol": "udp"
> +                }
> +            },
> +            "op": "==",
> +            "right": 67
> +        }
> +    }
> +]

This translation is not correct, the 'meta protocol' match is missing in
JSON. Even though it is not present when listing ruleset, the idea is
that JSON is identical to standard syntax input to avoid any "short
cuts" (I guess it's just a typo, other spots are fine).

[...]
> diff --git a/tests/py/ip6/meta.t b/tests/py/ip6/meta.t
> index dce97f5b0fd0..2c1aee2309a9 100644
> --- a/tests/py/ip6/meta.t
> +++ b/tests/py/ip6/meta.t
> @@ -9,5 +9,8 @@ meta l4proto icmp icmp type echo-request;ok;icmp type echo-request
>  meta l4proto 1 icmp type echo-request;ok;icmp type echo-request
>  icmp type echo-request;ok
>  
> +meta protocol ip udp dport 67;ok
> +meta protocol ip6 udp dport 67;ok
> +

Here, 'meta protocol ip6' should be dropped.

Pablo, do you want to have another look at your patch or should I try to
fix things up?

Cheers, Phil
