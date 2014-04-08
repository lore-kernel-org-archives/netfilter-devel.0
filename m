From: Ana Rey <anarey@gmail.com>
Subject: [nftables PATCH] src: rule: Fix list of set: Add a forgotten 'return'
Date: Tue,  8 Apr 2014 09:19:27 +0200
Message-ID: <bf9127aa386c8ca027215124fc1540f4f8ab9797.1396941336.git.anarey@gmail.com>
Cc: Ana Rey <anarey@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:40524 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754698AbaDHHTh (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 8 Apr 2014 03:19:37 -0400
Received: by mail-wg0-f44.google.com with SMTP id m15so496954wgh.27
        for <netfilter-devel@vger.kernel.org>; Tue, 08 Apr 2014 00:19:35 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Add a return forgotten.
It adds a exit in the function and It avoids executing unnecessary code.

Signed-off-by: Ana Rey <anarey@gmail.com>
---
 src/rule.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/rule.c b/src/rule.c
index 00dedf5..18ae6b1 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -674,7 +674,7 @@ static int do_command_list(struct netlink_ctx *ctx, struct cmd *cmd)
 				return -1;
 			set_print(set);
 		}
-		break;
+		return 0;
 	case CMD_OBJ_SET:
 		if (netlink_get_set(ctx, &cmd->handle, &cmd->location) < 0)
 			return -1;
-- 
1.9.0

