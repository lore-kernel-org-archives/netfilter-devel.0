From: Harald Welte <laforge@netfilter.org>
Subject: [PATCH 2.4] fix find_appropriate_src() to comply with kegel draft
Date: Wed, 10 Nov 2004 18:39:41 +0100
Message-ID: <20041110173940.GA7525@sunbeam.de.gnumonks.org>
References: <20041109154946.GD22257@sunbeam.de.gnumonks.org>
	<1100024526.6496.10.camel@tux.rsn.bth.se>
	<1100043724.25963.19.camel@localhost.localdomain>
	<20041110162500.GA7485@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="fdj2RfSjLxBAspz7"
Cc: Netfilter development mailing list <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Rusty Russell <rusty@rustcorp.com.au>,
	Martin Josefsson <gandalf@wlug.westbo.se>
Content-Disposition: inline
In-Reply-To: <20041110162500.GA7485@sunbeam.de.gnumonks.org>
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


--fdj2RfSjLxBAspz7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

This is now my 2.4.x merge, yet untested:

Name: Fix find_appropriate_src() To Actually Work
Status: Awaiting testing
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Harald Welte <laforge@netfilter.org>

We try to bind to the same source port when sending packets from the
same source IP/source port to the outside world.  Normally, this is
simple, since we always try to keep the same source port anyway, but
there are cases where that is not available.

This is a requirement for the Kegel Peer-to-Peer NAT paper:

	http://alumnus.caltech.edu/~dank/peer-nat.html

Unfortunately, our current implementation is useless.  It looks up a
hash to see if this srcip/srcpt has been used, but instead of
returning the mapping to use, it simply returns that same srcip/srcpt.
This is clearly wrong.  As pointed out by Krisztian Kovacs.

Also, we fix a long-standing in_range() bug that was first fixed in 2.4.23,=
 but
rolled back because it caused infinite loops.  However, this has since been
fixed and tested in 2.6.x by adding an additional ip_nat_used_tuple() in
get_unique_tuple().

diff -Nru --exclude .depend --exclude '*.o' --exclude '*.ko' --exclude '*.v=
er' --exclude '.*.flags' --exclude '*.orig' --exclude '*.rej' --exclude '*.=
cmd' --exclude '*.mod.c' --exclude '*~' linux-2.4.28-rc2-plain/net/ipv4/net=
filter/ip_nat_core.c linux-2.4.28-rc2-kegel/net/ipv4/netfilter/ip_nat_core.c
--- linux-2.4.28-rc2-plain/net/ipv4/netfilter/ip_nat_core.c	2004-08-08 01:2=
6:06.000000000 +0200
+++ linux-2.4.28-rc2-kegel/net/ipv4/netfilter/ip_nat_core.c	2004-11-10 18:3=
2:45.189229469 +0100
@@ -134,31 +134,30 @@
 	return ip_conntrack_tuple_taken(&reply, ignored_conntrack);
 }
