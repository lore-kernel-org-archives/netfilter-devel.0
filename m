From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 14/17] netfilter: nfnetlink_log: just returns error for unknown command
Date: Fri,  8 Jan 2016 15:02:14 +0100
Message-ID: <1452261737-7475-15-git-send-email-pablo@netfilter.org>
References: <1452261737-7475-1-git-send-email-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <1452261737-7475-1-git-send-email-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Ken-ichirou MATSUZAWA <chamaken@gmail.com>

This patch stops processing options for unknown command.

Signed-off-by: Ken-ichirou MATSUZAWA <chamas@h4.dion.ne.jp>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nfnetlink_log.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nfnetlink_log.c b/net/netfilter/nfnetlink_log.c
index 6a57f10..8ca9320 100644
--- a/net/netfilter/nfnetlink_log.c
+++ b/net/netfilter/nfnetlink_log.c
@@ -888,7 +888,7 @@ static int nfulnl_recv_config(struct net *net, struct sock *ctnl,
 			goto out_put;
 		default:
 			ret = -ENOTSUPP;
-			break;
+			goto out_put;
 		}
 	} else if (!inst) {
 		ret = -ENODEV;
-- 
2.1.4
