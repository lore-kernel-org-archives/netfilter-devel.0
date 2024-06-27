Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60B9E31758
	for <netfilter-devel@vger.kernel.org>; Thu, 27 Jun 2024 08:18:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719476310; cv=none; b=RgnVruTaMco9icl1doXMRK8iBy4eqo46T0RD2pzN2eiYmxayiPvLa1Hw6i9johGIlxd2ijqiiOzlCae/L9ssILrC/dkoHKCpK006JVzsL7V5q+i5wOCplUZ+mbnLv19qjUGihtxJAg5fH6UWNivql/LMwGdsX4qWRIAFKAxoii4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719476310; c=relaxed/simple;
	bh=6jLUrQaZ8HqS9zA+3gxTmLB9H/qCaGHum1tSj6k5uXs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TdSLVobkrKNiTSageW9rXg0YQrO8LWD5eY6H4Lfvb9iskuy00HWV74MacGciGQG2gMH0rP9yliDrbTeH+Ez5iGpy26Vydkdb5PF0ZYb5utiighfimCqY8V+WFv5MY0605YFHer9yYBnxEaKDAZtMWZBgk3RI5sJFfTcS/fXrMVI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=YblLndjK; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="YblLndjK"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=ydV65UObshyn7E6cwKnhtWIKtpCVrbP5D56MS/oODnc=; b=YblLndjKOT7iLvvepAn6bAb1qO
	cxgor2QHThzTy+dCL5TTPYtujTgcEwRFo+9bd5JSeV2F9WQy1xI7juQFTghuBWULZ4+c3XlIS/kkI
	zjP8G4Msz3khrivx05q1FN03FpOHbXBDc8nR6FPceCn+9itmkY1lptLFDkCCtIfghysgK3DKbWfAT
	UmIWx8ERgBSgf5SQziVjplCdlsxpgTss6UedctepdqLPejP3jKIA6AeaG4xaQYrU9MZPr5koGAfTn
	lPcTzb4gKIebfCeMWtSalHoxP2cCzsUyW5mpNJec9Qj3OLlgVspOmXAfQJrVYNEO+DJZxTELglABI
	UnTPdgDQ==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1sMkKk-0000000080D-2AVd;
	Thu, 27 Jun 2024 10:18:22 +0200
From: Phil Sutter <phil@nwl.cc>
To: Jozsef Kadlecsik <kadlec@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: [ipset PATCH 3/3] tests: Reduce testsuite run-time
Date: Thu, 27 Jun 2024 10:18:18 +0200
Message-ID: <20240627081818.16544-4-phil@nwl.cc>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240627081818.16544-1-phil@nwl.cc>
References: <20240627081818.16544-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Where acceptable, batch add set element calls to avoid overhead of
excessive 'ipset' program spawns. On my (slow) testing VM, this patch
reduces a full run of tests/runtest.sh from ~70min down to ~11min.

This might eliminate the situation being tested: resize.sh might be such
a case so batch only 255 'ipset add' calls and continue to repeat these
batched calls 32 times in hopes that it still qualifies as the resizing
stress test tests/hash:ip.t calls it.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 tests/resize.sh         |  4 ++--
 tests/resizec.sh        | 32 +++++++++++++--------------
 tests/resizen.sh        | 49 ++++++++++++++++++++---------------------
 tests/resizet.sh        | 40 ++++++++++++++++-----------------
 tests/setlist_resize.sh |  4 ++--
 5 files changed, 64 insertions(+), 65 deletions(-)

diff --git a/tests/resize.sh b/tests/resize.sh
index 19b93fb01876c..9069b4970e92d 100755
--- a/tests/resize.sh
+++ b/tests/resize.sh
@@ -9,6 +9,6 @@ set -e
 $ipset n resize-test hash:ip hashsize 64
 for x in `seq 1 32`; do
    for y in `seq 1 255`; do
-      $ipset a resize-test 192.168.$x.$y
-   done
+      echo "a resize-test 192.168.$x.$y"
+   done | $ipset restore
 done
diff --git a/tests/resizec.sh b/tests/resizec.sh
index 28d674769f76f..781acf74c38dd 100755
--- a/tests/resizec.sh
+++ b/tests/resizec.sh
@@ -25,65 +25,65 @@ case "$2" in
     	$ipset n test hash:ip $1 hashsize 64 comment
     	for x in `seq 0 16`; do
     	    for y in `seq 0 255`; do