=20
-/* Does tuple + the source manip come within the range mr */
+/* If we source map this tuple so reply looks like reply_tuple, will
+ * that meet the constraints of mr. */
 static int
 in_range(const struct ip_conntrack_tuple *tuple,
-	 const struct ip_conntrack_manip *manip,
 	 const struct ip_nat_multi_range *mr)
 {
 	struct ip_nat_protocol *proto =3D find_nat_proto(tuple->dst.protonum);
 	unsigned int i;
-	struct ip_conntrack_tuple newtuple =3D { *manip, tuple->dst };
=20
 	for (i =3D 0; i < mr->rangesize; i++) {
 		/* If we are allowed to map IPs, then we must be in the
 		   range specified, otherwise we must be unchanged. */
 		if (mr->range[i].flags & IP_NAT_RANGE_MAP_IPS) {
-			if (ntohl(newtuple.src.ip) < ntohl(mr->range[i].min_ip)
-			    || (ntohl(newtuple.src.ip)
+			if (ntohl(tuple->src.ip) < ntohl(mr->range[i].min_ip)
+			    || (ntohl(tuple->src.ip)
 				> ntohl(mr->range[i].max_ip)))
 				continue;
 		} else {
-			if (newtuple.src.ip !=3D tuple->src.ip)
+			if (tuple->src.ip !=3D tuple->src.ip)
 				continue;
 		}
=20
 		if ((mr->range[i].flags & IP_NAT_RANGE_PROTO_SPECIFIED)
-		    && proto->in_range(&newtuple, IP_NAT_MANIP_SRC,
+		    || proto->in_range(tuple, IP_NAT_MANIP_SRC,
 				       &mr->range[i].min, &mr->range[i].max))
 			return 1;
 	}
@@ -166,36 +165,38 @@
 }
=20
 static inline int
-src_cmp(const struct ip_nat_hash *i,
-	const struct ip_conntrack_tuple *tuple,
-	const struct ip_nat_multi_range *mr)
+same_src(const struct ip_nat_hash *i,
+	 const struct ip_conntrack_tuple *tuple)
 {
 	return (i->conntrack->tuplehash[IP_CT_DIR_ORIGINAL].tuple.dst.protonum
 		=3D=3D tuple->dst.protonum
 		&& i->conntrack->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.ip
 		=3D=3D tuple->src.ip
 		&& i->conntrack->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.u.all
-		=3D=3D tuple->src.u.all
-		&& in_range(tuple,
-			    &i->conntrack->tuplehash[IP_CT_DIR_ORIGINAL]
-			    .tuple.src,
-			    mr));
+		=3D=3D tuple->src.u.all);
 }
=20
 /* Only called for SRC manip */
-static struct ip_conntrack_manip *
+static int
 find_appropriate_src(const struct ip_conntrack_tuple *tuple,
+		     struct ip_conntrack_tuple *result,
 		     const struct ip_nat_multi_range *mr)
 {
 	unsigned int h =3D hash_by_src(&tuple->src, tuple->dst.protonum);
 	struct ip_nat_hash *i;
=20
 	MUST_BE_READ_LOCKED(&ip_nat_lock);
-	i =3D LIST_FIND(&bysource[h], src_cmp, struct ip_nat_hash *, tuple, mr);
-	if (i)
-		return &i->conntrack->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src;
-	else
-		return NULL;
+	i =3D LIST_FIND(&bysource[h], same_src, struct ip_nat_hash *, tuple);
+	if (i) {
+		/* Copy source part from reply tuple */
+		invert_tuplepr(result,=20
+			&i->conntrack->tuplehash[IP_CT_DIR_REPLY].tuple);
+		result->dst =3D tuple->dst;
+
+		if (in_range(result, mr))
+			return 1;
+	}
+	return 0;
 }
=20
 #ifdef CONFIG_IP_NF_NAT_LOCAL
@@ -412,15 +413,10 @@
 	   So far, we don't do local source mappings, so multiple
 	   manips not an issue.  */
 	if (hooknum =3D=3D NF_IP_POST_ROUTING) {
-		struct ip_conntrack_manip *manip;
-
-		manip =3D find_appropriate_src(orig_tuple, mr);
-		if (manip) {
-			/* Apply same source manipulation. */
-			*tuple =3D ((struct ip_conntrack_tuple)
-				  { *manip, orig_tuple->dst });
+		if (find_appropriate_src(orig_tuple, tuple, mr)) {
 			DEBUGP("get_unique_tuple: Found current src map\n");
-			return 1;
+			if (!ip_nat_used_tuple(tuple, conntrack))
+				return 1;
 		}
 	}
=20

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--fdj2RfSjLxBAspz7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.5 (GNU/Linux)

iD8DBQFBklJcXaXGVTD0i/8RAomSAKCEzWI8+dNrUW45rz0aUszyJPSX8QCfdEGa
Kbn7weLUNLFi073TV8TpHiQ=
=iTc6
-----END PGP SIGNATURE-----

--fdj2RfSjLxBAspz7--
