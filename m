From: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>
Subject: handling fragments in nf_conntrack(was Re: NAT for IPv6
 FINISHED!!!!!)
Date: Thu, 27 May 2004 18:16:51 +0900 (JST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <200405270916.SAA28894@toshiba.co.jp>
References: <20040524211902.69395.qmail@web90004.mail.scd.yahoo.com>
	<200405261401.XAA16017@toshiba.co.jp>
	<006c01c4433e$00fb2970$0400000a@majinbu>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: tato.net@tin.it
In-Reply-To: <006c01c4433e$00fb2970$0400000a@majinbu>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


Hi,

From: "Davide Guerri" <tato.net@tin.it>
Subject: Re: NAT for IPv6 FINISHED!!!!!
Date: Wed, 26 May 2004 18:25:05 +0200

> Hi Yasuyuki,
> how do you handle ipv6 fragment? It is possible to know original fragments
> size?

nf_conntrack pass the original fragmented packets to next network processing.

These packets are binded with the conntrack which tuple is consisted with
IPv6 addresses and ID in Fragmented Header. This conntrack has the reference
to the reassembled packet. And it is binded with other conntrack dependent on
upper protocol. for example,

	fragments -> conntrack (protocol=frag6) -> reassembled packet

	-> conntrack (protocol=udp)

Then you can access to the reassembled packet from original packets.
But, of cause, if you mangle original packets, reassembled packet must be
mangled too.

IPv4 fragmented packets are handled in the same way as ip_conntrack.
(pass reassembled packet to next processing)

Regards,

> BTW, some time ago I have finished my first version of NA(P)T-PT but I wrote
> my own connection tracking code (I had expires and I could not wait for an
> IPv6 conntrack that could handle fragmentation).
> 
> However my connection tracking code isn't that different from yours so, with
> minimal effort, I can remove it and use your code when (and if) it will meet
> my requirements.
> 
> My NA(P)T-PT supports fragmentation (on IPv4 and IPv6 side), preserves the
> DF(IPv4) and Fragment Header(IPv6) semantics (it is possible to do path MTU
> discovery throught it and it can handle correctly fragments with DF flag
> set) and, for now, it works like the masquerade: it's unidiretional, in the
> sense that connections may start only from IPv6 side, and IPv4 source
> address (for IPv6 to IPv4 translations) is calculated dinamically.
> Unfortunately to handle correctly fragments I have had to re-write parts of
> kernel fragmentation/defragmentation code, so I'm not that proud of my code
> ;)
> 
> Best regards,
> Davide Guerri.

-----------------------------------------------------------------
Yasuyuki KOZAKAI @ USAGI Project <yasuyuki.kozakai@toshiba.co.jp>
