Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1521EC432BE
	for <netfilter-devel@archiver.kernel.org>; Thu, 26 Aug 2021 13:54:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EE30E61038
	for <netfilter-devel@archiver.kernel.org>; Thu, 26 Aug 2021 13:54:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229793AbhHZNzf (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 26 Aug 2021 09:55:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242759AbhHZNze (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 26 Aug 2021 09:55:34 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D272C0613C1
        for <netfilter-devel@vger.kernel.org>; Thu, 26 Aug 2021 06:54:47 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1mJFq9-0000Z0-Pg; Thu, 26 Aug 2021 15:54:45 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nf 3/3] netfilter: conntrack: refuse insertion if chain has grown too large
Date:   Thu, 26 Aug 2021 15:54:21 +0200
Message-Id: <20210826135422.31063-4-fw@strlen.de>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210826135422.31063-1-fw@strlen.de>
References: <20210826135422.31063-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Assuming the old default size of 16536 buckets and max hash occupancy of
64k, this results in 128k insertions (origin+reply), so ~8 entries per
chain on average.

The revised settings in the earlier change result in about two entries per
bucket on average.

This enforces a hard-limit of 64.

This is not tunable at the moment, but its possible to either increase
nf_conntrack_buckets or decrease nf_conntrack_max to reduce average lengths.

A new stat counter for this gets exported both via old /proc interface and ctnetlink.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/linux/netfilter/nf_conntrack_common.h |  1 +
 .../linux/netfilter/nfnetlink_conntrack.h     |  1 +
 net/netfilter/nf_conntrack_core.c             | 42 +++++++++++++++----
 net/netfilter/nf_conntrack_netlink.c          |  4 +-
 net/netfilter/nf_conntrack_standalone.c       |  4 +-
 5 files changed, 42 insertions(+), 10 deletions(-)

diff --git a/include/linux/netfilter/nf_conntrack_common.h b/include/linux/netfilter/nf_conntrack_common.h
index 0c7d8d1e945d..700ea077ce2d 100644
--- a/include/linux/netfilter/nf_conntrack_common.h
+++ b/include/linux/netfilter/nf_conntrack_common.h
@@ -18,6 +18,7 @@ struct ip_conntrack_stat {
 	unsigned int expect_create;
 	unsigned int expect_delete;
 	unsigned int search_restart;
+	unsigned int chaintoolong;
 };
 
 #define NFCT_INFOMASK	7UL
diff --git a/include/uapi/linux/netfilter/nfnetlink_conntrack.h b/include/uapi/linux/netfilter/nfnetlink_conntrack.h
index d8484be72fdc..5ade231f497b 100644
--- a/include/uapi/linux/netfilter/nfnetlink_conntrack.h
+++ b/include/uapi/linux/netfilter/nfnetlink_conntrack.h
@@ -257,6 +257,7 @@ enum ctattr_stats_cpu {
 	CTA_STATS_ERROR,
 	CTA_STATS_SEARCH_RESTART,
 	CTA_STATS_CLASH_RESOLVE,
+	CTA_STATS_CHAIN_TOOLONG,
 	__CTA_STATS_MAX,
 };
 #define CTA_STATS_MAX (__CTA_STATS_MAX - 1)
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index da2650f872e1..94e18fb9690d 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -77,6 +77,8 @@ static __read_mostly bool nf_conntrack_locks_all;
 #define GC_SCAN_INTERVAL	(120u * HZ)
 #define GC_SCAN_MAX_DURATION	msecs_to_jiffies(10)
 
+#define MAX_CHAINLEN	64u
+
 static struct conntrack_gc_work conntrack_gc_work;
 
 void nf_conntrack_lock(spinlock_t *lock) __acquires(lock)
@@ -840,7 +842,9 @@ nf_conntrack_hash_check_insert(struct nf_conn *ct)
 	unsigned int hash, reply_hash;
 	struct nf_conntrack_tuple_hash *h;
 	struct hlist_nulls_node *n;
+	unsigned int chainlen = 0;
 	unsigned int sequence;
+	int err = -EEXIST;
 
 	zone = nf_ct_zone(ct);
 
@@ -854,15 +858,24 @@ nf_conntrack_hash_check_insert(struct nf_conn *ct)
 	} while (nf_conntrack_double_lock(net, hash, reply_hash, sequence));
 
 	/* See if there's one in the list already, including reverse */
-	hlist_nulls_for_each_entry(h, n, &nf_conntrack_hash[hash], hnnode)
+	hlist_nulls_for_each_entry(h, n, &nf_conntrack_hash[hash], hnnode) {
 		if (nf_ct_key_equal(h, &ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple,
 				    zone, net))
 			goto out;
 
-	hlist_nulls_for_each_entry(h, n, &nf_conntrack_hash[reply_hash], hnnode)
+		if (chainlen++ > MAX_CHAINLEN)
+			goto chaintoolong;
+	}
+
+	chainlen = 0;
+
+	hlist_nulls_for_each_entry(h, n, &nf_conntrack_hash[reply_hash], hnnode) {
 		if (nf_ct_key_equal(h, &ct->tuplehash[IP_CT_DIR_REPLY].tuple,
 				    zone, net))
 			goto out;
+		if (chainlen++ > MAX_CHAINLEN)
+			goto chaintoolong;
+	}
 
 	smp_wmb();
 	/* The caller holds a reference to this object */
