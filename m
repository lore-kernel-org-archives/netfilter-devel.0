Return-Path: <SRS0=WPBU=CJ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5ECACC433E2
	for <netfilter-devel@archiver.kernel.org>; Mon, 31 Aug 2020 16:36:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3ED1D20719
	for <netfilter-devel@archiver.kernel.org>; Mon, 31 Aug 2020 16:36:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728233AbgHaQgX (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 31 Aug 2020 12:36:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727019AbgHaQgX (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 31 Aug 2020 12:36:23 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75A6BC061573
        for <netfilter-devel@vger.kernel.org>; Mon, 31 Aug 2020 09:36:22 -0700 (PDT)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1kCmn0-0007FE-94; Mon, 31 Aug 2020 18:36:14 +0200
Date:   Mon, 31 Aug 2020 18:36:14 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, fw@strlen.de, eric@garver.life
Subject: Re: [PATCH] netfilter: nf_tables: coalesce multiple notifications
 into one skbuff
Message-ID: <20200831163614.GX23632@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org, fw@strlen.de, eric@garver.life
References: <20200827172842.24478-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200827172842.24478-1-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Pablo,

On Thu, Aug 27, 2020 at 07:28:42PM +0200, Pablo Neira Ayuso wrote:
> On x86_64, each notification results in one skbuff allocation which
> consumes at least 768 bytes due to the skbuff overhead.
> 
> This patch coalesces several notifications into one single skbuff, so
> each notification consumes at least ~211 bytes, that ~3.5 times less
> memory consumption. As a result, this is reducing the chances to exhaust
> the netlink socket receive buffer.
> 
> Rule of thumb is that each notification batch only contains netlink
> messages whose report flag is the same, nfnetlink_send() requires this
> to do appropriately delivery to userspace, either via unicast (echo
> mode) or multicast (monitor mode).
> 
> The skbuff control buffer is used to annotate the report flag for later
> handling at the new coalescing routine.
> 
> The batch skbuff notification size is NLMSG_GOODSIZE, using a larger
> skbuff would allow for more socket receiver buffer savings (to amortize
> the cost of the skbuff even more), however, going over that size might
> break userspace applications, so let's be conservative and stick to
> NLMSG_GOODSIZE.

With this patch in place on top of your other one ("netfilter:
nfnetlink: nfnetlink_unicast() reports EAGAIN instead of ENOBUFS"),
firewalld (as well as nft with same input) now report:

| netlink: Error: Could not process rule: No space left on device

The JSON snippet causing the problem is indeed quite big though:

| % grep "\"\(add\|insert\)\"" fail.pp.json | wc -l
| 462

Eric told me he plans to split initial ruleset creation into several
chunks though, so this should at least not be a blocker for firewalld.

something seems to be fishy, though. Here's a reproducer:

| #!/bin/bash
| 
| numrules="$1"
| 
| nft flush ruleset
| (
| 	echo "add table t"
| 	echo "add chain t c"
| 	for ((i = 0; i < $numrules; i++)); do
| 		echo "add rule t c ip saddr 10.0.0.1 ip daddr 10.0.0.2 tcp dport 27374 mark 0x23 counter accept"
| 	done
| ) | nft -ef -

It starts failing at 13, which is not much. Interestingly, it fails outside of
the container, too. And it even echoes part of the commands:

| add table ip t
| add chain ip t c
| add rule ip t c ip saddr 10.0.0.1 ip daddr 10.0.0.2 tcp dport 27374 meta mark 0x00000023 counter packets 0 bytes 0 accept
| add rule ip t c ip saddr 10.0.0.1 ip daddr 10.0.0.2 tcp dport 27374 meta mark 0x00000023 counter packets 0 bytes 0 accept
| add rule ip t c ip saddr 10.0.0.1 ip daddr 10.0.0.2 tcp dport 27374 meta mark 0x00000023 counter packets 0 bytes 0 accept
| add rule ip t c ip saddr 10.0.0.1 ip daddr 10.0.0.2 tcp dport 27374 meta mark 0x00000023 counter packets 0 bytes 0 accept
| add rule ip t c ip saddr 10.0.0.1 ip daddr 10.0.0.2 tcp dport 27374 meta mark 0x00000023 counter packets 0 bytes 0 accept
| add rule ip t c ip saddr 10.0.0.1 ip daddr 10.0.0.2 tcp dport 27374 meta mark 0x00000023 counter packets 0 bytes 0 accept
| netlink: Error: Could not process rule: No space left on device

Is this a bug in your patch?

Cheers, Phil
