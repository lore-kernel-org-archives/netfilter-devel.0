Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3EA92EB64DD
	for <netfilter-devel@archiver.kernel.org>; Wed,  9 Aug 2023 10:20:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230260AbjHIKUF (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 9 Aug 2023 06:20:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229669AbjHIKUE (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 9 Aug 2023 06:20:04 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23CB21BFB
        for <netfilter-devel@vger.kernel.org>; Wed,  9 Aug 2023 03:20:03 -0700 (PDT)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1qTgIL-00015i-07; Wed, 09 Aug 2023 12:20:01 +0200
Date:   Wed, 9 Aug 2023 12:20:00 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Thomas Haller <thaller@redhat.com>
Cc:     NetFilter <netfilter-devel@vger.kernel.org>
Subject: Re: [nft PATCH v4 2/6] src: add input flag NFT_CTX_INPUT_NO_DNS to
 avoid blocking
Message-ID: <ZNNoUHB/i7rxPXS1@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Thomas Haller <thaller@redhat.com>,
        NetFilter <netfilter-devel@vger.kernel.org>
References: <20230803193940.1105287-1-thaller@redhat.com>
 <20230803193940.1105287-5-thaller@redhat.com>
 <ZNJCFNlZ8bHuJOkl@orbyte.nwl.cc>
 <e095b0fe0c6db0eaafb8072abfa5102a55f9df41.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e095b0fe0c6db0eaafb8072abfa5102a55f9df41.camel@redhat.com>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Aug 08, 2023 at 10:05:19PM +0200, Thomas Haller wrote:
> On Tue, 2023-08-08 at 15:24 +0200, Phil Sutter wrote:
> > On Thu, Aug 03, 2023 at 09:35:16PM +0200, Thomas Haller wrote:
> > > getaddrinfo() blocks while trying to resolve the name. Blocking the
> > > caller of the library is in many cases undesirable. Also, while
> > > reconfiguring the firewall, it's not clear that resolving names via
> > > the network will work or makes sense.
> > > 
> > > Add a new input flag NFT_CTX_INPUT_NO_DNS to opt-out from
> > > getaddrinfo()
> > > and only accept plain IP addresses.
> > 
> > This sounds like user input validation via backend. Another way to
> > solve
> > the problem at hand is to not insert host names into the rules(et)
> > fed
> > into libnftables, right?
> 
> Right. More generally, ensure not to pass any non-addresses in JSON
> that would be resolved.

Well, detecting if a string constitutes a valid IP address is rather
trivial. In Python, there's even 'ipaddress' module for that job.

> Which requires that the user application is keenly aware, understands
> and validates the input data. For example, there couldn't be a "expert
> option" where the admin configures arbitrary JSON.

Why is host resolution a problem in such scenario? The fact that using
host names instead of IP addresses may result in significant delays due
to the required DNS queries is pretty common knowledge among system
administrators.

> And that the application doesn't make a mistake with that ([1]).
> 
> [1] https://github.com/firewalld/firewalld/commit/4db89e316f2d60f3cf856a7025a96a61e40b1e5a

This is just a bug in firewall-cmd, missing to convert ranges into JSON
format. I don't see the benefit for users which no longer may use host
names in that spot.

Cheers, Phil
