From: Harald Welte <laforge@netfilter.org>
Subject: [PATCH 2.6] netfilter /proc/net/ip_conntrack locking fix
Date: Tue, 27 Jan 2004 22:45:59 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040127214559.GD11761@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ZQ93ZA/51YEIDw4/"
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


--ZQ93ZA/51YEIDw4/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave!

Please apply the following fix to your 2.6.x tree.

Thanks.

Name: Grab ip_conntrack_expect_tuple_lock in list_conntracks
Author: Rusty Russell
Status: Experimental

D: http://bugme.osdl.org/show_bug.cgi?id=3D1764
D: We're walking the expect list without the ip_conntrack_expect_tuple_lock.

diff -urpN --exclude TAGS -X /home/rusty/devel/kernel/kernel-patches/curren=
t-dontdiff --minimal .20891-linux-2.6.1-rc1/include/linux/netfilter_ipv4/ip=
_conntrack_core.h .20891-linux-2.6.1-rc1.updated/include/linux/netfilter_ip=
v4/ip_conntrack_core.h
--- .20891-linux-2.6.1-rc1/include/linux/netfilter_ipv4/ip_conntrack_core.h=
	2003-09-22 10:26:46.000000000 +1000
+++ .20891-linux-2.6.1-rc1.updated/include/linux/netfilter_ipv4/ip_conntrac=
k_core.h	2004-01-03 15:27:14.000000000 +1100
@@ -50,5 +50,6 @@ static inline int ip_conntrack_confirm(s
 extern struct list_head *ip_conntrack_hash;
 extern struct list_head ip_conntrack_expect_list;
 DECLARE_RWLOCK_EXTERN(ip_conntrack_lock);
+DECLARE_RWLOCK_EXTERN(ip_conntrack_expect_tuple_lock);
 #endif /* _IP_CONNTRACK_CORE_H */
=20
diff -urpN --exclude TAGS -X /home/rusty/devel/kernel/kernel-patches/curren=
t-dontdiff --minimal .20891-linux-2.6.1-rc1/net/ipv4/netfilter/ip_conntrack=
_standalone.c .20891-linux-2.6.1-rc1.updated/net/ipv4/netfilter/ip_conntrac=
k_standalone.c
--- .20891-linux-2.6.1-rc1/net/ipv4/netfilter/ip_conntrack_standalone.c	200=
3-12-18 15:53:34.000000000 +1100
+++ .20891-linux-2.6.1-rc1.updated/net/ipv4/netfilter/ip_conntrack_standalo=
ne.c	2004-01-03 15:23:40.000000000 +1100
@@ -154,6 +154,7 @@ list_conntracks(char *buffer, char **sta
 	}
=20
 	/* Now iterate through expecteds. */
+	READ_LOCK(&ip_conntrack_expect_tuple_lock);
 	list_for_each(e, &ip_conntrack_expect_list) {
 		unsigned int last_len;
 		struct ip_conntrack_expect *expect
@@ -164,10 +165,12 @@ list_conntracks(char *buffer, char **sta
 		len +=3D print_expect(buffer + len, expect);
 		if (len > length) {
 			len =3D last_len;
-			goto finished;
+			goto finished_expects;
 		}
 	}
=20
+ finished_expects:
+	READ_UNLOCK(&ip_conntrack_expect_tuple_lock);
  finished:
 	READ_UNLOCK(&ip_conntrack_lock);
=20

--
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--ZQ93ZA/51YEIDw4/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.3 (GNU/Linux)

iD8DBQFAFtwXXaXGVTD0i/8RArjFAJ0X3M9zjEMlrpmDLbeHyxzjNdCNfwCgny7l
einh92qtwEf+K4SqqW2DYDA=
=lh5a
-----END PGP SIGNATURE-----

--ZQ93ZA/51YEIDw4/--
