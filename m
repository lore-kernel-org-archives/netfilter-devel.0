From: James Morris <jmorris@redhat.com>
Subject: [PATCH] make skb writeable for snmp helper
Date: Thu, 27 May 2004 23:48:29 -0400 (EDT)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Xine.LNX.4.44.0405272345200.22684-100000@thoron.boston.redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

The snmp helper needs an explicit call to skb_ip_make_writable.
Please apply.


diff -urN -X dontdiff linux-2.6.7-rc1.o/net/ipv4/netfilter/ip_nat_snmp_basic.c linux-2.6.7-rc1.w/net/ipv4/netfilter/ip_nat_snmp_basic.c
--- linux-2.6.7-rc1.o/net/ipv4/netfilter/ip_nat_snmp_basic.c	2004-05-09 22:33:13.000000000 -0400
+++ linux-2.6.7-rc1.w/net/ipv4/netfilter/ip_nat_snmp_basic.c	2004-05-27 22:00:23.000000000 -0400
@@ -1252,6 +1252,9 @@
 	int dir = CTINFO2DIR(ctinfo);
 	struct iphdr *iph = (*pskb)->nh.iph;
 	struct udphdr *udph = (struct udphdr *)((u_int32_t *)iph + iph->ihl);
+	
+	if (!skb_ip_make_writable(pskb, (*pskb)->len))
+		return NF_DROP;
 
 	spin_lock_bh(&snmp_lock);
 	