-    	    	$ipset a test $ip$x$sep$y comment "text $ip$x$sep$y"
+    	    	echo "a test $ip$x$sep$y comment \"text $ip$x$sep$y\""
     	    done
-    	done
+    	done | $ipset restore
     	;;
     ipport)
     	$ipset n test hash:ip,port $1 hashsize 64 comment
     	for x in `seq 0 16`; do
     	    for y in `seq 0 255`; do
-    	    	$ipset a test $ip$x$sep$y,1023 "text $ip$x$sep$y,1023"
+    	    	echo "a test $ip$x$sep$y,1023 \"text $ip$x$sep$y,1023\""
     	    done
-    	done
+    	done | $ipset restore
     	;;
     ipportip)
     	$ipset n test hash:ip,port,ip $1 hashsize 64 comment
     	for x in `seq 0 16`; do
     	    for y in `seq 0 255`; do
-    	    	$ipset a test $ip$x$sep$y,1023,$ip2 comment "text $ip$x$sep$y,1023,$ip2"
+    	    	echo "a test $ip$x$sep$y,1023,$ip2 comment \"text $ip$x$sep$y,1023,$ip2\""
     	    done
-    	done
+    	done | $ipset restore
     	;;
     ipportnet)
     	$ipset n test hash:ip,port,net $1 hashsize 64 comment
     	for x in `seq 0 16`; do
     	    for y in `seq 0 255`; do
-    	    	$ipset a test $ip$x$sep$y,1023,$ip2/$net comment "text $ip$x$sep$y,1023,$ip2/$net"
+    	    	echo "a test $ip$x$sep$y,1023,$ip2/$net comment \"text $ip$x$sep$y,1023,$ip2/$net\""
     	    done
-    	done
+    	done | $ipset restore
     	;;
     net)
     	$ipset n test hash:net $1 hashsize 64 comment
     	for x in `seq 0 16`; do
     	    for y in `seq 0 255`; do
-    	    	$ipset a test $ip$x$sep$y/$net comment "text $ip$x$sep$y/$net"
+    	    	echo "a test $ip$x$sep$y/$net comment \"text $ip$x$sep$y/$net\""
     	    done
-    	done
+    	done | $ipset restore
     	;;
     netnet)
 	$ipset n test hash:net,net $1 hashsize 64 comment
 	for x in `seq 0 16`; do
 	    for y in `seq 0 255`; do
-		$ipset a test $ip$x$sep$y/$net,$ip$y$sep$x/$net comment "text $ip$x$sep$y/$net,$ip$y$sep$x/$net"
+		echo "a test $ip$x$sep$y/$net,$ip$y$sep$x/$net comment \"text $ip$x$sep$y/$net,$ip$y$sep$x/$net\""
 	    done
-	done
+    	done | $ipset restore
 	;;
     netport)
     	$ipset n test hash:net,port $1 hashsize 64 comment
     	for x in `seq 0 16`; do
     	    for y in `seq 0 255`; do
-    	    	$ipset a test $ip$x$sep$y/$net,1023 comment "text $ip$x$sep$y/$net,1023"
+    	    	echo "a test $ip$x$sep$y/$net,1023 comment \"text $ip$x$sep$y/$net,1023\""
     	    done
-    	done
+    	done | $ipset restore
     	;;
     netiface)
     	$ipset n test hash:net,iface $1 hashsize 64 comment
     	for x in `seq 0 16`; do
     	    for y in `seq 0 255`; do
-    	    	$ipset a test $ip$x$sep$y/$net,eth0 comment "text $ip$x$sep$y/$net,eth0"
+    	    	echo "$ipset a test $ip$x$sep$y/$net,eth0 comment \"text $ip$x$sep$y/$net,eth0\""
     	    done
-    	done
+    	done | $ipset restore
     	;;
 esac
 $ipset l test | grep ^$ip | while read x y z; do
diff --git a/tests/resizen.sh b/tests/resizen.sh
index 9322bd2a2cfce..13221f7b0894a 100755
--- a/tests/resizen.sh
+++ b/tests/resizen.sh
@@ -25,80 +25,79 @@ case "$2" in
     	$ipset n test hash:ip,port,net $1 hashsize 64
     	for x in `seq 0 16`; do
     	    for y in `seq 0 255`; do
-    	    	$ipset a test $ip$x$sep$y,1023,$ip2/$net nomatch
+    	    	echo "a test $ip$x$sep$y,1023,$ip2/$net nomatch"
     	    done
-    	done
+    	done | $ipset restore
     	for x in `seq 0 16`; do
     	    for y in `seq 0 255`; do
