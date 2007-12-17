From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 49/64]: nfnetlink_{queue,log}: return ENOTSUPP for unknown cfg commands
Date: Tue, 18 Dec 2007 00:47:20 +0100 (MET)
Message-ID: <20071217234719.23601.47909.sendpatchset@localhost.localdomain>
References: <20071217234612.23601.6979.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:39033 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932875AbXLQXrV (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 17 Dec 2007 18:47:21 -0500
In-Reply-To: <20071217234612.23601.6979.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[NETFILTER]: nfnetlink_{queue,log}: return ENOTSUPP for unknown cfg commands

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 338250942a8a7810a9274028a9d96b8a6d3eecaa
tree 67d03f2ff6ee719cf9548a69227d56fbd6d660d0
parent 5860f7b62d7a9dcdb1ea33f24e2adb621087ff96
author Patrick McHardy <kaber@trash.net> Mon, 17 Dec 2007 14:58:40 +0100
committer Patrick McHardy <kaber@trash.net> Tue, 18 Dec 2007 00:24:58 +0100

 net/netfilter/nfnetlink_log.c   |    2 +-
 net/netfilter/nfnetlink_queue.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nfnetlink_log.c b/net/netfilter/nfnetlink_log.c
index 3dcc6f5..325e93a 100644
--- a/net/netfilter/nfnetlink_log.c
+++ b/net/netfilter/nfnetlink_log.c
@@ -798,7 +798,7 @@ nfulnl_recv_config(struct sock *ctnl, struct sk_buff *skb,
 			nf_log_unregister_pf(pf);
 			break;
 		default:
-			ret = -EINVAL;
+			ret = -ENOTSUPP;
 			break;
 		}
 	}
diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
index d94de48..370f0af 100644
--- a/net/netfilter/nfnetlink_queue.c
+++ b/net/netfilter/nfnetlink_queue.c
@@ -740,7 +740,7 @@ nfqnl_recv_config(struct sock *ctnl, struct sk_buff *skb,
 		case NFQNL_CFG_CMD_PF_UNBIND:
 			break;
 		default:
-			ret = -EINVAL;
+			ret = -ENOTSUPP;
 			break;
 		}
 	}
