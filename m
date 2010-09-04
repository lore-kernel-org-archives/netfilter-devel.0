From: Nicola Padovano <nicola.padovano@gmail.com>
Subject: Re: fragmented packet
Date: Sun, 5 Sep 2010 01:31:01 +0200
Message-ID: <AANLkTimmN8T4fw=kW+CB0Oh285wrVb4BD4_bx9k_kVxs@mail.gmail.com>
References: <AANLkTikniSd5X_ryuhWbAyDLPa7oDSDULe1iYfG02vuP@mail.gmail.com> <alpine.LNX.2.01.1009050017350.15290@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: netfilter-devel <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:63183 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753178Ab0IDXbW (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 4 Sep 2010 19:31:22 -0400
Received: by wwj40 with SMTP id 40so4608800wwj.1
        for <netfilter-devel@vger.kernel.org>; Sat, 04 Sep 2010 16:31:21 -0700 (PDT)
In-Reply-To: <alpine.LNX.2.01.1009050017350.15290@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

> MTU=4 does not even make for a proper IPv4 packet, for which
> the minimum reasonable MTU would be the IPv4 header size.
the minimum size of ipv4 header is 20 bytes, the ethernet protocol use
mtu=16byte, so the sentence below is not valid (imho)...i can build a
layer2 protocol where the mtu is 4 bytes: IP protocol must be able to
work above my layer2

>>sk_buff len: 24
>>!!!fragmented!!!
>>frag off: 0
>>
>>sk_buff len: 24
>>!!!fragmented!!!
>>frag off: 0
>
> This might be the reply.
no, it is impossibile because i've no response with that line of hping
(i send only one packet, zero receive): infact the output is:
--- localhost hping statistic ---
1 packets tramitted, 0 packets received, 100% packet loss
(0 received --- READ THE WHY BELOW )



> Input only, and empty fragment. You ought to check the packet size
the packet size is 40 bytes....


BELOW:
but...maybe i've found the "solution"...but i've to test it yet.
So: i've a 40 bytes packet, and a MTU of 4 byte. the payload size is
20 byte (because hping use the smaller ipheader: 20bytes). At this
point the fragment's number is -inevitably- 20/4 = 5. But, how can i
calculate the fragment offset?
In this way: the first packet has fragoff = 0, the second packet has
fragoff = size of the first fragment / 8 = 0!!! (rounded down), the
third packet has fragoff = (size of the first fragment+size of the
second fragment) / 8 = 1...
That's why i have no packet received, because i can't defragmented a
packet with some frags that have the same fragoff!
So in this way we have explained:
1. why i haven't receive a response packet
2. why i have the same fragoff

it's all ok, now.

what do you think Jan?

-- 
Nicola Padovano
e-mail: nicola.padovano@gmail.com
web: http://npadovano.altervista.org
