From: Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: Help: Cycle through iptables rules
Date: Wed, 26 May 2010 14:12:42 +0200
Message-ID: <1274875962.2672.206.camel@edumazet-laptop>
References: <AANLkTiliv-YLViJ9hgnRY_rnFYYIfjnupo-NOE9tru1y@mail.gmail.com>
	 <1274861468.2672.9.camel@edumazet-laptop>
	 <alpine.LSU.2.01.1005261142470.8695@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Felipe W Damasio <felipewd@gmail.com>,
	netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:65530 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757213Ab0EZMMu (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 26 May 2010 08:12:50 -0400
Received: by fxm5 with SMTP id 5so4325766fxm.19
        for <netfilter-devel@vger.kernel.org>; Wed, 26 May 2010 05:12:48 -0700 (PDT)
In-Reply-To: <alpine.LSU.2.01.1005261142470.8695@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Le mercredi 26 mai 2010 =C3=A0 11:47 +0200, Jan Engelhardt a =C3=A9crit=
 :

>=20
> There may be a non-uniform distribution so it may not be advisable.
> Instead perhaps,
>=20
> -A PREROUTING -m conntrack --ctstate NEW -j extrachain
> for (I =3D 0; I < N; ++I)
> 	-A extrachain -m statistic --mode nth --every I \
> 		-j CONNMARK --set-mark I
> for (I =3D 0; I < N; ++I)
> 	-A PREROUTING -m connmark --mark I -j TPROXY \
> 		--tproxy-mark I/0xff --on-port I+3127

I am not sure it would work "all the time".=20

Some packets could traverse the whole extrachain without hitting any
rule (extrachain is not an atomic group)

=46or high performance squid machine, it also adds yet another contenti=
on
points (after the conntrack lock of course...)

Some TPROXY extension would be necessary to handle RPS better on this
kind of machines.

Say you have 16 cpus, RPS is able to select a target cpu, then TPROXY
could use this CPU information to chose a destination port per cpu.

--on-port 3127+cpu



--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
