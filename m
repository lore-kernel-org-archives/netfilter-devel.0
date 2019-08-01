Return-Path: <SRS0=uSEi=V5=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ECF56C19759
	for <netfilter-devel@archiver.kernel.org>; Thu,  1 Aug 2019 14:20:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C3C9020838
	for <netfilter-devel@archiver.kernel.org>; Thu,  1 Aug 2019 14:20:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727024AbfHAOUZ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 1 Aug 2019 10:20:25 -0400
Received: from orbyte.nwl.cc ([151.80.46.58]:43574 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726825AbfHAOUZ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 1 Aug 2019 10:20:25 -0400
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.91)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1htBwN-0001Rh-A6; Thu, 01 Aug 2019 16:20:23 +0200
Date:   Thu, 1 Aug 2019 16:20:23 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [iptables PATCH 4/5] xtables-monitor: Support ARP and bridge
 families
Message-ID: <20190801142023.GV14469@orbyte.nwl.cc>
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
 <20190801125800.GU14469@orbyte.nwl.cc>
 <20190801130303.vddtqk2hect4mny7@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190801130303.vddtqk2hect4mny7@salvia>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Aug 01, 2019 at 03:03:03PM +0200, Pablo Neira Ayuso wrote:
> On Thu, Aug 01, 2019 at 02:58:00PM +0200, Phil Sutter wrote:
> > On Thu, Aug 01, 2019 at 02:47:38PM +0200, Pablo Neira Ayuso wrote:
> > > On Thu, Aug 01, 2019 at 02:41:07PM +0200, Phil Sutter wrote:
> > > > Hi,
> > > > 
> > > > On Thu, Aug 01, 2019 at 02:30:40PM +0200, Pablo Neira Ayuso wrote:
> > > > > On Thu, Aug 01, 2019 at 02:00:48PM +0200, Phil Sutter wrote:
> > > [...]
> > > > > I think users will end up using --arp and --bridge for this. I myself
> > > > > will not remember this -0 and -1 thing.
> > > > 
> > > > That's correct. So I guess changing cmdline flags to -a/-b makes sense
> > > > either way.
> > > 
> > > In the rule side, getopt_long() is already pretty overloaded, just
> > > double check these are spare.
> > 
> > This is only about xtables-monitor cmdline, or am I missing something?
> 
> I was referring to the iptables rule command. Not sure it's worth
> there the alias. I think you mentioned that there's already -0 and -1
> in the rule command line, hence the -0 and -1 for xtables-monitor.

Why should xtables-monitor print something that can be used as input to
iptables?

> > > > > Feel free to explore any possibility, probably leaving the existing -0
> > > > > and -1 in place if you're afraid of breaking anything, add aliases and
> > > > > only document the more intuitive one. If you think this is worth
> > > > > exploring, of course.
> > > > 
> > > > I would omit the prefix from output if a family was selected. For
> > > > unfiltered xtables-monitor output, I would change the prefix to
> > > > something more readable, e.g.:
> > > > 
> > > > 'ip:  ',
> > > > 'ip6: ',
> > > > 'arp: ',
> > > > 'eb:  '
> > > > 
> > > > What do you think?
> > > 
> > > Probably use the long option name, which seems more readable to me:
> > > 
> > > EVENT: --ipv4 -t filter -A INPUT -j ACCEPT
> > 
> > Ah, good idea!
> > 
> > > I like that the event is printed using the {ip,...}tables syntax.
> > 
> > OK. --arp/--bridge won't work there, obviously. We could of course try
> > to change that, but I guess it's not feasible.
> 
> I think we would need a common parser, and that's not feasible. Unless
> there is some preparsing, just to check if the family option is in
> place, ie. -4, -6, --arp and --bridge, then route the parsing to the
> corresponding parser. It's a bit of extra glue code, not sure it's
> worth, just an idea / future work if helping all these tooling
> converge might be of interest.

Given the large differences in ebtables cmdline syntax to the other
tools, I consider it a plus to have different commands (and hence
separate "main" functions).

> > Also, IIRC 'iptables -6' was buggy in that it should fail but does
> > not. This is a compatibility issue I didn't get to fix yet.
> 
> Noted. I have seen the recent patch to fix this.

That was only for iptables-nft-restore. I am talking about plain
iptables:

| % iptables-legacy -6 -A FORWARD -j ACCEPT
| This is the IPv4 version of iptables.
| Try `iptables -h' or 'iptables --help' for more information.

iptables-nft accepts this but the result seems to be identical to just
omitting '-6'.

Cheers, Phil
