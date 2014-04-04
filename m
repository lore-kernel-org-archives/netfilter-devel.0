From: Neutron Soutmun <neo.neutron@gmail.com>
Subject: [PATCH] ipset: Pass IPSET_BIN to test scripts to change binary
 location
Date: Fri, 4 Apr 2014 10:24:22 +0700
Message-ID: <20140404032422.GA5954@nitrogen.neutroncom.local>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="dDRMvlgZJXvWKvBx"
Cc: kadlec@blackhole.kfki.hu
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:47230 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751215AbaDDDY2 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 3 Apr 2014 23:24:28 -0400
Received: by mail-pb0-f46.google.com with SMTP id rq2so2824054pbb.33
        for <netfilter-devel@vger.kernel.org>; Thu, 03 Apr 2014 20:24:28 -0700 (PDT)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--dDRMvlgZJXvWKvBx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

In the "as-installed" package testing situation, the test scripts should
invokes the system installed "ipset" binary.
Therefore, the IPSET_BIN could be passed to change the binary location.

  IPSET_BIN=3D/sbin/ipset ./runtest.sh

The test scripts run fine in build source tree without IPSET_BIN.

Signed-off-by: Neutron Soutmun <neo.neutron@gmail.com>
---
 tests/check_cidrs.sh       | 18 +++++++++---------
 tests/check_counters       |  4 +++-
 tests/check_extensions     |  4 +++-
 tests/check_sendip_packets |  0
 tests/iptables.sh          | 40 +++++++++++++++++++++-------------------
 tests/resize.sh            |  8 +++++---
 tests/resizec.sh           |  2 +-
 tests/resizen.sh           |  2 +-
 tests/resizet.sh           |  2 +-
 tests/runtest.sh           |  8 +++++---
 tests/setlist_resize.sh    |  8 +++++---
 11 files changed, 54 insertions(+), 42 deletions(-)
 mode change 100644 =3D> 100755 tests/check_counters
 mode change 100644 =3D> 100755 tests/check_extensions
 mode change 100644 =3D> 100755 tests/check_sendip_packets
 mode change 100644 =3D> 100755 tests/resizec.sh
 mode change 100644 =3D> 100755 tests/resizen.sh
 mode change 100644 =3D> 100755 tests/resizet.sh

diff --git a/tests/check_cidrs.sh b/tests/check_cidrs.sh
index ee89e37..38f735f 100755
--- a/tests/check_cidrs.sh
+++ b/tests/check_cidrs.sh
@@ -2,22 +2,22 @@
=20
 set -e
=20
-cmd=3D../src/ipset
+ipset=3D${IPSET_BIN:-../src/ipset}
=20
-$cmd f
-$cmd x
-$cmd n test hash:net
+$ipset f
+$ipset x
+$ipset n test hash:net
 for x in `seq 1 32`; do
-    $cmd a test 10.0.0.0/$x
-    n=3D`$cmd l test | wc -l`
+    $ipset a test 10.0.0.0/$x
+    n=3D`$ipset l test | wc -l`
     n=3D$((n - 7))
     test $n -eq $x || exit 1
 done
 for x in `seq 32 -1 1`; do
-    $cmd d test 10.0.0.0/$x
-    n=3D`$cmd l test | wc -l`
+    $ipset d test 10.0.0.0/$x
+    n=3D`$ipset l test | wc -l`
     # We deleted one element
     n=3D$((n - 7 + 1))
     test $n -eq $x || exit 1
 done
-$cmd x test
+$ipset x test
diff --git a/tests/check_counters b/tests/check_counters
old mode 100644
new mode 100755
index 0099f23..912067a
--- a/tests/check_counters
+++ b/tests/check_counters
@@ -1,6 +1,8 @@
 #!/bin/bash
=20
-read ip p packets b bytes <<< $(../src/ipset l $1 | grep ^$2)
+ipset=3D${IPSET_BIN:-../src/ipset}
+
+read ip p packets b bytes <<< $($ipset l $1 | grep ^$2)
 test -z "$packets" -o -z "$bytes" && exit 1
 test $packets -ne $3 -o $bytes -ne $4 && exit 1
 exit 0
