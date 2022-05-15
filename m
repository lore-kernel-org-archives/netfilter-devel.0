Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35F52C433FE
	for <netfilter-devel@archiver.kernel.org>; Sun, 15 May 2022 14:09:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236244AbiEOOJ1 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 15 May 2022 10:09:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231526AbiEOOJZ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 15 May 2022 10:09:25 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3A0024093
        for <netfilter-devel@vger.kernel.org>; Sun, 15 May 2022 07:09:23 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1nqEvt-0004Zs-Pj; Sun, 15 May 2022 16:09:17 +0200
Date:   Sun, 15 May 2022 16:09:17 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Phil Sutter <phil@nwl.cc>,
        Maciej =?utf-8?Q?=C5=BBenczykowski?= <maze@google.com>,
        Nick Hainke <vincent@systemli.org>,
        Netfilter Development Mailing List 
        <netfilter-devel@vger.kernel.org>,
        Maciej =?utf-8?Q?=C5=BBenczykowski?= <zenczykowski@gmail.com>
Subject: Re: [PATCH iptables 1/2] xtables: fix compilation with musl
Message-ID: <20220515140917.GA2812@breakpoint.cc>
References: <20220514163325.54266-1-vincent@systemli.org>
 <Yn/hMODAkEEbzQno@orbyte.nwl.cc>
 <CANP3RGfP4Et8PCviNLLUJNHBCbo-B53UkaZfZJyqHBu_Ccs3Ow@mail.gmail.com>
 <YoDsbC/hwY9mPLR+@orbyte.nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YoDsbC/hwY9mPLR+@orbyte.nwl.cc>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Phil Sutter <phil@nwl.cc> wrote:
> > fix build for missing ETH_ALEN definition
> > (this is needed at least with bionic)
> > 
> > +#include <linux/if_ether.h> /* ETH_ALEN */
> > 
> > Based on the above, clearly adding an 'if defined GLIBC' wrapper will
> > break bionic...
> > and presumably glibc doesn't care whether the #include is done one way
> > or the other?
> 
> With glibc, netinet/ether.h includes netinet/if_ether.h which in turn
> includes linux/if_ether.h where finally ETH_ALEN is defined.
> 
> In xtables.c we definitely need netinet/ether.h for ether_aton()
> declaration.

Or we hand-roll a xt_ether_aton and add XT_ETH_ALEN to avoid
this include.

Probably easier to maintain than to add all these ifdefs?
