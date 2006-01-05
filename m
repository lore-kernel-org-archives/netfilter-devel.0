From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 14/18]: Remove okfn usage in ip_vs_core.c
Date: Thu,  5 Jan 2006 05:06:49 +0100 (MET)
Message-ID: <20060105040613.23512.13982.sendpatchset@localhost.localdomain>
References: <20060105040554.23512.27346.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: David S. Miller <davem@davemloft.net>
In-Reply-To: <20060105040554.23512.27346.sendpatchset@localhost.localdomain>
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

[NETFILTER]: Remove okfn usage in ip_vs_core.c

okfn should only be used from different contexts to avoid deep call chains,
i.e. by nf_queue.

Acked-by: Julian Anastasov <ja@ssi.bg>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 512a75394473e444f2276a3f7fd2c131df5d67d2
tree a69377e98cc3027a1e45b67377b54c0d181515f6
parent 10ee519ab7a421aa8a6fc62af197e7bdbd547b3e
author Patrick McHardy <kaber@trash.net> Thu, 05 Jan 2006 03:07:18 +0100
committer Patrick McHardy <kaber@trash.net> Thu, 05 Jan 2006 03:07:18 +0100

 net/ipv4/ipvs/ip_vs_core.c |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/net/ipv4/ipvs/ip_vs_core.c b/net/ipv4/ipvs/ip_vs_core.c
index 1a0843c..b63bb28 100644
--- a/net/ipv4/ipvs/ip_vs_core.c
+++ b/net/ipv4/ipvs/ip_vs_core.c
@@ -532,11 +532,8 @@ static unsigned int ip_vs_post_routing(u
 {
 	if (!((*pskb)->ipvs_property))
 		return NF_ACCEPT;
-
 	/* The packet was sent from IPVS, exit this chain */
-	(*okfn)(*pskb);
-
-	return NF_STOLEN;
+	return NF_STOP;
 }
 
 u16 ip_vs_checksum_complete(struct sk_buff *skb, int offset)
