From: Martin Josefsson <gandalf@wlug.westbo.se>
Subject: [PATCH] runme patch for 2.5
Date: 10 Oct 2002 16:33:15 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1034260395.25142.13.camel@tux>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-ZpVIJEVLEQBtBOE0dbMG"
Cc: Harald Welte <laforge@gnumonks.org>
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


--=-ZpVIJEVLEQBtBOE0dbMG
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Hi there,

Here's a small patch that will make patch-o-matic work with kernel 2.5
There's been some configurationchanges (Documentation/Configure.help
doesn't exist anymore)

This patch will make 'runme' incompatible with kernel 2.4 so use it only
with 2.5 kernels.

-- 
/Martin

Never argue with an idiot. They drag you down to their level, then beat
you with experience.

--=-ZpVIJEVLEQBtBOE0dbMG
Content-Disposition: attachment; filename=runme-2.5-patch
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; name=runme-2.5-patch; charset=ISO-8859-15

--- patch-o-matic/runme-2.4	2002-10-05 03:14:47.000000000 +0200
+++ patch-o-matic/runme	2002-10-05 02:22:38.000000000 +0200
@@ -52,7 +52,7 @@
 	dd if=3D/dev/urandom bs=3D32 count=3D1 2>/dev/null | od -x -w32 -A n | tr=
 -d ' '
 }
=20
-# Too many rejects from trying to patch Configure.help and Config.in.
+# Too many rejects from trying to patch Config.help and Config.in.
 # So we use special format: First line specifies entry we want to
 # follow, and rest of file is pasted in under that.
=20
@@ -123,10 +123,10 @@
 apply_config_help_change()
 {
     PRIOR=3D"`head -1 $1`"
-    LINE=3D`fgrep -x -n "$PRIOR" $2/Configure.help | cut -d: -f1 | head -1=
`
+    LINE=3D`fgrep -x -n "$PRIOR" $2/Config.help | cut -d: -f1 | head -1`
     if [ -z "$LINE" ] || [ "$LINE" -eq 0 ]
     then
-	echo Could not find place to slot in Configure.help entry >&2
+	echo Could not find place to slot in Config.help entry >&2
 	return 1
     fi
=20
@@ -135,13 +135,13 @@
         # Reverse "patch"
=20
         NUMLINES1=3D`sed -n \$=3D $1`
-        NUMLINES2=3D`sed -n \$=3D $2/Configure.help`
+        NUMLINES2=3D`sed -n \$=3D $2/Config.help`
         BEGIN=3D2
=20
-        LINES=3D`fgrep -nx "\`sed -n 2p $1\`" $2/Configure.help | cut -d: =
-f1`
+        LINES=3D`fgrep -nx "\`sed -n 2p $1\`" $2/Config.help | cut -d: -f1=
`
         if [ -z "$LINES" ]
         then
-	    echo Configure.help text not found >&2
+	    echo Config.help text not found >&2
             return 1
         fi
=20
@@ -152,7 +152,7 @@
             TESTLINE=3D$BEGIN
             # Be paranoid and check for match on all lines
             while `let "$TESTLINE <=3D $NUMLINES1"`; do
-                NOMATCH=3D`awk "NR=3D=3D$x + $TESTLINE - $BEGIN" $2/Config=
ure.help|\
+                NOMATCH=3D`awk "NR=3D=3D$x + $TESTLINE - $BEGIN" $2/Config=
.help|\
                         fgrep -xcv "\`sed -n -e ${TESTLINE}p $1\`"`;
=20
                 if [ $NOMATCH -ne 0 ]; then continue 2; fi
@@ -165,42 +165,42 @@
         done; # for
=20
         if [ ! "$MATCHES" ]; then
-            echo Configure.help text not found >&2
+            echo Config.help text not found >&2
             return 1
         fi;
=20
         for x in $MATCHES; do
-#            if (head -`expr $x - 1` $2/Configure.help && \
-#                tail -n +`expr $x + $NUMLINES1` $2/Configure.help) > $2/C=
onfigure.help.tmp
-	    if (awk "NR=3D=3D1,NR=3D=3D$x - 1" $2/Configure.help && \
-                awk "NR=3D=3D$x + $NUMLINES1,NR=3D0" $2/Configure.help) > =
$2/Configure.help.tmp
+#            if (head -`expr $x - 1` $2/Config.help && \
+#                tail -n +`expr $x + $NUMLINES1` $2/Config.help) > $2/Conf=
ig.help.tmp
+	    if (awk "NR=3D=3D1,NR=3D=3D$x - 1" $2/Config.help && \
+                awk "NR=3D=3D$x + $NUMLINES1,NR=3D0" $2/Config.help) > $2/=
Config.help.tmp
             then
-                mv $2/Configure.help.tmp $2/Configure.help
+                mv $2/Config.help.tmp $2/Config.help
             else
-                echo Could not update Configure.help >&2
-                rm -f $2/Configure.help.tmp
+                echo Could not update Config.help >&2
+                rm -f $2/Config.help.tmp
                 return 1
             fi
         done
-        echo "   Configure.help updated"
+        echo "   Config.help updated"
         return 0
     fi
=20
     #Apply "Patch"
=20
-    rm -f $2/Configure.help.tmp
+    rm -f $2/Config.help.tmp
     # Use awk to force newline if last line of $1 has only spaces
     # Necessary to properly remove inserted text if patch is reversed
-    if (awk "NR=3D=3D1,NR=3D=3D$LINE-2" $2/Configure.help && awk "NR=3D=3D=
2,NR=3D=3D0" $1 && echo && \
-        awk "NR=3D=3D$LINE-1,NR=3D=3D0" $2/Configure.help) > $2/Configure.=
help.tmp
+    if (awk "NR=3D=3D1,NR=3D=3D$LINE-2" $2/Config.help && awk "NR=3D=3D2,N=
R=3D=3D0" $1 && echo && \
+        awk "NR=3D=3D$LINE-1,NR=3D=3D0" $2/Config.help) > $2/Config.help.t=
mp
     then
-	mv $2/Configure.help.tmp $2/Configure.help
+	mv $2/Config.help.tmp $2/Config.help
     else
-	echo Could not slot in Configure.help entry >&2
-	rm -f $2/Configure.help.tmp
+	echo Could not slot in Config.help entry >&2
+	rm -f $2/Config.help.tmp
 	return 1
     fi
-    echo "   Placed new Configure.help entry"
+    echo "   Placed new Config.help entry"
     return 0
 }
=20
@@ -336,7 +336,7 @@
     echo Testing patch $1...
=20
     if apply_config_in_changes $1 $KTMPDIR/net/$2/netfilter &&
-	apply_config_help_changes $1 $KTMPDIR/Documentation &&
+	apply_config_help_changes $1 $KTMPDIR/net/$2/netfilter &&
 	apply_makefile_changes $1 $KTMPDIR/net/$2/netfilter &&
 	apply_conntrack_h_changes $1 $KTMPDIR/include/linux/netfilter_$2
     then :
@@ -461,7 +461,7 @@
         fi
     fi
     apply_config_in_changes $1 $KERNEL_DIR/net/$2/netfilter/
-    apply_config_help_changes $1 $KERNEL_DIR/Documentation/
+    apply_config_help_changes $1 $KERNEL_DIR/net/$2/netfilter/
     apply_makefile_changes $1 $KERNEL_DIR/net/$2/netfilter/
     apply_conntrack_h_changes $1 $KERNEL_DIR/include/linux/netfilter_$2
 }

--=-ZpVIJEVLEQBtBOE0dbMG--
