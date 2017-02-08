From: Simon Hanisch <hanisch@wh2.tu-dresden.de>
Subject: nftables bug: Only the first two elements of a map are used for NAT
Date: Wed, 8 Feb 2017 19:11:17 +0100
Message-ID: <7b9f63d7-b853-7005-78b1-fb3afc0d0c5a@wh2.tu-dresden.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="sUGgi22jg7BdR4l5BmePSeUl4ShPC9C51"
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from atlantis.wh2.tu-dresden.de ([141.30.228.39]:42460 "EHLO
        atlantis.wh2.tu-dresden.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751094AbdBHShk (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 8 Feb 2017 13:37:40 -0500
Received: from [192.168.178.35] (unknown [85.182.223.249])
        by atlantis.wh2.tu-dresden.de (Postfix) with ESMTPSA id 0997A83D106
        for <netfilter-devel@vger.kernel.org>; Wed,  8 Feb 2017 18:11:25 +0000 (UTC)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--sUGgi22jg7BdR4l5BmePSeUl4ShPC9C51
Content-Type: multipart/mixed; boundary="eCe3tNAaJWI4JqWKfx0jSoBIboga8FfrJ";
 protected-headers="v1"
From: Simon Hanisch <hanisch@wh2.tu-dresden.de>
To: netfilter-devel@vger.kernel.org
Message-ID: <7b9f63d7-b853-7005-78b1-fb3afc0d0c5a@wh2.tu-dresden.de>
Subject: nftables bug: Only the first two elements of a map are used for NAT

--eCe3tNAaJWI4JqWKfx0jSoBIboga8FfrJ
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hi,

we want to use a map for a large NAT setup, mapping subnets to a single
IP. Thats why we wanted to use a map, but only the first two elements of
the map are used for the NAT.
I added two config examples to reproduce the bug. In the first example
the NAT works fine for the network 100.64.15.0/24, in the second it does
not. The only difference is the order of the map elements.
We have build nft from the current master branch, last commit is
97a2a5bde2f03e33315eab4b76a9e69770b99351.



Working for 100.64.15.0/24

#!/usr/sbin/nft
add chain nat postrouting { type nat hook postrouting priority 100 ;}
add chain nat prerouting { type nat hook prerouting priority 0 ;}
add map nat subnettoip { type ipv4_addr: ipv4_addr ; flags interval ; }
add rule ip nat postrouting snat ip saddr map @subnettoip;
add element nat subnettoip { 100.64.13.0/24 : 192.168.0.32 }
add element nat subnettoip { 100.64.15.0/24 : 192.168.0.34 }
add element nat subnettoip { 100.64.14.0/24 : 192.168.0.33 }


Not working for 100.64.15.0/24

#!/usr/sbin/nft
add chain nat postrouting { type nat hook postrouting priority 100 ;}
add chain nat prerouting { type nat hook prerouting priority 0 ;}
add map nat subnettoip { type ipv4_addr: ipv4_addr ; flags interval ; }
add rule ip nat postrouting snat ip saddr map @subnettoip;
add element nat subnettoip { 100.64.13.0/24 : 192.168.0.32 }
add element nat subnettoip { 100.64.14.0/24 : 192.168.0.33 }
add element nat subnettoip { 100.64.15.0/24 : 192.168.0.34 }


Greetings,
Simon


--eCe3tNAaJWI4JqWKfx0jSoBIboga8FfrJ--

--sUGgi22jg7BdR4l5BmePSeUl4ShPC9C51
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJYm19NAAoJEIRZrhfmcZz5gLkP+wTv4uJB8le7yVJ3PWWz4wO+
ZgcQzY6Z3gXCT0n2F049ZmNrxcf10Qxcz+OIfs3KtVPA1plJeBk3UGIKj+N39VUT
JKo9Yr993JGd3jXNvgByMa7taC1KPBuFZPSeuYisJRT49dI+qNcXzKCsszTTLZIh
nSkZW7RmevBRvjWjWN7gaX6kG1Wwu+m/n0BsKOr9kEZZD2rkHPWtQ5g//90i0ZT8
J2UEcCawWjI1fQi0D1z0a/p2JZ+H3L2Nuln4YzLkvQ6F4t4hF0HvAtKlVajflcZ2
KHMijY3Jaw6xs5jLOU26WxqzJSv2Ly3V3ydwDs10Lhod/NfmuJYFUjlwLs4fdQeD
R1/8rN044B13WvHIoGGcY+Cz3WPDAE3Ij+HrKQItvf4NHK9KQq3cRKDYrD2jRfr2
jyLs5y6eIoGVqbzqNIoKHdRYkoKMDY7X1x502ytWdfwxgflPUv545XgePmGsJFzf
9C64MEp4s6ffY7uURB+7yMdh4oQvnwmBDPoKg8arKggyu3XFVsx0g0ay+/XcFpPq
3hFMUC+yVIXAEGizYCIkezjM8DLYX9QDvwlLbtRSrvIAULccuISNWrzP2fBlXuVq
ERNYR/eir0rPlrKregKggU6Hh0U1wkkT726uZwCIty/MNGKhts7lQj3faJqao7jI
jC2VQisEBOB8+OC546l5
=mD9r
-----END PGP SIGNATURE-----

--sUGgi22jg7BdR4l5BmePSeUl4ShPC9C51--
