Return-Path: <SRS0=8PdD=RO=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19525C10F06
	for <netfilter-devel@archiver.kernel.org>; Mon, 11 Mar 2019 22:50:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E4DCC2087C
	for <netfilter-devel@archiver.kernel.org>; Mon, 11 Mar 2019 22:50:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726504AbfCKWup (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 11 Mar 2019 18:50:45 -0400
Received: from mail.us.es ([193.147.175.20]:34552 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726187AbfCKWup (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 11 Mar 2019 18:50:45 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 2446820991F
        for <netfilter-devel@vger.kernel.org>; Mon, 11 Mar 2019 23:50:43 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 150F6DA872
        for <netfilter-devel@vger.kernel.org>; Mon, 11 Mar 2019 23:50:43 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 0A4C0DA86E; Mon, 11 Mar 2019 23:50:43 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D7E8EDA85D;
        Mon, 11 Mar 2019 23:50:40 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 11 Mar 2019 23:50:40 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id A92504265A2F;
        Mon, 11 Mar 2019 23:50:40 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 1/5] netfilter: nat: don't register device notifier twice
Date:   Mon, 11 Mar 2019 23:50:31 +0100
Message-Id: <20190311225035.21250-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190311225035.21250-1-pablo@netfilter.org>
References: <20190311225035.21250-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

Otherwise, we get notifier list corruption.

This is the most simple fix: remove the device notifier call chain
from the ipv6 masquerade register function and handle it only
in the ipv4 version.

The better fix is merge
nf_nat_masquerade_ipv4/6_(un)register_notifier
  into a single
nf_nat_masquerade_(un)register_notifiers

but to do this its needed to first merge the two masquerade modules
into a single xt_MASQUERADE.

Furthermore, we need to use different refcounts for ipv4/ipv6
until we can merge MASQUERADE.

Fixes: d1aca8ab3104a ("netfilter: nat: merge ipv4 and ipv6 masquerade functionality")
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_nat_masquerade.c | 35 +++++++++++++++++++----------------
 1 file changed, 19 insertions(+), 16 deletions(-)

diff --git a/net/netfilter/nf_nat_masquerade.c b/net/netfilter/nf_nat_masquerade.c
index 86fa4dcc63c5..d85c4d902e7b 100644
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
@@ -321,25 +327,23 @@ int nf_nat_masquerade_ipv6_register_notifier(void)
 	int ret = 0;
 
 	mutex_lock(&masq_mutex);
-	/* check if the notifier is already set */
-	if (++masq_refcnt > 1)
+	if (WARN_ON_ONCE(masq_refcnt6 == UINT_MAX)) {
+		ret = -EOVERFLOW;
 		goto out_unlock;
+	}
 
-	ret = register_netdevice_notifier(&masq_dev_notifier);
-	if (ret)
-		goto err_dec;
+	/* check if the notifier is already set */
+	if (++masq_refcnt6 > 1)
+		goto out_unlock;
 
 	ret = register_inet6addr_notifier(&masq_inet6_notifier);
 	if (ret)
-		goto err_unregister;
+		goto err_dec;
 
 	mutex_unlock(&masq_mutex);
 	return ret;
-
-err_unregister:
-	unregister_netdevice_notifier(&masq_dev_notifier);
 err_dec:
-	masq_refcnt--;
+	masq_refcnt6--;
 out_unlock:
 	mutex_unlock(&masq_mutex);
 	return ret;
@@ -350,11 +354,10 @@ void nf_nat_masquerade_ipv6_unregister_notifier(void)
 {
 	mutex_lock(&masq_mutex);
 	/* check if the notifier still has clients */
-	if (--masq_refcnt > 0)
+	if (--masq_refcnt6 > 0)
 		goto out_unlock;
 
 	unregister_inet6addr_notifier(&masq_inet6_notifier);
-	unregister_netdevice_notifier(&masq_dev_notifier);
 out_unlock:
 	mutex_unlock(&masq_mutex);
 }
-- 
2.11.0

