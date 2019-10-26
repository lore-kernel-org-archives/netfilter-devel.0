Return-Path: <SRS0=4S6R=YT=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65C62CA9EB9
	for <netfilter-devel@archiver.kernel.org>; Sat, 26 Oct 2019 06:59:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3B87421655
	for <netfilter-devel@archiver.kernel.org>; Sat, 26 Oct 2019 06:59:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726098AbfJZG7t (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 26 Oct 2019 02:59:49 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:59217 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726010AbfJZG7s (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 26 Oct 2019 02:59:48 -0400
Received: from dimstar.local.net (n122-110-44-45.sun2.vic.optusnet.com.au [122.110.44.45])
        by mail105.syd.optusnet.com.au (Postfix) with SMTP id 72B5D3A058C
        for <netfilter-devel@vger.kernel.org>; Sat, 26 Oct 2019 17:59:33 +1100 (AEDT)
Received: (qmail 18033 invoked by uid 501); 26 Oct 2019 06:59:32 -0000
From:   Duncan Roe <duncan_roe@optusnet.com.au>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH libnfnetlink v2 2/2] Make it clear that this library is deprecated
Date:   Sat, 26 Oct 2019 17:59:32 +1100
Message-Id: <20191026065932.17985-3-duncan_roe@optusnet.com.au>
X-Mailer: git-send-email 2.14.5
In-Reply-To: <20191026065932.17985-1-duncan_roe@optusnet.com.au>
References: <20191026065932.17985-1-duncan_roe@optusnet.com.au>
In-Reply-To: <20191026051937.GA17407@dimstar.local.net>
References: <20191026051937.GA17407@dimstar.local.net>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=G6BsK5s5 c=1 sm=1 tr=0
        a=4DzML1vCOQ6Odsy8BUtSXQ==:117 a=4DzML1vCOQ6Odsy8BUtSXQ==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=XobE76Q3jBoA:10 a=3HDBlxybAAAA:8
        a=2N_xtPVrLEw7wJbsGzEA:9 a=laEoCiVfU_Unz3mSdgXN:22
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

 src/iftable.c: Update group description

 src/libnfnetlink.c: - Re-work main page (which was based on the misconception
                       that this library always gets used)
                     - Update group description
---
 src/iftable.c      |  6 +++++-
 src/libnfnetlink.c | 17 ++++++++++++++---
 2 files changed, 19 insertions(+), 4 deletions(-)

diff --git a/src/iftable.c b/src/iftable.c
index 6d1d135..aab59b3 100644
--- a/src/iftable.c
+++ b/src/iftable.c
@@ -25,7 +25,11 @@
 #include "linux_list.h"
 
 /**
- * \defgroup iftable Functions in iftable.c
+ * \defgroup iftable Functions in iftable.c [DEPRECATED]
+ * This documentation is provided for the benefit of maintainers of legacy code.
+ *
+ * New applications should use
+ * [libmnl](https://netfilter.org/projects/libmnl/doxygen/html/).
  * @{
  */
 
diff --git a/src/libnfnetlink.c b/src/libnfnetlink.c
index 3db21e0..1cb6a82 100644
--- a/src/libnfnetlink.c
+++ b/src/libnfnetlink.c
@@ -55,12 +55,23 @@
 /**
  * \mainpage
  *
- * libnfnetlink is the bottom-level communication between the kernel and
- * userspace
+ * Deprecated
+ * ---
+ * New applications should use
+ * [libmnl](https://netfilter.org/projects/libmnl/doxygen/html/).
+ *
+ * [libnetfilter_queue]
+ * (https://netfilter.org/projects/libnetfilter_queue/doxygen/html/)
+ * now provides a set of helpers for libmnl, in addition to those it provides
+ * for libnfnetlink (which are now deprecated).
  */
 
 /**
- * \defgroup libnfnetlink Functions in libnfnetlink.c
+ * \defgroup libnfnetlink Functions in libnfnetlink.c [DEPRECATED]
+ * This documentation is provided for the benefit of maintainers of legacy code.
+ *
+ * New applications should use
+ * [libmnl](https://netfilter.org/projects/libmnl/doxygen/html/).
  * @{
  */
 
-- 
2.14.5

