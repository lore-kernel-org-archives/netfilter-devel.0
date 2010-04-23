From: Salatiel Filho <salatiel.filho@gmail.com>
Subject: Re: PRIO qdisc + iptables TOS target
Date: Fri, 23 Apr 2010 04:53:38 -0300
Message-ID: <u2obeb91d721004230053rc4bd530do1a3cba5c334c3852@mail.gmail.com>
References: <4bd150a7.0aaa660a.1872.ffffde4c@mx.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: arimus.uk@googlemail.com,
	netfilter-devel <netfilter-devel@vger.kernel.org>,
	lartc@mailman.ds9a.nl
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:40044 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756372Ab0DWHyA convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 23 Apr 2010 03:54:00 -0400
Received: by pvh1 with SMTP id 1so1052394pvh.19
        for <netfilter-devel@vger.kernel.org>; Fri, 23 Apr 2010 00:53:59 -0700 (PDT)
In-Reply-To: <4bd150a7.0aaa660a.1872.ffffde4c@mx.google.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Why ? Isn't the mapping done automatically based on the packet TOS ?

At least accoding to http://www.opalsoft.net/qos/DS-23.htm

   	"If you do not provide tc filters to classify traffic", the PRIO
qdisc looks at the TC_PRIO
priority to decide how to enqueue traffic. The kernel assigns each
packet a TC_PRIO priority,
based on TOS flags or socket options passed by the application.
  	The TC_PRIO is decided based on the TOS, and mapped as follows:"


[]'s
Salatiel

"O maior prazer do inteligente =E9 bancar o  idiota
   diante de um  idiota que banca o inteligente".




On Fri, Apr 23, 2010 at 04:47,  <arimus.uk@googlemail.com> wrote:
> You need a filter (tc) to direct traffic with a tos field of 0x10 to =
the prio queue.
> --- Original Message ---
> From: Salatiel Filho <salatiel.filho@gmail.com>
> Sent: Thu, 22 Apr 2010 21:46:25 Localtime
> To: netfilter@vger.kernel.org,
> =A0 =A0 =A0 =A0lartc@mailman.ds9a.nl
> Subject: PRIO qdisc + iptables TOS target
>
> i am trying to do some traffic classification using the PRIO qdisc an=
d
> i am having a few problems.
>
> I have a root htb class:
>
> tc qdisc add dev imq0 root handle 1: htb =A0default 255 r2q 1
> tc class add dev imq0 parent 1: =A0classid 1:1 htb rate 768kbit
>
> and a child PRIO
> tc class add dev imq0 parent 1:1 classid =A01:99 htb rate 96kbit ceil
> 600kbit prio 0
> tc qdisc add dev imq0 parent 1:99 prio
> tc filter add dev imq0 parent 1: protocol ip =A0prio 7 u32 match ip d=
st
> 192.168.1.99 flowid 1:99
>
>
>
>
> the result is:
>
> # tc - s class ls dev imq0
>
> class htb 1:1 root rate 768000bit ceil 768000bit burst 1599b cburst 1=
599b
> =A0Sent 2451 bytes 22 pkt (dropped 0, overlimits 0 requeues 0)
> =A0rate 1016bit 1pps backlog 0b 0p requeues 0
> =A0lended: 0 borrowed: 0 giants: 0
> =A0tokens: 250000 ctokens: 250000
>
> class htb 1:129 parent 1:1 leaf 816c: prio 0 rate 96000bit ceil
> 600000bit burst 1599b cburst 1599b
> =A0Sent 7269 bytes 50 pkt (dropped 0, overlimits 0 requeues 0)
> =A0rate 1416bit 1pps backlog 0b 0p requeues 0
>
> class prio 816c:1 parent 816c:
> =A0Sent 0 bytes 0 pkt (dropped 0, overlimits 0 requeues 0)
> =A0backlog 0b 0p requeues 0
> class prio 816c:2 parent 816c:
> =A0Sent 7269 bytes 50 pkt (dropped 0, overlimits 0 requeues 0)
> =A0backlog 0b 0p requeues 0
> class prio 816c:3 parent 816c:
> =A0Sent 0 bytes 0 pkt (dropped 0, overlimits 0 requeues 0)
> =A0backlog 0b 0p requeues 0
>
>
>
> The problem is that when i want to give a higher priority for some
> ports the packets keep going to 816:2 instead of 816:1
>
> my iptables rules:
>
>
> iptables -t mangle -I PREROUTING =A0-p tcp -m multiport --ports 22,80=
 -j
> TOS =A0--set-tos 0x10
>
> Shouldn't this rule make all packets from/to port 22 and 80 go throug=
h
> 816c:1 PRIO class ?
>
>
> Any help is very welcome.
>
>
> []'s
> Salatiel
>
> "O maior prazer do inteligente =E9 bancar o =A0idiota
> =A0 diante de um =A0idiota que banca o inteligente".
> --
> To unsubscribe from this list: send the line "unsubscribe netfilter" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
