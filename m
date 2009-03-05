From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH] nefilter: nfnetlink: add nfnetlink_set_err and use it in
	ctnetlink
Date: Thu, 05 Mar 2009 17:32:08 +0100
Message-ID: <20090305163208.14553.517.stgit@Decadence>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:55112 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752488AbZCEQcS (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 5 Mar 2009 11:32:18 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch adds nfnetlink_set_err() to propagate the error to netlink
broadcast listener in case of memory allocation errors in the
message building.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---

 include/linux/netfilter/nfnetlink.h  |    1 +
 net/netfilter/nf_conntrack_netlink.c |    2 ++
 net/netfilter/nfnetlink.c            |    6 ++++++
 net/netlink/af_netlink.c             |    1 +
 4 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/include/linux/netfilter/nfnetlink.h b/include/linux/netfilter/nfnetlink.h
index 7d8e045..97ade6c 100644
--- a/include/linux/netfilter/nfnetlink.h
+++ b/include/linux/netfilter/nfnetlink.h
@@ -76,6 +76,7 @@ extern int nfnetlink_subsys_unregister(const struct nfnetlink_subsystem *n);
 extern int nfnetlink_has_listeners(unsigned int group);
 extern int nfnetlink_send(struct sk_buff *skb, u32 pid, unsigned group, 
 			  int echo);
+extern void nfnetlink_set_err(u32 group, int error);
 extern int nfnetlink_unicast(struct sk_buff *skb, u_int32_t pid, int flags);
 
 extern void nfnl_lock(void);
diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index c9db6ec..02ee8e1 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -619,6 +619,7 @@ static int ctnetlink_conntrack_event(struct notifier_block *this,
 nla_put_failure:
 	rcu_read_unlock();
 nlmsg_failure:
+	nfnetlink_set_err(group, -ENOBUFS);
 	kfree_skb(skb);
 	return NOTIFY_DONE;
 }
@@ -1643,6 +1644,7 @@ static int ctnetlink_expect_event(struct notifier_block *this,
 nla_put_failure:
 	rcu_read_unlock();
 nlmsg_failure:
+	nfnetlink_set_err(0, -ENOBUFS);
 	kfree_skb(skb);
 	return NOTIFY_DONE;
 }
diff --git a/net/netfilter/nfnetlink.c b/net/netfilter/nfnetlink.c
index 9c0ba17..cd85c56 100644
--- a/net/netfilter/nfnetlink.c
+++ b/net/netfilter/nfnetlink.c
@@ -113,6 +113,12 @@ int nfnetlink_send(struct sk_buff *skb, u32 pid, unsigned group, int echo)
 }
 EXPORT_SYMBOL_GPL(nfnetlink_send);
 
+void nfnetlink_set_err(u32 group, int error)
+{
+	netlink_set_err(nfnl, 0, group, error);
+}
+EXPORT_SYMBOL_GPL(nfnetlink_set_err);
+
 int nfnetlink_unicast(struct sk_buff *skb, u_int32_t pid, int flags)
 {
 	return netlink_unicast(nfnl, skb, pid, flags);
diff --git a/net/netlink/af_netlink.c b/net/netlink/af_netlink.c
index 09e5008..dc93836 100644
--- a/net/netlink/af_netlink.c
+++ b/net/netlink/af_netlink.c
@@ -1118,6 +1118,7 @@ void netlink_set_err(struct sock *ssk, u32 pid, u32 group, int code)
 
 	read_unlock(&nl_table_lock);
 }
+EXPORT_SYMBOL(netlink_set_err);
 
 /* must be called with netlink table grabbed */
 static void netlink_update_socket_mc(struct netlink_sock *nlk,

