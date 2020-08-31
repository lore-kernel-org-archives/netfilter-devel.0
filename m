Return-Path: <SRS0=WPBU=CJ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66C7FC433E2
	for <netfilter-devel@archiver.kernel.org>; Mon, 31 Aug 2020 16:49:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3D08120707
	for <netfilter-devel@archiver.kernel.org>; Mon, 31 Aug 2020 16:49:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728714AbgHaQtL (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 31 Aug 2020 12:49:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727114AbgHaQtK (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 31 Aug 2020 12:49:10 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 496B7C061573
        for <netfilter-devel@vger.kernel.org>; Mon, 31 Aug 2020 09:49:10 -0700 (PDT)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1kCmzS-0007Ne-5B; Mon, 31 Aug 2020 18:49:06 +0200
Date:   Mon, 31 Aug 2020 18:49:06 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Quentin Armitage <quentin@armitage.org.uk>
Cc:     Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Subject: Re: [PATCH] netfilter: nftables: fix documentation for dup statement
Message-ID: <20200831164906.GY23632@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Quentin Armitage <quentin@armitage.org.uk>,
        Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
References: <f9bc9e191b03728fe233ca7a75fdc40ede0fde8e.camel@armitage.org.uk>
 <20200827170203.GM23632@orbyte.nwl.cc>
 <20200827174015.GC7319@breakpoint.cc>
 <1c9c80c0645a79d93ccecdc7ecceb22e15bba5df.camel@armitage.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1c9c80c0645a79d93ccecdc7ecceb22e15bba5df.camel@armitage.org.uk>
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Quentin,

On Thu, Aug 27, 2020 at 07:59:19PM +0100, Quentin Armitage wrote:
> On Thu, 2020-08-27 at 19:40 +0200, Florian Westphal wrote:
> > Phil Sutter <phil@nwl.cc> wrote:
> > > Hi,
> > > 
> > > On Thu, Aug 27, 2020 at 04:42:00PM +0100, Quentin Armitage wrote:
> > > > The dup statement requires an address, and the device is optional,
> > > > not the other way round.
> > > > 
> > > > Signed-off-by: Quentin Armitage <
> > > > quentin@armitage.org.uk
> > > > >
> > > > ---
> > > >  doc/statements.txt | 2 +-
> > > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > > > 
> > > > diff --git a/doc/statements.txt b/doc/statements.txt
> > > > index 9155f286..835db087 100644
> > > > --- a/doc/statements.txt
> > > > +++ b/doc/statements.txt
> > > > @@ -648,7 +648,7 @@ The dup statement is used to duplicate a packet and
> > > > send the
> > > > copy to a different
> > > >  destination.
> > > >  
> > > >  [verse]
> > > > -*dup to* 'device'
> > > > +*dup to* 'address'
> > > >  *dup to* 'address' *device* 'device'
> > > >  
> > > >  .Dup statement values
> > > 
> > > The examples are wrong, too. I wonder if this is really just a mistake
> > > and all three examples given (including the "advanced" usage using a
> > > map) are just wrong or if 'dup' actually was meant to support
> > > duplicating to a device in mirror port fashion.
> > 
> > Right, 'dup to eth0' can be used in the netdev ingress hook.
> > 
> > For dup from ipv4/ipv6 families the address is needed.
> 
> So it seems the valid options are:
> *dup to* 'device'			# netdev ingress hook only
> *dup to* 'address'  			# ipv4/ipv6 only
> *dup to* 'address' *device* 'device'	# ipv4/ipv6 only
> 
> From a user perspective being able to specify "dup to 'device'" is something
> that is useful to be able to specify. I am now using:
>   dup to ip[6] daddr device 'device'
> but it seems to me that having to specify "to ip[6] daddr" is unnecessary.

Oh, and that works? From reading nf_dup_ipv4.c, the kernel seems to
perform a route lookup for the packet's daddr on given iface. Did you
add an onlink route or something to make sure that succeeds?

Cheers, Phil
