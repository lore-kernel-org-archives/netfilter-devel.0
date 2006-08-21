From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 05/18]: ctnetlink: dump connection mark
Date: Tue, 22 Aug 2006 00:52:24 +0200 (MEST)
Message-ID: <20060821225224.10288.77960.sendpatchset@localhost.localdomain>
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

[NETFILTER]: ctnetlink: dump connection mark

ctnetlink dumps the mark iif the event mark happened

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 430bb812a0703f2faddbe92a097d0ef7289b963b
tree e2c09a86971ac58d9b4ed85bf5962a9e360bbf05
parent 706761e6047b57ee8fa33c2eca912ffc5f36bfa7
author Pablo Neira Ayuso <pablo@netfilter.org> Fri, 11 Aug 2006 21:01:17 +0200
committer Patrick McHardy <kaber@trash.net> Fri, 11 Aug 2006 21:01:17 +0200

 net/ipv4/netfilter/ip_conntrack_netlink.c |    4 ++++
 net/netfilter/nf_conntrack_netlink.c      |    4 ++++
 2 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/net/ipv4/netfilter/ip_conntrack_netlink.c b/net/ipv4/netfilter/ip_conntrack_netlink.c
index 33891bb..319022e 100644
--- a/net/ipv4/netfilter/ip_conntrack_netlink.c
+++ b/net/ipv4/netfilter/ip_conntrack_netlink.c
@@ -385,6 +385,10 @@ static int ctnetlink_conntrack_event(str
 	    ctnetlink_dump_counters(skb, ct, IP_CT_DIR_REPLY) < 0)
 		goto nfattr_failure;
 
+	if (events & IPCT_MARK
+	    && ctnetlink_dump_mark(skb, ct) < 0)
+		goto nfattr_failure;
+
 	nlh->nlmsg_len = skb->tail - b;
 	nfnetlink_send(skb, 0, group, 0);
 	return NOTIFY_DONE;
diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index af48459..ed8268a 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -395,6 +395,10 @@ static int ctnetlink_conntrack_event(str
 	    ctnetlink_dump_counters(skb, ct, IP_CT_DIR_REPLY) < 0)
 		goto nfattr_failure;
 
+	if (events & IPCT_MARK
+	    && ctnetlink_dump_mark(skb, ct) < 0)
+		goto nfattr_failure;
+
 	nlh->nlmsg_len = skb->tail - b;
 	nfnetlink_send(skb, 0, group, 0);
 	return NOTIFY_DONE;
