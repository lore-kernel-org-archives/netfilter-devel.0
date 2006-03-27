From: Ralf Schlatterbeck <rsc@runtux.com>
Subject: [PATCH] compilation error + kernel panic sip-conntrack-nat
Date: Mon, 27 Mar 2006 15:56:37 +0200
Message-ID: <20060327135637.GA19422@runtux.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
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

The following patch fixes a compilation problem for 2.6.16 (two missing
includes) and a kernel panic on the first sip packets (reproduced with
2.6.15.4 and 2.6.16, tested only with 2.6.16). The kernel-panic fix is
from the mailinglist-archive but obviously didn't yet make it into
the official tree yet.

Note: The FAQ-Entry about SIP 
http://www.netfilter.org/documentation/FAQ/netfilter-faq-1.html#ss1.8
should be updated to point to sip-conntrack-nat, see
http://www.iptel.org/sipalg/
The conntrack module would surely get more testing if it is mentioned in
the FAQ :-)


--- linux/net/ipv4/netfilter/ip_conntrack_sip.c.before-rsc	2006-03-27 08:41:10.000000000 +0200
+++ linux/net/ipv4/netfilter/ip_conntrack_sip.c	2006-03-27 10:18:57.101716429 +0200
@@ -13,6 +13,8 @@
 #include <linux/netfilter.h>
 #include <linux/ip.h>
 #include <linux/ctype.h>
+#include <linux/in.h>
+#include <linux/udp.h>
 #include <net/checksum.h>
 #include <net/udp.h>
 
@@ -296,7 +298,7 @@
 		return NF_ACCEPT;
         }
         
-	ip_ct_refresh_acct(ct, ctinfo, NULL, sip_timeout * HZ);
+	ip_ct_refresh(ct, *pskb, sip_timeout * HZ);
 		
 	spin_lock_bh(&sipbf_lock);
 	


Ralf
-- 
Ralf Schlatterbeck
