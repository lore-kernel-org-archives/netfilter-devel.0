From: Harald Welte <laforge@netfilter.org>
Subject: Re: [PATCH] fix iptables on systems with discontiguous processor ids
Date: Wed, 12 Oct 2005 08:40:35 +0200
Message-ID: <20051012064035.GD4237@rama.de.gnumonks.org>
References: <20051010164141.GG5627@rama> <434AE1A0.5030400@frankengul.org>
	<20051011142347.GB4756@rama.de.gnumonks.org>
	<434C27A8.5080403@frankengul.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="nHwqXXcoX0o6fKCv"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: =?iso-8859-1?Q?S=E9bastien?= Bernard <seb@frankengul.org>
Content-Disposition: inline
In-Reply-To: <434C27A8.5080403@frankengul.org>
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


--nHwqXXcoX0o6fKCv
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 11, 2005 at 10:59:20PM +0200, S=E9bastien Bernard wrote:
> Harald Welte a =E9crit :
>=20
> >On Mon, Oct 10, 2005 at 11:48:16PM +0200, S=E9bastien Bernard wrote:
> >=20
> >>>[snip]
> >>>    =20
> >>I tested this patch on my machine.
> >>It ooops instantly in get_counters() from ip_tables.c.
> >>  =20
> >Mh, can you capture the oops and send it?  I'm travelling and don't have
> >access to any SMP box, so it's unlikely I will be able to resolve this
> >alone.
> >=20
> What information do you need exactly ?
> The oops can be tiresome to write down.

please use a serial console or take a photograph with a digital camera. ;)

Pleaes also send me the corresponding ip_tables.ko object file.=20

Thanks

--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--nHwqXXcoX0o6fKCv
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2 (GNU/Linux)

iD8DBQFDTK/jXaXGVTD0i/8RAssDAKCUAX/AWURgD92dVihi0ZZAfmR0twCfYOFc
WMfBtIGi+2qPQsXzRO4By1U=
=ilMh
-----END PGP SIGNATURE-----

--nHwqXXcoX0o6fKCv--
