From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 07/12]: H.323 helper: add parameter 'default_rrq_ttl'
Date: Thu,  6 Apr 2006 12:05:03 +0200 (MEST)
Message-ID: <20060406100502.17409.1181.sendpatchset@localhost.localdomain>
References: <20060406100452.17409.37120.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: davem@davemloft.net
In-Reply-To: <20060406100452.17409.37120.sendpatchset@localhost.localdomain>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

[NETFILTER]: H.323 helper: add parameter 'default_rrq_ttl'

default_rrq_ttl is used when no TTL is included in the RRQ.

Signed-off-by: Jing Min Zhao <zhaojingmin@users.sourceforge.net>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 58e6febec3e259470b331d97cfe085242d2421c5
tree a4d5bd9755e4cfbe35cadac9ade4246a857be278
parent a429b7ed024240e1334b78447e208f71959add62
author Jing Min Zhao <zhaojingmin@users.sourceforge.net> Thu, 06 Apr 2006 11:43:00 +0200
committer Patrick McHardy <kaber@trash.net> Thu, 06 Apr 2006 11:43:00 +0200

 net/ipv4/netfilter/ip_conntrack_helper_h323.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/net/ipv4/netfilter/ip_conntrack_helper_h323.c b/net/ipv4/netfilter/ip_conntrack_helper_h323.c
index 11c652f..dccc6c3 100644
--- a/net/ipv4/netfilter/ip_conntrack_helper_h323.c
+++ b/net/ipv4/netfilter/ip_conntrack_helper_h323.c
@@ -61,6 +61,10 @@
 #endif
 
 /* Parameters */
+static unsigned int default_rrq_ttl = 300;
+module_param(default_rrq_ttl, uint, 0600);
+MODULE_PARM_DESC(default_rrq_ttl, "use this TTL if it's missing in RRQ");
+
 static int gkrouted_only = 1;
 module_param(gkrouted_only, int, 0600);
 MODULE_PARM_DESC(gkrouted_only, "only accept calls from gatekeeper");
@@ -1300,7 +1304,7 @@ static int process_rrq(struct sk_buff **
 		DEBUGP("ip_ct_ras: RRQ TTL = %u seconds\n", rrq->timeToLive);
 		info->timeout = rrq->timeToLive;
 	} else
-		info->timeout = 0;
+		info->timeout = default_rrq_ttl;
 
 	return 0;
 }
