From: Harald Welte <laforge@netfilter.org>
Subject: Re: [PATCH 4/7] add missing module_alias_subsys
Date: Sat, 5 Nov 2005 12:53:37 +0100
Message-ID: <20051105115337.GB16000@sunbeam.de.gnumonks.org>
References: <436BA1C1.8070806@netfilter.org> <436C5FBC.70804@trash.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="QTprm0S8XgL7H0Dt"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Pablo Neira <pablo@netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Content-Disposition: inline
In-Reply-To: <436C5FBC.70804@trash.net>
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


--QTprm0S8XgL7H0Dt
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Nov 05, 2005 at 08:31:08AM +0100, Patrick McHardy wrote:
> Pablo Neira wrote:
> >Add missing module alias. This is a must to load ctnetlink on demand.
> >For example, the conntrack tool will fail if the module isn't loaded.
>=20
> I don't think this is a good idea currently. Capability checking is
> done after module autoloading, so any user can load ctnetlink,
> ip_conntrack and all related modules.=20

interesting point, thanks for mentioning it.

> Please make sure to move capability checking in nfnetlink before
> module loading first.

This unfortunately doesn't work with the current architecture, where
every nfnetlink subsystem can specifiy the required capabilities per
message.  That specification isn't available before loading the module,
though.

I think we can (in addition to our usual capability checks) add a
capability check to only do autoloading of a module if CAP_NET_ADMIN is
set.  Like:


[NETFILTER] nfnetlink: only load subsystems if CAP_NET_ADMIN is set

Without this patch, any user can cause nfnetlink subsystems to be
autoloaded.  Those subsystems however could add significant processing
overhead to packet processing, and would refuse any configuration messages
=66rom non-CAP_NET_ADMIN processes anyway.

This patch follows a suggestion from Patrick McHardy.

Signed-off-by: Harald Welte <laforge@netfilter.org>

---
commit b73cccaf3b2d71b8f516c9b28cd44bf3b4efab1c
tree a67a2728bae003a7974ed9e5fd69bc8a40fd7f03
parent 5bd49cc95f4f8ef5e6782242709927cd3ee6337d
author Harald Welte <laforge@hanuman.de.gnumonks.org> Sat, 05 Nov 2005 12:5=
2:07 +0100
committer Harald Welte <laforge@netfilter.org> Sat, 05 Nov 2005 12:52:07 +0=
100

 net/netfilter/nfnetlink.c |   17 ++++++++++-------
 1 files changed, 10 insertions(+), 7 deletions(-)

diff --git a/net/netfilter/nfnetlink.c b/net/netfilter/nfnetlink.c
--- a/net/netfilter/nfnetlink.c
+++ b/net/netfilter/nfnetlink.c
@@ -240,15 +240,18 @@ static inline int nfnetlink_rcv_msg(stru
 	ss =3D nfnetlink_get_subsys(type);
 	if (!ss) {
 #ifdef CONFIG_KMOD
-		/* don't call nfnl_shunlock, since it would reenter
-		 * with further packet processing */
-		up(&nfnl_sem);
-		request_module("nfnetlink-subsys-%d", NFNL_SUBSYS_ID(type));
-		nfnl_shlock();
-		ss =3D nfnetlink_get_subsys(type);
+		if (cap_raised(NETLINK_CB(skb).eff_cap, CAP_NET_ADMIN)) {
+			/* don't call nfnl_shunlock, since it would reenter
+			 * with further packet processing */
+			up(&nfnl_sem);
+			request_module("nfnetlink-subsys-%d",
+					NFNL_SUBSYS_ID(type));
+			nfnl_shlock();
+			ss =3D nfnetlink_get_subsys(type);
+		}
 		if (!ss)
 #endif
-		goto err_inval;
+			goto err_inval;
 	}
=20
 	nc =3D nfnetlink_find_client(type, ss);

--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--QTprm0S8XgL7H0Dt
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2 (GNU/Linux)

iD8DBQFDbJ1BXaXGVTD0i/8RArFnAJ9phUchl4OfkDQX1D2HhlDiro0VBQCeN2tr
0VyawHJP+rTQPePNhmzrLv8=
=UnUa
-----END PGP SIGNATURE-----

--QTprm0S8XgL7H0Dt--
