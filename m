From: Liping Zhang <zlpnobody@163.com>
Subject: [PATCH nft 3/3] meta: fix a format error display when we set priority to root or none
Date: Sun, 29 May 2016 18:08:09 +0800
Message-ID: <1464516489-21616-3-git-send-email-zlpnobody@163.com>
References: <1464516489-21616-1-git-send-email-zlpnobody@163.com>
Cc: netfilter-devel@vger.kernel.org,
	Liping Zhang <liping.zhang@spreadtrum.com>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from m12-17.163.com ([220.181.12.17]:37168 "EHLO m12-17.163.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932079AbcE2KJa (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 29 May 2016 06:09:30 -0400
In-Reply-To: <1464516489-21616-1-git-send-email-zlpnobody@163.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Liping Zhang <liping.zhang@spreadtrum.com>

Also delete the redundant '\n'.
This fixes:

  # nft add rule filter test meta priority set root
  # nft list chain filter test
  table ip filter {
      chain test {
          meta priority set root
  none
  ffff:ffff
      }
  }

Signed-off-by: Liping Zhang <liping.zhang@spreadtrum.com>
---
 src/meta.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/src/meta.c b/src/meta.c
index 74d2b4c..75431a2 100644
--- a/src/meta.c
+++ b/src/meta.c
@@ -74,9 +74,11 @@ static void tchandle_type_print(const struct expr *expr)
 
 	switch(handle) {
 	case TC_H_ROOT:
-		printf("root\n");
+		printf("root");
+		break;
 	case TC_H_UNSPEC:
-		printf("none\n");
+		printf("none");
+		break;
 	default:
 		if (TC_H_MAJ(handle) == 0)
 			printf(":%04x", TC_H_MIN(handle));
-- 
2.5.5


