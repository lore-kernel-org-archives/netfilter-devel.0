Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 375BFC25B47
	for <netfilter-devel@archiver.kernel.org>; Fri, 27 Oct 2023 10:41:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229633AbjJ0KlJ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 27 Oct 2023 06:41:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229503AbjJ0KlI (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 27 Oct 2023 06:41:08 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18FE4191
        for <netfilter-devel@vger.kernel.org>; Fri, 27 Oct 2023 03:41:03 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1qwKGz-0004b5-G0; Fri, 27 Oct 2023 12:41:01 +0200
Date:   Fri, 27 Oct 2023 12:41:01 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Florian Westphal <fw@strlen.de>,
        Netfilter Development <netfilter-devel@vger.kernel.org>
Subject: Re: Netfilter queue is unable to mangle fragmented UDP6: bug?
Message-ID: <20231027104101.GA6174@breakpoint.cc>
References: <ZTSj8oazCy7PQfxY@slk15.local.net>
 <20231025123232.GA27882@breakpoint.cc>
 <ZTscICNz5aUmLYSr@slk15.local.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZTscICNz5aUmLYSr@slk15.local.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Duncan Roe <duncan_roe@optusnet.com.au> wrote:
> I expected the netfilter program to see the full UDP datagram as sent. With
> UDP/IPv4 it does see the full datagram, but not with UDP/IPv6.

For INPUT ipv4 stack will defrag before INPUT hooks are called.

From ipv6 point of view, the ipv6 next header protocol value isn't
relevant at that stage, so it doesn't matter if thats IPPROTO_TCP,
IPPROTO_UDP or, in this case, IPPROTO_FRAGMENT.

INPUT hook runs on the arrived packets, then the packets are delivered
to the next handler, i.e. the fragment-collection done by the IPPROTO_FRAGMENT
handlers is done AFTER the INPUT hook.

To get the behaviour you want you need to enable netfilter ipv6 defrag.

There is currently no way to do this standalone, you will need to add
a dummy tproxy or conntrack rule (the latter will enable conntrack too
which might not be what you want).

Or you modify your ruleset to also queue fragments to userspace and
do ipv6 defrag yourself in the nfqueue application.

> > Do you mean "segments"?  Its the other way around, with GSO/TSO, stack
> > builds large superpackes, one tcp header with lots of data.
> 
> Sorry for the confusion here. I only meant to say that there is no problem with
> TCP.

Yes, because no ipv6 fragmentation takes place.

> IOW kernel delivers to filter program exactly what was in the buffer when the
> remote application did a write(2) (for buffer size up to just under 64KB).

Not really, it depends on the protocols involved and the network, think
e.g. of a traffic policier that enforces some rate limit.

> I don't know what GSO is, only that it's strongly recommended to use it.

https://en.wikipedia.org/wiki/TCP_offload_engine

But if you are talking about F_GSO flag for nfqueue -- it does NOT
enable GSO, on the contrary.  It tells the kernel "This program
can handle large packets with "bogus" (to-be-filled-by-hardware)
checksum".

Without the flag, tcp packets need to be splitted in software and their
checksums need to be computed too (i.e. all the data needs to be read).

> This example shows a UDP4 2KB datagram being successfully mangled and a UDP6 2KB
> datagram failing to be mangled.
> >
> > You also removed tcpdump info, I suspect it was "flags [+]"
> > with two fragments for udp:ipv4 too?
> 
> There are 2 fragments for both IPv4 and IPv6.
> 
> tcpdump does not report any flags:
> 
> > 08:16:09.713395 IP6 fe80::1a60:24ff:febb:2d6 > fe80::1ac0:4dff:fe04:75ba: frag (0|1448) 47843 > 1042: UDP, length 2048
> > 08:16:09.713395 IP6 fe80::1a60:24ff:febb:2d6 > fe80::1ac0:4dff:fe04:75ba: frag (1448|608)
> > 08:17:22.924883 IP smallstar.local.net.55288 > dimstar.local.net.1042: UDP, length 2048
> > 08:17:22.924883 IP smallstar.local.net > dimstar.local.net: udp

Forgot to mention: in the future when debugging problems, please use
-vvvv (as many as needed), tcpdump elides a lot of information
otherwise.
