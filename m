Return-Path: <SRS0=3cJm=SY=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0705C282CE
	for <netfilter-devel@archiver.kernel.org>; Mon, 22 Apr 2019 20:48:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B946C206A3
	for <netfilter-devel@archiver.kernel.org>; Mon, 22 Apr 2019 20:48:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730817AbfDVUsO (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 22 Apr 2019 16:48:14 -0400
Received: from mail.us.es ([193.147.175.20]:46722 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728797AbfDVUsN (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 22 Apr 2019 16:48:13 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 5195A44382F
        for <netfilter-devel@vger.kernel.org>; Mon, 22 Apr 2019 22:48:10 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 4376EDA70B
        for <netfilter-devel@vger.kernel.org>; Mon, 22 Apr 2019 22:48:10 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 39452DA709; Mon, 22 Apr 2019 22:48:10 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 1720BDA702;
        Mon, 22 Apr 2019 22:48:08 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 22 Apr 2019 22:48:08 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id DB0644265A32;
        Mon, 22 Apr 2019 22:48:07 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 05/10] netfilter: ctnetlink: don't use conntrack/expect object addresses as id
Date:   Mon, 22 Apr 2019 22:47:56 +0200
Message-Id: <20190422204801.26321-6-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190422204801.26321-1-pablo@netfilter.org>
References: <20190422204801.26321-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

else, we leak the addresses to userspace via ctnetlink events
and dumps.

Compute an ID on demand based on the immutable parts of nf_conn struct.

Another advantage compared to using an address is that there is no
immediate re-use of the same ID in case the conntrack entry is freed and
reallocated again immediately.

Fixes: 3583240249ef ("[NETFILTER]: nf_conntrack_expect: kill unique ID")
Fixes: 7f85f914721f ("[NETFILTER]: nf_conntrack: kill unique ID")
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_conntrack.h |  2 ++
 net/netfilter/nf_conntrack_core.c    | 35 +++++++++++++++++++++++++++++++++++
 net/netfilter/nf_conntrack_netlink.c | 34 +++++++++++++++++++++++++++++-----
 3 files changed, 66 insertions(+), 5 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack.h b/include/net/netfilter/nf_conntrack.h
index 5ee7b30b4917..d2bc733a2ef1 100644
--- a/include/net/netfilter/nf_conntrack.h
+++ b/include/net/netfilter/nf_conntrack.h
@@ -316,6 +316,8 @@ struct nf_conn *nf_ct_tmpl_alloc(struct net *net,
 				 gfp_t flags);
 void nf_ct_tmpl_free(struct nf_conn *tmpl);
 
+u32 nf_ct_get_id(const struct nf_conn *ct);
+
 static inline void
 nf_ct_set(struct sk_buff *skb, struct nf_conn *ct, enum ip_conntrack_info info)
 {
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index a137d4e7f218..3c48d44d6fff 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -25,6 +25,7 @@
 #include <linux/slab.h>
 #include <linux/random.h>
 #include <linux/jhash.h>
+#include <linux/siphash.h>
 #include <linux/err.h>
 #include <linux/percpu.h>
 #include <linux/moduleparam.h>
@@ -449,6 +450,40 @@ nf_ct_invert_tuple(struct nf_conntrack_tuple *inverse,
 }
 EXPORT_SYMBOL_GPL(nf_ct_invert_tuple);
 
+/* Generate a almost-unique pseudo-id for a given conntrack.
+ *
+ * intentionally doesn't re-use any of the seeds used for hash
+ * table location, we assume id gets exposed to userspace.
+ *
+ * Following nf_conn items do not change throughout lifetime
+ * of the nf_conn after it has been committed to main hash table:
+ *
+ * 1. nf_conn address
+ * 2. nf_conn->ext address
+ * 3. nf_conn->master address (normally NULL)
+ * 4. tuple
+ * 5. the associated net namespace
+ */
+u32 nf_ct_get_id(const struct nf_conn *ct)
+{
+	static __read_mostly siphash_key_t ct_id_seed;
+	unsigned long a, b, c, d;
+
+	net_get_random_once(&ct_id_seed, sizeof(ct_id_seed));
+
+	a = (unsigned long)ct;
+	b = (unsigned long)ct->master ^ net_hash_mix(nf_ct_net(ct));
+	c = (unsigned long)ct->ext;
+	d = (unsigned long)siphash(&ct->tuplehash, sizeof(ct->tuplehash),
+				   &ct_id_seed);
+#ifdef CONFIG_64BIT
+	return siphash_4u64((u64)a, (u64)b, (u64)c, (u64)d, &ct_id_seed);
+#else
+	return siphash_4u32((u32)a, (u32)b, (u32)c, (u32)d, &ct_id_seed);
+#endif
+}
+EXPORT_SYMBOL_GPL(nf_ct_get_id);
+
 static void
 clean_from_lists(struct nf_conn *ct)
 {
diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 66c596d287a5..d7f61b0547c6 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -29,6 +29,7 @@
 #include <linux/spinlock.h>
 #include <linux/interrupt.h>
 #include <linux/slab.h>
+#include <linux/siphash.h>
 
 #include <linux/netfilter.h>
 #include <net/netlink.h>
@@ -485,7 +486,9 @@ static int ctnetlink_dump_ct_synproxy(struct sk_buff *skb, struct nf_conn *ct)
 
 static int ctnetlink_dump_id(struct sk_buff *skb, const struct nf_conn *ct)
 {
-	if (nla_put_be32(skb, CTA_ID, htonl((unsigned long)ct)))
+	__be32 id = (__force __be32)nf_ct_get_id(ct);
+
+	if (nla_put_be32(skb, CTA_ID, id))
 		goto nla_put_failure;
 	return 0;
 
@@ -1286,8 +1289,9 @@ static int ctnetlink_del_conntrack(struct net *net, struct sock *ctnl,
 	}
 
 	if (cda[CTA_ID]) {
-		u_int32_t id = ntohl(nla_get_be32(cda[CTA_ID]));
-		if (id != (u32)(unsigned long)ct) {
+		__be32 id = nla_get_be32(cda[CTA_ID]);
+
+		if (id != (__force __be32)nf_ct_get_id(ct)) {
 			nf_ct_put(ct);
 			return -ENOENT;
 		}
@@ -2692,6 +2696,25 @@ static int ctnetlink_exp_dump_mask(struct sk_buff *skb,
 
 static const union nf_inet_addr any_addr;
 
+static __be32 nf_expect_get_id(const struct nf_conntrack_expect *exp)
+{
+	static __read_mostly siphash_key_t exp_id_seed;
+	unsigned long a, b, c, d;
+
+	net_get_random_once(&exp_id_seed, sizeof(exp_id_seed));
+
+	a = (unsigned long)exp;
+	b = (unsigned long)exp->helper;
+	c = (unsigned long)exp->master;
+	d = (unsigned long)siphash(&exp->tuple, sizeof(exp->tuple), &exp_id_seed);
+
+#ifdef CONFIG_64BIT
+	return (__force __be32)siphash_4u64((u64)a, (u64)b, (u64)c, (u64)d, &exp_id_seed);
+#else
+	return (__force __be32)siphash_4u32((u32)a, (u32)b, (u32)c, (u32)d, &exp_id_seed);
+#endif
+}
+
 static int
 ctnetlink_exp_dump_expect(struct sk_buff *skb,
 			  const struct nf_conntrack_expect *exp)
@@ -2739,7 +2762,7 @@ ctnetlink_exp_dump_expect(struct sk_buff *skb,
 	}
 #endif
 	if (nla_put_be32(skb, CTA_EXPECT_TIMEOUT, htonl(timeout)) ||
-	    nla_put_be32(skb, CTA_EXPECT_ID, htonl((unsigned long)exp)) ||
+	    nla_put_be32(skb, CTA_EXPECT_ID, nf_expect_get_id(exp)) ||
 	    nla_put_be32(skb, CTA_EXPECT_FLAGS, htonl(exp->flags)) ||
 	    nla_put_be32(skb, CTA_EXPECT_CLASS, htonl(exp->class)))
 		goto nla_put_failure;
@@ -3044,7 +3067,8 @@ static int ctnetlink_get_expect(struct net *net, struct sock *ctnl,
 
 	if (cda[CTA_EXPECT_ID]) {
 		__be32 id = nla_get_be32(cda[CTA_EXPECT_ID]);
-		if (ntohl(id) != (u32)(unsigned long)exp) {
+
+		if (id != nf_expect_get_id(exp)) {
 			nf_ct_expect_put(exp);
 			return -ENOENT;
 		}
-- 
2.11.0

