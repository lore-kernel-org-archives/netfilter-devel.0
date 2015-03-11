From: Jan Engelhardt <jengelh@inai.de>
Subject: RE: iptables at scale
Date: Wed, 11 Mar 2015 22:44:17 +0100 (CET)
Message-ID: <alpine.LSU.2.11.1503112242290.9828@nerf40.vanv.qr>
References: <SNT152-W61FA9088D57B93B1B5C878B8190@phx.gbl>,<CAJ26g5SeC-shnX+PT2nijqJMLk45zg8VVqvEVk7xG-6r7XgP-w@mail.gmail.com> <SNT152-W53EABE020E8B236DF21FE0B8190@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
To: Glen Miner <shaggie76@hotmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares41.inai.de ([46.4.122.207]:48858 "EHLO ares41.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752154AbbCKVoS (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 11 Mar 2015 17:44:18 -0400
In-Reply-To: <SNT152-W53EABE020E8B236DF21FE0B8190@phx.gbl>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Wednesday 2015-03-11 22:27, Glen Miner wrote:
>>=20
>> What exactly are these four rules, and what do they accomplish?=C2=A0
>
>echo "*nat
>:PREROUTING - [0:0]
>-I PREROUTING -p udp -s $aAddr --sport $aPort -d $nAddr --dport $bnPor=
t -j DNAT --to $bAddr:$bPort
>-I PREROUTING -p udp -s $bAddr --sport $bPort -d $nAddr --dport $anPor=
t -j DNAT --to $aAddr:$aPort
>:POSTROUTING - [0:0]
>-A POSTROUTING -p udp -s $aAddr --sport $aPort -d $bAddr --dport $bPor=
t =C2=A0-j SNAT --to $nAddr:$anPort
>-A POSTROUTING -p udp -s $bAddr --sport $bPort -d $aAddr --dport $aPor=
t =C2=A0-j SNAT --to $nAddr:$bnPort
>COMMIT
>" | iptables-restore --noflush
>
>> You won't be happy changing iptables rules on the fly for each=C2=A0
>> customer. Hire somebody who can program in C, point them at the=20
>> iptables kernel NAT module implementation, and maybe ipset, and get=20
>> them hacking away at a solution that works without table manipulatio=
n.=20
>
>I can program in C; like I said: I translated the above command + some
>conntrack junk to direct function calls to skip process creation and p=
arsing
>logic for 20x better performance. However, it's not really clear where=
 I'd go
>instead short of reinventing iptables / conntrack and lord knows what =
else.

If all you do is the NAT mappings, then directly using conntrack(8)
and/or libnetfilter_conntrack should suffice, especially since UDP CT
entries stay around until their known timeout.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
