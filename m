From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 10/18]: xt_CONNMARK: use tabs for indentation
Date: Tue, 22 Aug 2006 00:52:31 +0200 (MEST)
Message-ID: <20060821225231.10288.68694.sendpatchset@localhost.localdomain>
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

[NETFILTER]: xt_CONNMARK: use tabs for indentation

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit c3e06d8b091765def127afcc148835736d64fad5
tree cd0512e19c5b2958a06ac0c0bf22a018242787df
parent 54ba0f09d3cb3d4ce48e4eb8cb9cae3ac60bade1
author Patrick McHardy <kaber@trash.net> Sun, 13 Aug 2006 17:19:50 +0200
committer Patrick McHardy <kaber@trash.net> Sun, 13 Aug 2006 17:19:50 +0200

 net/netfilter/xt_CONNMARK.c |   57 ++++++++++++++++++++++---------------------
 1 files changed, 29 insertions(+), 28 deletions(-)

diff --git a/net/netfilter/xt_CONNMARK.c b/net/netfilter/xt_CONNMARK.c
index 784482b..19989a9 100644
--- a/net/netfilter/xt_CONNMARK.c
+++ b/net/netfilter/xt_CONNMARK.c
@@ -49,36 +49,37 @@ target(struct sk_buff **pskb,
 	u_int32_t *ctmark = nf_ct_get_mark(*pskb, &ctinfo);
 
 	if (ctmark) {
-	    switch(markinfo->mode) {
-	    case XT_CONNMARK_SET:
-		newmark = (*ctmark & ~markinfo->mask) | markinfo->mark;
-		if (newmark != *ctmark) {
-		    *ctmark = newmark;
+		switch(markinfo->mode) {
+		case XT_CONNMARK_SET:
+			newmark = (*ctmark & ~markinfo->mask) | markinfo->mark;
+			if (newmark != *ctmark) {
+				*ctmark = newmark;
 #ifdef CONFIG_IP_NF_CONNTRACK_EVENTS
-		    ip_conntrack_event_cache(IPCT_MARK, *pskb);
+				ip_conntrack_event_cache(IPCT_MARK, *pskb);
 #else
-		    nf_conntrack_event_cache(IPCT_MARK, *pskb);
+				nf_conntrack_event_cache(IPCT_MARK, *pskb);
 #endif
 		}
-		break;
-	    case XT_CONNMARK_SAVE:
-		newmark = (*ctmark & ~markinfo->mask) | ((*pskb)->nfmark & markinfo->mask);
-		if (*ctmark != newmark) {
-		    *ctmark = newmark;
+			break;
+		case XT_CONNMARK_SAVE:
+			newmark = (*ctmark & ~markinfo->mask) |
+				  ((*pskb)->nfmark & markinfo->mask);
+			if (*ctmark != newmark) {
+				*ctmark = newmark;
 #ifdef CONFIG_IP_NF_CONNTRACK_EVENTS
-		    ip_conntrack_event_cache(IPCT_MARK, *pskb);
+				ip_conntrack_event_cache(IPCT_MARK, *pskb);
 #else
-		    nf_conntrack_event_cache(IPCT_MARK, *pskb);
+				nf_conntrack_event_cache(IPCT_MARK, *pskb);
 #endif
+			}
+			break;
+		case XT_CONNMARK_RESTORE:
+			nfmark = (*pskb)->nfmark;
+			diff = (*ctmark ^ nfmark) & markinfo->mask;
+			if (diff != 0)
+				(*pskb)->nfmark = nfmark ^ diff;
+			break;
 		}
-		break;
-	    case XT_CONNMARK_RESTORE:
-		nfmark = (*pskb)->nfmark;
-		diff = (*ctmark ^ nfmark) & markinfo->mask;
-		if (diff != 0)
-		    (*pskb)->nfmark = nfmark ^ diff;
-		break;
-	    }
 	}
 
 	return XT_CONTINUE;
@@ -95,17 +96,17 @@ checkentry(const char *tablename,
 	struct xt_connmark_target_info *matchinfo = targinfo;
 
 	if (matchinfo->mode == XT_CONNMARK_RESTORE) {
-	    if (strcmp(tablename, "mangle") != 0) {
-		    printk(KERN_WARNING "CONNMARK: restore can only be called from \"mangle\" table, not \"%s\"\n", tablename);
-		    return 0;
-	    }
+		if (strcmp(tablename, "mangle") != 0) {
+			printk(KERN_WARNING "CONNMARK: restore can only be "
+			       "called from \"mangle\" table, not \"%s\"\n",
+			       tablename);
+			return 0;
+		}
 	}
-
 	if (matchinfo->mark > 0xffffffff || matchinfo->mask > 0xffffffff) {
 		printk(KERN_WARNING "CONNMARK: Only supports 32bit mark\n");
 		return 0;
 	}
-
 	return 1;
 }
 
