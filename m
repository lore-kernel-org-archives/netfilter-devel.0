From: Harald Welte <laforge@netfilter.org>
Subject: Re: Transparent web proxiing stops working in linux-2.4.22
Date: Fri, 5 Sep 2003 17:08:46 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030905150846.GD3400@obroa-skai.de.gnumonks.org>
References: <20030904215231.GD6909@obroa-skai.de.gnumonks.org> <Pine.LNX.4.44.0309050851560.6603-100000@filer.marasystems.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="cHMo6Wbp1wrKhbfi"
Cc: Raivis Bucis <raivis@mt.lv>, netfilter-devel@lists.netfilter.org,
	cieciwa@alpha.zarz.agh.edu.pl
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Henrik Nordstrom <hno@marasystems.com>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44.0309050851560.6603-100000@filer.marasystems.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--cHMo6Wbp1wrKhbfi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Sep 05, 2003 at 09:08:19AM +0200, Henrik Nordstrom wrote:
> On Thu, 4 Sep 2003, Harald Welte wrote:
>=20
> > +	struct ip_conntrack_tuple tuple;
> > +
> > +	memset(&tuple, 0, sizeof(tuple));
> > +	tuple =3D { { sk->rcv_saddr, { .tcp =3D { sk->sport } } },
> > +		  { sk->daddr, { .tcp =3D { sk->dport } }, IPPROTO_TCP } };
>=20
> This construct looks dangerous to me, relying on the compiler to optimize=
=20
> the assignment in order to fix the bug..

You are right.  Thanks for pointing this out.

This new patch should be a much cleaner solution:

diff -Nru --exclude .depend --exclude '*.o' --exclude '*.ko' --exclude '*.v=
er' --exclude '.*.flags' --exclude '*.orig' --exclude '*.rej' --exclude '*.=
cmd' --exclude '*.mod.c' --exclude '*~' linux-2.4.22-plain/include/linux/ne=
tfilter_ipv4/ip_conntrack_tuple.h linux-2.4.22-getorig/include/linux/netfil=
ter_ipv4/ip_conntrack_tuple.h
--- linux-2.4.22-plain/include/linux/netfilter_ipv4/ip_conntrack_tuple.h	20=
02-02-25 20:38:13.000000000 +0100
+++ linux-2.4.22-getorig/include/linux/netfilter_ipv4/ip_conntrack_tuple.h	=
2003-09-05 17:04:20.000000000 +0200
@@ -62,6 +62,14 @@
 	} dst;
 };
=20
+/* This is optimized opposed to a memset of the whole structure.  Everythi=
ng we
+ * really care about is the  source/destination unions */
+#define IP_CT_TUPLE_BLANK(tuple) 				\
+	do {							\
+		tuple->src.u.all =3D 0;				\
+		tuple->dst.u.all =3D 0;				\
+	} while (0)
+
 enum ip_conntrack_dir
 {
 	IP_CT_DIR_ORIGINAL,
diff -Nru --exclude .depend --exclude '*.o' --exclude '*.ko' --exclude '*.v=
er' --exclude '.*.flags' --exclude '*.orig' --exclude '*.rej' --exclude '*.=
cmd' --exclude '*.mod.c' --exclude '*~' linux-2.4.22-plain/net/ipv4/netfilt=
er/ip_conntrack_core.c linux-2.4.22-getorig/net/ipv4/netfilter/ip_conntrack=
_core.c
--- linux-2.4.22-plain/net/ipv4/netfilter/ip_conntrack_core.c	2003-08-25 13=
:44:44.000000000 +0200
+++ linux-2.4.22-getorig/net/ipv4/netfilter/ip_conntrack_core.c	2003-09-05 =
17:04:20.000000000 +0200
@@ -1303,9 +1303,14 @@
 getorigdst(struct sock *sk, int optval, void *user, int *len)
 {
 	struct ip_conntrack_tuple_hash *h;
-	struct ip_conntrack_tuple tuple =3D { { sk->rcv_saddr, { .tcp =3D { sk->s=
port } } },
-					    { sk->daddr, { .tcp =3D { sk->dport } },
-					      IPPROTO_TCP } };
+	struct ip_conntrack_tuple tuple;
+
+	IP_CT_TUPLE_BLANK(&tuple);
+	tuple.src.ip =3D sk->rcv_saddr;
+	tuple.src.u.tcp.port =3D sk->sport;
+	tuple.dst.ip =3D sk->daddr;
+	tuple.dst.u.tcp.port =3D sk->dport;
+	tuple.dst.protonum =3D IPPROTO_TCP;
=20
 	/* We only do TCP at the moment: is there a better way? */
 	if (strcmp(sk->prot->name, "TCP") !=3D 0) {

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--cHMo6Wbp1wrKhbfi
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.2 (GNU/Linux)

iD8DBQE/WKb+XaXGVTD0i/8RAi+OAJ4u/oiSow+YtIhew/69xuZQbFMmEACeNhXW
zCjpx0y0/JhKAGwfBYwtcuA=
=2tAs
-----END PGP SIGNATURE-----

--cHMo6Wbp1wrKhbfi--
