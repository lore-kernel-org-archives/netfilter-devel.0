From: Harald Welte <laforge@netfilter.org>
Subject: [PATCH 4/5] NETFILTER ctnetlink: allow userspace to change tcp state
Date: Sat, 8 Oct 2005 00:26:25 +0200
Message-ID: <20051007222625.GO4450@rama.customers.eurospot.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="/YnR2r17TIEndSCI"
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


--/YnR2r17TIEndSCI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave,

this is clearly a new feature, so it can wait for 2.6.15.

Please apply to your 2.6.15 queue, or tell me to resubmit later, thanks.

[NETFILTER] ctnetlink: allow userspace to change TCP state

This patch adds the ability of changing the state a TCP connection. I know
that this must be used with care but it's required to provide a complete
conntrack creation via conntrack_netlink. So I'll document this aspect on
the upcoming docs.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Harald Welte <laforge@netfilter.org>

---
commit ba8264034a65ccb9a84e3be2ab1fe5b2b20dc692
tree b2b29df9a5f6a5e79e8e12838bea111723554306
parent d02c08d8d64333867d569535ed02f9600bcfb91d
author Harald Welte <laforge@netfilter.org> Fri, 07 Oct 2005 23:40:39 +0200
committer Harald Welte <laforge@netfilter.org> Fri, 07 Oct 2005 23:40:39 +0=
200

 clude/linux/netfilter_ipv4/ip_conntrack_protocol.h |    3 +++
 net/ipv4/netfilter/ip_conntrack_proto_tcp.c        |   23 ++++++++++++++++=
++++
 2 files changed, 26 insertions(+), 0 deletions(-)

diff --git a/include/linux/netfilter_ipv4/ip_conntrack_protocol.h b/include=
/linux/netfilter_ipv4/ip_conntrack_protocol.h
--- a/include/linux/netfilter_ipv4/ip_conntrack_protocol.h
+++ b/include/linux/netfilter_ipv4/ip_conntrack_protocol.h
@@ -52,6 +52,9 @@ struct ip_conntrack_protocol
 	int (*to_nfattr)(struct sk_buff *skb, struct nfattr *nfa,
 			 const struct ip_conntrack *ct);
=20
+	/* convert nfnetlink attributes to protoinfo */
+	int (*from_nfattr)(struct nfattr *tb[], struct ip_conntrack *ct);
+
 	int (*tuple_to_nfattr)(struct sk_buff *skb,
 			       const struct ip_conntrack_tuple *t);
 	int (*nfattr_to_tuple)(struct nfattr *tb[],
diff --git a/net/ipv4/netfilter/ip_conntrack_proto_tcp.c b/net/ipv4/netfilt=
er/ip_conntrack_proto_tcp.c
--- a/net/ipv4/netfilter/ip_conntrack_proto_tcp.c
+++ b/net/ipv4/netfilter/ip_conntrack_proto_tcp.c
@@ -356,6 +356,28 @@ nfattr_failure:
 	read_unlock_bh(&tcp_lock);
 	return -ENOMEM;
 }
+
+static int nfattr_to_tcp(struct nfattr *cda[], struct ip_conntrack *ct)
+{
+	struct nfattr *attr =3D cda[CTA_PROTOINFO_TCP-1];
+	struct nfattr *tb[CTA_PROTOINFO_TCP_MAX];
+
+        if (nfattr_parse_nested(tb, CTA_PROTOINFO_TCP_MAX, attr) < 0)
+                goto nfattr_failure;
+
+	if (!tb[CTA_PROTOINFO_TCP_STATE-1])
+		return -EINVAL;
+
+	write_lock_bh(&tcp_lock);
+	ct->proto.tcp.state =3D=20
+		*(u_int8_t *)NFA_DATA(tb[CTA_PROTOINFO_TCP_STATE-1]);
+	write_unlock_bh(&tcp_lock);
+
+	return 0;
+
+nfattr_failure:
+	return -ENOMEM;
+}
 #endif
=20
 static unsigned int get_conntrack_index(const struct tcphdr *tcph)
@@ -1127,6 +1149,7 @@ struct ip_conntrack_protocol ip_conntrac
 #if defined(CONFIG_IP_NF_CONNTRACK_NETLINK) || \
     defined(CONFIG_IP_NF_CONNTRACK_NETLINK_MODULE)
 	.to_nfattr		=3D tcp_to_nfattr,
+	.from_nfattr		=3D nfattr_to_tcp,
 	.tuple_to_nfattr	=3D ip_ct_port_tuple_to_nfattr,
 	.nfattr_to_tuple	=3D ip_ct_port_nfattr_to_tuple,
 #endif
--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--/YnR2r17TIEndSCI
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2 (GNU/Linux)

iD8DBQFDRvYRXaXGVTD0i/8RAtK0AKCEv33pjsrhKS9/o3LBQxsOshbQVQCghSmj
jI2gKLMcdVITLhE7XH2v26Y=
=YroZ
-----END PGP SIGNATURE-----

--/YnR2r17TIEndSCI--
