From: kaber@trash.net
Subject: [PATCH 53/84] netfilter: CLUSTERIP: clusterip_seq_stop() fix
Date: Mon, 10 May 2010 22:18:24 +0200
Message-ID: <1273522735-24672-54-git-send-email-kaber@trash.net>
References: <1273522735-24672-1-git-send-email-kaber@trash.net>
Cc: netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:54506 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756724Ab0EJUTR (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 10 May 2010 16:19:17 -0400
In-Reply-To: <1273522735-24672-1-git-send-email-kaber@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Eric Dumazet <eric.dumazet@gmail.com>

If clusterip_seq_start() memory allocation fails, we crash later in
clusterip_seq_start(), trying to kfree(ERR_PTR(-ENOMEM))

Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
Signed-off-by: Patrick McHardy <kaber@trash.net>
---
 net/ipv4/netfilter/ipt_CLUSTERIP.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/net/ipv4/netfilter/ipt_CLUSTERIP.c b/net/ipv4/netfilter/ipt_CLUSTERIP.c
index 5d70c43..c6be74e 100644
--- a/net/ipv4/netfilter/ipt_CLUSTERIP.c
+++ b/net/ipv4/netfilter/ipt_CLUSTERIP.c
@@ -599,7 +599,8 @@ static void *clusterip_seq_next(struct seq_file *s, void *v, loff_t *pos)
 
 static void clusterip_seq_stop(struct seq_file *s, void *v)
 {
-	kfree(v);
+	if (!IS_ERR(v))
+		kfree(v);
 }
 
 static int clusterip_seq_show(struct seq_file *s, void *v)
-- 
1.7.0.4

