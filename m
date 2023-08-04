Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6EA1CC04A6A
	for <netfilter-devel@archiver.kernel.org>; Fri,  4 Aug 2023 16:22:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229459AbjHDQWD (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 4 Aug 2023 12:22:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229545AbjHDQWC (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 4 Aug 2023 12:22:02 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 603E92D71
        for <netfilter-devel@vger.kernel.org>; Fri,  4 Aug 2023 09:22:00 -0700 (PDT)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1qRxYs-0001lV-6l; Fri, 04 Aug 2023 18:21:58 +0200
Date:   Fri, 4 Aug 2023 18:21:58 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org, robert.smith51@protonmail.com
Subject: Re: [PATCH iptables] nft-ruleparse: parse meta mark set as MARK
 target
Message-ID: <ZM0lptBHzgTMV24n@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org,
        robert.smith51@protonmail.com
References: <20230803193917.26779-1-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230803193917.26779-1-fw@strlen.de>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Aug 03, 2023 at 09:39:13PM +0200, Florian Westphal wrote:
> Mixing nftables and iptables-nft in the same table doesn't work,
> but some people do this.
> 
> v1.8.8 ignored rules it could not represent in iptables syntax,
> v1.8.9 bails in this case.
> 
> Add parsing of meta mark expressions so iptables-nft can render them
> as -j MARK rules.
> 
> This is flawed, nft has features that have no corresponding
> syntax in iptables, but we can't undo this.
> 
> Link: https://bugzilla.netfilter.org/show_bug.cgi?id=1659

Intentionally not "Closes:"?

> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
>  iptables/nft-ruleparse.c | 83 +++++++++++++++++++++++++++-------------
>  1 file changed, 56 insertions(+), 27 deletions(-)
> 
> diff --git a/iptables/nft-ruleparse.c b/iptables/nft-ruleparse.c
> index edbbfa40e9c4..44b9bcc268f4 100644
> --- a/iptables/nft-ruleparse.c
> +++ b/iptables/nft-ruleparse.c
> @@ -84,6 +84,37 @@ nft_create_match(struct nft_xt_ctx *ctx,
>  	return match->m->data;
>  }
>  
> +static void *
> +nft_create_target(struct nft_xt_ctx *ctx,
> +		  struct iptables_command_state *cs,
> +		  const char *name)

Please hold back a bit, I have a better implementation of this function
lingering locally. Will adjust and submit both in a minute.

Thanks, Phil
