From: Eric Leblond <eric@regit.org>
Subject: Re: libnetfilter_queue callback and verdict order
Date: Fri, 02 Aug 2013 09:29:15 +0200
Message-ID: <1375428555.11948.62.camel@ice-age.regit.org>
References: <2013073107581060268014@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-JsJibmsS/yCQgWsuKSF+"
Cc: netfilter-devel <netfilter-devel@vger.kernel.org>
To: medialy <medialy@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ks28632.kimsufi.com ([91.121.96.152]:59979 "EHLO
	ks28632.kimsufi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755867Ab3HBH3V (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 2 Aug 2013 03:29:21 -0400
In-Reply-To: <2013073107581060268014@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--=-JsJibmsS/yCQgWsuKSF+
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: quoted-printable

Hi,

Le mercredi 31 juillet 2013 =E0 07:58 +0800, medialy a =E9crit :
> I am developing an application base on libnetfilter_queue to filter http =
traffic(CentOS 5.5 x86_64).=20
> In order to make full use of multi-CPU, I try to use a read thread(where =
recv and nfq_handle_packet=20
> are called) and several verdict threads(where nfq_set_verdict2 is called)=
.=20
>=20
> My questions are:
> Can the parameter value in cb(qh, nfmsg, nfa, data) function used in verd=
ict thread?

No, the netlink message will be discarded at the end of the callback.

> Can the packet be verdict without order?

Yes.

See
https://home.regit.org/netfilter-en/using-nfqueue-and-libnetfilter_queue/
for more information.

BR,
--
Eric


--=-JsJibmsS/yCQgWsuKSF+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iD8DBQBR+1/MnxA7CdMWjzIRAms2AJ0ZAuoHELHYWyXnRsiRF7SpAU1VNgCfR/Iz
w2p678Bb3wFVcYn9flIu5pc=
=NAFJ
-----END PGP SIGNATURE-----

--=-JsJibmsS/yCQgWsuKSF+--

