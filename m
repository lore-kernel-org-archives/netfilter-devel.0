Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79AC1C4332F
	for <netfilter-devel@archiver.kernel.org>; Tue, 17 May 2022 08:18:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242982AbiEQISN (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 17 May 2022 04:18:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235160AbiEQISH (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 17 May 2022 04:18:07 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89E6649C82
        for <netfilter-devel@vger.kernel.org>; Tue, 17 May 2022 01:17:54 -0700 (PDT)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1nqsOu-0008KQ-4l; Tue, 17 May 2022 10:17:52 +0200
Date:   Tue, 17 May 2022 10:17:52 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Maciej =?utf-8?Q?=C5=BBenczykowski?= <maze@google.com>
Cc:     Nick Hainke <vincent@systemli.org>,
        Netfilter Development Mailing List 
        <netfilter-devel@vger.kernel.org>,
        Maciej =?utf-8?Q?=C5=BBenczykowski?= <zenczykowski@gmail.com>
Subject: Re: [PATCH iptables 1/2] xtables: fix compilation with musl
Message-ID: <YoNaMKGWLBrqIueJ@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Maciej =?utf-8?Q?=C5=BBenczykowski?= <maze@google.com>,
        Nick Hainke <vincent@systemli.org>,
        Netfilter Development Mailing List <netfilter-devel@vger.kernel.org>,
        Maciej =?utf-8?Q?=C5=BBenczykowski?= <zenczykowski@gmail.com>
References: <20220514163325.54266-1-vincent@systemli.org>
 <Yn/hMODAkEEbzQno@orbyte.nwl.cc>
 <CANP3RGfP4Et8PCviNLLUJNHBCbo-B53UkaZfZJyqHBu_Ccs3Ow@mail.gmail.com>
 <YoDsbC/hwY9mPLR+@orbyte.nwl.cc>
 <CANP3RGeEnEZUJtUQbjukSUC-6KBoHPF5dTD72b73Rev3hfp7MQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CANP3RGeEnEZUJtUQbjukSUC-6KBoHPF5dTD72b73Rev3hfp7MQ@mail.gmail.com>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Sun, May 15, 2022 at 06:40:51AM -0700, Maciej Żenczykowski wrote:
> On Sun, May 15, 2022 at 5:05 AM Phil Sutter <phil@nwl.cc> wrote:
> >
> > Hi Maciej,
> >
> > On Sat, May 14, 2022 at 12:14:27PM -0700, Maciej Żenczykowski wrote:
> > > On Sat, May 14, 2022 at 10:04 AM Phil Sutter <phil@nwl.cc> wrote:
> > > > On Sat, May 14, 2022 at 06:33:24PM +0200, Nick Hainke wrote:
> > > > > Only include <linux/if_ether.h> if glibc is used.
> > > >
> > > > This looks like a bug in musl? OTOH explicit include of linux/if_ether.h
> > > > was added in commit c5d9a723b5159 ("fix build for missing ETH_ALEN
> > > > definition"), despite netinet/ether.h being included in line 2248 of
> > > > libxtables/xtables.c. So maybe *also* a bug in bionic?!
> > >
> > > You stripped the email you're replying to, and while I'm on lkml and
> > > netdev - with my personal account - I'm not (apparently) subscribed to
> > > netfilter-devel (or I'm not subscribed from work account).
> >
> > Oh, sorry for the caused inconvenience.
> >
> > > Either way, if my search-fu is correct you're replying to
> > > https://marc.info/?l=netfilter-devel&m=165254651011397&w=2
> > >
> > > +#if defined(__GLIBC__)
> > >  #include <linux/if_ether.h> /* ETH_ALEN */
> > > +#endif
> > >
> > > and you're presumably CC'ing me due to
> > >
> > > https://git.netfilter.org/iptables/commit/libxtables/xtables.c?id=c5d9a723b5159a28f547b577711787295a14fd84
> > >
> > > which added the include in the first place...:
> >
> > That's correct. I assumed that you added the include for a reason and
> > it's breaking Nick's use-case, the two of you want to have a word with
> > each other. :)
> >
> > > fix build for missing ETH_ALEN definition
> > > (this is needed at least with bionic)
> > >
> > > +#include <linux/if_ether.h> /* ETH_ALEN */
> > >
> > > Based on the above, clearly adding an 'if defined GLIBC' wrapper will
> > > break bionic...
> > > and presumably glibc doesn't care whether the #include is done one way
> > > or the other?
> >
> > With glibc, netinet/ether.h includes netinet/if_ether.h which in turn
> > includes linux/if_ether.h where finally ETH_ALEN is defined.
> >
> > In xtables.c we definitely need netinet/ether.h for ether_aton()
> > declaration.
> >
> > > Obviously it could be '#if !defined MUSL' instead...
> >
> > Could ...
> >
> > > As for the fix?  And whether glibc or musl or bionic are wrong or not...
> > > Utterly uncertain...
> > >
> > > Though, I will point out #include's 2000 lines into a .c file are kind of funky.
> >
> > ACK!
> >
> > > Ultimately I find
> > > https://android.git.corp.google.com/platform/external/iptables/+/7608e136bd495fe734ad18a6897dd4425e1a633b%5E%21/
> > >
> > > +#ifdef __BIONIC__
> > > +#include <linux/if_ether.h> /* ETH_ALEN */
> > > +#endif
> >
> > While I think musl not catching the "double" include is a bug, I'd
> > prefer the ifdef __BIONIC__ solution since it started the "but my libc
> > needs this" game.
> >
> > Nick, if the above change fixes musl builds for you, would you mind
> > submitting it formally along with a move of the netinet/ether.h include
> > from mid-file to top?
> >
> > Thanks, Phil
> 
> Any thoughts about the rest of my email - wrt. #define __USE_BSD
> - do you know how that is supposed to work?

No, but isn't this a detail of bionic header layout?

Cheers, Phil
