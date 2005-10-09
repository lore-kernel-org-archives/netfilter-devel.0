From: Harald Welte <laforge@netfilter.org>
Subject: [PATCH 4/5] NETFILTER: remove bogus structure member
Date: Mon, 10 Oct 2005 00:15:46 +0200
Message-ID: <20051009221546.GD6493@rama.customers.eurospot.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="eqp4TxRxnD4KrmFZ"
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


--eqp4TxRxnD4KrmFZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave,=20

please apply this fix to you 2.6.14 tree.

[NETFILTER] nat: remove bogus structure member

When 'rustynat' was merged in 2.6.12, the use of the "helper" pointer of
struct ipt_nat_info was obsoleted, but the pointer not removed from the
struct.

This patch removes the pointer, thereby yet again shrinking struct
ip_conntrack.

Discovered-by: Rusty Russell <rusty@netfilter.org>
Signed-off-by: Harald Welte <laforge@netfilter.org>

---
commit 5382af42cb3fed0aa6658b8de20a966f8498ac28
tree 96ca699fc1869bad7c812802a9e9f77dfae9702d
parent ff438dea2c776f065b7260b850a19d5f7a0bfec9
author Harald Welte <laforge@netfilter.org> Sun, 09 Oct 2005 23:29:06 +0200
committer Harald Welte <laforge@netfilter.org> Sun, 09 Oct 2005 23:29:06 +0=
200

 include/linux/netfilter_ipv4/ip_nat.h |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/include/linux/netfilter_ipv4/ip_nat.h b/include/linux/netfilte=
r_ipv4/ip_nat.h
--- a/include/linux/netfilter_ipv4/ip_nat.h
+++ b/include/linux/netfilter_ipv4/ip_nat.h
@@ -58,10 +58,6 @@ extern rwlock_t ip_nat_lock;
 struct ip_nat_info
 {
 	struct list_head bysource;
-
-	/* Helper (NULL if none). */
-	struct ip_nat_helper *helper;
-
 	struct ip_nat_seq seq[IP_CT_DIR_MAX];
 };
=20
--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--eqp4TxRxnD4KrmFZ
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2 (GNU/Linux)

iD8DBQFDSZaSXaXGVTD0i/8RAuxHAJ9vWdUJBCmJZ+s5lThDm0JBeg5SvgCeNnhv
0IaMZqXVUfHAPnHNev4qHvs=
=0f2t
-----END PGP SIGNATURE-----

--eqp4TxRxnD4KrmFZ--
