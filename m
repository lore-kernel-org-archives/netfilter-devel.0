From: Daniel Borkmann <dborkman@redhat.com>
Subject: [PATCH] netfilter: x_tables: allow to use default cgroup match
Date: Mon, 18 Aug 2014 15:46:28 +0200
Message-ID: <1408369588-12363-1-git-send-email-dborkman@redhat.com>
Cc: a.perevalov@samsung.com, netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:11990 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750762AbaHRNql (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 18 Aug 2014 09:46:41 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

There's actually no good reason why we cannot use cgroup id 0,
so lets just remove this artificial barrier.

Reported-by: Alexey Perevalov <a.perevalov@samsung.com>
Signed-off-by: Daniel Borkmann <dborkman@redhat.com>
---
 net/netfilter/xt_cgroup.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/xt_cgroup.c b/net/netfilter/xt_cgroup.c
index f4e8330..7198d66 100644
--- a/net/netfilter/xt_cgroup.c
+++ b/net/netfilter/xt_cgroup.c
@@ -31,7 +31,7 @@ static int cgroup_mt_check(const struct xt_mtchk_param *par)
 	if (info->invert & ~1)
 		return -EINVAL;
 
-	return info->id ? 0 : -EINVAL;
+	return 0;
 }
 
 static bool
-- 
1.7.11.7

