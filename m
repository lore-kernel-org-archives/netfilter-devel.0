From: Harald Welte <laforge@netfilter.org>
Subject: Re: Transparent web proxiing stops working in linux-2.4.22
Date: Thu, 4 Sep 2003 23:52:31 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030904215231.GD6909@obroa-skai.de.gnumonks.org>
References: <200309020938.56412.raivis@mt.lv>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="zbGR4y+acU1DwHSi"
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


--zbGR4y+acU1DwHSi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 02, 2003 at 09:38:56AM +0000, Raivis Bucis wrote:
> It doesn't zero all of the tuple contents before assigning, and this way =
3rd=20
> and 4th bytes of tuple.src.all contain garbage, and ip_conntrack_find_get=
 is=20
> not able to find correct conntrack because of that.
>=20
> So instead of fixing getorigdst for big endian architectures, it brakes e=
ven=20
> the little endian ones.

Can you please test the following (proposed) patch and report back if it
fixes your problems?

If you could post your comments to the correspoinding bugzilla entry
(https://bugzilla.netfilter.org/cgi-bin/bugzilla/show_bug.cgi?id=3D126),
it would make my work easier.  Otherwise, just send an email reply.

diff -Nru --exclude .depend --exclude '*.o' --exclude '*.ko' --exclude '*.v=
er' --exclude '.*.flags' --exclude '*.orig' --exclude '*.rej' --exclude '*.=
cmd' --exclude '*.mod.c' --exclude '*~' linux-2.4.22-plain/net/ipv4/netfilt=
er/ip_conntrack_core.c linux-2.4.22-getorig/net/ipv4/netfilter/ip_conntrack=
_core.c
--- linux-2.4.22-plain/net/ipv4/netfilter/ip_conntrack_core.c	2003-08-25 13=
:44:44.000000000 +0200
+++ linux-2.4.22-getorig/net/ipv4/netfilter/ip_conntrack_core.c	2003-09-04 =
23:47:30.000000000 +0200
@@ -1303,9 +1303,11 @@
 getorigdst(struct sock *sk, int optval, void *user, int *len)
 {
 	struct ip_conntrack_tuple_hash *h;
-	struct ip_conntrack_tuple tuple =3D { { sk->rcv_saddr, { .tcp =3D { sk->s=
port } } },
-					    { sk->daddr, { .tcp =3D { sk->dport } },
-					      IPPROTO_TCP } };
+	struct ip_conntrack_tuple tuple;
+
+	memset(&tuple, 0, sizeof(tuple));
+	tuple =3D { { sk->rcv_saddr, { .tcp =3D { sk->sport } } },
+		  { sk->daddr, { .tcp =3D { sk->dport } }, IPPROTO_TCP } };
=20
 	/* We only do TCP at the moment: is there a better way? */
 	if (strcmp(sk->prot->name, "TCP") !=3D 0) {

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

--zbGR4y+acU1DwHSi
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.2 (GNU/Linux)

iD8DBQE/V7QeXaXGVTD0i/8RAoK+AKCeFFV8MB18ieAcpm47OExc9xoIHgCcCkBZ
BCOSvgmbMhEhRIXo0qMfQUw=
=6FBK
-----END PGP SIGNATURE-----

--zbGR4y+acU1DwHSi--
