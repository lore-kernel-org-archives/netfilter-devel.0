From: Harald Welte <laforge@netfilter.org>
Subject: [PATCH] netfilter fix (4/7): fix ip6tables alignment (64bit archs)
Date: Tue, 24 Jun 2003 16:02:57 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030624140257.GD2645@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="kvUQC+jR9YzypDnK"
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


--kvUQC+jR9YzypDnK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave!

Here goes the fourth...


Author: Jakub Bogusz <qboosh@pld.org.pl>

The calculated padding used for alignment in struct ip6t_table_info
type definition is wrong.
char[SMP_ALIGN((NF_IP6_NUMHOOKS*2+2)*sizeof(unsigned int))]
has _its size_ (not end address) aligned to cache line size; also note
that there are 3 ints, not 2 before arrays. And if whole ip6t_table_info
started on address aligned to 8, entries were placed on address not
aligned to 8. On some machines (at least ppc - IBM RS/6000)
__alignof__(struct ip6t_entry) is 8 - so loading any ip6table_* module
failed with "Bad offset".

Probably padding was meant to be something like
char padding[SMP_ALIGN((NF_IP6_NUMHOOKS*2+3)*sizeof(unsigned int)) -
	((NF_IP6_NUMHOOKS*2+3)*sizeof(unsigned int))]
but it's simpler to use gcc's aligned attribute through
____cacheline_aligned macro (just like in ipt_table_info struct in
ip_tables module for ipv4/netfilter).


diff -Nru --exclude .depend --exclude '*.o' --exclude '*.ver' --exclude '.*=
=2Eflags' --exclude '*.orig' --exclude '*.rej' --exclude '*~' linux-2.4.21-=
32cpu/net/ipv6/netfilter/ip6_tables.c linux-2.4.21-ip6t_alignment/net/ipv6/=
netfilter/ip6_tables.c
--- linux-2.4.21-32cpu/net/ipv6/netfilter/ip6_tables.c	2002-11-29 00:53:15.=
000000000 +0100
+++ linux-2.4.21-ip6t_alignment/net/ipv6/netfilter/ip6_tables.c	2003-06-24 =
15:54:55.000000000 +0200
@@ -101,10 +101,8 @@
 	unsigned int hook_entry[NF_IP6_NUMHOOKS];
 	unsigned int underflow[NF_IP6_NUMHOOKS];
=20
-	char padding[SMP_ALIGN((NF_IP6_NUMHOOKS*2+2)*sizeof(unsigned int))];
-
 	/* ip6t_entry tables: one per CPU */
-	char entries[0];
+	char entries[0] ____cacheline_aligned;
 };
=20
 static LIST_HEAD(ip6t_target);
@@ -1450,7 +1448,7 @@
 	int ret;
 	struct ip6t_table_info *newinfo;
 	static struct ip6t_table_info bootstrap
-		=3D { 0, 0, 0, { 0 }, { 0 }, { }, { } };
+		=3D { 0, 0, 0, { 0 }, { 0 }, { } };
=20
 	MOD_INC_USE_COUNT;
 	newinfo =3D vmalloc(sizeof(struct ip6t_table_info)




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

--kvUQC+jR9YzypDnK
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.1 (GNU/Linux)

iD8DBQE++FoRXaXGVTD0i/8RAvOeAJ4/CAIoYgH4OhopglXcn8KApMQmGgCghUfg
v4JNrS5WKGGgpPld3rELWig=
=fLSU
-----END PGP SIGNATURE-----

--kvUQC+jR9YzypDnK--
