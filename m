From: Arushi Singhal <arushisinghal19971997@gmail.com>
Subject: [PATCH] iptables: extensions: Place trailing */ on a separate line.
Date: Thu, 30 Mar 2017 23:30:31 +0530
Message-ID: <20170330180031.GA3701@arushi-HP-Pavilion-Notebook>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: outreachy-kernel@googlegroups.com
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pg0-f67.google.com ([74.125.83.67]:35455 "EHLO
        mail-pg0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933150AbdC3SAh (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 30 Mar 2017 14:00:37 -0400
Received: by mail-pg0-f67.google.com with SMTP id g2so11632741pge.2
        for <netfilter-devel@vger.kernel.org>; Thu, 30 Mar 2017 11:00:36 -0700 (PDT)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Solve the checkpatch issue:
"Block comments use a trailing */ on a separate line"

Signed-off-by: Arushi Singhal <arushisinghal19971997@gmail.com>
---
 extensions/libebt_mark.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/extensions/libebt_mark.c b/extensions/libebt_mark.c
index 7b80b22..1cc2c2a 100644
--- a/extensions/libebt_mark.c
+++ b/extensions/libebt_mark.c
@@ -28,7 +28,8 @@ static int mark_supplied;
 static const struct option brmark_opts[] = {
 	{ .name = "mark-target",.has_arg = true,	.val = MARK_TARGET },
 	/* an oldtime messup, we should have always used the scheme
-	 * <extension-name>-<option> */
+	 * <extension-name>-<option>
+	 */
 	{ .name = "set-mark",	.has_arg = true,	.val = MARK_SETMARK },
 	{ .name = "mark-set",	.has_arg = true,	.val = MARK_SETMARK },
 	{ .name = "mark-or",	.has_arg = true,	.val = MARK_ORMARK },
-- 
2.11.0

