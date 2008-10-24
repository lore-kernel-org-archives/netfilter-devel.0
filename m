From: Sven Wegener <sven.wegener@stealer.net>
Subject: [PATCH] ipset: limits.h strikes again
Date: Sat, 25 Oct 2008 00:27:47 +0200 (CEST)
Message-ID: <alpine.LNX.2.00.0810250020540.24348@titan.stealer.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp1.stealer.net ([88.198.224.204]:53569 "EHLO
	smtp1.stealer.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754803AbYJXW16 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 24 Oct 2008 18:27:58 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Jozsef,

looks like the include got lost, please apply.

Sven

Index: ipset/ipset_nethash.c
===================================================================
--- ipset/ipset_nethash.c	(revision 7571)
+++ ipset/ipset_nethash.c	(working copy)
@@ -15,6 +15,7 @@
  * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
  */
 
+#include <limits.h>
 #include <stdio.h>
 #include <stdlib.h>
 #include <string.h>
Index: ipset/ipset_ipportiphash.c
===================================================================
--- ipset/ipset_ipportiphash.c	(revision 7571)
+++ ipset/ipset_ipportiphash.c	(working copy)
@@ -15,6 +15,7 @@
  * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
  */
 
+#include <limits.h>
 #include <stdio.h>
 #include <stdlib.h>
 #include <string.h>
Index: ipset/ipset_iphash.c
===================================================================
--- ipset/ipset_iphash.c	(revision 7571)
+++ ipset/ipset_iphash.c	(working copy)
@@ -15,6 +15,7 @@
  * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
  */
 
+#include <limits.h>
 #include <stdio.h>
 #include <stdlib.h>
 #include <string.h>
Index: ipset/ipset_ipporthash.c
===================================================================
--- ipset/ipset_ipporthash.c	(revision 7571)
+++ ipset/ipset_ipporthash.c	(working copy)
@@ -15,6 +15,7 @@
  * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
  */
 
+#include <limits.h>
 #include <stdio.h>
 #include <stdlib.h>
 #include <string.h>
Index: ipset/ipset_iptreemap.c
===================================================================
--- ipset/ipset_iptreemap.c	(revision 7571)
+++ ipset/ipset_iptreemap.c	(working copy)
@@ -15,6 +15,7 @@
  * Place, Suite 330, Boston, MA 02111-1307 USA
  */
 
+#include <limits.h>
 #include <stdio.h>
 #include <stdlib.h>
 #include <string.h>
Index: ipset/ipset_iptree.c
===================================================================
--- ipset/ipset_iptree.c	(revision 7571)
+++ ipset/ipset_iptree.c	(working copy)
@@ -15,6 +15,7 @@
  * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
  */
 
+#include <limits.h>
 #include <stdio.h>
 #include <stdlib.h>
 #include <string.h>
Index: ipset/ipset_ipportnethash.c
===================================================================
--- ipset/ipset_ipportnethash.c	(revision 7571)
+++ ipset/ipset_ipportnethash.c	(working copy)
@@ -15,6 +15,7 @@
  * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
  */
 
+#include <limits.h>
 #include <stdio.h>
 #include <stdlib.h>
 #include <string.h>
