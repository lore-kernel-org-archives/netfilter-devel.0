From: =?GBK?B?ts6+vA==?= <jduan@fiberhome.com>
Subject: [PATCH] nfnetlink_log: fix the typo
Date: Thu, 16 Feb 2017 11:12:27 +0800
Message-ID: <a9c19965-2c96-8608-6bbb-cb3f09fc2226@fiberhome.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mxuc.fiberhome.com ([113.57.179.111]:56449 "EHLO
        mxuc.fiberhome.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751958AbdBPDYT (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 15 Feb 2017 22:24:19 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

 From 5a4a39fd4373e78b0019b0180718e96c85b1fdd7 Mon Sep 17 00:00:00 2001
From: Duan Jiong <jduan@fiberhome.com>
Date: Thu, 16 Feb 2017 11:07:38 +0800
Subject: [PATCH] nfnetlink_log: fix the typo

s/nfetlink/nfnetlink/

Signed-off-by: Duan Jiong <jduan@fiberhome.com>
---
  net/netfilter/nfnetlink_log.c | 2 +-
  1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nfnetlink_log.c b/net/netfilter/nfnetlink_log.c
index 08247bf..b8ff558 100644
--- a/net/netfilter/nfnetlink_log.c
+++ b/net/netfilter/nfnetlink_log.c
@@ -1,6 +1,6 @@
  /*
   * This is a module which is used for logging packets to userspace via
- * nfetlink.
+ * nfnetlink.
   *
   * (C) 2005 by Harald Welte <laforge@netfilter.org>
   * (C) 2006-2012 Patrick McHardy <kaber@trash.net>
-- 
2.7.4


