From: Stelian Pop <stelian.pop@fr.alcove.com>
Subject: [PATCH 2.5.bk] make netfilter's ipt_TCPMSS compile again
Date: Wed, 30 Oct 2002 15:15:16 +0100
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <20021030141516.GG17103@tahoe.alcove-fr>
Reply-To: Stelian Pop <stelian.pop@fr.alcove.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.netfilter.org
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Disposition: inline
List-Id: netfilter-devel.vger.kernel.org

Hi,

The attached patch is required to make ipt_TCPMSS.c compile again,
due to the pmtu changes.

Stelian.

===== net/ipv4/netfilter/ipt_TCPMSS.c 1.5 vs edited =====
--- 1.5/net/ipv4/netfilter/ipt_TCPMSS.c	Tue Feb  5 16:23:43 2002
+++ edited/net/ipv4/netfilter/ipt_TCPMSS.c	Wed Oct 30 13:01:44 2002
@@ -85,14 +85,14 @@
 			return NF_DROP; /* or IPT_CONTINUE ?? */
 		}
 
-		if((*pskb)->dst->pmtu <= (sizeof(struct iphdr) + sizeof(struct tcphdr))) {
+		if(dst_pmtu((*pskb)->dst) <= (sizeof(struct iphdr) + sizeof(struct tcphdr))) {
 			if (net_ratelimit())
 				printk(KERN_ERR
-		       			"ipt_tcpmss_target: unknown or invalid path-MTU (%d)\n", (*pskb)->dst->pmtu);
+		       			"ipt_tcpmss_target: unknown or invalid path-MTU (%d)\n", dst_pmtu((*pskb)->dst));
 			return NF_DROP; /* or IPT_CONTINUE ?? */
 		}
 
-		newmss = (*pskb)->dst->pmtu - sizeof(struct iphdr) - sizeof(struct tcphdr);
+		newmss = dst_pmtu((*pskb)->dst) - sizeof(struct iphdr) - sizeof(struct tcphdr);
 	} else
 		newmss = tcpmssinfo->mss;
 
-- 
Stelian Pop <stelian.pop@fr.alcove.com>
Alcove - http://www.alcove.com
