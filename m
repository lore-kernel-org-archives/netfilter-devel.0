Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E584C433FE
	for <netfilter-devel@archiver.kernel.org>; Thu, 24 Nov 2022 17:05:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229581AbiKXRE7 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 24 Nov 2022 12:04:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229640AbiKXRE6 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 24 Nov 2022 12:04:58 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E21B2C108
        for <netfilter-devel@vger.kernel.org>; Thu, 24 Nov 2022 09:04:57 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1oyFeg-0001Sn-R0; Thu, 24 Nov 2022 18:04:54 +0100
Date:   Thu, 24 Nov 2022 18:04:54 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Phil Sutter <phil@nwl.cc>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>
Subject: Re: [nft PATCH 3/4] xt: Rewrite unsupported compat expression dumping
Message-ID: <20221124170454.GG2753@breakpoint.cc>
References: <20221124165641.26921-1-phil@nwl.cc>
 <20221124165641.26921-4-phil@nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221124165641.26921-4-phil@nwl.cc>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Phil Sutter <phil@nwl.cc> wrote:
> diff --git a/src/scanner.l b/src/scanner.l
> index 1371cd044b65a..4edd729c80dab 100644
> --- a/src/scanner.l
> +++ b/src/scanner.l
> @@ -214,6 +214,7 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
>  %s SCANSTATE_TCP
>  %s SCANSTATE_TYPE
>  %s SCANSTATE_VLAN
> +%s SCANSTATE_XT
>  %s SCANSTATE_CMD_EXPORT
>  %s SCANSTATE_CMD_IMPORT
>  %s SCANSTATE_CMD_LIST
> @@ -799,6 +800,8 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
>  
>  "secmark"		{ scanner_push_start_cond(yyscanner, SCANSTATE_SECMARK); return SECMARK; }
>  
> +"xt"			{ scanner_push_start_cond(yyscanner, SCANSTATE_XT); return XT; }

Why is there a new scanner state?  It has no tokens, so it doesn't do
anything.

Perhaps a leftover?  Or did you plan to make match/target/watcher scoped
tokens?
