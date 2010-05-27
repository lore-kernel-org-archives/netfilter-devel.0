From: Felipe W Damasio <felipewd@gmail.com>
Subject: Re: Help: Cycle through iptables rules
Date: Thu, 27 May 2010 17:29:29 -0300
Message-ID: <AANLkTilwGbJn20DXLtyDCHFQm8eS4g3_AUyLrI-huNi8@mail.gmail.com>
References: <AANLkTiliv-YLViJ9hgnRY_rnFYYIfjnupo-NOE9tru1y@mail.gmail.com>
	<1274861468.2672.9.camel@edumazet-laptop>
	<alpine.LSU.2.01.1005261142470.8695@obet.zrqbmnf.qr>
	<AANLkTilFXTT5kKPCTD7Re8Xzeg6UoKlDUJJvWPCGJXRd@mail.gmail.com>
	<alpine.LSU.2.01.1005262215010.30857@obet.zrqbmnf.qr>
	<1274905649.2542.1.camel@edumazet-laptop>
	<alpine.LSU.2.01.1005270008520.30857@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Eric Dumazet <eric.dumazet@gmail.com>,
	netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:46376 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754371Ab0E0U3a convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 27 May 2010 16:29:30 -0400
Received: by fxm10 with SMTP id 10so205426fxm.19
        for <netfilter-devel@vger.kernel.org>; Thu, 27 May 2010 13:29:29 -0700 (PDT)
In-Reply-To: <alpine.LSU.2.01.1005270008520.30857@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Mr. Engelhardt,

I created a script using the instructions you gave me.

The result was:

Chain PREROUTING (policy ACCEPT)
target     prot opt source               destination
extrachain  all  --  0.0.0.0/0            0.0.0.0/0           ctstate N=
EW
TPROXY     tcp  --  0.0.0.0/0            0.0.0.0/0           tcp
dpt:80 connmark match 0x0 TPROXY redirect 0.0.0.0:3127 mark 0x1/0x1
TPROXY     tcp  --  0.0.0.0/0            0.0.0.0/0           tcp
dpt:80 connmark match 0x1 TPROXY redirect 0.0.0.0:3128 mark 0x1/0x1
TPROXY     tcp  --  0.0.0.0/0            0.0.0.0/0           tcp
dpt:80 connmark match 0x2 TPROXY redirect 0.0.0.0:3129 mark 0x1/0x1

Chain extrachain (1 references)
target     prot opt source               destination
CONNMARK   all  --  0.0.0.0/0            0.0.0.0/0           statistic
mode nth every 3 CONNMARK and 0x0
CONNMARK   all  --  0.0.0.0/0            0.0.0.0/0           statistic
mode nth every 3 packet 1 CONNMARK xset 0x1/0xffffffff
CONNMARK   all  --  0.0.0.0/0            0.0.0.0/0           statistic
mode nth every 3 packet 2 CONNMARK xset 0x2/0xffffffff

 This is for N=3D3 instances of squid.

 The TPROXY rules make sense to me (forwarding to a port based on the
mark that was done in the extrachain). I just don't get the extrachain
rules regarding that "--every 3" bit yet. :-)

 Are they right, though?

 I'm really trying to understand those statistic mode nth options :)

 Thanks.

 Cheers,

=46elipe Damasio

2010/5/26 Jan Engelhardt <jengelh@medozas.de>:
> On Wednesday 2010-05-26 22:27, Eric Dumazet wrote:
>>> >
>>> > =A0So we create 48 rules using this setup?
>>>
>>> Since there are two loops to be done, it would be 96 rules in total=
=2E
>>>
>>> > =A0I can see why it'll work on the first 48 packets (one for each
>>> >rule), but what happens on the 49th new connection? It'll go on th=
e
>>> >first rule again?
>>>
>>> nth uses modulus, otherwise you can't get the "every Nth" semantic.=
 :-)
>>>
>>> (It should have been: --mode nth --every N --packet I)
>>
>>not exactly :)
>>
>>It should be --mode nth --every N-I --packet I
>>
>>(first rule consume one packet out of 48, then second rule consume on=
e
>>packet out of 47, ...
>
> The second rule still consumes 48 packets, because CONNMARK is
> non-terminating. Thus it's --every N.
>
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
