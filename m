From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 09/11] netfilter: xtables: remove another level of indent
Date: Fri,  8 May 2009 11:26:39 +0200
Message-ID: <1241774801-2315-10-git-send-email-jengelh@medozas.de>
References: <1241774801-2315-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:53364 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755985AbZEHJ0p (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 8 May 2009 05:26:45 -0400
In-Reply-To: <1241774801-2315-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 net/ipv4/netfilter/arp_tables.c |   33 ++++++++++++------------
 net/ipv4/netfilter/ip_tables.c  |   52 ++++++++++++++++++--------------------
 net/ipv6/netfilter/ip6_tables.c |   44 +++++++++++++++-----------------
 3 files changed, 63 insertions(+), 66 deletions(-)

diff --git a/net/ipv4/netfilter/arp_tables.c b/net/ipv4/netfilter/arp_tables.c
index ecba246..7505dff 100644
--- a/net/ipv4/netfilter/arp_tables.c
+++ b/net/ipv4/netfilter/arp_tables.c
@@ -313,23 +313,24 @@ unsigned int arpt_do_table(struct sk_buff *skb,
 			}
 
 			e = get_entry(table_base, v);
-		} else {
-			/* Targets which reenter must return
-			 * abs. verdicts
-			 */
-			tgpar.target   = t->u.kernel.target;
-			tgpar.targinfo = t->data;
-			verdict = t->u.kernel.target->target(skb, &tgpar);
-
-			/* Target might have changed stuff. */
-			arp = arp_hdr(skb);
-
-			if (verdict == ARPT_CONTINUE)
-				e = arpt_next_entry(e);
-			else
-				/* Verdict */
-				break;
+			continue;
 		}
+
+		/* Targets which reenter must return
+		 * abs. verdicts
+		 */
+		tgpar.target   = t->u.kernel.target;
+		tgpar.targinfo = t->data;
+		verdict = t->u.kernel.target->target(skb, &tgpar);
+
+		/* Target might have changed stuff. */
+		arp = arp_hdr(skb);
+
+		if (verdict == ARPT_CONTINUE)
+			e = arpt_next_entry(e);
+		else
+			/* Verdict */
+			break;
 	} while (!hotdrop);
 	xt_info_rdunlock_bh();
 
diff --git a/net/ipv4/netfilter/ip_tables.c b/net/ipv4/netfilter/ip_tables.c
index cfcb7af..d91ecd4 100644
--- a/net/ipv4/netfilter/ip_tables.c
+++ b/net/ipv4/netfilter/ip_tables.c
@@ -402,37 +402,35 @@ ipt_do_table(struct sk_buff *skb,
 			}
 
 			e = get_entry(table_base, v);
-		} else {
-			/* Targets which reenter must return
-			   abs. verdicts */
-			tgpar.target   = t->u.kernel.target;
-			tgpar.targinfo = t->data;
+			continue;
+		}
+
+		/* Targets which reenter must return
+		   abs. verdicts */
+		tgpar.target   = t->u.kernel.target;
+		tgpar.targinfo = t->data;
 #ifdef CONFIG_NETFILTER_DEBUG
-			((struct ipt_entry *)table_base)->comefrom
-				= 0xeeeeeeec;
+		((struct ipt_entry *)table_base)->comefrom = 0xeeeeeeec;
 #endif
-			verdict = t->u.kernel.target->target(skb, &tgpar);
+		verdict = t->u.kernel.target->target(skb, &tgpar);
 #ifdef CONFIG_NETFILTER_DEBUG
-			if (((struct ipt_entry *)table_base)->comefrom
-			    != 0xeeeeeeec
-			    && verdict == IPT_CONTINUE) {
-				printk("Target %s reentered!\n",
-				       t->u.kernel.target->name);
-				verdict = NF_DROP;
-			}
-			((struct ipt_entry *)table_base)->comefrom
-				= 0x57acc001;
-#endif
-			/* Target might have changed stuff. */
-			ip = ip_hdr(skb);
-			datalen = skb->len - ip->ihl * 4;
-
-			if (verdict == IPT_CONTINUE)
-				e = ipt_next_entry(e);
-			else
-				/* Verdict */
-				break;
+		if (((struct ipt_entry *)table_base)->comefrom != 0xeeeeeeec &&
+		    verdict == IPT_CONTINUE) {
+			printk("Target %s reentered!\n",
+			       t->u.kernel.target->name);
+			verdict = NF_DROP;
 		}
+		((struct ipt_entry *)table_base)->comefrom = 0x57acc001;
+#endif
+		/* Target might have changed stuff. */
+		ip = ip_hdr(skb);
+		datalen = skb->len - ip->ihl * 4;
+
+		if (verdict == IPT_CONTINUE)
+			e = ipt_next_entry(e);
+		else
+			/* Verdict */
+			break;
 	} while (!hotdrop);
 	xt_info_rdunlock_bh();
 
diff --git a/net/ipv6/netfilter/ip6_tables.c b/net/ipv6/netfilter/ip6_tables.c
index d01b8a3..5a178be 100644
--- a/net/ipv6/netfilter/ip6_tables.c
+++ b/net/ipv6/netfilter/ip6_tables.c
@@ -431,35 +431,33 @@ ip6t_do_table(struct sk_buff *skb,
 			}
 
 			e = get_entry(table_base, v);
-		} else {
-			/* Targets which reenter must return
-			   abs. verdicts */
-			tgpar.target   = t->u.kernel.target;
-			tgpar.targinfo = t->data;
+			continue;
+		}
+
+		/* Targets which reenter must return
+		   abs. verdicts */
+		tgpar.target   = t->u.kernel.target;
+		tgpar.targinfo = t->data;
 
 #ifdef CONFIG_NETFILTER_DEBUG
-			((struct ip6t_entry *)table_base)->comefrom
-				= 0xeeeeeeec;
+		((struct ip6t_entry *)table_base)->comefrom = 0xeeeeeeec;
 #endif
-			verdict = t->u.kernel.target->target(skb, &tgpar);
+		verdict = t->u.kernel.target->target(skb, &tgpar);
 
 #ifdef CONFIG_NETFILTER_DEBUG
-			if (((struct ip6t_entry *)table_base)->comefrom
-			    != 0xeeeeeeec
-			    && verdict == IP6T_CONTINUE) {
-				printk("Target %s reentered!\n",
-				       t->u.kernel.target->name);
-				verdict = NF_DROP;
-			}
-			((struct ip6t_entry *)table_base)->comefrom
-				= 0x57acc001;
-#endif
-			if (verdict == IP6T_CONTINUE)
-				e = ip6t_next_entry(e);
-			else
-				/* Verdict */
-				break;
+		if (((struct ip6t_entry *)table_base)->comefrom != 0xeeeeeeec &&
+		    verdict == IP6T_CONTINUE) {
+			printk("Target %s reentered!\n",
+			       t->u.kernel.target->name);
+			verdict = NF_DROP;
 		}
+		((struct ip6t_entry *)table_base)->comefrom = 0x57acc001;
+#endif
+		if (verdict == IP6T_CONTINUE)
+			e = ip6t_next_entry(e);
+		else
+			/* Verdict */
+			break;
 	} while (!hotdrop);
 
 #ifdef CONFIG_NETFILTER_DEBUG
-- 
1.6.2.2

