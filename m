From: Rusty Russell <rusty@rustcorp.com.au>
Subject: [PATCH 16/18] Netfilter:  Fix for NAT core on nonlinear skbs
Date: Wed, 05 Jan 2005 14:37:08 +1100
Message-ID: <1104896228.20582.84.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@netfilter.org>,
	Netfilter development mailing list <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Linus Torvalds <torvalds@osdl.org>
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

Name: Fix for NAT core on nonlinear skbs
Status: Tested under nfsim
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

The nat core calls skb_ip_make_writable() with a length too short.
Found by nfsim.

Index: linux-2.6.10-bk1-Netfilter/net/ipv4/netfilter/ip_nat_core.c
===================================================================
--- linux-2.6.10-bk1-Netfilter.orig/net/ipv4/netfilter/ip_nat_core.c	2005-01-04 18:15:04.000000000 +1100
+++ linux-2.6.10-bk1-Netfilter/net/ipv4/netfilter/ip_nat_core.c	2005-01-04 19:08:50.880576984 +1100
@@ -466,7 +466,7 @@
 	struct iphdr *iph;
 
 	(*pskb)->nfcache |= NFC_ALTERED;
-	if (!skb_ip_make_writable(pskb, iphdroff+sizeof(iph)))
+	if (!skb_ip_make_writable(pskb, iphdroff+sizeof(*iph)))
 		return 0;
 
 	iph = (void *)(*pskb)->data + iphdroff;
