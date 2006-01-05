From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 06/18]: ctnetlink: use u_int32_t instead of unsigned int
Date: Thu,  5 Jan 2006 05:06:37 +0100 (MET)
Message-ID: <20060105040602.23512.77706.sendpatchset@localhost.localdomain>
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

[NETFILTER]: ctnetlink: use u_int32_t instead of unsigned int

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 4cf0ebc33ac486730b4af5657f683673c25ee599
tree 084b7be976ae7aba4ce2707a66f76c01dff13431
parent c1dbf7cb5f9690b9bb12dc0707278376760e4839
author Pablo Neira Ayuso <pablo@netfilter.org> Thu, 05 Jan 2006 02:54:58 +0100
committer Patrick McHardy <kaber@trash.net> Thu, 05 Jan 2006 02:54:58 +0100

 net/ipv4/netfilter/ip_conntrack_netlink.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/ipv4/netfilter/ip_conntrack_netlink.c b/net/ipv4/netfilter/ip_conntrack_netlink.c
index 5e9affd..faa027b 100644
--- a/net/ipv4/netfilter/ip_conntrack_netlink.c
+++ b/net/ipv4/netfilter/ip_conntrack_netlink.c
@@ -230,7 +230,7 @@ nfattr_failure:
 static inline int
 ctnetlink_dump_use(struct sk_buff *skb, const struct ip_conntrack *ct)
 {
-	unsigned int use = htonl(atomic_read(&ct->ct_general.use));
+	u_int32_t use = htonl(atomic_read(&ct->ct_general.use));
 	
 	NFA_PUT(skb, CTA_USE, sizeof(u_int32_t), &use);
 	return 0;
