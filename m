From: Harald Welte <laforge@netfilter.org>
Subject: Re: Transparent web proxiing stops working in linux-2.4.22
Date: Thu, 4 Sep 2003 12:24:43 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030904102442.GF2616@obroa-skai.de.gnumonks.org>
References: <200309020938.56412.raivis@mt.lv>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="aZoGpuMECXJckB41"
Cc: netfilter-devel@lists.netfilter.org, cieciwa@alpha.zarz.agh.edu.pl
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Raivis Bucis <raivis@mt.lv>
Content-Disposition: inline
In-Reply-To: <200309020938.56412.raivis@mt.lv>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--aZoGpuMECXJckB41
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 02, 2003 at 09:38:56AM +0000, Raivis Bucis wrote:
> Transparent web proxiing stops working in linux-2.4.22 because of the=20
> following patch:

I've added your bug report to bugzilla.netfilter.org - It has been
assigned #126

> It doesn't zero all of the tuple contents before assigning, and this way =
3rd=20
> and 4th bytes of tuple.src.all contain garbage, and ip_conntrack_find_get=
 is=20
> not able to find correct conntrack because of that.

I'll write up a patch to fix this issue later today.=20

> So instead of fixing getorigdst for big endian architectures, it brakes e=
ven=20
> the little endian ones.

:(

> Raivis Bucis

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--aZoGpuMECXJckB41
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.2 (GNU/Linux)

iD8DBQE/VxLqXaXGVTD0i/8RAtJxAJ4/oV+kILvzek4oJcPgIxWUhDapDQCdEVVD
km4JEMmTdt8x1RC0cmIe76E=
=CKNi
-----END PGP SIGNATURE-----

--aZoGpuMECXJckB41--
