Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D44BC001E0
	for <netfilter-devel@archiver.kernel.org>; Wed, 16 Aug 2023 16:03:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235674AbjHPQCr (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 16 Aug 2023 12:02:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344546AbjHPQC0 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 16 Aug 2023 12:02:26 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CD032D5A
        for <netfilter-devel@vger.kernel.org>; Wed, 16 Aug 2023 09:02:01 -0700 (PDT)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1qWIy7-0000zf-He; Wed, 16 Aug 2023 18:01:59 +0200
Date:   Wed, 16 Aug 2023 18:01:59 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Thomas Haller <thaller@redhat.com>
Cc:     NetFilter <netfilter-devel@vger.kernel.org>
Subject: Re: [nft PATCH v4 2/6] src: add input flag NFT_CTX_INPUT_NO_DNS to
 avoid blocking
Message-ID: <ZNzy9+OPzBiYVnvT@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Thomas Haller <thaller@redhat.com>,
        NetFilter <netfilter-devel@vger.kernel.org>
References: <20230803193940.1105287-1-thaller@redhat.com>
 <20230803193940.1105287-5-thaller@redhat.com>
 <ZNJCFNlZ8bHuJOkl@orbyte.nwl.cc>
 <e095b0fe0c6db0eaafb8072abfa5102a55f9df41.camel@redhat.com>
 <ZNNoUHB/i7rxPXS1@orbyte.nwl.cc>
 <b1829e8f312b2e626dc4efefdc1d666044405552.camel@redhat.com>
 <ZNSVo9Um6T0fgqXA@orbyte.nwl.cc>
 <7f3848f6d52a2521df8bd1ee01b2fdb0af9b57a1.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7f3848f6d52a2521df8bd1ee01b2fdb0af9b57a1.camel@redhat.com>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Aug 10, 2023 at 10:43:38AM +0200, Thomas Haller wrote:
> Hi Phil,
> 
> On Thu, 2023-08-10 at 09:45 +0200, Phil Sutter wrote:
> > On Wed, Aug 09, 2023 at 09:17:36PM +0200, Thomas Haller wrote:
> > 
> > 
> > > 
> > > It seems prudent that libnftables provides a mode of operation so
> > > that
> > > it doesn't block the calling application. Otherwise, it is a
> > > problem
> > > for applications that care about that.
> > 
> > Hmm. In that case, one might also have to take care of calls to
> > getprotobyname() and maybe others (getaddrinfo()?). Depending on
> > nsswitch.conf it may block, too, right?
> 
> getaddrinfo() is avoided by NFT_CTX_INPUT_NO_DNS.
> 
> ... except at one place in `inet_service_type_parse()`, where
> getaddrinfo() is used to parse the service. I don't think that has any
> reason to block(*), has it?.
> 
> getprotobyname() also should not block(*)  as it merely reads
> /etc/protocols (in musl it's even hard-coded).
> 
> 
> (*) reading from /etc or talking netlink to kernel is sufficiently fast
> so I consider it "non-blocking".

I think these functions support /etc/nsswitch.conf, so feeding them
names is not necessarily only a local lookup. But anyway, this doesn't
quite matter: /etc/nsswitch.conf is in control of the user, just as is
the input fed into run_cmd_from_*(). So for the sake of the discussion
here, it doesn't make a difference.

> In the first version, the flag was called NFT_CTX_NO_BLOCK. It had the
> goal to avoid any significant blocking. The flag got renamed to
> NFT_CTX_INPUT_NO_DNS, which on the surface has the different goal to
> only accept plain IP addresses.
> 
> If there are other places that still can block, they should be
> identified and addressed. But that's then separate from NO_DNS flag.

Yes, I believe the various name to number lookups are the only potential
blockers.

> > > > > And that the application doesn't make a mistake with that
> > > > > ([1]).
> > > > > 
> > > > > [1]
> > > > > https://github.com/firewalld/firewalld/commit/4db89e316f2d60f3cf856a7025a96a61e40b1e5a
> > > > 
> > > > This is just a bug in firewall-cmd, missing to convert ranges
> > > > into
> > > > JSON
> > > > format. I don't see the benefit for users which no longer may use
> > > > host
> > > > names in that spot.
> > > 
> > > Which spot do you mean? /sbin/nft is not affected, unless it opts-
> > > in to
> > > the new flag. firewalld never supported hostnames at that spot
> > > anyway
> > > (or does it?).
> > 
> > I'm pretty sure it does, albeit maybe not officially.
> 
> That would be important to verify. I will check, thank you.

Did you find time for it already?

Cheers, Phil
