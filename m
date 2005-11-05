From: Eric Leblond <eric@inl.fr>
Subject: Re: [ANNOUNCE] multiple netfilter.org releases
Date: Sat, 05 Nov 2005 22:10:43 +0100
Message-ID: <1131225043.11473.29.camel@localhost.localdomain>
References: <20051105192931.GI16000@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="=-Ejfp2BIOiA1Ai1RT/eZP"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20051105192931.GI16000@sunbeam.de.gnumonks.org>
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


--=-Ejfp2BIOiA1Ai1RT/eZP
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi,

Le samedi 05 novembre 2005 =E0 20:29 +0100, Harald Welte a =E9crit :
> Hi!

> libnetfilter_queue-0.0.10
> 	ftp://ftp.netfilter.org/pub/libnetfilter_queue/libnetfilter_queue-0.0.10=
.tar.bz2
> 	This is the userspace library for nfnetlink_queue in 2.6.14
> 	It is used by applications that traditionally used libipq
> 	NuFW already has a working port
> 	Needs libnfnetlink-0.0.11

I think there is an issue with the timestamp related function that
won't work without this patch :
	http://patchwork.netfilter.org/netfilter-devel/patch.pl?id=3D3016

BR,
--=20
Eric Leblond <eric@inl.fr>

--=-Ejfp2BIOiA1Ai1RT/eZP
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2 (GNU/Linux)

iD8DBQBDbR/TnxA7CdMWjzIRAq+uAJwMjtFZc7PqJg3omw1y8mukqszlIwCbBgmy
+v3Pgps9UZLTzzMLVYN2c30=
=/VeG
-----END PGP SIGNATURE-----

--=-Ejfp2BIOiA1Ai1RT/eZP--
