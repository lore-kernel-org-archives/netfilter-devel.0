From: Thomas Zehetbauer <thomasz@hostmaster.org>
Subject: Re: netfilter IPv6 support
Date: Fri, 27 Aug 2004 12:02:24 +0200
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <1093600944.3497.51.camel@hostmaster.org>
References: <1093546367.3497.23.camel@hostmaster.org>
	 <412E4740.3090807@pobox.com> <20040826140637.336c4d10.davem@redhat.com>
	 <20040826211107.GA30080@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-OyOPXd39pAtT79KBG4yg"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <linux-kernel-owner+glk-linux-kernel=40m.gmane.org-S262406AbUH0KCa@vger.kernel.org>
To: linux-kernel@vger.kernel.org
In-Reply-To: <20040826211107.GA30080@havoc.gtf.org>
List-Id: netfilter-devel.vger.kernel.org


--=-OyOPXd39pAtT79KBG4yg
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Don, 2004-08-26 at 17:11 -0400, Jeff Garzik wrote:
> For example, a NAT box behind which 32,000 hosts sit, or something like
> that :)

NAT is limited to count(official addresses)*65535 connections anyway.

One of the most important features of IPv6 is to reconcile today's
interNAT to a homogenous internet as it was before and intended to be.
If someone wants then to put 32k hosts behind a single linux router he
would better provide the necessary hardware for it.

Tom

--=20
  T h o m a s   Z e h e t b a u e r   ( TZ251 )
  PGP encrypted mail preferred - KeyID 96FFCB89
      finger thomasz@hostmaster.org for key

Sacrilegia minuta puniuntur, magna in triumphis feruntur
                                      - Seneca



--=-OyOPXd39pAtT79KBG4yg
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.5 (GNU/Linux)

iQEVAwUAQS8Gr2D1OYqW/8uJAQKtmQf9HuvhfaSv21QuqvqTE2C1fzBX0MxeaUWs
y2Dlf2FJB6D0gooxDElcjnL5TvSb3t024YbLzoOOkiBqQSWK5H6zDlleObOrulw6
Q4HfcIpLncK3P6p73CylO9ny6rHUWkOWVoVO/gtWg8vRhfcIHNtcfQ5c3OaOathu
5BeX9zGjGhCV/WtF0fDaon7kk8VHX2/uU7+0e/76nD58MpsD+/BR1BsSnjKuFio2
ipHrhIX1C64dnREKsypDToGUdFJ3Edb7CJCz/wBLgrAqDA+58nYGRm3BTv1PCBYH
4NiO3u/brIesZNHS7fdE8fFBOp4HWDTTIzzK/OtbQppo8YjlBKmvSQ==
=6a0d
-----END PGP SIGNATURE-----

--=-OyOPXd39pAtT79KBG4yg--