diff --git a/tests/check_extensions b/tests/check_extensions
old mode 100644
new mode 100755
index 5848b38..77e7c2c
--- a/tests/check_extensions
+++ b/tests/check_extensions
@@ -1,6 +1,8 @@
 #!/bin/bash
=20
-read ip t timeout p packets b bytes <<< $(../src/ipset l $1 | grep ^$2)
+ipset=3D${IPSET_BIN:-../src/ipset}
+
+read ip t timeout p packets b bytes <<< $($ipset l $1 | grep ^$2)
 test -z "$timeout" -o -z "$packets" -o -z "$bytes" && exit 1
 test $timeout -gt $3 -o $timeout -lt $(($3 - 10)) && exit 1
 test $packets -ne $4 -o $bytes -ne $5 && exit 1
diff --git a/tests/check_sendip_packets b/tests/check_sendip_packets
old mode 100644
new mode 100755
diff --git a/tests/iptables.sh b/tests/iptables.sh
index 63b0b92..03d2e09 100755
--- a/tests/iptables.sh
+++ b/tests/iptables.sh
@@ -3,6 +3,8 @@
 # set -x
 set -e
=20
+ipset=3D${IPSET_BIN:-../src/ipset}
+
 # We play with the following networks:
 # inet: 10.255.255.0/24
 # 	10.255.255.0-31 in ip1
@@ -37,14 +39,14 @@ esac
=20
 case "$2" in
 start)
-	../src/ipset n ip1 hash:ip $family 2>/dev/null
-	../src/ipset a ip1 $IP1 2>/dev/null
-	../src/ipset n ip2 hash:ip $family 2>/dev/null
-	../src/ipset a ip2 $IP2 2>/dev/null
-	../src/ipset n ipport hash:ip,port $family 2>/dev/null
-	../src/ipset n list list:set 2>/dev/null
-	../src/ipset a list ipport 2>/dev/null
-	../src/ipset a list ip1 2>/dev/null
+	$ipset n ip1 hash:ip $family 2>/dev/null
+	$ipset a ip1 $IP1 2>/dev/null
+	$ipset n ip2 hash:ip $family 2>/dev/null
+	$ipset a ip2 $IP2 2>/dev/null
+	$ipset n ipport hash:ip,port $family 2>/dev/null
+	$ipset n list list:set 2>/dev/null
+	$ipset a list ipport 2>/dev/null
+	$ipset a list ip1 2>/dev/null
 	$cmd -A INPUT ! -s $NET -j ACCEPT
 	$cmd -A INPUT -m set ! --match-set ip1 src \
 		      -m set ! --match-set ip2 src \
@@ -62,10 +64,10 @@ start)
 	cat /dev/null > /var/log/kern.log
 	;;
 start_flags)
-	../src/ipset n test hash:net $family 2>/dev/null
-	../src/ipset a test 10.0.0.0/16 2>/dev/null
-	../src/ipset a test 10.0.0.0/24 nomatch 2>/dev/null
-	../src/ipset a test 10.0.0.1 2>/dev/null
+	$ipset n test hash:net $family 2>/dev/null
+	$ipset a test 10.0.0.0/16 2>/dev/null
+	$ipset a test 10.0.0.0/24 nomatch 2>/dev/null
+	$ipset a test 10.0.0.1 2>/dev/null
 	$cmd -A INPUT ! -s 10.0.0.0/16 -j ACCEPT
 	$cmd -A INPUT -m set --match-set test src \
 		      -j LOG --log-prefix "in set test: "
@@ -76,10 +78,10 @@ start_flags)
 	cat /dev/null > /var/log/kern.log
 	;;
 start_flags_reversed)
