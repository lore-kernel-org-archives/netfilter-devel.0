Return-Path: <SRS0=cI96=DJ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8F35C4363D
	for <netfilter-devel@archiver.kernel.org>; Fri,  2 Oct 2020 09:00:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8A20D20719
	for <netfilter-devel@archiver.kernel.org>; Fri,  2 Oct 2020 09:00:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726754AbgJBJAg (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 2 Oct 2020 05:00:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725993AbgJBJAg (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 2 Oct 2020 05:00:36 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7080C0613D0
        for <netfilter-devel@vger.kernel.org>; Fri,  2 Oct 2020 02:00:35 -0700 (PDT)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1kOGvZ-0006C3-9e; Fri, 02 Oct 2020 11:00:33 +0200
Date:   Fri, 2 Oct 2020 11:00:33 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Florian Westphal <fw@strlen.de>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Subject: Re: [net-next PATCH 0/2] netfilter: Improve inverted IP prefix
 matches
Message-ID: <20201002090033.GB1845@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
References: <20201001165744.25466-1-phil@nwl.cc>
 <20201001222536.GB12773@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201001222536.GB12773@breakpoint.cc>
Sender:  <n0-1@orbyte.nwl.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Florian,

On Fri, Oct 02, 2020 at 12:25:36AM +0200, Florian Westphal wrote:
> Phil Sutter <phil@nwl.cc> wrote:
> > The following two patches improve packet throughput in a test setup
> > sending UDP packets (using iperf3) between two netns. The ruleset used
> > on receiver side is like this:
> > 
> > | *filter
> > | :test - [0:0]
> > | -A INPUT -j test
> > | -A INPUT -j ACCEPT
> > | -A test ! -s 10.0.0.0/10 -j DROP # this line repeats 10000 times
> > | COMMIT
> > 
> > These are the generated VM instructions for each rule:
> > 
> > | [ payload load 4b @ network header + 12 => reg 1 ]
> > | [ bitwise reg 1 = (reg=1 & 0x0000c0ff ) ^ 0x00000000 ]
> 
> Not related to this patch, but we should avoid the bitop if the
> netmask is divisble by 8 (can adjust the cmp -- adjusting the
> payload expr is probably not worth it).

See the patch I just sent to this list. I adjusted both - it simply
didn't appear to me that I could get by with reducing the cmp expression
size only. The upside though is that detecting the prefix match based on
payload expression length is quick and easy.

Someone will have to adjust nft tool, though. ;)

> > | [ cmp eq reg 1 0x0000000a ]
> > | [ counter pkts 0 bytes 0 ]
> 
> Out of curiosity, does omitting 'counter' help?
> 
> nft counter is rather expensive due to bh disable,
> iptables does it once at the evaluation loop only.

I changed the test to create the base ruleset using iptables-nft-restore
just as before, but create the rules in 'test' chain like so:

| nft add rule filter test ip saddr != 10.0.0.0/10 drop

The VM code is as expected:

| [ payload load 4b @ network header + 12 => reg 1 ]
| [ bitwise reg 1 = (reg=1 & 0x0000c0ff ) ^ 0x00000000 ]
| [ cmp eq reg 1 0x0000000a ]
| [ immediate reg 0 drop ]

Performance is ~7000pkt/s. So while it's faster than iptables-nft, it's
still quite a bit slower than legacy iptables despite the skipped
counters.

Cheers, Phil
