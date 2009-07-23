From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: A general question about IP fragmented packets and netfilter
Date: Thu, 23 Jul 2009 11:51:38 +0200 (CEST)
Message-ID: <alpine.LSU.2.00.0907231149350.6513@fbirervta.pbzchgretzou.qr>
References: <alpine.LSU.2.00.0907231148440.6513@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Giacomo <delleceste@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:49598 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752030AbZGWJvi (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 23 Jul 2009 05:51:38 -0400
In-Reply-To: <alpine.LSU.2.00.0907231148440.6513@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


>Don't strip the ml
>
>---------- Forwarded message ----------
>> On Thursday 2009-07-23 08:40, Giacomo wrote:
>>>
>>>Starting from NF_IP_PRE_ROUTING, where destination NAT and
>>>de-masquerading takes place, do the packets arrive fragmented - and
>>>netfilter takes care of the fragments - or do they arrive already
>>>reassembled from the IP stack?
>>>
>>>In the first case, what is, generally speaking, the technique
>>>adopted to track fragmented IP packets and assign each of them to
>>>the correct flow?
>>
>> Connection tracking does not care about packets or their fragment
>> bits per se.
>
>Yes but suppose a fragmented ip protocol hits the NF_IP_PRE_ROUTING hook and
>there has to be destination Natted (for instance because being part of
>a Masqueraded
>stream). Such a packet, without a TCP header, must be recognized as part of the
>masqueraded stream, and it has only an IP header, with `More
>Fragments' set and some
>data. How is it associated to the masqueraded flow if the packet is
>not reassembled?

It would not be. Hence the defragmenter is mandatory.

>That is, how is it destination-NATTED?

Once it is defragmented, NAT can take place.

>> Because it reads out the layer-4 header (TCP/etc.) however,
>> it defragments packets for simplicity.
>>
>>>In the second case, if I register with netfilter NF_IP_PRE_ROUTING
>>>hook, which is the correct "priority"
>>>to assign during registration to receive packets already reassembled?
>>
>> Before NF_IP_PRI_CONNTRACK_DEFRAG.
>
>Do you mean that before NF_IP_PRI_CONNTRACK_DEFRAG, i.e. NF_IP_PRI_FIRST,

Before NF_IP_PRI_CONNTRACK_DEFRAG, fragments will be visible.

>in the NF_IP_PRE_ROUTING hook, packets arrive reassembled, that is there are no
>IP packets with 'More Fragments' set to true?
>
>Thanks a lot, very kind of you.
>
>Giacomo
>
>
>

