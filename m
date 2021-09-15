Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14871C433EF
	for <netfilter-devel@archiver.kernel.org>; Wed, 15 Sep 2021 14:46:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E740860F48
	for <netfilter-devel@archiver.kernel.org>; Wed, 15 Sep 2021 14:46:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237989AbhIOOsJ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 15 Sep 2021 10:48:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237982AbhIOOsJ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 15 Sep 2021 10:48:09 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13090C061574
        for <netfilter-devel@vger.kernel.org>; Wed, 15 Sep 2021 07:46:50 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1mQWBU-0005kH-8u; Wed, 15 Sep 2021 16:46:48 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nf 1/2] netfilter: nf_nat_masquerade: make async masq_inet6_event handling generic
Date:   Wed, 15 Sep 2021 16:46:38 +0200
Message-Id: <20210915144639.25024-2-fw@strlen.de>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210915144639.25024-1-fw@strlen.de>
References: <20210915144639.25024-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

masq_inet6_event is called asynchronously from system work queue,
because the inet6 notifier is atomic and nf_iterate_cleanup can sleep.

The ipv4 and device notifiers call nf_iterate_cleanup directly.

This is legal, but these notifiers are called with RTNL mutex held.
A large conntrack table with many devices coming and going will have severe
impact on the system usability, with 'ip a' blocking for several seconds.

This change places the defer code into a helper and makes it more
generic so ipv4 and ifdown notifiers can be converted to defer the
cleanup walk as well in a follow patch.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nf_nat_masquerade.c | 122 ++++++++++++++++++------------
 1 file changed, 75 insertions(+), 47 deletions(-)

diff --git a/net/netfilter/nf_nat_masquerade.c b/net/netfilter/nf_nat_masquerade.c
index 8e8a65d46345..415919a6ac1a 100644
--- a/net/netfilter/nf_nat_masquerade.c
+++ b/net/netfilter/nf_nat_masquerade.c
@@ -9,8 +9,19 @@
 
 #include <net/netfilter/nf_nat_masquerade.h>
 
+struct masq_dev_work {
+	struct work_struct work;
+	struct net *net;
+	union nf_inet_addr addr;
+	int ifindex;
+	int (*iter)(struct nf_conn *i, void *data);
+};
+
+#define MAX_MASQ_WORKER_COUNT	16
+
 static DEFINE_MUTEX(masq_mutex);
 static unsigned int masq_refcnt __read_mostly;
