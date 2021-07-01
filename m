Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2328C11F64
	for <netfilter-devel@archiver.kernel.org>; Thu,  1 Jul 2021 09:31:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 98D366148E
	for <netfilter-devel@archiver.kernel.org>; Thu,  1 Jul 2021 09:31:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235168AbhGAJdu (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 1 Jul 2021 05:33:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235161AbhGAJdu (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 1 Jul 2021 05:33:50 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FF90C061756
        for <netfilter-devel@vger.kernel.org>; Thu,  1 Jul 2021 02:31:20 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1lyt2Q-0005vj-Pv; Thu, 01 Jul 2021 11:31:14 +0200
Date:   Thu, 1 Jul 2021 11:31:14 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Cole Dishington <Cole.Dishington@alliedtelesis.co.nz>
Cc:     pablo@netfilter.org, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH] extensions: masquerade: Add RFC-7597 section 5.1 PSID
 support
Message-ID: <20210701093114.GA2230@breakpoint.cc>
References: <20210629001608.30771-1-Cole.Dishington@alliedtelesis.co.nz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210629001608.30771-1-Cole.Dishington@alliedtelesis.co.nz>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Cole Dishington <Cole.Dishington@alliedtelesis.co.nz> wrote:
> Added --psid option to masquerade extension to specify port ranges, as
> described in RFC-7597 section 5.1. The PSID option needs the base field
> in range2, so add version 1 of the masquerade extension.
> 
> Signed-off-by: Cole Dishington <Cole.Dishington@alliedtelesis.co.nz>
> ---
>  extensions/libipt_MASQUERADE.c   | 283 +++++++++++++++++++++++++------
>  include/linux/netfilter/nf_nat.h |   5 +-

Can you add test cases too?
( extensions/libipt_MASQUERADE.t ).

The new option needs to be added to the man page as well that briefly
explains what its doing and what the --psid numbers do (ports? bits?).

> +static void MASQUERADE_help_v1(void)
> +{
> +	printf(
> +"MASQUERADE target options:\n"
> +" --to-ports <port>[-<port>]\n"
> +"				Port (range) to map to.\n"
> +" --random\n"
> +"				Randomize source port.\n"
> +" --random-fully\n"
> +"				Fully randomize source port.\n"

Consider removing the above, you can just call
MASQUERADE_help() before printf(" --psid ...

> +static void range_to_psid_args(struct nf_nat_range2 *r, unsigned int *offset,
> +			       unsigned int *psid, unsigned int *psid_length)
> +{

warning: passing argument 1 of 'range_to_psid_args' discards 'const'
qualifier from pointer target type [-Wdiscarded-qualifiers]
  239 |    range_to_psid_args(r, &offset, &psid, &psid_length);

> +	min = htons(r->min_proto.all);
> +	power_j = htons(r->max_proto.all) - min + 1;
> +	*offset = ntohs(r->base_proto.all);
> +	*psid = (min - *offset) >> _log2(power_j);
> +	*psid_length = _log2(*offset/power_j);
> +}
> +
> +static void parse_psid(const char *arg, struct nf_nat_range2 *r)
> +{
> +	char *end;
> +	unsigned int offset, psid, psid_len;
> +
> +	if (!xtables_strtoui(arg, &end, &offset, 0, UINT16_MAX) || *end != ':' ||
> +	    offset >= (1 << 16))
> +		xtables_param_act(XTF_BAD_VALUE, "MASQUERADE", "PSID settings", arg);
> +
> +	if (!xtables_strtoui(end + 1, &end, &psid, 0, UINT16_MAX) || *end != ':')
> +		xtables_param_act(XTF_BAD_VALUE, "MASQUERADE", "PSID settings", arg);
> +
> +	if (!xtables_strtoui(end + 1, &end, &psid_len, 0, UINT16_MAX) || *end != '\0' ||
> +	    psid_len >= 16)
> +		xtables_param_act(XTF_BAD_VALUE, "MASQUERADE", "PSID settings", arg);

This needs better error checking.  For example, this should
say which of the parameters (offset,len, ...) causes the parse error.

> +	psid = psid << (_log2(offset/(1 << psid_len)));

This results in infinite _log2() loop if offset / 1 << len is 0.
