Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D85FAC2BB9A
	for <netfilter-devel@archiver.kernel.org>; Mon, 14 Dec 2020 14:29:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 91CF32222B
	for <netfilter-devel@archiver.kernel.org>; Mon, 14 Dec 2020 14:29:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2440049AbgLNOUC (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 14 Dec 2020 09:20:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2440042AbgLNOUC (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 14 Dec 2020 09:20:02 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9B09C0613CF
        for <netfilter-devel@vger.kernel.org>; Mon, 14 Dec 2020 06:19:19 -0800 (PST)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1kooh4-0000fA-DC; Mon, 14 Dec 2020 15:19:18 +0100
Date:   Mon, 14 Dec 2020 15:19:18 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH xtables-nft 1/3] xtables-monitor: fix rule printing
Message-ID: <20201214141918.GD28824@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
References: <20201212151534.54336-1-fw@strlen.de>
 <20201212151534.54336-2-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201212151534.54336-2-fw@strlen.de>
Sender:  <n0-1@orbyte.nwl.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Sat, Dec 12, 2020 at 04:15:32PM +0100, Florian Westphal wrote:
> trace_print_rule does a rule dump.  This prints unrelated rules
> in the same chain.  Instead the function should only request the
> specific handle.
> 
> Furthermore, flush output buffer afterwards so this plays nice when
> output isn't a terminal.
> 
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
>  iptables/xtables-monitor.c | 32 +++++++++++++++-----------------
>  1 file changed, 15 insertions(+), 17 deletions(-)
> 
> diff --git a/iptables/xtables-monitor.c b/iptables/xtables-monitor.c
> index 4008cc00d469..364e600e1b38 100644
> --- a/iptables/xtables-monitor.c
> +++ b/iptables/xtables-monitor.c
> @@ -227,12 +227,12 @@ static void trace_print_rule(const struct nftnl_trace *nlt, struct cb_arg *args)
>  		exit(EXIT_FAILURE);
>  	}
>  
> -	nlh = nftnl_chain_nlmsg_build_hdr(buf, NFT_MSG_GETRULE, family, NLM_F_DUMP, 0);
> +	nlh = nftnl_chain_nlmsg_build_hdr(buf, NFT_MSG_GETRULE, family, 0, 0);
>  
>          nftnl_rule_set_u32(r, NFTNL_RULE_FAMILY, family);
>  	nftnl_rule_set_str(r, NFTNL_RULE_CHAIN, chain);
>  	nftnl_rule_set_str(r, NFTNL_RULE_TABLE, table);
> -	nftnl_rule_set_u64(r, NFTNL_RULE_POSITION, handle);
> +	nftnl_rule_set_u64(r, NFTNL_RULE_HANDLE, handle);
>  	nftnl_rule_nlmsg_build_payload(nlh, r);
>  	nftnl_rule_free(r);
>  
> @@ -248,24 +248,21 @@ static void trace_print_rule(const struct nftnl_trace *nlt, struct cb_arg *args)
>  	}
>  
>  	portid = mnl_socket_get_portid(nl);
> -        if (mnl_socket_sendto(nl, nlh, nlh->nlmsg_len) < 0) {
> -                perror("mnl_socket_send");
> -                exit(EXIT_FAILURE);
> -        }
> +	if (mnl_socket_sendto(nl, nlh, nlh->nlmsg_len) < 0) {
> +		perror("mnl_socket_send");
> +		exit(EXIT_FAILURE);
> +	}

Just in case someone else wonders as well: This does a whitespace
cleanup, replacing spaces by tabs. Later changes contain the same
cleanup, too.

Cheers, Phil
