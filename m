From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: PacketScript: packet mangling using the Lua scripting language
Date: Tue, 21 Sep 2010 00:13:20 +0200
Message-ID: <4C97DC80.7050201@netfilter.org>
References: <AANLkTi=mPHY0JqEm+dDH-QwiFvVLq7r_86+_xp8d7TLM@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: andre@dergraf.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:42105 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754320Ab0ITWNY (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 20 Sep 2010 18:13:24 -0400
In-Reply-To: <AANLkTi=mPHY0JqEm+dDH-QwiFvVLq7r_86+_xp8d7TLM@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 20/09/10 22:04, Andr=E9 Graf wrote:
> Hello
>=20
> As a part of my master thesis I developed PacketScript - a Netfilter
> extension, which enables to extend Netfilter with Lua scripts. The Lu=
a
> scripts are loaded with iptables and provide an easy way to deal with
> network packets. Here a short example:
>=20
> # iptables -A INPUT -p tcp -j LUA --script /path/to/my/script.lua
>=20
> and the /path/to/my/script.lua can contain a Lua function similar to
> the following: (Lua uses -- for comments)
>=20
> -- called by the Netfilter callback function, gets a 'raw' packet
> function process_packet(raw)
>     -- apply the Ethernet dissector
>     ethernet =3D raw:data(packet_ethernet)
>=20
>     -- apply the IP dissector
>     ip =3D ethernet:data(packet_ip)
>=20
>     -- dissect IP source address
>     src =3D ip:saddr()
>     if src:get() =3D=3D "192.168.1.1" then
>         -- rewrite IP source address
>         src:set("10.0.0.123")
>         -- accept packet
>         return NF_ACCEPT
>     end
>     -- drop packet
>     return NF_DROP
> end
>=20
> PacketScript was not build with a specific network protocol or
> protocol layer in mind, so it offers a simple framework to extend it
> with other protocols. The current version provides rudimentary suppor=
t
> for Ethernet, IP, ICMP, UDP, TCP, TFTP, and HTTP. For my thesis I als=
o
> developed the possibility to access the Linux workqueue interface
> using Lua.
>=20
> At the moment I am cleaning up the code and write the user
> documentation. But, before I put too much extra effort into it I woul=
d
> really like to know your opinion. Thank you!

Interesting approach, I'd like to see how the code looks like to know
what approach you've followed.

BTW, do you have some performance numbers in matching packets with
lua-based script?
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
