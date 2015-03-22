From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 5/6] netfilter: xt_TPROXY: fix invflags check in tproxy_tg6_check()
Date: Sun, 22 Mar 2015 19:46:37 +0100
Message-ID: <1427049998-5665-6-git-send-email-pablo@netfilter.org>
References: <1427049998-5665-1-git-send-email-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <1427049998-5665-1-git-send-email-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

We have to check for IP6T_INV_PROTO in invflags, instead of flags.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Acked-by: Balazs Scheidler <bazsi@balabit.hu>
---
 net/netfilter/xt_TPROXY.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/xt_TPROXY.c b/net/netfilter/xt_TPROXY.c
index ef8a926..50e1e5a 100644
--- a/net/netfilter/xt_TPROXY.c
+++ b/net/netfilter/xt_TPROXY.c
@@ -513,8 +513,8 @@ static int tproxy_tg6_check(const struct xt_tgchk_param *par)
 {
 	const struct ip6t_ip6 *i = par->entryinfo;
 
-	if ((i->proto == IPPROTO_TCP || i->proto == IPPROTO_UDP)
-	    && !(i->flags & IP6T_INV_PROTO))
+	if ((i->proto == IPPROTO_TCP || i->proto == IPPROTO_UDP) &&
+	    !(i->invflags & IP6T_INV_PROTO))
 		return 0;
 
 	pr_info("Can be used only in combination with "
-- 
1.7.10.4
