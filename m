From: Martin Josefsson <gandalf@wlug.westbo.se>
Subject: Re: tcp-window-tracking vs. pending/24_conntrack-nosysctl.patch
Date: 05 Apr 2003 16:47:21 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1049554040.25168.187.camel@tux.rsn.bth.se>
References: <Pine.LNX.4.33.0304041041450.18961-100000@blackhole.kfki.hu>
	 <1049541403.25169.167.camel@tux.rsn.bth.se>
	 <1049545687.25167.177.camel@tux.rsn.bth.se>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-80cRowGH31hapOcDEkml"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
In-Reply-To: <1049545687.25167.177.camel@tux.rsn.bth.se>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--=-80cRowGH31hapOcDEkml
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Sat, 2003-04-05 at 14:28, Martin Josefsson wrote:

> I'll look at it more closely a little later today.

Seems to work fine in my new runme version.

I've attached two patches.
The first is my changes up till before I added this last copy-stuff.
The second is the copy-stuff I just added.

Do you see any problems? If not I'll commit the new version.

-- 
/Martin

--=-80cRowGH31hapOcDEkml
Content-Disposition: attachment; filename=runme-conflict
Content-Type: text/plain; name=runme-conflict; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

--- runme	2003-04-05 02:07:27.000000000 +0200
+++ runme-works	2003-04-05 13:14:27.000000000 +0200
@@ -302,30 +302,60 @@
 test_patch_depend()
 {
     # Check the dependecy of the patch
-    if [ -f "$1.depend" ]; then
+    if [ -f "$1.depend" -a -z "$MODE" ]; then
 	while read dep
 	do
+	    if [ -z "${dep/##*}" ]; then
+	    	continue
+	    fi
+
+	    not=3D0
+	    if [ -z "${dep/#not *}" ]; then
+		dep=3D${dep/#not }
+		not=3D1
+	    fi
+	   =20
 	    f=3D${dep%%.patch*}	# filename without .patch*
 	    p=3D${dep##$f.patch}	# protocol, if exist
 	    p=3D${p##.}
 	    n=3D$f${p:+-$p}
 	    if [ "`echo $PROCESSED | grep $n`" ]; then
-		continue
+		if [ $not =3D=3D 1 ]; then
+			echo >&2
+			echo "Conflicting dependency." >&2
+			echo "   $1" >&2
+			echo "is incompatible with" >&2
+			echo "   $dep" >&2
+			echo >&2
+			return 1
+		else
+			continue
+		fi
 	    elif [ "`echo $DEPEND | grep $dep`" ]; then
+		echo >&2
 		echo "Circular dependency, patch $1 cannot be applied." >&2
  		echo "Report the problem to the patch-o-matic maintainer." >&2
+		echo >&2
 		return 1
 	    fi
-	    echo Patch $1 depends on $dep...
+	    if [ $not =3D=3D 1 ]; then
+		echo Patch $1 conflicts with $dep...
+	    else
+	    	echo Patch $1 depends on $dep...
+	    fi
 	    DEPEND=3D"$DEPEND $dep"
-	    isapplied=3D
             if ./isapplied $KERNEL_DIR $dep
 	    then=20
-		isapplied=3DY
-	    fi
-            if [ "$isapplied" -a -z "$MODE" ] || [ ! "$isapplied" -a -n "$=
MODE" ]
-            then :
-            elif test_patch_depend $dep ${p:-"ipv4"}
+		if [ $not =3D=3D 1 ]; then
+			echo >&2
+			echo "Conflicting dependency." >&2
+			echo "   $1" >&2
+			echo "is incompatible with" >&2
+			echo "   $dep" >&2
+			echo >&2
+			return 1
+		fi
+            elif [ $not =3D=3D 1 ] || test_patch_depend $dep ${p:-"ipv4"}
 	    then :
 	    else
 		return 1
@@ -402,30 +432,60 @@
 apply_patch_depend()
 {
     # Check the dependecy of the patch
-    if [ -f "$1.depend" ]; then
+    if [ -z "$3" -a -f "$1.depend" -a -z "$MODE" ]; then
 	while read dep
 	do
+	    if [ -z "${dep/##*}" ]; then
+	    	continue
+	    fi
+
+	    not=3D0
+	    if [ -z "${dep/#not *}" ]; then
+		dep=3D${dep/#not }
+		not=3D1
+	    fi
+
 	    f=3D${dep%%.patch*}	# filename without .patch*
 	    p=3D${dep##$f.patch}	# protocol, if exist
 	    p=3D${p##.}
 	    n=3D$f${p:+-$p}
 	    if [ "`echo $PROCESSED | grep $n`" ]; then
-		continue
+		if [ $not =3D=3D 1 ]; then
+			echo >&2
+			echo "Conflicting dependency." >&2
+			echo "   $1" >&2
+			echo "is incompatible with" >&2
+			echo "   $dep" >&2
+			echo >&2
+			return 1
+		else
+			continue
+		fi
 	    elif [ "`echo $DEPEND | grep $dep`" ]; then
+		echo >&2
 		echo "Circular dependency, patch $1 cannot be applied." >&2
  		echo "Report the problem to the patch-o-matic maintainer." >&2
+		echo >&2
 		return 1
 	    fi
-	    echo Patch $1 depends on $dep...
+	    if [ $not =3D=3D 1 ]; then
+		echo Patch $1 conflicts with $dep...
+	    else
+	    	echo Patch $1 depends on $dep...
+	    fi
 	    DEPEND=3D"$DEPEND $dep"
-	    isapplied=3D
             if ./isapplied $KERNEL_DIR $dep
 	    then=20
-		isapplied=3DY
-	    fi
-            if [ "$isapplied" -a -z "$MODE" ] || [ ! "$isapplied" -a -n "$=
MODE" ]
-            then :
-	    elif apply_patch_depend $dep ${p:-"ipv4"}
+		if [ $not =3D=3D 1 ]; then
+			echo >&2
+			echo "Conflicting dependency." >&2
+			echo "   $1" >&2
+			echo "is incompatible with" >&2
+			echo "   $dep" >&2
+			echo >&2
+			return 1
+		fi
+	    elif [ $not =3D=3D 1 ] || apply_patch_depend $dep ${p:-"ipv4"}
 	    then :
 	    else
 		return 1
@@ -493,7 +553,7 @@
 apply_patch()
 {
     DEPEND=3D$1
-    apply_patch_depend $1 $2
+    apply_patch_depend $1 $2 $3
 }
=20
 # Reverse order of arguments.
@@ -664,7 +724,7 @@
 			    test_patch $THIS_PATCH ${PROTO:-"ipv4"}
 			    ;;
 		        f*|F*)
-			    apply_patch $THIS_PATCH ${PROTO:-"ipv4"}
+			    apply_patch $THIS_PATCH ${PROTO:-"ipv4"} force
 			    PROCESSED=3D"$PROCESSED $SUITE/$BASE${PROTO:+-$PROTO}"
 			    entertocont # pause before screen is cleared by printheader
 			    ;;

--=-80cRowGH31hapOcDEkml
Content-Disposition: attachment; filename=runme-copy
Content-Type: text/plain; name=runme-copy; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

--- ../../tmp/runme-works	2003-04-05 13:14:27.000000000 +0200
+++ runme	2003-04-05 16:33:04.000000000 +0200
@@ -48,6 +48,14 @@
 	echo
 }
=20
+#
+# WARNING: this function could fail, always check the output.
+#
+tmpdirname()
+{
+	dd if=3D/dev/urandom bs=3D32 count=3D1 2>/dev/null | od -x -w32 -A n | tr=
 -d ' '
+}
+
 # Too many rejects from trying to patch Configure.help/Config.help and Con=
fig.in.
 # So we use special format: First line specifies entry we want to
 # follow, and rest of file is pasted in under that.
@@ -344,7 +352,7 @@
 	    	echo Patch $1 depends on $dep...
 	    fi
 	    DEPEND=3D"$DEPEND $dep"
-            if ./isapplied $KERNEL_DIR $dep
+            if ./isapplied $KTMPDIR $dep
 	    then=20
 		if [ $not =3D=3D 1 ]; then
 			echo >&2
@@ -355,7 +363,7 @@
 			echo >&2
 			return 1
 		fi
-            elif [ $not =3D=3D 1 ] || test_patch_depend $dep ${p:-"ipv4"}
+            elif [ $not =3D=3D 1 ] || apply_patch_depend $dep ${p:-"ipv4"}
 	    then :
 	    else
 		return 1
@@ -365,21 +373,21 @@
=20
     echo Testing patch $1...
=20
-    if [ -f "$KERNEL_DIR/net/$2/netfilter/Config.help" ]; then
+    if [ -f "$KTMPDIR/net/$2/netfilter/Config.help" ]; then
     	DOCUMENTATIONFILE=3D"net/$2/netfilter/Config.help"
-    elif [ -f "$KERNEL_DIR/Documentation/Configure.help" ]; then
+    elif [ -f "$KTMPDIR/Documentation/Configure.help" ]; then
         DOCUMENTATIONFILE=3D"Documentation/Configure.help"
     else
         echo Warning - no help text file could be found in either >&2
-        echo $KERNEL_DIR/net/$2/netfilter/Config.help >&2
-        echo or $KERNEL_DIR/Documentation/Configure.help >&2
+        echo $KTMPDIR/net/$2/netfilter/Config.help >&2
+        echo or $KTMPDIR/Documentation/Configure.help >&2
 	DOCUMENTATIONFILE=3D/dev/null
     fi
=20
-    if apply_config_in_changes $1 $KERNEL_DIR/net/$2/netfilter test &&
-	apply_config_help_changes $1 $KERNEL_DIR/$DOCUMENTATIONFILE test &&
-	apply_makefile_changes $1 $KERNEL_DIR/net/$2/netfilter test &&
-	apply_conntrack_h_changes $1 $KERNEL_DIR/include/linux/netfilter_$2 test
+    if apply_config_in_changes $1 $KTMPDIR/net/$2/netfilter test &&
+	apply_config_help_changes $1 $KTMPDIR/$DOCUMENTATIONFILE test &&
+	apply_makefile_changes $1 $KTMPDIR/net/$2/netfilter test &&
+	apply_conntrack_h_changes $1 $KTMPDIR/include/linux/netfilter_$2 test
     then :
     else
 	return 1
@@ -387,14 +395,14 @@
=20
     if [ $MODE ]
     then
-    	REJECTS=3D`(cd $KERNEL_DIR && patch -R -p1 --dry-run | grep FAILED) <=
 $1`
+    	REJECTS=3D`(cd $KTMPDIR && patch -R -p1 --dry-run | grep FAILED) < $1=
`
     else
-    	REJECTS=3D`(cd $KERNEL_DIR && patch -p1 --dry-run | grep FAILED) < $1=
`
+    	REJECTS=3D`(cd $KTMPDIR && patch -p1 --dry-run | grep FAILED) < $1`
     fi
=20
     if [ "$REJECTS" ]
     then
-	echo "Testing of patch failed in $KERNEL_DIR" >&2
+	echo "Failed to patch copy of $KERNEL_DIR" >&2
 	return 1
     fi
     if [ ! -e $1.userspace ];
@@ -425,7 +433,32 @@
 test_patch()
 {
     DEPEND=3D$1
-    test_patch_depend $1 $2
+
+    if [ -f "$1.depend" -a -z "$MODE" ]; then
+	KTMPDIR=3D`tmpdirname`
+	# I'm really paranoid.  What if there's no /dev/urandom?
+	if [ -z "$KTMPDIR" ]; then
+	   echo Failed to generate kernel tmpdirname: perhaps your /dev/urandom i=
s broken >&2
+	   exit 1
+	fi
+	KTMPDIR=3D$KERNEL_DIR/../$KTMPDIR
+	if cp -al $KERNEL_DIR/. $KTMPDIR
+	then :
+	else
+	   echo Failed to make copy of $KERNEL_DIR >&2
+	   rm -rf $KTMPDIR
+	   exit 1
+	fi
+
+	test_patch_depend $1 $2
+	ret=3D$?
+=09
+	rm -rf $KTMPDIR
+	return $ret
+    else
+	    KTMPDIR=3D$KERNEL_DIR
+	    test_patch_depend $1 $2
+    fi
 }
=20
 # Args: patch filename, protocol.
@@ -474,7 +507,7 @@
 	    	echo Patch $1 depends on $dep...
 	    fi
 	    DEPEND=3D"$DEPEND $dep"
-            if ./isapplied $KERNEL_DIR $dep
+            if ./isapplied $KTMPDIR $dep
 	    then=20
 		if [ $not =3D=3D 1 ]; then
 			echo >&2
@@ -494,15 +527,15 @@
     fi
=20
     echo `modesense 3` patch $1...
-    REJECTSBEFORE=3D"`find $KERNEL_DIR/. -name '*.rej' -exec cat {} \; | g=
rep -c '^\*\*\* '`"
+    REJECTSBEFORE=3D"`find $KTMPDIR/. -name '*.rej' -exec cat {} \; | grep=
 -c '^\*\*\* '`"
     if [ -e $1.userspace ];
     then
         REJECTSBEFOREU=3D"`find $NETFILTERDIR/. -name '*.rej' -exec cat {}=
 \; | grep -c '^\*\*\* '`"
     fi
-    if (cd $KERNEL_DIR && if [ $MODE ]; then patch -R -p1; else patch -p1;=
 fi > /dev/null) < $1
+    if (cd $KTMPDIR && if [ $MODE ]; then patch -R -p1; else patch -p1; fi=
 > /dev/null) < $1
     then :
     else
-	echo Failed to patch $KERNEL_DIR >&2
+	echo Failed to patch copy of $KERNEL_DIR >&2
 	return 1
     fi
     if [ -e $1.userspace ];
@@ -514,7 +547,7 @@
             return 1
         fi
     fi
-    REJECTSAFTER=3D"`find $KERNEL_DIR/. -name '*.rej' -exec cat {} \; | gr=
ep -c '^\*\*\* '`"
+    REJECTSAFTER=3D"`find $KTMPDIR/. -name '*.rej' -exec cat {} \; | grep =
-c '^\*\*\* '`"
     if [ -e $1.userspace ];
     then
         REJECTSAFTERU=3D"`find $NETFILTERDIR/. -name '*.rej' -exec cat {} =
\; | grep -c '^\*\*\* '`"
@@ -525,7 +558,7 @@
         if [ "$REJECTSBEFORE" -ne "$REJECTSAFTER" ] || [ "$REJECTSBEFOREU"=
 -ne "$REJECTSAFTERU" ];
         then
             echo WARNING: patch $1 seems to have had rejects \(`expr $REJE=
CTSAFTER + $REJECTSAFTERU - $REJECTSBEFORE - $REJECTSBEFOREU` new rejection=
s\):
-	    find $KERNEL_DIR/. -name '*rej'
+	    find $KTMPDIR/. -name '*rej'
 	    find $NETFILTERDIR/. -name '*rej'
         else
 	    echo "   Patch $1 `modesense 2` cleanly."
@@ -538,20 +571,21 @@
         if [ "$REJECTSBEFORE" -ne "$REJECTSAFTER" ];
         then
             echo WARNING: patch $1 seems to have had rejects \(`expr $REJE=
CTSAFTER - $REJECTSBEFORE` new rejections\):
-	    find $KERNEL_DIR/. -name '*rej'
+	    find $KTMPDIR/. -name '*rej'
         else
 	    echo "   Patch $1 `modesense 2` cleanly."
         fi
     fi
-    apply_config_in_changes $1 $KERNEL_DIR/net/$2/netfilter/
-    apply_config_help_changes $1 $KERNEL_DIR/$DOCUMENTATIONFILE
-    apply_makefile_changes $1 $KERNEL_DIR/net/$2/netfilter/
-    apply_conntrack_h_changes $1 $KERNEL_DIR/include/linux/netfilter_$2
+    apply_config_in_changes $1 $KTMPDIR/net/$2/netfilter/
+    apply_config_help_changes $1 $KTMPDIR/$DOCUMENTATIONFILE
+    apply_makefile_changes $1 $KTMPDIR/net/$2/netfilter/
+    apply_conntrack_h_changes $1 $KTMPDIR/include/linux/netfilter_$2
 }
=20
 # Args: patch filename, protocol.
 apply_patch()
 {
+    KTMPDIR=3D$KERNEL_DIR
     DEPEND=3D$1
     apply_patch_depend $1 $2 $3
 }

--=-80cRowGH31hapOcDEkml--
