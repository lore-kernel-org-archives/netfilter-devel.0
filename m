From: Harald Welte <laforge@netfilter.org>
Subject: [PATCH 4/6] move nfnetlink attr_count from subsys -> callback
Date: Tue, 2 Aug 2005 12:57:50 +0200
Message-ID: <20050802105750.GK4158@rama.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ZG5hGh9V5E9QzVHS"
Cc: Linux Netdev List <netdev@vger.kernel.org>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
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


--ZG5hGh9V5E9QzVHS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

[NETFILTER] attribute count is an anttribute of message type, not subsytem

Prior to this patch, every nfnetlink subsystem had to specify it's
attribute count.  However, in reality the attribute count depends on the
message type within the subsystem, not the subsystem itself.  This patch
moves 'attr_count' from 'struct nfnetlink_subsys' into nfnl_callback to
fix this.

Signed-off-by: Harald Welte <laforge@netfilter.org>

---
commit 9ae30513b70ed5325f66adc02788a7d6ef69cb1e
tree 993ba601e02c1be1e23896d4b62ac45de0bb7064
parent 5d03469be285d9bc2b82861d87c667cf5614132d
author Harald Welte <laforge@netfilter.org> Di, 02 Aug 2005 12:17:57 +0200
committer Harald Welte <laforge@netfilter.org> Di, 02 Aug 2005 12:17:57 +02=
00

 include/linux/netfilter/nfnetlink.h       |    4 ++--
 net/ipv4/netfilter/ip_conntrack_netlink.c |    9 +++++++--
 net/netfilter/nfnetlink.c                 |   20 ++++++++++++++++----
 net/netfilter/nfnetlink_log.c             |    5 +++--
 net/netfilter/nfnetlink_queue.c           |    4 +++-
 5 files changed, 31 insertions(+), 11 deletions(-)

diff --git a/include/linux/netfilter/nfnetlink.h b/include/linux/netfilter/=
nfnetlink.h
--- a/include/linux/netfilter/nfnetlink.h
+++ b/include/linux/netfilter/nfnetlink.h
@@ -85,9 +85,10 @@ struct nfgenmsg {
=20
 struct nfnl_callback
 {
-	kernel_cap_t cap_required; /* capabilities required for this msg */
 	int (*call)(struct sock *nl, struct sk_buff *skb,=20
 		struct nlmsghdr *nlh, struct nfattr *cda[], int *errp);
+	kernel_cap_t cap_required; /* capabilities required for this msg */
+	u_int16_t attr_count;	/* number of nfattr's */
 };
=20
 struct nfnetlink_subsystem
@@ -95,7 +96,6 @@ struct nfnetlink_subsystem
 	const char *name;
 	__u8 subsys_id;		/* nfnetlink subsystem ID */
 	__u8 cb_count;		/* number of callbacks */
-	u_int32_t attr_count;	/* number of nfattr's */
 	struct nfnl_callback *cb; /* callback for individual types */
 };
=20
diff --git a/net/ipv4/netfilter/ip_conntrack_netlink.c b/net/ipv4/netfilter=
/ip_conntrack_netlink.c
--- a/net/ipv4/netfilter/ip_conntrack_netlink.c
+++ b/net/ipv4/netfilter/ip_conntrack_netlink.c
@@ -1484,21 +1484,28 @@ static struct notifier_block ctnl_notifi
=20
 static struct nfnl_callback ctnl_cb[IPCTNL_MSG_MAX] =3D {
 	[IPCTNL_MSG_CT_NEW]		=3D { .call =3D ctnetlink_new_conntrack,
+					    .attr_count =3D CTA_MAX,
 					    .cap_required =3D CAP_NET_ADMIN },
 	[IPCTNL_MSG_CT_GET] 		=3D { .call =3D ctnetlink_get_conntrack,
+					    .attr_count =3D CTA_MAX,
 					    .cap_required =3D CAP_NET_ADMIN },
 	[IPCTNL_MSG_CT_DELETE]  	=3D { .call =3D ctnetlink_del_conntrack,
+					    .attr_count =3D CTA_MAX,
 					    .cap_required =3D CAP_NET_ADMIN },
 	[IPCTNL_MSG_CT_GET_CTRZERO] 	=3D { .call =3D ctnetlink_get_conntrack,
+					    .attr_count =3D CTA_MAX,
 					    .cap_required =3D CAP_NET_ADMIN },
 };
=20
 static struct nfnl_callback ctnl_exp_cb[IPCTNL_MSG_MAX] =3D {
 	[IPCTNL_MSG_EXP_GET]		=3D { .call =3D ctnetlink_get_expect,
+					    .attr_count =3D CTA_EXPECT_MAX,
 					    .cap_required =3D CAP_NET_ADMIN },
 	[IPCTNL_MSG_EXP_NEW]		=3D { .call =3D ctnetlink_new_expect,
+					    .attr_count =3D CTA_EXPECT_MAX,
 					    .cap_required =3D CAP_NET_ADMIN },
 	[IPCTNL_MSG_EXP_DELETE]		=3D { .call =3D ctnetlink_del_expect,
+					    .attr_count =3D CTA_EXPECT_MAX,
 					    .cap_required =3D CAP_NET_ADMIN },
 };
=20
@@ -1506,7 +1513,6 @@ static struct nfnetlink_subsystem ctnl_s
 	.name				=3D "conntrack",
 	.subsys_id			=3D NFNL_SUBSYS_CTNETLINK,
 	.cb_count			=3D IPCTNL_MSG_MAX,
-	.attr_count			=3D CTA_MAX,
 	.cb				=3D ctnl_cb,
 };
