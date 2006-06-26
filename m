From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 04/06]: xt_sctp: fix --chunk-types matching
Date: Mon, 26 Jun 2006 17:43:12 +0200 (MEST)
Message-ID: <20060626154312.11682.68659.sendpatchset@localhost.localdomain>
References: <20060626154307.11682.28562.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: davem@davemloft.net
In-Reply-To: <20060626154307.11682.28562.sendpatchset@localhost.localdomain>
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

[NETFILTER]: xt_sctp: fix --chunk-types matching

xt_sctp uses an incorrect header offset when --chunk-types is used.

Signed-off-by: Jorge Matias <jorge.matias@motorola.com>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 9565b859bc682e4c208f73e83adb21a7f86d0143
tree 7823e21bbe10b265fe011cb895f30160789210ad
parent a81302ac4c22da108602d0c053c168a700c81e32
author Jorge Matias <jorge.matias@motorola.com> Mon, 19 Jun 2006 18:04:28 +0200
committer Patrick McHardy <kaber@trash.net> Mon, 19 Jun 2006 18:04:28 +0200

 net/netfilter/xt_sctp.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/netfilter/xt_sctp.c b/net/netfilter/xt_sctp.c
index b5110e5..919c037 100644
--- a/net/netfilter/xt_sctp.c
+++ b/net/netfilter/xt_sctp.c
@@ -151,7 +151,7 @@ match(const struct sk_buff *skb,
 		&& SCCHECK(((ntohs(sh->dest) >= info->dpts[0]) 
 			&& (ntohs(sh->dest) <= info->dpts[1])), 
 			XT_SCTP_DEST_PORTS, info->flags, info->invflags)
-		&& SCCHECK(match_packet(skb, protoff,
+		&& SCCHECK(match_packet(skb, protoff + sizeof (sctp_sctphdr_t),
 					info->chunkmap, info->chunk_match_type,
  					info->flag_info, info->flag_count, 
 					hotdrop),
