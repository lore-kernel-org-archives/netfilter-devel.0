From: Harald Welte <laforge@netfilter.org>
Subject: Re: [ANNOUNCE] multiple netfilter.org releases
Date: Sat, 5 Nov 2005 22:35:20 +0100
Message-ID: <20051105213520.GM16000@sunbeam.de.gnumonks.org>
References: <20051105192931.GI16000@sunbeam.de.gnumonks.org>
	<1131225043.11473.29.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="M2Pxvdb9QxnGd/3e"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Eric Leblond <eric@inl.fr>
Content-Disposition: inline
In-Reply-To: <1131225043.11473.29.camel@localhost.localdomain>
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


--M2Pxvdb9QxnGd/3e
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Nov 05, 2005 at 10:10:43PM +0100, Eric Leblond wrote:
> Hi,
>=20
> Le samedi 05 novembre 2005 =E0 20:29 +0100, Harald Welte a =E9crit :
> > Hi!
>=20
> > libnetfilter_queue-0.0.10
> > 	ftp://ftp.netfilter.org/pub/libnetfilter_queue/libnetfilter_queue-0.0.=
10.tar.bz2
> > 	This is the userspace library for nfnetlink_queue in 2.6.14
> > 	It is used by applications that traditionally used libipq
> > 	NuFW already has a working port
> > 	Needs libnfnetlink-0.0.11
>=20
> I think there is an issue with the timestamp related function that
> won't work without this patch :
> 	http://patchwork.netfilter.org/netfilter-devel/patch.pl?id=3D3016

mh, i'll make another release soon.  Anyway, I think the caller should
provide a &struct timeval and then the library fills in.   If you're
interested in cooking up a patch, you're welcome


--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--M2Pxvdb9QxnGd/3e
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2 (GNU/Linux)

iD8DBQFDbSWYXaXGVTD0i/8RAo6DAJ9Qogb6aLbkoEoC8aWZXy8ha/ltBwCdG8dd
CrC14n84b6i6vQVXafZRGxI=
=zBRa
-----END PGP SIGNATURE-----

--M2Pxvdb9QxnGd/3e--