=20
@@ -1514,7 +1520,6 @@ static struct nfnetlink_subsystem ctnl_e
 	.name				=3D "conntrack_expect",
 	.subsys_id			=3D NFNL_SUBSYS_CTNETLINK_EXP,
 	.cb_count			=3D IPCTNL_MSG_EXP_MAX,
-	.attr_count			=3D CTA_MAX,
 	.cb				=3D ctnl_exp_cb,
 };
=20
diff --git a/net/netfilter/nfnetlink.c b/net/netfilter/nfnetlink.c
--- a/net/netfilter/nfnetlink.c
+++ b/net/netfilter/nfnetlink.c
@@ -155,8 +155,18 @@ nfnetlink_check_attributes(struct nfnetl
 			   struct nlmsghdr *nlh, struct nfattr *cda[])
 {
 	int min_len;
+	u_int16_t attr_count;
+	u_int8_t cb_id =3D NFNL_MSG_TYPE(nlh->nlmsg_type);
=20
-	memset(cda, 0, sizeof(struct nfattr *) * subsys->attr_count);
+	if (unlikely(cb_id >=3D subsys->cb_count)) {
+		DEBUGP("msgtype %u >=3D %u, returning\n",
+			cb_id, subsys->cb_count);
+		return -EINVAL;
+	}
+=09
+	attr_count =3D subsys->cb[cb_id].attr_count;
+
+	memset(cda, 0, sizeof(struct nfattr *) * attr_count);
=20
 	/* check attribute lengths. */
 	min_len =3D NLMSG_ALIGN(sizeof(struct nfgenmsg));
@@ -170,7 +180,7 @@ nfnetlink_check_attributes(struct nfnetl
 		while (NFA_OK(attr, attrlen)) {
 			unsigned flavor =3D attr->nfa_type;
 			if (flavor) {
-				if (flavor > subsys->attr_count)
+				if (flavor > attr_count)
 					return -EINVAL;
 				cda[flavor - 1] =3D attr;
 			}
@@ -256,9 +266,11 @@ static inline int nfnetlink_rcv_msg(stru
 	}
=20
 	{
-		struct nfattr *cda[ss->attr_count];
+		u_int16_t attr_count =3D=20
+			ss->cb[NFNL_MSG_TYPE(nlh->nlmsg_type)].attr_count;
+		struct nfattr *cda[attr_count];
=20
-		memset(cda, 0, ss->attr_count*sizeof(struct nfattr *));
+		memset(cda, 0, sizeof(struct nfattr *) * attr_count);
 	=09
 		err =3D nfnetlink_check_attributes(ss, nlh, cda);
 		if (err < 0)
diff --git a/net/netfilter/nfnetlink_log.c b/net/netfilter/nfnetlink_log.c
--- a/net/netfilter/nfnetlink_log.c
+++ b/net/netfilter/nfnetlink_log.c
@@ -803,8 +803,10 @@ out_put:
=20
 static struct nfnl_callback nfulnl_cb[NFULNL_MSG_MAX] =3D {
 	[NFULNL_MSG_PACKET]	=3D { .call =3D nfulnl_recv_unsupp,
-				    .cap_required =3D CAP_NET_ADMIN },
+				    .attr_count =3D NFULA_MAX,
+				    .cap_required =3D CAP_NET_ADMIN, },
 	[NFULNL_MSG_CONFIG]	=3D { .call =3D nfulnl_recv_config,
+				    .attr_count =3D NFULA_CFG_MAX,
 				    .cap_required =3D CAP_NET_ADMIN },
 };
=20
@@ -812,7 +814,6 @@ static struct nfnetlink_subsystem nfulnl
 	.name		=3D "log",
 	.subsys_id	=3D NFNL_SUBSYS_ULOG,
 	.cb_count	=3D NFULNL_MSG_MAX,
-	.attr_count	=3D NFULA_MAX,
 	.cb		=3D nfulnl_cb,
 };
=20
diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queu=
e.c
--- a/net/netfilter/nfnetlink_queue.c
+++ b/net/netfilter/nfnetlink_queue.c
@@ -877,10 +877,13 @@ out_put:
=20
 static struct nfnl_callback nfqnl_cb[NFQNL_MSG_MAX] =3D {
 	[NFQNL_MSG_PACKET]	=3D { .call =3D nfqnl_recv_unsupp,
+				    .attr_count =3D NFQA_MAX,
 				    .cap_required =3D CAP_NET_ADMIN },
 	[NFQNL_MSG_VERDICT]	=3D { .call =3D nfqnl_recv_verdict,
+				    .attr_count =3D NFQA_MAX,
 				    .cap_required =3D CAP_NET_ADMIN },
 	[NFQNL_MSG_CONFIG]	=3D { .call =3D nfqnl_recv_config,
+				    .attr_count =3D NFQA_CFG_MAX,
 				    .cap_required =3D CAP_NET_ADMIN },
 };
=20
@@ -888,7 +891,6 @@ static struct nfnetlink_subsystem nfqnl_
 	.name		=3D "nf_queue",
 	.subsys_id	=3D NFNL_SUBSYS_QUEUE,
 	.cb_count	=3D NFQNL_MSG_MAX,
-	.attr_count	=3D NFQA_MAX,
 	.cb		=3D nfqnl_cb,
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

--ZG5hGh9V5E9QzVHS
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFC71GuXaXGVTD0i/8RAgx+AJ0fRCrwAxGND0eUyDMBDBXZHjUTjwCeOqLY
JsMbU1dVZulopVlHPk/9cuU=
=wQy+
-----END PGP SIGNATURE-----

--ZG5hGh9V5E9QzVHS--
