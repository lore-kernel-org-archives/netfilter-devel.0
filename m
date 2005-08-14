From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 3/4]: Make NETMAP target usable in OUTPUT
Date: Mon, 15 Aug 2005 00:43:56 +0200
Message-ID: <42FFC92C.1030304@trash.net>
Mime-Version: 1.0
Content-Type: text/x-patch;
 name="03.diff"
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "David S. Miller" <davem@davemloft.net>
Content-Disposition: inline;
 filename="03.diff"
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

[NETFILTER]: Make NETMAP target usable in OUTPUT

Signed-off-by: Gary Wayne Smith <gary.w.smith@primeexalia.com>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 7ea3224e415f93eff91b7e21cfb99fc39b2c1e90
tree bcae188c7e54ec80398c581d73d4ffa2176b0a80
parent 17bfdaf02646cc6fafa9fa661e4c6e8775a9af3a
author Gary Wayne Smith <gary.w.smith@primeexalia.com> Mon, 15 Aug 2005 00:32:48 +0200
committer Patrick McHardy <kaber@trash.net> Mon, 15 Aug 2005 00:32:48 +0200

 net/ipv4/netfilter/ipt_NETMAP.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/net/ipv4/netfilter/ipt_NETMAP.c b/net/ipv4/netfilter/ipt_NETMAP.c
--- a/net/ipv4/netfilter/ipt_NETMAP.c
+++ b/net/ipv4/netfilter/ipt_NETMAP.c
@@ -46,7 +46,8 @@ check(const char *tablename,
 		DEBUGP(MODULENAME":check: size %u.\n", targinfosize);
 		return 0;
 	}
-	if (hook_mask & ~((1 << NF_IP_PRE_ROUTING) | (1 << NF_IP_POST_ROUTING))) {
+	if (hook_mask & ~((1 << NF_IP_PRE_ROUTING) | (1 << NF_IP_POST_ROUTING) |
+	                  (1 << NF_IP_LOCAL_OUT))) {
 		DEBUGP(MODULENAME":check: bad hooks %x.\n", hook_mask);
 		return 0;
 	}
@@ -76,12 +77,13 @@ target(struct sk_buff **pskb,
 	struct ip_nat_range newrange;
 
 	IP_NF_ASSERT(hooknum == NF_IP_PRE_ROUTING
-		     || hooknum == NF_IP_POST_ROUTING);
+		     || hooknum == NF_IP_POST_ROUTING
+		     || hooknum == NF_IP_LOCAL_OUT);
 	ct = ip_conntrack_get(*pskb, &ctinfo);
 
 	netmask = ~(mr->range[0].min_ip ^ mr->range[0].max_ip);
 
-	if (hooknum == NF_IP_PRE_ROUTING)
+	if (hooknum == NF_IP_PRE_ROUTING || hooknum == NF_IP_LOCAL_OUT)
 		new_ip = (*pskb)->nh.iph->daddr & ~netmask;
 	else
 		new_ip = (*pskb)->nh.iph->saddr & ~netmask;
