From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 32/41]: nf_conntrack: add tuplehash l3num/protonum accessors
Date: Mon, 14 Apr 2008 12:17:02 +0200 (MEST)
Message-ID: <20080414101658.32717.53673.sendpatchset@localhost.localdomain>
References: <20080414101614.32717.35526.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:36343 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755637AbYDNKRD (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 14 Apr 2008 06:17:03 -0400
In-Reply-To: <20080414101614.32717.35526.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[NETFILTER]: nf_conntrack: add tuplehash l3num/protonum accessors

Add accessors for l3num and protonum and get rid of some overly long
expressions.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 94ab8bc42cb5b451913d470adb06659fec70cc9d
tree 39d4804fb533dc0d63c32e30204094da8328d43d
parent 887a1a991c8d75bcbb6ccf4cbac7559ea12cda7a
author Patrick McHardy <kaber@trash.net> Mon, 14 Apr 2008 12:10:55 +0200
committer Patrick McHardy <kaber@trash.net> Mon, 14 Apr 2008 12:10:55 +0200

 include/net/netfilter/nf_conntrack.h               |   10 +++++
 .../netfilter/nf_conntrack_l3proto_ipv4_compat.c   |   13 ++-----
 net/netfilter/nf_conntrack_amanda.c                |    4 +-
 net/netfilter/nf_conntrack_core.c                  |    3 +-
 net/netfilter/nf_conntrack_ftp.c                   |    4 +-
 net/netfilter/nf_conntrack_h323_main.c             |   39 +++++++-------------
 net/netfilter/nf_conntrack_netlink.c               |   19 ++++------
 net/netfilter/nf_conntrack_pptp.c                  |    4 +-
 net/netfilter/nf_conntrack_proto.c                 |    9 ++---
 net/netfilter/nf_conntrack_proto_dccp.c            |    3 +-
 net/netfilter/nf_conntrack_sane.c                  |    3 +-
 net/netfilter/nf_conntrack_sip.c                   |   20 ++++------
 net/netfilter/nf_conntrack_standalone.c            |   15 ++------
 net/netfilter/nf_conntrack_tftp.c                  |    4 +-
 net/netfilter/xt_connlimit.c                       |    4 +-
 net/netfilter/xt_conntrack.c                       |    4 +-
 16 files changed, 64 insertions(+), 94 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack.h b/include/net/netfilter/nf_conntrack.h
index 4a0496a..26e6a6e 100644
--- a/include/net/netfilter/nf_conntrack.h
+++ b/include/net/netfilter/nf_conntrack.h
@@ -140,6 +140,16 @@ nf_ct_tuplehash_to_ctrack(const struct nf_conntrack_tuple_hash *hash)
 			    tuplehash[hash->tuple.dst.dir]);
 }
 
+static inline u_int16_t nf_ct_l3num(const struct nf_conn *ct)
+{
+	return ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.l3num;
+}
+
+static inline u_int8_t nf_ct_protonum(const struct nf_conn *ct)
+{
+	return ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.dst.protonum;
+}
+
 /* get master conntrack via master expectation */
 #define master_ct(conntr) (conntr->master)
 
diff --git a/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4_compat.c b/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4_compat.c
index e60b885..40a46d4 100644
--- a/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4_compat.c
+++ b/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4_compat.c
@@ -106,21 +106,16 @@ static int ct_seq_show(struct seq_file *s, void *v)
 	/* we only want to print DIR_ORIGINAL */
 	if (NF_CT_DIRECTION(hash))
 		return 0;
-	if (ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.l3num != AF_INET)
+	if (nf_ct_l3num(ct) != AF_INET)
 		return 0;
 
-	l3proto = __nf_ct_l3proto_find(ct->tuplehash[IP_CT_DIR_ORIGINAL]
-				       .tuple.src.l3num);
+	l3proto = __nf_ct_l3proto_find(nf_ct_l3num(ct));
 	NF_CT_ASSERT(l3proto);
-	l4proto = __nf_ct_l4proto_find(ct->tuplehash[IP_CT_DIR_ORIGINAL]
-				       .tuple.src.l3num,
-				       ct->tuplehash[IP_CT_DIR_ORIGINAL]
-				       .tuple.dst.protonum);
+	l4proto = __nf_ct_l4proto_find(nf_ct_l3num(ct), nf_ct_protonum(ct));
 	NF_CT_ASSERT(l4proto);
 
 	if (seq_printf(s, "%-8s %u %ld ",
-		      l4proto->name,
-		      ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.dst.protonum,
+		      l4proto->name, nf_ct_protonum(ct),
 		      timer_pending(&ct->timeout)
 		      ? (long)(ct->timeout.expires - jiffies)/HZ : 0) != 0)
 		return -ENOSPC;
