From: Harald Welte <laforge@gnumonks.org>
Subject: [PATCH 2.6] Two ipt_CLUSTERIP fixes
Date: Fri, 6 May 2005 15:02:28 +0200
Message-ID: <20050506130228.GL30482@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="VVogE+Aj2JczxLgf"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: David Miller <davem@davemloft.net>
Content-Disposition: inline
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


--VVogE+Aj2JczxLgf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave!

Please apply the following two small CLUSTERIP fixes to your tree.

Thanks.

=3D=3D=3D

Fix handling of ICMP packets (RELATED) in ipt_CLUSTERIP target.

Signed-off-by: Harald Welte <laforge@netfilter.org>

---
commit c51a9fa4957bf92a2d430ec56b31b27318c42984
tree 0c9caa0c5b8b19e81d276bf8e864bd065324972c
parent b6d31e80f0d6a722bf85b3a7090df473fc545980
author Harald Welte <laforge@hanuman.de.gnumonks.org> 1115378435 +0200
committer Harald Welte <laforge@hanuman.de.gnumonks.org> 1115378435 +0200

Index: net/ipv4/netfilter/ipt_CLUSTERIP.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- 999772bc591650ab8b58d2c7a225ae83ecb6697f/net/ipv4/netfilter/ipt_CLUSTER=
IP.c  (mode:100644 sha1:0f12e3a3dc73dc9e4c6a535a717581c2f89d3958)
+++ 0c9caa0c5b8b19e81d276bf8e864bd065324972c/net/ipv4/netfilter/ipt_CLUSTER=
IP.c  (mode:100644 sha1:85b7bbbe2953e8efedc163e833a0c8b34d616575)
@@ -338,7 +338,7 @@
 	 * error messages (RELATED) and information requests (see below) */
 	if ((*pskb)->nh.iph->protocol =3D=3D IPPROTO_ICMP
 	    && (ctinfo =3D=3D IP_CT_RELATED=20
-		|| ctinfo =3D=3D IP_CT_IS_REPLY+IP_CT_IS_REPLY))
+		|| ctinfo =3D=3D IP_CT_RELATED+IP_CT_IS_REPLY))
 		return IPT_CONTINUE;
=20
 	/* ip_conntrack_icmp guarantees us that we only have ICMP_ECHO,=20


=0C
!-------------------------------------------------------------flip-


Fix "iptables -D" rule deletion with ipt_CLUSTERIP target.  The patch just
changes the order of structure members.

Signed-off-by: Harald Welte <laforge@netfilter.org>

---
commit c38fe815dfba73749ecd94f855883018dfccc6b6
tree 09cd81a88d9efa542d79941d00d893462cbe7b7f
parent c51a9fa4957bf92a2d430ec56b31b27318c42984
author Harald Welte <laforge@netfilter.org> 1115380872 +0200
committer Harald Welte <laforge@netfilter.org> 1115380872 +0200

Index: include/linux/netfilter_ipv4/ipt_CLUSTERIP.h
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- 0c9caa0c5b8b19e81d276bf8e864bd065324972c/include/linux/netfilter_ipv4/i=
pt_CLUSTERIP.h  (mode:100644 sha1:baa83e757156c66d9e34015f554512eadb84f1f1)
+++ 09cd81a88d9efa542d79941d00d893462cbe7b7f/include/linux/netfilter_ipv4/i=
pt_CLUSTERIP.h  (mode:100644 sha1:d9bceedfb3dca67c9c8e3290480e7cb2d2a2b28e)
@@ -18,7 +18,6 @@
 struct ipt_clusterip_tgt_info {
=20
 	u_int32_t flags;
-	struct clusterip_config *config;
 =09
 	/* only relevant for new ones */
 	u_int8_t clustermac[6];
@@ -27,6 +26,8 @@
 	u_int16_t local_nodes[CLUSTERIP_MAX_NODES];
 	enum clusterip_hashmode hash_mode;
 	u_int32_t hash_initval;
+
+	struct clusterip_config *config;
 };
=20
 #endif /*_IPT_CLUSTERIP_H_target*/


=0C
!-------------------------------------------------------------flip-


--=20
- Harald Welte <laforge@gnumonks.org>          	        http://gnumonks.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
"Privacy in residential applications is a desirable marketing option."
                                                  (ETSI EN 300 175-7 Ch. A6)

--VVogE+Aj2JczxLgf
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.0 (GNU/Linux)

iD8DBQFCe2rkXaXGVTD0i/8RAuEfAKCsjuESgL18ojfeR6nDG/Afz/6rlQCfWDwx
uO6y7S2xldnAnu6AVUJG3lM=
=I1dL
-----END PGP SIGNATURE-----

--VVogE+Aj2JczxLgf--
