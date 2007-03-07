From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 13/13]: nfnetlink_log: fix crash on bridged packet
Date: Wed,  7 Mar 2007 22:34:45 +0100 (MET)
Message-ID: <20070307213405.22306.94073.sendpatchset@localhost.localdomain>
References: <20070307213347.22306.9248.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>,
	davem@davemloft.net
To: stable@kernel.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <20070307213347.22306.9248.sendpatchset@localhost.localdomain>
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
commit f6b1560a99c15c4a36c891d576fadb017b12da58
tree a2db90ece908c7334c5a8167cfdf36e8aefedc4f
parent 80124a592479a1730fde6fb370c80d705d889ce3
author Patrick McHardy <kaber@trash.net> Tue, 06 Mar 2007 08:31:57 +0100
committer Patrick McHardy <kaber@trash.net> Tue, 06 Mar 2007 08:31:57 +0100

 net/netfilter/nfnetlink_log.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/netfilter/nfnetlink_log.c b/net/netfilter/nfnetlink_log.c
index 5675d2d..60d821f 100644
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
