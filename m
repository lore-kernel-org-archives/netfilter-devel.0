Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA739C4361B
	for <netfilter-devel@archiver.kernel.org>; Mon, 14 Dec 2020 14:15:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6806C22B47
	for <netfilter-devel@archiver.kernel.org>; Mon, 14 Dec 2020 14:15:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439156AbgLNOPZ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 14 Dec 2020 09:15:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2438848AbgLNOPR (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 14 Dec 2020 09:15:17 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3828C0613CF
        for <netfilter-devel@vger.kernel.org>; Mon, 14 Dec 2020 06:14:36 -0800 (PST)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1koocV-0000XE-F8; Mon, 14 Dec 2020 15:14:35 +0100
Date:   Mon, 14 Dec 2020 15:14:35 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH xtables-nft 3/3] xtables-monitor: print packet first
Message-ID: <20201214141435.GC28824@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
References: <20201212151534.54336-1-fw@strlen.de>
 <20201212151534.54336-4-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201212151534.54336-4-fw@strlen.de>
Sender:  <n0-1@orbyte.nwl.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Sat, Dec 12, 2020 at 04:15:34PM +0100, Florian Westphal wrote:
> The trace mode should first print the packet that was received and
> then the rule/verdict.
> 
> Furthermore, the monitor did sometimes print an extra newline.
> 
> After this patch, output is more consistent with nft monitor.
> 
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
>  iptables/xtables-monitor.c | 34 +++++++++++++++++++++++-----------
>  1 file changed, 23 insertions(+), 11 deletions(-)
> 
> diff --git a/iptables/xtables-monitor.c b/iptables/xtables-monitor.c
> index 8850a12032d2..45a0d6bf1343 100644
> --- a/iptables/xtables-monitor.c
> +++ b/iptables/xtables-monitor.c
> @@ -106,6 +106,7 @@ static int rule_cb(const struct nlmsghdr *nlh, void *data)
>  		printf("-0 ");
>  		break;
>  	default:
> +		puts("");
>  		goto err_free;
>  	}
>  
> @@ -433,9 +434,18 @@ static void trace_print_packet(const struct nftnl_trace *nlt, struct cb_arg *arg
>  	mark = nftnl_trace_get_u32(nlt, NFTNL_TRACE_MARK);
>  	if (mark)
>  		printf("MARK=0x%x ", mark);
> +	puts("");
> +}
> +
> +static void trace_print_hdr(const struct nftnl_trace *nlt)
> +{
> +	printf(" TRACE: %d %08x %s:%s", nftnl_trace_get_u32(nlt, NFTNL_TABLE_FAMILY),
> +					nftnl_trace_get_u32(nlt, NFTNL_TRACE_ID),
> +					nftnl_trace_get_str(nlt, NFTNL_TRACE_TABLE),
> +					nftnl_trace_get_str(nlt, NFTNL_TRACE_CHAIN));
>  }
>  
> -static void print_verdict(struct nftnl_trace *nlt, uint32_t verdict)
> +static void print_verdict(const struct nftnl_trace *nlt, uint32_t verdict)
>  {
>  	const char *chain;
>  
> @@ -496,35 +506,37 @@ static int trace_cb(const struct nlmsghdr *nlh, struct cb_arg *arg)
>  	    arg->nfproto != nftnl_trace_get_u32(nlt, NFTNL_TABLE_FAMILY))
>  		goto err_free;
>  
> -	printf(" TRACE: %d %08x %s:%s", nftnl_trace_get_u32(nlt, NFTNL_TABLE_FAMILY),
> -					nftnl_trace_get_u32(nlt, NFTNL_TRACE_ID),
> -					nftnl_trace_get_str(nlt, NFTNL_TRACE_TABLE),
> -					nftnl_trace_get_str(nlt, NFTNL_TRACE_CHAIN));
> -
>  	switch (nftnl_trace_get_u32(nlt, NFTNL_TRACE_TYPE)) {
>  	case NFT_TRACETYPE_RULE:
>  		verdict = nftnl_trace_get_u32(nlt, NFTNL_TRACE_VERDICT);
> -		printf(":rule:0x%llx:", (unsigned long long)nftnl_trace_get_u64(nlt, NFTNL_TRACE_RULE_HANDLE));

Quite long long line here. ;)
How about using PRIx64 in the format string to avoid the cast?

> -		print_verdict(nlt, verdict);
>  
> -		if (nftnl_trace_is_set(nlt, NFTNL_TRACE_RULE_HANDLE))
> -			trace_print_rule(nlt, arg);
>  		if (nftnl_trace_is_set(nlt, NFTNL_TRACE_LL_HEADER) ||
>  		    nftnl_trace_is_set(nlt, NFTNL_TRACE_NETWORK_HEADER))
>  			trace_print_packet(nlt, arg);
> +
> +		if (nftnl_trace_is_set(nlt, NFTNL_TRACE_RULE_HANDLE)) {
> +			trace_print_hdr(nlt);
> +			printf(":rule:0x%llx:", (unsigned long long)nftnl_trace_get_u64(nlt, NFTNL_TRACE_RULE_HANDLE));

Same here.

Cheers, Phil
