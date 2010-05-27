From: Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: Help: Cycle through iptables rules
Date: Thu, 27 May 2010 22:40:13 +0200
Message-ID: <1274992813.2446.22.camel@edumazet-laptop>
References: <AANLkTiliv-YLViJ9hgnRY_rnFYYIfjnupo-NOE9tru1y@mail.gmail.com>
	 <1274861468.2672.9.camel@edumazet-laptop>
	 <alpine.LSU.2.01.1005261142470.8695@obet.zrqbmnf.qr>
	 <AANLkTilFXTT5kKPCTD7Re8Xzeg6UoKlDUJJvWPCGJXRd@mail.gmail.com>
	 <alpine.LSU.2.01.1005262215010.30857@obet.zrqbmnf.qr>
	 <1274905649.2542.1.camel@edumazet-laptop>
	 <alpine.LSU.2.01.1005270008520.30857@obet.zrqbmnf.qr>
	 <AANLkTilwGbJn20DXLtyDCHFQm8eS4g3_AUyLrI-huNi8@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Jan Engelhardt <jengelh@medozas.de>,
	netfilter-devel@vger.kernel.org
To: Felipe W Damasio <felipewd@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ww0-f46.google.com ([74.125.82.46]:35234 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756139Ab0E0UkT (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 27 May 2010 16:40:19 -0400
Received: by wwb34 with SMTP id 34so339632wwb.19
        for <netfilter-devel@vger.kernel.org>; Thu, 27 May 2010 13:40:18 -0700 (PDT)
In-Reply-To: <AANLkTilwGbJn20DXLtyDCHFQm8eS4g3_AUyLrI-huNi8@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Le jeudi 27 mai 2010 =C3=A0 17:29 -0300, Felipe W Damasio a =C3=A9crit =
:
> Hi Mr. Engelhardt,
>=20
> I created a script using the instructions you gave me.
>=20
> The result was:
>=20
> Chain PREROUTING (policy ACCEPT)
> target     prot opt source               destination
> extrachain  all  --  0.0.0.0/0            0.0.0.0/0           ctstate=
 NEW
> TPROXY     tcp  --  0.0.0.0/0            0.0.0.0/0           tcp
> dpt:80 connmark match 0x0 TPROXY redirect 0.0.0.0:3127 mark 0x1/0x1
> TPROXY     tcp  --  0.0.0.0/0            0.0.0.0/0           tcp
> dpt:80 connmark match 0x1 TPROXY redirect 0.0.0.0:3128 mark 0x1/0x1
> TPROXY     tcp  --  0.0.0.0/0            0.0.0.0/0           tcp
> dpt:80 connmark match 0x2 TPROXY redirect 0.0.0.0:3129 mark 0x1/0x1
>=20
> Chain extrachain (1 references)
> target     prot opt source               destination
> CONNMARK   all  --  0.0.0.0/0            0.0.0.0/0           statisti=
c
> mode nth every 3 CONNMARK and 0x0
> CONNMARK   all  --  0.0.0.0/0            0.0.0.0/0           statisti=
c
> mode nth every 3 packet 1 CONNMARK xset 0x1/0xffffffff
> CONNMARK   all  --  0.0.0.0/0            0.0.0.0/0           statisti=
c
> mode nth every 3 packet 2 CONNMARK xset 0x2/0xffffffff
>=20
>  This is for N=3D3 instances of squid.
>=20
>  The TPROXY rules make sense to me (forwarding to a port based on the
> mark that was done in the extrachain). I just don't get the extrachai=
n
> rules regarding that "--every 3" bit yet. :-)
>=20
>  Are they right, though?

Its right only if you have a single NIC, and a single queue one.

Or else two SYN packets could flight in // in extrachain (using two
cpus), and the logic would be wrong.

I suggest using a first 'catch all' rule in extrachain, to make sure on=
e
CONNMARK is done.

Or else, some connections would not go through any TPROXY rule.

Chain extrachain (1 references)
target     prot opt source               destination

CONNMARK   all  --  0.0.0.0/0            0.0.0.0/0           CONNMARK
xset 0x0/0xffffffff

CONNMARK   all  --  0.0.0.0/0            0.0.0.0/0           statistic
mode nth every 3 packet 1 CONNMARK xset 0x1/0xffffffff

CONNMARK   all  --  0.0.0.0/0            0.0.0.0/0           statistic
mode nth every 3 packet 2 CONNMARK xset 0x2/0xffffffff





--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