-    	    	$ipset t test $ip$x$sep$y,1023,$ip2/$net nomatch 2>/dev/null
+    	    	echo "t test $ip$x$sep$y,1023,$ip2/$net nomatch"
     	    done
-    	done
+    	done | $ipset restore 2>/dev/null
     	;;
     netportnet)
     	$ipset n test hash:net,port,net $1 hashsize 64
     	for x in `seq 0 16`; do
     	    for y in `seq 0 255`; do
-    	    	$ipset a test $ip$x$sep$y,1023,$ip2/$net nomatch
+    	    	echo "a test $ip$x$sep$y,1023,$ip2/$net nomatch"
     	    done
-    	done
+    	done | $ipset restore
     	for x in `seq 0 16`; do
     	    for y in `seq 0 255`; do
-    	    	$ipset t test $ip$x$sep$y,1023,$ip2/$net nomatch 2>/dev/null
+    	    	echo "t test $ip$x$sep$y,1023,$ip2/$net nomatch"
     	    done
-    	done
+    	done | $ipset restore 2>/dev/null
     	;;
     net)
     	$ipset n test hash:net $1 hashsize 64
     	for x in `seq 0 16`; do
     	    for y in `seq 0 255`; do
-    	    	$ipset a test $ip$x$sep$y/$net nomatch
+    	    	echo "a test $ip$x$sep$y/$net nomatch"
     	    done
-    	done
+    	done | $ipset restore
     	for x in `seq 0 16`; do
     	    for y in `seq 0 255`; do
-    	    	$ipset t test $ip$x$sep$y/$net nomatch 2>/dev/null
+    	    	echo "t test $ip$x$sep$y/$net nomatch"
     	    done
-    	done
+    	done | $ipset restore 2>/dev/null
     	;;
     netnet)
 	$ipset n test hash:net,net $1 hashsize 64
 	for x in `seq 0 16`; do
 	    for y in `seq 0 255`; do
-		$ipset a test $ip$x$sep$y/$net,$ip$y$sep$x/$net nomatch
+		echo "a test $ip$x$sep$y/$net,$ip$y$sep$x/$net nomatch"
 	    done
-	done
+	done | $ipset restore
 	for x in `seq 0 16`; do
 	    for y in `seq 0 255`; do
-		$ipset t test $ip$x$sep$y/$net,$ip$y$sep$x/$net nomatch \
-		2>/dev/null
+		echo "t test $ip$x$sep$y/$net,$ip$y$sep$x/$net nomatch"
 	    done
-	done
+	done | $ipset restore 2>/dev/null
 	;;
     netport)
     	$ipset n test hash:net,port $1 hashsize 64
     	for x in `seq 0 16`; do
     	    for y in `seq 0 255`; do
-    	    	$ipset a test $ip$x$sep$y/$net,1023 nomatch
+    	    	echo "a test $ip$x$sep$y/$net,1023 nomatch"
     	    done
-    	done
+    	done | $ipset restore
     	for x in `seq 0 16`; do
     	    for y in `seq 0 255`; do
-    	    	$ipset t test $ip$x$sep$y/$net,1023 nomatch 2>/dev/null
+    	    	echo "t test $ip$x$sep$y/$net,1023 nomatch"
     	    done
-    	done
+    	done | $ipset restore 2>/dev/null
     	;;
     netiface)
     	$ipset n test hash:net,iface $1 hashsize 64
     	for x in `seq 0 16`; do
     	    for y in `seq 0 255`; do
-    	    	$ipset a test $ip$x$sep$y/$net,eth0 nomatch
+    	    	echo "a test $ip$x$sep$y/$net,eth0 nomatch"
     	    done
-    	done
+    	done | $ipset restore
     	for x in `seq 0 16`; do
     	    for y in `seq 0 255`; do
-    	    	$ipset t test $ip$x$sep$y/$net,eth0 nomatch 2>/dev/null
+    	    	echo "t test $ip$x$sep$y/$net,eth0 nomatch"
     	    done
-    	done
+    	done | $ipset restore 2>/dev/null
     	;;
 esac
 $ipset x
diff --git a/tests/resizet.sh b/tests/resizet.sh
index eed4abf2bd86e..e8fdd732435ab 100755
--- a/tests/resizet.sh
+++ b/tests/resizet.sh
@@ -25,81 +25,81 @@ case "$2" in
     	$ipset n test hash:ip $1 hashsize 64 timeout 100
     	for x in `seq 0 16`; do
     	    for y in `seq 0 255`; do
