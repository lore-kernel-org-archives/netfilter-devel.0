From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 58/64]: Introduce nf_inet_address
Date: Tue, 18 Dec 2007 00:47:32 +0100 (MET)
Message-ID: <20071217234731.23601.91421.sendpatchset@localhost.localdomain>
References: <20071217234612.23601.6979.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:39055 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933172AbXLQXrd (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 17 Dec 2007 18:47:33 -0500
In-Reply-To: <20071217234612.23601.6979.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[NETFILTER]: Introduce nf_inet_address

A few netfilter modules provide their own union of IPv4 and IPv6
address storage. Will unify that in this patch series.

(1/4): Rename union nf_conntrack_address to union nf_inet_addr and
move it to x_tables.h.

Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 3cecb3726340f00f0c6e08804fff5b552fe9feef
tree dc96e7cb0fa58e84b1bc19e43689091ae5eac1fb
parent 92c790e129d05df719f233ac8f4e45d736304b23
author Jan Engelhardt <jengelh@computergmbh.de> Mon, 17 Dec 2007 14:58:52 +0100
committer Patrick McHardy <kaber@trash.net> Tue, 18 Dec 2007 00:25:00 +0100

 include/linux/netfilter.h                   |    6 +++++
 include/linux/netfilter/nf_conntrack_h323.h |    6 ++---
 include/net/netfilter/nf_conntrack_expect.h |    4 ++-
 include/net/netfilter/nf_conntrack_tuple.h  |   17 ++++----------
 net/ipv4/netfilter/nf_nat_h323.c            |   10 ++++----
 net/netfilter/nf_conntrack_expect.c         |    4 ++-
 net/netfilter/nf_conntrack_ftp.c            |    2 +-
 net/netfilter/nf_conntrack_h323_main.c      |   34 ++++++++++++++-------------
 net/netfilter/nf_conntrack_sip.c            |    8 +++---
 net/netfilter/xt_connlimit.c                |   20 ++++++++--------
 10 files changed, 55 insertions(+), 56 deletions(-)

diff --git a/include/linux/netfilter.h b/include/linux/netfilter.h
index 1a84873..d190d56 100644
--- a/include/linux/netfilter.h
+++ b/include/linux/netfilter.h
@@ -48,6 +48,12 @@ enum nf_inet_hooks {
 	NF_INET_NUMHOOKS
 };
 
+union nf_inet_addr {
+	u_int32_t	all[4];
+	__be32		ip;
+	__be32		ip6[4];
+};
+
 #ifdef __KERNEL__
 #ifdef CONFIG_NETFILTER
 
diff --git a/include/linux/netfilter/nf_conntrack_h323.h b/include/linux/netfilter/nf_conntrack_h323.h
index aabd24a..26f9226 100644
--- a/include/linux/netfilter/nf_conntrack_h323.h
+++ b/include/linux/netfilter/nf_conntrack_h323.h
@@ -31,7 +31,7 @@ struct nf_conn;
 
 extern int get_h225_addr(struct nf_conn *ct, unsigned char *data,
 			 TransportAddress *taddr,
-			 union nf_conntrack_address *addr, __be16 *port);
+			 union nf_inet_addr *addr, __be16 *port);
 extern void nf_conntrack_h245_expect(struct nf_conn *new,
 				     struct nf_conntrack_expect *this);
 extern void nf_conntrack_q931_expect(struct nf_conn *new,
@@ -39,12 +39,12 @@ extern void nf_conntrack_q931_expect(struct nf_conn *new,
 extern int (*set_h245_addr_hook) (struct sk_buff *skb,
 				  unsigned char **data, int dataoff,
 				  H245_TransportAddress *taddr,
-				  union nf_conntrack_address *addr,
+				  union nf_inet_addr *addr,
 				  __be16 port);
 extern int (*set_h225_addr_hook) (struct sk_buff *skb,
 				  unsigned char **data, int dataoff,
 				  TransportAddress *taddr,
-				  union nf_conntrack_address *addr,
+				  union nf_inet_addr *addr,
 				  __be16 port);
 extern int (*set_sig_addr_hook) (struct sk_buff *skb,
 				 struct nf_conn *ct,
diff --git a/include/net/netfilter/nf_conntrack_expect.h b/include/net/netfilter/nf_conntrack_expect.h
index b47c04f..6c3fd25 100644
--- a/include/net/netfilter/nf_conntrack_expect.h
+++ b/include/net/netfilter/nf_conntrack_expect.h
@@ -73,8 +73,8 @@ void nf_ct_unexpect_related(struct nf_conntrack_expect *exp);
    nf_ct_expect_related.  You will have to call put afterwards. */
 struct nf_conntrack_expect *nf_ct_expect_alloc(struct nf_conn *me);
 void nf_ct_expect_init(struct nf_conntrack_expect *, int,
-		       union nf_conntrack_address *,
-		       union nf_conntrack_address *,
+		       union nf_inet_addr *,
+		       union nf_inet_addr *,
 		       u_int8_t, __be16 *, __be16 *);
 void nf_ct_expect_put(struct nf_conntrack_expect *exp);
 int nf_ct_expect_related(struct nf_conntrack_expect *expect);
diff --git a/include/net/netfilter/nf_conntrack_tuple.h b/include/net/netfilter/nf_conntrack_tuple.h
index c48e390..45cb17c 100644
--- a/include/net/netfilter/nf_conntrack_tuple.h
+++ b/include/net/netfilter/nf_conntrack_tuple.h
@@ -10,6 +10,7 @@
 #ifndef _NF_CONNTRACK_TUPLE_H
 #define _NF_CONNTRACK_TUPLE_H
 
+#include <linux/netfilter/x_tables.h>
 #include <linux/netfilter/nf_conntrack_tuple_common.h>
 
 /* A `tuple' is a structure containing the information to uniquely
@@ -20,15 +21,7 @@
   "non-manipulatable" lines, for the benefit of the NAT code.
 */
 
-#define NF_CT_TUPLE_L3SIZE	4
-
-/* The l3 protocol-specific manipulable parts of the tuple: always in
-   network order! */
-union nf_conntrack_address {
-	u_int32_t all[NF_CT_TUPLE_L3SIZE];
-	__be32 ip;
-	__be32 ip6[4];
-};
+#define NF_CT_TUPLE_L3SIZE	ARRAY_SIZE(((union nf_inet_addr *)NULL)->all)
 
 /* The protocol-specific manipulable parts of the tuple: always in
    network order! */
@@ -57,7 +50,7 @@ union nf_conntrack_man_proto
 /* The manipulable part of the tuple. */
 struct nf_conntrack_man
 {
-	union nf_conntrack_address u3;
+	union nf_inet_addr u3;
 	union nf_conntrack_man_proto u;
 	/* Layer 3 protocol */
 	u_int16_t l3num;
@@ -70,7 +63,7 @@ struct nf_conntrack_tuple
 
 	/* These are the parts of the tuple which are fixed. */
 	struct {
-		union nf_conntrack_address u3;
+		union nf_inet_addr u3;
 		union {
 			/* Add other protocols here. */
 			__be16 all;
@@ -103,7 +96,7 @@ struct nf_conntrack_tuple
 struct nf_conntrack_tuple_mask
 {
 	struct {
-		union nf_conntrack_address u3;
+		union nf_inet_addr u3;
 		union nf_conntrack_man_proto u;
 	} src;
 };
diff --git a/net/ipv4/netfilter/nf_nat_h323.c b/net/ipv4/netfilter/nf_nat_h323.c
index 2e4bdee..a121989 100644
--- a/net/ipv4/netfilter/nf_nat_h323.c
+++ b/net/ipv4/netfilter/nf_nat_h323.c
@@ -76,7 +76,7 @@ static int set_addr(struct sk_buff *skb,
 static int set_h225_addr(struct sk_buff *skb,
 			 unsigned char **data, int dataoff,
 			 TransportAddress *taddr,
-			 union nf_conntrack_address *addr, __be16 port)
+			 union nf_inet_addr *addr, __be16 port)
 {
 	return set_addr(skb, data, dataoff, taddr->ipAddress.ip,
 			addr->ip, port);
@@ -86,7 +86,7 @@ static int set_h225_addr(struct sk_buff *skb,
 static int set_h245_addr(struct sk_buff *skb,
 			 unsigned char **data, int dataoff,
 			 H245_TransportAddress *taddr,
-			 union nf_conntrack_address *addr, __be16 port)
+			 union nf_inet_addr *addr, __be16 port)
 {
 	return set_addr(skb, data, dataoff,
 			taddr->unicastAddress.iPAddress.network,
@@ -103,7 +103,7 @@ static int set_sig_addr(struct sk_buff *skb, struct nf_conn *ct,
 	int dir = CTINFO2DIR(ctinfo);
 	int i;
 	__be16 port;
-	union nf_conntrack_address addr;
+	union nf_inet_addr addr;
 
 	for (i = 0; i < count; i++) {
 		if (get_h225_addr(ct, *data, &taddr[i], &addr, &port)) {
@@ -155,7 +155,7 @@ static int set_ras_addr(struct sk_buff *skb, struct nf_conn *ct,
 	int dir = CTINFO2DIR(ctinfo);
 	int i;
 	__be16 port;
-	union nf_conntrack_address addr;
+	union nf_inet_addr addr;
 
 	for (i = 0; i < count; i++) {
 		if (get_h225_addr(ct, *data, &taddr[i], &addr, &port) &&
@@ -408,7 +408,7 @@ static int nat_q931(struct sk_buff *skb, struct nf_conn *ct,
 	struct nf_ct_h323_master *info = &nfct_help(ct)->help.ct_h323_info;
 	int dir = CTINFO2DIR(ctinfo);
 	u_int16_t nated_port = ntohs(port);
-	union nf_conntrack_address addr;
+	union nf_inet_addr addr;
 
 	/* Set expectations for NAT */
 	exp->saved_proto.tcp.port = exp->tuple.dst.u.tcp.port;
diff --git a/net/netfilter/nf_conntrack_expect.c b/net/netfilter/nf_conntrack_expect.c
index 175c8d1..0efbf34 100644
--- a/net/netfilter/nf_conntrack_expect.c
+++ b/net/netfilter/nf_conntrack_expect.c
@@ -226,8 +226,8 @@ struct nf_conntrack_expect *nf_ct_expect_alloc(struct nf_conn *me)
 EXPORT_SYMBOL_GPL(nf_ct_expect_alloc);
 
 void nf_ct_expect_init(struct nf_conntrack_expect *exp, int family,
-		       union nf_conntrack_address *saddr,
-		       union nf_conntrack_address *daddr,
+		       union nf_inet_addr *saddr,
+		       union nf_inet_addr *daddr,
 		       u_int8_t proto, __be16 *src, __be16 *dst)
 {
 	int len;
diff --git a/net/netfilter/nf_conntrack_ftp.c b/net/netfilter/nf_conntrack_ftp.c
index 6df2590..6770baf 100644
--- a/net/netfilter/nf_conntrack_ftp.c
+++ b/net/netfilter/nf_conntrack_ftp.c
@@ -358,7 +358,7 @@ static int help(struct sk_buff *skb,
 	unsigned int matchlen, matchoff;
 	struct nf_ct_ftp_master *ct_ftp_info = &nfct_help(ct)->help.ct_ftp_info;
 	struct nf_conntrack_expect *exp;
-	union nf_conntrack_address *daddr;
+	union nf_inet_addr *daddr;
 	struct nf_conntrack_man cmd = {};
 	unsigned int i;
 	int found = 0, ends_in_nl;
diff --git a/net/netfilter/nf_conntrack_h323_main.c b/net/netfilter/nf_conntrack_h323_main.c
index b636ca6..872c1aa 100644
--- a/net/netfilter/nf_conntrack_h323_main.c
+++ b/net/netfilter/nf_conntrack_h323_main.c
@@ -50,12 +50,12 @@ MODULE_PARM_DESC(callforward_filter, "only create call forwarding expectations "
 int (*set_h245_addr_hook) (struct sk_buff *skb,
 			   unsigned char **data, int dataoff,
 			   H245_TransportAddress *taddr,
-			   union nf_conntrack_address *addr, __be16 port)
+			   union nf_inet_addr *addr, __be16 port)
 			   __read_mostly;
 int (*set_h225_addr_hook) (struct sk_buff *skb,
 			   unsigned char **data, int dataoff,
 			   TransportAddress *taddr,
-			   union nf_conntrack_address *addr, __be16 port)
+			   union nf_inet_addr *addr, __be16 port)
 			   __read_mostly;
 int (*set_sig_addr_hook) (struct sk_buff *skb,
 			  struct nf_conn *ct,
@@ -214,7 +214,7 @@ static int get_tpkt_data(struct sk_buff *skb, unsigned int protoff,
 /****************************************************************************/
 static int get_h245_addr(struct nf_conn *ct, unsigned char *data,
 			 H245_TransportAddress *taddr,
-			 union nf_conntrack_address *addr, __be16 *port)
+			 union nf_inet_addr *addr, __be16 *port)
 {
 	unsigned char *p;
 	int family = ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.l3num;
@@ -257,7 +257,7 @@ static int expect_rtp_rtcp(struct sk_buff *skb, struct nf_conn *ct,
 	int ret = 0;
 	__be16 port;
 	__be16 rtp_port, rtcp_port;
-	union nf_conntrack_address addr;
+	union nf_inet_addr addr;
 	struct nf_conntrack_expect *rtp_exp;
 	struct nf_conntrack_expect *rtcp_exp;
 	typeof(nat_rtp_rtcp_hook) nat_rtp_rtcp;
@@ -330,7 +330,7 @@ static int expect_t120(struct sk_buff *skb,
 	int dir = CTINFO2DIR(ctinfo);
 	int ret = 0;
 	__be16 port;
-	union nf_conntrack_address addr;
+	union nf_inet_addr addr;
 	struct nf_conntrack_expect *exp;
 	typeof(nat_t120_hook) nat_t120;
 
@@ -623,7 +623,7 @@ static struct nf_conntrack_helper nf_conntrack_helper_h245 __read_mostly = {
 /****************************************************************************/
 int get_h225_addr(struct nf_conn *ct, unsigned char *data,
 		  TransportAddress *taddr,
-		  union nf_conntrack_address *addr, __be16 *port)
+		  union nf_inet_addr *addr, __be16 *port)
 {
 	unsigned char *p;
 	int family = ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.l3num;
@@ -662,7 +662,7 @@ static int expect_h245(struct sk_buff *skb, struct nf_conn *ct,
 	int dir = CTINFO2DIR(ctinfo);
 	int ret = 0;
 	__be16 port;
-	union nf_conntrack_address addr;
+	union nf_inet_addr addr;
 	struct nf_conntrack_expect *exp;
 	typeof(nat_h245_hook) nat_h245;
 
@@ -704,8 +704,8 @@ static int expect_h245(struct sk_buff *skb, struct nf_conn *ct,
 
 /* If the calling party is on the same side of the forward-to party,
  * we don't need to track the second call */
-static int callforward_do_filter(union nf_conntrack_address *src,
-				 union nf_conntrack_address *dst,
+static int callforward_do_filter(union nf_inet_addr *src,
+				 union nf_inet_addr *dst,
 				 int family)
 {
 	const struct nf_afinfo *afinfo;
@@ -772,7 +772,7 @@ static int expect_callforwarding(struct sk_buff *skb,
 	int dir = CTINFO2DIR(ctinfo);
 	int ret = 0;
 	__be16 port;
-	union nf_conntrack_address addr;
+	union nf_inet_addr addr;
 	struct nf_conntrack_expect *exp;
 	typeof(nat_callforwarding_hook) nat_callforwarding;
 
@@ -828,7 +828,7 @@ static int process_setup(struct sk_buff *skb, struct nf_conn *ct,
 	int ret;
 	int i;
 	__be16 port;
-	union nf_conntrack_address addr;
+	union nf_inet_addr addr;
 	typeof(set_h225_addr_hook) set_h225_addr;
 
 	pr_debug("nf_ct_q931: Setup\n");
@@ -1200,7 +1200,7 @@ static unsigned char *get_udp_data(struct sk_buff *skb, unsigned int protoff,
 
 /****************************************************************************/
 static struct nf_conntrack_expect *find_expect(struct nf_conn *ct,
-					       union nf_conntrack_address *addr,
+					       union nf_inet_addr *addr,
 					       __be16 port)
 {
 	struct nf_conntrack_expect *exp;
@@ -1242,7 +1242,7 @@ static int expect_q931(struct sk_buff *skb, struct nf_conn *ct,
 	int ret = 0;
 	int i;
 	__be16 port;
-	union nf_conntrack_address addr;
+	union nf_inet_addr addr;
 	struct nf_conntrack_expect *exp;
 	typeof(nat_q931_hook) nat_q931;
 
@@ -1311,7 +1311,7 @@ static int process_gcf(struct sk_buff *skb, struct nf_conn *ct,
 	int dir = CTINFO2DIR(ctinfo);
 	int ret = 0;
 	__be16 port;
-	union nf_conntrack_address addr;
+	union nf_inet_addr addr;
 	struct nf_conntrack_expect *exp;
 
 	pr_debug("nf_ct_ras: GCF\n");
@@ -1471,7 +1471,7 @@ static int process_arq(struct sk_buff *skb, struct nf_conn *ct,
 	struct nf_ct_h323_master *info = &nfct_help(ct)->help.ct_h323_info;
 	int dir = CTINFO2DIR(ctinfo);
 	__be16 port;
-	union nf_conntrack_address addr;
+	union nf_inet_addr addr;
 	typeof(set_h225_addr_hook) set_h225_addr;
 
 	pr_debug("nf_ct_ras: ARQ\n");
@@ -1513,7 +1513,7 @@ static int process_acf(struct sk_buff *skb, struct nf_conn *ct,
 	int dir = CTINFO2DIR(ctinfo);
 	int ret = 0;
 	__be16 port;
-	union nf_conntrack_address addr;
+	union nf_inet_addr addr;
 	struct nf_conntrack_expect *exp;
 	typeof(set_sig_addr_hook) set_sig_addr;
 
@@ -1576,7 +1576,7 @@ static int process_lcf(struct sk_buff *skb, struct nf_conn *ct,
 	int dir = CTINFO2DIR(ctinfo);
 	int ret = 0;
 	__be16 port;
-	union nf_conntrack_address addr;
+	union nf_inet_addr addr;
 	struct nf_conntrack_expect *exp;
 
 	pr_debug("nf_ct_ras: LCF\n");
diff --git a/net/netfilter/nf_conntrack_sip.c b/net/netfilter/nf_conntrack_sip.c
index 8f8b5a4..7ee6976 100644
--- a/net/netfilter/nf_conntrack_sip.c
+++ b/net/netfilter/nf_conntrack_sip.c
@@ -247,7 +247,7 @@ static int skp_digits_len(struct nf_conn *ct, const char *dptr,
 }
 
 static int parse_addr(struct nf_conn *ct, const char *cp, const char **endp,
-		      union nf_conntrack_address *addr, const char *limit)
+		      union nf_inet_addr *addr, const char *limit)
 {
 	const char *end;
 	int family = ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.l3num;
@@ -275,7 +275,7 @@ static int parse_addr(struct nf_conn *ct, const char *cp, const char **endp,
 static int epaddr_len(struct nf_conn *ct, const char *dptr,
 		      const char *limit, int *shift)
 {
-	union nf_conntrack_address addr;
+	union nf_inet_addr addr;
 	const char *aux = dptr;
 
 	if (!parse_addr(ct, dptr, &dptr, &addr, limit)) {
@@ -366,7 +366,7 @@ EXPORT_SYMBOL_GPL(ct_sip_get_info);
 static int set_expected_rtp(struct sk_buff *skb,
 			    struct nf_conn *ct,
 			    enum ip_conntrack_info ctinfo,
-			    union nf_conntrack_address *addr,
+			    union nf_inet_addr *addr,
 			    __be16 port,
 			    const char *dptr)
 {
@@ -403,7 +403,7 @@ static int sip_help(struct sk_buff *skb,
 		    enum ip_conntrack_info ctinfo)
 {
 	int family = ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.l3num;
-	union nf_conntrack_address addr;
+	union nf_inet_addr addr;
 	unsigned int dataoff, datalen;
 	const char *dptr;
 	int ret = NF_ACCEPT;
diff --git a/net/netfilter/xt_connlimit.c b/net/netfilter/xt_connlimit.c
index 26d12b0..b7a6846 100644
--- a/net/netfilter/xt_connlimit.c
+++ b/net/netfilter/xt_connlimit.c
@@ -53,10 +53,10 @@ static inline unsigned int connlimit_iphash(__be32 addr)
 }
 
 static inline unsigned int
-connlimit_iphash6(const union nf_conntrack_address *addr,
-                  const union nf_conntrack_address *mask)
+connlimit_iphash6(const union nf_inet_addr *addr,
+                  const union nf_inet_addr *mask)
 {
-	union nf_conntrack_address res;
+	union nf_inet_addr res;
 	unsigned int i;
 
 	if (unlikely(!connlimit_rnd_inited)) {
@@ -81,14 +81,14 @@ static inline bool already_closed(const struct nf_conn *conn)
 }
 
 static inline unsigned int
-same_source_net(const union nf_conntrack_address *addr,
-		const union nf_conntrack_address *mask,
-		const union nf_conntrack_address *u3, unsigned int family)
+same_source_net(const union nf_inet_addr *addr,
+		const union nf_inet_addr *mask,
+		const union nf_inet_addr *u3, unsigned int family)
 {
 	if (family == AF_INET) {
 		return (addr->ip & mask->ip) == (u3->ip & mask->ip);
 	} else {
-		union nf_conntrack_address lh, rh;
+		union nf_inet_addr lh, rh;
 		unsigned int i;
 
 		for (i = 0; i < ARRAY_SIZE(addr->ip6); ++i) {
@@ -102,8 +102,8 @@ same_source_net(const union nf_conntrack_address *addr,
 
 static int count_them(struct xt_connlimit_data *data,
 		      const struct nf_conntrack_tuple *tuple,
-		      const union nf_conntrack_address *addr,
-		      const union nf_conntrack_address *mask,
+		      const union nf_inet_addr *addr,
+		      const union nf_inet_addr *mask,
 		      const struct xt_match *match)
 {
 	struct nf_conntrack_tuple_hash *found;
@@ -185,7 +185,7 @@ connlimit_mt(const struct sk_buff *skb, const struct net_device *in,
              bool *hotdrop)
 {
 	const struct xt_connlimit_info *info = matchinfo;
-	union nf_conntrack_address addr, mask;
+	union nf_inet_addr addr, mask;
 	struct nf_conntrack_tuple tuple;
 	const struct nf_conntrack_tuple *tuple_ptr = &tuple;
 	enum ip_conntrack_info ctinfo;
