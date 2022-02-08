Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7CCC7C433F5
	for <netfilter-devel@archiver.kernel.org>; Tue,  8 Feb 2022 11:32:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232380AbiBHLcv (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 8 Feb 2022 06:32:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357310AbiBHLaq (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 8 Feb 2022 06:30:46 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBD84C03C1B0
        for <netfilter-devel@vger.kernel.org>; Tue,  8 Feb 2022 03:29:54 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1nHOgy-0004d5-DX; Tue, 08 Feb 2022 12:29:52 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next] netfilter: cttimeout: use option structure
Date:   Tue,  8 Feb 2022 12:29:47 +0100
Message-Id: <20220208112947.26405-1-fw@strlen.de>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Instead of two exported functions, export a single option structure.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/net/netfilter/nf_conntrack_timeout.h |  8 +++--
 net/netfilter/nf_conntrack_timeout.c         | 31 ++++++++------------
 net/netfilter/nfnetlink_cttimeout.c          | 11 ++++---
 3 files changed, 26 insertions(+), 24 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack_timeout.h b/include/net/netfilter/nf_conntrack_timeout.h
index db507e4a65bb..3ea94f6f3844 100644
--- a/include/net/netfilter/nf_conntrack_timeout.h
+++ b/include/net/netfilter/nf_conntrack_timeout.h
@@ -108,8 +108,12 @@ static inline void nf_ct_destroy_timeout(struct nf_conn *ct)
 #endif /* CONFIG_NF_CONNTRACK_TIMEOUT */
 
 #ifdef CONFIG_NF_CONNTRACK_TIMEOUT
-extern struct nf_ct_timeout *(*nf_ct_timeout_find_get_hook)(struct net *net, const char *name);
-extern void (*nf_ct_timeout_put_hook)(struct nf_ct_timeout *timeout);
+struct nf_ct_timeout_hooks {
+	struct nf_ct_timeout *(*timeout_find_get)(struct net *net, const char *name);
+	void (*timeout_put)(struct nf_ct_timeout *timeout);
+};
+
+extern const struct nf_ct_timeout_hooks *nf_ct_timeout_hook;
 #endif
 
 #endif /* _NF_CONNTRACK_TIMEOUT_H */
diff --git a/net/netfilter/nf_conntrack_timeout.c b/net/netfilter/nf_conntrack_timeout.c
index cd76ccca25e8..cec166ecba77 100644
--- a/net/netfilter/nf_conntrack_timeout.c
+++ b/net/netfilter/nf_conntrack_timeout.c
@@ -22,12 +22,8 @@
 #include <net/netfilter/nf_conntrack_l4proto.h>
 #include <net/netfilter/nf_conntrack_timeout.h>
 
-struct nf_ct_timeout *
-(*nf_ct_timeout_find_get_hook)(struct net *net, const char *name) __read_mostly;
-EXPORT_SYMBOL_GPL(nf_ct_timeout_find_get_hook);
-
-void (*nf_ct_timeout_put_hook)(struct nf_ct_timeout *timeout) __read_mostly;
-EXPORT_SYMBOL_GPL(nf_ct_timeout_put_hook);
+const struct nf_ct_timeout_hooks *nf_ct_timeout_hook __read_mostly;
+EXPORT_SYMBOL_GPL(nf_ct_timeout_hook);
 
 static int untimeout(struct nf_conn *ct, void *timeout)
 {
@@ -48,31 +44,30 @@ EXPORT_SYMBOL_GPL(nf_ct_untimeout);
 
 static void __nf_ct_timeout_put(struct nf_ct_timeout *timeout)
 {
-	typeof(nf_ct_timeout_put_hook) timeout_put;
+	const struct nf_ct_timeout_hooks *h = rcu_dereference(nf_ct_timeout_hook);
 
-	timeout_put = rcu_dereference(nf_ct_timeout_put_hook);
-	if (timeout_put)
-		timeout_put(timeout);
+	if (h)
+		h->timeout_put(timeout);
 }
 
 int nf_ct_set_timeout(struct net *net, struct nf_conn *ct,
 		      u8 l3num, u8 l4num, const char *timeout_name)
 {
-	typeof(nf_ct_timeout_find_get_hook) timeout_find_get;
+	const struct nf_ct_timeout_hooks *h;
 	struct nf_ct_timeout *timeout;
 	struct nf_conn_timeout *timeout_ext;
 	const char *errmsg = NULL;
 	int ret = 0;
 
 	rcu_read_lock();
-	timeout_find_get = rcu_dereference(nf_ct_timeout_find_get_hook);
-	if (!timeout_find_get) {
+	h = rcu_dereference(nf_ct_timeout_hook);
+	if (!h) {
 		ret = -ENOENT;
 		errmsg = "Timeout policy base is empty";
 		goto out;
 	}
 
-	timeout = timeout_find_get(net, timeout_name);
+	timeout = h->timeout_find_get(net, timeout_name);
 	if (!timeout) {
 		ret = -ENOENT;
 		pr_info_ratelimited("No such timeout policy \"%s\"\n",
@@ -119,15 +114,15 @@ EXPORT_SYMBOL_GPL(nf_ct_set_timeout);
 void nf_ct_destroy_timeout(struct nf_conn *ct)
 {
 	struct nf_conn_timeout *timeout_ext;
-	typeof(nf_ct_timeout_put_hook) timeout_put;
+	const struct nf_ct_timeout_hooks *h;
 
 	rcu_read_lock();
-	timeout_put = rcu_dereference(nf_ct_timeout_put_hook);
+	h = rcu_dereference(nf_ct_timeout_hook);
 
-	if (timeout_put) {
+	if (h) {
 		timeout_ext = nf_ct_timeout_find(ct);
 		if (timeout_ext) {
-			timeout_put(timeout_ext->timeout);
+			h->timeout_put(timeout_ext->timeout);
 			RCU_INIT_POINTER(timeout_ext->timeout, NULL);
 		}
 	}
diff --git a/net/netfilter/nfnetlink_cttimeout.c b/net/netfilter/nfnetlink_cttimeout.c
index c57673d499be..b0d8888a539b 100644
--- a/net/netfilter/nfnetlink_cttimeout.c
+++ b/net/netfilter/nfnetlink_cttimeout.c
@@ -605,6 +605,11 @@ static struct pernet_operations cttimeout_ops = {
 	.size   = sizeof(struct nfct_timeout_pernet),
 };
 
+static const struct nf_ct_timeout_hooks hooks = {
+	.timeout_find_get = ctnl_timeout_find_get,
+	.timeout_put = ctnl_timeout_put,
+};
+
 static int __init cttimeout_init(void)
 {
 	int ret;
@@ -619,8 +624,7 @@ static int __init cttimeout_init(void)
 			"nfnetlink.\n");
 		goto err_out;
 	}
-	RCU_INIT_POINTER(nf_ct_timeout_find_get_hook, ctnl_timeout_find_get);
-	RCU_INIT_POINTER(nf_ct_timeout_put_hook, ctnl_timeout_put);
+	RCU_INIT_POINTER(nf_ct_timeout_hook, &hooks);
 	return 0;
 
 err_out:
@@ -633,8 +637,7 @@ static void __exit cttimeout_exit(void)
 	nfnetlink_subsys_unregister(&cttimeout_subsys);
 
 	unregister_pernet_subsys(&cttimeout_ops);
-	RCU_INIT_POINTER(nf_ct_timeout_find_get_hook, NULL);
-	RCU_INIT_POINTER(nf_ct_timeout_put_hook, NULL);
+	RCU_INIT_POINTER(nf_ct_timeout_hook, NULL);
 	synchronize_rcu();
 }
 
-- 
2.34.1

