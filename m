From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 04/15]: Remove useless comparisons before assignments
Date: Wed,  7 Feb 2007 09:22:40 +0100 (MET)
Message-ID: <20070207082239.27478.9386.sendpatchset@localhost.localdomain>
References: <20070207082228.27478.19484.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
To: davem@davemloft.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <20070207082228.27478.19484.sendpatchset@localhost.localdomain>
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

[NETFILTER]: Remove useless comparisons before assignments

Remove unnecessary if() constructs before assignment.

Signed-off-by: Jan Engelhardt <jengelh@gmx.de>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 190276633aff2a1c54c2c5d12788f62c58067f2b
tree 9c8daa83b4803cdc04c6b10e75a25dea5d39bec6
parent 7d1ff8ef614415a0cad0eb9a357e614673ff5129
author Jan Engelhardt <jengelh@gmx.de> Tue, 06 Feb 2007 07:36:51 +0100
committer Patrick McHardy <kaber@trash.net> Tue, 06 Feb 2007 08:37:35 +0100

 net/ipv6/netfilter/ip6t_HL.c   |    3 +--
 net/netfilter/xt_CLASSIFY.c    |    4 +---
 net/netfilter/xt_CONNMARK.c    |    5 ++---
 net/netfilter/xt_CONNSECMARK.c |    6 ++----
 net/netfilter/xt_MARK.c        |    8 ++------
 net/netfilter/xt_SECMARK.c     |    4 +---
 6 files changed, 9 insertions(+), 21 deletions(-)

diff --git a/net/ipv6/netfilter/ip6t_HL.c b/net/ipv6/netfilter/ip6t_HL.c
index 435750f..7e5d513 100644
--- a/net/ipv6/netfilter/ip6t_HL.c
+++ b/net/ipv6/netfilter/ip6t_HL.c
@@ -52,8 +52,7 @@ static unsigned int ip6t_hl_target(struc
 			break;
 	}
 
-	if (new_hl != ip6h->hop_limit)
-		ip6h->hop_limit = new_hl;
+	ip6h->hop_limit = new_hl;
 
 	return IP6T_CONTINUE;
 }
diff --git a/net/netfilter/xt_CLASSIFY.c b/net/netfilter/xt_CLASSIFY.c
index 50de965..195e929 100644
--- a/net/netfilter/xt_CLASSIFY.c
+++ b/net/netfilter/xt_CLASSIFY.c
@@ -33,9 +33,7 @@ target(struct sk_buff **pskb,
 {
 	const struct xt_classify_target_info *clinfo = targinfo;
 
-	if ((*pskb)->priority != clinfo->priority)
-		(*pskb)->priority = clinfo->priority;
-
+	(*pskb)->priority = clinfo->priority;
 	return XT_CONTINUE;
 }
 
diff --git a/net/netfilter/xt_CONNMARK.c b/net/netfilter/xt_CONNMARK.c
index 0534bfa..795c058 100644
--- a/net/netfilter/xt_CONNMARK.c
+++ b/net/netfilter/xt_CONNMARK.c
@@ -61,7 +61,7 @@ #if defined(CONFIG_IP_NF_CONNTRACK) || d
 #else
 				nf_conntrack_event_cache(IPCT_MARK, *pskb);
 #endif
-		}
+			}
 			break;
 		case XT_CONNMARK_SAVE:
 			newmark = (*ctmark & ~markinfo->mask) |
@@ -78,8 +78,7 @@ #endif
 		case XT_CONNMARK_RESTORE:
 			mark = (*pskb)->mark;
 			diff = (*ctmark ^ mark) & markinfo->mask;
-			if (diff != 0)
-				(*pskb)->mark = mark ^ diff;
+			(*pskb)->mark = mark ^ diff;
 			break;
 		}
 	}
diff --git a/net/netfilter/xt_CONNSECMARK.c b/net/netfilter/xt_CONNSECMARK.c
index a3fe3c3..1ab0db6 100644
--- a/net/netfilter/xt_CONNSECMARK.c
+++ b/net/netfilter/xt_CONNSECMARK.c
@@ -41,8 +41,7 @@ static void secmark_save(struct sk_buff 
 
 		connsecmark = nf_ct_get_secmark(skb, &ctinfo);
 		if (connsecmark && !*connsecmark)
-			if (*connsecmark != skb->secmark)
-				*connsecmark = skb->secmark;
+			*connsecmark = skb->secmark;
 	}
 }
 
@@ -58,8 +57,7 @@ static void secmark_restore(struct sk_bu
 
 		connsecmark = nf_ct_get_secmark(skb, &ctinfo);
 		if (connsecmark && *connsecmark)
-			if (skb->secmark != *connsecmark)
-				skb->secmark = *connsecmark;
+			skb->secmark = *connsecmark;
 	}
 }
 
diff --git a/net/netfilter/xt_MARK.c b/net/netfilter/xt_MARK.c
index 0b48547..cfc45af 100644
--- a/net/netfilter/xt_MARK.c
+++ b/net/netfilter/xt_MARK.c
@@ -31,9 +31,7 @@ target_v0(struct sk_buff **pskb,
 {
 	const struct xt_mark_target_info *markinfo = targinfo;
 
-	if((*pskb)->mark != markinfo->mark)
-		(*pskb)->mark = markinfo->mark;
-
+	(*pskb)->mark = markinfo->mark;
 	return XT_CONTINUE;
 }
 
@@ -62,9 +60,7 @@ target_v1(struct sk_buff **pskb,
 		break;
 	}
 
-	if((*pskb)->mark != mark)
-		(*pskb)->mark = mark;
-
+	(*pskb)->mark = mark;
 	return XT_CONTINUE;
 }
 
diff --git a/net/netfilter/xt_SECMARK.c b/net/netfilter/xt_SECMARK.c
index add7521..f1131c3 100644
--- a/net/netfilter/xt_SECMARK.c
+++ b/net/netfilter/xt_SECMARK.c
@@ -47,9 +47,7 @@ static unsigned int target(struct sk_buf
 		BUG();
 	}
 
-	if ((*pskb)->secmark != secmark)
-		(*pskb)->secmark = secmark;
-
+	(*pskb)->secmark = secmark;
 	return XT_CONTINUE;
 }
 
