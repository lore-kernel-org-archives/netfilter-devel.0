From: fgao@ikuai8.com
Subject: [PATCH nf-next] netfilter: xt_helper: Use sizeof(variable) instead of literal number
Date: Tue, 20 Sep 2016 10:31:04 +0800
Message-ID: <1474338664-7258-1-git-send-email-fgao@ikuai8.com>
Cc: gfree.wind@gmail.com, Gao Feng <fgao@ikuai8.com>
To: pablo@netfilter.org, netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from SMTPBG132.QQ.COM ([113.108.23.42]:56765 "EHLO smtpbg132.qq.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753530AbcITCcD (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 19 Sep 2016 22:32:03 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Gao Feng <fgao@ikuai8.com>

It's better to use sizeof(info->name)-1 as index to force set the string
tail instead of literal number '29'.

Signed-off-by: Gao Feng <fgao@ikuai8.com>
---
 net/netfilter/xt_helper.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/xt_helper.c b/net/netfilter/xt_helper.c
index 9f4ab00..f71ee88 100644
--- a/net/netfilter/xt_helper.c
+++ b/net/netfilter/xt_helper.c
@@ -65,7 +65,7 @@ static int helper_mt_check(const struct xt_mtchk_param *par)
 			par->family);
 		return ret;
 	}
-	info->name[29] = '\0';
+	info->name[sizeof(info->name) - 1] = '\0';
 	return 0;
 }
 
-- 
1.9.1


