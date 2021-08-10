Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7B6FC4320E
	for <netfilter-devel@archiver.kernel.org>; Tue, 10 Aug 2021 16:08:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CB13B610A8
	for <netfilter-devel@archiver.kernel.org>; Tue, 10 Aug 2021 16:08:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233349AbhHJQIp (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 10 Aug 2021 12:08:45 -0400
Received: from mail.netfilter.org ([217.70.188.207]:42506 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233058AbhHJQIo (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 10 Aug 2021 12:08:44 -0400
Received: from salvia.lan (bl11-146-165.dsl.telepac.pt [85.244.146.165])
        by mail.netfilter.org (Postfix) with ESMTPSA id 076CE60030;
        Tue, 10 Aug 2021 18:07:38 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     duncan_roe@optusnet.com.au
Subject: [PATCH libnetfilter_queue] include: deprecate libnetfilter_queue/linux_nfnetlink_queue.h
Date:   Tue, 10 Aug 2021 18:08:13 +0200
Message-Id: <20210810160813.26984-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Emit a warning to notify users that this file is deprecated.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/libnetfilter_queue/libnetfilter_queue.h    | 2 --
 include/libnetfilter_queue/linux_nfnetlink_queue.h | 2 ++
 src/libnetfilter_queue.c                           | 1 +
 utils/nfqnl_test.c                                 | 1 +
 4 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/include/libnetfilter_queue/libnetfilter_queue.h b/include/libnetfilter_queue/libnetfilter_queue.h
index a19122f10ec6..42a3a45f27e1 100644
--- a/include/libnetfilter_queue/libnetfilter_queue.h
+++ b/include/libnetfilter_queue/libnetfilter_queue.h
@@ -16,8 +16,6 @@
 #include <sys/time.h>
 #include <libnfnetlink/libnfnetlink.h>
 
-#include <libnetfilter_queue/linux_nfnetlink_queue.h>
-
 #ifdef __cplusplus
 extern "C" {
 #endif
diff --git a/include/libnetfilter_queue/linux_nfnetlink_queue.h b/include/libnetfilter_queue/linux_nfnetlink_queue.h
index caa67884482c..84f5d96c0a7b 100644
--- a/include/libnetfilter_queue/linux_nfnetlink_queue.h
+++ b/include/libnetfilter_queue/linux_nfnetlink_queue.h
@@ -1,6 +1,8 @@
 #ifndef _NFNETLINK_QUEUE_H
 #define _NFNETLINK_QUEUE_H
 
+#warning "#include <libnetfilter_queue/linux_nfnetlink_queue.h> is deprecated, use #include <linux/netfilter/nfnetlink_queue.h> instead."
+
 #ifndef aligned_u64
 #define aligned_u64 unsigned long long __attribute__((aligned(8)))
 #endif
diff --git a/src/libnetfilter_queue.c b/src/libnetfilter_queue.c
index ef3b21101998..11a4e7c51cc0 100644
--- a/src/libnetfilter_queue.c
+++ b/src/libnetfilter_queue.c
@@ -29,6 +29,7 @@
 #include <errno.h>
 #include <netinet/in.h>
 #include <sys/socket.h>
+#include <linux/netfilter/nfnetlink_queue.h>
 
 #include <libnfnetlink/libnfnetlink.h>
 #include <libnetfilter_queue/libnetfilter_queue.h>
diff --git a/utils/nfqnl_test.c b/utils/nfqnl_test.c
index 5e76ffe48cc7..682f3d79d45a 100644
--- a/utils/nfqnl_test.c
+++ b/utils/nfqnl_test.c
@@ -5,6 +5,7 @@
 #include <netinet/in.h>
 #include <linux/types.h>
 #include <linux/netfilter.h>		/* for NF_ACCEPT */
+#include <linux/netfilter/nfnetlink_queue.h>
 #include <errno.h>
 
 #include <libnetfilter_queue/libnetfilter_queue.h>
-- 
2.20.1

