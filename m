Return-Path: <SRS0=uSEi=V5=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91A99C433FF
	for <netfilter-devel@archiver.kernel.org>; Thu,  1 Aug 2019 12:41:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6CC0520644
	for <netfilter-devel@archiver.kernel.org>; Thu,  1 Aug 2019 12:41:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731385AbfHAMlJ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 1 Aug 2019 08:41:09 -0400
Received: from orbyte.nwl.cc ([151.80.46.58]:43396 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730319AbfHAMlI (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 1 Aug 2019 08:41:08 -0400
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.91)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1htAOJ-0000AV-P1; Thu, 01 Aug 2019 14:41:07 +0200
Date:   Thu, 1 Aug 2019 14:41:07 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [iptables PATCH 4/5] xtables-monitor: Support ARP and bridge
 families
Message-ID: <20190801124107.GT14469@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
References: <20190731163915.22232-1-phil@nwl.cc>
 <20190731163915.22232-5-phil@nwl.cc>
 <20190801112050.nqig4dbncyx4gfdz@salvia>
 <20190801120048.GS14469@orbyte.nwl.cc>
 <20190801123040.rljiffbbux3bajls@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190801123040.rljiffbbux3bajls@salvia>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

On Thu, Aug 01, 2019 at 02:30:40PM +0200, Pablo Neira Ayuso wrote:
> On Thu, Aug 01, 2019 at 02:00:48PM +0200, Phil Sutter wrote:
> > On Thu, Aug 01, 2019 at 01:20:50PM +0200, Pablo Neira Ayuso wrote:
> > > On Wed, Jul 31, 2019 at 06:39:14PM +0200, Phil Sutter wrote:
> > >  @@ -565,6 +574,8 @@ static const struct option options[] = {
> > > >  	{.name = "counters", .has_arg = false, .val = 'c'},
> > > >  	{.name = "trace", .has_arg = false, .val = 't'},
> > > >  	{.name = "event", .has_arg = false, .val = 'e'},
> > > > +	{.name = "arp", .has_arg = false, .val = '0'},
> > > > +	{.name = "bridge", .has_arg = false, .val = '1'},
> > > 
> > > Probably?
> > > 
> > > -A for arp.
> > > -B for bridge.
> > > 
> > > so users don't have to remember? -4 and -6 are intuitive, I'd like
> > > these are sort of intuitive too in its compact definition.
> > > 
> > > Apart from that, patchset looks good to me.
> > 
> > I had something like that (-a and -b should still be free), but then
> > discovered that for rules there was '-0' prefix in use when printing arp
> > family rules. Should I change these prefixes also or leave them as -0
> > and -1? I guess most importantly they must not clash with real
> > parameters.
> 
> You can just leave them as is if this is the way this is exposed in
> rules. Not sure what the logic behing -0 and -1 is, this is not
> mapping to NFPROTO_* definitions, so it looks like something it's been
> pulled out of someone's hat :-)

Well, the '-1' certainly was! :D
In ss tool, '-0' is used to select packet sockets. Maybe that's where it
came from.

> I think users will end up using --arp and --bridge for this. I myself
> will not remember this -0 and -1 thing.

That's correct. So I guess changing cmdline flags to -a/-b makes sense
either way.

> Feel free to explore any possibility, probably leaving the existing -0
> and -1 in place if you're afraid of breaking anything, add aliases and
> only document the more intuitive one. If you think this is worth
> exploring, of course.

I would omit the prefix from output if a family was selected. For
unfiltered xtables-monitor output, I would change the prefix to
something more readable, e.g.:

'ip:  ',
'ip6: ',
'arp: ',
'eb:  '

What do you think?

Thanks for the input,
Phil
