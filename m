From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: ip_set_hash_netnet.c:62: possible typo ?
Date: Mon, 25 Nov 2013 21:50:27 +0100 (CET)
Message-ID: <alpine.DEB.2.10.1311252149230.5977@blackhole.kfki.hu>
References: <DUB118-W3449F030E13F8088A847CC9CED0@phx.gbl>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="110391812-439997912-1385412627=:5977"
Cc: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
To: David Binderman <dcb314@hotmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.25]:60768 "EHLO smtp0.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751887Ab3KYUub (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 25 Nov 2013 15:50:31 -0500
In-Reply-To: <DUB118-W3449F030E13F8088A847CC9CED0@phx.gbl>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--110391812-439997912-1385412627=:5977
Content-Type: TEXT/PLAIN; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE

On Mon, 25 Nov 2013, David Binderman wrote:

> I just ran the static analyser "cppcheck" over the source
> code of linux-3.13-rc1. It said
>=20
> [linux-3.13-rc1/net/netfilter/ipset/ip_set_hash_netnet.c:62] -> [linux-3.=
13-rc1/net/netfilter/ipset/ip_set_hash_netnet.c:62]: (style) Same expressio=
n on both sides of '=3D=3D'.
>=20
> Source code is
>=20
> static inline bool
> hash_netnet4_data_equal(const struct hash_netnet4_elem *ip1,
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 const struct hash_netnet4_elem *ip2,
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 u32 *multi)
> {
> =A0=A0=A0 return ip1->ipcmp =3D=3D ip2->ipcmp &&
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 ip2->ccmp =3D=3D ip2->ccmp;
> }
>=20
> Maybe=20
>=20
> static inline bool
> hash_netnet4_data_equal(const struct hash_netnet4_elem *ip1,
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 const struct hash_netnet4_elem *ip2,
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 u32 *multi)
> {
> =A0=A0=A0 return ip1->ipcmp =3D=3D ip2->ipcmp &&
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 ip1->ccmp =3D=3D ip2->ccmp;
> }
>=20
> would be better code ?

Yes, you are completely right. I'm going to check why the testsuite did=20
not catch it.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
--110391812-439997912-1385412627=:5977--
