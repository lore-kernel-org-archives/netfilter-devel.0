From: Marcus Sundberg <marcus@ingate.com>
Subject: [PATCH] Compile fixes
Date: 02 Jun 2002 16:01:04 +0200
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <veg005rd9b.fsf@inigo.ingate.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netfilter-devel-admin@lists.samba.org>
To: netfilter-devel@lists.samba.org
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi,

some fixes to make current CVS compile properly.

Changes
* Fix typo in ipt_ecn.h
* Make connmark match and target compile with NO_SHARED_LIBS=1
* Make POOL target compile with NO_SHARED_LIBS=1


Index: userspace/include/linux/netfilter_ipv4/ipt_ecn.h
===================================================================
RCS file: /cvsroot/netfilter/userspace/include/linux/netfilter_ipv4/ipt_ecn.h,v
retrieving revision 1.1
diff -u -u -r1.1 ipt_ecn.h
--- userspace/include/linux/netfilter_ipv4/ipt_ecn.h	29 May 2002 15:12:30 -0000	1.1
+++ userspace/include/linux/netfilter_ipv4/ipt_ecn.h	2 Jun 2002 13:46:07 -0000
@@ -9,7 +9,7 @@
 */
 #ifndef _IPT_ECN_H
 #define _IPT_ECN_H
-#include <linux/netfilter_ipv4/ipt_dcsp.h>
+#include <linux/netfilter_ipv4/ipt_dscp.h>
 
 #define IPT_ECN_IP_MASK	(~IPT_DSCP_MASK)
 
Index: userspace/patch-o-matic/base/ecn.patch
===================================================================
RCS file: /cvsroot/netfilter/userspace/patch-o-matic/base/ecn.patch,v
retrieving revision 1.1
diff -u -u -r1.1 ecn.patch
--- userspace/patch-o-matic/base/ecn.patch	29 May 2002 15:10:11 -0000	1.1
+++ userspace/patch-o-matic/base/ecn.patch	2 Jun 2002 13:46:07 -0000
@@ -13,7 +13,7 @@
 +*/
 +#ifndef _IPT_ECN_H
 +#define _IPT_ECN_H
-+#include <linux/netfilter_ipv4/ipt_dcsp.h>
++#include <linux/netfilter_ipv4/ipt_dscp.h>
 +
 +#define IPT_ECN_IP_MASK	(~IPT_DSCP_MASK)
 +
Index: userspace/extensions/libipt_CONNMARK.c
===================================================================
RCS file: /cvsroot/netfilter/userspace/extensions/libipt_CONNMARK.c,v
retrieving revision 1.2
diff -u -r1.2 libipt_CONNMARK.c
--- userspace/extensions/libipt_CONNMARK.c	29 May 2002 13:08:16 -0000	1.2
+++ userspace/extensions/libipt_CONNMARK.c	2 Jun 2002 13:47:09 -0000
@@ -146,6 +146,7 @@
 	}
 }
 
+static
 struct iptables_target mark
 = { NULL,
     "CONNMARK",
Index: userspace/extensions/libipt_connmark.c
===================================================================
RCS file: /cvsroot/netfilter/userspace/extensions/libipt_connmark.c,v
retrieving revision 1.3
diff -u -r1.3 libipt_connmark.c
--- userspace/extensions/libipt_connmark.c	29 May 2002 13:08:16 -0000	1.3
+++ userspace/extensions/libipt_connmark.c	2 Jun 2002 13:47:09 -0000
@@ -107,6 +107,7 @@
 		  ((struct ipt_connmark_info *)match->data)->invert, 0);
 }
 
+static
 struct iptables_match mark
 = { NULL,
     "connmark",

*

//Marcus
-- 
---------------------------------------+--------------------------
  Marcus Sundberg <marcus@ingate.com>  | Firewalls with SIP & NAT
 Firewall Developer, Ingate Systems AB |  http://www.ingate.com/