@@ -872,11 +885,13 @@ nf_conntrack_hash_check_insert(struct nf_conn *ct)
 	NF_CT_STAT_INC(net, insert);
 	local_bh_enable();
 	return 0;
-
+chaintoolong:
+	NF_CT_STAT_INC(net, chaintoolong);
+	err = -ENOSPC;
 out:
 	nf_conntrack_double_unlock(hash, reply_hash);
 	local_bh_enable();
-	return -EEXIST;
+	return err;
 }
 EXPORT_SYMBOL_GPL(nf_conntrack_hash_check_insert);
 
@@ -1089,6 +1104,7 @@ int
 __nf_conntrack_confirm(struct sk_buff *skb)
 {
 	const struct nf_conntrack_zone *zone;
+	unsigned int chainlen = 0, sequence;
 	unsigned int hash, reply_hash;
 	struct nf_conntrack_tuple_hash *h;
 	struct nf_conn *ct;
@@ -1096,7 +1112,6 @@ __nf_conntrack_confirm(struct sk_buff *skb)
 	struct hlist_nulls_node *n;
 	enum ip_conntrack_info ctinfo;
 	struct net *net;
-	unsigned int sequence;
 	int ret = NF_DROP;
 
 	ct = nf_ct_get(skb, &ctinfo);
@@ -1156,15 +1171,28 @@ __nf_conntrack_confirm(struct sk_buff *skb)
 	/* See if there's one in the list already, including reverse:
 	   NAT could have grabbed it without realizing, since we're
 	   not in the hash.  If there is, we lost race. */
-	hlist_nulls_for_each_entry(h, n, &nf_conntrack_hash[hash], hnnode)
+	hlist_nulls_for_each_entry(h, n, &nf_conntrack_hash[hash], hnnode) {
 		if (nf_ct_key_equal(h, &ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple,
 				    zone, net))
 			goto out;
+		if (chainlen++ > MAX_CHAINLEN)
+			goto chaintoolong;
+	}
 
-	hlist_nulls_for_each_entry(h, n, &nf_conntrack_hash[reply_hash], hnnode)
+	chainlen = 0;
+	hlist_nulls_for_each_entry(h, n, &nf_conntrack_hash[reply_hash], hnnode) {
 		if (nf_ct_key_equal(h, &ct->tuplehash[IP_CT_DIR_REPLY].tuple,
 				    zone, net))
 			goto out;
+		if (chainlen++ > MAX_CHAINLEN) {
+chaintoolong:
+			nf_ct_add_to_dying_list(ct);
+			NF_CT_STAT_INC(net, chaintoolong);
+			NF_CT_STAT_INC(net, insert_failed);
+			ret = NF_DROP;
+			goto dying;
+		}
+	}
 
 	/* Timer relative to confirmation time, not original
 	   setting time, otherwise we'd get timer wrap in
diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index e81af33b233b..3f081ae08266 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -2484,7 +2484,9 @@ ctnetlink_ct_stat_cpu_fill_info(struct sk_buff *skb, u32 portid, u32 seq,
 	    nla_put_be32(skb, CTA_STATS_SEARCH_RESTART,
 				htonl(st->search_restart)) ||
 	    nla_put_be32(skb, CTA_STATS_CLASH_RESOLVE,
-				htonl(st->clash_resolve)))
+				htonl(st->clash_resolve)) ||
+	    nla_put_be32(skb, CTA_STATS_CHAIN_TOOLONG,
+			 htonl(st->chaintoolong)))
 		goto nla_put_failure;
 
 	nlmsg_end(skb, nlh);
diff --git a/net/netfilter/nf_conntrack_standalone.c b/net/netfilter/nf_conntrack_standalone.c
index e84b499b7bfa..f94ebd5194b5 100644
--- a/net/netfilter/nf_conntrack_standalone.c
+++ b/net/netfilter/nf_conntrack_standalone.c
@@ -429,7 +429,7 @@ static int ct_cpu_seq_show(struct seq_file *seq, void *v)
 	unsigned int nr_conntracks;
 
 	if (v == SEQ_START_TOKEN) {
-		seq_puts(seq, "entries  clashres found new invalid ignore delete delete_list insert insert_failed drop early_drop icmp_error  expect_new expect_create expect_delete search_restart\n");
+		seq_puts(seq, "entries  clashres found new invalid ignore delete chainlength insert insert_failed drop early_drop icmp_error  expect_new expect_create expect_delete search_restart\n");
 		return 0;
 	}
 
@@ -444,7 +444,7 @@ static int ct_cpu_seq_show(struct seq_file *seq, void *v)
 		   st->invalid,
 		   0,
 		   0,
-		   0,
+		   st->chaintoolong,
 		   st->insert,
 		   st->insert_failed,
 		   st->drop,
-- 
2.31.1

