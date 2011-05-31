From: Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [ANNOUNCE] ipset 6.7 released
Date: Tue, 31 May 2011 23:42:08 +0200
Message-ID: <1306878128.3171.4.camel@edumazet-laptop>
References: <alpine.DEB.2.00.1105312155260.29607@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:50558 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758467Ab1EaVmN (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 31 May 2011 17:42:13 -0400
In-Reply-To: <alpine.DEB.2.00.1105312155260.29607@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Le mardi 31 mai 2011 =C3=A0 22:11 +0200, Jozsef Kadlecsik a =C3=A9crit =
:
> Hi,
>=20
> Besides a few bugfixes, ipset 6.7 comes with a new set type called=20
> hash:net,iface. The new type makes possible to store network address =
and=20
> interface name pairs in a set. That way egress and ingress filtering =
is=20
> possible with ipset, in just a few rules. Just an example:
>=20
> # Define the set for all your networks and fill it out
> ipset create nets hash:net
> ipset add nets 10.0.0.0/8
> ipset add nets 192.168.0.0/16
> ...
> # Define the set with the allowed network, interface pairs
> ipset create ifaces hash:net,iface
> ipset add ifaces 10.0.0.0/24,eth0
> ipset add ifaces 10.2.0.0/16,eth1
> ...
> # Create a chain to handle your networks
> iptables -N nets
> iptables -A nets -m set --match-set ifaces src,src -j ACCEPT
> iptables -A nets -j log-and-drop-spoofed-packets
> # Egress and ingress filtering
> iptables -t raw -A PREROUTING -m set --match-set nets src -j ifaces
> iptables -t raw -A PREROUTING -i external-iface0 -j ACCEPT
> iptables -t raw -A PREROUTING -i external-iface1 -j ACCEPT

Hi Jozsef

I could probably use this feature if plugged into tc filter, so that I
really can apply qdisc/class trafic shaping on ingress, to queue packet
into right queue, before iptables layer.

tc filter add dev ifb0 protocol ip parent 10: handle 2 \
	flow ipset ipset keys src \
	flowid 1:40

Any plan on this side ?

Thanks

> ...
> iptables -t raw -j log-and-drop-spoofed-packets
> # That's all :-)


--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
