From: Thomas Jarosch <thomas.jarosch@intra2net.com>
Subject: [patch] libnfnetlink compile fix
Date: Fri, 16 Mar 2007 14:20:36 +0100
Message-ID: <200703161420.36846.thomas.jarosch@intra2net.com>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_kmp+FOHJFbTr8kR"
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

--Boundary-00=_kmp+FOHJFbTr8kR
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hello,

attached patch fixes compilation of libnfnetlink for old glibc versions. 
Otherwise "struct iovec" is undefined.

Cheers,
Thomas

--Boundary-00=_kmp+FOHJFbTr8kR
Content-Type: text/x-diff; charset="us-ascii"; name="libnfnetlink-iovec.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="libnfnetlink-iovec.patch"

diff -u -r -p libnfnetlink-20070315/src/libnfnetlink.c libnfnetlink.iovec/src/libnfnetlink.c
--- libnfnetlink-20070315/src/libnfnetlink.c	Tue Feb 27 02:44:02 2007
+++ libnfnetlink.iovec/src/libnfnetlink.c	Fri Mar 16 14:15:10 2007
@@ -45,6 +45,7 @@
 #include <assert.h>
 #include <linux/types.h>
 #include <sys/socket.h>
+#include <sys/uio.h>
 
 #include <linux/netlink.h>
 
diff -u -r -p libnfnetlink-20070315/src/rtnl.c libnfnetlink.iovec/src/rtnl.c
--- libnfnetlink-20070315/src/rtnl.c	Mon Feb 12 02:43:31 2007
+++ libnfnetlink.iovec/src/rtnl.c	Fri Mar 16 14:15:03 2007
@@ -16,6 +16,7 @@
 #include <errno.h>
 #include <time.h>
 #include <sys/types.h>
+#include <sys/uio.h>
 
 #include <netinet/in.h>
 

--Boundary-00=_kmp+FOHJFbTr8kR--
