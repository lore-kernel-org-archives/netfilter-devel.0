Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53C31C433FE
	for <netfilter-devel@archiver.kernel.org>; Wed,  8 Sep 2021 12:29:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3A0C960E77
	for <netfilter-devel@archiver.kernel.org>; Wed,  8 Sep 2021 12:29:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348576AbhIHMaH (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 8 Sep 2021 08:30:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346096AbhIHMaD (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 8 Sep 2021 08:30:03 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DCEEC061575
        for <netfilter-devel@vger.kernel.org>; Wed,  8 Sep 2021 05:28:56 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1mNwhC-0004bB-QV; Wed, 08 Sep 2021 14:28:54 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nf 1/5] netfilter: conntrack: make connection tracking table less predictable
Date:   Wed,  8 Sep 2021 14:28:34 +0200
Message-Id: <20210908122839.7526-2-fw@strlen.de>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210908122839.7526-1-fw@strlen.de>
References: <20210908122839.7526-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Similar to commit 67d6d681e15b
("ipv4: make exception cache less predictible"):

Use a random drop length to make it harder to detect when entries were
hashed to same bucket list.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nf_conntrack_core.c | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 94e18fb9690d..91b7edaa635c 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -77,7 +77,8 @@ static __read_mostly bool nf_conntrack_locks_all;
 #define GC_SCAN_INTERVAL	(120u * HZ)
 #define GC_SCAN_MAX_DURATION	msecs_to_jiffies(10)
 
-#define MAX_CHAINLEN	64u
+#define MIN_CHAINLEN	8u
+#define MAX_CHAINLEN	(32u - MIN_CHAINLEN)
 
 static struct conntrack_gc_work conntrack_gc_work;
 
@@ -842,6 +843,7 @@ nf_conntrack_hash_check_insert(struct nf_conn *ct)
 	unsigned int hash, reply_hash;
 	struct nf_conntrack_tuple_hash *h;
 	struct hlist_nulls_node *n;
+	unsigned int max_chainlen;
 	unsigned int chainlen = 0;
 	unsigned int sequence;
 	int err = -EEXIST;
@@ -857,13 +859,15 @@ nf_conntrack_hash_check_insert(struct nf_conn *ct)
 					   &ct->tuplehash[IP_CT_DIR_REPLY].tuple);
 	} while (nf_conntrack_double_lock(net, hash, reply_hash, sequence));
 
+	max_chainlen = MIN_CHAINLEN + prandom_u32_max(MAX_CHAINLEN);
+
 	/* See if there's one in the list already, including reverse */
 	hlist_nulls_for_each_entry(h, n, &nf_conntrack_hash[hash], hnnode) {
 		if (nf_ct_key_equal(h, &ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple,
 				    zone, net))
 			goto out;
 
-		if (chainlen++ > MAX_CHAINLEN)
+		if (chainlen++ > max_chainlen)
 			goto chaintoolong;
 	}
 
@@ -873,7 +877,7 @@ nf_conntrack_hash_check_insert(struct nf_conn *ct)
 		if (nf_ct_key_equal(h, &ct->tuplehash[IP_CT_DIR_REPLY].tuple,
 				    zone, net))
 			goto out;
-		if (chainlen++ > MAX_CHAINLEN)
+		if (chainlen++ > max_chainlen)
 			goto chaintoolong;
 	}
 
@@ -1103,8 +1107,8 @@ nf_ct_resolve_clash(struct sk_buff *skb, struct nf_conntrack_tuple_hash *h,
 int
 __nf_conntrack_confirm(struct sk_buff *skb)
 {
+	unsigned int chainlen = 0, sequence, max_chainlen;
 	const struct nf_conntrack_zone *zone;
-	unsigned int chainlen = 0, sequence;
 	unsigned int hash, reply_hash;
 	struct nf_conntrack_tuple_hash *h;
 	struct nf_conn *ct;
@@ -1168,6 +1172,7 @@ __nf_conntrack_confirm(struct sk_buff *skb)
 		goto dying;
 	}
 
+	max_chainlen = MIN_CHAINLEN + prandom_u32_max(MAX_CHAINLEN);
 	/* See if there's one in the list already, including reverse:
 	   NAT could have grabbed it without realizing, since we're
 	   not in the hash.  If there is, we lost race. */
@@ -1175,7 +1180,7 @@ __nf_conntrack_confirm(struct sk_buff *skb)
 		if (nf_ct_key_equal(h, &ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple,
 				    zone, net))
 			goto out;
-		if (chainlen++ > MAX_CHAINLEN)
+		if (chainlen++ > max_chainlen)
 			goto chaintoolong;
 	}
 
@@ -1184,7 +1189,7 @@ __nf_conntrack_confirm(struct sk_buff *skb)
 		if (nf_ct_key_equal(h, &ct->tuplehash[IP_CT_DIR_REPLY].tuple,
 				    zone, net))
 			goto out;
-		if (chainlen++ > MAX_CHAINLEN) {
+		if (chainlen++ > max_chainlen) {
 chaintoolong:
 			nf_ct_add_to_dying_list(ct);
 			NF_CT_STAT_INC(net, chaintoolong);
-- 
2.32.0

