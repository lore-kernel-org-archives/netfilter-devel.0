Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B095FC7619A
	for <netfilter-devel@archiver.kernel.org>; Tue, 11 Apr 2023 08:29:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230431AbjDKI3H (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 11 Apr 2023 04:29:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230238AbjDKI2z (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 11 Apr 2023 04:28:55 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4B7AE4210
        for <netfilter-devel@vger.kernel.org>; Tue, 11 Apr 2023 01:28:29 -0700 (PDT)
Date:   Tue, 11 Apr 2023 10:28:17 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     Jeremy Sowden <jeremy@azazel.net>,
        Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH nftables 8/8] test: py: add tests for shifted nat
 port-ranges
Message-ID: <ZDUaIa0N2R1Ay7o/@calendula>
References: <20230305101418.2233910-1-jeremy@azazel.net>
 <20230305101418.2233910-9-jeremy@azazel.net>
 <20230324225904.GB17250@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230324225904.GB17250@breakpoint.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

On Fri, Mar 24, 2023 at 11:59:04PM +0100, Florian Westphal wrote:
> Jeremy Sowden <jeremy@azazel.net> wrote:
> > +ip daddr 10.0.0.1 tcp dport 55900-55910 dnat ip to 192.168.127.1:5900-5910/55900;ok
> > +ip6 daddr 10::1 tcp dport 55900-55910 dnat ip6 to [::c0:a8:7f:1]:5900-5910/55900;ok
> 
> This syntax is horrible (yes, I know, xtables fault).
> 
> Do you think this series could be changed to grab the offset register from the
> left edge of the range rather than requiring the user to specify it a
> second time?  Something like:
> 
> ip daddr 10.0.0.1 tcp dport 55900-55910 dnat ip to 192.168.127.1:5900-5910
> 
> I'm open to other suggestions of course.

To allow to mix this with maps, I think the best approach is to add a
new flag (port-shift) and then allow the user to specify the
port-shift 'delta'.

ip daddr 10.0.0.1 tcp dport 55900-55910 dnat ip to ip saddr map { \
        192.168.127.0-129.168.127.128 : 1.2.3.4 . -55000 } port-shift

where -55000 means, subtract -55000 to the tcp dport in the packet, it
is an incremental update.

This requires a kernel patch to add the new port-shift flag.

It should be possible to add a new netlink attribute

NFTA_NAT_REG_PROTO_SHIFT

which allows for -2^16 .. +2^16 to express the (positive/negative)
delta offset.

Parser would need to be taught to deal with negative and positive
offset, we probably need a new special type for named maps too
(port-shift).

Florian, this is based on your idea to support 'add' command, which is
still needed for other usecases. I think nat is special in the sense
that the goal is to feed the registers that instruct the NAT engine
what kind of mangling is needed.
