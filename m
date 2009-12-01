From: Changli Gao <xiaosuo@gmail.com>
Subject: Re: Add seperated timeout for the connections that only receive
	packets in one direction
Date: Tue, 1 Dec 2009 09:26:39 +0800
Message-ID: <412e6f7f0911301726w654e8075v4a802cb8437938dd@mail.gmail.com>
References: <4B0FA3AA.4070702@trash.net> <4B0FBC5F.8030108@trash.net>
	 <412e6f7f0911292039v74b89b4cieca5e2a043bad43d@mail.gmail.com>
	 <4B13A80C.6070607@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
	netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pw0-f42.google.com ([209.85.160.42]:50825 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750937AbZLAB0c convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 30 Nov 2009 20:26:32 -0500
Received: by pwi3 with SMTP id 3so2207711pwi.21
        for <netfilter-devel@vger.kernel.org>; Mon, 30 Nov 2009 17:26:39 -0800 (PST)
In-Reply-To: <4B13A80C.6070607@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Nov 30, 2009 at 7:10 PM, Patrick McHardy <kaber@trash.net> wrot=
e:
> Changli Gao wrote:
>> Case 2:
>>
>> Attacker ---+
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 +-- Linux Ro=
uter --> WAN
>> Victim-------+
>>
>> If we do sth. like RPF before entering conntrack, the packets in the
>> other direction won't be in.
>
> RPF doesn't help since its also done after conntrack.
>

I didn't mean RPF. I meaned some other thing like RPF before conntrack.

--=20
Regards=EF=BC=8C
Changli Gao(xiaosuo@gmail.com)
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
