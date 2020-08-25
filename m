Return-Path: <SRS0=A2+c=CD=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1EB6C433DF
	for <netfilter-devel@archiver.kernel.org>; Tue, 25 Aug 2020 22:53:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BA9952075F
	for <netfilter-devel@archiver.kernel.org>; Tue, 25 Aug 2020 22:53:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726809AbgHYWxT (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 25 Aug 2020 18:53:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726466AbgHYWxT (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 25 Aug 2020 18:53:19 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EBBFC061574
        for <netfilter-devel@vger.kernel.org>; Tue, 25 Aug 2020 15:53:18 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1kAhoW-00065j-Ov; Wed, 26 Aug 2020 00:53:13 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next 3/4] netfilter: conntrack: add clash resolution stat counter
Date:   Wed, 26 Aug 2020 00:52:44 +0200
Message-Id: <20200825225245.8072-4-fw@strlen.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200825225245.8072-1-fw@strlen.de>
References: <20200825225245.8072-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

There is a misconception about what "insert_failed" means.

We increment this even when a clash got resolved, so it might not indicate
a problem.

Add a dedicated counter for clash resolution and only increment
insert_failed if a clash cannot be resolved.

For the old /proc interface, export this in place of an older stat
that got removed a while back.
For ctnetlink, export this with a new attribute.

Also correct an outdated comment that implies we add a duplicate tuple --
we only add the (unique) reply direction.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/linux/netfilter/nf_conntrack_common.h      | 1 +
 include/uapi/linux/netfilter/nfnetlink_conntrack.h | 1 +
 net/netfilter/nf_conntrack_core.c                  | 9 +++++----
 net/netfilter/nf_conntrack_netlink.c               | 4 +++-
 net/netfilter/nf_conntrack_standalone.c            | 2 +-
 5 files changed, 11 insertions(+), 6 deletions(-)

diff --git a/include/linux/netfilter/nf_conntrack_common.h b/include/linux/netfilter/nf_conntrack_common.h
index 96b90d7e361f..0c7d8d1e945d 100644
--- a/include/linux/netfilter/nf_conntrack_common.h
+++ b/include/linux/netfilter/nf_conntrack_common.h
@@ -10,6 +10,7 @@ struct ip_conntrack_stat {
 	unsigned int invalid;
 	unsigned int insert;
 	unsigned int insert_failed;
+	unsigned int clash_resolve;
 	unsigned int drop;
 	unsigned int early_drop;
 	unsigned int error;
diff --git a/include/uapi/linux/netfilter/nfnetlink_conntrack.h b/include/uapi/linux/netfilter/nfnetlink_conntrack.h
index 3e471558da82..d8484be72fdc 100644
--- a/include/uapi/linux/netfilter/nfnetlink_conntrack.h
+++ b/include/uapi/linux/netfilter/nfnetlink_conntrack.h
@@ -256,6 +256,7 @@ enum ctattr_stats_cpu {
 	CTA_STATS_EARLY_DROP,
 	CTA_STATS_ERROR,
 	CTA_STATS_SEARCH_RESTART,
+	CTA_STATS_CLASH_RESOLVE,
 	__CTA_STATS_MAX,
 };
 #define CTA_STATS_MAX (__CTA_STATS_MAX - 1)
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index a111bcf1b93c..93e77ca0efad 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -859,7 +859,6 @@ nf_conntrack_hash_check_insert(struct nf_conn *ct)
 
 out:
 	nf_conntrack_double_unlock(hash, reply_hash);
-	NF_CT_STAT_INC(net, insert_failed);
 	local_bh_enable();
 	return -EEXIST;
 }
@@ -934,7 +933,7 @@ static int __nf_ct_resolve_clash(struct sk_buff *skb,
 		nf_conntrack_put(&loser_ct->ct_general);
 		nf_ct_set(skb, ct, ctinfo);
 
-		NF_CT_STAT_INC(net, insert_failed);
+		NF_CT_STAT_INC(net, clash_resolve);
 		return NF_ACCEPT;
 	}
 
@@ -998,6 +997,8 @@ static int nf_ct_resolve_clash_harder(struct sk_buff *skb, u32 repl_idx)
 
 	hlist_nulls_add_head_rcu(&loser_ct->tuplehash[IP_CT_DIR_REPLY].hnnode,
 				 &nf_conntrack_hash[repl_idx]);
+
+	NF_CT_STAT_INC(net, clash_resolve);
 	return NF_ACCEPT;
 }
 
@@ -1027,10 +1028,10 @@ static int nf_ct_resolve_clash_harder(struct sk_buff *skb, u32 repl_idx)
  *
  * Failing that, the new, unconfirmed conntrack is still added to the table
  * provided that the collision only occurs in the ORIGINAL direction.
- * The new entry will be added after the existing one in the hash list,
+ * The new entry will be added only in the non-clashing REPLY direction,
  * so packets in the ORIGINAL direction will continue to match the existing
  * entry.  The new entry will also have a fixed timeout so it expires --
- * due to the collision, it will not see bidirectional traffic.
+ * due to the collision, it will only see reply traffic.
  *
  * Returns NF_DROP if the clash could not be resolved.
  */
diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index c64f23a8f373..89d99f6dfd0a 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -2516,7 +2516,9 @@ ctnetlink_ct_stat_cpu_fill_info(struct sk_buff *skb, u32 portid, u32 seq,
 	    nla_put_be32(skb, CTA_STATS_EARLY_DROP, htonl(st->early_drop)) ||
 	    nla_put_be32(skb, CTA_STATS_ERROR, htonl(st->error)) ||
 	    nla_put_be32(skb, CTA_STATS_SEARCH_RESTART,
-				htonl(st->search_restart)))
+				htonl(st->search_restart)) ||
+	    nla_put_be32(skb, CTA_STATS_CLASH_RESOLVE,
+				htonl(st->clash_resolve)))
 		goto nla_put_failure;
 
 	nlmsg_end(skb, nlh);
diff --git a/net/netfilter/nf_conntrack_standalone.c b/net/netfilter/nf_conntrack_standalone.c
index b673a03624d2..0ff39740797d 100644
--- a/net/netfilter/nf_conntrack_standalone.c
+++ b/net/netfilter/nf_conntrack_standalone.c
@@ -435,7 +435,7 @@ static int ct_cpu_seq_show(struct seq_file *seq, void *v)
 	seq_printf(seq, "%08x  %08x %08x %08x %08x %08x %08x %08x "
 			"%08x %08x %08x %08x %08x  %08x %08x %08x %08x\n",
 		   nr_conntracks,
-		   0,
+		   st->clash_resolve, /* was: searched */
 		   st->found,
 		   0,
 		   st->invalid,
-- 
2.26.2

