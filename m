From: =?KOI8-R?B?SWdvciAnTG8nICjpLkwuKQ==?= <bombsiteunrested@gmail.com>
Subject: Re: recommendations on implementing a custom Netfilter hook to QUEUE
 packets before their SEQ/ACK and size before fragmentation are known?
Date: Tue, 8 Mar 2011 05:18:03 +0200
Message-ID: <AANLkTinJtySfQeSvZwAn-_1YJ5gN_XFmqf9x7tqUvnK9@mail.gmail.com>
References: <AANLkTi=x_khzkObaG4F7PrVzbStd5c1OZMCE_oKHa35b@mail.gmail.com> <y0maah61obj.fsf@fche.csb>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:33606 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753787Ab1CHDSo convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 7 Mar 2011 22:18:44 -0500
Received: by wwa36 with SMTP id 36so326175wwa.1
        for <netfilter-devel@vger.kernel.org>; Mon, 07 Mar 2011 19:18:43 -0800 (PST)
In-Reply-To: <y0maah61obj.fsf@fche.csb>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,
> I don't know what I'm talking about, but... :
> Are you sure NFQUEUE gets involved in outgoing tcp fragmentation?
Well, NFQUEUE receives 100 bytes payload, out of which 20 are IP and 20=
 TCP.
I shrink payload (adding a valid TCP option, 8 NOPs for example), so
TCP is 28 bytes and the payload size is (100-20-28).
These 8 bytes will get retransmitted over and over, breaking the
transmission and coming from the most unlucky packet that started a
SEQ/ACK war.
Same happens when payload gets larger.

>
>> also want to have control over SEQ/ACK numbers assigned to
>> both packets and connection structures.
>
> It'd be the TCP layer's job to fragment outgoing packets, considering
> the appropriate MSS. =A0conntrack defragments, as far as I can see,
> nfqueue doesn't deal with the issue at all.

Of course it is.
But, given example - want to modify packet so it's data size (mean,
data =3D=3D anything after tcphdr data offset) will change. Wasn't NFQU=
EUE
oriented at doing any kinds of MITM/encryption stuff, not being used
as a drop-in replacement for pcap thus a base for l7-filter only?
What happens then? Retransmission. What happens if I want to send out
a packet which length is bigger than MTU? Partial fragmentation thus
SEQ/ACK flaw leading to constant retransmission of a first fragment.
More, the same happened when trying to capture packet withing mangle
or raw table, which is nonetheless strange.

=46rom looking at the code, guess the only possible workaround is to us=
e
nfq_set_verdict(NF_STOLEN, ...) and reinject the modified packet.
But again, that's not enough to deal with whole connection tracking thi=
ng.

>> [...] =A0Can anyone point me to correct place in kernel sources to
>> see/attach with SystemTap and track how SEQs are generated and how
>> outgoing packets are planned to be fragmented or even dropped?
>> Deliberately want a good tour. [...]
>
> For plain ipv4, for recent systemtap versions:
>
> =A0 =A0probe kernel.function("secure_tcp_sequence_number").return {
> =A0 =A0 =A0 =A0 =A0printf ("%s -> %d\n", @entry($$parms), $return)
> =A0 =A0}

> =A0 =A0probe kernel.function("tcp_fragment") {
> =A0 =A0 =A0 =A0 =A0println($$parms, " ", @cast(&$skb->cb[0], "tcp_skb=
_cb")->seq,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 " ", @cast(&$skb-=
>cb[0], "tcp_skb_cb")->end_seq)
> =A0 =A0}
>
> sk=3D0xffff8805215d4880 skb=3D0xffff8805125fac00 len=3D0x500 mss_now=3D=
0x5a8 1280 3015968150 3016000006

Answer accepted. So will running a dump_trace() or similar for
anything called after nfq_set_verdict reveal a call to this functions?

cheers,
Igor
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
