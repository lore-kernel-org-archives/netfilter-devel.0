From: philipc@snapgear.com
Subject: [PATCH 3/4] log dropped ICMP redirects
Date: Wed, 24 May 2006 14:04:44 +1000
Message-ID: <20060524040951.092582000@snapgear.com>
References: <20060524040441.111049000@snapgear.com>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline; filename=invalidicmpredirect.patch
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

Log dropped ICMP redirects for untracked connections.

This was required to meet a certification test.  But there are
many more locations that can drop packets without logging them,
which weren't tested for certification.  Should all instances of
NF_DROP in netfilter/iptables have a call to nf_log_packet?

Signed-off-by: Philip Craig <philipc@snapgear.com>

Index: linux-2.6.17-rc4.orig/net/ipv4/netfilter/ip_nat_standalone.c
===================================================================
--- linux-2.6.17-rc4.orig.orig/net/ipv4/netfilter/ip_nat_standalone.c	2006-05-24 11:57:28.000000000 +1000
+++ linux-2.6.17-rc4.orig/net/ipv4/netfilter/ip_nat_standalone.c	2006-05-24 13:22:38.000000000 +1000
@@ -41,6 +41,7 @@
 #include <linux/netfilter_ipv4/ip_nat_helper.h>
 #include <linux/netfilter_ipv4/ip_tables.h>
 #include <linux/netfilter_ipv4/ip_conntrack_core.h>
+#include <linux/netfilter_ipv4/ip_conntrack_protocol.h>
 #include <linux/netfilter_ipv4/listhelp.h>
 
 #if 0
@@ -132,8 +133,13 @@ ip_nat_fn(unsigned int hooknum,
 						(*pskb)->nh.iph->ihl*4,
 						sizeof(_hdr), &_hdr);
 			if (hp != NULL &&
-			    hp->type == ICMP_REDIRECT)
+			    hp->type == ICMP_REDIRECT) {
+				if (LOG_INVALID(IPPROTO_ICMP))
+					nf_log_packet(PF_INET, 0, *pskb,
+						NULL, NULL, NULL, "ip_nat: "
+						"untracked ICMP redirect ");
 				return NF_DROP;
+			}
 		}
 		return NF_ACCEPT;
 	}

--
