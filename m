From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 04/18]: conntrack: introduce connection mark event
Date: Tue, 22 Aug 2006 00:52:23 +0200 (MEST)
Message-ID: <20060821225223.10288.810.sendpatchset@localhost.localdomain>
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

[NETFILTER]: conntrack: introduce connection mark event

This patch introduces the mark event. ctnetlink can use this to know if
the mark needs to be dumped.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 706761e6047b57ee8fa33c2eca912ffc5f36bfa7
tree 450fe3c2d130148e1e88909f1ef6b2b2ae1c0496
parent 55eeb35cfb789640cc0d3b179398b196286c5991
author Pablo Neira Ayuso <pablo@netfilter.org> Fri, 11 Aug 2006 21:01:12 +0200
committer Patrick McHardy <kaber@trash.net> Fri, 11 Aug 2006 21:01:12 +0200

 include/linux/netfilter/nf_conntrack_common.h |    4 ++++
 net/netfilter/xt_CONNMARK.c                   |   16 ++++++++++++++--
 2 files changed, 18 insertions(+), 2 deletions(-)

diff --git a/include/linux/netfilter/nf_conntrack_common.h b/include/linux/netfilter/nf_conntrack_common.h
index d2e4bd7..9e0dae0 100644
--- a/include/linux/netfilter/nf_conntrack_common.h
+++ b/include/linux/netfilter/nf_conntrack_common.h
@@ -125,6 +125,10 @@ enum ip_conntrack_events
 	/* Counter highest bit has been set */
 	IPCT_COUNTER_FILLING_BIT = 11,
 	IPCT_COUNTER_FILLING = (1 << IPCT_COUNTER_FILLING_BIT),
+
+	/* Mark is set */
+	IPCT_MARK_BIT = 12,
+	IPCT_MARK = (1 << IPCT_MARK_BIT),
 };
 
 enum ip_conntrack_expect_events {
diff --git a/net/netfilter/xt_CONNMARK.c b/net/netfilter/xt_CONNMARK.c
index 60c375d..784482b 100644
--- a/net/netfilter/xt_CONNMARK.c
+++ b/net/netfilter/xt_CONNMARK.c
@@ -52,13 +52,25 @@ target(struct sk_buff **pskb,
 	    switch(markinfo->mode) {
 	    case XT_CONNMARK_SET:
 		newmark = (*ctmark & ~markinfo->mask) | markinfo->mark;
-		if (newmark != *ctmark)
+		if (newmark != *ctmark) {
 		    *ctmark = newmark;
+#ifdef CONFIG_IP_NF_CONNTRACK_EVENTS
+		    ip_conntrack_event_cache(IPCT_MARK, *pskb);
+#else
+		    nf_conntrack_event_cache(IPCT_MARK, *pskb);
+#endif
+		}
 		break;
 	    case XT_CONNMARK_SAVE:
 		newmark = (*ctmark & ~markinfo->mask) | ((*pskb)->nfmark & markinfo->mask);
-		if (*ctmark != newmark)
+		if (*ctmark != newmark) {
 		    *ctmark = newmark;
+#ifdef CONFIG_IP_NF_CONNTRACK_EVENTS
+		    ip_conntrack_event_cache(IPCT_MARK, *pskb);
+#else
+		    nf_conntrack_event_cache(IPCT_MARK, *pskb);
+#endif
+		}
 		break;
 	    case XT_CONNMARK_RESTORE:
 		nfmark = (*pskb)->nfmark;
