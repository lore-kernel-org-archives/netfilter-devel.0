Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BAE8BC433EF
	for <netfilter-devel@archiver.kernel.org>; Fri, 22 Oct 2021 00:04:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 918CC6101D
	for <netfilter-devel@archiver.kernel.org>; Fri, 22 Oct 2021 00:04:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231326AbhJVAHL (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 21 Oct 2021 20:07:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229512AbhJVAHL (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 21 Oct 2021 20:07:11 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80AFAC061764;
        Thu, 21 Oct 2021 17:04:54 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1mdi3H-0003kx-K4; Fri, 22 Oct 2021 02:04:51 +0200
Date:   Fri, 22 Oct 2021 02:04:51 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Florian Westphal <fw@strlen.de>
Cc:     Eugene Crosser <crosser@average.org>, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, dsahern@kernel.org,
        pablo@netfilter.org, lschlesinger@drivenets.com
Subject: Re: [PATCH net-next 2/2] vrf: run conntrack only in context of
 lower/physdev for locally generated packets
Message-ID: <20211022000451.GG7604@breakpoint.cc>
References: <20211021144857.29714-1-fw@strlen.de>
 <20211021144857.29714-3-fw@strlen.de>
 <dbbc274e-cf69-5207-6ddd-00c435d5a689@average.org>
 <20211021235819.GF7604@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211021235819.GF7604@breakpoint.cc>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Florian Westphal <fw@strlen.de> wrote:
> Eugene Crosser <crosser@average.org> wrote:
> > In  such case 'set_untrackd' will do nothing, but 'reset_ct' will clear
> > UNTRACKED status that was set elswhere. It seems wrong, am I missing something?
> 
> No, thats the catch.  I can't find a better option.

To clarify, existing code has unconditional reset, so existing rulesets
that set 'notrack' in the first (vrf) round do not affect the second
round.

This feature/bug would remain, which sucks but I can't think of a saner
alternative.
