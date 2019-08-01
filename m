Return-Path: <SRS0=uSEi=V5=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3FA6C19759
	for <netfilter-devel@archiver.kernel.org>; Thu,  1 Aug 2019 12:58:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D206320838
	for <netfilter-devel@archiver.kernel.org>; Thu,  1 Aug 2019 12:58:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731509AbfHAM6C (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 1 Aug 2019 08:58:02 -0400
Received: from orbyte.nwl.cc ([151.80.46.58]:43426 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730887AbfHAM6B (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 1 Aug 2019 08:58:01 -0400
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.91)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1htAee-0000Qq-RY; Thu, 01 Aug 2019 14:58:00 +0200
Date:   Thu, 1 Aug 2019 14:58:00 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [iptables PATCH 4/5] xtables-monitor: Support ARP and bridge
 families
Message-ID: <20190801125800.GU14469@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
References: <20190731163915.22232-1-phil@nwl.cc>
 <20190731163915.22232-5-phil@nwl.cc>
 <20190801112050.nqig4dbncyx4gfdz@salvia>
 <20190801120048.GS14469@orbyte.nwl.cc>
 <20190801123040.rljiffbbux3bajls@salvia>
 <20190801124107.GT14469@orbyte.nwl.cc>
 <20190801124738.pnfo4zsypkqiaonm@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190801124738.pnfo4zsypkqiaonm@salvia>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Aug 01, 2019 at 02:47:38PM +0200, Pablo Neira Ayuso wrote:
> On Thu, Aug 01, 2019 at 02:41:07PM +0200, Phil Sutter wrote:
> > Hi,
> > 
> > On Thu, Aug 01, 2019 at 02:30:40PM +0200, Pablo Neira Ayuso wrote:
> > > On Thu, Aug 01, 2019 at 02:00:48PM +0200, Phil Sutter wrote:
> [...]
> > > I think users will end up using --arp and --bridge for this. I myself
> > > will not remember this -0 and -1 thing.
> > 
> > That's correct. So I guess changing cmdline flags to -a/-b makes sense
> > either way.
> 
> In the rule side, getopt_long() is already pretty overloaded, just
> double check these are spare.

This is only about xtables-monitor cmdline, or am I missing something?

> > > Feel free to explore any possibility, probably leaving the existing -0
> > > and -1 in place if you're afraid of breaking anything, add aliases and
> > > only document the more intuitive one. If you think this is worth
> > > exploring, of course.
> > 
> > I would omit the prefix from output if a family was selected. For
> > unfiltered xtables-monitor output, I would change the prefix to
> > something more readable, e.g.:
> > 
> > 'ip:  ',
> > 'ip6: ',
> > 'arp: ',
> > 'eb:  '
> > 
> > What do you think?
> 
> Probably use the long option name, which seems more readable to me:
> 
> EVENT: --ipv4 -t filter -A INPUT -j ACCEPT

Ah, good idea!

> I like that the event is printed using the {ip,...}tables syntax.

OK. --arp/--bridge won't work there, obviously. We could of course try
to change that, but I guess it's not feasible. Also, IIRC 'iptables -6'
was buggy in that it should fail but does not. This is a compatibility
issue I didn't get to fix yet.

Cheers, Phil
