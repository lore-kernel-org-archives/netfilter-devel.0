Return-Path: <SRS0=UFFK=AD=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF3FBC433DF
	for <netfilter-devel@archiver.kernel.org>; Mon, 22 Jun 2020 14:35:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CE2462071A
	for <netfilter-devel@archiver.kernel.org>; Mon, 22 Jun 2020 14:35:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729049AbgFVOfM (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 22 Jun 2020 10:35:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729040AbgFVOfM (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 22 Jun 2020 10:35:12 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74C1BC061573
        for <netfilter-devel@vger.kernel.org>; Mon, 22 Jun 2020 07:35:11 -0700 (PDT)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1jnNXQ-0003jA-1H; Mon, 22 Jun 2020 16:35:08 +0200
Date:   Mon, 22 Jun 2020 16:35:08 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Jan Engelhardt <jengelh@inai.de>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Subject: Re: iptables user space performance benchmarks published
Message-ID: <20200622143508.GA23632@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Jan Engelhardt <jengelh@inai.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
References: <20200619141157.GU23632@orbyte.nwl.cc>
 <nycvar.YFH.7.77.849.2006221553450.28529@n3.vanv.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <nycvar.YFH.7.77.849.2006221553450.28529@n3.vanv.qr>
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Jan,

On Mon, Jun 22, 2020 at 04:04:43PM +0200, Jan Engelhardt wrote:
> On Friday 2020-06-19 16:11, Phil Sutter wrote:
> >I remember you once asked for the benchmark scripts I used to compare
> >performance of iptables-nft with -legacy in terms of command overhead
> >and caching, as detailed in a blog[1] I wrote about it. I meanwhile
> >managed to polish the scripts a bit and push them into a public repo,
> >accessible here[2]. I'm not sure whether they are useful for regular
> >runs (or even CI) as a single run takes a few hours and parallel use
> >likely kills result precision.
> >
> >[1] https://developers.redhat.com/blog/2020/04/27/optimizing-iptables-nft-large-ruleset-performance-in-user-space/
> >
> >"""My main suspects for why iptables-nft performed so poorly were kernel ruleset
> >caching and the internal conversion from nftables rules in libnftnl data
> >structures to iptables rules in libxtables data structures."""
> 
> Did you record any syscall-induced latency? The classic ABI used a
> one-syscall approach, passing the entire buffer at once. With
> netlink, it's a bit of a ping-pong between user and kernel unless one
> uses mmap like on AF_PACKET — and I don't see any mmap in libmnl or
> libnftnl.

While it is true that no zero-copy mechanisms are used by
libmnl/libnftnl, an early improvement I did was to max out receive
buffer size (see commit 5a0294901db1d which also has some figures).
After all though, I would consider this to be mostly relevant when
loading a large ruleset and that is rather a one-time action, for
instance during system boot-up.

Some "quick changes" like, e.g. adding an IP to a blacklist, usually
don't need to push much data to the kernel for zero-copy to become
relevant. (Of course they may still benefit if setup overhead can be
kept low).

> Furthermore, loading the ruleset is just one aspect. Evaluating it
> for every packet is what should weigh in a lot more. Did you by
> chance collect any numbers in that regard?

Not really. I did some runtime measurements once but unless there's an
undiscovered performance loop I wouldn't expect much to improve there.

Obviously, a much larger factor is ruleset design. I guess most
existing, legacy rulesets out there would largely benefit from
introducing ipset. Duplicating the same crappy ruleset in nftables is
pointless. Making it use nftables' features after the conversion is not
trivial, but results aren't even comparable afterwards. At least that's
my quintessence from trying, see the related blog[1] for details.

Cheers, Phil

[1] https://developers.redhat.com/blog/2017/04/11/benchmarking-nftables/

