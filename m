Return-Path: <SRS0=LVSz=EB=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52C85C4363A
	for <netfilter-devel@archiver.kernel.org>; Mon, 26 Oct 2020 12:46:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 12606207F7
	for <netfilter-devel@archiver.kernel.org>; Mon, 26 Oct 2020 12:46:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1775402AbgJZMqw (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 26 Oct 2020 08:46:52 -0400
Received: from orbyte.nwl.cc ([151.80.46.58]:57452 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1775372AbgJZMqw (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 26 Oct 2020 08:46:52 -0400
X-Greylist: delayed 1045 seconds by postgrey-1.27 at vger.kernel.org; Mon, 26 Oct 2020 08:46:51 EDT
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1kX1cp-0004sS-40; Mon, 26 Oct 2020 13:29:23 +0100
Date:   Mon, 26 Oct 2020 13:29:23 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
Subject: Re: [net-next PATCH 0/2] netfilter: Improve inverted IP prefix
 matches
Message-ID: <20201026122923.GY13016@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
References: <20201001165744.25466-1-phil@nwl.cc>
 <20201001222536.GB12773@breakpoint.cc>
 <20201002090033.GB1845@orbyte.nwl.cc>
 <20201021104321.GA30742@salvia>
 <20201021104952.GA31026@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201021104952.GA31026@salvia>
Sender:  <n0-1@orbyte.nwl.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Pablo,

On Wed, Oct 21, 2020 at 12:49:52PM +0200, Pablo Neira Ayuso wrote:
> On Wed, Oct 21, 2020 at 12:43:21PM +0200, Pablo Neira Ayuso wrote:
> > Hi Phil,
> > 
> > On Fri, Oct 02, 2020 at 11:00:33AM +0200, Phil Sutter wrote:
> > > Hi Florian,
> > > 
> > > On Fri, Oct 02, 2020 at 12:25:36AM +0200, Florian Westphal wrote:
> > > > Phil Sutter <phil@nwl.cc> wrote:
> > > > > The following two patches improve packet throughput in a test setup
> > > > > sending UDP packets (using iperf3) between two netns. The ruleset used
> > > > > on receiver side is like this:
> > > > > 
> > > > > | *filter
> > > > > | :test - [0:0]
> > > > > | -A INPUT -j test
> > > > > | -A INPUT -j ACCEPT
> > > > > | -A test ! -s 10.0.0.0/10 -j DROP # this line repeats 10000 times
> > > > > | COMMIT
> > > > > 
> > > > > These are the generated VM instructions for each rule:
> > > > > 
> > > > > | [ payload load 4b @ network header + 12 => reg 1 ]
> > > > > | [ bitwise reg 1 = (reg=1 & 0x0000c0ff ) ^ 0x00000000 ]
> > > > 
> > > > Not related to this patch, but we should avoid the bitop if the
> > > > netmask is divisble by 8 (can adjust the cmp -- adjusting the
> > > > payload expr is probably not worth it).
> > > 
> > > See the patch I just sent to this list. I adjusted both - it simply
> > > didn't appear to me that I could get by with reducing the cmp expression
> > > size only. The upside though is that detecting the prefix match based on
> > > payload expression length is quick and easy.
> > > 
> > > Someone will have to adjust nft tool, though. ;)
> > > 
> > > > > | [ cmp eq reg 1 0x0000000a ]
> > > > > | [ counter pkts 0 bytes 0 ]
> > > > 
> > > > Out of curiosity, does omitting 'counter' help?
> > > > 
> > > > nft counter is rather expensive due to bh disable,
> > > > iptables does it once at the evaluation loop only.
> > > 
> > > I changed the test to create the base ruleset using iptables-nft-restore
> > > just as before, but create the rules in 'test' chain like so:
> > > 
> > > | nft add rule filter test ip saddr != 10.0.0.0/10 drop
> > > 
> > > The VM code is as expected:
> > > 
> > > | [ payload load 4b @ network header + 12 => reg 1 ]
> > > | [ bitwise reg 1 = (reg=1 & 0x0000c0ff ) ^ 0x00000000 ]
> > > | [ cmp eq reg 1 0x0000000a ]
> > > | [ immediate reg 0 drop ]
> > > 
> > > Performance is ~7000pkt/s. So while it's faster than iptables-nft, it's
> > > still quite a bit slower than legacy iptables despite the skipped
> > > counters.
> > 
> > iptables is optimized for matching on input/output device name and
> > IPv4 address + mask (see ip_packet_match()) for historical reasons,
> > iptables does not use a match for this since the beginning.

Ah, thanks for the pointer. That function (and the code therein) pretty
clearly shows why rule-shredding is so much slower in iptables-nft than
legacy despite the attempts at improving it.

> For clarity here, I mean: iptables does not use the generic match
> infrastructure for matching on these fields, instead it is using
> ip_packet_match() which is called from ipt_do_table() which is the
> core function that evaluates the packet.
> 
> > One possibility (in the short-term) is to add an internal kernel
> > expression to achieve the same behaviour. The kernel needs to detects
> > for:
> > 
> > payload (nh, offset to ip saddr or ip daddr or ip protocol) + cmp
> > payload (nh, offset to ip saddr or ip daddr) + bitwise + cmp
> > meta (iifname or oifname) + bitwise + cmp
> > meta (iifname or oifname) + cmp
> > 
> > at the very beginning of the rule.
> > 
> > and squash these expressions into the "built-in" iptables match
> > expression which emulates ip_packet_match().
> > 
> > Not nice, but if microbenchmarks using thousand of rules really matter
> > (this is worst case O(n) linear list evaluation...) then it might make
> > sense to explore this.

I appreciate the effort to identify a solution which "just works",
though am not sure if we really should implement such hacks (yet). That
said, the "fast" expressions strictly speaking are hacks as well ...

Cheers, Phil
