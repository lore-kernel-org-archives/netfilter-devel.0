From: Henrik Nordstrom <hno@marasystems.com>
Subject: [resend] p-o-m runme --exclude update
Date: Thu, 13 Nov 2003 16:22:26 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0311131619330.20382-100000@filer.marasystems.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

This patch extends the --exlude option to runme to accept pathes named by 
their full name (including .patch). Previously the --exclude option only 
matched patches by their internal base name (dir/patchname without 
.patch).

This makes --exclude more consistent with the other patch naming in
patch-o-matic use.

Regards
Henrik


--- runme       13 Oct 2003 21:08:40 -0000      1.50
+++ runme       13 Nov 2003 15:18:42 -0000
@@ -1082,7 +1082,7 @@
 until [ $DONE ];
 do
     PROCESSED=
-    SEEN="$EXCLUDED "
+    SEEN="${EXCLUDED//.patch/} "
     process_patches $PATCHES
     DONE=1
 done 
