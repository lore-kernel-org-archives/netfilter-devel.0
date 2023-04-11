Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0AEF5C77B6F
	for <netfilter-devel@archiver.kernel.org>; Tue, 11 Apr 2023 12:36:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229598AbjDKMgI (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 11 Apr 2023 08:36:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229581AbjDKMgH (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 11 Apr 2023 08:36:07 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A242A30FA
        for <netfilter-devel@vger.kernel.org>; Tue, 11 Apr 2023 05:36:06 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1pmDEC-0001cw-Pz; Tue, 11 Apr 2023 14:36:04 +0200
Date:   Tue, 11 Apr 2023 14:36:04 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Florian Westphal <fw@strlen.de>, Jeremy Sowden <jeremy@azazel.net>,
        Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH nftables 8/8] test: py: add tests for shifted nat
 port-ranges
Message-ID: <20230411123604.GF21051@breakpoint.cc>
References: <20230305101418.2233910-1-jeremy@azazel.net>
 <20230305101418.2233910-9-jeremy@azazel.net>
 <20230324225904.GB17250@breakpoint.cc>
 <ZDUaIa0N2R1Ay7o/@calendula>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZDUaIa0N2R1Ay7o/@calendula>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Pablo Neira Ayuso <pablo@netfilter.org> wrote:

Circling back to this.

> On Fri, Mar 24, 2023 at 11:59:04PM +0100, Florian Westphal wrote:
> > Jeremy Sowden <jeremy@azazel.net> wrote:
> > > +ip daddr 10.0.0.1 tcp dport 55900-55910 dnat ip to 192.168.127.1:5900-5910/55900;ok
> > > +ip6 daddr 10::1 tcp dport 55900-55910 dnat ip6 to [::c0:a8:7f:1]:5900-5910/55900;ok
> > 
> > This syntax is horrible (yes, I know, xtables fault).
> > 
> > Do you think this series could be changed to grab the offset register from the
> > left edge of the range rather than requiring the user to specify it a
> > second time?  Something like:
> > 
> > ip daddr 10.0.0.1 tcp dport 55900-55910 dnat ip to 192.168.127.1:5900-5910
> > 
> > I'm open to other suggestions of course.
> 
> To allow to mix this with maps, I think the best approach is to add a
> new flag (port-shift) and then allow the user to specify the
> port-shift 'delta'.
> 
> ip daddr 10.0.0.1 tcp dport 55900-55910 dnat ip to ip saddr map { \
>         192.168.127.0-129.168.127.128 : 1.2.3.4 . -55000 } port-shift
> 
> where -55000 means, subtract -55000 to the tcp dport in the packet, it
> is an incremental update.
> 
> This requires a kernel patch to add the new port-shift flag.

Where is this new port-shift flag needed?  NAT engine?
I'm a bit confused, are you proposing new/different syntax for Jeremys
kernel-patchset or something else?

AFAICS, for what you want do to, Jeremys kernel patches should
already work as-is?

Just to be clear again, I have no objects to the kernel patches
that Jeremy proposed.  I just dislike the iptables-inspired userspace
syntax with a need to explicitly state the left edge of the range.

> It should be possible to add a new netlink attribute
> 
> NFTA_NAT_REG_PROTO_SHIFT
> 
> which allows for -2^16 .. +2^16 to express the (positive/negative)
> delta offset.

Isn't that essentially what Jeremys patchset is already doing, i.e.
adding a new register to store the offset?

You can't use an immediate, else maps with different deltas don't work.

> Parser would need to be taught to deal with negative and positive
> offset, we probably need a new special type for named maps too
> (port-shift).

You mean a pseudotype to work with 'typeof'? We alreay do this for
verdicts so this should work.
