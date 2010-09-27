From: Mistick Levi <gmistick@gmail.com>
Subject: Fwd: Fwd: TCP ack in libnetfilter_queue
Date: Mon, 27 Sep 2010 10:11:10 +0200
Message-ID: <AANLkTik8TW6PjoifmSVwJX2JBmNZUwNGYcwYacQJnTp1@mail.gmail.com>
References: <AANLkTimxj_yVspgWQB2tHF+=ZGvEh1sdga+RdnD_t_SQ@mail.gmail.com>
 <AANLkTi=X0E3keLqnedFG7_BWim3fJvqU+O2RaFUv1+MT@mail.gmail.com>
 <1285573277.21274.190.camel@khasse.inl.fr> <AANLkTikkDCufxM1p5g+SzNZZ171pe6J_a8YdpTigscbj@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:45607 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758581Ab0I0ILb convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 27 Sep 2010 04:11:31 -0400
Received: by fxm3 with SMTP id 3so1631860fxm.19
        for <netfilter-devel@vger.kernel.org>; Mon, 27 Sep 2010 01:11:30 -0700 (PDT)
In-Reply-To: <AANLkTikkDCufxM1p5g+SzNZZ171pe6J_a8YdpTigscbj@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,
Thanks for the reply, i'll give it a go..

but i was wondering if maybe there should be added a new FLAG for the
connection tracking... since i belive most people think that
"ESTABLISHED" mean's after the 3way handshake and the start of the
session....
any Idea's on why is the "ESTABLISHED" state is on before the 3-way
handshake is finished... or maybe there is another flag that would
help?

Thanks in advance..
Yechiel Levi

2010/9/27 Eric Leblond <eric@inl.fr>:
> Hi,
>
> Le dimanche 26 septembre 2010 =E0 07:53 +0200, Mistick Levi a =E9crit=
 :
>> Hi,
>> did'nt get any reply on the users list.... Hope anyone here could he=
lp out.
>>
>>
>> ---------- Forwarded message ----------
>> From: Mistick Levi <gmistick@gmail.com>
>> Date: Thu, Sep 23, 2010 at 4:12 PM
>> Subject: TCP ack in libnetfilter_queue
>> To: netfilter@vger.kernel.org
>>
>>
>> Hey,
>>
>> i wrote a filter using libnetfilter_queue api, and i want to send
>> messages to the queue in a specific way...
>> I want to get the first packet after the TCP 3-way-handshak is
>> finished ( meaning - only data!)..
>>
>> i tried using conntrack with "ESTABLISHED" status, but then i start
>> getting messages to the queue from the last message of the
>> handshake... ( meaning the last ack )... and i dont want that since =
it
>> contain no data....
>
> What about filtering on PSH, something like:
> =A0 =A0 =A0 =A0iptables XXXXX --tcp-flags PSH, PSH -j NFQUEUE
> Not really strict but it should work in most case.
> Or you can work on packet length, if it has data it is bigger:
> =A0 =A0 =A0 =A0iptables XXXXX --length 60:1500 -j NFQUEUE
>
> BR,
> --
> =C9ric Leblond <eric@inl.fr>
> EdenWall, http://www.edenwall.com/
> NuFW, http://www.nufw.org
>
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
