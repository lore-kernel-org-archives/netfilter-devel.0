From: Harald Welte <laforge@netfilter.org>
Subject: Re: sctp conntrack
Date: Mon, 2 Aug 2004 13:05:22 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040802110522.GN18758@sunbeam2>
References: <20040722191649.GJ14946@obroa-skai.de.gnumonks.org> <200407271348.34615.immidi@spymac.com> <20040801165005.GA14539@sunbeam2> <200408021555.38315.immidi@spymac.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Pz/qqzCPDfGwIFOg"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Kiran Kumar Immidi <immidi@spymac.com>
Content-Disposition: inline
In-Reply-To: <200408021555.38315.immidi@spymac.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--Pz/qqzCPDfGwIFOg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 02, 2004 at 03:55:38PM +0530, Kiran Kumar Immidi wrote:
> On Sunday 01 August 2004 10:20 pm, Harald Welte wrote:
>=20
> > > - The type of these timeouts in case of TCP is unsigned long, though =
the
> > > code in ip_conntrack_standalone.c treats them as unsigned int. I am n=
ot
> > > sure of the working, but I suspect something wrong here. I have follo=
wed
> > > the same pattern however.
> >
> > yes, indeed. on 64bit archs this is going to cause trouble :(
>=20
>   Do you want me to make a patch for this?

that would be appreciated, yes.

>   Attached is a patch which adds SCTP support for the LOG target. This
>   applies=20

Thanks, I'm putting it in patch-o-matic right now.

A patch for ulogd_BASE.c from ulogd would also be very much appreciated.

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--Pz/qqzCPDfGwIFOg
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQFBDh/yXaXGVTD0i/8RAgfuAJwMFcu6XUY988zyeg/pOuExSQlo3wCbBoYw
VykeWMOrb+bMhm+QSZF9Ccg=
=dngx
-----END PGP SIGNATURE-----

--Pz/qqzCPDfGwIFOg--
