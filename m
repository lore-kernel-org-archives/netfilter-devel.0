From: Harald Welte <laforge@gnumonks.org>
Subject: Re: --reject-with admin-prohib - Suggested Solution.
Date: Thu, 5 Dec 2002 20:28:35 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20021205192835.GB11044@naboo.club.berlin.ccc.de>
References: <20021128081009.GJ7047@naboo.de.gnumonks.org> <Pine.LNX.4.33.0212040052300.29619-100000@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ZfOjI3PrQbgiZnxM"
Cc: Maciej Soltysiak <solt@dns.toxicfilms.tv>, g@naboo.gnumonks.org,
	netfilter-devel@lists.samba.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.33.0212040052300.29619-100000@blackhole.kfki.hu>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--ZfOjI3PrQbgiZnxM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 04, 2002 at 01:02:23AM +0100, Jozsef Kadlecsik wrote:
> On Thu, 28 Nov 2002, Harald Welte wrote:
>=20
> > > Now, if the 2.5.48 kernel has the admin-prohib support, the userspace=
 will
> > > detect it, and will show the option in -j REJECT --help and will acce=
pt
> > > admin-prohib.
> >
> > No.  You will make the libipt_REJECT.so dependent on the particular
> > source code installed on the machine where iptables was compiled.
>=20
> Why don't we simply add an INCOMPATIBILITIES file to the userspace source
> tree, together with a similar section in the manpage?
>=20
> Backward compatibility is very important, but we shouldn't insist on it at
> every cost.

Yup, we should draw a line somewhere.

I think we should just add the option to both kernel and userspace,
which would result in the following bug:

old kernel + new userspace + usage of the new admin-prohibited type =3D=3D
DROP without any REJECT.

I'll put the Patch from Maciej (message=20
<Pine.LNX.4.21.0207261551070.3420-200000@dns.toxicfilms.tv>)
without any attempt of the userspace-patch.

> Regards,
> Jozsef
--=20
Live long and prosper
- Harald Welte / laforge@gnumonks.org               http://www.gnumonks.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
GCS/E/IT d- s-: a-- C+++ UL++++$ P+++ L++++$ E--- W- N++ o? K- w--- O- M-=
=20
V-- PS+ PE-- Y+ PGP++ t++ 5-- !X !R tv-- b+++ DI? !D G+ e* h+ r% y+(*)

--ZfOjI3PrQbgiZnxM
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE976jjXaXGVTD0i/8RAqfNAJ4lYWn279U6yQfFR/PPsonZ0d8BtgCeP292
M1tcVChwFZcKvayyJdyX/KQ=
=VDEA
-----END PGP SIGNATURE-----

--ZfOjI3PrQbgiZnxM--
