From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 13/13]: ctnetlink: avoid unneccessary event message
	generation
Date: Thu, 16 Feb 2006 22:32:28 +0100 (MET)
Message-ID: <20060216213228.6933.24929.sendpatchset@localhost.localdomain>
References: <20060216213207.6933.99672.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: davem@davemloft.net
In-Reply-To: <20060216213207.6933.99672.sendpatchset@localhost.localdomain>
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

[NETFILTER]: ctnetlink: avoid unneccessary event message generation

Avoid unneccessary event message generation by checking for netlink
listeners before building a message.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 0d101f9f648b51101f3c4ba4ba39b76b4a3e12c8
tree f3bf95231f93cf57d25e3239eebbe897a2927259
parent 3a3198cc233706dcead7c9642201cc747579a677
author Patrick McHardy <kaber@trash.net> Thu, 16 Feb 2006 14:35:58 +0100
committer Patrick McHardy <kaber@trash.net> Thu, 16 Feb 2006 14:35:58 +0100

 include/linux/netfilter/nfnetlink.h       |    1 +
 net/ipv4/netfilter/ip_conntrack_netlink.c |    7 ++++---
 net/netfilter/nf_conntrack_netlink.c      |    7 ++++---
 net/netfilter/nfnetlink.c                 |    6 ++++++
 4 files changed, 15 insertions(+), 6 deletions(-)

diff --git a/include/linux/netfilter/nfnetlink.h b/include/linux/netfilter/nfnetlink.h
index 934a247..9f5b12c 100644
--- a/include/linux/netfilter/nfnetlink.h
+++ b/include/linux/netfilter/nfnetlink.h
@@ -164,6 +164,7 @@ extern void nfattr_parse(struct nfattr *
  	__res;								\
 })
 
+extern int nfnetlink_has_listeners(unsigned int group);
 extern int nfnetlink_send(struct sk_buff *skb, u32 pid, unsigned group, 
 			  int echo);
 extern int nfnetlink_unicast(struct sk_buff *skb, u_int32_t pid, int flags);
diff --git a/net/ipv4/netfilter/ip_conntrack_netlink.c b/net/ipv4/netfilter/ip_conntrack_netlink.c
index e0b5926..5ce2e3f 100644
--- a/net/ipv4/netfilter/ip_conntrack_netlink.c
+++ b/net/ipv4/netfilter/ip_conntrack_netlink.c
@@ -327,9 +327,10 @@ static int ctnetlink_conntrack_event(str
 		group = NFNLGRP_CONNTRACK_UPDATE;
 	} else 
 		return NOTIFY_DONE;
-	
-  /* FIXME: Check if there are any listeners before, don't hurt performance */
-	
+
+	if (!nfnetlink_has_listeners(group))
+		return NOTIFY_DONE;
+
 	skb = alloc_skb(NLMSG_GOODSIZE, GFP_ATOMIC);
 	if (!skb)
 		return NOTIFY_DONE;
diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index f0d6fc9..20db402 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -338,9 +338,10 @@ static int ctnetlink_conntrack_event(str
 		group = NFNLGRP_CONNTRACK_UPDATE;
 	} else
 		return NOTIFY_DONE;
-	
-  /* FIXME: Check if there are any listeners before, don't hurt performance */
-	
+
+	if (!nfnetlink_has_listeners(group))
+		return NOTIFY_DONE;
+
 	skb = alloc_skb(NLMSG_GOODSIZE, GFP_ATOMIC);
 	if (!skb)
 		return NOTIFY_DONE;
diff --git a/net/netfilter/nfnetlink.c b/net/netfilter/nfnetlink.c
index f6063e8..b88e82a 100644
--- a/net/netfilter/nfnetlink.c
+++ b/net/netfilter/nfnetlink.c
@@ -191,6 +191,12 @@ nfnetlink_check_attributes(struct nfnetl
         return 0;
 }
 
+int nfnetlink_has_listeners(unsigned int group)
+{
+	return netlink_has_listeners(nfnl, group);
+}
+EXPORT_SYMBOL_GPL(nfnetlink_has_listeners);
+
 int nfnetlink_send(struct sk_buff *skb, u32 pid, unsigned group, int echo)
 {
 	gfp_t allocation = in_interrupt() ? GFP_ATOMIC : GFP_KERNEL;