+static atomic_t masq_worker_count __read_mostly;
 
 unsigned int
 nf_nat_masquerade_ipv4(struct sk_buff *skb, unsigned int hooknum,
@@ -63,6 +74,63 @@ nf_nat_masquerade_ipv4(struct sk_buff *skb, unsigned int hooknum,
 }
 EXPORT_SYMBOL_GPL(nf_nat_masquerade_ipv4);
 
+static void iterate_cleanup_work(struct work_struct *work)
+{
+	struct masq_dev_work *w;
+
+	w = container_of(work, struct masq_dev_work, work);
+
+	nf_ct_iterate_cleanup_net(w->net, w->iter, (void *)w, 0, 0);
+
+	put_net(w->net);
+	kfree(w);
+	atomic_dec(&masq_worker_count);
+	module_put(THIS_MODULE);
+}
+
+/* Iterate conntrack table in the background and remove conntrack entries
+ * that use the device/address being removed.
+ *
+ * In case too many work items have been queued already or memory allocation
+ * fails iteration is skipped, conntrack entries will time out eventually.
+ */
+static void nf_nat_masq_schedule(struct net *net, union nf_inet_addr *addr,
+				 int ifindex,
+				 int (*iter)(struct nf_conn *i, void *data),
+				 gfp_t gfp_flags)
+{
+	struct masq_dev_work *w;
+
+	if (atomic_read(&masq_worker_count) > MAX_MASQ_WORKER_COUNT)
+		return;
+
+	net = maybe_get_net(net);
+	if (!net)
+		return;
+
+	if (!try_module_get(THIS_MODULE))
+		goto err_module;
+
+	w = kzalloc(sizeof(*w), gfp_flags);
+	if (w) {
+		/* We can overshoot MAX_MASQ_WORKER_COUNT, no big deal */
+		atomic_inc(&masq_worker_count);
+
+		INIT_WORK(&w->work, iterate_cleanup_work);
+		w->ifindex = ifindex;
+		w->net = net;
+		w->iter = iter;
+		if (addr)
+			w->addr = *addr;
+		schedule_work(&w->work);
+		return;
+	}
+
+	module_put(THIS_MODULE);
+ err_module:
+	put_net(net);
+}
+
 static int device_cmp(struct nf_conn *i, void *ifindex)
 {
 	const struct nf_conn_nat *nat = nfct_nat(i);
@@ -136,8 +204,6 @@ static struct notifier_block masq_inet_notifier = {
 };
 
 #if IS_ENABLED(CONFIG_IPV6)
-static atomic_t v6_worker_count __read_mostly;
-
 static int
 nat_ipv6_dev_get_saddr(struct net *net, const struct net_device *dev,
 		       const struct in6_addr *daddr, unsigned int srcprefs,
@@ -187,13 +253,6 @@ nf_nat_masquerade_ipv6(struct sk_buff *skb, const struct nf_nat_range2 *range,
 }
 EXPORT_SYMBOL_GPL(nf_nat_masquerade_ipv6);
 
-struct masq_dev_work {
-	struct work_struct work;
-	struct net *net;
-	struct in6_addr addr;
-	int ifindex;
-};
-
 static int inet6_cmp(struct nf_conn *ct, void *work)
 {
 	struct masq_dev_work *w = (struct masq_dev_work *)work;
@@ -204,21 +263,7 @@ static int inet6_cmp(struct nf_conn *ct, void *work)
 
 	tuple = &ct->tuplehash[IP_CT_DIR_REPLY].tuple;
 
-	return ipv6_addr_equal(&w->addr, &tuple->dst.u3.in6);
-}
-
-static void iterate_cleanup_work(struct work_struct *work)
-{
-	struct masq_dev_work *w;
-
-	w = container_of(work, struct masq_dev_work, work);
-
-	nf_ct_iterate_cleanup_net(w->net, inet6_cmp, (void *)w, 0, 0);
-
-	put_net(w->net);
-	kfree(w);
-	atomic_dec(&v6_worker_count);
-	module_put(THIS_MODULE);
+	return nf_inet_addr_cmp(&w->addr, &tuple->dst.u3);
 }
 
 /* atomic notifier; can't call nf_ct_iterate_cleanup_net (it can sleep).
@@ -233,36 +278,19 @@ static int masq_inet6_event(struct notifier_block *this,
 {
 	struct inet6_ifaddr *ifa = ptr;
 	const struct net_device *dev;
-	struct masq_dev_work *w;
-	struct net *net;
+	union nf_inet_addr addr;
 
-	if (event != NETDEV_DOWN || atomic_read(&v6_worker_count) >= 16)
+	if (event != NETDEV_DOWN)
 		return NOTIFY_DONE;
 
 	dev = ifa->idev->dev;
-	net = maybe_get_net(dev_net(dev));
-	if (!net)
-		return NOTIFY_DONE;
 
-	if (!try_module_get(THIS_MODULE))
-		goto err_module;
+	memset(&addr, 0, sizeof(addr));
 
-	w = kmalloc(sizeof(*w), GFP_ATOMIC);
-	if (w) {
-		atomic_inc(&v6_worker_count);
+	addr.in6 = ifa->addr;
 
-		INIT_WORK(&w->work, iterate_cleanup_work);
-		w->ifindex = dev->ifindex;
-		w->net = net;
-		w->addr = ifa->addr;
-		schedule_work(&w->work);
-
-		return NOTIFY_DONE;
-	}
-
-	module_put(THIS_MODULE);
- err_module:
-	put_net(net);
+	nf_nat_masq_schedule(dev_net(dev), &addr, dev->ifindex, inet6_cmp,
+			     GFP_ATOMIC);
 	return NOTIFY_DONE;
 }
 
-- 
2.32.0

