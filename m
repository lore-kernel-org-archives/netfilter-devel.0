From: Harald Welte <laforge@netfilter.org>
Subject: Re: [PATCH] Passive OS fingerprint matching module update. Dynamic fingerprint loading.
Date: Tue, 23 Sep 2003 14:57:46 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030923125746.GL31401@sunbeam.de.gnumonks.org>
References: <20030922171921.009b2133.johnpol@2ka.mipt.ru> <20030923155944.521d6299.johnpol@2ka.mipt.ru>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="fTrra2YUagINO7SV"
Cc: netfilter-devel@lists.netfilter.org, quaker@ondraszek.eu.org,
	solt@dns.toxicfilms.tv
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Content-Disposition: inline
In-Reply-To: <20030923155944.521d6299.johnpol@2ka.mipt.ru>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--fTrra2YUagINO7SV
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 23, 2003 at 03:59:44PM +0400, Evgeniy Polyakov wrote:
>=20
> > Examples:
> > loading new rule:
> > echo "16384:64:0:44:M512:.:AIX:4.3.2 and
> > earlier">/proc/sys/net/ipv4/osf=20
>=20
> So, in OpenBSD we have:=20
> 16384:64:0:44:M512:             AIX:4.3:2-3:AIX 4.3.2 and earlier
>                                                              ^^^^^^^^
>=20
> If someone like to use this notation, i can create a patch.

Well, the osf match is pretty much your child... so it's up to you.

I personally would like to see compatibility... since this means that
the fingerprint database has only to be kept in one format.

> 	Evgeniy Polyakov

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--fTrra2YUagINO7SV
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.2 (GNU/Linux)

iD8DBQE/cENKXaXGVTD0i/8RAvLoAJ4zrbD4oTBSeDJKtO6mJ9edwwHREgCePS5n
DptE65xZ/HtjxrkzL8xqfwY=
=DK0v
-----END PGP SIGNATURE-----

--fTrra2YUagINO7SV--
