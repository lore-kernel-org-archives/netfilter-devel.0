Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2AA8BC7619A
	for <netfilter-devel@archiver.kernel.org>; Wed, 12 Apr 2023 11:23:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229897AbjDLLXo (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 12 Apr 2023 07:23:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229701AbjDLLXm (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 12 Apr 2023 07:23:42 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E80CD76A4
        for <netfilter-devel@vger.kernel.org>; Wed, 12 Apr 2023 04:23:20 -0700 (PDT)
Date:   Wed, 12 Apr 2023 13:22:51 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     Jeremy Sowden <jeremy@azazel.net>,
        Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH nftables 8/8] test: py: add tests for shifted nat
 port-ranges
Message-ID: <ZDaUi172jznQL5l9@calendula>
References: <20230305101418.2233910-1-jeremy@azazel.net>
 <20230305101418.2233910-9-jeremy@azazel.net>
 <20230324225904.GB17250@breakpoint.cc>
 <ZDUaIa0N2R1Ay7o/@calendula>
 <20230411123604.GF21051@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230411123604.GF21051@breakpoint.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Apr 11, 2023 at 02:36:04PM +0200, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> 
> Circling back to this.
> 
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
> > 
> > where -55000 means, subtract -55000 to the tcp dport in the packet, it
> > is an incremental update.
> > 
> > This requires a kernel patch to add the new port-shift flag.
> 
> Where is this new port-shift flag needed?  NAT engine?

My proposal was based on adding a new port-shift flag to the NAT
engine, for simplicity. So the NAT engine knows it has to fetch + add
delta to the existing port, instead of the explicit math + add, ie.
just let the NAT engine handle this port shift.

> I'm a bit confused, are you proposing new/different syntax for Jeremys
> kernel-patchset or something else?

I'm proposing an alternative approach. Jeremy's approach is based on
iptables way of doing things, which is backwards for nftables because
we need to integrate new things with map.

I think we can just set on the new flag in the NAT engine to say: "hey
NAT engine, I instruct you to do a port shift on the packet, and this
is the delta".

ip daddr 10.0.0.1 tcp dport 55900-55910 dnat ip to ip saddr map { \
         192.168.127.0-129.168.127.128 : 1.2.3.4 . -55000,
         192.168.130/24 : 1.2.3.5 . -40000 } port-shift

and all the flexibility this provides, where one might need mappings.

> AFAICS, for what you want do to, Jeremys kernel patches should
> already work as-is?
> 
> Just to be clear again, I have no objects to the kernel patches
> that Jeremy proposed.  I just dislike the iptables-inspired userspace
> syntax with a need to explicitly state the left edge of the range.

I think it is a no-go: it will require multiple rules for more than
one mapping. Then, we could extend userspace to support for:

ip daddr 10.0.0.1 tcp dport 55900-55910 dnat ip to ip saddr map { \
         192.168.127.0-129.168.127.128 : 1.2.3.4 . 45900-45910 . 55900 } port-shift
                                                                 ^^^^^

where this is the base, or even infer it, but it is a bit of
complexity to handle that from userspace, even if this is not exposed
to the syntax (ie. infered from context), that would still need to be
exposed through datatype in an explicit map definition. That will be
awkward because datatype definition of the map will have something
like:

        ipv4_addr . inet_service . base

while listing will not show the base (I am talking about the
possibility of infering the base from context).

> > It should be possible to add a new netlink attribute
> > 
> > NFTA_NAT_REG_PROTO_SHIFT
> > 
> > which allows for -2^16 .. +2^16 to express the (positive/negative)
> > delta offset.
> 
> Isn't that essentially what Jeremys patchset is already doing, i.e.
> adding a new register to store the offset?

Jeremy uses the register to store the _BASE port.

> You can't use an immediate, else maps with different deltas don't work.
> 
> > Parser would need to be taught to deal with negative and positive
> > offset, we probably need a new special type for named maps too
> > (port-shift).
> 
> You mean a pseudotype to work with 'typeof'? We alreay do this for
> verdicts so this should work.

Yes, adding a new type should not be a problem.

I think my proposal provides a simple way to support this, it just a
new flag in the NAT engine, few lines to handle it and new userspace
code to handle -/+offset in a map.

Your idea of doing it via payload + math is also good, but it would
just require more work to support this NAT port-shift feature in
userspace.

Does this help clarify? I am talking about a completely different
design for this feature, not so iptablish.
