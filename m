Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2C84C11F64
	for <netfilter-devel@archiver.kernel.org>; Thu,  1 Jul 2021 05:02:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AEFD1613FC
	for <netfilter-devel@archiver.kernel.org>; Thu,  1 Jul 2021 05:02:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231982AbhGAFE5 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 1 Jul 2021 01:04:57 -0400
Received: from relay.sw.ru ([185.231.240.75]:50828 "EHLO relay.sw.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230293AbhGAFE5 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 1 Jul 2021 01:04:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=virtuozzo.com; s=relay; h=Content-Type:MIME-Version:Date:Message-ID:Subject
        :From; bh=j+NnwwOJ1AMrdrJeNJZBPanrIefil1SM4Aq4CQtIjvI=; b=AfqsE7m2NsBgi6LznP5
        hI5UIwMBs4bJyDrD6qhiOhXuFkUoqWqhxzzvZXiK52/Hj6OB/8rUpn2yAn/247Lbalv04zoMCJlk+
        dCuINJyqI86JYTDYznvUL7toQq+OHo2aCUtfa7T+VpVdN7O/3szOzFG4S7UaOi5UMeMd6ofbOt0=;
Received: from [10.93.0.56]
        by relay.sw.ru with esmtp (Exim 4.94.2)
        (envelope-from <vvs@virtuozzo.com>)
        id 1lYVtY-002Tjh-IM; Thu, 01 Jul 2021 08:02:25 +0300
From:   Vasily Averin <vvs@virtuozzo.com>
Subject: [PATCH NETFILTER v2] netfilter: gre: nf_ct_gre_keymap_flush() removal
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        linux-kernel@vger.kernel.org
Message-ID: <0e3cdbe6-33f7-60b0-64ca-72f6f6a42df8@virtuozzo.com>
Date:   Thu, 1 Jul 2021 08:02:24 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

nf_ct_gre_keymap_flush() is useless.
It is called from nf_conntrack_cleanup_net_list() only and tries to remove
nf_ct_gre_keymap entries from pernet gre keymap list. Though:
a) at this point the list should already be empty, all its entries were
deleted during the conntracks cleanup, because
nf_conntrack_cleanup_net_list() executes nf_ct_iterate_cleanup(kill_all)
before nf_conntrack_proto_pernet_fini():
 nf_conntrack_cleanup_net_list
  +- nf_ct_iterate_cleanup
  |   nf_ct_put
  |    nf_conntrack_put
  |     nf_conntrack_destroy
  |      destroy_conntrack
  |       destroy_gre_conntrack
  |        nf_ct_gre_keymap_destroy
  `- nf_conntrack_proto_pernet_fini
      nf_ct_gre_keymap_flush

b) Let's say we find that the keymap list is not empty. This means netns
still has a conntrack associated with gre, in which case we should not free
its memory, because this will lead to a double free and related crashes.
However I doubt it could have gone unnoticed for years, obviously
this does not happen in real life. So I think we can remove
both nf_ct_gre_keymap_flush() and nf_conntrack_proto_pernet_fini().

Signed-off-by: Vasily Averin <vvs@virtuozzo.com>
Acked-by: Florian Westphal <fw@strlen.de>
---
v2: resent, original letter was graylisted

 include/net/netfilter/nf_conntrack_core.h |  1 -
 net/netfilter/nf_conntrack_core.c         |  1 -
 net/netfilter/nf_conntrack_proto.c        |  7 -------
 net/netfilter/nf_conntrack_proto_gre.c    | 13 -------------
 4 files changed, 22 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack_core.h b/include/net/netfilter/nf_conntrack_core.h
index 09f2efea0b97..13807ea94cd2 100644
--- a/include/net/netfilter/nf_conntrack_core.h
+++ b/include/net/netfilter/nf_conntrack_core.h
@@ -30,7 +30,6 @@ void nf_conntrack_cleanup_net(struct net *net);
 void nf_conntrack_cleanup_net_list(struct list_head *net_exit_list);
 
 void nf_conntrack_proto_pernet_init(struct net *net);
-void nf_conntrack_proto_pernet_fini(struct net *net);
 
 int nf_conntrack_proto_init(void);
 void nf_conntrack_proto_fini(void);
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index e0befcf8113a..ad53666120e9 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -2461,7 +2461,6 @@ void nf_conntrack_cleanup_net_list(struct list_head *net_exit_list)
 	}
 
 	list_for_each_entry(net, net_exit_list, exit_list) {
-		nf_conntrack_proto_pernet_fini(net);
 		nf_conntrack_ecache_pernet_fini(net);
 		nf_conntrack_expect_pernet_fini(net);
 		free_percpu(net->ct.stat);
diff --git a/net/netfilter/nf_conntrack_proto.c b/net/netfilter/nf_conntrack_proto.c
index 89e5bac384d7..2ca25aaad032 100644
--- a/net/netfilter/nf_conntrack_proto.c
+++ b/net/netfilter/nf_conntrack_proto.c
@@ -697,13 +697,6 @@ void nf_conntrack_proto_pernet_init(struct net *net)
 #endif
 }
 
-void nf_conntrack_proto_pernet_fini(struct net *net)
-{
-#ifdef CONFIG_NF_CT_PROTO_GRE
-	nf_ct_gre_keymap_flush(net);
-#endif
-}
-
 module_param_call(hashsize, nf_conntrack_set_hashsize, param_get_uint,
 		  &nf_conntrack_htable_size, 0600);
 
diff --git a/net/netfilter/nf_conntrack_proto_gre.c b/net/netfilter/nf_conntrack_proto_gre.c
index db11e403d818..728eeb0aea87 100644
--- a/net/netfilter/nf_conntrack_proto_gre.c
+++ b/net/netfilter/nf_conntrack_proto_gre.c
@@ -55,19 +55,6 @@ static inline struct nf_gre_net *gre_pernet(struct net *net)
 	return &net->ct.nf_ct_proto.gre;
 }
 
-void nf_ct_gre_keymap_flush(struct net *net)
-{
-	struct nf_gre_net *net_gre = gre_pernet(net);
-	struct nf_ct_gre_keymap *km, *tmp;
-
-	spin_lock_bh(&keymap_lock);
-	list_for_each_entry_safe(km, tmp, &net_gre->keymap_list, list) {
-		list_del_rcu(&km->list);
-		kfree_rcu(km, rcu);
-	}
-	spin_unlock_bh(&keymap_lock);
-}
-
 static inline int gre_key_cmpfn(const struct nf_ct_gre_keymap *km,
 				const struct nf_conntrack_tuple *t)
 {
-- 
2.25.1

