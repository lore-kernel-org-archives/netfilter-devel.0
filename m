Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4CE70C64EC4
	for <netfilter-devel@archiver.kernel.org>; Wed,  8 Mar 2023 11:14:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230326AbjCHLOp (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 8 Mar 2023 06:14:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231211AbjCHLOo (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 8 Mar 2023 06:14:44 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 129E093112
        for <netfilter-devel@vger.kernel.org>; Wed,  8 Mar 2023 03:14:43 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1pZrkm-0000uL-1C; Wed, 08 Mar 2023 12:14:40 +0100
Date:   Wed, 8 Mar 2023 12:14:40 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Jeremy Sowden <jeremy@azazel.net>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH nf 0/4] NAT fixes
Message-ID: <20230308111440.GA2253@breakpoint.cc>
References: <20230307232259.2681135-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230307232259.2681135-1-jeremy@azazel.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Jeremy Sowden <jeremy@azazel.net> wrote:
> These bug-fixes were originally part of a larger series adding shifted
> port-ranges to nft NAT and targetting nf-next, but Florian suggested
> sending them via nf instead to get them upstream more quickly.
> 
> * Patches 1-3 correct the sizes in `nft_parse_register_load` calls in
>   nft_nat, nft_masq and nft_redir.
> * Patch 4 corrects a C&P mistake in an nft_redir `nft_expr_type`
>   definition.

Reviewed-by: Florian Westphal <fw@strlen.de>

