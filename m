From: Harald Welte <laforge@sunbeam.franken.de>
Subject: Re: Problem with IP-Pools
Date: Thu, 5 Dec 2002 21:11:13 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20021205201113.GD11068@naboo.club.berlin.ccc.de>
References: <20021128162921.2b2a721d.markus.schaber@student.uni-ulm.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="vni90+aGYgRvsTuO"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Markus Schaber <markus.schaber@student.uni-ulm.de>
Content-Disposition: inline
In-Reply-To: <20021128162921.2b2a721d.markus.schaber@student.uni-ulm.de>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--vni90+aGYgRvsTuO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 28, 2002 at 04:29:21PM +0100, Markus Schaber wrote:
> Hi,
>=20
> I'm using the IP Pools extension form Patch-O-matic, and now have the
> problem that it tends to kill the machine on SMP. (I just killed our
> backup firewall two times this day...)

I think the pool stuff is pretty much unmaintained as of now, sorry.
It was a contribution to the project, and the original author (Gerd
Knorr, IIRC) has abandoned it.

> Thanks,
> Markus

--=20
Live long and prosper
- Harald Welte / laforge@sunbeam.franken.de    http://www.sunbeam.franken.de
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
GCS/E/IT d- s-: a-- C+++ UL++++$ P+++ L++++$ E--- W- N++ o? K- w--- O- M-=
=20
V-- PS+ PE-- Y+ PGP++ t++ 5-- !X !R tv-- b+++ DI? !D G+ e* h+ r% y+(*)

--vni90+aGYgRvsTuO
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE977LhXaXGVTD0i/8RAuNZAJ4vkzmjvqIISzk3KJz6sABLU1VFNQCfSvyH
AInterbe+509+YpBt5Z5td0=
=5sw3
-----END PGP SIGNATURE-----

--vni90+aGYgRvsTuO--
