Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81F94C7619A
	for <netfilter-devel@archiver.kernel.org>; Tue, 11 Apr 2023 10:53:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229936AbjDKKxS (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 11 Apr 2023 06:53:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229931AbjDKKxR (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 11 Apr 2023 06:53:17 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7C7941982
        for <netfilter-devel@vger.kernel.org>; Tue, 11 Apr 2023 03:53:16 -0700 (PDT)
Date:   Tue, 11 Apr 2023 12:53:13 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     Jeremy Sowden <jeremy@azazel.net>,
        Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH nftables 8/8] test: py: add tests for shifted nat
 port-ranges
Message-ID: <ZDU8GcaowpCbIeDJ@calendula>
References: <20230305101418.2233910-1-jeremy@azazel.net>
 <20230305101418.2233910-9-jeremy@azazel.net>
 <20230324225904.GB17250@breakpoint.cc>
 <ZDUaIa0N2R1Ay7o/@calendula>
 <20230411102532.GC21051@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230411102532.GC21051@breakpoint.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Apr 11, 2023 at 12:25:32PM +0200, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > On Fri, Mar 24, 2023 at 11:59:04PM +0100, Florian Westphal wrote:
> > > Jeremy Sowden <jeremy@azazel.net> wrote:
> > > > +ip daddr 10.0.0.1 tcp dport 55900-55910 dnat ip to 192.168.127.1:5900-5910/55900;ok
> > > > +ip6 daddr 10::1 tcp dport 55900-55910 dnat ip6 to [::c0:a8:7f:1]:5900-5910/55900;ok
> > > 
> > > This syntax is horrible (yes, I know, xtables fault).
> > > 
> > > Do you think this series could be changed to grab the offset register from the
> > > left edge of the range rather than requiring the user to specify it a
> > > second time?  Something like:
> > > 
> > > ip daddr 10.0.0.1 tcp dport 55900-55910 dnat ip to 192.168.127.1:5900-5910
> > > 
> > > I'm open to other suggestions of course.
> > 
> > To allow to mix this with maps, I think the best approach is to add a
> > new flag (port-shift) and then allow the user to specify the
> > port-shift 'delta'.
> > 
> > ip daddr 10.0.0.1 tcp dport 55900-55910 dnat ip to ip saddr map { \
> >         192.168.127.0-129.168.127.128 : 1.2.3.4 . -55000 } port-shift
> 
> Sorry, I don't see the usecase for different deltas.

Then, users will more than one single rule for different port-shift
mappings?

> But even if we assume that, kernel already takes the dnat target port
> number from a register.

In my proposal, kernel would take the delta from register, the flag
tells the nat core how to interpret this.

> > where -55000 means, subtract -55000 to the tcp dport in the packet, it
> > is an incremental update.
> > 
> > This requires a kernel patch to add the new port-shift flag.
> 
> ... so I don't see why we need a new port-shift flag at all.
> I think best approach is to provide the actual new dport in a register,
> like we already do right now.
>
> So we need an 'add' operation in kernel to compute

This is an 'add' operation built-in into the NAT engine.

How would a generic 'add' operation in the kernel will work with
concatenations?

> portreg = sreg_with_port + sreg_with_offset
> > 
> > Florian, this is based on your idea to support 'add' command, which is
> > still needed for other usecases. I think nat is special in the sense
> > that the goal is to feed the registers that instruct the NAT engine
> > what kind of mangling is needed.
> 
> See above.  I don't think we should go with the existing NAT flag,
> its very much a hack to overcome iptables design limitations.
