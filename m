From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 01/04]: nfnetlink_log: fix byteorder of NFULA_SEQ_GLOBAL
Date: Tue, 14 Nov 2006 08:03:28 +0100 (MET)
Message-ID: <20061114070327.13023.70644.sendpatchset@localhost.localdomain>
References: <20061114070325.13023.10720.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: davem@davemloft.net
In-Reply-To: <20061114070325.13023.10720.sendpatchset@localhost.localdomain>
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

[NETFILTER]: nfnetlink_log: fix byteorder of NFULA_SEQ_GLOBAL

NFULA_SEQ_GLOBAL should be in network byteorder.

Spotted by Al Viro.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 7c1ac6f74a10cb9fe0800de7e9a1626497dde438
tree bae81087a86be5325fd94b6c6ec26023328e09e0
parent bb831eb2027c12a740ad4e4ad78f2a0e841ae808
author Patrick McHardy <kaber@trash.net> Tue, 14 Nov 2006 07:53:30 +0100
committer Patrick McHardy <kaber@trash.net> Tue, 14 Nov 2006 07:53:30 +0100

 net/netfilter/nfnetlink_log.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/netfilter/nfnetlink_log.c b/net/netfilter/nfnetlink_log.c
index b2bf8f2..1e5207b 100644
--- a/net/netfilter/nfnetlink_log.c
+++ b/net/netfilter/nfnetlink_log.c
@@ -544,7 +544,7 @@ #endif
 	}
 	/* global sequence number */
 	if (inst->flags & NFULNL_CFG_F_SEQ_GLOBAL) {
-		tmp_uint = atomic_inc_return(&global_seq);
+		tmp_uint = htonl(atomic_inc_return(&global_seq));
 		NFA_PUT(inst->skb, NFULA_SEQ_GLOBAL, sizeof(tmp_uint), &tmp_uint);
 	}
 
