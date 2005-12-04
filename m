From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 3/9]: Fix incorrect argument to ip_nat_initialized() in
	ctnetlink
Date: Sun, 04 Dec 2005 22:01:20 +0100
Message-ID: <20051204210120.24032.24517.sendpatchset@localhost.localdomain>
References: <20051204210116.24032.9802.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: David S. Miller <davem@davemloft.net>
In-Reply-To: <20051204210116.24032.9802.sendpatchset@localhost.localdomain>
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

[NETFILTER]: Fix incorrect argument to ip_nat_initialized() in ctnetlink

ip_nat_initialized() takes enum ip_nat_manip_type as it's second argument,
not a hook number.

Noticed and initial patch by Marcus Sundberg <marcus@ingate.com>.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 5b33d73e5d4153241c8e2378332f9810f4eca160
tree 4a1ec661e39d1adf96e8621b36236882295b03ff
parent 1ec1f9de65434db4bac6141e25c5b8a6b5110e4f
author Pablo Neira Ayuso <pablo@netfilter.org> Sun, 04 Dec 2005 16:35:54 +0100
committer Patrick McHardy <kaber@trash.net> Sun, 04 Dec 2005 16:35:54 +0100

 net/ipv4/netfilter/ip_conntrack_netlink.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/ipv4/netfilter/ip_conntrack_netlink.c b/net/ipv4/netfilter/ip_conntrack_netlink.c
index 3fce91b..70402e0 100644
--- a/net/ipv4/netfilter/ip_conntrack_netlink.c
+++ b/net/ipv4/netfilter/ip_conntrack_netlink.c
@@ -877,7 +877,7 @@ ctnetlink_change_status(struct ip_conntr
 		DEBUGP("NAT status: %lu\n", 
 		       status & (IPS_NAT_MASK | IPS_NAT_DONE_MASK));
 		
-		if (ip_nat_initialized(ct, hooknum))
+		if (ip_nat_initialized(ct, HOOK2MANIP(hooknum)))
 			return -EEXIST;
 		ip_nat_setup_info(ct, &range, hooknum);
 
