From: Ana Rey <anarey@gmail.com>
Subject: [nftables PATCH v2] src: rule: fix crash in set listing
Date: Tue,  8 Apr 2014 10:19:41 +0200
Message-ID: <89f7e3e3f3a65a85381e04e8e0d12dd1c3069f73.1396944817.git.anarey@gmail.com>
Cc: Ana Rey <anarey@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-we0-f179.google.com ([74.125.82.179]:51738 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756293AbaDHITv (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 8 Apr 2014 04:19:51 -0400
Received: by mail-we0-f179.google.com with SMTP id x48so559954wes.38
        for <netfilter-devel@vger.kernel.org>; Tue, 08 Apr 2014 01:19:49 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

It fixes an invalid read that is shown by valgrind.

==3962== Invalid read of size 4
==3962==    at 0x407040: do_command (rule.c:692)
==3962==    by 0x40588C: nft_run (main.c:183)
==3962==    by 0x405469: main (main.c:334)
==3962==  Address 0x10 is not stack'd, malloc'd or (recently) free'd

Signed-off-by: Ana Rey <anarey@gmail.com>
---
[Changes in v2]
*  I fix description and subject in this patch.


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

