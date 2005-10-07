From: Harald Welte <laforge@netfilter.org>
Subject: [PATCH] don't use __be16 in files used by userspace
Date: Fri, 7 Oct 2005 12:31:05 +0200
Message-ID: <20051007103105.GF4719@rama>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="e5bfZ/T2xnjpUIbw"
Cc: David Miller <davem@davemloft.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
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


--e5bfZ/T2xnjpUIbw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave!

This (or a different solution such as=20
"#ifndef __KERNEL__ #define __be16 #endif" needs to go in before 2.6.14
is released, since otherwise we'd break userspace compilation :(

Please apply, thanks.


[NETFILTER] do not use __be16 in headerfile that is used by userspace

__be16 is not defined in userspace, and therefore iptables cannot be
compiled with such types in ip_conntrack_tuple.h.  Yes, we can add a bogus
#define to iptables userspace, but we can only do so for new releases, not
for old ones.  Since we do not want to loose the ability to compile old
iptables programs on new kernels, we revert the change.

Signed-off-by: Harald Welte <laforge@netfilter.org>

---
commit 4714eea267d67e65aabb6518cbfa81b8c45c2147
tree caf15c3b67ea6595db868305e7042cbea3f01edf
parent d5b3f0a9fdcf7881d3b6efedd862aef6d561db03
author Harald Welte <laforge@netfilter.org> Fri, 07 Oct 2005 12:59:02 +0200
committer Harald Welte <laforge@netfilter.org> Fri, 07 Oct 2005 12:59:02 +0=
200

 include/linux/netfilter_ipv4/ip_conntrack_tuple.h |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/linux/netfilter_ipv4/ip_conntrack_tuple.h b/include/li=
nux/netfilter_ipv4/ip_conntrack_tuple.h
--- a/include/linux/netfilter_ipv4/ip_conntrack_tuple.h
+++ b/include/linux/netfilter_ipv4/ip_conntrack_tuple.h
@@ -17,7 +17,7 @@ union ip_conntrack_manip_proto
 	u_int16_t all;
=20
 	struct {
-		__be16 port;
+		u_int16_t port;
 	} tcp;
 	struct {
 		u_int16_t port;
@@ -29,7 +29,7 @@ union ip_conntrack_manip_proto
 		u_int16_t port;
 	} sctp;
 	struct {
-		__be16 key;	/* key is 32bit, pptp only uses 16 */
+		u_int16_t key;	/* key is 32bit, pptp only uses 16 */
 	} gre;
 };
=20
@@ -65,7 +65,7 @@ struct ip_conntrack_tuple
 				u_int16_t port;
 			} sctp;
 			struct {
-				__be16 key;	/* key is 32bit,=20
+				u_int16_t key;	/* key is 32bit,=20
 						 * pptp only uses 16 */
 			} gre;
 		} u;
--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--e5bfZ/T2xnjpUIbw
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2 (GNU/Linux)

iD8DBQFDRk5pXaXGVTD0i/8RAgaWAJ4l2HpjBzaido4zptzL1Zmar6I0fACeKMFs
ZUao+RBPhMZJrYlbWCmW0Ts=
=rflO
-----END PGP SIGNATURE-----

--e5bfZ/T2xnjpUIbw--
