Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9929AC433EF
	for <netfilter-devel@archiver.kernel.org>; Wed, 15 Sep 2021 14:47:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8278960E90
	for <netfilter-devel@archiver.kernel.org>; Wed, 15 Sep 2021 14:47:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238017AbhIOOsQ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 15 Sep 2021 10:48:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237980AbhIOOsN (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 15 Sep 2021 10:48:13 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64344C061575
        for <netfilter-devel@vger.kernel.org>; Wed, 15 Sep 2021 07:46:54 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1mQWBY-0005kW-Q5; Wed, 15 Sep 2021 16:46:52 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>,
        Martin Zaharinov <micron10@gmail.com>
Subject: [PATCH nf 2/2] netfilter: nf_nat_masquerade: defer conntrack walk to work queue
Date:   Wed, 15 Sep 2021 16:46:39 +0200
Message-Id: <20210915144639.25024-3-fw@strlen.de>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210915144639.25024-1-fw@strlen.de>
References: <20210915144639.25024-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The ipv4 and device notifiers are called with RTNL mutex held.
The table walk can take some time, better not block other RTNL users.

'ip a' has been reported to block for up to 20 seconds when conntrack table
has many entries and device down events are frequent (e.g., PPP).

Reported-and-tested-by: Martin Zaharinov <micron10@gmail.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nf_nat_masquerade.c | 50 +++++++++++++++----------------
 1 file changed, 24 insertions(+), 26 deletions(-)

diff --git a/net/netfilter/nf_nat_masquerade.c b/net/netfilter/nf_nat_masquerade.c
index 415919a6ac1a..acd73f717a08 100644
--- a/net/netfilter/nf_nat_masquerade.c
+++ b/net/netfilter/nf_nat_masquerade.c
@@ -131,13 +131,14 @@ static void nf_nat_masq_schedule(struct net *net, union nf_inet_addr *addr,
 	put_net(net);
 }
 
-static int device_cmp(struct nf_conn *i, void *ifindex)
+static int device_cmp(struct nf_conn *i, void *arg)
 {
 	const struct nf_conn_nat *nat = nfct_nat(i);
+	const struct masq_dev_work *w = arg;
 
 	if (!nat)
 		return 0;
-	return nat->masq_index == (int)(long)ifindex;
+	return nat->masq_index == w->ifindex;
 }
 
 static int masq_device_event(struct notifier_block *this,
@@ -153,8 +154,8 @@ static int masq_device_event(struct notifier_block *this,
 		 * and forget them.
 		 */
 
-		nf_ct_iterate_cleanup_net(net, device_cmp,
-					  (void *)(long)dev->ifindex, 0, 0);
+		nf_nat_masq_schedule(net, NULL, dev->ifindex,
+				     device_cmp, GFP_KERNEL);
 	}
 
 	return NOTIFY_DONE;
@@ -162,35 +163,45 @@ static int masq_device_event(struct notifier_block *this,
 
 static int inet_cmp(struct nf_conn *ct, void *ptr)
 {
-	struct in_ifaddr *ifa = (struct in_ifaddr *)ptr;
-	struct net_device *dev = ifa->ifa_dev->dev;
 	struct nf_conntrack_tuple *tuple;
+	struct masq_dev_work *w = ptr;
 
-	if (!device_cmp(ct, (void *)(long)dev->ifindex))
+	if (!device_cmp(ct, ptr))
 		return 0;
 
 	tuple = &ct->tuplehash[IP_CT_DIR_REPLY].tuple;
 
-	return ifa->ifa_address == tuple->dst.u3.ip;
+	return nf_inet_addr_cmp(&w->addr, &tuple->dst.u3);
 }
 
 static int masq_inet_event(struct notifier_block *this,
 			   unsigned long event,
 			   void *ptr)
 {
-	struct in_device *idev = ((struct in_ifaddr *)ptr)->ifa_dev;
-	struct net *net = dev_net(idev->dev);
+	const struct in_ifaddr *ifa = ptr;
+	const struct in_device *idev;
+	const struct net_device *dev;
+	union nf_inet_addr addr;
+
+	if (event != NETDEV_DOWN)
+		return NOTIFY_DONE;
 
 	/* The masq_dev_notifier will catch the case of the device going
 	 * down.  So if the inetdev is dead and being destroyed we have
 	 * no work to do.  Otherwise this is an individual address removal
 	 * and we have to perform the flush.
 	 */
+	idev = ifa->ifa_dev;
 	if (idev->dead)
 		return NOTIFY_DONE;
 
-	if (event == NETDEV_DOWN)
-		nf_ct_iterate_cleanup_net(net, inet_cmp, ptr, 0, 0);
+	memset(&addr, 0, sizeof(addr));
+
+	addr.ip = ifa->ifa_address;
+
+	dev = idev->dev;
+	nf_nat_masq_schedule(dev_net(idev->dev), &addr, dev->ifindex,
+			     inet_cmp, GFP_KERNEL);
 
 	return NOTIFY_DONE;
 }
@@ -253,19 +264,6 @@ nf_nat_masquerade_ipv6(struct sk_buff *skb, const struct nf_nat_range2 *range,
 }
 EXPORT_SYMBOL_GPL(nf_nat_masquerade_ipv6);
 
-static int inet6_cmp(struct nf_conn *ct, void *work)
-{
-	struct masq_dev_work *w = (struct masq_dev_work *)work;
-	struct nf_conntrack_tuple *tuple;
-
-	if (!device_cmp(ct, (void *)(long)w->ifindex))
-		return 0;
-
-	tuple = &ct->tuplehash[IP_CT_DIR_REPLY].tuple;
-
-	return nf_inet_addr_cmp(&w->addr, &tuple->dst.u3);
-}
-
 /* atomic notifier; can't call nf_ct_iterate_cleanup_net (it can sleep).
  *
  * Defer it to the system workqueue.
@@ -289,7 +287,7 @@ static int masq_inet6_event(struct notifier_block *this,
 
 	addr.in6 = ifa->addr;
 
-	nf_nat_masq_schedule(dev_net(dev), &addr, dev->ifindex, inet6_cmp,
+	nf_nat_masq_schedule(dev_net(dev), &addr, dev->ifindex, inet_cmp,
 			     GFP_ATOMIC);
 	return NOTIFY_DONE;
 }
-- 
2.32.0

