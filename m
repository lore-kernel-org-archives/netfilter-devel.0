From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 13/18]: ctnetlink: Fix dumping of helper name
Date: Thu,  5 Jan 2006 05:06:47 +0100 (MET)
Message-ID: <20060105040612.23512.59260.sendpatchset@localhost.localdomain>
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

[NETFILTER]: ctnetlink: Fix dumping of helper name

Properly dump the helper name instead of internal kernel data.
Based on patch by Marcus Sundberg <marcus@ingate.com>.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 10ee519ab7a421aa8a6fc62af197e7bdbd547b3e
tree 7e2970bdeaee1e44e72ee27f1e90cace28522319
parent f771b92e29f4a46b7e5cd506f2584bfae187ba6a
author Patrick McHardy <kaber@trash.net> Thu, 05 Jan 2006 02:58:46 +0100
committer Patrick McHardy <kaber@trash.net> Thu, 05 Jan 2006 02:58:46 +0100

 include/linux/netfilter/nfnetlink_conntrack.h |    2 --
 net/ipv4/netfilter/ip_conntrack_netlink.c     |    2 +-
 2 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/include/linux/netfilter/nfnetlink_conntrack.h b/include/linux/netfilter/nfnetlink_conntrack.h
index b8e9a5b..668ec94 100644
--- a/include/linux/netfilter/nfnetlink_conntrack.h
+++ b/include/linux/netfilter/nfnetlink_conntrack.h
@@ -131,6 +131,4 @@ enum ctattr_help {
 };
 #define CTA_HELP_MAX (__CTA_HELP_MAX - 1)
 
-#define CTA_HELP_MAXNAMESIZE	32
-
 #endif /* _IPCONNTRACK_NETLINK_H */
diff --git a/net/ipv4/netfilter/ip_conntrack_netlink.c b/net/ipv4/netfilter/ip_conntrack_netlink.c
index 1763764..a572b16 100644
--- a/net/ipv4/netfilter/ip_conntrack_netlink.c
+++ b/net/ipv4/netfilter/ip_conntrack_netlink.c
@@ -161,7 +161,7 @@ ctnetlink_dump_helpinfo(struct sk_buff *
 		return 0;
 		
 	nest_helper = NFA_NEST(skb, CTA_HELP);
-	NFA_PUT(skb, CTA_HELP_NAME, CTA_HELP_MAXNAMESIZE, &ct->helper->name);
+	NFA_PUT(skb, CTA_HELP_NAME, strlen(ct->helper->name), ct->helper->name);
 
 	if (ct->helper->to_nfattr)
 		ct->helper->to_nfattr(skb, ct);