-    	    	$ipset a test $ip$x$sep$y
+    	    	echo "a test $ip$x$sep$y"
     	    done
-    	done
+    	done | $ipset restore
     	;;
     ipmark)
     	$ipset n test hash:ip,mark $1 hashsize 64 timeout 100
     	for x in `seq 0 16`; do
     	    for y in `seq 0 255`; do
-    	    	$ipset a test $ip$x$sep$y,1023
+    	    	echo "a test $ip$x$sep$y,1023"
     	    done
-    	done
+    	done | $ipset restore
     	;;
     ipport)
     	$ipset n test hash:ip,port $1 hashsize 64 timeout 100
     	for x in `seq 0 16`; do
     	    for y in `seq 0 255`; do
-    	    	$ipset a test $ip$x$sep$y,1023
+    	    	echo "a test $ip$x$sep$y,1023"
     	    done
-    	done
+    	done | $ipset restore
     	;;
     ipportip)
     	$ipset n test hash:ip,port,ip $1 hashsize 64 timeout 100
     	for x in `seq 0 16`; do
     	    for y in `seq 0 255`; do
-    	    	$ipset a test $ip$x$sep$y,1023,$ip2
+    	    	echo "a test $ip$x$sep$y,1023,$ip2"
     	    done
-    	done
+    	done | $ipset restore
     	;;
     ipportnet)
     	$ipset n test hash:ip,port,net $1 hashsize 64 timeout 100
     	for x in `seq 0 16`; do
     	    for y in `seq 0 255`; do
-    	    	$ipset a test $ip$x$sep$y,1023,$ip2/$net
+    	    	echo "a test $ip$x$sep$y,1023,$ip2/$net"
     	    done
-    	done
+    	done | $ipset restore
     	;;
     netportnet)
     	$ipset n test hash:net,port,net $1 hashsize 64 timeout 100
     	for x in `seq 0 16`; do
     	    for y in `seq 0 128`; do
-    	    	$ipset a test $ip$x$sep$y/$net,1023,$ip$y$sep$x/$net
+    	    	echo "a test $ip$x$sep$y/$net,1023,$ip$y$sep$x/$net"
     	    done
-    	done
+    	done | $ipset restore
     	;;
     net)
     	$ipset n test hash:net $1 hashsize 64 timeout 100
     	for x in `seq 0 16`; do
     	    for y in `seq 0 255`; do
-    	    	$ipset a test $ip$x$sep$y/$net
+    	    	echo "a test $ip$x$sep$y/$net"
     	    done
-    	done
+    	done | $ipset restore
     	;;
     netnet)
 	$ipset n test hash:net,net $1 hashsize 64 timeout 100
 	for x in `seq 0 16`; do
 	    for y in `seq 0 255`; do
-		$ipset a test $ip$x$sep$y/$net,$ip$y$sep$x/$net
+		echo "a test $ip$x$sep$y/$net,$ip$y$sep$x/$net"
 	    done
-	done
+	done | $ipset restore
 	;;
     netport)
     	$ipset n test hash:net,port $1 hashsize 64 timeout 100
     	for x in `seq 0 16`; do
     	    for y in `seq 0 255`; do
-    	    	$ipset a test $ip$x$sep$y/$net,1023
+    	    	echo "a test $ip$x$sep$y/$net,1023"
     	    done
-    	done
+    	done | $ipset restore
     	;;
     netiface)
     	$ipset n test hash:net,iface $1 hashsize 64 timeout 100
     	for x in `seq 0 16`; do
     	    for y in `seq 0 255`; do
-    	    	$ipset a test $ip$x$sep$y/$net,eth0
+    	    	echo "a test $ip$x$sep$y/$net,eth0"
     	    done
-    	done
+    	done | $ipset restore
     	;;
 esac
 $ipset l test | grep ^$ip | while read x y z; do
diff --git a/tests/setlist_resize.sh b/tests/setlist_resize.sh
index 848f1d123b2a0..e0179d0f42788 100755
--- a/tests/setlist_resize.sh
+++ b/tests/setlist_resize.sh
@@ -18,9 +18,9 @@ done
 create() {
     n=$1
     while [ $n -le 1024 ]; do
-      $ipset c test$n hash:ip
+      echo "c test$n hash:ip"
     	n=$((n+2))
-    done
+    done | $ipset restore
 }
 
 for x in `seq 1 $loop`; do
-- 
2.43.0

