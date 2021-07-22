Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29819C6377D
	for <netfilter-devel@archiver.kernel.org>; Thu, 22 Jul 2021 08:49:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0EDE761351
	for <netfilter-devel@archiver.kernel.org>; Thu, 22 Jul 2021 08:49:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231211AbhGVII0 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 22 Jul 2021 04:08:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231187AbhGVII0 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 22 Jul 2021 04:08:26 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B23CBC061757
        for <netfilter-devel@vger.kernel.org>; Thu, 22 Jul 2021 01:49:01 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1m6UO4-0000yr-9A; Thu, 22 Jul 2021 10:49:00 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next 3/3] netfilter: remove xt pernet data
Date:   Thu, 22 Jul 2021 10:48:34 +0200
Message-Id: <20210722084834.27027-4-fw@strlen.de>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210722084834.27027-1-fw@strlen.de>
References: <20210722084834.27027-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

clusterip is now handled via net_generic.

NOTRACK is tiny compared to rest of xt_CT feature set, even the existing
deprecation warning is bigger than the actual functionality.

Just remove the warning, its not worth keeping/adding a net_generic one.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/net/net_namespace.h  |  2 --
 include/net/netns/x_tables.h | 12 ------------
 net/netfilter/xt_CT.c        | 11 -----------
 3 files changed, 25 deletions(-)
 delete mode 100644 include/net/netns/x_tables.h

diff --git a/include/net/net_namespace.h b/include/net/net_namespace.h
index 12cf6d7ea62c..60693fd5de45 100644
--- a/include/net/net_namespace.h
+++ b/include/net/net_namespace.h
@@ -23,7 +23,6 @@
 #include <net/netns/ieee802154_6lowpan.h>
 #include <net/netns/sctp.h>
 #include <net/netns/netfilter.h>
-#include <net/netns/x_tables.h>
 #if defined(CONFIG_NF_CONNTRACK) || defined(CONFIG_NF_CONNTRACK_MODULE)
 #include <net/netns/conntrack.h>
 #endif
@@ -132,7 +131,6 @@ struct net {
 #endif
 #ifdef CONFIG_NETFILTER
 	struct netns_nf		nf;
-	struct netns_xt		xt;
 #if defined(CONFIG_NF_CONNTRACK) || defined(CONFIG_NF_CONNTRACK_MODULE)
 	struct netns_ct		ct;
 #endif
diff --git a/include/net/netns/x_tables.h b/include/net/netns/x_tables.h
deleted file mode 100644
index d02316ec2906..000000000000
--- a/include/net/netns/x_tables.h
+++ /dev/null
@@ -1,12 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0 */
-#ifndef __NETNS_X_TABLES_H
-#define __NETNS_X_TABLES_H
-
-#include <linux/list.h>
-#include <linux/netfilter_defs.h>
-
-struct netns_xt {
-	bool notrack_deprecated_warning;
-	bool clusterip_deprecated_warning;
-};
-#endif
diff --git a/net/netfilter/xt_CT.c b/net/netfilter/xt_CT.c
index 12404d221026..0a913ce07425 100644
--- a/net/netfilter/xt_CT.c
+++ b/net/netfilter/xt_CT.c
@@ -351,21 +351,10 @@ notrack_tg(struct sk_buff *skb, const struct xt_action_param *par)
 	return XT_CONTINUE;
 }
 
-static int notrack_chk(const struct xt_tgchk_param *par)
-{
-	if (!par->net->xt.notrack_deprecated_warning) {
-		pr_info("netfilter: NOTRACK target is deprecated, "
-			"use CT instead or upgrade iptables\n");
-		par->net->xt.notrack_deprecated_warning = true;
-	}
-	return 0;
-}
-
 static struct xt_target notrack_tg_reg __read_mostly = {
 	.name		= "NOTRACK",
 	.revision	= 0,
 	.family		= NFPROTO_UNSPEC,
-	.checkentry	= notrack_chk,
 	.target		= notrack_tg,
 	.table		= "raw",
 	.me		= THIS_MODULE,
-- 
2.31.1

