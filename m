Return-Path: <SRS0=UFFK=AD=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AAB60C433DF
	for <netfilter-devel@archiver.kernel.org>; Mon, 22 Jun 2020 13:40:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 88D6020679
	for <netfilter-devel@archiver.kernel.org>; Mon, 22 Jun 2020 13:40:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728911AbgFVNkk (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 22 Jun 2020 09:40:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728605AbgFVNkk (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 22 Jun 2020 09:40:40 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FCDFC061573
        for <netfilter-devel@vger.kernel.org>; Mon, 22 Jun 2020 06:40:39 -0700 (PDT)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1jnMgg-00038q-5O; Mon, 22 Jun 2020 15:40:38 +0200
Date:   Mon, 22 Jun 2020 15:40:38 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: iptables user space performance benchmarks published
Message-ID: <20200622134038.GY23632@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
References: <20200619141157.GU23632@orbyte.nwl.cc>
 <20200622124207.GA25671@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200622124207.GA25671@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Pablo,

On Mon, Jun 22, 2020 at 02:42:07PM +0200, Pablo Neira Ayuso wrote:
> On Fri, Jun 19, 2020 at 04:11:57PM +0200, Phil Sutter wrote:
> > Hi Pablo,
> > 
> > I remember you once asked for the benchmark scripts I used to compare
> > performance of iptables-nft with -legacy in terms of command overhead
> > and caching, as detailed in a blog[1] I wrote about it. I meanwhile
> > managed to polish the scripts a bit and push them into a public repo,
> > accessible here[2]. I'm not sure whether they are useful for regular
> > runs (or even CI) as a single run takes a few hours and parallel use
> > likely kills result precision.
> 
> So what is the _technical_ incentive for using the iptables blob
> interface (a.k.a. legacy) these days then?

Mostly interoperability, I guess. Recent real-world scenario is host
firewall management from inside a container (please don't ask me why):
If the host uses legacy iptables (for legacy reasons ;) the top-notch
state of the art container has to do so as well or hell freezes over.

Apart from that, I can imagine there are users depending on one of the
few missing features like e.g. broute table in ebtables.

> The iptables-nft frontend is transparent and it outperforms the legacy
> code for dynamic rulesets.

Sadly, we can't claim the same for nft - its caching strategy is dumb
compared to what iptables-nft does nowadays. I guess that should be my
follow-up task. :)

Cheers, Phil
