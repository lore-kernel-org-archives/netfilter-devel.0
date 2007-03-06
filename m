From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 03/03]: nfnetlink_log: fix crash on bridged packet
Date: Tue,  6 Mar 2007 08:44:05 +0100 (MET)
Message-ID: <20070306074404.24479.71527.sendpatchset@localhost.localdomain>
References: <20070306074400.24479.43171.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
To: davem@davemloft.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <20070306074400.24479.43171.sendpatchset@localhost.localdomain>
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

[NETFILTER]: nfnetlink_log: fix crash on bridged packet

physoutdev is only set on purely bridged packet, when nfnetlink_log is used
in the OUTPUT/FORWARD/POSTROUTING hooks on packets forwarded from or to a
bridge it crashes when trying to dereference skb->nf_bridge->physoutdev.

Reported by Holger Eitzenberger <heitzenberger@astaro.com>

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 8baa666cdecd6dbb774f0ceca9ea2738f893a02b
tree 950f54d9eec340efe42b10810994ee9f1b6887ba
parent fdc819454fe27437cdaac5674a18373657650068
author Patrick McHardy <kaber@trash.net> Tue, 06 Mar 2007 08:09:06 +0100
committer Patrick McHardy <kaber@trash.net> Tue, 06 Mar 2007 08:09:06 +0100

 net/netfilter/nfnetlink_log.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/netfilter/nfnetlink_log.c b/net/netfilter/nfnetlink_log.c
index 12f92e2..5cb30eb 100644
--- a/net/netfilter/nfnetlink_log.c
+++ b/net/netfilter/nfnetlink_log.c
@@ -486,7 +486,7 @@ #else
 			 * for physical device (when called from ipv4) */
 			NFA_PUT(inst->skb, NFULA_IFINDEX_OUTDEV,
 				sizeof(tmp_uint), &tmp_uint);
-			if (skb->nf_bridge) {
+			if (skb->nf_bridge && skb->nf_bridge->physoutdev) {
 				tmp_uint =
 				    htonl(skb->nf_bridge->physoutdev->ifindex);
 				NFA_PUT(inst->skb, NFULA_IFINDEX_PHYSOUTDEV,
