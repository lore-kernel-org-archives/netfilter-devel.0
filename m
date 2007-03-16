From: Thomas Jarosch <thomas.jarosch@intra2net.com>
Subject: [patch] conntrack compile fix
Date: Fri, 16 Mar 2007 15:07:05 +0100
Message-ID: <200703161507.05220.thomas.jarosch@intra2net.com>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_JSq+FItB+ue00oz"
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

--Boundary-00=_JSq+FItB+ue00oz
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hello,

attached is a compile fix for conntrack.

Cheers,
Thomas

--Boundary-00=_JSq+FItB+ue00oz
Content-Type: text/x-diff; charset="us-ascii";
	name="conntrack-compile-fix.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="conntrack-compile-fix.patch"

diff -u -r conntrack-20070315/src/conntrack.c conntrack.fixed/src/conntrack.c
--- conntrack-20070315/src/conntrack.c	Mon Jul  3 20:34:50 2006
+++ conntrack.fixed/src/conntrack.c	Fri Mar 16 15:03:44 2007
@@ -48,6 +48,7 @@
 #endif
 #include <fcntl.h>
 #include <dlfcn.h>
+#include <signal.h>
 #include <string.h>
 #include "linux_list.h"
 #include "conntrack.h"

--Boundary-00=_JSq+FItB+ue00oz--
