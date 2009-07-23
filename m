From: Giacomo <delleceste@gmail.com>
Subject: Re: A general question about IP fragmented packets and netfilter
Date: Thu, 23 Jul 2009 12:15:30 +0200
Message-ID: <885896af0907230315o76c62f7ct1136753ac5693e0e@mail.gmail.com>
References: <alpine.LSU.2.00.0907231148440.6513@fbirervta.pbzchgretzou.qr>
	 <alpine.LSU.2.00.0907231149350.6513@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: Jan Engelhardt <jengelh@medozas.de>,
	netfilter-devel <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.25]:55849 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751364AbZGWKPb (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 23 Jul 2009 06:15:31 -0400
Received: by ey-out-2122.google.com with SMTP id 9so259659eyd.37
        for <netfilter-devel@vger.kernel.org>; Thu, 23 Jul 2009 03:15:30 -0700 (PDT)
In-Reply-To: <alpine.LSU.2.00.0907231149350.6513@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

2009/7/23 Jan Engelhardt <jengelh@medozas.de>:
>
>>Don't strip the ml

Sorry I did not realize!

>>
>>---------- Forwarded message ----------
>>> On Thursday 2009-07-23 08:40, Giacomo wrote:
>>>>
>>>>Starting from NF_IP_PRE_ROUTING, where destination NAT and
>>>>de-masquerading takes place, do the packets arrive fragmented - and
>>>>netfilter takes care of the fragments - or do they arrive already
>>>>reassembled from the IP stack?
>>>>
>>>>In the first case, what is, generally speaking, the technique
>>>>adopted to track fragmented IP packets and assign each of them to
>>>>the correct flow?
>>>
>>> Connection tracking does not care about packets or their fragment
>>> bits per se.
>>
>>Yes but suppose a fragmented ip protocol hits the NF_IP_PRE_ROUTING hook and
>>there has to be destination Natted (for instance because being part of
>>a Masqueraded
>>stream). Such a packet, without a TCP header, must be recognized as part of the
>>masqueraded stream, and it has only an IP header, with `More
>>Fragments' set and some
>>data. How is it associated to the masqueraded flow if the packet is
>>not reassembled?
>
> It would not be. Hence the defragmenter is mandatory.
>
>>That is, how is it destination-NATTED?
>
> Once it is defragmented, NAT can take place.
>
>>> Because it reads out the layer-4 header (TCP/etc.) however,
>>> it defragments packets for simplicity.
>>>
>>>>In the second case, if I register with netfilter NF_IP_PRE_ROUTING
>>>>hook, which is the correct "priority"
>>>>to assign during registration to receive packets already reassembled?
>>>
>>> Before NF_IP_PRI_CONNTRACK_DEFRAG.
>>
>>Do you mean that before NF_IP_PRI_CONNTRACK_DEFRAG, i.e. NF_IP_PRI_FIRST,
>
> Before NF_IP_PRI_CONNTRACK_DEFRAG, fragments will be visible.

Very well. finally, if I have correctly understood the issu, if I have
to de-masquerade a packet
or, more generally, destination nat  it, I have two possibilities:

a. use nf_defrag_ipv4 module and register AFTER  NF_IP_PRI_CONNTRACK_DEFRAG
    and then dest - nat

or

b. register with any priority in  NF_IP_PRE_ROUTING hook, call
ip_defrag() and friend
    defined in linux/ip.h to reassemble packets and then dest - nat.

But last... is there any `priority' to register with inside
NF_IP_PRE_ROUTING to `freely' obtain
reassembled packages? Between which hooks/priority does the IP stack
normally reassemble
packets? (and fragments them in output?)

Thanks again and sorry If I abused of your patience.

Giacomo.

>
>>in the NF_IP_PRE_ROUTING hook, packets arrive reassembled, that is there are no
>>IP packets with 'More Fragments' set to true?
>>
>>Thanks a lot, very kind of you.
>>
>>Giacomo
>>
>>
>>
>
>



-- 
Giacomo S.
http://www.giacomos.it

- - - - - - - - - - - - - - - - - - - - - -

* Aprile 2008: iqfire-wall, un progetto
  open source che implementa un
  filtro di pacchetti di rete per Linux,
  e` disponibile per il download qui:
  http://sourceforge.net/projects/ipfire-wall

* Informazioni e pagina web ufficiale:
  http://www.giacomos.it/iqfire/index.html

- - - - - - - - - - - - - - - - - - - - - -

 . ''  `.
:   :'    :
 `.  ` '
    `- Debian GNU/Linux -- The power of freedom
        http://www.debian.org
