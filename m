From: Rickard Molin <rickard.molin@businessecurity.com>
Subject: IP csum bug in ROUTE module
Date: Mon, 19 Apr 2004 14:42:48 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <5340B444BE2BD411A89C009027F6917B4FDDE6@BSSERVER>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Cc: "'delanois@info.ucl.ac.be'" <delanois@info.ucl.ac.be>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: "Netfilter-Devel (E-mail)" <netfilter-devel@lists.netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi.

I reported this bug to Cedric de Lanois (Author) a few months ago but he
seems to have to much work to include the fix.

If ROUTE is used on the INPUT chain with the --oif option the ttl needs to
be decreased and the checksum recalculated. This is currently done with
ip_decrease_ttl which also fixes the checksum assuming that nothing else has
changed in the IP header. If the packet was defragmented before the
netfilter hook the length has changed and ip_decrease_ttl produces an
incorrect checksum.

Therefore i propose that ip_fast_csum should be used when on INPUT chain
instead.
I have done limited testing and cannot guarantee that this is correct but
here is a patch

/Rickard Molin




--- linux-2.4.20/net/ipv4/netfilter/ipt_ROUTE.c	2004-04-19
11:18:17.000000000 +0200
+++ linux-2.4.20-patched/net/ipv4/netfilter/ipt_ROUTE.c	2004-04-19
14:35:55.000000000 +0200
@@ -19,6 +19,7 @@
 #include <net/ip.h>
 #include <net/route.h>
 #include <net/icmp.h>
+#include <net/checksum.h>
 
 #if 0
 #define DEBUGP printk
@@ -281,8 +282,19 @@
 			return NF_DROP;
 		}
 
-		ip_decrease_ttl(iph);
-	}
+
+    /*
+     * If we are at INPUT the checksum must be recalculated since
+     * the length could change as the result of a defragmentation.
+     */
+    if(hooknum == NF_IP_LOCAL_IN) {
+      iph->ttl = iph->ttl - 1;
+      iph->check = 0;
+      iph->check = ip_fast_csum((unsigned char *)iph, iph->ihl);
+    } else {
+      ip_decrease_ttl(iph);
+    }
+  }
 
 	/* Tell conntrack to forget this packet since it may get confused 
 	 * when a packet is leaving with dst address == our address.
