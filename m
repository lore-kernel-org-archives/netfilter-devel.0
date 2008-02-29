From: Pascal Hambourg <pascal.mail@plouf.fr.eu.org>
Subject: Re: Does Redirect/NAT change the destination port of reverse tuple
 ?
Date: Fri, 29 Feb 2008 12:52:23 +0100
Message-ID: <47C7F1F7.9030406@plouf.fr.eu.org>
References: <005101c87ac0$c0d34580$4279d080$@com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-dmz-235-friday.dmz.nerim.net ([195.5.254.235]:59772 "EHLO
	kellthuzad.dmz.nerim.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756712AbYB2MYN (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 29 Feb 2008 07:24:13 -0500
Received: from mallaury.nerim.net (smtp-105-friday.noc.nerim.net [62.4.17.105])
	by kellthuzad.dmz.nerim.net (Postfix) with ESMTP id 123C6274D1
	for <netfilter-devel@vger.kernel.org>; Fri, 29 Feb 2008 12:54:09 +0100 (CET)
Received: from [192.168.0.246] (plouf.fr.eu.org [213.41.173.35])
	by mallaury.nerim.net (Postfix) with ESMTP id 0E98C4F4FD
	for <netfilter-devel@vger.kernel.org>; Fri, 29 Feb 2008 12:52:16 +0100 (CET)
In-Reply-To: <005101c87ac0$c0d34580$4279d080$@com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello,

Nishit Shah a =E9crit :
> 	I have following iptable rule in system.
>=20
> 	iptables -I PREROUTING -t nat -p tcp --dport 443 -j REDIRECT
> --to-ports 3128
> 	kernel - 2.6.16.13
>=20
> 	I am using following scenario for load testing
>=20
> 	192.168.206.200 -----> 192.168.121.125 	-----> 	72.14.223.83
> 	Client			iptables/proxy server		server
>=20
> 	and I am getting following entry through conntrack binay as well as
> in /proc/net/ip_conntrack
>=20
> 	[NEW] tcp 6 120 NONE src=3D192.168.206.200 dst=3D72.14.223.83
> sport=3D63423 dport=3D443 packets=3D1 bytes=3D48 [UNREPLIED] src=3D19=
2.168.121.125
> dst=3D192.168.206.200 sport=3D3128 dport=3D46873 packets=3D0 bytes=3D=
0 id=3D28187887
>=20
> Now here original and reverse tuples are -->=20
> 	Original tuple 192.168.206.200:63423->72.14.223.83:443
> 	Reply tuple    192.168.121.125:3128->192.168.206.200:46873
>=20
> So, here destination port of reverse tuple is 46873. Is it correct ?

Yes. NAT may implicitly change the original source port in order to=20
avoid a clash with an existing connection. However the original port=20
will be restored in reply packets before they leave the box, so the=20
client won't see anything. Remember that the tuples in ip_conntrack=20
contain the addresses and ports when packets enter the PREROUTING or=20
OUTPUT chains, not when they leave the POSTROUTING or INPUT chains.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
