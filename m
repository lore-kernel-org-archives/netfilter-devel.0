From: Sander Eikelenboom <S.Eikelenboom@stud.tue.nl>
Subject: [PATCH] pptp_conntrack-nat: Fix compile errors DEBUGP() macro in
	ip_nat_proto_gre.c and ip_nat_pptp.c,
	fix typo in ip_conntrack_pptp.h
Date: Sat, 26 Feb 2005 00:23:05 +0100
Message-ID: <1268323301.20050226002305@stud.tue.nl>
Reply-To: Sander Eikelenboom <S.Eikelenboom@stud.tue.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
To: netfilter-devel@lists.netfilter.org
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

3 small fixes:
- Fixed compile errors in 2.6 DEBUGP() macro of  ip_nat_proto_gre.c and ip_nat_pptp.c
- Fixed typo in ip_conntrack_pptp.h



serveerstertje:/usr/src/netfilter-svn/patch-o-matic-ng# svn diff
Index: pptp-conntrack-nat/linux/include/linux/netfilter_ipv4/ip_conntrack_pptp.h
===================================================================
--- pptp-conntrack-nat/linux/include/linux/netfilter_ipv4/ip_conntrack_pptp.h   (revision 3742)
+++ pptp-conntrack-nat/linux/include/linux/netfilter_ipv4/ip_conntrack_pptp.h   (working copy)
@@ -54,7 +54,7 @@
                 void                           *rawreq;
                struct PptpStartSessionRequest  *sreq;
                struct PptpStartSessionReply    *srep;
-               struct PptpStopSessionReqest    *streq;
+               struct PptpStopSessionRequest   *streq;
                struct PptpStopSessionReply     *strep;
                 struct PptpOutCallRequest       *ocreq;
                 struct PptpOutCallReply         *ocack;
Index: pptp-conntrack-nat/linux-2.6/net/ipv4/netfilter/ip_nat_proto_gre.c
===================================================================
--- pptp-conntrack-nat/linux-2.6/net/ipv4/netfilter/ip_nat_proto_gre.c  (revision 3742)
+++ pptp-conntrack-nat/linux-2.6/net/ipv4/netfilter/ip_nat_proto_gre.c  (working copy)
@@ -36,8 +36,7 @@
 MODULE_DESCRIPTION("Netfilter NAT protocol helper module for GRE");

 #if 0
-#define DEBUGP(format, args...) printk(KERN_DEBUG __FILE__ ":" __FUNCTION__ \
-                                      ": " format, ## args)
+#define DEBUGP(format, args...) printk(KERN_DEBUG "%s:%s: " format, __FILE__, __FUNCTION__, ## args)
 #else
 #define DEBUGP(x, args...)
 #endif
Index: pptp-conntrack-nat/linux-2.6/net/ipv4/netfilter/ip_nat_pptp.c
===================================================================
--- pptp-conntrack-nat/linux-2.6/net/ipv4/netfilter/ip_nat_pptp.c       (revision 3742)
+++ pptp-conntrack-nat/linux-2.6/net/ipv4/netfilter/ip_nat_pptp.c       (working copy)
@@ -56,8 +56,7 @@

 #if 0
 #include "ip_conntrack_pptp_priv.h"
-#define DEBUGP(format, args...) printk(KERN_DEBUG __FILE__ ":" __FUNCTION__ \
-                                      ": " format, ## args)
+#define DEBUGP(format, args...) printk(KERN_DEBUG "%s:%s: " format, __FILE__, __FUNCTION__, ## args)
 #else
 #define DEBUGP(format, args...)
 #endif
