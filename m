From: Harald Welte <laforge@netfilter.org>
Subject: [PATCH] netfilter fix (3/7): make iptables work on systems >32 cpus
Date: Tue, 24 Jun 2003 16:01:22 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030624140122.GC2645@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="lMM8JwqTlfDpEaS6"
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


--lMM8JwqTlfDpEaS6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave!

Here goes the third...


Author: Martin Hicks <mort@wildopensource.com>

There are a bunch of (1<<smp_processor_id()) type shifts in lockhelp.h, whi=
ch
is safe for small processor machines, but breaks on larger ones.


diff -Nru a/include/linux/netfilter_ipv4/lockhelp.h b/include/linux/netfilt=
er_ipv4/lockhelp.h
--- a/include/linux/netfilter_ipv4/lockhelp.h	Tue Apr  8 19:27:20 2003
+++ b/include/linux/netfilter_ipv4/lockhelp.h	Tue Apr  8 19:27:20 2003
@@ -42,22 +42,22 @@
 	printk("ASSERT %s:%u %s locked\n", __FILE__, __LINE__, #l);	\
 } while(0)
=20
-/* Write locked OK as well. */						    \
+/* Write locked OK as well. */
 #define MUST_BE_READ_LOCKED(l)						    \
-do { if (!((l)->read_locked_map & (1 << smp_processor_id()))		    \
-	 && !((l)->write_locked_map & (1 << smp_processor_id())))	    \
+do { if (!((l)->read_locked_map & (1UL << smp_processor_id()))		    \
+	 && !((l)->write_locked_map & (1UL << smp_processor_id())))	    \
 	printk("ASSERT %s:%u %s not readlocked\n", __FILE__, __LINE__, #l); \
 } while(0)
=20
 #define MUST_BE_WRITE_LOCKED(l)						     \
-do { if (!((l)->write_locked_map & (1 << smp_processor_id())))		     \
+do { if (!((l)->write_locked_map & (1UL << smp_processor_id())))	     \
 	printk("ASSERT %s:%u %s not writelocked\n", __FILE__, __LINE__, #l); \
 } while(0)
=20
 #define MUST_BE_READ_WRITE_UNLOCKED(l)					  \
-do { if ((l)->read_locked_map & (1 << smp_processor_id()))		  \
+do { if ((l)->read_locked_map & (1UL << smp_processor_id()))		  \
 	printk("ASSERT %s:%u %s readlocked\n", __FILE__, __LINE__, #l);	  \
- else if ((l)->write_locked_map & (1 << smp_processor_id()))		  \
+ else if ((l)->write_locked_map & (1UL << smp_processor_id()))		  \
 	 printk("ASSERT %s:%u %s writelocked\n", __FILE__, __LINE__, #l); \
 } while(0)
=20
@@ -91,7 +91,7 @@
=20
 #define READ_UNLOCK(lk)							\
 do {									\
-	if (!((lk)->read_locked_map & (1 << smp_processor_id())))	\
+	if (!((lk)->read_locked_map & (1UL << smp_processor_id())))	\
 		printk("ASSERT: %s:%u %s not readlocked\n", 		\
 		       __FILE__, __LINE__, #lk);			\
 	clear_bit(smp_processor_id(), &(lk)->read_locked_map);		\
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

--lMM8JwqTlfDpEaS6
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.1 (GNU/Linux)

iD8DBQE++FmyXaXGVTD0i/8RApMoAJ9eRXqmSsBdF/jiVnITLdBRu78aqgCdEORJ
VhAMfke4QczrQDaDWSPcBj8=
=r+LC
-----END PGP SIGNATURE-----

--lMM8JwqTlfDpEaS6--
