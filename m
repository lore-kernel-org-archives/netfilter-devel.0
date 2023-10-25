Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58CE6C0032E
	for <netfilter-devel@archiver.kernel.org>; Wed, 25 Oct 2023 12:32:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234732AbjJYMcj (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 25 Oct 2023 08:32:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232775AbjJYMci (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 25 Oct 2023 08:32:38 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C10F5192
        for <netfilter-devel@vger.kernel.org>; Wed, 25 Oct 2023 05:32:34 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1qvd3o-0007na-Mr
        for netfilter-devel@vger.kernel.org; Wed, 25 Oct 2023 14:32:32 +0200
Date:   Wed, 25 Oct 2023 14:32:32 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Netfilter Development <netfilter-devel@vger.kernel.org>
Subject: Re: Netfilter queue is unable to mangle fragmented UDP6: bug?
Message-ID: <20231025123232.GA27882@breakpoint.cc>
References: <ZTSj8oazCy7PQfxY@slk15.local.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZTSj8oazCy7PQfxY@slk15.local.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Duncan Roe <duncan_roe@optusnet.com.au> wrote:
> My libnetfilter_queue application is unable to mangle UDP6 messages that have
> been fragmented. The kernel only delivers the first fragment of such a message
> to the application.
> 
> Is this a permanent restriction or a bug?

There is not enough information here to answer this question,
see below.

> messages. "Something else" in the kernel re-combines UDP4 fragments before they
> are queued to my application, so they mangle OK.

I'm not sure what you mean or what you expect to happen.

> In summary:
>  - GSO re-combines TCP fragments before tcpdump can see them.

Do you mean "segments"?  Its the other way around, with GSO/TSO, stack
builds large superpackes, one tcp header with lots of data.

Such superpackets are split at the last possible moment;
ideally by NIC/hardware.

>  - Some other kernel code re-combines UDP4 fragments before netfilter queues
>    them
>  - Some other different kernel code re-combines UDP6 fragments for the user
>    application but after netfilter queues them
>  - It's been this way for a number of years

GSO is just the software fallback of TSO, i.e. local stack passes
large skb down to the driver which will do pseudo segmentation,
this needs hardware that can handle scatterlist, which is true for
almost all nics.

There is some segmentation support for UDP to handle encapsulation
(tunneling) use cases, where stack can pass large skb and then can
have hardware or software fallback do the segmentation for us, i.e.
split according to inner protocol and add the outer udp encapsulation
to all packets.

> ================ Testing with GSO
> 
>  nfq6 cmd: nfq6 -t6 -t7 -t8 -t17 -t18 24
>  tcpdump cmd: tcpdump -i eth1 'ether host 18:60:24:bb:02:d6 && (tcp || udp) &&
>                       ! port x11'
> 
> > netcat cmds: nc -6 -q0 -u fe80::1ac0:4dff:fe04:75ba%eth0 1042 <zxc2k : nc -6 -k -l -n -p 1042 -q0 -u -v
> >               nfq6 output                                   # tcpdump o/p (early fields omitted)
> > packet received (id=169 hw=0x86dd hook=1, payload len 1496) # frag (0|1448) 33020 > 1042: UDP, length 2048
> > Packet too short to get UDP payload                         #
> >                                                             # frag (1448|608)

You are sending a large udp packet via ipv6, it doesn't fit the device mtu,
fragmentation is needed.  This has nothing to do with GSO.

> > packet received (id=176 hw=0x0800 hook=1, payload len 60)                           # > Flags [S], seq 821055799, win 64240, options [mss 1460,sackOK,TS val 3739788506 ecr 0,nop,wscale 7], length 0
> > packet received (id=177 hw=0x0800 hook=3, payload len 60, checksum not ready)       # < Flags [S.], seq 1085807033, ack 821055800, win 65160, options [mss 1460,sackOK,TS val 4164299250 ecr 3739788506,nop,wscale 7], length 0
> > packet received (id=178 hw=0x0800 hook=1, payload len 52)                           # > Flags [.], ack 1, win 502, options [nop,nop,TS val 3739788506 ecr 4164299250], length 0
> > GSO packet received (id=179 hw=0x0800 hook=1, payload len 2100, checksum not ready) # > Flags [P.], seq 1:2049, ack 1, win 502, options [nop,nop,TS val 3739788506 ecr 4164299250], length 2048

Stack built a larger packet, device or software fallback will segment
them as needed.

> ================ Testing without GSO (needs v2 nfq6)
> 
>  nfq6 cmd: nfq6 -t6 -t7 -t8 -t17 -t18 -t20 24
>  tcpdump cmd: (as above)
> 
> > netcat cmds: nc -6 -q0 -u fe80::1ac0:4dff:fe04:75ba%eth0 1042 <zxc2k : nc -6 -k -l -n -p 1042 -q0 -u -v
> >               nfq6 output                                   # tcpdump o/p (early fields and source port omitted)
> > packet received (id=1 hw=0x86dd hook=1, payload len 1496)   # frag (0|1448) > 1042: UDP, length 2048
> > Packet too short to get UDP payload                         #
> >                                                             # frag (1448|608)
> > -----------------------------------------------------------------------------
> > netcat cmds: nc -4 -q0 -u dimstar 1042 <zxc2k : nc -4 -k -l -n -p 1042 -q0 -u -v
> >               nfq6 output                                   # tcpdump o/p (early fields omitted)
> >                                                             # UDP, length 2048
> > packet received (id=3 hw=0x0800 hook=1, payload len 2076)   # udp
> > -----------------------------------------------------------------------------

It would help if you could explain what is wrong here.

You also removed tcpdump info, I suspect it was "flags [+]"
with two fragments for udp:ipv4 too?

Frag handling depends on a lot of factors, such as ip defrag being
enabled or not, where queueing happens (hook and prio), if userspace
does mtu probing (like 'ping6 -M do') or not.

And the NIC driver too.

For incoming data it also depends on sysctl settings and if
GRO/LRO is enabled.

> > packet received (id=49 hw=0x86dd hook=1, payload len 72)    # > Flags [.], ack 1, win 507, options [nop,nop,TS val 925571377 ecr 2923572945], length 0
> > packet received (id=50 hw=0x86dd hook=1, payload len 1500)  # > Flags [.], seq 1:1429, ack 1, win 507, options [nop,nop,TS val 925571377 ecr 2923572945], length 1428
> > packet received (id=51 hw=0x86dd hook=3, payload len 72)    # < Flags [.], ack 1429, win 501, options [nop,nop,TS val 2923572945 ecr 925571377], length 0
> > packet received (id=52 hw=0x86dd hook=1, payload len 692)   # > Flags [P.], seq 1429:2049, ack 1, win 507, options [nop,nop,TS val 925571377 ecr 2923572945], length 620

Kernel does software segmentation here, this is slow.