-	../src/ipset n test hash:net $family 2>/dev/null
-	../src/ipset a test 10.0.0.0/16 2>/dev/null
-	../src/ipset a test 10.0.0.0/24 nomatch 2>/dev/null
-	../src/ipset a test 10.0.0.1 2>/dev/null
+	$ipset n test hash:net $family 2>/dev/null
+	$ipset a test 10.0.0.0/16 2>/dev/null
+	$ipset a test 10.0.0.0/24 nomatch 2>/dev/null
+	$ipset a test 10.0.0.1 2>/dev/null
 	$cmd -A INPUT ! -s 10.0.0.0/16 -j ACCEPT
 	$cmd -A INPUT -m set --match-set test src --return-nomatch \
 		      -j LOG --log-prefix "in set test-nomatch: "
@@ -94,14 +96,14 @@ del)
 	$cmd -A INPUT -j SET --del-set ipport src,src
 	;;
 timeout)
-	../src/ipset n test hash:ip,port timeout 2
+	$ipset n test hash:ip,port timeout 2
 	$cmd -A INPUT -j SET --add-set test src,src --timeout 10 --exist
 	;;
 stop)
 	$cmd -F
 	$cmd -X
-	../src/ipset -F 2>/dev/null
-	../src/ipset -X 2>/dev/null
+	$ipset -F 2>/dev/null
+	$ipset -X 2>/dev/null
 	;;
 *)
 	echo "Usage: $0 start|stop"
diff --git a/tests/resize.sh b/tests/resize.sh
index 008c607..19b93fb 100755
--- a/tests/resize.sh
+++ b/tests/resize.sh
@@ -1,12 +1,14 @@
 #!/bin/bash
=20
-../src/ipset x resize-test 2>/dev/null
+ipset=3D${IPSET_BIN:-../src/ipset}
+
+$ipset x resize-test 2>/dev/null
=20
 set -e
=20
-../src/ipset n resize-test hash:ip hashsize 64
+$ipset n resize-test hash:ip hashsize 64
 for x in `seq 1 32`; do
    for y in `seq 1 255`; do
-      ../src/ipset a resize-test 192.168.$x.$y
+      $ipset a resize-test 192.168.$x.$y
    done
 done
diff --git a/tests/resizec.sh b/tests/resizec.sh
old mode 100644
new mode 100755
index c9b0c41..28d6747
--- a/tests/resizec.sh
+++ b/tests/resizec.sh
@@ -3,7 +3,7 @@
 # set -x
 set -e
=20
-ipset=3D../src/ipset
+ipset=3D${IPSET_BIN:-../src/ipset}
=20
 case "$1" in
     -4)
diff --git a/tests/resizen.sh b/tests/resizen.sh
old mode 100644
new mode 100755
index 9ceee88..9322bd2
--- a/tests/resizen.sh
+++ b/tests/resizen.sh
@@ -3,7 +3,7 @@
 # set -x
 set -e
=20
-ipset=3D../src/ipset
+ipset=3D${IPSET_BIN:-../src/ipset}
=20
 case "$1" in
     -4)
diff --git a/tests/resizet.sh b/tests/resizet.sh
old mode 100644
new mode 100755
index 753c08e..b5f7fdc
--- a/tests/resizet.sh
+++ b/tests/resizet.sh
@@ -3,7 +3,7 @@
 # set -x
 set -e
=20
-ipset=3D../src/ipset
+ipset=3D${IPSET_BIN:-../src/ipset}
=20
 case "$1" in
     -4)
diff --git a/tests/runtest.sh b/tests/runtest.sh
index 99e5e6c..fbfa154 100755
--- a/tests/runtest.sh
+++ b/tests/runtest.sh
@@ -2,6 +2,8 @@
=20
 # set -x
=20
+ipset=3D${IPSET_BIN:-../src/ipset}
+
 tests=3D"init"
 tests=3D"$tests ipmap bitmap:ip"
 tests=3D"$tests macipmap portmap"
@@ -65,7 +67,7 @@ fi
 chmod a+x check_* *.sh
=20
 for types in $tests; do
-    ../src/ipset -X test >/dev/null 2>&1
+    $ipset -X test >/dev/null 2>&1
     if [ -f $types ]; then
     	filename=3D$types
     else
