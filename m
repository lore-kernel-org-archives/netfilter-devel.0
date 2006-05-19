From: Eric Leblond <eric@inl.fr>
Subject: [PATCH] Unconditionaly push mark to conntrack structure
Date: Fri, 19 May 2006 08:45:17 +0000 (UTC)
Message-ID: <E1Fh0am-0003Ct-Ph@fydelkass.inl.fr>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
Resent-Message-ID: <20060519083925.GB19855@profy.inl.fr>
To: netfilter-devel@lists.netfilter.org
Date: Fri May 19 10:28:45 2006 +0200
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

This is needed in userspace as the mark can be used to select 
efficiently a subset of the conntrack events to work on.

Signed-off-by: Eric Leblond <eric@inl.fr>


---

 net/ipv4/netfilter/ip_conntrack_netlink.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

a0d56f7badb6267e07582a569c82779b2cdb2711
diff --git a/net/ipv4/netfilter/ip_conntrack_netlink.c b/net/ipv4/netfilter/ip_conntrack_netlink.c
index 0fee630..02531fe 100644
--- a/net/ipv4/netfilter/ip_conntrack_netlink.c
+++ b/net/ipv4/netfilter/ip_conntrack_netlink.c
@@ -381,8 +381,8 @@ static int ctnetlink_conntrack_event(str
 	if (events & IPCT_HELPINFO
 	    && ctnetlink_dump_helpinfo(skb, ct) < 0)
 		goto nfattr_failure;
-	if (events & IPCT_MARK
-	    && ctnetlink_dump_mark(skb, ct) < 0)
+
+	if (ctnetlink_dump_mark(skb, ct) < 0)
 		goto nfattr_failure;
 
 	if (ctnetlink_dump_counters(skb, ct, IP_CT_DIR_ORIGINAL) < 0 ||
-- 
1.2.6
