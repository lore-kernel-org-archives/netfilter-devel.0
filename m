From: fche@redhat.com (Frank Ch. Eigler)
Subject: Re: recommendations on implementing a custom Netfilter hook to QUEUE packets before their SEQ/ACK and size before fragmentation are known?
Date: Mon, 07 Mar 2011 18:52:00 -0500
Message-ID: <y0maah61obj.fsf@fche.csb>
References: <AANLkTi=x_khzkObaG4F7PrVzbStd5c1OZMCE_oKHa35b@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel <netfilter-devel@vger.kernel.org>
To: =?us-ascii?Q?=3D=3FKOI8-R=3FB=3FSWdvciAnTG8nICjpLkwuKQ=3D=3D=3F=3D?=
	<bombsiteunrested@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:27690 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753684Ab1CGXwD (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 7 Mar 2011 18:52:03 -0500
In-Reply-To: <AANLkTi=x_khzkObaG4F7PrVzbStd5c1OZMCE_oKHa35b@mail.gmail.com> (KOI8-R's message of "Wed, 2 Mar 2011 05:22:39 +0200")
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


Hi -

=?KOI8-R?B?SWdvciAnTG8nICjpLkwuKQ==?= <bombsiteunrested@gmail.com> writes:

> What I look for is reimplementing a part of NFQUEUE functionality at
> the stage where TCP packet is formed before sending to network.

I don't know what I'm talking about, but... :
Are you sure NFQUEUE gets involved in outgoing tcp fragmentation?

> It seems that NFQUEUE can't just handle expanded (> MTU) packet, and
> also want to have control over SEQ/ACK numbers assigned to
> both packets and connection structures.

It'd be the TCP layer's job to fragment outgoing packets, considering
the appropriate MSS.  conntrack defragments, as far as I can see,
nfqueue doesn't deal with the issue at all.

> [...]  Can anyone point me to correct place in kernel sources to
> see/attach with SystemTap and track how SEQs are generated and how
> outgoing packets are planned to be fragmented or even dropped?
> Deliberately want a good tour. [...]

For plain ipv4, for recent systemtap versions:

    probe kernel.function("secure_tcp_sequence_number").return {
          printf ("%s -> %d\n", @entry($$parms), $return)
    }

[...]
saddr=0x100007f daddr=0x100007f sport=0xcee1 dport=0x3815 -> 1787682413
saddr=0x100007f daddr=0x100007f sport=0x3815 dport=0xcee1 -> 1793064379
saddr=0x100007f daddr=0x100007f sport=0x75c9 dport=0xf03 -> 1934845113
saddr=0x100007f daddr=0x100007f sport=0xf03 dport=0x75c9 -> 1938803971
[...]

    probe kernel.function("tcp_fragment") {
          println($$parms, " ", @cast(&$skb->cb[0], "tcp_skb_cb")->seq,
                           " ", @cast(&$skb->cb[0], "tcp_skb_cb")->end_seq)
    }

sk=0xffff8805215d4880 skb=0xffff8805125fac00 len=0x500 mss_now=0x5a8 1280 3015968150 3016000006
[...]


- FChE
