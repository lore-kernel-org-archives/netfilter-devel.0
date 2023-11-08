Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7BFBEC4332F
	for <netfilter-devel@archiver.kernel.org>; Wed,  8 Nov 2023 09:13:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235460AbjKHJNS (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 8 Nov 2023 04:13:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235408AbjKHJNR (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 8 Nov 2023 04:13:17 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DEF19F
        for <netfilter-devel@vger.kernel.org>; Wed,  8 Nov 2023 01:13:15 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1r0eca-00054e-MF; Wed, 08 Nov 2023 10:13:12 +0100
Date:   Wed, 8 Nov 2023 10:13:12 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Phil Sutter <phil@nwl.cc>
Cc:     Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
Subject: Re: [iptables PATCH 1/3] arptables: Fix formatting of numeric
 --h-type output
Message-ID: <20231108091312.GB5721@breakpoint.cc>
References: <20231108033130.18747-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231108033130.18747-1-phil@nwl.cc>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Phil Sutter <phil@nwl.cc> wrote:
> Arptables expects numeric arguments to --h-type option in hexadecimal
> form, even if no '0x'-prefix is present. In contrast, it prints such
> values in decimal. This is not just inconsistent, but makes it
> impossible to save and later restore a ruleset without fixing up the
> values in between.
> 
> Assuming that the parser side can't be changed for compatibility
> reasons, fix the output side instead.
> 
> This is a day 1 bug and present in legacy arptables as well, so treat
> this as a "feature" of arptables-nft and omit a Fixes: tag.

Acked-by: Florian Westphal <fw@strlen.de>
