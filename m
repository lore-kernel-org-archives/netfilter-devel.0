From: Harald Welte <laforge@netfilter.org>
Subject: [PATCH] netfilter fix (1/7): make conntrack really search backwards
Date: Tue, 24 Jun 2003 15:57:06 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030624135706.GA2645@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="XsQoSWH+UP9D9v3l"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: David Miller <davem@redhat.com>
Content-Disposition: inline
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--XsQoSWH+UP9D9v3l
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave!

This patch is the first of a series of patches (7 fixes, 4 enhancements,
7 cosmetic changes) I have pending for 2.4.22-pre.

I'll take care of merging the patches with 2.5, but this will take
another day. Expect them tomorrow.

=3D=3D=3D

Author: Martin Josefsson <gandalf@wlug.westbo.se>
Really search _backwards_ to find the oldest unreplied connection to evict


diff -Nru --exclude .depend --exclude '*.o' --exclude '*.ver' --exclude '.*=
=2Eflags' --exclude '*.orig' --exclude '*.rej' --exclude '*~' linux-2.4.21-=
plain/include/linux/netfilter_ipv4/listhelp.h linux-2.4.21-dropback/include=
/linux/netfilter_ipv4/listhelp.h
--- linux-2.4.21-plain/include/linux/netfilter_ipv4/listhelp.h	2001-07-26 2=
2:52:12.000000000 +0200
+++ linux-2.4.21-dropback/include/linux/netfilter_ipv4/listhelp.h	2003-06-2=
4 15:50:53.000000000 +0200
@@ -39,6 +39,22 @@
 	(type)__i;				\
 })
=20
+/* Just like LIST_FIND but we search backwards */
+#define LIST_FIND_B(head, cmpfn, type, args...)		\
+({							\
+	const struct list_head *__i =3D (head);		\
+							\
+	ASSERT_READ_LOCK(head);				\
+	do {						\
+		__i =3D __i->prev;			\
+		if (__i =3D=3D (head)) {			\
+			__i =3D NULL;			\
+			break;				\
+		}					\
+	} while (!cmpfn((const type)__i , ## args));	\
+	(type)__i;					\
+})
+
 static inline int
 __list_cmp_same(const void *p1, const void *p2) { return p1 =3D=3D p2; }
=20
diff -Nru --exclude .depend --exclude '*.o' --exclude '*.ver' --exclude '.*=
=2Eflags' --exclude '*.orig' --exclude '*.rej' --exclude '*~' linux-2.4.21-=
plain/net/ipv4/netfilter/ip_conntrack_core.c linux-2.4.21-dropback/net/ipv4=
/netfilter/ip_conntrack_core.c
--- linux-2.4.21-plain/net/ipv4/netfilter/ip_conntrack_core.c	2003-06-13 16=
:51:39.000000000 +0200
+++ linux-2.4.21-dropback/net/ipv4/netfilter/ip_conntrack_core.c	2003-06-24=
 15:50:53.000000000 +0200
@@ -596,7 +596,7 @@
 	int dropped =3D 0;
=20
 	READ_LOCK(&ip_conntrack_lock);
-	h =3D LIST_FIND(chain, unreplied, struct ip_conntrack_tuple_hash *);
+	h =3D LIST_FIND_B(chain, unreplied, struct ip_conntrack_tuple_hash *);
 	if (h)
 		atomic_inc(&h->ctrack->ct_general.use);
 	READ_UNLOCK(&ip_conntrack_lock);

Please apply, thanks.

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--XsQoSWH+UP9D9v3l
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.1 (GNU/Linux)

iD8DBQE++FiyXaXGVTD0i/8RAtVzAJ9qb1DJf/qlAcELDWIMUM/SJHHNfQCglrOw
h125RyL0F2iGgTX6ndEIU8I=
=UTcR
-----END PGP SIGNATURE-----

--XsQoSWH+UP9D9v3l--
