From: Nicola Padovano <nicola.padovano@gmail.com>
Subject: Re: get tcp header
Date: Wed, 1 Sep 2010 14:45:28 +0200
Message-ID: <AANLkTi=rTOhi50zES_HPwdBkANNfTBHCsvVYj5tv1C-i@mail.gmail.com>
References: <AANLkTikz7+MsnB4B0PPLX6ypGaLLnpcXgaXryctaT2LW@mail.gmail.com>
 <alpine.LNX.2.01.1008312034240.10509@obet.zrqbmnf.qr> <AANLkTikQoVP_c6JfoSjz46WrARzP1QEEeuoabSdRjk8A@mail.gmail.com>
 <AANLkTinQvTBiw7Gno42xdRdgF5_aCGb8BdEo82ocoY2e@mail.gmail.com>
 <alpine.LNX.2.01.1009011251590.20617@obet.zrqbmnf.qr> <AANLkTi=AzvtAJ23nmA7Y7=RfkgJ_NLExj2f-Lm54tGt_@mail.gmail.com>
 <AANLkTimhvuY7JouM-Ctv5oh+_Tgzskpvc+wfoc2JYH6m@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: netfilter-devel <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:61181 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752404Ab0IAMsF (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 1 Sep 2010 08:48:05 -0400
Received: by wwb17 with SMTP id 17so1420066wwb.1
        for <netfilter-devel@vger.kernel.org>; Wed, 01 Sep 2010 05:48:04 -0700 (PDT)
In-Reply-To: <AANLkTimhvuY7JouM-Ctv5oh+_Tgzskpvc+wfoc2JYH6m@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

ok.thanks. now is all clear...so if i write a new target for
NFPROTO_IPV4, the packet that i firstly receive in my target-hook
function is an _IP_ packet. isn't it?

On Wed, Sep 1, 2010 at 2:18 PM, Nicola Padovano
<nicola.padovano@gmail.com> wrote:
> maybe because the packet is sent firstly to the router and then the
> router sends to my host a ip packet in which network_header is set? i
> hope so...
>
> On Wed, Sep 1, 2010 at 1:48 PM, Nicola Padovano
> <nicola.padovano@gmail.com> wrote:
>> ok, Jan! Perfect.
>>
>> But there is a last question: i've seen a source code that get a
>> packet just received from the Net: so -if I understand correctly- it
>> can't use skb_network_header (IP header) because when i get a packet
>> just received from the net i should have only the mac_header set.
>> isn't it?
>> But, i've seen the usage of skb_network_header...
>>
>> On Wed, Sep 1, 2010 at 12:53 PM, Jan Engelhardt <jengelh@medozas.de> wrote:
>>> On Wednesday 2010-09-01 11:57, Nicola Padovano wrote:
>>>
>>>>"If a packet is handled by a bridge, that is, a component that does not
>>>>deal with layer 3 or 4, there is no point in spending time to find the
>>>>start of the layer 3/4 header."
>>>>
>>>>Ok, well: great. but in this case (bridge) also the skb_network_header
>>>>function is senseless because we don't have to find layer3 header.
>>>>isn't it?
>>>
>>> Correct.
>>>
>>>>in general: when i can use the skb_transport_header function?
>>>
>>> When a transport header pointer has been set. Which is when the
>>> appropriate layer-X function has processed it. (After ip_rcv for
>>> example)
>>> On the output path, since it goes in the reverse direction, it will
>>> always be set.
>>>
>>>
>>
>>
>>
>> --
>> Nicola Padovano
>> e-mail: nicola.padovano@gmail.com
>> web: http://npadovano.altervista.org
>>
>
>
>
> --
> Nicola Padovano
> e-mail: nicola.padovano@gmail.com
> web: http://npadovano.altervista.org
>



-- 
Nicola Padovano
e-mail: nicola.padovano@gmail.com
web: http://npadovano.altervista.org
