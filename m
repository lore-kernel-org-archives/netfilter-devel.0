From: Henrik Nordstrom <hno@marasystems.com>
Subject: runme --exclude does not like xxx.patch arguments
Date: Sun, 12 Oct 2003 09:16:53 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0310120912380.26419-100000@filer.marasystems.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Netfilter-devel <netfilter-devel@lists.netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

The --exclude option in it's current incarnation is a litle inconsequent 
in that it expexts patches to be named without .patch while included 
patches are expected to be named with .patch.

This small patch extends the --exclude option to also accept patches to be 
named as xxx.patch 

Index: runme
===================================================================
RCS file: /cvspublic/netfilter/patch-o-matic/runme,v
retrieving revision 1.48
diff -u -w -p -r1.48 runme
--- runme       10 Aug 2003 09:44:16 -0000      1.48
+++ runme       12 Oct 2003 07:12:00 -0000
@@ -1044,7 +1044,7 @@ DONE=
 until [ $DONE ];
 do
     PROCESSED=
-    SEEN="$EXCLUDED "
+    SEEN="${EXCLUDED//.patch/} "
     process_patches $PATCHES
     DONE=1
 done 

Regards
Henrik
