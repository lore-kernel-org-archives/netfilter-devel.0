From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: fragmented packet
Date: Sun, 5 Sep 2010 00:19:26 +0200 (CEST)
Message-ID: <alpine.LNX.2.01.1009050017350.15290@obet.zrqbmnf.qr>
References: <AANLkTikniSd5X_ryuhWbAyDLPa7oDSDULe1iYfG02vuP@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel <netfilter-devel@vger.kernel.org>
To: Nicola Padovano <nicola.padovano@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:48497 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753689Ab0IDWT2 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 4 Sep 2010 18:19:28 -0400
In-Reply-To: <AANLkTikniSd5X_ryuhWbAyDLPa7oDSDULe1iYfG02vuP@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Saturday 2010-09-04 19:09, Nicola Padovano wrote:
>then iptables (where TAR is my new target)
>[IPTABLES]
>iptables -t mangle -A PREROUTING -p tcp -s localhost -j TAR
>[/IPTABLES]
>(note: i use mangle table to have available PREROUTING hook, where the
>packets are not yet defragmented)
>
>so hpinging in this way (-c = packets' number, -m = mtu in byte)
>[HPING]
>hping -m 4 -c 1 localhost
>[/HPING]

MTU=4 does not even make for a proper IPv4 packet, for which
the minimum reasonable MTU would be the IPv4 header size.
Plus perhaps at least part of the fragment, i.e. 24 octets.
God knows what happens if you use MTU=4.
An MTU of 4

>Now let's a look to output
>[OUTPUT]
>sk_buff len: 24
>!!!fragmented!!!
>frag off: 0
>
>sk_buff len: 24
>!!!fragmented!!!
>frag off: 0

This might be the reply.

>sk_buff len: 24
>!!!fragmented!!!
>frag off: 1
>
>sk_buff len: 24
>!!!fragmented!!!
>frag off: 1

Also reply.

>sk_buff len: 24
>!!!fragmented!!!
>frag off: 2

Input only, and empty fragment. You ought to check the packet size.

