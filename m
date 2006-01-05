From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 07/18]: ctnetlink: ctnetlink_event cleanup
Date: Thu,  5 Jan 2006 05:06:39 +0100 (MET)
Message-ID: <20060105040603.23512.45375.sendpatchset@localhost.localdomain>
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

[NETFILTER]: ctnetlink: ctnetlink_event cleanup

Cleanup: Use 'else if' instead of a ugly 'goto' statement.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit d1e28c10106f0f49384d3f4e4303a2944d977e86
tree a89a207ba2caa1d4cebda6e086c4d5c089cb9036
parent 4cf0ebc33ac486730b4af5657f683673c25ee599
author Pablo Neira Ayuso <pablo@netfilter.org> Thu, 05 Jan 2006 02:55:15 +0100
committer Patrick McHardy <kaber@trash.net> Thu, 05 Jan 2006 02:55:15 +0100

 net/ipv4/netfilter/ip_conntrack_netlink.c |   15 ++++-----------
 1 files changed, 4 insertions(+), 11 deletions(-)

diff --git a/net/ipv4/netfilter/ip_conntrack_netlink.c b/net/ipv4/netfilter/ip_conntrack_netlink.c
index faa027b..04137d0 100644
--- a/net/ipv4/netfilter/ip_conntrack_netlink.c
+++ b/net/ipv4/netfilter/ip_conntrack_netlink.c
@@ -312,29 +312,22 @@ static int ctnetlink_conntrack_event(str
 	if (events & IPCT_DESTROY) {
 		type = IPCTNL_MSG_CT_DELETE;
 		group = NFNLGRP_CONNTRACK_DESTROY;
-		goto alloc_skb;
-	}
-	if (events & (IPCT_NEW | IPCT_RELATED)) {
+	} else if (events & (IPCT_NEW | IPCT_RELATED)) {
 		type = IPCTNL_MSG_CT_NEW;
 		flags = NLM_F_CREATE|NLM_F_EXCL;
 		/* dump everything */
 		events = ~0UL;
 		group = NFNLGRP_CONNTRACK_NEW;
-		goto alloc_skb;
-	}
-	if (events & (IPCT_STATUS |
+	} else if (events & (IPCT_STATUS |
 		      IPCT_PROTOINFO |
 		      IPCT_HELPER |
 		      IPCT_HELPINFO |
 		      IPCT_NATINFO)) {
 		type = IPCTNL_MSG_CT_NEW;
 		group = NFNLGRP_CONNTRACK_UPDATE;
-		goto alloc_skb;
-	} 
+	} else 
+		return NOTIFY_DONE;
 	
-	return NOTIFY_DONE;
-
-alloc_skb:
   /* FIXME: Check if there are any listeners before, don't hurt performance */
 	
 	skb = alloc_skb(NLMSG_GOODSIZE, GFP_ATOMIC);
