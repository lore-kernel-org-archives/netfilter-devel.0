From: Harald Welte <laforge@netfilter.org>
Subject: [PATCH 2.4] netfilter: optimization of listhelp.h
Date: Sun, 30 Nov 2003 21:06:27 +0530
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20031130153627.GG26749@obroa-skai.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Encpt1P6Mxii2VuT"
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


--Encpt1P6Mxii2VuT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave!

This mail contains the fifth netfilter patch, please apply.

Author: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>

List macro optimization patch so that we can benefit
=66rom prefetching automatically.

--- linux-2.4.22-locking-base/include/linux/netfilter_ipv4/listhelp.h	2003-=
09-17 17:14:54.000000000 +0200
+++ linux-2.4.22-locking-refcount/include/linux/netfilter_ipv4/listhelp.h	2=
003-11-14 14:02:25.000000000 +0100
@@ -11,48 +11,42 @@
    required to allow inlining of cmpfn. */
 #define LIST_FIND(head, cmpfn, type, args...)		\
 ({							\
-	const struct list_head *__i =3D (head);		\
+	const struct list_head *__i, *__j =3D NULL;	\
 							\
 	ASSERT_READ_LOCK(head);				\
-	do {						\
-		__i =3D __i->next;			\
-		if (__i =3D=3D (head)) {			\
-			__i =3D NULL;			\
+	list_for_each(__i, (head))			\
+		if (cmpfn((const type)__i , ## args)) {	\
+			__j =3D __i;			\
 			break;				\
 		}					\
-	} while (!cmpfn((const type)__i , ## args));	\
-	(type)__i;					\
+	(type)__j;					\
 })
=20
-#define LIST_FIND_W(head, cmpfn, type, args...)	\
-({						\
-	const struct list_head *__i =3D (head);	\
-						\
-	ASSERT_WRITE_LOCK(head);		\
-	do {					\
-		__i =3D __i->next;		\
-		if (__i =3D=3D (head)) {		\
-			__i =3D NULL;		\
-			break;			\
-		}				\
-	} while (!cmpfn((type)__i , ## args));	\
-	(type)__i;				\
+#define LIST_FIND_W(head, cmpfn, type, args...)		\
+({							\
+	const struct list_head *__i, *__j =3D NULL;	\
+							\
+	ASSERT_WRITE_LOCK(head);			\
+	list_for_each(__i, (head))			\
+		if (cmpfn((const type)__i , ## args)) {	\
+			__j =3D __i;			\
+			break;				\
+		}					\
+	(type)__j;					\
 })
=20
 /* Just like LIST_FIND but we search backwards */
 #define LIST_FIND_B(head, cmpfn, type, args...)		\
 ({							\
-	const struct list_head *__i =3D (head);		\
+	const struct list_head *__i, *__j =3D NULL;	\
 							\
 	ASSERT_READ_LOCK(head);				\
-	do {						\
-		__i =3D __i->prev;			\
-		if (__i =3D=3D (head)) {			\
-			__i =3D NULL;			\
+	list_for_each_prev(__i, (head))			\
+		if (cmpfn((const type)__i , ## args)) {	\
+			__j =3D __i;			\
 			break;				\
 		}					\
-	} while (!cmpfn((const type)__i , ## args));	\
-	(type)__i;					\
+	(type)__j;					\
 })
=20
 static inline int
@@ -100,9 +94,9 @@
 do {								\
 	struct list_head *__i;					\
 	ASSERT_WRITE_LOCK(head);				\
-	for (__i =3D (head)->next;				\
-	     !cmpfn((new), (typeof (new))__i) && __i !=3D (head);	\
-	     __i =3D __i->next);					\
+	list_for_each(__i, (head))				\
+		if ((new), (typeof (new))__i)			\
+			break;					\
 	list_add((struct list_head *)(new), __i->prev);		\
 } while(0)
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

--Encpt1P6Mxii2VuT
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.3 (GNU/Linux)

iD8DBQE/yg6QXaXGVTD0i/8RAnAAAJ9Zm5F+cxmCdGcFODKcDva3pFvsDQCePetm
ky4uGvFnxVlVqRt6yzlp1Ps=
=NWSF
-----END PGP SIGNATURE-----

--Encpt1P6Mxii2VuT--
