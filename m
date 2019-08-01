Return-Path: <SRS0=uSEi=V5=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6486C433FF
	for <netfilter-devel@archiver.kernel.org>; Thu,  1 Aug 2019 12:00:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B30422087E
	for <netfilter-devel@archiver.kernel.org>; Thu,  1 Aug 2019 12:00:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729091AbfHAMAu (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 1 Aug 2019 08:00:50 -0400
Received: from orbyte.nwl.cc ([151.80.46.58]:43284 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726612AbfHAMAu (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 1 Aug 2019 08:00:50 -0400
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.91)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1ht9lI-00085N-5s; Thu, 01 Aug 2019 14:00:48 +0200
Date:   Thu, 1 Aug 2019 14:00:48 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [iptables PATCH 4/5] xtables-monitor: Support ARP and bridge
 families
Message-ID: <20190801120048.GS14469@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
References: <20190731163915.22232-1-phil@nwl.cc>
 <20190731163915.22232-5-phil@nwl.cc>
 <20190801112050.nqig4dbncyx4gfdz@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190801112050.nqig4dbncyx4gfdz@salvia>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Aug 01, 2019 at 01:20:50PM +0200, Pablo Neira Ayuso wrote:
> On Wed, Jul 31, 2019 at 06:39:14PM +0200, Phil Sutter wrote:
>  @@ -565,6 +574,8 @@ static const struct option options[] = {
> >  	{.name = "counters", .has_arg = false, .val = 'c'},
> >  	{.name = "trace", .has_arg = false, .val = 't'},
> >  	{.name = "event", .has_arg = false, .val = 'e'},
> > +	{.name = "arp", .has_arg = false, .val = '0'},
> > +	{.name = "bridge", .has_arg = false, .val = '1'},
> 
> Probably?
> 
> -A for arp.
> -B for bridge.
> 
> so users don't have to remember? -4 and -6 are intuitive, I'd like
> these are sort of intuitive too in its compact definition.
> 
> Apart from that, patchset looks good to me.

I had something like that (-a and -b should still be free), but then
discovered that for rules there was '-0' prefix in use when printing arp
family rules. Should I change these prefixes also or leave them as -0
and -1? I guess most importantly they must not clash with real
parameters.

Thanks, Phil
