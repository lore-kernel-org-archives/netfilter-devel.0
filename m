From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 34/53] netfilter: xt_helper: Use sizeof(variable) instead of literal number
Date: Mon, 26 Sep 2016 01:06:44 +0200
Message-ID: <1474844823-2026-35-git-send-email-pablo@netfilter.org>
References: <1474844823-2026-1-git-send-email-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:54734 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1034726AbcIYXHz (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 25 Sep 2016 19:07:55 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id D2787C1098
        for <netfilter-devel@vger.kernel.org>; Mon, 26 Sep 2016 01:07:53 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C1BC6DA844
        for <netfilter-devel@vger.kernel.org>; Mon, 26 Sep 2016 01:07:53 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B4937DA81A
        for <netfilter-devel@vger.kernel.org>; Mon, 26 Sep 2016 01:07:51 +0200 (CEST)
In-Reply-To: <1474844823-2026-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Gao Feng <fgao@ikuai8.com>

It's better to use sizeof(info->name)-1 as index to force set the string
tail instead of literal number '29'.

Signed-off-by: Gao Feng <fgao@ikuai8.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/xt_helper.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/xt_helper.c b/net/netfilter/xt_helper.c
index 9f4ab00c8050..805c9f64a04c 100644
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
2.1.4

