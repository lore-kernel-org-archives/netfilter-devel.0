From: Glen Miner <shaggie76@hotmail.com>
Subject: RE: iptables at scale
Date: Wed, 11 Mar 2015 17:27:35 -0400
Message-ID: <SNT152-W53EABE020E8B236DF21FE0B8190@phx.gbl>
References: <SNT152-W61FA9088D57B93B1B5C878B8190@phx.gbl>,<CAJ26g5SeC-shnX+PT2nijqJMLk45zg8VVqvEVk7xG-6r7XgP-w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from snt004-omc1s16.hotmail.com ([65.55.90.27]:64537 "EHLO
	SNT004-OMC1S16.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751300AbbCKV1g convert rfc822-to-8bit
	(ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 11 Mar 2015 17:27:36 -0400
In-Reply-To: <CAJ26g5SeC-shnX+PT2nijqJMLk45zg8VVqvEVk7xG-6r7XgP-w@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


>> What it does: makes UDP NAT proxies so people with strict-NAT or=20
> multi-layer NAT can communicate. This essentially works out to be 4=20
> iptables rules created for a pair of peers. They talk to our server a=
nd=20
> our server makes it look like they're talking to each other; fighting=
=20
> bad NAT with our NAT is somewhat ironic but it's quite elegant.=20
>=20
> What exactly are these four rules, and what do they accomplish?=A0

aAddr : aPort is player A's real ip : port
bAddr : bPort=A0is=A0player B's=A0real=A0ip=A0: port
nAddr : anPort is what player B uses to talk to A
nAddr : bnPort is what player A uses to talk to B

echo "*nat
:PREROUTING - [0:0]
-I PREROUTING -p udp -s $aAddr --sport $aPort -d $nAddr --dport $bnPort=
 -j DNAT --to $bAddr:$bPort
-I PREROUTING -p udp -s $bAddr --sport $bPort -d $nAddr --dport $anPort=
 -j DNAT --to $aAddr:$aPort
:POSTROUTING - [0:0]
-A POSTROUTING -p udp -s $aAddr --sport $aPort -d $bAddr --dport $bPort=
 =A0-j SNAT --to $nAddr:$anPort
-A POSTROUTING -p udp -s $bAddr --sport $bPort -d $aAddr --dport $aPort=
 =A0-j SNAT --to $nAddr:$bnPort
COMMIT
" | iptables-restore --noflush

> You won't be happy changing iptables rules on the fly for each=A0
> customer. Hire somebody who can program in C, point them at the=20
> iptables kernel NAT module implementation, and maybe ipset, and get=20
> them hacking away at a solution that works without table manipulation=
=2E=20

I can program in C; like I said: I translated the above command + some =
conntrack junk to direct function calls to skip process creation and pa=
rsing logic for 20x better performance. However, it's not really clear =
where I'd go instead short of reinventing iptables / conntrack and lord=
 knows what else. Are you suggesting I write my own kernel hooks?

-g 		 	   		  --
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
