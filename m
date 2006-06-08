From: Jesper Dangaard Brouer <hawk@comx.dk>
Subject: Re: Concurrency issues with the iptables userspace program
	andexitcodes
Date: Thu, 08 Jun 2006 14:52:23 +0200
Message-ID: <1149771143.28481.87.camel@localhost.localdomain>
References: <1149153349.28481.15.camel@localhost.localdomain>
	<447F1227.7050900@trash.net>
	<Pine.LNX.4.61.0606012200260.27621@ask.diku.dk>
	<447F5204.4080505@trash.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="=-qfhlrsRW34nksTiIf/vm"
Cc: Jesper Dangaard Brouer <hawk@diku.dk>, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <447F5204.4080505@trash.net>
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


--=-qfhlrsRW34nksTiIf/vm
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2006-06-01 at 22:45 +0200, Patrick McHardy wrote:
> Jesper Dangaard Brouer wrote:
> >=20
> > On Thu, 1 Jun 2006, Patrick McHardy wrote:
> >=20
> >> Wouldn't it make more sense to just make sure you don't have iptables
> >> commands running concurrently?
> >=20
> >=20
> > I already have implemented (f)locks in my code around the iptables
> > invocations.  But the problem can still arise when root executes the
> > iptables command from the shell. Thus, I still need to handle the
> > situation in my code, and a proper exitcode would be nice.
> >=20
> > In iptables-standalone.c it would be very easy to simply return the
> > errno instead of !res (which always will return 0 or 1).  Would that be
> > a feasable solution?
>=20
> It would probably break other scripts that check for the current
> (documented) exit codes. I guess adding a new one for this case
> is fine, other code can't really expect that no new values are
> ever added.

That would be fine.
For example something like the following patch?

I have tracked down where the "Resource temporarily unavailable" occurs
in libiptc.c, and marked it with a comment... if you can use it for any
thing.

--=20
Med venlig hilsen / Best regards
  Jesper Brouer
  ComX Networks A/S
  Linux Network developer
  Cand. Scient Datalog / MSc.
  Author of http://adsl-optimizer.dk


diff --exclude '*.d' --exclude-from /var/kernel/exclude_these -urpN iptable=
s-1.3.4-pom-l7/include/iptables_common.h iptables-1.3.4-pom-l7-blocking/inc=
lude/iptables_common.h
--- iptables-1.3.4-pom-l7/include/iptables_common.h	2005-10-31 20:03:49.000=
000000 +0100
+++ iptables-1.3.4-pom-l7-blocking/include/iptables_common.h	2006-06-08 14:=
19:53.000000000 +0200
@@ -5,7 +5,8 @@
 enum exittype {
 	OTHER_PROBLEM =3D 1,
 	PARAMETER_PROBLEM,
-	VERSION_PROBLEM
+	VERSION_PROBLEM,
+	RESOURCE_PROBLEM
 };
=20
 /* this is a special 64bit data type that is 8-byte aligned */
diff --exclude '*.d' --exclude-from /var/kernel/exclude_these -urpN iptable=
s-1.3.4-pom-l7/iptables-standalone.c iptables-1.3.4-pom-l7-blocking/iptable=
s-standalone.c
--- iptables-1.3.4-pom-l7/iptables-standalone.c	2005-01-04 11:38:39.0000000=
00 +0100
+++ iptables-1.3.4-pom-l7-blocking/iptables-standalone.c	2006-06-08 14:23:4=
8.000000000 +0200
@@ -64,9 +64,13 @@ main(int argc, char *argv[])
 	if (ret)
 		ret =3D iptc_commit(&handle);
=20
-	if (!ret)
+	if (!ret) {
 		fprintf(stderr, "iptables: %s\n",
 			iptc_strerror(errno));
+		if (errno =3D=3D EAGAIN) {
+			exit(RESOURCE_PROBLEM);
+		}
+	}
=20
 	exit(!ret);
 }
diff --exclude '*.d' --exclude-from /var/kernel/exclude_these -urpN iptable=
s-1.3.4-pom-l7/libiptc/libiptc.c iptables-1.3.4-pom-l7-blocking/libiptc/lib=
iptc.c
--- iptables-1.3.4-pom-l7/libiptc/libiptc.c	2005-10-31 20:03:49.000000000 +=
0100
+++ iptables-1.3.4-pom-l7-blocking/libiptc/libiptc.c	2006-06-07 10:25:02.00=
0000000 +0200
@@ -2104,6 +2104,7 @@ TC_COMMIT(TC_HANDLE_T *handle)
 		free(repl->counters);
 		free(repl);
 		free(newcounters);
+		// The "EAGAIN: Resource temporarily unavailable" occurs here.
 		return 0;
 	}
=20


--=-qfhlrsRW34nksTiIf/vm
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQBEiB2HwuVH+NB3fZkRAhGwAJ9sP5TRhhLrgTegE8qQ2VwFyevXegCfS/m/
bQykjeexCVPtowK4s703zA0=
=Xwgh
-----END PGP SIGNATURE-----

--=-qfhlrsRW34nksTiIf/vm--
