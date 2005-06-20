From: Christian Hentschel <chentschel@arnet.com.ar>
Subject: Re: [PATCH] SIP/SDP conntrack and NAT helper
Date: Mon, 20 Jun 2005 14:54:16 -0300
Message-ID: <1119290056.26216.18.camel@www.l-chr.com.ar>
References: <1115493770.1949.9.camel@www.l-chr.com.ar>
	<5caa9b87050620024652114b0a@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="=-/kqXjPJAiEMpocFAQek3"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Steve Davies <davies147@gmail.com>
In-Reply-To: <5caa9b87050620024652114b0a@mail.gmail.com>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org


--=-/kqXjPJAiEMpocFAQek3
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi,=20

> In our network, we use SNOM 190 phones. When they register, they
> negotiate to listen on a dynamic port number (NOT 5060) - The
> conntrack code is only looking for packets with a SOURCE port of 5060,
> so when the SNOM 190 initiates the INVITE, the destination port is
> 5060, but the source port is not. Of course conntrack does not see
> this, and the RTP packets  are not allowed.

mmm.. it should be looking for dst 5060. Anyways, since i don't have
those snom, can u send me some captures of this situation?. ethereal
would be great.

Please, use the lastest sip conntrack patch though, 2.6.10 was an early
code.

Best regards
--=20
"Debugging is twice as hard as writing the code in the first place.
Therefore, if you write the code as cleverly as possible, you are,
by definition, not smart enough to debug it." - Brian W. Kernighan

--=-/kqXjPJAiEMpocFAQek3
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.5 (GNU/Linux)

iD8DBQBCtwLH/jxG54BC3LgRAj46AKCL/S3LgJpdsKe85TMAw0y9bCP6iQCdGIpk
e76uf9mLRui53/Xt0r3w/sc=
=FKwk
-----END PGP SIGNATURE-----

--=-/kqXjPJAiEMpocFAQek3--
