Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB22EC11F65
	for <netfilter-devel@archiver.kernel.org>; Wed, 30 Jun 2021 15:13:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D11F661476
	for <netfilter-devel@archiver.kernel.org>; Wed, 30 Jun 2021 15:13:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235466AbhF3PPx (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 30 Jun 2021 11:15:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235417AbhF3PPx (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 30 Jun 2021 11:15:53 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57DC3C061756
        for <netfilter-devel@vger.kernel.org>; Wed, 30 Jun 2021 08:13:24 -0700 (PDT)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1lybtv-00020X-DS; Wed, 30 Jun 2021 17:13:19 +0200
Date:   Wed, 30 Jun 2021 17:13:19 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Eric Garver <e@erig.me>
Subject: Re: [PATCH nft v2 1/3] netlink_delinearize: add missing icmp
 id/sequence support
Message-ID: <20210630151319.GZ3673@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org,
        Pablo Neira Ayuso <pablo@netfilter.org>, Eric Garver <e@erig.me>
References: <20210615160151.10594-1-fw@strlen.de>
 <20210615160151.10594-2-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210615160151.10594-2-fw@strlen.de>
Sender:  <n0-1@orbyte.nwl.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

On Tue, Jun 15, 2021 at 06:01:49PM +0200, Florian Westphal wrote:
> Pablo reports following input and output:
> in: icmpv6 id 1
> out: icmpv6 type { echo-request, echo-reply } icmpv6 parameter-problem 65536/16
> 
> Reason is that icmp fields overlap, decoding of the correct name requires
> check of the icmpv6 type.  This only works for equality tests, for
> instance
> 
> in: icmpv6 type echo-request icmpv6 id 1
> will be listed as "icmpv6 id 1" (which is not correct either, since the
> input only matches on echo-request).
> 
> with this patch, output of 'icmpv6 id 1' is
> icmpv6 type { echo-request, echo-reply } icmpv6 id 1
> 
> The second problem, the removal of a single check (request OR reply),
> is resolved in the followup patch.
> 
> Signed-off-by: Florian Westphal <fw@strlen.de>

Eric reported a testcase in which this patch seems to cause a segfault
(bisected). The test is as simple as:

| nft -f - <<EOF
| add table inet firewalld_check_rule_index
| add chain inet firewalld_check_rule_index foobar { type filter hook input priority 0 ; }
| add rule inet firewalld_check_rule_index foobar tcp dport 1234 accept
| add rule inet firewalld_check_rule_index foobar accept
| insert rule inet firewalld_check_rule_index foobar index 1 udp dport 4321 accept
| EOF

But a ruleset is in place at this time. Also, I can't reproduce it on my
own machine but only on Eric's VM for testing.

[...]
>  static void payload_match_postprocess(struct rule_pp_ctx *ctx,
>  				      struct expr *expr,
>  				      struct expr *payload)
> @@ -1883,6 +1932,19 @@ static void payload_match_postprocess(struct rule_pp_ctx *ctx,
>  		if (expr->right->etype == EXPR_VALUE) {
>  			payload_match_expand(ctx, expr, payload);
>  			break;
> +		} else if (expr->right->etype == EXPR_SET_REF) {
> +			struct set *set = expr->right->set;
> +
> +			if (set_is_anonymous(set->flags) &&
> +			    !list_empty(&set->init->expressions)) {

According to GDB, set->init is NULL here.

I am not familiar with recent changes in cache code, maybe there's the
actual culprit: Debug printf in cache_init_objects() states flags
variable is 0x4000005f, i.e. NFT_CACHE_SETELEM_BIT is not set.

I am not sure if caching is incomplete and we need that bit or if the
above code should expect sets with missing elements and therefore check
'set->init != NULL' before accessing expressions field.

Cheers, Phil
