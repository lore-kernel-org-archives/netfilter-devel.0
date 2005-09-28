From: Christian Hentschel <chentschel@iplan.com.ar>
Subject: [PATCH] conntrack tool.
Date: Wed, 28 Sep 2005 09:49:17 -0300
Message-ID: <1127911757.4947.12.camel@linbox>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-mfcmPbqb4RDe4//lK8rW"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: pablo@netfilter.org
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


--=-mfcmPbqb4RDe4//lK8rW
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Hi pablo, 
	This patch adds small fixes to the conntrack tool.

Changes:
	libct_proto_icmp.c args parsing. 
	added autogen.sh file (stolen from libnfnetlink_conntrack) :)


Regards, 
-- 
Christian Hentschel <chentschel@arnet.com.ar>

--=-mfcmPbqb4RDe4//lK8rW
Content-Disposition: attachment; filename=conntrack.patch
Content-Type: text/x-patch; name=conntrack.patch; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 7bit

Index: extensions/libct_proto_icmp.c
===================================================================
--- extensions/libct_proto_icmp.c	(revision 4307)
+++ extensions/libct_proto_icmp.c	(working copy)
@@ -15,9 +15,9 @@
 #include "libct_proto.h"
 
 static struct option opts[] = {
-	{"--icmp-type", 1, 0, '1'},
-	{"--icmp-code", 1, 0, '2'},
-	{"--icmp-id", 1, 0, '3'},
+	{"icmp-type", 1, 0, '1'},
+	{"icmp-code", 1, 0, '2'},
+	{"icmp-id", 1, 0, '3'},
 	{0, 0, 0, 0}
 };
 
Index: autogen.sh
===================================================================
--- autogen.sh	(revision 0)
+++ autogen.sh	(revision 0)
@@ -0,0 +1,17 @@
+#!/bin/sh
+
+run ()
+{
+    echo "running: $*"
+    eval $*
+
+    if test $? != 0 ; then
+	echo "error: while running '$*'"
+	exit 1
+    fi
+}
+
+run aclocal-1.6
+#run autoheader
+run automake-1.6 -a
+run autoconf

Property changes on: autogen.sh
___________________________________________________________________
Name: svn:executable
   + *


--=-mfcmPbqb4RDe4//lK8rW--
