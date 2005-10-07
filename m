From: Harald Welte <laforge@netfilter.org>
Subject: [PATCH 5/5] NETFILTER ctnetlink: allow userspace to change protoinfo
Date: Sat, 8 Oct 2005 00:27:19 +0200
Message-ID: <20051007222719.GP4450@rama.customers.eurospot.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="9lPOKfY2vCV97ybw"
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


--9lPOKfY2vCV97ybw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave,

this is clearly a new feature, so it can wait for 2.6.15.

Please apply to your 2.6.15 queue, or tell me to resubmit later, thanks.


[NETFILTER] ctnetlink: add support to change protocol info

This patch add support to change the state of the private protocol
information via conntrack_netlink.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Harald Welte <laforge@netfilter.org>

---
commit ffcaec22fc809c18ae5c6837515c2ba5962fa0c2
tree b1985400c94eac012415e63d22e9318f22a92f67
parent ba8264034a65ccb9a84e3be2ab1fe5b2b20dc692
author Harald Welte <laforge@netfilter.org> Fri, 07 Oct 2005 23:42:02 +0200
committer Harald Welte <laforge@netfilter.org> Fri, 07 Oct 2005 23:42:02 +0=
200

 net/ipv4/netfilter/ip_conntrack_netlink.c |   37 +++++++++++++++++++++++++=
++++
 1 files changed, 37 insertions(+), 0 deletions(-)

diff --git a/net/ipv4/netfilter/ip_conntrack_netlink.c b/net/ipv4/netfilter=
/ip_conntrack_netlink.c
--- a/net/ipv4/netfilter/ip_conntrack_netlink.c
+++ b/net/ipv4/netfilter/ip_conntrack_netlink.c
@@ -948,6 +948,31 @@ ctnetlink_change_timeout(struct ip_connt
 	return 0;
 }
=20
+static inline int
+ctnetlink_change_protoinfo(struct ip_conntrack *ct, struct nfattr *cda[])
+{
+	struct nfattr *tb[CTA_PROTOINFO_MAX], *attr =3D cda[CTA_PROTOINFO-1];
+	struct ip_conntrack_protocol *proto;
+	u_int16_t npt =3D ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.dst.protonum;
+	int err =3D 0;
+
+	if (nfattr_parse_nested(tb, CTA_PROTOINFO_MAX, attr) < 0)
+		goto nfattr_failure;
+
+	proto =3D ip_conntrack_proto_find_get(npt);
+	if (!proto)
+		return -EINVAL;
+
+	if (proto->from_nfattr)
+		err =3D proto->from_nfattr(tb, ct);
+	ip_conntrack_proto_put(proto);=20
+
+	return err;
+
+nfattr_failure:
+	return -ENOMEM;
+}
+
 static int
 ctnetlink_change_conntrack(struct ip_conntrack *ct, struct nfattr *cda[])
 {
@@ -973,6 +998,12 @@ ctnetlink_change_conntrack(struct ip_con
 			return err;
 	}
=20
+	if (cda[CTA_PROTOINFO-1]) {
+		err =3D ctnetlink_change_protoinfo(ct, cda);
+		if (err < 0)
+			return err;
+	}
+
 	DEBUGP("all done\n");
 	return 0;
 }
@@ -1002,6 +1033,12 @@ ctnetlink_create_conntrack(struct nfattr
 	if (err < 0)
 		goto err;
=20
+	if (cda[CTA_PROTOINFO-1]) {
+		err =3D ctnetlink_change_protoinfo(ct, cda);
+		if (err < 0)
+			return err;
+	}
+
 	ct->helper =3D ip_conntrack_helper_find_get(rtuple);
=20
 	add_timer(&ct->timeout);
--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--9lPOKfY2vCV97ybw
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2 (GNU/Linux)

iD8DBQFDRvZHXaXGVTD0i/8RAlHjAJ4nokS3cIYbgCF9uKcWsz4nbFhUNwCeNJdo
+yqMLxb2TcFxfbOCtW0Yl5c=
=Iwho
-----END PGP SIGNATURE-----

--9lPOKfY2vCV97ybw--
