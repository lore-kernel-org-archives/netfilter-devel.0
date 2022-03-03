Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81DE8C433EF
	for <netfilter-devel@archiver.kernel.org>; Thu,  3 Mar 2022 13:55:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232036AbiCCN4F (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 3 Mar 2022 08:56:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233134AbiCCN4E (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 3 Mar 2022 08:56:04 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A808518BA6E
        for <netfilter-devel@vger.kernel.org>; Thu,  3 Mar 2022 05:55:18 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1nPlvJ-0001Xm-5O; Thu, 03 Mar 2022 14:55:17 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [RFC v3 nf-next 12/15] netfilter: extensions: introduce extension genid count
Date:   Thu,  3 Mar 2022 14:54:16 +0100
Message-Id: <20220303135419.10837-13-fw@strlen.de>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220303135419.10837-1-fw@strlen.de>
References: <20220303135419.10837-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Multiple netfilter extensions store pointers to external data
in their extension area struct.

Examples:
1. Timeout policies
2. Connection tracking helpers.

No references are taken for these.

When a helper or timeout policy is removed, the conntrack table gets
traversed and affected extensions are cleared.

Conntrack entries not yet in the hashtable are referenced via a special
list, the unconfirmed list.

On removal of a policy or connection tracking helper, the unconfirmed
list gets traversed an all entries are marked as dying, this prevents
them from getting committed to the table at insertion time: core checks
for dying bit, if set, the conntrack entry gets destroyed at confirm
time.

The disadvantage is that each new conntrack has to be added to the
percpu unconfirmed list, and each insertion needs to remove it from
this list. The list is only ever needed when a policy or helper is
removed -- a rare occurence.

Add a generation ID count: Instead of adding to the list and then
traversing that list on policy/helper removal, increment a counter
that is stored in the extension area.

For unconfirmed conntracks, the extension has the genid valid at
conntrack allocation time.

Removal of a helper/policy etc. increments the counter.
At confirmation time, validate that ext->genid == global_id.

If the stored number is not the same, do not allow the conntrack
insertion, just like as if a confirmed-list traversal would have flagged
the entry as dying.

After insertion, the genid is no longer relevant (conntrack entries
are now reachable via the conntrack table iterators and is set to 0.

This allows removal of the percpu unconfirmed list.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/net/netfilter/nf_conntrack_extend.h | 31 ++++++------
 net/netfilter/nf_conntrack_core.c           | 55 +++++++++++++++++++++
 net/netfilter/nf_conntrack_extend.c         | 32 +++++++++++-
 3 files changed, 102 insertions(+), 16 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack_extend.h b/include/net/netfilter/nf_conntrack_extend.h
index 96635ad2acc7..0b247248b032 100644
--- a/include/net/netfilter/nf_conntrack_extend.h
+++ b/include/net/netfilter/nf_conntrack_extend.h
@@ -34,21 +34,11 @@ enum nf_ct_ext_id {
 	NF_CT_EXT_NUM,
 };
 
-#define NF_CT_EXT_HELPER_TYPE struct nf_conn_help
-#define NF_CT_EXT_NAT_TYPE struct nf_conn_nat
-#define NF_CT_EXT_SEQADJ_TYPE struct nf_conn_seqadj
-#define NF_CT_EXT_ACCT_TYPE struct nf_conn_acct
-#define NF_CT_EXT_ECACHE_TYPE struct nf_conntrack_ecache
-#define NF_CT_EXT_TSTAMP_TYPE struct nf_conn_tstamp
-#define NF_CT_EXT_TIMEOUT_TYPE struct nf_conn_timeout
-#define NF_CT_EXT_LABELS_TYPE struct nf_conn_labels
-#define NF_CT_EXT_SYNPROXY_TYPE struct nf_conn_synproxy
-#define NF_CT_EXT_ACT_CT_TYPE struct nf_conn_act_ct_ext
-
 /* Extensions: optional stuff which isn't permanently in struct. */
 struct nf_ct_ext {
 	u8 offset[NF_CT_EXT_NUM];
 	u8 len;
+	unsigned int gen_id;
 	char data[] __aligned(8);
 };
 
@@ -62,17 +52,28 @@ static inline bool nf_ct_ext_exist(const struct nf_conn *ct, u8 id)
 	return (ct->ext && __nf_ct_ext_exist(ct->ext, id));
 }
 
-static inline void *__nf_ct_ext_find(const struct nf_conn *ct, u8 id)
+void *__nf_ct_ext_find(const struct nf_ct_ext *ext, u8 id);
+
+static inline void *nf_ct_ext_find(const struct nf_conn *ct, u8 id)
 {
-	if (!nf_ct_ext_exist(ct, id))
+	struct nf_ct_ext *ext = ct->ext;
+
+	if (!ext || !__nf_ct_ext_exist(ext, id))
 		return NULL;
 
+	if (unlikely(ext->gen_id))
+		return __nf_ct_ext_find(ext, id);
+
 	return (void *)ct->ext + ct->ext->offset[id];
 }
-#define nf_ct_ext_find(ext, id)	\
-	((id##_TYPE *)__nf_ct_ext_find((ext), (id)))
 
 /* Add this type, returns pointer to data or NULL. */
 void *nf_ct_ext_add(struct nf_conn *ct, enum nf_ct_ext_id id, gfp_t gfp);
 
+/* ext genid.  if ext->id != ext_genid, extensions cannot be used
+ * anymore unless conntrack has CONFIRMED bit set.
+ */
+extern atomic_t nf_conntrack_ext_genid;
+void nf_ct_ext_bump_genid(void);
+
 #endif /* _NF_CONNTRACK_EXTEND_H */
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index cbfd79dae8e7..7c775a6c27ff 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -863,6 +863,33 @@ static void __nf_conntrack_hash_insert(struct nf_conn *ct,
 			   &nf_conntrack_hash[reply_hash]);
 }
 
+static bool nf_ct_ext_valid_pre(const struct nf_ct_ext *ext)
+{
+	/* if ext->gen_id is not equal to nf_conntrack_ext_genid, some extensions
+	 * may contain stale pointers to e.g. helper that has been removed.
+	 *
+	 * The helper can't clear this because the nf_conn object isn't in
+	 * any hash and synchronize_rcu() isn't enough because associated skb
+	 * might sit in a queue.
+	 */
+	return !ext || ext->gen_id == atomic_read(&nf_conntrack_ext_genid);
+}
+
+static bool nf_ct_ext_valid_post(struct nf_ct_ext *ext)
+{
+	if (!ext)
+		return true;
+
+	if (ext->gen_id != atomic_read(&nf_conntrack_ext_genid))
+		return false;
+
+	/* inserted into conntrack table, nf_ct_iterate_cleanup()
+	 * will find it.  Disable nf_ct_ext_find() id check.
+	 */
+	WRITE_ONCE(ext->gen_id, 0);
+	return true;
+}
+
 int
 nf_conntrack_hash_check_insert(struct nf_conn *ct)
 {
@@ -878,6 +905,11 @@ nf_conntrack_hash_check_insert(struct nf_conn *ct)
 
 	zone = nf_ct_zone(ct);
 
+	if (!nf_ct_ext_valid_pre(ct->ext)) {
+		NF_CT_STAT_INC(net, insert_failed);
+		return -ETIMEDOUT;
+	}
+
 	local_bh_disable();
 	do {
 		sequence = read_seqcount_begin(&nf_conntrack_generation);
@@ -918,6 +950,13 @@ nf_conntrack_hash_check_insert(struct nf_conn *ct)
 	nf_conntrack_double_unlock(hash, reply_hash);
 	NF_CT_STAT_INC(net, insert);
 	local_bh_enable();
+
+	if (!nf_ct_ext_valid_post(ct->ext)) {
+		nf_ct_kill(ct);
+		NF_CT_STAT_INC(net, drop);
+		return -ETIMEDOUT;
+	}
+
 	return 0;
 chaintoolong:
 	NF_CT_STAT_INC(net, chaintoolong);
@@ -1185,6 +1224,11 @@ __nf_conntrack_confirm(struct sk_buff *skb)
 		return NF_DROP;
 	}
 
+	if (!nf_ct_ext_valid_pre(ct->ext)) {
+		NF_CT_STAT_INC(net, insert_failed);
+		goto dying;
+	}
+
 	pr_debug("Confirming conntrack %p\n", ct);
 	/* We have to check the DYING flag after unlink to prevent
 	 * a race against nf_ct_get_next_corpse() possibly called from
@@ -1241,6 +1285,16 @@ __nf_conntrack_confirm(struct sk_buff *skb)
 	nf_conntrack_double_unlock(hash, reply_hash);
 	local_bh_enable();
 
+	/* ext area is still valid (rcu read lock is held,
+	 * but will go out of scope soon, we need to remove
+	 * this conntrack again.
+	 */
+	if (!nf_ct_ext_valid_post(ct->ext)) {
+		nf_ct_kill(ct);
+		NF_CT_STAT_INC(net, drop);
+		return NF_DROP;
+	}
+
 	help = nfct_help(ct);
 	if (help && help->helper)
 		nf_conntrack_event_cache(IPCT_HELPER, ct);
@@ -2443,6 +2497,7 @@ nf_ct_iterate_destroy(int (*iter)(struct nf_conn *i, void *data), void *data)
 	 */
 	synchronize_net();
 
+	nf_ct_ext_bump_genid();
 	nf_ct_iterate_cleanup(iter, data, 0, 0);
 }
 EXPORT_SYMBOL_GPL(nf_ct_iterate_destroy);
diff --git a/net/netfilter/nf_conntrack_extend.c b/net/netfilter/nf_conntrack_extend.c
index 1296fda54ac6..0b513f7bf9f3 100644
--- a/net/netfilter/nf_conntrack_extend.c
+++ b/net/netfilter/nf_conntrack_extend.c
@@ -27,6 +27,8 @@
 
 #define NF_CT_EXT_PREALLOC	128u /* conntrack events are on by default */
 
+atomic_t nf_conntrack_ext_genid __read_mostly = ATOMIC_INIT(1);
+
 static const u8 nf_ct_ext_type_len[NF_CT_EXT_NUM] = {
 	[NF_CT_EXT_HELPER] = sizeof(struct nf_conn_help),
 #if IS_ENABLED(CONFIG_NF_NAT)
@@ -116,8 +118,10 @@ void *nf_ct_ext_add(struct nf_conn *ct, enum nf_ct_ext_id id, gfp_t gfp)
 	if (!new)
 		return NULL;
 
-	if (!ct->ext)
+	if (!ct->ext) {
 		memset(new->offset, 0, sizeof(new->offset));
+		new->gen_id = atomic_read(&nf_conntrack_ext_genid);
+	}
 
 	new->offset[id] = newoff;
 	new->len = newlen;
@@ -127,3 +131,29 @@ void *nf_ct_ext_add(struct nf_conn *ct, enum nf_ct_ext_id id, gfp_t gfp)
 	return (void *)new + newoff;
 }
 EXPORT_SYMBOL(nf_ct_ext_add);
+
+/* Use nf_ct_ext_find wrapper. This is only useful for unconfirmed entries. */
+void *__nf_ct_ext_find(const struct nf_ct_ext *ext, u8 id)
+{
+	unsigned int gen_id = atomic_read(&nf_conntrack_ext_genid);
+	unsigned int this_id = READ_ONCE(ext->gen_id);
+
+	if (!__nf_ct_ext_exist(ext, id))
+		return NULL;
+
+	if (this_id == 0 || ext->gen_id == gen_id)
+		return (void *)ext + ext->offset[id];
+
+	return NULL;
+}
+EXPORT_SYMBOL(__nf_ct_ext_find);
+
+void nf_ct_ext_bump_genid(void)
+{
+	unsigned int value = atomic_inc_return(&nf_conntrack_ext_genid);
+
+	if (value == UINT_MAX)
+		atomic_set(&nf_conntrack_ext_genid, 1);
+
+	msleep(HZ);
+}
-- 
2.34.1

