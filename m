From: Changli Gao <xiaosuo@gmail.com>
Subject: [PATCH] netfilter: use NFPROTO_IPV4 instead of AF_INET
Date: Tue, 17 Aug 2010 14:47:12 +0800
Message-ID: <1282027632-13707-1-git-send-email-xiaosuo@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>,
	netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
	Changli Gao <xiaosuo@gmail.com>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netdev-owner@vger.kernel.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

The field family of xt_target should be NFPROTO_IPV4, though NFPROTO_IPV4
and AF_INET are the same.

Signed-off-by: Changli Gao <xiaosuo@gmail.com>
---
 net/netfilter/xt_TPROXY.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)
diff --git a/net/netfilter/xt_TPROXY.c b/net/netfilter/xt_TPROXY.c
index c61294d..21bb2af 100644
--- a/net/netfilter/xt_TPROXY.c
+++ b/net/netfilter/xt_TPROXY.c
@@ -76,7 +76,7 @@ static int tproxy_tg_check(const struct xt_tgchk_param *par)
 
 static struct xt_target tproxy_tg_reg __read_mostly = {
 	.name		= "TPROXY",
-	.family		= AF_INET,
+	.family		= NFPROTO_IPV4,
 	.table		= "mangle",
 	.target		= tproxy_tg,
 	.targetsize	= sizeof(struct xt_tproxy_target_info),
