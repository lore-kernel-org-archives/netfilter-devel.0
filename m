Return-Path: <SRS0=UFFK=AD=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5AB6CC433E0
	for <netfilter-devel@archiver.kernel.org>; Mon, 22 Jun 2020 14:04:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3BEC2206E2
	for <netfilter-devel@archiver.kernel.org>; Mon, 22 Jun 2020 14:04:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729310AbgFVOEq (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 22 Jun 2020 10:04:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729056AbgFVOEp (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 22 Jun 2020 10:04:45 -0400
Received: from a3.inai.de (a3.inai.de [IPv6:2a01:4f8:10b:45d8::f5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C3F6C061573
        for <netfilter-devel@vger.kernel.org>; Mon, 22 Jun 2020 07:04:45 -0700 (PDT)
Received: by a3.inai.de (Postfix, from userid 25121)
        id 04F2A58743C32; Mon, 22 Jun 2020 16:04:44 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by a3.inai.de (Postfix) with ESMTP id 0412660D8F1CA;
        Mon, 22 Jun 2020 16:04:44 +0200 (CEST)
Date:   Mon, 22 Jun 2020 16:04:43 +0200 (CEST)
From:   Jan Engelhardt <jengelh@inai.de>
To:     Phil Sutter <phil@nwl.cc>
cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Subject: Re: iptables user space performance benchmarks published
In-Reply-To: <20200619141157.GU23632@orbyte.nwl.cc>
Message-ID: <nycvar.YFH.7.77.849.2006221553450.28529@n3.vanv.qr>
References: <20200619141157.GU23632@orbyte.nwl.cc>
User-Agent: Alpine 2.22 (LSU 394 2020-01-19)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


On Friday 2020-06-19 16:11, Phil Sutter wrote:
>
>I remember you once asked for the benchmark scripts I used to compare
>performance of iptables-nft with -legacy in terms of command overhead
>and caching, as detailed in a blog[1] I wrote about it. I meanwhile
>managed to polish the scripts a bit and push them into a public repo,
>accessible here[2]. I'm not sure whether they are useful for regular
>runs (or even CI) as a single run takes a few hours and parallel use
>likely kills result precision.
>
>[1] https://developers.redhat.com/blog/2020/04/27/optimizing-iptables-nft-large-ruleset-performance-in-user-space/
>
>"""My main suspects for why iptables-nft performed so poorly were kernel ruleset
>caching and the internal conversion from nftables rules in libnftnl data
>structures to iptables rules in libxtables data structures."""

Did you record any syscall-induced latency? The classic ABI used a
one-syscall approach, passing the entire buffer at once. With
netlink, it's a bit of a ping-pong between user and kernel unless one
uses mmap like on AF_PACKET — and I don't see any mmap in libmnl or
libnftnl.

Furthermore, loading the ruleset is just one aspect. Evaluating it
for every packet is what should weigh in a lot more. Did you by
chance collect any numbers in that regard?
