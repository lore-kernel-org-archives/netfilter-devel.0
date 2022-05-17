Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA6A6C433EF
	for <netfilter-devel@archiver.kernel.org>; Tue, 17 May 2022 08:17:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242874AbiEQIRA (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 17 May 2022 04:17:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243436AbiEQIQt (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 17 May 2022 04:16:49 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87E3C4B858
        for <netfilter-devel@vger.kernel.org>; Tue, 17 May 2022 01:14:40 -0700 (PDT)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1nqsLk-0008Gn-1d; Tue, 17 May 2022 10:14:36 +0200
Date:   Tue, 17 May 2022 10:14:36 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Maciej =?utf-8?Q?=C5=BBenczykowski?= <maze@google.com>
Cc:     Florian Westphal <fw@strlen.de>,
        Nick Hainke <vincent@systemli.org>,
        Netfilter Development Mailing List 
        <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH iptables 1/2] xtables: fix compilation with musl
Message-ID: <YoNZbOglBKlT8Nwl@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Maciej =?utf-8?Q?=C5=BBenczykowski?= <maze@google.com>,
        Florian Westphal <fw@strlen.de>, Nick Hainke <vincent@systemli.org>,
        Netfilter Development Mailing List <netfilter-devel@vger.kernel.org>
References: <20220514163325.54266-1-vincent@systemli.org>
 <Yn/hMODAkEEbzQno@orbyte.nwl.cc>
 <CANP3RGfP4Et8PCviNLLUJNHBCbo-B53UkaZfZJyqHBu_Ccs3Ow@mail.gmail.com>
 <YoDsbC/hwY9mPLR+@orbyte.nwl.cc>
 <20220515140917.GA2812@breakpoint.cc>
 <CANP3RGfoEu5dKV83bO0LYnWYLoJMrvaMaCAx4sYaDNn6-14Z-Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CANP3RGfoEu5dKV83bO0LYnWYLoJMrvaMaCAx4sYaDNn6-14Z-Q@mail.gmail.com>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Sun, May 15, 2022 at 07:13:27AM -0700, Maciej Żenczykowski wrote:
> On Sun, May 15, 2022 at 7:09 AM Florian Westphal <fw@strlen.de> wrote:
> > Phil Sutter <phil@nwl.cc> wrote:
> > > > fix build for missing ETH_ALEN definition
> > > > (this is needed at least with bionic)
> > > >
> > > > +#include <linux/if_ether.h> /* ETH_ALEN */
> > > >
> > > > Based on the above, clearly adding an 'if defined GLIBC' wrapper will
> > > > break bionic...
> > > > and presumably glibc doesn't care whether the #include is done one way
> > > > or the other?
> > >
> > > With glibc, netinet/ether.h includes netinet/if_ether.h which in turn
> > > includes linux/if_ether.h where finally ETH_ALEN is defined.
> > >
> > > In xtables.c we definitely need netinet/ether.h for ether_aton()
> > > declaration.
> >
> > Or we hand-roll a xt_ether_aton and add XT_ETH_ALEN to avoid
> > this include.
> >
> > Probably easier to maintain than to add all these ifdefs?
> 
> or even simply replace both the #include's with
> #ifndef ETH_ALEN
> #define ETH_ALEN 6
> #endif

If that's sufficient for both musl and bionic, probably the easiest
solution with least potential for surprises.

Cheers, Phil
