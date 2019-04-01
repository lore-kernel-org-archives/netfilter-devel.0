Return-Path: <SRS0=mHk2=SD=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65B2EC43381
	for <netfilter-devel@archiver.kernel.org>; Mon,  1 Apr 2019 11:11:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3F14820870
	for <netfilter-devel@archiver.kernel.org>; Mon,  1 Apr 2019 11:11:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726708AbfDALLI (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 1 Apr 2019 07:11:08 -0400
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:55376 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725882AbfDALLH (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 1 Apr 2019 07:11:07 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.89)
        (envelope-from <fw@breakpoint.cc>)
        id 1hAuqG-00031F-RI; Mon, 01 Apr 2019 13:11:05 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nf] netfilter: ctnetlink: don't use conntrack/expect object addresses as id
Date:   Mon,  1 Apr 2019 13:08:54 +0200
Message-Id: <20190401110854.19894-1-fw@strlen.de>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

else, we leak the addresses to userspace via ctnetlink events
and dumps.

Compute an ID on demand based on the immutable parts of nf_conn struct.

Another advantage compared to using an address is that there is no
immediate re-use of the same ID in case the conntrack entry is freed and
reallocated again immediately.

Fixes: 3583240249ef ("[NETFILTER]: nf_conntrack_expect: kill unique ID")
Fixes: 7f85f914721f ("[NETFILTER]: nf_conntrack: kill unique ID")
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/net/netfilter/nf_conntrack.h |  2 ++
 net/netfilter/nf_conntrack_core.c    | 39 ++++++++++++++++++++++++++++
 net/netfilter/nf_conntrack_netlink.c | 37 ++++++++++++++++++++++----
 3 files changed, 73 insertions(+), 5 deletions(-)

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
index 82bfbeef46af..be899f2713e0 100644
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
@@ -449,6 +450,44 @@ nf_ct_invert_tuple(struct nf_conntrack_tuple *inverse,
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
+
+#ifdef CONFIG_64BIT
+	d = siphash(&ct->tuplehash, sizeof(ct->tuplehash), &ct_id_seed);
+
+	return siphash_4u64((u64)a, (u64)b, (u64)c, (u64)d, &ct_id_seed);
+#else
+	d = hsiphash(&ct->tuplehash, sizeof(ct->tuplehash), &ct_id_seed);
+
+	return siphash_4u32((u32)a, (u32)b, (u32)c, (u32)d, &ct_id_seed);
+#endif
+
+}
+EXPORT_SYMBOL_GPL(nf_ct_get_id);
+
 static void
 clean_from_lists(struct nf_conn *ct)
 {
diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 66c596d287a5..f80fce25c673 100644
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
@@ -2692,6 +2696,28 @@ static int ctnetlink_exp_dump_mask(struct sk_buff *skb,
 
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
+#ifdef CONFIG_64BIT
+	d = siphash(&exp->tuple, sizeof(exp->tuple), &exp_id_seed);
+
+	return (__force __be32)siphash_4u64((u64)a, (u64)b, (u64)c, (u64)d, &exp_id_seed);
+#else
+	d = hsiphash(&exp->tuple, sizeof(exp->tuple), &exp_id_seed);
+
+	return (__force __be32)siphash_4u32((u32)a, (u32)b, (u32)c, (u32)d, &exp_id_seed);
+#endif
+}
+EXPORT_SYMBOL_GPL(nf_ct_get_id);
+
 static int
 ctnetlink_exp_dump_expect(struct sk_buff *skb,
 			  const struct nf_conntrack_expect *exp)
@@ -2739,7 +2765,7 @@ ctnetlink_exp_dump_expect(struct sk_buff *skb,
 	}
 #endif
 	if (nla_put_be32(skb, CTA_EXPECT_TIMEOUT, htonl(timeout)) ||
-	    nla_put_be32(skb, CTA_EXPECT_ID, htonl((unsigned long)exp)) ||
+	    nla_put_be32(skb, CTA_EXPECT_ID, nf_expect_get_id(exp)) ||
 	    nla_put_be32(skb, CTA_EXPECT_FLAGS, htonl(exp->flags)) ||
 	    nla_put_be32(skb, CTA_EXPECT_CLASS, htonl(exp->class)))
 		goto nla_put_failure;
@@ -3044,7 +3070,8 @@ static int ctnetlink_get_expect(struct net *net, struct sock *ctnl,
 
 	if (cda[CTA_EXPECT_ID]) {
 		__be32 id = nla_get_be32(cda[CTA_EXPECT_ID]);
-		if (ntohl(id) != (u32)(unsigned long)exp) {
+
+		if (id != nf_expect_get_id(exp)) {
 			nf_ct_expect_put(exp);
 			return -ENOENT;
 		}
-- 
2.21.0

