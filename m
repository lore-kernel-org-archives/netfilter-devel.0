Return-Path: <SRS0=/MqZ=RG=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3C54C43381
	for <netfilter-devel@archiver.kernel.org>; Sun,  3 Mar 2019 09:12:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9DDDB20836
	for <netfilter-devel@archiver.kernel.org>; Sun,  3 Mar 2019 09:12:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726095AbfCCJMh (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 3 Mar 2019 04:12:37 -0500
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:39180 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725923AbfCCJMh (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 3 Mar 2019 04:12:37 -0500
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.89)
        (envelope-from <fw@breakpoint.cc>)
        id 1h0NAg-0007pc-MK; Sun, 03 Mar 2019 10:12:34 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next] netfilter: nat: don't use same refcount for notifiers
Date:   Sun,  3 Mar 2019 10:13:32 +0100
Message-Id: <20190303091332.7287-1-fw@strlen.de>
X-Mailer: git-send-email 2.19.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Otherwise, when ipv4 gets registered first, ipv6 registration is a
no-op, and vice versa.  Just use different refcounts for both.

The effect will be that either ipv4 or ipv6 flows that are masqueraded
won't be deleted when the masquerading interface had its address changed.

Fixes: d1aca8ab3104a ("netfilter: nat: merge ipv4 and ipv6 masquerade functionality")
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nf_nat_masquerade.c | 25 ++++++++++++++++++-------
 1 file changed, 18 insertions(+), 7 deletions(-)

diff --git a/net/netfilter/nf_nat_masquerade.c b/net/netfilter/nf_nat_masquerade.c
index 86fa4dcc63c5..9f7a51309479 100644
--- a/net/netfilter/nf_nat_masquerade.c
+++ b/net/netfilter/nf_nat_masquerade.c
@@ -11,7 +11,8 @@
 #include <net/netfilter/ipv6/nf_nat_masquerade.h>
 
 static DEFINE_MUTEX(masq_mutex);
-static unsigned int masq_refcnt __read_mostly;
+static unsigned int masq_refcnt4 __read_mostly;
+static unsigned int masq_refcnt6 __read_mostly;
 
 unsigned int
 nf_nat_masquerade_ipv4(struct sk_buff *skb, unsigned int hooknum,
@@ -141,8 +142,13 @@ int nf_nat_masquerade_ipv4_register_notifier(void)
 	int ret = 0;
 
 	mutex_lock(&masq_mutex);
+	if (WARN_ON_ONCE(masq_refcnt4 == UINT_MAX)) {
+		ret = -EOVERFLOW;
+		goto out_unlock;
+	}
+
 	/* check if the notifier was already set */
-	if (++masq_refcnt > 1)
+	if (++masq_refcnt4 > 1)
 		goto out_unlock;
 
 	/* Register for device down reports */
@@ -160,7 +166,7 @@ int nf_nat_masquerade_ipv4_register_notifier(void)
 err_unregister:
 	unregister_netdevice_notifier(&masq_dev_notifier);
 err_dec:
-	masq_refcnt--;
+	masq_refcnt4--;
 out_unlock:
 	mutex_unlock(&masq_mutex);
 	return ret;
@@ -171,7 +177,7 @@ void nf_nat_masquerade_ipv4_unregister_notifier(void)
 {
 	mutex_lock(&masq_mutex);
 	/* check if the notifier still has clients */
-	if (--masq_refcnt > 0)
+	if (--masq_refcnt4 > 0)
 		goto out_unlock;
 
 	unregister_netdevice_notifier(&masq_dev_notifier);
@@ -321,8 +327,13 @@ int nf_nat_masquerade_ipv6_register_notifier(void)
 	int ret = 0;
 
 	mutex_lock(&masq_mutex);
+	if (WARN_ON_ONCE(masq_refcnt6 == UINT_MAX)) {
+		ret = -EOVERFLOW;
+		goto out_unlock;
+	}
+
 	/* check if the notifier is already set */
-	if (++masq_refcnt > 1)
+	if (++masq_refcnt6 > 1)
 		goto out_unlock;
 
 	ret = register_netdevice_notifier(&masq_dev_notifier);
@@ -339,7 +350,7 @@ int nf_nat_masquerade_ipv6_register_notifier(void)
 err_unregister:
 	unregister_netdevice_notifier(&masq_dev_notifier);
 err_dec:
-	masq_refcnt--;
+	masq_refcnt6--;
 out_unlock:
 	mutex_unlock(&masq_mutex);
 	return ret;
@@ -350,7 +361,7 @@ void nf_nat_masquerade_ipv6_unregister_notifier(void)
 {
 	mutex_lock(&masq_mutex);
 	/* check if the notifier still has clients */
-	if (--masq_refcnt > 0)
+	if (--masq_refcnt6 > 0)
 		goto out_unlock;
 
 	unregister_inet6addr_notifier(&masq_inet6_notifier);
-- 
2.19.2

