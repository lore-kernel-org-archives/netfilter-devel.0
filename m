From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 05/18]: ctnetlink: propagate ctnetlink_dump_tuples_proto
	return value back
Date: Thu,  5 Jan 2006 05:06:36 +0100 (MET)
Message-ID: <20060105040600.23512.23865.sendpatchset@localhost.localdomain>
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

[NETFILTER]: ctnetlink: propagate ctnetlink_dump_tuples_proto return value back

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit c1dbf7cb5f9690b9bb12dc0707278376760e4839
tree 52427c40ad1f88b57bde7aafb91c9ba2adb8d938
parent f067059d5e3d09c6679d860eb8c283df7f0f3420
author Pablo Neira Ayuso <pablo@netfilter.org> Thu, 05 Jan 2006 02:54:30 +0100
committer Patrick McHardy <kaber@trash.net> Thu, 05 Jan 2006 02:54:30 +0100

 net/ipv4/netfilter/ip_conntrack_netlink.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/netfilter/ip_conntrack_netlink.c b/net/ipv4/netfilter/ip_conntrack_netlink.c
index 91fe8f2..5e9affd 100644
--- a/net/ipv4/netfilter/ip_conntrack_netlink.c
+++ b/net/ipv4/netfilter/ip_conntrack_netlink.c
@@ -79,6 +79,7 @@ ctnetlink_dump_tuples(struct sk_buff *sk
 		      const struct ip_conntrack_tuple *tuple)
 {
 	struct nfattr *nest_parms;
+	int ret;
 	
 	nest_parms = NFA_NEST(skb, CTA_TUPLE_IP);
 	NFA_PUT(skb, CTA_IP_V4_SRC, sizeof(u_int32_t), &tuple->src.ip);
@@ -86,10 +87,10 @@ ctnetlink_dump_tuples(struct sk_buff *sk
 	NFA_NEST_END(skb, nest_parms);
 
 	nest_parms = NFA_NEST(skb, CTA_TUPLE_PROTO);
-	ctnetlink_dump_tuples_proto(skb, tuple);
+	ret = ctnetlink_dump_tuples_proto(skb, tuple);
 	NFA_NEST_END(skb, nest_parms);
 
-	return 0;
+	return ret;
 
 nfattr_failure:
 	return -1;
