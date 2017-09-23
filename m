From: JingPiao Chen <chenjingpiao@gmail.com>
Subject: [PATCH] include: remove outdated comment
Date: Sat, 23 Sep 2017 17:11:22 +0800
Message-ID: <20170923091123.3115-1-chenjingpiao@gmail.com>
Cc: JingPiao Chen <chenjingpiao@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pg0-f66.google.com ([74.125.83.66]:33236 "EHLO
        mail-pg0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750766AbdIWJLk (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 23 Sep 2017 05:11:40 -0400
Received: by mail-pg0-f66.google.com with SMTP id i130so2008631pgc.0
        for <netfilter-devel@vger.kernel.org>; Sat, 23 Sep 2017 02:11:40 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Remove outdated comment, format field in struct cmd have moved in
commit 788687b0.

Signed-off-by: JingPiao Chen <chenjingpiao@gmail.com>
---
 include/rule.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/include/rule.h b/include/rule.h
index 631a1bc..89a6da6 100644
--- a/include/rule.h
+++ b/include/rule.h
@@ -437,7 +437,6 @@ void monitor_free(struct monitor *m);
  * @seqnum:	sequence number to match netlink errors
  * @union:	object
  * @arg:	argument data
- * @format:	info about the export/import format
  */
 struct cmd {
 	struct list_head	list;
-- 
2.7.4

