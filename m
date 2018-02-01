From: Cong Wang <xiyou.wangcong@gmail.com>
Subject: [Patch net] xt_RATEEST: acquire xt_rateest_mutex for hash insert
Date: Wed, 31 Jan 2018 16:26:31 -0800
Message-ID: <20180201002631.17638-1-xiyou.wangcong@gmail.com>
Cc: netfilter-devel@vger.kernel.org,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>
To: netdev@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:45410 "EHLO
        mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753461AbeBAA0m (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 31 Jan 2018 19:26:42 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

rateest_hash is supposed to be protected by xt_rateest_mutex.

Reported-by: <syzbot+5cb189720978275e4c75@syzkaller.appspotmail.com>
Fixes: 5859034d7eb8 ("[NETFILTER]: x_tables: add RATEEST target")
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
---
 net/netfilter/xt_RATEEST.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/netfilter/xt_RATEEST.c b/net/netfilter/xt_RATEEST.c
index 498b54fd04d7..83ec3a282755 100644
--- a/net/netfilter/xt_RATEEST.c
+++ b/net/netfilter/xt_RATEEST.c
@@ -36,7 +36,9 @@ static void xt_rateest_hash_insert(struct xt_rateest *est)
 	unsigned int h;
 
 	h = xt_rateest_hash(est->name);
+	mutex_lock(&xt_rateest_mutex);
 	hlist_add_head(&est->list, &rateest_hash[h]);
+	mutex_unlock(&xt_rateest_mutex);
 }
 
 struct xt_rateest *xt_rateest_lookup(const char *name)
-- 
2.13.0

