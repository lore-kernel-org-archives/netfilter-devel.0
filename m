From: gfree.wind@foxmail.com
Subject: [PATCH nf-next 1/1] netfilter: expect: Add one common func nf_ct_remove_expect to simplify codes
Date: Mon, 27 Mar 2017 10:31:26 +0800
Message-ID: <1490581886-53648-1-git-send-email-gfree.wind@foxmail.com>
Cc: Gao Feng <fgao@ikuai8.com>
To: pablo@netfilter.org, netfilter-devel@vger.kernel.org,
        gfree.wind@foxmail.com
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtpbgsg2.qq.com ([54.254.200.128]:38209 "EHLO smtpbgsg2.qq.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751753AbdC0Cbm (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 26 Mar 2017 22:31:42 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Gao Feng <fgao@ikuai8.com>

When remove one expect, it needs three statements. And there are
multiple duplicated codes in current codes. So add one common func
nf_ct_remove_expect to simplify the codes.

Signed-off-by: Gao Feng <fgao@ikuai8.com>
---
 include/net/netfilter/nf_conntrack_expect.h |  1 +
 net/netfilter/nf_conntrack_expect.c         | 33 +++++++++++++++--------------
 net/netfilter/nf_conntrack_helper.c         |  6 ++----
 net/netfilter/nf_conntrack_sip.c            |  4 +---
 4 files changed, 21 insertions(+), 23 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack_expect.h b/include/net/netfilter/nf_conntrack_expect.h
index 65cc2cb..dff3068 100644
--- a/include/net/netfilter/nf_conntrack_expect.h
+++ b/include/net/netfilter/nf_conntrack_expect.h
@@ -104,6 +104,7 @@ static inline void nf_ct_unlink_expect(struct nf_conntrack_expect *exp)
 
 void nf_ct_remove_expectations(struct nf_conn *ct);
 void nf_ct_unexpect_related(struct nf_conntrack_expect *exp);
+bool nf_ct_remove_expect(struct nf_conntrack_expect *exp);
 
 /* Allocate space for an expectation: this is mandatory before calling
    nf_ct_expect_related.  You will have to call put afterwards. */
diff --git a/net/netfilter/nf_conntrack_expect.c b/net/netfilter/nf_conntrack_expect.c
index cb29e59..bbffe6a 100644
--- a/net/netfilter/nf_conntrack_expect.c
+++ b/net/netfilter/nf_conntrack_expect.c
@@ -103,6 +103,18 @@ static unsigned int nf_ct_expect_dst_hash(const struct net *n, const struct nf_c
 	       nf_ct_zone_equal_any(i->master, zone);
 }
 
+bool
+nf_ct_remove_expect(struct nf_conntrack_expect *exp)
+{
+	if (del_timer(&exp->timeout)) {
+		nf_ct_unlink_expect(exp);
+		nf_ct_expect_put(exp);
+		return true;
+	}
+	return false;
+}
+EXPORT_SYMBOL_GPL(nf_ct_remove_expect);
+
 struct nf_conntrack_expect *
 __nf_ct_expect_find(struct net *net,
 		    const struct nf_conntrack_zone *zone,
@@ -211,10 +223,7 @@ void nf_ct_remove_expectations(struct nf_conn *ct)
 
 	spin_lock_bh(&nf_conntrack_expect_lock);
 	hlist_for_each_entry_safe(exp, next, &help->expectations, lnode) {
-		if (del_timer(&exp->timeout)) {
-			nf_ct_unlink_expect(exp);
-			nf_ct_expect_put(exp);
-		}
+		nf_ct_remove_expect(exp);
 	}
 	spin_unlock_bh(&nf_conntrack_expect_lock);
 }
@@ -255,10 +264,7 @@ static inline int expect_matches(const struct nf_conntrack_expect *a,
 void nf_ct_unexpect_related(struct nf_conntrack_expect *exp)
 {
 	spin_lock_bh(&nf_conntrack_expect_lock);
-	if (del_timer(&exp->timeout)) {
-		nf_ct_unlink_expect(exp);
-		nf_ct_expect_put(exp);
-	}
+	nf_ct_remove_expect(exp);
 	spin_unlock_bh(&nf_conntrack_expect_lock);
 }
 EXPORT_SYMBOL_GPL(nf_ct_unexpect_related);
@@ -394,10 +400,8 @@ static void evict_oldest_expect(struct nf_conn *master,
 			last = exp;
 	}
 
-	if (last && del_timer(&last->timeout)) {
-		nf_ct_unlink_expect(last);
-		nf_ct_expect_put(last);
-	}
+	if (last)
+		nf_ct_remove_expect(last);
 }
 
 static inline int __nf_ct_expect_check(struct nf_conntrack_expect *expect)
@@ -419,11 +423,8 @@ static inline int __nf_ct_expect_check(struct nf_conntrack_expect *expect)
 	h = nf_ct_expect_dst_hash(net, &expect->tuple);
 	hlist_for_each_entry_safe(i, next, &nf_ct_expect_hash[h], hnode) {
 		if (expect_matches(i, expect)) {
-			if (del_timer(&i->timeout)) {
-				nf_ct_unlink_expect(i);
-				nf_ct_expect_put(i);
+			if (nf_ct_remove_expect(expect))
 				break;
-			}
 		} else if (expect_clash(i, expect)) {
 			ret = -EBUSY;
 			goto out;
diff --git a/net/netfilter/nf_conntrack_helper.c b/net/netfilter/nf_conntrack_helper.c
index 6dc44d9..97bc0d2 100644
--- a/net/netfilter/nf_conntrack_helper.c
+++ b/net/netfilter/nf_conntrack_helper.c
@@ -448,10 +448,8 @@ void nf_conntrack_helper_unregister(struct nf_conntrack_helper *me)
 			if ((rcu_dereference_protected(
 					help->helper,
 					lockdep_is_held(&nf_conntrack_expect_lock)
-					) == me || exp->helper == me) &&
-			    del_timer(&exp->timeout)) {
-				nf_ct_unlink_expect(exp);
-				nf_ct_expect_put(exp);
+					) == me || exp->helper == me)) {
+				nf_ct_remove_expect(exp);
 			}
 		}
 	}
diff --git a/net/netfilter/nf_conntrack_sip.c b/net/netfilter/nf_conntrack_sip.c
index 0d17894..91a9c97 100644
--- a/net/netfilter/nf_conntrack_sip.c
+++ b/net/netfilter/nf_conntrack_sip.c
@@ -829,10 +829,8 @@ static void flush_expectations(struct nf_conn *ct, bool media)
 	hlist_for_each_entry_safe(exp, next, &help->expectations, lnode) {
 		if ((exp->class != SIP_EXPECT_SIGNALLING) ^ media)
 			continue;
-		if (!del_timer(&exp->timeout))
+		if (!nf_ct_remove_expect(exp))
 			continue;
-		nf_ct_unlink_expect(exp);
-		nf_ct_expect_put(exp);
 		if (!media)
 			break;
 	}
-- 
1.9.1




