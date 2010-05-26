From: Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: Help: Cycle through iptables rules
Date: Wed, 26 May 2010 10:11:08 +0200
Message-ID: <1274861468.2672.9.camel@edumazet-laptop>
References: <AANLkTiliv-YLViJ9hgnRY_rnFYYIfjnupo-NOE9tru1y@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: Felipe W Damasio <felipewd@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:53896 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751170Ab0EZILM (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 26 May 2010 04:11:12 -0400
Received: by fxm5 with SMTP id 5so4081150fxm.19
        for <netfilter-devel@vger.kernel.org>; Wed, 26 May 2010 01:11:11 -0700 (PDT)
In-Reply-To: <AANLkTiliv-YLViJ9hgnRY_rnFYYIfjnupo-NOE9tru1y@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Le mardi 25 mai 2010 =C3=A0 21:31 -0300, Felipe W Damasio a =C3=A9crit =
:
> Hi,
>=20
>   I'm using squid on an ISP as a webcache.
>=20
>   We have a very high load cache (6000 users with 300Mbps of web
> access), and to solve the squid slowdown, the solution is to use
> multiple http_port, using around 48 squid instances to serve the
> users.
>=20
>   It works fine when I put the machine (which is in bridge mode)
> between the users and the final router (which does the NAT from
> reserved IP addresses to the real IPs). I separated the rules like
> this:
>=20
> iptables -t mangle -A PREROUTING -i eth0 -p tcp -s 192.168.1.0/24
> --dport 80  -j TPROXY --tproxy-mark 0x1/0x1 --on-port 3127
> iptables -t mangle -A PREROUTING -i eth0 -p tcp -s 192.168.2.0/24
> --dport 80  -j TPROXY --tproxy-mark 0x1/0x1 --on-port 3128
> ...
>=20
>=20
>   Everything works fine when we use this scenario.
>=20
>   But now it was decided (and I can't reverse the decision) that the
> webcache machine was to be located between the final Router and the
> internet....in this case, the cache machine is now only seeing a few
> IP addresses....so I can't do this "-s <network or ip>" trick.
>=20
>   So I'd like to know if I can cycle through all these rules based on
> the number of connections.
>=20
>   Something like "Forward the first 100 connections to port 3127, the
> next 100 to 3128 ....at the end, forward the next 100 to port 3127
> again", and so on.
>=20
>   Is it possible?
>=20
>   If it isn't currently, can this functionality be added? How can I h=
elp?
>=20

So all connections are coming from the NAT device, with a single IP, an=
d
ports from say 30000 to 60000 (check your NAT device)

You could add a test on source port instead, using existing multiport ?

iptables -t mangle -A PREROUTING -i eth0 -p tcp --dport 80 -m multiport=
=20
--source-ports 30000:31000 -j TPROXY --tproxy-mark 0x1/0x1 --on-port 31=
27

iptables -t mangle -A PREROUTING -i eth0 -p tcp --dport 80 -m multiport=
=20
--source-ports 31000:32000 -j TPROXY --tproxy-mark 0x1/0x1 --on-port 31=
28

=2E..

exact port ranges should be computed with (60000-30000/number of squid =
instances)

I bet a better scheme would be to hash (saddr, daddr, sport, dport) and=
 be able to do this with one single rule

iptables -t mangle -A PREROUTING -i eth0 -p tcp --dport 80 -m multiport=
=20
--source-ports 30000:31000 -j TPROXY --tproxy-mark 0x1/0x1 --on-ports 3=
127:3174

But it would need to extend TPROXY module



--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