@@ -92,7 +94,7 @@ for types in $tests; do
 		;;
 	esac
 	echo -ne "$types: $what: "
-	cmd=3D`echo $cmd | sed 's/ipset/..\/src\/ipset 2>.foo.err/'`
+	cmd=3D`echo $cmd | sed "s|ipset|$ipset 2>.foo.err|"`
 	eval $cmd
 	r=3D$?
 	# echo $ret $r
@@ -108,7 +110,7 @@ for types in $tests; do
     done < $filename
 done
 # Remove test sets created by setlist.t
-../src/ipset -X >/dev/null 2>&1
+$ipset -X >/dev/null 2>&1
 for x in $tests; do
 	case $x in
 	init)
diff --git a/tests/setlist_resize.sh b/tests/setlist_resize.sh
index 7e7ad24..01d1cfc 100755
--- a/tests/setlist_resize.sh
+++ b/tests/setlist_resize.sh
@@ -2,6 +2,8 @@
=20
 # set -x
=20
+ipset=3D${IPSET_BIN:-../src/ipset}
+
 loop=3D8
=20
 for x in ip_set_list_set ip_set_hash_netiface ip_set_hash_ipportnet \
@@ -16,7 +18,7 @@ done
 create() {
     n=3D$1
     while [ $n -le 1024 ]; do
-    	../src/ipset c test$n hash:ip
+      $ipset c test$n hash:ip
     	n=3D$((n+2))
     done
 }
@@ -26,8 +28,8 @@ for x in `seq 1 $loop`; do
     create 1 &
     create 2 &
     wait
-    test `../src/ipset l -n | wc -l` -eq 1024 || exit 1
-    ../src/ipset x
+    test `$ipset l -n | wc -l` -eq 1024 || exit 1
+    $ipset x
     test `lsmod|grep -w ^ip_set_hash_ip | awk '{print $3}'` -eq 0 || exit 1
     rmmod ip_set_hash_ip
     rmmod ip_set
--=20
1.9.1


--dDRMvlgZJXvWKvBx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCAAGBQJTPiXmAAoJEJ0EcL2mzcRXmlAQAMR5iZ/T2mg+5dMhtPI7mb0D
7zd/zcrgGv4UMUPOeI5fIonrOJ5dlsu6ZOYi5U03WEYROvR245Pzz6ROZclhMl2t
YRcc3W0YF3t4R9F29xRLa2ngSImXDtjLOVOxTGj/xp7vrwWCuZ9AKJAHr1+vcpdL
vJ82lydIzSV0rcTWhUUbyLx+tJ3QE2ddSCaCyQGoFVi9YEWcNPVp2JLI9IBr3+LT
7nzQmVe5eVnOhbBLna9kahOWMVS/8BS6dQ3ldW8PuXJKDOtT42SJg0FtrRTaFMOh
m22lKvww0eAP3t/pBzZS6AOn3lZKBgvB1l52GSO094oMH61DOR+iYhwhxgrTPZh1
zc7T5vMmrsTxPHe2SS4NjxMunmnOU9fcYPGZZ0EYjr/IZ5pMj2h9hkzX2CLZS2h1
orC7CEYzD9jxHZV6T8qNnvfE7xX1sR747KHjwhm2dPNrCzR/75VmFDwVGoZFYG/7
bSGyom65+qSIWa5RheoJOlr67IdzJx1Q524eTgpqgJd9hLJj/yk2fUVPx5yKK7RR
YAEl6CGY+klWFwT5e+aSyPjY6vBaP7FtA0ULB+R1cZVvSk6Ih2FC1q7CWqN5uxuR
Qf2+XIGl+UhbkAxwXcJPDDZWLt5F/k0C80nmUjZv6WqMnf8K45jDb1HUUqXvscY1
+Mc4OjfgUutt6tuLqHKM
=E7Vx
-----END PGP SIGNATURE-----

--dDRMvlgZJXvWKvBx--
