From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 06/18]: ctnetlink: check for listeners before sending
	expectation events
Date: Tue, 22 Aug 2006 00:52:26 +0200 (MEST)
Message-ID: <20060821225225.10288.61654.sendpatchset@localhost.localdomain>
References: <20060821225217.10288.69738.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: davem@davemloft.net
In-Reply-To: <20060821225217.10288.69738.sendpatchset@localhost.localdomain>
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

[NETFILTER]: ctnetlink: check for listeners before sending expectation events

This patch uses nfnetlink_has_listeners to check for listeners in
userspace.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 67b49f9ce48d6acb259d20a38bf1d131250a01c6
tree a68fa4897286bc09b28047f8de29f38c57301f51
parent 430bb812a0703f2faddbe92a097d0ef7289b963b
author Pablo Neira Ayuso <pablo@netfilter.org> Fri, 11 Aug 2006 21:01:23 +0200
committer Patrick McHardy <kaber@trash.net> Fri, 11 Aug 2006 21:01:23 +0200

 net/ipv4/netfilter/ip_conntrack_netlink.c |    3 +++
 net/netfilter/nf_conntrack_netlink.c      |    3 +++
 2 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/net/ipv4/netfilter/ip_conntrack_netlink.c b/net/ipv4/netfilter/ip_conntrack_netlink.c
index 319022e..090df76 100644
--- a/net/ipv4/netfilter/ip_conntrack_netlink.c
+++ b/net/ipv4/netfilter/ip_conntrack_netlink.c
@@ -1260,6 +1260,9 @@ static int ctnetlink_expect_event(struct
 	} else
 		return NOTIFY_DONE;
 
+	if (!nfnetlink_has_listeners(NFNLGRP_CONNTRACK_EXP_NEW))
+		return NOTIFY_DONE;
+
 	skb = alloc_skb(NLMSG_GOODSIZE, GFP_ATOMIC);
 	if (!skb)
 		return NOTIFY_DONE;
diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index ed8268a..81bcbe8 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -1281,6 +1281,9 @@ static int ctnetlink_expect_event(struct
 	} else
 		return NOTIFY_DONE;
 
+	if (!nfnetlink_has_listeners(NFNLGRP_CONNTRACK_EXP_NEW))
+		return NOTIFY_DONE;
+
 	skb = alloc_skb(NLMSG_GOODSIZE, GFP_ATOMIC);
 	if (!skb)
 		return NOTIFY_DONE;
