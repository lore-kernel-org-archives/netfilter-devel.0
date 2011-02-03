From: "Mario 'BitKoenig' Holbe" <Mario.Holbe@TU-Ilmenau.DE>
Subject: MASQUERADE selects wrong source IP for overlapping networks
Date: Thu, 3 Feb 2011 20:16:42 +0100
Message-ID: <20110203191642.GB23221@darkside.kls.lan>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Bn2rw/3z4jIqBvZU"
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from piggy.rz.tu-ilmenau.de ([141.24.4.8]:60961 "EHLO
	piggy.rz.tu-ilmenau.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932547Ab1BCTQt (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 3 Feb 2011 14:16:49 -0500
Received: from p4FD5610A.dip.t-dialin.net (vpn19.rz.tu-ilmenau.de [141.24.172.19])
	by piggy.rz.tu-ilmenau.de (8.13.7/8.13.7/Debian-2) with ESMTP id p13JGiVY016794
	for <netfilter-devel@vger.kernel.org>; Thu, 3 Feb 2011 20:16:45 +0100
Received: from darkside.kls.lan (root@darkside.kls.lan [IPv6:2001:6f8:90c:12:21e:8cff:fecf:cfad])
	by p4FD5610A.dip.t-dialin.net (8.14.3/8.14.3) with ESMTP id p13JGjXK026271
	for <netfilter-devel@vger.kernel.org>; Thu, 3 Feb 2011 20:16:46 +0100
Received: from darkside.kls.lan (holbe@localhost [IPv6:::1])
	by darkside.kls.lan (8.14.4/8.14.4) with ESMTP id p13JGhad009505
	for <netfilter-devel@vger.kernel.org>; Thu, 3 Feb 2011 20:16:44 +0100
Received: (from holbe@localhost)
	by darkside.kls.lan (8.14.4/8.14.4) id p13JGgv7009503
	for netfilter-devel@vger.kernel.org; Thu, 3 Feb 2011 20:16:42 +0100
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--Bn2rw/3z4jIqBvZU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello,

The iptables MASQUERADE target's source address selection doesn't work
for overlapping networks on an interface.

The real-world scenario behind this case is a VPN tunnel set up using
racoon in a roadwarrior scenario. The VPN gateway offers a dynamic
tunnel IP via ISAKMP mode config which is then added to the outgoing
interface (typically PPP or something like that). Routing selects the
tunnel IP as source address for secure subnets and IPsec policies are
applied then. This works - until MASQUERADE enters the game.

Test case:
# ip addr add 10.0.0.1/16 dev dummy0
# ip addr add 10.0.1.1/24 dev dummy0
# ip link set dummy0 up=20
# ip route show dev dummy0
10.0.1.0/24  proto kernel  scope link  src 10.0.1.1=20
10.0.0.0/16  proto kernel  scope link  src 10.0.0.1=20
# ping -c1 10.0.0.2
-> tcpdump: IP 10.0.0.1 > 10.0.0.2: ICMP echo request
# ping -c1 10.0.1.2
-> tcpdump: IP 10.0.1.1 > 10.0.1.2: ICMP echo request
# iptables -t nat -A POSTROUTING -o dummy0 -j MASQUERADE
# ping -c1 10.0.0.2
-> tcpdump: IP 10.0.0.1 > 10.0.0.2: ICMP echo request
# ping -c1 10.0.1.2
-> tcpdump: IP 10.0.0.1 > 10.0.1.2: ICMP echo request

This is due to masquerade_tg() not considering routing decisions. This
is fine with non-overlapping networks. In this case, inet_select_addr()
is sufficient.
With overlapping networks inet_select_addr() is not sufficient, because
it just selects the first matching address, while the correct source
address can only be retrieved from routing.


regards
   Mario
--=20
Good, Fast, Cheap: Pick any two (you can't have all three).
                                            -- RFC 1925, 7a

--Bn2rw/3z4jIqBvZU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEVAwUBTUr/GhS+e2HeSPbpAQJQjggAj3Hm/vmEGr3FY8PSq2JICQ3XRlDvqZ4G
YojTUPOFlseieoisQEU3LTp0Ln7oo7YVoEawxoD/maAkYR4cCMiZvbwXIC3l+s1K
60q7GAdSA3F6XdMzKbJfghYyix25XhFpuwInKWdM4tn1v6nMOzZW67jZRiCDzqCe
B4ryRA9QuCX4MKKQHMSHLroO9Huloz0E25oHAXOoFnS2ezJfN+i8DDyymfm+t+8f
mXT1GLFexL9y0YaHYJk3bGYtPmSx/S87cWVEatI3NNaLlWSC7JnSjrbbIEpSjYLM
sHcW6SHRarJg+NNeZvjq2TXXhoBDayuymdRC5av4IfA32yISDr+gfA==
=2ZFU
-----END PGP SIGNATURE-----

--Bn2rw/3z4jIqBvZU--