diff --git a/net/netfilter/nf_conntrack_amanda.c b/net/netfilter/nf_conntrack_amanda.c
index ddfac99..38aedee 100644
--- a/net/netfilter/nf_conntrack_amanda.c
+++ b/net/netfilter/nf_conntrack_amanda.c
@@ -91,7 +91,6 @@ static int amanda_help(struct sk_buff *skb,
 	char pbuf[sizeof("65535")], *tmp;
 	u_int16_t len;
 	__be16 port;
-	int family = ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.l3num;
 	int ret = NF_ACCEPT;
 	typeof(nf_nat_amanda_hook) nf_nat_amanda;
 
@@ -148,7 +147,8 @@ static int amanda_help(struct sk_buff *skb,
 			goto out;
 		}
 		tuple = &ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple;
-		nf_ct_expect_init(exp, NF_CT_EXPECT_CLASS_DEFAULT, family,
+		nf_ct_expect_init(exp, NF_CT_EXPECT_CLASS_DEFAULT,
+				  nf_ct_l3num(ct),
 				  &tuple->src.u3, &tuple->dst.u3,
 				  IPPROTO_TCP, NULL, &port);
 
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index b77eb56..21ab0c3 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -194,8 +194,7 @@ destroy_conntrack(struct nf_conntrack *nfct)
 	 * destroy_conntrack() MUST NOT be called with a write lock
 	 * to nf_conntrack_lock!!! -HW */
 	rcu_read_lock();
-	l4proto = __nf_ct_l4proto_find(ct->tuplehash[IP_CT_DIR_REPLY].tuple.src.l3num,
-				       ct->tuplehash[IP_CT_DIR_REPLY].tuple.dst.protonum);
+	l4proto = __nf_ct_l4proto_find(nf_ct_l3num(ct), nf_ct_protonum(ct));
 	if (l4proto && l4proto->destroy)
 		l4proto->destroy(ct);
 
diff --git a/net/netfilter/nf_conntrack_ftp.c b/net/netfilter/nf_conntrack_ftp.c
index 87ca39b..bb20672 100644
--- a/net/netfilter/nf_conntrack_ftp.c
+++ b/net/netfilter/nf_conntrack_ftp.c
@@ -406,7 +406,7 @@ static int help(struct sk_buff *skb,
 
 	/* Initialize IP/IPv6 addr to expected address (it's not mentioned
 	   in EPSV responses) */
-	cmd.l3num = ct->tuplehash[dir].tuple.src.l3num;
+	cmd.l3num = nf_ct_l3num(ct);
 	memcpy(cmd.u3.all, &ct->tuplehash[dir].tuple.src.u3.all,
 	       sizeof(cmd.u3.all));
 
@@ -453,7 +453,7 @@ static int help(struct sk_buff *skb,
 	daddr = &ct->tuplehash[!dir].tuple.dst.u3;
 
 	/* Update the ftp info */
-	if ((cmd.l3num == ct->tuplehash[dir].tuple.src.l3num) &&
+	if ((cmd.l3num == nf_ct_l3num(ct)) &&
 	    memcmp(&cmd.u3.all, &ct->tuplehash[dir].tuple.src.u3.all,
 		     sizeof(cmd.u3.all))) {
 		/* Enrico Scholz's passive FTP to partially RNAT'd ftp
diff --git a/net/netfilter/nf_conntrack_h323_main.c b/net/netfilter/nf_conntrack_h323_main.c
index 505052d..c3f8709 100644
--- a/net/netfilter/nf_conntrack_h323_main.c
+++ b/net/netfilter/nf_conntrack_h323_main.c
@@ -218,7 +218,6 @@ static int get_h245_addr(struct nf_conn *ct, const unsigned char *data,
 			 union nf_inet_addr *addr, __be16 *port)
 {
 	const unsigned char *p;
-	int family = ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.l3num;
 	int len;
 
 	if (taddr->choice != eH245_TransportAddress_unicastAddress)
@@ -226,13 +225,13 @@ static int get_h245_addr(struct nf_conn *ct, const unsigned char *data,
 
 	switch (taddr->unicastAddress.choice) {
 	case eUnicastAddress_iPAddress:
-		if (family != AF_INET)
+		if (nf_ct_l3num(ct) != AF_INET)
 			return 0;
 		p = data + taddr->unicastAddress.iPAddress.network;
 		len = 4;
 		break;
 	case eUnicastAddress_iP6Address:
-		if (family != AF_INET6)
+		if (nf_ct_l3num(ct) != AF_INET6)
 			return 0;
 		p = data + taddr->unicastAddress.iP6Address.network;
 		len = 16;
@@ -277,8 +276,7 @@ static int expect_rtp_rtcp(struct sk_buff *skb, struct nf_conn *ct,
 	/* Create expect for RTP */
 	if ((rtp_exp = nf_ct_expect_alloc(ct)) == NULL)
 		return -1;
-	nf_ct_expect_init(rtp_exp, NF_CT_EXPECT_CLASS_DEFAULT,
-			  ct->tuplehash[!dir].tuple.src.l3num,
+	nf_ct_expect_init(rtp_exp, NF_CT_EXPECT_CLASS_DEFAULT, nf_ct_l3num(ct),
 			  &ct->tuplehash[!dir].tuple.src.u3,
 			  &ct->tuplehash[!dir].tuple.dst.u3,
 			  IPPROTO_UDP, NULL, &rtp_port);
@@ -288,8 +286,7 @@ static int expect_rtp_rtcp(struct sk_buff *skb, struct nf_conn *ct,
 		nf_ct_expect_put(rtp_exp);
 		return -1;
 	}
-	nf_ct_expect_init(rtcp_exp, NF_CT_EXPECT_CLASS_DEFAULT,
-			  ct->tuplehash[!dir].tuple.src.l3num,
+	nf_ct_expect_init(rtcp_exp, NF_CT_EXPECT_CLASS_DEFAULT, nf_ct_l3num(ct),
 			  &ct->tuplehash[!dir].tuple.src.u3,
 			  &ct->tuplehash[!dir].tuple.dst.u3,
 			  IPPROTO_UDP, NULL, &rtcp_port);
@@ -346,8 +343,7 @@ static int expect_t120(struct sk_buff *skb,
 	/* Create expect for T.120 connections */
 	if ((exp = nf_ct_expect_alloc(ct)) == NULL)
 		return -1;
-	nf_ct_expect_init(exp, NF_CT_EXPECT_CLASS_DEFAULT,
-			  ct->tuplehash[!dir].tuple.src.l3num,
+	nf_ct_expect_init(exp, NF_CT_EXPECT_CLASS_DEFAULT, nf_ct_l3num(ct),
 			  &ct->tuplehash[!dir].tuple.src.u3,
 			  &ct->tuplehash[!dir].tuple.dst.u3,
 			  IPPROTO_TCP, NULL, &port);
@@ -634,18 +630,17 @@ int get_h225_addr(struct nf_conn *ct, unsigned char *data,
 		  union nf_inet_addr *addr, __be16 *port)
 {
 	const unsigned char *p;
-	int family = ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.l3num;
 	int len;
 
 	switch (taddr->choice) {
 	case eTransportAddress_ipAddress:
-		if (family != AF_INET)
+		if (nf_ct_l3num(ct) != AF_INET)
 			return 0;
 		p = data + taddr->ipAddress.ip;
 		len = 4;
 		break;
 	case eTransportAddress_ip6Address:
-		if (family != AF_INET6)
+		if (nf_ct_l3num(ct) != AF_INET6)
 			return 0;
 		p = data + taddr->ip6Address.ip;
 		len = 16;
@@ -683,8 +678,7 @@ static int expect_h245(struct sk_buff *skb, struct nf_conn *ct,
 	/* Create expect for h245 connection */
 	if ((exp = nf_ct_expect_alloc(ct)) == NULL)
 		return -1;
-	nf_ct_expect_init(exp, NF_CT_EXPECT_CLASS_DEFAULT,
-			  ct->tuplehash[!dir].tuple.src.l3num,
+	nf_ct_expect_init(exp, NF_CT_EXPECT_CLASS_DEFAULT, nf_ct_l3num(ct),
 			  &ct->tuplehash[!dir].tuple.src.u3,
 			  &ct->tuplehash[!dir].tuple.dst.u3,
 			  IPPROTO_TCP, NULL, &port);
@@ -792,7 +786,7 @@ static int expect_callforwarding(struct sk_buff *skb,
 	 * we don't need to track the second call */
 	if (callforward_filter &&
 	    callforward_do_filter(&addr, &ct->tuplehash[!dir].tuple.src.u3,
-				  ct->tuplehash[!dir].tuple.src.l3num)) {
+				  nf_ct_l3num(ct))) {
 		pr_debug("nf_ct_q931: Call Forwarding not tracked\n");
 		return 0;
 	}
@@ -800,8 +794,7 @@ static int expect_callforwarding(struct sk_buff *skb,
 	/* Create expect for the second call leg */
 	if ((exp = nf_ct_expect_alloc(ct)) == NULL)
 		return -1;
-	nf_ct_expect_init(exp, NF_CT_EXPECT_CLASS_DEFAULT,
-			  ct->tuplehash[!dir].tuple.src.l3num,
+	nf_ct_expect_init(exp, NF_CT_EXPECT_CLASS_DEFAULT, nf_ct_l3num(ct),
 			  &ct->tuplehash[!dir].tuple.src.u3, &addr,
 			  IPPROTO_TCP, NULL, &port);
 	exp->helper = nf_conntrack_helper_q931;
@@ -1272,8 +1265,7 @@ static int expect_q931(struct sk_buff *skb, struct nf_conn *ct,
 	/* Create expect for Q.931 */
 	if ((exp = nf_ct_expect_alloc(ct)) == NULL)
 		return -1;
-	nf_ct_expect_init(exp, NF_CT_EXPECT_CLASS_DEFAULT,
-			  ct->tuplehash[!dir].tuple.src.l3num,
+	nf_ct_expect_init(exp, NF_CT_EXPECT_CLASS_DEFAULT, nf_ct_l3num(ct),
 			  gkrouted_only ? /* only accept calls from GK? */
 				&ct->tuplehash[!dir].tuple.src.u3 : NULL,
 			  &ct->tuplehash[!dir].tuple.dst.u3,
@@ -1344,8 +1336,7 @@ static int process_gcf(struct sk_buff *skb, struct nf_conn *ct,
 	/* Need new expect */
 	if ((exp = nf_ct_expect_alloc(ct)) == NULL)
 		return -1;
-	nf_ct_expect_init(exp, NF_CT_EXPECT_CLASS_DEFAULT,
-			  ct->tuplehash[!dir].tuple.src.l3num,
+	nf_ct_expect_init(exp, NF_CT_EXPECT_CLASS_DEFAULT, nf_ct_l3num(ct),
 			  &ct->tuplehash[!dir].tuple.src.u3, &addr,
 			  IPPROTO_UDP, NULL, &port);
 	exp->helper = nf_conntrack_helper_ras;
@@ -1549,8 +1540,7 @@ static int process_acf(struct sk_buff *skb, struct nf_conn *ct,
 	/* Need new expect */
 	if ((exp = nf_ct_expect_alloc(ct)) == NULL)
 		return -1;
-	nf_ct_expect_init(exp, NF_CT_EXPECT_CLASS_DEFAULT,
-			  ct->tuplehash[!dir].tuple.src.l3num,
+	nf_ct_expect_init(exp, NF_CT_EXPECT_CLASS_DEFAULT, nf_ct_l3num(ct),
 			  &ct->tuplehash[!dir].tuple.src.u3, &addr,
 			  IPPROTO_TCP, NULL, &port);
 	exp->flags = NF_CT_EXPECT_PERMANENT;
@@ -1603,8 +1593,7 @@ static int process_lcf(struct sk_buff *skb, struct nf_conn *ct,
 	/* Need new expect for call signal */
 	if ((exp = nf_ct_expect_alloc(ct)) == NULL)
 		return -1;
-	nf_ct_expect_init(exp, NF_CT_EXPECT_CLASS_DEFAULT,
-			  ct->tuplehash[!dir].tuple.src.l3num,
+	nf_ct_expect_init(exp, NF_CT_EXPECT_CLASS_DEFAULT, nf_ct_l3num(ct),
 			  &ct->tuplehash[!dir].tuple.src.u3, &addr,
 			  IPPROTO_TCP, NULL, &port);
 	exp->flags = NF_CT_EXPECT_PERMANENT;
diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 79d5ecd..16774ec 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -145,10 +145,11 @@ nla_put_failure:
 static inline int
 ctnetlink_dump_protoinfo(struct sk_buff *skb, const struct nf_conn *ct)
 {
-	struct nf_conntrack_l4proto *l4proto = nf_ct_l4proto_find_get(ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.l3num, ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.dst.protonum);
+	struct nf_conntrack_l4proto *l4proto;
 	struct nlattr *nest_proto;
 	int ret;
 
+	l4proto = nf_ct_l4proto_find_get(nf_ct_l3num(ct), nf_ct_protonum(ct));
 	if (!l4proto->to_nlattr) {
 		nf_ct_l4proto_put(l4proto);
 		return 0;
@@ -368,8 +369,7 @@ ctnetlink_fill_info(struct sk_buff *skb, u32 pid, u32 seq,
 	nfmsg  = NLMSG_DATA(nlh);
 
 	nlh->nlmsg_flags    = (nowait && pid) ? NLM_F_MULTI : 0;
-	nfmsg->nfgen_family =
-		ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.l3num;
+	nfmsg->nfgen_family = nf_ct_l3num(ct);
 	nfmsg->version      = NFNETLINK_V0;
 	nfmsg->res_id	    = 0;
 
@@ -454,7 +454,7 @@ static int ctnetlink_conntrack_event(struct notifier_block *this,
 	nfmsg = NLMSG_DATA(nlh);
 
 	nlh->nlmsg_flags    = flags;
-	nfmsg->nfgen_family = ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.l3num;
+	nfmsg->nfgen_family = nf_ct_l3num(ct);
 	nfmsg->version	= NFNETLINK_V0;
 	nfmsg->res_id	= 0;
 
@@ -535,8 +535,6 @@ static int ctnetlink_done(struct netlink_callback *cb)
 	return 0;
 }
 
-#define L3PROTO(ct) (ct)->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.l3num
-
 static int
 ctnetlink_dump_table(struct sk_buff *skb, struct netlink_callback *cb)
 {
@@ -558,7 +556,7 @@ restart:
 			/* Dump entries of a given L3 protocol number.
 			 * If it is not specified, ie. l3proto == 0,
 			 * then dump everything. */
-			if (l3proto && L3PROTO(ct) != l3proto)
+			if (l3proto && nf_ct_l3num(ct) != l3proto)
 				continue;
 			if (cb->args[1]) {
 				if (ct != last)
@@ -704,7 +702,7 @@ static int nfnetlink_parse_nat_proto(struct nlattr *attr,
 	if (err < 0)
 		return err;
 
-	npt = nf_nat_proto_find_get(ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.dst.protonum);
+	npt = nf_nat_proto_find_get(nf_ct_protonum(ct));
 	if (npt->nlattr_to_range)
 		err = npt->nlattr_to_range(tb, range);
 	nf_nat_proto_put(npt);
@@ -1001,14 +999,11 @@ ctnetlink_change_protoinfo(struct nf_conn *ct, struct nlattr *cda[])
 {
 	struct nlattr *tb[CTA_PROTOINFO_MAX+1], *attr = cda[CTA_PROTOINFO];
 	struct nf_conntrack_l4proto *l4proto;
-	u_int16_t npt = ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.dst.protonum;
-	u_int16_t l3num = ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.l3num;
 	int err = 0;
 
 	nla_parse_nested(tb, CTA_PROTOINFO_MAX, attr, NULL);
 
-	l4proto = nf_ct_l4proto_find_get(l3num, npt);
-
+	l4proto = nf_ct_l4proto_find_get(nf_ct_l3num(ct), nf_ct_protonum(ct));
 	if (l4proto->from_nlattr)
 		err = l4proto->from_nlattr(tb, ct);
 	nf_ct_l4proto_put(l4proto);
diff --git a/net/netfilter/nf_conntrack_pptp.c b/net/netfilter/nf_conntrack_pptp.c
index 8fd8347..4793cc0 100644
--- a/net/netfilter/nf_conntrack_pptp.c
+++ b/net/netfilter/nf_conntrack_pptp.c
@@ -209,7 +209,7 @@ static int exp_gre(struct nf_conn *ct, __be16 callid, __be16 peer_callid)
 	/* original direction, PNS->PAC */
 	dir = IP_CT_DIR_ORIGINAL;
 	nf_ct_expect_init(exp_orig, NF_CT_EXPECT_CLASS_DEFAULT,
-			  ct->tuplehash[dir].tuple.src.l3num,
+			  nf_ct_l3num(ct),
 			  &ct->tuplehash[dir].tuple.src.u3,
 			  &ct->tuplehash[dir].tuple.dst.u3,
 			  IPPROTO_GRE, &peer_callid, &callid);
@@ -218,7 +218,7 @@ static int exp_gre(struct nf_conn *ct, __be16 callid, __be16 peer_callid)
 	/* reply direction, PAC->PNS */
 	dir = IP_CT_DIR_REPLY;
 	nf_ct_expect_init(exp_reply, NF_CT_EXPECT_CLASS_DEFAULT,
-			  ct->tuplehash[dir].tuple.src.l3num,
+			  nf_ct_l3num(ct),
 			  &ct->tuplehash[dir].tuple.src.u3,
 			  &ct->tuplehash[dir].tuple.dst.u3,
 			  IPPROTO_GRE, &callid, &peer_callid);
diff --git a/net/netfilter/nf_conntrack_proto.c b/net/netfilter/nf_conntrack_proto.c
index 8595b59..a49fc93 100644
--- a/net/netfilter/nf_conntrack_proto.c
+++ b/net/netfilter/nf_conntrack_proto.c
@@ -146,18 +146,15 @@ EXPORT_SYMBOL_GPL(nf_ct_l3proto_module_put);
 
 static int kill_l3proto(struct nf_conn *i, void *data)
 {
-	return (i->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.l3num ==
-			((struct nf_conntrack_l3proto *)data)->l3proto);
+	return nf_ct_l3num(i) == ((struct nf_conntrack_l3proto *)data)->l3proto;
 }
 
 static int kill_l4proto(struct nf_conn *i, void *data)
 {
 	struct nf_conntrack_l4proto *l4proto;
 	l4proto = (struct nf_conntrack_l4proto *)data;
-	return (i->tuplehash[IP_CT_DIR_ORIGINAL].tuple.dst.protonum ==
-			l4proto->l4proto) &&
-	       (i->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.l3num ==
-			l4proto->l3proto);
+	return nf_ct_protonum(i) == l4proto->l4proto &&
+	       nf_ct_l3num(i) == l4proto->l3proto;
 }
 
 static int nf_ct_l3proto_register_sysctl(struct nf_conntrack_l3proto *l3proto)
diff --git a/net/netfilter/nf_conntrack_proto_dccp.c b/net/netfilter/nf_conntrack_proto_dccp.c
index db88c5b..9376dcd 100644
--- a/net/netfilter/nf_conntrack_proto_dccp.c
+++ b/net/netfilter/nf_conntrack_proto_dccp.c
@@ -418,7 +418,6 @@ static int dccp_invert_tuple(struct nf_conntrack_tuple *inv,
 static int dccp_new(struct nf_conn *ct, const struct sk_buff *skb,
 		    unsigned int dataoff)
 {
-	int pf = ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.l3num;
 	struct dccp_hdr _dh, *dh;
 	const char *msg;
 	u_int8_t state;
@@ -447,7 +446,7 @@ static int dccp_new(struct nf_conn *ct, const struct sk_buff *skb,
 
 out_invalid:
 	if (LOG_INVALID(IPPROTO_DCCP))
-		nf_log_packet(pf, 0, skb, NULL, NULL, NULL, msg);
+		nf_log_packet(nf_ct_l3num(ct), 0, skb, NULL, NULL, NULL, msg);
 	return 0;
 }
 
diff --git a/net/netfilter/nf_conntrack_sane.c b/net/netfilter/nf_conntrack_sane.c
index 7542e25..c3d5e84 100644
--- a/net/netfilter/nf_conntrack_sane.c
+++ b/net/netfilter/nf_conntrack_sane.c
@@ -72,7 +72,6 @@ static int help(struct sk_buff *skb,
 	struct nf_conntrack_tuple *tuple;
 	struct sane_request *req;
 	struct sane_reply_net_start *reply;
-	int family = ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.l3num;
 
 	ct_sane_info = &nfct_help(ct)->help.ct_sane_info;
 	/* Until there's been traffic both ways, don't look in packets. */
@@ -143,7 +142,7 @@ static int help(struct sk_buff *skb,
 	}
 
 	tuple = &ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple;
-	nf_ct_expect_init(exp, NF_CT_EXPECT_CLASS_DEFAULT, family,
+	nf_ct_expect_init(exp, NF_CT_EXPECT_CLASS_DEFAULT, nf_ct_l3num(ct),
 			  &tuple->src.u3, &tuple->dst.u3,
 			  IPPROTO_TCP, NULL, &reply->port);
 
diff --git a/net/netfilter/nf_conntrack_sip.c b/net/netfilter/nf_conntrack_sip.c
index f3915f8..65b3ba5 100644
--- a/net/netfilter/nf_conntrack_sip.c
+++ b/net/netfilter/nf_conntrack_sip.c
@@ -142,11 +142,10 @@ static int parse_addr(const struct nf_conn *ct, const char *cp,
                       const char *limit)
 {
 	const char *end;
-	int family = ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.l3num;
 	int ret = 0;
 
 	memset(addr, 0, sizeof(*addr));
-	switch (family) {
+	switch (nf_ct_l3num(ct)) {
 	case AF_INET:
 		ret = in4_pton(cp, limit - cp, (u8 *)&addr->ip, -1, &end);
 		break;
@@ -740,7 +739,6 @@ static int set_expected_rtp_rtcp(struct sk_buff *skb,
 	enum ip_conntrack_dir dir = CTINFO2DIR(ctinfo);
 	union nf_inet_addr *saddr;
 	struct nf_conntrack_tuple tuple;
-	int family = ct->tuplehash[!dir].tuple.src.l3num;
 	int direct_rtp = 0, skip_expect = 0, ret = NF_DROP;
 	u_int16_t base_port;
 	__be16 rtp_port, rtcp_port;
@@ -770,7 +768,7 @@ static int set_expected_rtp_rtcp(struct sk_buff *skb,
 	memset(&tuple, 0, sizeof(tuple));
 	if (saddr)
 		tuple.src.u3 = *saddr;
-	tuple.src.l3num		= family;
+	tuple.src.l3num		= nf_ct_l3num(ct);
 	tuple.dst.protonum	= IPPROTO_UDP;
 	tuple.dst.u3		= *daddr;
 	tuple.dst.u.udp.port	= port;
@@ -815,13 +813,13 @@ static int set_expected_rtp_rtcp(struct sk_buff *skb,
 	rtp_exp = nf_ct_expect_alloc(ct);
 	if (rtp_exp == NULL)
 		goto err1;
-	nf_ct_expect_init(rtp_exp, class, family, saddr, daddr,
+	nf_ct_expect_init(rtp_exp, class, nf_ct_l3num(ct), saddr, daddr,
 			  IPPROTO_UDP, NULL, &rtp_port);
 
 	rtcp_exp = nf_ct_expect_alloc(ct);
 	if (rtcp_exp == NULL)
 		goto err2;
-	nf_ct_expect_init(rtcp_exp, class, family, saddr, daddr,
+	nf_ct_expect_init(rtcp_exp, class, nf_ct_l3num(ct), saddr, daddr,
 			  IPPROTO_UDP, NULL, &rtcp_port);
 
 	nf_nat_sdp_media = rcu_dereference(nf_nat_sdp_media_hook);
@@ -871,7 +869,6 @@ static int process_sdp(struct sk_buff *skb,
 {
 	enum ip_conntrack_info ctinfo;
 	struct nf_conn *ct = nf_ct_get(skb, &ctinfo);
-	int family = ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.l3num;
 	unsigned int matchoff, matchlen;
 	unsigned int mediaoff, medialen;
 	unsigned int sdpoff;
@@ -886,8 +883,8 @@ static int process_sdp(struct sk_buff *skb,
 	typeof(nf_nat_sdp_session_hook) nf_nat_sdp_session;
 
 	nf_nat_sdp_addr = rcu_dereference(nf_nat_sdp_addr_hook);
-	c_hdr = family == AF_INET ? SDP_HDR_CONNECTION_IP4 :
-				    SDP_HDR_CONNECTION_IP6;
+	c_hdr = nf_ct_l3num(ct) == AF_INET ? SDP_HDR_CONNECTION_IP4 :
+					     SDP_HDR_CONNECTION_IP6;
 
 	/* Find beginning of session description */
 	if (ct_sip_get_sdp_header(ct, *dptr, 0, *datalen,
@@ -1034,7 +1031,6 @@ static int process_register_request(struct sk_buff *skb,
 	struct nf_conn *ct = nf_ct_get(skb, &ctinfo);
 	struct nf_conn_help *help = nfct_help(ct);
 	enum ip_conntrack_dir dir = CTINFO2DIR(ctinfo);
-	int family = ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.l3num;
 	unsigned int matchoff, matchlen;
 	struct nf_conntrack_expect *exp;
 	union nf_inet_addr *saddr, daddr;
@@ -1089,8 +1085,8 @@ static int process_register_request(struct sk_buff *skb,
 	if (sip_direct_signalling)
 		saddr = &ct->tuplehash[!dir].tuple.src.u3;
 
-	nf_ct_expect_init(exp, SIP_EXPECT_SIGNALLING, family, saddr, &daddr,
-			  IPPROTO_UDP, NULL, &port);
+	nf_ct_expect_init(exp, SIP_EXPECT_SIGNALLING, nf_ct_l3num(ct),
+			  saddr, &daddr, IPPROTO_UDP, NULL, &port);
 	exp->timeout.expires = sip_timeout * HZ;
 	exp->helper = nfct_help(ct)->helper;
 	exp->flags = NF_CT_EXPECT_PERMANENT | NF_CT_EXPECT_INACTIVE;
diff --git a/net/netfilter/nf_conntrack_standalone.c b/net/netfilter/nf_conntrack_standalone.c
index 01d1f7e..b59871f 100644
--- a/net/netfilter/nf_conntrack_standalone.c
+++ b/net/netfilter/nf_conntrack_standalone.c
@@ -127,21 +127,14 @@ static int ct_seq_show(struct seq_file *s, void *v)
 	if (NF_CT_DIRECTION(hash))
 		return 0;
 
-	l3proto = __nf_ct_l3proto_find(ct->tuplehash[IP_CT_DIR_ORIGINAL]
-				       .tuple.src.l3num);
-
+	l3proto = __nf_ct_l3proto_find(nf_ct_l3num(ct));
 	NF_CT_ASSERT(l3proto);
-	l4proto = __nf_ct_l4proto_find(ct->tuplehash[IP_CT_DIR_ORIGINAL]
-				   .tuple.src.l3num,
-				   ct->tuplehash[IP_CT_DIR_ORIGINAL]
-				   .tuple.dst.protonum);
+	l4proto = __nf_ct_l4proto_find(nf_ct_l3num(ct), nf_ct_protonum(ct));
 	NF_CT_ASSERT(l4proto);
 
 	if (seq_printf(s, "%-8s %u %-8s %u %ld ",
-		       l3proto->name,
-		       ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.l3num,
-		       l4proto->name,
-		       ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.dst.protonum,
+		       l3proto->name, nf_ct_l3num(ct),
+		       l4proto->name, nf_ct_protonum(ct),
 		       timer_pending(&ct->timeout)
 		       ? (long)(ct->timeout.expires - jiffies)/HZ : 0) != 0)
 		return -ENOSPC;
diff --git a/net/netfilter/nf_conntrack_tftp.c b/net/netfilter/nf_conntrack_tftp.c
index a28341b..ea5ff49 100644
--- a/net/netfilter/nf_conntrack_tftp.c
+++ b/net/netfilter/nf_conntrack_tftp.c
@@ -44,7 +44,6 @@ static int tftp_help(struct sk_buff *skb,
 	struct nf_conntrack_expect *exp;
 	struct nf_conntrack_tuple *tuple;
 	unsigned int ret = NF_ACCEPT;
-	int family = ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.l3num;
 	typeof(nf_nat_tftp_hook) nf_nat_tftp;
 
 	tfh = skb_header_pointer(skb, protoff + sizeof(struct udphdr),
@@ -63,7 +62,8 @@ static int tftp_help(struct sk_buff *skb,
 		if (exp == NULL)
 			return NF_DROP;
 		tuple = &ct->tuplehash[IP_CT_DIR_REPLY].tuple;
-		nf_ct_expect_init(exp, NF_CT_EXPECT_CLASS_DEFAULT, family,
+		nf_ct_expect_init(exp, NF_CT_EXPECT_CLASS_DEFAULT,
+				  nf_ct_l3num(ct),
 				  &tuple->src.u3, &tuple->dst.u3,
 				  IPPROTO_UDP, NULL, &tuple->dst.u.udp.port);
 
diff --git a/net/netfilter/xt_connlimit.c b/net/netfilter/xt_connlimit.c
index 0ca9fe9..2e89a00 100644
--- a/net/netfilter/xt_connlimit.c
+++ b/net/netfilter/xt_connlimit.c
@@ -72,9 +72,7 @@ connlimit_iphash6(const union nf_inet_addr *addr,
 
 static inline bool already_closed(const struct nf_conn *conn)
 {
-	u_int16_t proto = conn->tuplehash[0].tuple.dst.protonum;
-
-	if (proto == IPPROTO_TCP)
+	if (nf_ct_protonum(conn) == IPPROTO_TCP)
 		return conn->proto.tcp.state == TCP_CONNTRACK_TIME_WAIT;
 	else
 		return 0;
diff --git a/net/netfilter/xt_conntrack.c b/net/netfilter/xt_conntrack.c
index 0c50b28..d61412f 100644
--- a/net/netfilter/xt_conntrack.c
+++ b/net/netfilter/xt_conntrack.c
@@ -65,7 +65,7 @@ conntrack_mt_v0(const struct sk_buff *skb, const struct net_device *in,
 	}
 
 	if (sinfo->flags & XT_CONNTRACK_PROTO &&
-	    FWINV(ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.dst.protonum !=
+	    FWINV(nf_ct_protonum(ct) !=
 		  sinfo->tuple[IP_CT_DIR_ORIGINAL].dst.protonum,
 		  XT_CONNTRACK_PROTO))
 		return false;
@@ -174,7 +174,7 @@ ct_proto_port_check(const struct xt_conntrack_mtinfo1 *info,
 
 	tuple = &ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple;
 	if ((info->match_flags & XT_CONNTRACK_PROTO) &&
-	    (tuple->dst.protonum == info->l4proto) ^
+	    (nf_ct_protonum(ct) == info->l4proto) ^
 	    !(info->invert_flags & XT_CONNTRACK_PROTO))
 		return false;
 
