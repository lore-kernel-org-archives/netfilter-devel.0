Return-Path: <SRS0=UAOK=W4=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7128C3A5A4
	for <netfilter-devel@archiver.kernel.org>; Sun,  1 Sep 2019 21:01:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 874A42190F
	for <netfilter-devel@archiver.kernel.org>; Sun,  1 Sep 2019 21:01:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="uOLkbbeB"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729012AbfIAVBS (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 1 Sep 2019 17:01:18 -0400
Received: from kadath.azazel.net ([81.187.231.250]:53540 "EHLO
        kadath.azazel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728879AbfIAVBS (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 1 Sep 2019 17:01:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=+cVnISrLjNPp19pCU4MkMq64I37x2abdQokAKgJ5xTg=; b=uOLkbbeBYKSJFxB6TqvxYxwn4+
        /uF0ub50gkS3y5Eay+NBT/0NG1ApWnZznJYLPUeNLjli8iNnclJ+/a2poXXlZ44wYhB/UmYgyH+DK
        pNy6EnfWoSfA74+IaE5XMfNLJylPvmqD3C35pgKjzjiR9ObRjFIBPC2mOPzyDnTr5o+8tP6mQHdnR
        DWNNWNKOlp2AItnAjAL7+PYXfQtufv3bTloVYMpP0PS09Xj63XMRNJcgg11xLF4Sdwt6luS/j+Vo3
        GJiE6XbFs1JIP5gEHsbJPVAPJf7+zW6wWAwRrcFKzGdD7NSRPls3khQwDcyAN9iZCY/IKFTWcDTgB
        5Z1IwsQQ==;
Received: from [2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae] (helo=ulthar.dreamlands)
        by kadath.azazel.net with esmtp (Exim 4.92)
        (envelope-from <jeremy@azazel.net>)
        id 1i4Wop-0002Uf-Uo; Sun, 01 Sep 2019 21:51:28 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH nf-next 12/29] netfilter: inline three headers.
Date:   Sun,  1 Sep 2019 21:51:08 +0100
Message-Id: <20190901205126.6935-13-jeremy@azazel.net>
X-Mailer: git-send-email 2.23.0.rc1
In-Reply-To: <20190901205126.6935-1-jeremy@azazel.net>
References: <20190901205126.6935-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Three netfilter headers are only included once.  Inline their contents
at those sites and remove them.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 include/linux/netfilter/xt_hashlimit.h     | 11 -----------
 include/linux/netfilter/xt_physdev.h       |  8 --------
 include/linux/netfilter_bridge/ebt_802_3.h | 12 ------------
 net/bridge/netfilter/ebt_802_3.c           |  8 +++++++-
 net/netfilter/xt_hashlimit.c               |  7 ++++++-
 net/netfilter/xt_physdev.c                 |  5 +++--
 6 files changed, 16 insertions(+), 35 deletions(-)
 delete mode 100644 include/linux/netfilter/xt_hashlimit.h
 delete mode 100644 include/linux/netfilter/xt_physdev.h
 delete mode 100644 include/linux/netfilter_bridge/ebt_802_3.h

diff --git a/include/linux/netfilter/xt_hashlimit.h b/include/linux/netfilter/xt_hashlimit.h
deleted file mode 100644
index 169d03983589..000000000000
--- a/include/linux/netfilter/xt_hashlimit.h
+++ /dev/null
@@ -1,11 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0 */
-#ifndef _XT_HASHLIMIT_H
-#define _XT_HASHLIMIT_H
-
-#include <uapi/linux/netfilter/xt_hashlimit.h>
-
-#define XT_HASHLIMIT_ALL (XT_HASHLIMIT_HASH_DIP | XT_HASHLIMIT_HASH_DPT | \
-			  XT_HASHLIMIT_HASH_SIP | XT_HASHLIMIT_HASH_SPT | \
-			  XT_HASHLIMIT_INVERT | XT_HASHLIMIT_BYTES |\
-			  XT_HASHLIMIT_RATE_MATCH)
-#endif /*_XT_HASHLIMIT_H*/
diff --git a/include/linux/netfilter/xt_physdev.h b/include/linux/netfilter/xt_physdev.h
deleted file mode 100644
index 4ca0593949cd..000000000000
--- a/include/linux/netfilter/xt_physdev.h
+++ /dev/null
@@ -1,8 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0 */
-#ifndef _XT_PHYSDEV_H
-#define _XT_PHYSDEV_H
-
-#include <linux/if.h>
-#include <uapi/linux/netfilter/xt_physdev.h>
-
-#endif /*_XT_PHYSDEV_H*/
diff --git a/include/linux/netfilter_bridge/ebt_802_3.h b/include/linux/netfilter_bridge/ebt_802_3.h
deleted file mode 100644
index c6147f9c0d80..000000000000
--- a/include/linux/netfilter_bridge/ebt_802_3.h
+++ /dev/null
@@ -1,12 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0 */
-#ifndef __LINUX_BRIDGE_EBT_802_3_H
-#define __LINUX_BRIDGE_EBT_802_3_H
-
-#include <linux/skbuff.h>
-#include <uapi/linux/netfilter_bridge/ebt_802_3.h>
-
-static inline struct ebt_802_3_hdr *ebt_802_3_hdr(const struct sk_buff *skb)
-{
-	return (struct ebt_802_3_hdr *)skb_mac_header(skb);
-}
-#endif
diff --git a/net/bridge/netfilter/ebt_802_3.c b/net/bridge/netfilter/ebt_802_3.c
index 2c8fe24400e5..68c2519bdc52 100644
--- a/net/bridge/netfilter/ebt_802_3.c
+++ b/net/bridge/netfilter/ebt_802_3.c
@@ -11,7 +11,13 @@
 #include <linux/module.h>
 #include <linux/netfilter/x_tables.h>
 #include <linux/netfilter_bridge/ebtables.h>
-#include <linux/netfilter_bridge/ebt_802_3.h>
+#include <linux/skbuff.h>
+#include <uapi/linux/netfilter_bridge/ebt_802_3.h>
+
+static struct ebt_802_3_hdr *ebt_802_3_hdr(const struct sk_buff *skb)
+{
+	return (struct ebt_802_3_hdr *)skb_mac_header(skb);
+}
 
 static bool
 ebt_802_3_mt(const struct sk_buff *skb, struct xt_action_param *par)
diff --git a/net/netfilter/xt_hashlimit.c b/net/netfilter/xt_hashlimit.c
index 2d2691dd51e0..ced3fc8fad7c 100644
--- a/net/netfilter/xt_hashlimit.c
+++ b/net/netfilter/xt_hashlimit.c
@@ -34,9 +34,14 @@
 #include <linux/netfilter/x_tables.h>
 #include <linux/netfilter_ipv4/ip_tables.h>
 #include <linux/netfilter_ipv6/ip6_tables.h>
-#include <linux/netfilter/xt_hashlimit.h>
 #include <linux/mutex.h>
 #include <linux/kernel.h>
+#include <uapi/linux/netfilter/xt_hashlimit.h>
+
+#define XT_HASHLIMIT_ALL (XT_HASHLIMIT_HASH_DIP | XT_HASHLIMIT_HASH_DPT | \
+			  XT_HASHLIMIT_HASH_SIP | XT_HASHLIMIT_HASH_SPT | \
+			  XT_HASHLIMIT_INVERT | XT_HASHLIMIT_BYTES |\
+			  XT_HASHLIMIT_RATE_MATCH)
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Harald Welte <laforge@netfilter.org>");
diff --git a/net/netfilter/xt_physdev.c b/net/netfilter/xt_physdev.c
index 4f311e5703e8..559a0572557f 100644
--- a/net/netfilter/xt_physdev.c
+++ b/net/netfilter/xt_physdev.c
@@ -5,11 +5,13 @@
 /* (C) 2001-2003 Bart De Schuymer <bdschuym@pandora.be>
  */
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
+#include <linux/if.h>
 #include <linux/module.h>
 #include <linux/skbuff.h>
 #include <linux/netfilter_bridge.h>
-#include <linux/netfilter/xt_physdev.h>
 #include <linux/netfilter/x_tables.h>
+#include <uapi/linux/netfilter/xt_physdev.h>
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Bart De Schuymer <bdschuym@pandora.be>");
@@ -17,7 +19,6 @@ MODULE_DESCRIPTION("Xtables: Bridge physical device match");
 MODULE_ALIAS("ipt_physdev");
 MODULE_ALIAS("ip6t_physdev");
 
-
 static bool
 physdev_mt(const struct sk_buff *skb, struct xt_action_param *par)
 {
-- 
2.23.0.rc1

