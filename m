From: Thomas Jarosch <thomas.jarosch@intra2net.com>
Subject: [patch] libnetlink_conntrack compile fix
Date: Fri, 16 Mar 2007 14:55:51 +0100
Message-ID: <200703161455.52075.thomas.jarosch@intra2net.com>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_oHq+FdJ6LS95mry"
To: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
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

--Boundary-00=_oHq+FdJ6LS95mry
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hello,

attached patch fixes compilation of libnetlink_conntrack
for old glibc versions.

Cheers,
Thomas

PS: Patrick, when do you get up in the morning?!
I just noticed you first reply was around 5 o' clock...

--Boundary-00=_oHq+FdJ6LS95mry
Content-Type: text/x-diff; charset="us-ascii";
	name="libnetfilter_conntrack-compile-fix.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="libnetfilter_conntrack-compile-fix.patch"

diff -u -r -p libnetfilter_conntrack-20070315/include/internal.h libnetfilter_conntrack.fixed/include/internal.h
--- libnetfilter_conntrack-20070315/include/internal.h	Tue Dec 19 18:41:53 2006
+++ libnetfilter_conntrack.fixed/include/internal.h	Fri Mar 16 14:43:32 2007
@@ -22,6 +22,10 @@
 #include <libnfnetlink/libnfnetlink.h>
 #include <libnetfilter_conntrack/libnetfilter_conntrack.h>
 
+#ifndef IPPROTO_SCTP
+#define IPPROTO_SCTP 132
+#endif
+
 struct nfct_handle;
 
 typedef void (*set_attr)(struct nf_conntrack *ct, const void *value);

--Boundary-00=_oHq+FdJ6LS95mry--
