From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH] netlink: fix length value of concat data
Date: Mon, 14 Apr 2014 08:07:33 +0200
Message-ID: <1397455653-3619-1-git-send-email-kaber@trash.net>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:57521 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750732AbaDNGHg (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 14 Apr 2014 02:07:36 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The length is measured in bytes, not bits.

Signed-off-by: Patrick McHardy <kaber@trash.net>
---
 src/netlink.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/netlink.c b/src/netlink.c
index daac64c..0f6fb28 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -230,7 +230,7 @@ static void netlink_gen_concat_data(const struct expr *expr,
 		}
 
 		memcpy(nld->value, data, len / BITS_PER_BYTE);
-		nld->len = len;
+		nld->len = len / BITS_PER_BYTE;
 	}
 }
 
-- 
1.9.0

