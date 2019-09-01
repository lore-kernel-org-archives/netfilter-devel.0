Return-Path: <SRS0=UAOK=W4=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8480C3A5A4
	for <netfilter-devel@archiver.kernel.org>; Sun,  1 Sep 2019 21:01:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 927C52190F
	for <netfilter-devel@archiver.kernel.org>; Sun,  1 Sep 2019 21:01:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="K3b+u0Hf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729072AbfIAVBZ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 1 Sep 2019 17:01:25 -0400
Received: from kadath.azazel.net ([81.187.231.250]:53582 "EHLO
        kadath.azazel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729059AbfIAVBZ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 1 Sep 2019 17:01:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=MNOBjMlj3K/sXr/JzviS5Sk7mC+5AmCmU8kYahc7308=; b=K3b+u0Hf4SOATrcw1XsLupSOWy
        Fmk3DQ3dsYK/8SyOMeZHUIRnZvsmH554kD/q4WnH0D6Z9kDsiCKyABs0b8Jh6OC0LfrYtKrOvGaz/
        nxeqQAQpaWvdID/I2bZ2BNJ7WT6Caj7PM1lC2A9kZNVDKnz8a0Z5GuBL3wGc9/VJaC6nY/KtNGuya
        BYKB8u6mF2xvC5oVBuawJjlBIMJgsc9E1Wxr+rpaapJIGGkf7CoIEvjZj6tNtxLrR3MNQ/FIJiHZq
        UOFSMj3RhfGl6FtXDj8qHofKvtZCIwkOloQk2GSQEyQPLYHwTOzxRMLloPzrr2C19xWdr0OHNgoN1
        RQbl8qsw==;
Received: from [2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae] (helo=ulthar.dreamlands)
        by kadath.azazel.net with esmtp (Exim 4.92)
        (envelope-from <jeremy@azazel.net>)
        id 1i4Wop-0002Uf-No; Sun, 01 Sep 2019 21:51:27 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH nf-next 11/29] netfilter: added missing includes.
Date:   Sun,  1 Sep 2019 21:51:07 +0100
Message-Id: <20190901205126.6935-12-jeremy@azazel.net>
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

Include some headers in files which use them.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 include/net/netfilter/nf_conntrack_core.h | 3 ++-
 include/net/netfilter/nf_nat.h            | 5 +++--
 include/net/netfilter/nf_nat_masquerade.h | 1 +
 net/netfilter/nf_conntrack_ecache.c       | 1 +
 net/netfilter/nf_conntrack_expect.c       | 2 ++
 net/netfilter/nf_conntrack_helper.c       | 5 +++--
 net/netfilter/nf_conntrack_timeout.c      | 1 +
 net/netfilter/nf_flow_table_core.c        | 1 +
 net/netfilter/nft_flow_offload.c          | 3 ++-
 net/netfilter/xt_connlimit.c              | 2 ++
 10 files changed, 18 insertions(+), 6 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack_core.h b/include/net/netfilter/nf_conntrack_core.h
index 71a2d9cb64ea..d340886e012d 100644
--- a/include/net/netfilter/nf_conntrack_core.h
+++ b/include/net/netfilter/nf_conntrack_core.h
@@ -14,8 +14,9 @@
 #define _NF_CONNTRACK_CORE_H
 
 #include <linux/netfilter.h>
-#include <net/netfilter/nf_conntrack_l4proto.h>
+#include <net/netfilter/nf_conntrack.h>
 #include <net/netfilter/nf_conntrack_ecache.h>
+#include <net/netfilter/nf_conntrack_l4proto.h>
 
 /* This header is used to share core functionality between the
    standalone connection tracking module, and the compatibility layer's use
diff --git a/include/net/netfilter/nf_nat.h b/include/net/netfilter/nf_nat.h
index eec208fb9c23..518b3288bab4 100644
--- a/include/net/netfilter/nf_nat.h
+++ b/include/net/netfilter/nf_nat.h
@@ -1,8 +1,11 @@
 /* SPDX-License-Identifier: GPL-2.0 */
 #ifndef _NF_NAT_H
 #define _NF_NAT_H
+
 #include <linux/netfilter_ipv4.h>
 #include <linux/netfilter/nf_nat.h>
