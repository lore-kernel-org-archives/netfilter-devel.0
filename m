From: Pablo Neira <pablo@netfilter.org>
Subject: [PATCH 2/2] update in-tree headers automatically
Date: Sun, 13 Nov 2005 18:34:39 +0100
Message-ID: <4377792F.1030804@netfilter.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------010809060205030400010004"
Cc: Harald Welte <laforge@netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
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

This is a multi-part message in MIME format.
--------------010809060205030400010004
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit

This patch add the ability to copy and mangle the kernel headers
required by libnfnetlink and libnetfilter_[queue|log|conntrack] at
autogen.sh stage.

-- 
The dawn of the fourth age of Linux firewalling is coming; a time of
great struggle and heroic deeds -- J.Kadlecsik got inspired by J.Morris

--------------010809060205030400010004
Content-Type: text/plain;
 name="autogen.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="autogen.patch"

Index: libnfnetlink/autogen.sh
===================================================================
--- libnfnetlink/autogen.sh	(revision 4511)
+++ libnfnetlink/autogen.sh	(working copy)
@@ -1,5 +1,24 @@
 #!/bin/sh
 
+include ()
+{
+    # If we keep a copy of the kernel header in the SVN tree, we'll have
+    # to worry about synchronization issues forever. Instead, we just copy 
+    # the headers that we need from the lastest kernel version at autogen
+    # stage.
+
+    INCLUDEDIR=/lib/modules/`uname -r`/build/include/linux
+    if [ -f $INCLUDEDIR/netfilter/nfnetlink.h ]
+    then
+    	TARGET=include/libnfnetlink/linux_nfnetlink.h
+    	echo "Copying nfnetlink.h to linux_nfnetlink.h"
+    	cp $INCLUDEDIR/netfilter/nfnetlink.h $TARGET
+    else
+    	echo "can't find nfnetlink.h kernel file"
+    	exit 1
+    fi
+}
+
 run ()
 {
     echo "running: $*"
@@ -11,6 +30,7 @@
     fi
 }
 
+include
 run aclocal
 #run autoheader
 run libtoolize -f
Index: libnetfilter_conntrack/autogen.sh
===================================================================
--- libnetfilter_conntrack/autogen.sh	(revision 4511)
+++ libnetfilter_conntrack/autogen.sh	(working copy)
@@ -1,5 +1,27 @@
 #!/bin/sh
 
+include ()
+{
+    # If we keep a copy of the kernel header in the SVN tree, we'll have
+    # to worry about synchronization issues forever. Instead, we just copy 
+    # the headers that we need from the lastest kernel version at autogen
+    # stage.
+
+    INCLUDEDIR=/lib/modules/`uname -r`/build/include/linux
+    if [ -f $INCLUDEDIR/netfilter/nfnetlink_conntrack.h ]
+    then
+    	TARGET=include/libnetfilter_conntrack/linux_nfnetlink_conntrack.h
+    	echo "Copying nfnetlink_conntrack.h to linux_nfnetlink_conntrack.h"
+    	cp $INCLUDEDIR/netfilter/nfnetlink_conntrack.h $TARGET
+	TEMP=`tempfile`
+	sed 's/linux\/netfilter\/nfnetlink.h/libnfnetlink\/linux_nfnetlink.h/g' $TARGET > $TEMP
+	mv $TEMP $TARGET
+    else
+    	echo "can't find nfnetlink_conntrack.h kernel file"
+    	exit 1
+    fi
+}
+
 run ()
 {
     echo "running: $*"
@@ -11,6 +33,7 @@
     fi
 }
 
+include
 run aclocal
 run libtoolize -f
 #run autoheader
Index: libnetfilter_queue/autogen.sh
===================================================================
--- libnetfilter_queue/autogen.sh	(revision 4511)
+++ libnetfilter_queue/autogen.sh	(working copy)
@@ -1,5 +1,39 @@
 #!/bin/sh
 
+include ()
+{
+    # If we keep a copy of the kernel header in the SVN tree, we'll have
+    # to worry about synchronization issues forever. Instead, we just copy 
+    # the headers that we need from the lastest kernel version at autogen
+    # stage.
+
+    INCLUDEDIR=/lib/modules/`uname -r`/build/include/linux
+    if [ -f $INCLUDEDIR/netfilter/nfnetlink_queue.h ]
+    then
+    	TARGET=include/libnetfilter_queue/linux_nfnetlink_queue.h
+    	echo "Copying nfnetlink_queue.h to linux_nfnetlink_queue.h"
+    	cp $INCLUDEDIR/netfilter/nfnetlink_queue.h $TARGET
+	TEMP=`tempfile`
+	sed 's/linux\/netfilter\/nfnetlink.h/libnfnetlink\/linux_nfnetlink.h/g' $TARGET > $TEMP
+	# Add aligned_u64 definition after #define _NFNETLINK_QUEUE_H
+	awk '{
+        if ( $0 == "#define _NFNETLINK_QUEUE_H" ) {
+		print $0
+		getline
+		print $0
+		print "#ifndef aligned_u64"
+		print "#define aligned_u64 unsigned long long __attribute__((aligned(8)))"
+		print "#endif"
+	}
+
+	print $0
+	}' $TEMP > $TARGET
+    else
+    	echo "can't find nfnetlink_queue.h kernel file"
+    	exit 1
+    fi
+}
+
 run ()
 {
     echo "running: $*"
@@ -11,6 +45,7 @@
     fi
 }
 
+include
 run libtoolize
 run aclocal
 #run autoheader
Index: libnetfilter_log/autogen.sh
===================================================================
--- libnetfilter_log/autogen.sh	(revision 4511)
+++ libnetfilter_log/autogen.sh	(working copy)
@@ -1,5 +1,39 @@
 #!/bin/sh
 
+include ()
+{
+    # If we keep a copy of the kernel header in the SVN tree, we'll have
+    # to worry about synchronization issues forever. Instead, we just copy 
+    # the headers that we need from the lastest kernel version at autogen
+    # stage.
+
+    INCLUDEDIR=/lib/modules/`uname -r`/build/include/linux
+    if [ -f $INCLUDEDIR/netfilter/nfnetlink_log.h ]
+    then
+    	TARGET=include/libnetfilter_log/linux_nfnetlink_log.h
+    	echo "Copying nfnetlink_log.h to linux_nfnetlink_log.h"
+    	cp $INCLUDEDIR/netfilter/nfnetlink_log.h $TARGET
+	TEMP=`tempfile`
+	sed 's/linux\/netfilter\/nfnetlink.h/libnfnetlink\/linux_nfnetlink.h/g' $TARGET > $TEMP
+	# Add aligned_u64 definition after #define _NFNETLINK_LOG_H
+	awk '{
+        if ( $0 == "#define _NFNETLINK_LOG_H" ) {
+		print $0
+		getline
+		print $0
+		print "#ifndef aligned_u64"
+		print "#define aligned_u64 unsigned long long __attribute__((aligned(8)))"
+		print "#endif"
+	}
+
+	print $0
+	}' $TEMP > $TARGET
+    else
+    	echo "can't find nfnetlink_log.h kernel file"
+    	exit 1
+    fi
+}
+
 run ()
 {
     echo "running: $*"
@@ -11,6 +45,7 @@
     fi
 }
 
+include
 run aclocal
 #run autoheader
 run libtoolize -f

--------------010809060205030400010004--
