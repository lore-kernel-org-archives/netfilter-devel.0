From: Harald Welte <laforge@netfilter.org>
Subject: [PATCH 3/5] NETFILTER ctnetlink: add one nesting level for TCP
Date: Sat, 8 Oct 2005 00:24:56 +0200
Message-ID: <20051007222456.GN4450@rama.customers.eurospot.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="kOdvwer/5gjFgNo6"
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


--kOdvwer/5gjFgNo6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave,

I leave it up to you to decide whether that is considered a bug fix
or not.  To me it is one, since the missing nesting level will create
(resolvable, but still ugly) compatibility issues when 2.6.14 is
released without it, but 2.6.15 will introduce it.

Please apply (or add to your 2.6.15 queue, or tell me to resubmit
later), thanks.


[NETFILTER] ctnetlink: add one nesting level for TCP state

To keep consistency, the TCP private protocol information is nested
attributes under CTA_PROTOINFO_TCP. This way the sequence of attributes to
access the TCP state information looks like here below:

CTA_PROTOINFO
CTA_PROTOINFO_TCP
CTA_PROTOINFO_TCP_STATE

instead of:

CTA_PROTOINFO
CTA_PROTOINFO_TCP_STATE

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Harald Welte <laforge@netfilter.org>

---
commit d02c08d8d64333867d569535ed02f9600bcfb91d
tree 7dbf9c904c36aa4c1fb7d68d8f8f150ad5b3ce64
parent cecb8a8d864562529a9798fd401411158ccadf4c
author Harald Welte <laforge@netfilter.org> Fri, 07 Oct 2005 23:38:34 +0200
committer Harald Welte <laforge@netfilter.org> Fri, 07 Oct 2005 23:38:34 +0=
200

 include/linux/netfilter/nfnetlink_conntrack.h |    9 ++++++++-
 net/ipv4/netfilter/ip_conntrack_proto_tcp.c   |    4 ++++
 2 files changed, 12 insertions(+), 1 deletions(-)

diff --git a/include/linux/netfilter/nfnetlink_conntrack.h b/include/linux/=
netfilter/nfnetlink_conntrack.h
--- a/include/linux/netfilter/nfnetlink_conntrack.h
+++ b/include/linux/netfilter/nfnetlink_conntrack.h
@@ -70,11 +70,18 @@ enum ctattr_l4proto {
=20
 enum ctattr_protoinfo {
 	CTA_PROTOINFO_UNSPEC,
-	CTA_PROTOINFO_TCP_STATE,
+	CTA_PROTOINFO_TCP,
 	__CTA_PROTOINFO_MAX
 };
 #define CTA_PROTOINFO_MAX (__CTA_PROTOINFO_MAX - 1)
=20
+enum ctattr_protoinfo_tcp {
+	CTA_PROTOINFO_TCP_UNSPEC,
+	CTA_PROTOINFO_TCP_STATE,
+	__CTA_PROTOINFO_TCP_MAX
+};
+#define CTA_PROTOINFO_TCP_MAX (__CTA_PROTOINFO_TCP_MAX - 1)
+
 enum ctattr_counters {
 	CTA_COUNTERS_UNSPEC,
 	CTA_COUNTERS_PACKETS,		/* old 64bit counters */
diff --git a/net/ipv4/netfilter/ip_conntrack_proto_tcp.c b/net/ipv4/netfilt=
er/ip_conntrack_proto_tcp.c
--- a/net/ipv4/netfilter/ip_conntrack_proto_tcp.c
+++ b/net/ipv4/netfilter/ip_conntrack_proto_tcp.c
@@ -341,11 +341,15 @@ static int tcp_print_conntrack(struct se
 static int tcp_to_nfattr(struct sk_buff *skb, struct nfattr *nfa,
 			 const struct ip_conntrack *ct)
 {
+	struct nfattr *nest_parms =3D NFA_NEST(skb, CTA_PROTOINFO_TCP);
+=09
 	read_lock_bh(&tcp_lock);
 	NFA_PUT(skb, CTA_PROTOINFO_TCP_STATE, sizeof(u_int8_t),
 		&ct->proto.tcp.state);
 	read_unlock_bh(&tcp_lock);
=20
+	NFA_NEST_END(skb, nest_parms);
+
 	return 0;
=20
 nfattr_failure:
--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--kOdvwer/5gjFgNo6
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2 (GNU/Linux)

iD8DBQFDRvW4XaXGVTD0i/8RAhn9AKCzTqwjzhfX9pSQ6GZDl0qJOGKrXwCaA0Es
OjDn1THFTHubBhEWBuYV3Qs=
=xoj8
-----END PGP SIGNATURE-----

--kOdvwer/5gjFgNo6--
