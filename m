From: Jan Engelhardt <jengelh@linux01.gwdg.de>
Subject: Re: xt_MARK useless line
Date: Wed, 10 Jan 2007 12:12:26 +0100 (MET)
Message-ID: <Pine.LNX.4.61.0701101205010.3029@yvahk01.tjqt.qr>
References: <Pine.LNX.4.61.0612291752440.9799@yvahk01.tjqt.qr>
	<20070107141557.GB13543@prithivi.gnumonks.org>
	<Pine.LNX.4.61.0701071613520.4365@yvahk01.tjqt.qr>
	<45A18EE8.5080909@snapgear.com> <45A47F66.2050603@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Harald Welte <laforge@netfilter.org>,
	Netfilter Developer Mailing List <netfilter-devel@lists.netfilter.org>,
	Philip Craig <philipc@snapgear.com>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <45A47F66.2050603@trash.net>
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


On Jan 10 2007 06:53, Patrick McHardy wrote:
>> 
>> Some of these may be leftover from when NFC_ALTERED existed?
>
>That sounds like the most likely explanation. Looking at 2.4:
>
>        if((*pskb)->nfmark != markinfo->mark) {
>                (*pskb)->nfmark = markinfo->mark;
>                (*pskb)->nfcache |= NFC_ALTERED;
>
>        }
>
>I vote for removing this (also in CONNMARK, CONNSECMARK, ...).
>

Not everywhere, xt_CONNMARK has a place where:

newmark = (*ctmark & ~markinfo->mask) | markinfo->mark;
if (newmark != *ctmark) {
    *ctmark = newmark;
#if defined(CONFIG_IP_NF_CONNTRACK) || defined(CONFIG_IP_NF_CONNTRACK_MODULE)
    ip_conntrack_event_cache(IPCT_MARK, *pskb);
#else
    nf_conntrack_event_cache(IPCT_MARK, *pskb);
#endif
}

Would it matter to call these cache functions it even if the mark did
not really change?

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Remove unnecessary if() constructs before assignment.
Plus one spelling fix, one brace indent fix.

Signed-off-by: Jan Engelhardt <jengelh@gmx.de>

Index: linux-2.6.20-rc4/net/ipv6/netfilter/ip6t_HL.c
===================================================================
--- linux-2.6.20-rc4.orig/net/ipv6/netfilter/ip6t_HL.c
+++ linux-2.6.20-rc4/net/ipv6/netfilter/ip6t_HL.c
@@ -52,8 +52,7 @@ static unsigned int ip6t_hl_target(struc
 			break;
 	}
 
-	if (new_hl != ip6h->hop_limit)
-		ip6h->hop_limit = new_hl;
+	ip6h->hop_limit = new_hl;
 
 	return IP6T_CONTINUE;
 }
Index: linux-2.6.20-rc4/net/netfilter/xt_CLASSIFY.c
===================================================================
--- linux-2.6.20-rc4.orig/net/netfilter/xt_CLASSIFY.c
+++ linux-2.6.20-rc4/net/netfilter/xt_CLASSIFY.c
@@ -32,10 +32,7 @@ target(struct sk_buff **pskb,
        const void *targinfo)
 {
 	const struct xt_classify_target_info *clinfo = targinfo;
-
-	if ((*pskb)->priority != clinfo->priority)
-		(*pskb)->priority = clinfo->priority;
-
+	(*pskb)->priority = clinfo->priority;
 	return XT_CONTINUE;
 }
 
Index: linux-2.6.20-rc4/net/netfilter/xt_CONNMARK.c
===================================================================
--- linux-2.6.20-rc4.orig/net/netfilter/xt_CONNMARK.c
+++ linux-2.6.20-rc4/net/netfilter/xt_CONNMARK.c
@@ -61,7 +61,7 @@ target(struct sk_buff **pskb,
 #else
 				nf_conntrack_event_cache(IPCT_MARK, *pskb);
 #endif
-		}
+			}
 			break;
 		case XT_CONNMARK_SAVE:
 			newmark = (*ctmark & ~markinfo->mask) |
@@ -78,8 +78,7 @@ target(struct sk_buff **pskb,
 		case XT_CONNMARK_RESTORE:
 			mark = (*pskb)->mark;
 			diff = (*ctmark ^ mark) & markinfo->mask;
-			if (diff != 0)
-				(*pskb)->mark = mark ^ diff;
+			(*pskb)->mark = mark ^ diff;
 			break;
 		}
 	}
Index: linux-2.6.20-rc4/net/netfilter/xt_CONNSECMARK.c
===================================================================
--- linux-2.6.20-rc4.orig/net/netfilter/xt_CONNSECMARK.c
+++ linux-2.6.20-rc4/net/netfilter/xt_CONNSECMARK.c
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
 
Index: linux-2.6.20-rc4/net/netfilter/xt_MARK.c
===================================================================
--- linux-2.6.20-rc4.orig/net/netfilter/xt_MARK.c
+++ linux-2.6.20-rc4/net/netfilter/xt_MARK.c
@@ -30,10 +30,7 @@ target_v0(struct sk_buff **pskb,
 	  const void *targinfo)
 {
 	const struct xt_mark_target_info *markinfo = targinfo;
-
-	if((*pskb)->mark != markinfo->mark)
-		(*pskb)->mark = markinfo->mark;
-
+	(*pskb)->mark = markinfo->mark;
 	return XT_CONTINUE;
 }
 
@@ -62,9 +59,7 @@ target_v1(struct sk_buff **pskb,
 		break;
 	}
 
-	if((*pskb)->mark != mark)
-		(*pskb)->mark = mark;
-
+	(*pskb)->mark = mark;
 	return XT_CONTINUE;
 }
 
Index: linux-2.6.20-rc4/net/netfilter/xt_NOTRACK.c
===================================================================
--- linux-2.6.20-rc4.orig/net/netfilter/xt_NOTRACK.c
+++ linux-2.6.20-rc4/net/netfilter/xt_NOTRACK.c
@@ -24,7 +24,7 @@ target(struct sk_buff **pskb,
 
 	/* Attach fake conntrack entry. 
 	   If there is a real ct entry correspondig to this packet, 
-	   it'll hang aroun till timing out. We don't deal with it
+	   it'll hang around till timing out. We don't deal with it
 	   for performance reasons. JK */
 	nf_ct_untrack(*pskb);
 	(*pskb)->nfctinfo = IP_CT_NEW;
Index: linux-2.6.20-rc4/net/netfilter/xt_SECMARK.c
===================================================================
--- linux-2.6.20-rc4.orig/net/netfilter/xt_SECMARK.c
+++ linux-2.6.20-rc4/net/netfilter/xt_SECMARK.c
@@ -47,9 +47,7 @@ static unsigned int target(struct sk_buf
 		BUG();
 	}
 
-	if ((*pskb)->secmark != secmark)
-		(*pskb)->secmark = secmark;
-
+	(*pskb)->secmark = secmark;
 	return XT_CONTINUE;
 }
 
