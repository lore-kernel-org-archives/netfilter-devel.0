Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38EDAFA3742
	for <netfilter-devel@archiver.kernel.org>; Fri, 28 Oct 2022 16:38:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229678AbiJ1QiJ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 28 Oct 2022 12:38:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229647AbiJ1Qh7 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 28 Oct 2022 12:37:59 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 592E81DF43E
        for <netfilter-devel@vger.kernel.org>; Fri, 28 Oct 2022 09:37:58 -0700 (PDT)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1ooSMm-0000W1-2L; Fri, 28 Oct 2022 18:37:56 +0200
Date:   Fri, 28 Oct 2022 18:37:56 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH iptables-nft] nft: disscect basic icmp type/code match
Message-ID: <Y1wFZCWWdoU3sVQO@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Florian Westphal <fw@strlen.de>,
        netfilter-devel <netfilter-devel@vger.kernel.org>
References: <20221021100208.7654-1-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221021100208.7654-1-fw@strlen.de>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi!

There's a typo in subject: s/disscect/dissect/

Other than that:

On Fri, Oct 21, 2022 at 12:02:08PM +0200, Florian Westphal wrote:
[...]
> +static void nft_parse_icmp(struct nft_xt_ctx *ctx,
> +			   struct nft_xt_ctx_reg *sreg,
> +			   struct nftnl_expr *e,
> +			   struct iptables_command_state *cs,
> +			   const char *name)
> +{
> +	struct xtables_rule_match *m;
> +	struct xtables_match *match;
> +	struct ipt_icmp *icmp;
> +	const uint8_t *v;
> +	unsigned int len;
> +	int op;
> +
> +	v = nftnl_expr_get(e, NFTNL_EXPR_CMP_DATA, &len);
> +	switch (sreg->payload.offset) {
> +	case 0:
> +		if (len == 1 || len == 2)
> +			break;
> +		return;

At this point the match is ignored and the rule "loaded" without it. Not
that we don't lack error handling in other spots, so this is fine for
now. We should really fix it, though and mark the whole rule as
incompatible. Maybe even a replacement for the overly simple
nft_is_expr_compatible() (and callers)?

Cheers, Phil