+#include <net/netfilter/nf_conntrack.h>
+#include <net/netfilter/nf_conntrack_extend.h>
 #include <net/netfilter/nf_conntrack_tuple.h>
 
 enum nf_nat_manip_type {
@@ -26,8 +29,6 @@ union nf_conntrack_nat_help {
 #endif
 };
 
-struct nf_conn;
-
 /* The structure embedded in the conntrack structure. */
 struct nf_conn_nat {
 	union nf_conntrack_nat_help help;
diff --git a/include/net/netfilter/nf_nat_masquerade.h b/include/net/netfilter/nf_nat_masquerade.h
index 54a14d643c34..be7abc9d5f22 100644
--- a/include/net/netfilter/nf_nat_masquerade.h
+++ b/include/net/netfilter/nf_nat_masquerade.h
@@ -2,6 +2,7 @@
 #ifndef _NF_NAT_MASQUERADE_H_
 #define _NF_NAT_MASQUERADE_H_
 
+#include <linux/skbuff.h>
 #include <net/netfilter/nf_nat.h>
 
 unsigned int
diff --git a/net/netfilter/nf_conntrack_ecache.c b/net/netfilter/nf_conntrack_ecache.c
index 5e2812ee2149..6fba74b5aaf7 100644
--- a/net/netfilter/nf_conntrack_ecache.c
+++ b/net/netfilter/nf_conntrack_ecache.c
@@ -24,6 +24,7 @@
 
 #include <net/netfilter/nf_conntrack.h>
 #include <net/netfilter/nf_conntrack_core.h>
+#include <net/netfilter/nf_conntrack_ecache.h>
 #include <net/netfilter/nf_conntrack_extend.h>
 
 static DEFINE_MUTEX(nf_ct_ecache_mutex);
diff --git a/net/netfilter/nf_conntrack_expect.c b/net/netfilter/nf_conntrack_expect.c
index 65364de915d1..42557d2b6a90 100644
--- a/net/netfilter/nf_conntrack_expect.c
+++ b/net/netfilter/nf_conntrack_expect.c
@@ -25,8 +25,10 @@
 
 #include <net/netfilter/nf_conntrack.h>
 #include <net/netfilter/nf_conntrack_core.h>
+#include <net/netfilter/nf_conntrack_ecache.h>
 #include <net/netfilter/nf_conntrack_expect.h>
 #include <net/netfilter/nf_conntrack_helper.h>
+#include <net/netfilter/nf_conntrack_l4proto.h>
 #include <net/netfilter/nf_conntrack_tuple.h>
 #include <net/netfilter/nf_conntrack_zones.h>
 
diff --git a/net/netfilter/nf_conntrack_helper.c b/net/netfilter/nf_conntrack_helper.c
index 8d729e7c36ff..118f415928ae 100644
--- a/net/netfilter/nf_conntrack_helper.c
+++ b/net/netfilter/nf_conntrack_helper.c
@@ -21,10 +21,11 @@
 #include <linux/rtnetlink.h>
 
 #include <net/netfilter/nf_conntrack.h>
-#include <net/netfilter/nf_conntrack_l4proto.h>
-#include <net/netfilter/nf_conntrack_helper.h>
 #include <net/netfilter/nf_conntrack_core.h>
+#include <net/netfilter/nf_conntrack_ecache.h>
 #include <net/netfilter/nf_conntrack_extend.h>
+#include <net/netfilter/nf_conntrack_helper.h>
+#include <net/netfilter/nf_conntrack_l4proto.h>
 #include <net/netfilter/nf_log.h>
 
 static DEFINE_MUTEX(nf_ct_helper_mutex);
diff --git a/net/netfilter/nf_conntrack_timeout.c b/net/netfilter/nf_conntrack_timeout.c
index 13d0f4a92647..14387e0b8008 100644
--- a/net/netfilter/nf_conntrack_timeout.c
+++ b/net/netfilter/nf_conntrack_timeout.c
@@ -19,6 +19,7 @@
 #include <net/netfilter/nf_conntrack.h>
 #include <net/netfilter/nf_conntrack_core.h>
 #include <net/netfilter/nf_conntrack_extend.h>
+#include <net/netfilter/nf_conntrack_l4proto.h>
 #include <net/netfilter/nf_conntrack_timeout.h>
 
 struct nf_ct_timeout *
diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
index 80a8f9ae4c93..09310a1bd91f 100644
--- a/net/netfilter/nf_flow_table_core.c
+++ b/net/netfilter/nf_flow_table_core.c
@@ -11,6 +11,7 @@
 #include <net/netfilter/nf_flow_table.h>
 #include <net/netfilter/nf_conntrack.h>
 #include <net/netfilter/nf_conntrack_core.h>
+#include <net/netfilter/nf_conntrack_l4proto.h>
 #include <net/netfilter/nf_conntrack_tuple.h>
 
 struct flow_offload_entry {
diff --git a/net/netfilter/nft_flow_offload.c b/net/netfilter/nft_flow_offload.c
index 060a4ed46d5e..b2dec0185056 100644
--- a/net/netfilter/nft_flow_offload.c
+++ b/net/netfilter/nft_flow_offload.c
@@ -6,12 +6,13 @@
 #include <linux/netfilter.h>
 #include <linux/workqueue.h>
 #include <linux/spinlock.h>
+#include <linux/netfilter/nf_conntrack_common.h>
 #include <linux/netfilter/nf_tables.h>
 #include <net/ip.h> /* for ipv4 options. */
 #include <net/netfilter/nf_tables.h>
 #include <net/netfilter/nf_tables_core.h>
 #include <net/netfilter/nf_conntrack_core.h>
-#include <linux/netfilter/nf_conntrack_common.h>
+#include <net/netfilter/nf_conntrack_extend.h>
 #include <net/netfilter/nf_flow_table.h>
 
 struct nft_flow_offload {
diff --git a/net/netfilter/xt_connlimit.c b/net/netfilter/xt_connlimit.c
index bc6c8ab0fa62..46fcac75f726 100644
--- a/net/netfilter/xt_connlimit.c
+++ b/net/netfilter/xt_connlimit.c
@@ -13,6 +13,8 @@
  */
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
+#include <linux/ip.h>
+#include <linux/ipv6.h>
 #include <linux/module.h>
 #include <linux/skbuff.h>
 #include <linux/netfilter/x_tables.h>
-- 
2.23.0.rc1

