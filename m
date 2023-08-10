Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2C9DC001DE
	for <netfilter-devel@archiver.kernel.org>; Thu, 10 Aug 2023 07:45:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230197AbjHJHpn (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 10 Aug 2023 03:45:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231517AbjHJHpn (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 10 Aug 2023 03:45:43 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D51EC3
        for <netfilter-devel@vger.kernel.org>; Thu, 10 Aug 2023 00:45:42 -0700 (PDT)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1qU0MW-0001FU-1X; Thu, 10 Aug 2023 09:45:40 +0200
Date:   Thu, 10 Aug 2023 09:45:39 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Thomas Haller <thaller@redhat.com>
Cc:     NetFilter <netfilter-devel@vger.kernel.org>
Subject: Re: [nft PATCH v4 2/6] src: add input flag NFT_CTX_INPUT_NO_DNS to
 avoid blocking
Message-ID: <ZNSVo9Um6T0fgqXA@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Thomas Haller <thaller@redhat.com>,
        NetFilter <netfilter-devel@vger.kernel.org>
References: <20230803193940.1105287-1-thaller@redhat.com>
 <20230803193940.1105287-5-thaller@redhat.com>
 <ZNJCFNlZ8bHuJOkl@orbyte.nwl.cc>
 <e095b0fe0c6db0eaafb8072abfa5102a55f9df41.camel@redhat.com>
 <ZNNoUHB/i7rxPXS1@orbyte.nwl.cc>
 <b1829e8f312b2e626dc4efefdc1d666044405552.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b1829e8f312b2e626dc4efefdc1d666044405552.camel@redhat.com>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Aug 09, 2023 at 09:17:36PM +0200, Thomas Haller wrote:
> On Wed, 2023-08-09 at 12:20 +0200, Phil Sutter wrote:
> > On Tue, Aug 08, 2023 at 10:05:19PM +0200, Thomas Haller wrote:
> > > On Tue, 2023-08-08 at 15:24 +0200, Phil Sutter wrote:
> > > > On Thu, Aug 03, 2023 at 09:35:16PM +0200, Thomas Haller wrote:
> > > > > getaddrinfo() blocks while trying to resolve the name. Blocking
> > > > > the
> > > > > caller of the library is in many cases undesirable. Also, while
> > > > > reconfiguring the firewall, it's not clear that resolving names
> > > > > via
> > > > > the network will work or makes sense.
> > > > > 
> > > > > Add a new input flag NFT_CTX_INPUT_NO_DNS to opt-out from
> > > > > getaddrinfo()
> > > > > and only accept plain IP addresses.
> > > > 
> > > > This sounds like user input validation via backend. Another way
> > > > to
> > > > solve
> > > > the problem at hand is to not insert host names into the
> > > > rules(et)
> > > > fed
> > > > into libnftables, right?
> > > 
> > > Right. More generally, ensure not to pass any non-addresses in JSON
> > > that would be resolved.
> > 
> > Well, detecting if a string constitutes a valid IP address is rather
> > trivial. In Python, there's even 'ipaddress' module for that job.
> 
> firewalld messed it up, showing that it can happen.

I'm just saying it's possible. From libnftables' PoV, hostname input is
supported and works as expected.

> > > Which requires that the user application is keenly aware,
> > > understands
> > > and validates the input data. For example, there couldn't be a
> > > "expert
> > > option" where the admin configures arbitrary JSON.
> > 
> > Why is host resolution a problem in such scenario? The fact that
> > using
> > host names instead of IP addresses may result in significant delays
> > due
> > to the required DNS queries is pretty common knowledge among system
> > administrators.
> 
> 
> It seems prudent that libnftables provides a mode of operation so that
> it doesn't block the calling application. Otherwise, it is a problem
> for applications that care about that.

Hmm. In that case, one might also have to take care of calls to
getprotobyname() and maybe others (getaddrinfo()?). Depending on
nsswitch.conf it may block, too, right?

> > > And that the application doesn't make a mistake with that ([1]).
> > > 
> > > [1]
> > > https://github.com/firewalld/firewalld/commit/4db89e316f2d60f3cf856a7025a96a61e40b1e5a
> > 
> > This is just a bug in firewall-cmd, missing to convert ranges into
> > JSON
> > format. I don't see the benefit for users which no longer may use
> > host
> > names in that spot.
> 
> Which spot do you mean? /sbin/nft is not affected, unless it opts-in to
> the new flag. firewalld never supported hostnames at that spot anyway
> (or does it?).

I'm pretty sure it does, albeit maybe not officially.

Cheers, Phil
