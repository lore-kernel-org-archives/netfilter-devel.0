Return-Path: <SRS0=Y5HT=D4=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE440C4363A
	for <netfilter-devel@archiver.kernel.org>; Wed, 21 Oct 2020 10:43:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 50F4C20795
	for <netfilter-devel@archiver.kernel.org>; Wed, 21 Oct 2020 10:43:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2410333AbgJUKn1 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 21 Oct 2020 06:43:27 -0400
Received: from correo.us.es ([193.147.175.20]:35312 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2410312AbgJUKn0 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 21 Oct 2020 06:43:26 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id DEF0CD2B841
        for <netfilter-devel@vger.kernel.org>; Wed, 21 Oct 2020 12:43:24 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D036CFA52A
        for <netfilter-devel@vger.kernel.org>; Wed, 21 Oct 2020 12:43:24 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id C599853893; Wed, 21 Oct 2020 12:43:24 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 739A4E150F;
        Wed, 21 Oct 2020 12:43:22 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 21 Oct 2020 12:43:22 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 57A864301DE4;
        Wed, 21 Oct 2020 12:43:22 +0200 (CEST)
Date:   Wed, 21 Oct 2020 12:43:22 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>, Florian Westphal <fw@strlen.de>,
        netfilter-devel@vger.kernel.org
Subject: Re: [net-next PATCH 0/2] netfilter: Improve inverted IP prefix
 matches
Message-ID: <20201021104321.GA30742@salvia>
References: <20201001165744.25466-1-phil@nwl.cc>
 <20201001222536.GB12773@breakpoint.cc>
 <20201002090033.GB1845@orbyte.nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20201002090033.GB1845@orbyte.nwl.cc>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Phil,

On Fri, Oct 02, 2020 at 11:00:33AM +0200, Phil Sutter wrote:
> Hi Florian,
> 
> On Fri, Oct 02, 2020 at 12:25:36AM +0200, Florian Westphal wrote:
> > Phil Sutter <phil@nwl.cc> wrote:
> > > The following two patches improve packet throughput in a test setup
> > > sending UDP packets (using iperf3) between two netns. The ruleset used
> > > on receiver side is like this:
> > > 
> > > | *filter
> > > | :test - [0:0]
> > > | -A INPUT -j test
> > > | -A INPUT -j ACCEPT
> > > | -A test ! -s 10.0.0.0/10 -j DROP # this line repeats 10000 times
> > > | COMMIT
> > > 
> > > These are the generated VM instructions for each rule:
> > > 
> > > | [ payload load 4b @ network header + 12 => reg 1 ]
> > > | [ bitwise reg 1 = (reg=1 & 0x0000c0ff ) ^ 0x00000000 ]
> > 
> > Not related to this patch, but we should avoid the bitop if the
> > netmask is divisble by 8 (can adjust the cmp -- adjusting the
> > payload expr is probably not worth it).
> 
> See the patch I just sent to this list. I adjusted both - it simply
> didn't appear to me that I could get by with reducing the cmp expression
> size only. The upside though is that detecting the prefix match based on
> payload expression length is quick and easy.
> 
> Someone will have to adjust nft tool, though. ;)
> 
> > > | [ cmp eq reg 1 0x0000000a ]
> > > | [ counter pkts 0 bytes 0 ]
> > 
> > Out of curiosity, does omitting 'counter' help?
> > 
> > nft counter is rather expensive due to bh disable,
> > iptables does it once at the evaluation loop only.
> 
> I changed the test to create the base ruleset using iptables-nft-restore
> just as before, but create the rules in 'test' chain like so:
> 
> | nft add rule filter test ip saddr != 10.0.0.0/10 drop
> 
> The VM code is as expected:
> 
> | [ payload load 4b @ network header + 12 => reg 1 ]
> | [ bitwise reg 1 = (reg=1 & 0x0000c0ff ) ^ 0x00000000 ]
> | [ cmp eq reg 1 0x0000000a ]
> | [ immediate reg 0 drop ]
> 
> Performance is ~7000pkt/s. So while it's faster than iptables-nft, it's
> still quite a bit slower than legacy iptables despite the skipped
> counters.

iptables is optimized for matching on input/output device name and
IPv4 address + mask (see ip_packet_match()) for historical reasons,
iptables does not use a match for this since the beginning.

One possibility (in the short-term) is to add an internal kernel
expression to achieve the same behaviour. The kernel needs to detects
for:

payload (nh, offset to ip saddr or ip daddr or ip protocol) + cmp
payload (nh, offset to ip saddr or ip daddr) + bitwise + cmp
meta (iifname or oifname) + bitwise + cmp
meta (iifname or oifname) + cmp

at the very beginning of the rule.

and squash these expressions into the "built-in" iptables match
expression which emulates ip_packet_match().

Not nice, but if microbenchmarks using thousand of rules really matter
(this is worst case O(n) linear list evaluation...) then it might make
sense to explore this.
