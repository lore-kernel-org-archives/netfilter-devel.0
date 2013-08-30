From: valentina.giusti@bmw-carit.de
Subject: [PATCH] xt_owner: enable xt_owner on INPUT chain
Date: Fri, 30 Aug 2013 14:43:43 +0200
Message-ID: <1377866623-25948-2-git-send-email-valentina.giusti@bmw-carit.de>
References: <1377866623-25948-1-git-send-email-valentina.giusti@bmw-carit.de>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Patrick McHardy <kaber@trash.net>,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
	"David S. Miller" <davem@davemloft.net>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.bmw-carit.de ([62.245.222.98]:49544 "EHLO
	linuxmail.bmw-carit.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752797Ab3H3Mwa (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 30 Aug 2013 08:52:30 -0400
In-Reply-To: <1377866623-25948-1-git-send-email-valentina.giusti@bmw-carit.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Valentina Giusti <valentina.giusti@bmw-carit.de>

Since (41063e9 ipv4: Early TCP socket demux), we can apply the owner
extension on the INPUT chain and match established TCP sockets.
However, because of the same commit, we can have skb->sk pointing to a
timewait socket, in which case accessing skb->sk->sk_socket is invalid.

Signed-off-by: Valentina Giusti <valentina.giusti@bmw-carit.de>

Cc: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Patrick McHardy <kaber@trash.net>
Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Cc: "David S. Miller" <davem@davemloft.net>
---
 net/netfilter/xt_owner.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/xt_owner.c b/net/netfilter/xt_owner.c
index ca2e577..df03cac 100644
--- a/net/netfilter/xt_owner.c
+++ b/net/netfilter/xt_owner.c
@@ -16,6 +16,7 @@
 #include <net/sock.h>
 #include <linux/netfilter/x_tables.h>
 #include <linux/netfilter/xt_owner.h>
+#include <net/tcp_states.h>
 
 static int owner_check(const struct xt_mtchk_param *par)
 {
@@ -34,7 +35,8 @@ owner_mt(const struct sk_buff *skb, struct xt_action_param *par)
 	const struct xt_owner_match_info *info = par->matchinfo;
 	const struct file *filp;
 
-	if (skb->sk == NULL || skb->sk->sk_socket == NULL)
+	if (skb->sk == NULL || skb->sk->sk_state == TCP_TIME_WAIT ||
+	    skb->sk->sk_socket == NULL)
 		return (info->match ^ info->invert) == 0;
 	else if (info->match & info->invert & XT_OWNER_SOCKET)
 		/*
@@ -76,7 +78,8 @@ static struct xt_match owner_mt_reg __read_mostly = {
 	.checkentry = owner_check,
 	.match      = owner_mt,
 	.matchsize  = sizeof(struct xt_owner_match_info),
-	.hooks      = (1 << NF_INET_LOCAL_OUT) |
+	.hooks      = (1 << NF_INET_LOCAL_IN) |
+		      (1 << NF_INET_LOCAL_OUT) |
 	              (1 << NF_INET_POST_ROUTING),
 	.me         = THIS_MODULE,
 };
-- 
1.7.10.4

