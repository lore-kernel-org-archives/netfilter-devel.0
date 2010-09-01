From: Nicola Padovano <nicola.padovano@gmail.com>
Subject: Re: get tcp header
Date: Wed, 1 Sep 2010 13:48:45 +0200
Message-ID: <AANLkTi=AzvtAJ23nmA7Y7=RfkgJ_NLExj2f-Lm54tGt_@mail.gmail.com>
References: <AANLkTikz7+MsnB4B0PPLX6ypGaLLnpcXgaXryctaT2LW@mail.gmail.com>
 <alpine.LNX.2.01.1008312034240.10509@obet.zrqbmnf.qr> <AANLkTikQoVP_c6JfoSjz46WrARzP1QEEeuoabSdRjk8A@mail.gmail.com>
 <AANLkTinQvTBiw7Gno42xdRdgF5_aCGb8BdEo82ocoY2e@mail.gmail.com> <alpine.LNX.2.01.1009011251590.20617@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: netfilter-devel <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:43469 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751778Ab0IALtH (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 1 Sep 2010 07:49:07 -0400
Received: by ewy23 with SMTP id 23so4215743ewy.19
        for <netfilter-devel@vger.kernel.org>; Wed, 01 Sep 2010 04:49:06 -0700 (PDT)
In-Reply-To: <alpine.LNX.2.01.1009011251590.20617@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

ok, Jan! Perfect.

But there is a last question: i've seen a source code that get a
packet just received from the Net: so -if I understand correctly- it
can't use skb_network_header (IP header) because when i get a packet
just received from the net i should have only the mac_header set.
isn't it?
But, i've seen the usage of skb_network_header...

On Wed, Sep 1, 2010 at 12:53 PM, Jan Engelhardt <jengelh@medozas.de> wrote:
> On Wednesday 2010-09-01 11:57, Nicola Padovano wrote:
>
>>"If a packet is handled by a bridge, that is, a component that does not
>>deal with layer 3 or 4, there is no point in spending time to find the
>>start of the layer 3/4 header."
>>
>>Ok, well: great. but in this case (bridge) also the skb_network_header
>>function is senseless because we don't have to find layer3 header.
>>isn't it?
>
> Correct.
>
>>in general: when i can use the skb_transport_header function?
>
> When a transport header pointer has been set. Which is when the
> appropriate layer-X function has processed it. (After ip_rcv for
> example)
> On the output path, since it goes in the reverse direction, it will
> always be set.
>
>



-- 
Nicola Padovano
e-mail: nicola.padovano@gmail.com
web: http://npadovano.altervista.org
