From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 05/15]: nf_nat: remove broken HOOKNAME macro
Date: Wed,  7 Feb 2007 09:22:43 +0100 (MET)
Message-ID: <20070207082242.27478.11640.sendpatchset@localhost.localdomain>
References: <20070207082228.27478.19484.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
To: davem@davemloft.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <20070207082228.27478.19484.sendpatchset@localhost.localdomain>
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

[NETFILTER]: nf_nat: remove broken HOOKNAME macro

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit cbc5f2f9419e2ef388ce01f9ace8cbb76ff8e357
tree b1aceae682be063d4769a7f3ad4f108ce01db0cb
parent 190276633aff2a1c54c2c5d12788f62c58067f2b
author Patrick McHardy <kaber@trash.net> Tue, 06 Feb 2007 07:36:52 +0100
committer Patrick McHardy <kaber@trash.net> Tue, 06 Feb 2007 08:37:36 +0100

 net/ipv4/netfilter/nf_nat_standalone.c |    6 ------
 1 files changed, 0 insertions(+), 6 deletions(-)

diff --git a/net/ipv4/netfilter/nf_nat_standalone.c b/net/ipv4/netfilter/nf_nat_standalone.c
index 00d6dea..5a964a1 100644
--- a/net/ipv4/netfilter/nf_nat_standalone.c
+++ b/net/ipv4/netfilter/nf_nat_standalone.c
@@ -32,12 +32,6 @@ #else
 #define DEBUGP(format, args...)
 #endif
 
-#define HOOKNAME(hooknum) ((hooknum) == NF_IP_POST_ROUTING ? "POST_ROUTING"  \
-			   : ((hooknum) == NF_IP_PRE_ROUTING ? "PRE_ROUTING" \
-			      : ((hooknum) == NF_IP_LOCAL_OUT ? "LOCAL_OUT"  \
-			         : ((hooknum) == NF_IP_LOCAL_IN ? "LOCAL_IN"  \
-				    : "*ERROR*")))
-
 #ifdef CONFIG_XFRM
 static void nat_decode_session(struct sk_buff *skb, struct flowi *fl)
 {
