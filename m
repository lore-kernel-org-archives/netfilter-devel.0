Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34E3DC433EF
	for <netfilter-devel@archiver.kernel.org>; Wed,  8 Sep 2021 12:29:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 18BE761155
	for <netfilter-devel@archiver.kernel.org>; Wed,  8 Sep 2021 12:29:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348701AbhIHMaQ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 8 Sep 2021 08:30:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348699AbhIHMaQ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 8 Sep 2021 08:30:16 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC4CEC061575
        for <netfilter-devel@vger.kernel.org>; Wed,  8 Sep 2021 05:29:08 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1mNwhP-0004bm-9E; Wed, 08 Sep 2021 14:29:07 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nf 3/5] netfilter: nat: include zone id in nat table hash again
Date:   Wed,  8 Sep 2021 14:28:37 +0200
Message-Id: <20210908122839.7526-5-fw@strlen.de>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210908122839.7526-1-fw@strlen.de>
References: <20210908122839.7526-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Similar to the conntrack change, also use the zone id for the nat source
lists if the zone id is valid in both directions.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nf_nat_core.c | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/net/netfilter/nf_nat_core.c b/net/netfilter/nf_nat_core.c
index 7008961f5cb0..273117683922 100644
--- a/net/netfilter/nf_nat_core.c
+++ b/net/netfilter/nf_nat_core.c
@@ -150,13 +150,16 @@ static void __nf_nat_decode_session(struct sk_buff *skb, struct flowi *fl)
 
 /* We keep an extra hash for each conntrack, for fast searching. */
 static unsigned int
-hash_by_src(const struct net *n, const struct nf_conntrack_tuple *tuple)
+hash_by_src(const struct net *net,
+	    const struct nf_conntrack_zone *zone,
+	    const struct nf_conntrack_tuple *tuple)
 {
 	unsigned int hash;
 	struct {
 		struct nf_conntrack_man src;
 		u32 net_mix;
 		u32 protonum;
+		u32 zone;
 	} __aligned(SIPHASH_ALIGNMENT) combined;
 
 	get_random_once(&nf_nat_hash_rnd, sizeof(nf_nat_hash_rnd));
@@ -165,9 +168,13 @@ hash_by_src(const struct net *n, const struct nf_conntrack_tuple *tuple)
 
 	/* Original src, to ensure we map it consistently if poss. */
 	combined.src = tuple->src;
-	combined.net_mix = net_hash_mix(n);
+	combined.net_mix = net_hash_mix(net);
 	combined.protonum = tuple->dst.protonum;
 
+	/* Zone ID can be used provided its valid for both directions */
+	if (zone->dir == NF_CT_DEFAULT_ZONE_DIR)
+		combined.zone = zone->id;
+
 	hash = siphash(&combined, sizeof(combined), &nf_nat_hash_rnd);
 
 	return reciprocal_scale(hash, nf_nat_htable_size);
@@ -272,7 +279,7 @@ find_appropriate_src(struct net *net,
 		     struct nf_conntrack_tuple *result,
 		     const struct nf_nat_range2 *range)
 {
-	unsigned int h = hash_by_src(net, tuple);
+	unsigned int h = hash_by_src(net, zone, tuple);
 	const struct nf_conn *ct;
 
 	hlist_for_each_entry_rcu(ct, &nf_nat_bysource[h], nat_bysource) {
@@ -619,7 +626,7 @@ nf_nat_setup_info(struct nf_conn *ct,
 		unsigned int srchash;
 		spinlock_t *lock;
 
-		srchash = hash_by_src(net,
+		srchash = hash_by_src(net, nf_ct_zone(ct),
 				      &ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple);
 		lock = &nf_nat_locks[srchash % CONNTRACK_LOCKS];
 		spin_lock_bh(lock);
@@ -788,7 +795,7 @@ static void __nf_nat_cleanup_conntrack(struct nf_conn *ct)
 {
 	unsigned int h;
 
-	h = hash_by_src(nf_ct_net(ct), &ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple);
+	h = hash_by_src(nf_ct_net(ct), nf_ct_zone(ct), &ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple);
 	spin_lock_bh(&nf_nat_locks[h % CONNTRACK_LOCKS]);
 	hlist_del_rcu(&ct->nat_bysource);
 	spin_unlock_bh(&nf_nat_locks[h % CONNTRACK_LOCKS]);
-- 
2.32.0

