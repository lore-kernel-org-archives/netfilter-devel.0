Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 239E3C636D6
	for <netfilter-devel@archiver.kernel.org>; Wed, 22 Feb 2023 15:32:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230048AbjBVPcR (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 22 Feb 2023 10:32:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232457AbjBVPcQ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 22 Feb 2023 10:32:16 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5CE537F38
        for <netfilter-devel@vger.kernel.org>; Wed, 22 Feb 2023 07:32:11 -0800 (PST)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1pUr6H-00046d-AC; Wed, 22 Feb 2023 16:32:09 +0100
Date:   Wed, 22 Feb 2023 16:32:09 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Thomas Devoogdt <thomas@devoogdt.com>,
        netfilter-devel@vger.kernel.org,
        Thomas Devoogdt <thomas.devoogdt@barco.com>
Subject: Re: [PATCH] [iptables] extensions: libxt_LOG.c: fix
 linux/netfilter/xt_LOG.h include on Linux < 3.4
Message-ID: <Y/Y1efOjGyBo0MAj@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Thomas Devoogdt <thomas@devoogdt.com>,
        netfilter-devel@vger.kernel.org,
        Thomas Devoogdt <thomas.devoogdt@barco.com>
References: <20230222072349.509917-1-thomas.devoogdt@barco.com>
 <Y/XouZlrtw/SN/C2@salvia>
 <Y/YFcwp/gyZY5Pmw@orbyte.nwl.cc>
 <Y/YZC1Feu9gOCdWF@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y/YZC1Feu9gOCdWF@salvia>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Feb 22, 2023 at 02:30:51PM +0100, Pablo Neira Ayuso wrote:
> On Wed, Feb 22, 2023 at 01:07:15PM +0100, Phil Sutter wrote:
> > On Wed, Feb 22, 2023 at 11:04:41AM +0100, Pablo Neira Ayuso wrote:
> > > On Wed, Feb 22, 2023 at 08:23:49AM +0100, Thomas Devoogdt wrote:
> > > > libxt_LOG.c:6:10: fatal error: linux/netfilter/xt_LOG.h: No such file or directory
> > > > . #include <linux/netfilter/xt_LOG.h>
> > > >           ^~~~~~~~~~~~~~~~~~~~~~~~~~
> > > > 
> > > > Linux < 3.4 defines are in include/linux/netfilter_ipv{4,6}/ipt_LOG.h,
> > > > but the naming is slightly different, so just define it here as the values are the same.
> > > > 
> > > > https://github.com/torvalds/linux/commit/6939c33a757bd006c5e0b8b5fd429fc587a4d0f4
> > > 
> > > Probably you could add xt_LOG.h to iptables/include/linux/netfilter/ ?
> > > 
> > > There are plenty of headers that are cached there to make sure
> > > userspace compile with minimal external dependencies.
> > > 
> > > xt_LOG.h is missing for some reason in that folder, but there are many
> > > of xt_*.h files there.
> > 
> > While being at it, how about caching all netfilter kernel headers we
> > include? The only downside I see is that we may have to update them from
> > time to time (in case new symbols land) but that's rare and the
> > alternative is accidental breakages like above.
> 
> Caching _all_ dependencies is going to be hard, because it might pull
> in lots of header files. The idea so far has been to find a reasonable
> tradeoff, ensuring that iptables compilation is self-contained in a
> best effort approach.

OK, for fun I tried compiling with linux headers from 2.6.39 and 3.0.101
in /usr/include/linux. The only missing files apart from the above were
linux/bpf{,_common}.h. So I guess if we add those as well, we're good
for a while. :)

> > WDYT? I'd volunteer to do it. :)
> 
> iptables already caches a lot of header files, as I said I don't
> remember why this one has never been cached before.

Git says, it's my fault. :(
When merging libipt and libip6t LOG.c files, I introduced the include
but missed to copy the header as well.

I'll apply Thomas' patch adding a reference to my commit and follow up
with bpf header copy (unless someone objects).

Thanks, Phil
