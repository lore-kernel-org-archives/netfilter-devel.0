Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D253429E116
	for <netfilter-devel@vger.kernel.org>; Thu,  9 Jul 2026 20:04:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783627474; cv=none; b=CPCAG7J6ZixuUlAdmtt0wouGhVBqKNDyWqkAwa5VKQVzqTxc/KF64Ntpmlt9jBnDlrNxWqn3mq8c1LPGBxZyavMzKI0/2RGFqrZKkgTQsv/VorWzTS7AB1YiEjtc8x18UXp7MkOREr7/2eTOg+pNapuyKaD3hmBFjxTnj3fBM+E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783627474; c=relaxed/simple;
	bh=VXND2wIDGCEyyM6ubFN5hepJI+iq8bI1UXE8G5Ez6SM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eHoZsFKHlmdndeqJdveoGqHbqwSZGIwZABhhAS98dtjuw6q4Gdd7j8If9SAEdmS9uLH0F8ZzCr/YtVE0lzaLPrhk3g2FDDoKB+uplw7cONMMbDa1v79eJALGLff3JkJBQbK5qOHcYKLFmeN/Tdg/AS38lGtl5nJukLpIXDr+9g0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 45D8F602A9; Thu, 09 Jul 2026 22:04:31 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: kadlec@netfilter.org,
	Florian Westphal <fw@strlen.de>
Subject: [PATCH ipset 6/7] tests: make setlist_resize.sh more verbose on error
Date: Thu,  9 Jul 2026 22:03:57 +0200
Message-ID: <20260709200358.15504-7-fw@strlen.de>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260709200358.15504-1-fw@strlen.de>
References: <20260709200358.15504-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Instead of just existing, tell where we failed.
Use -x and take advantage of $IPSET_TMP to capture the
full output.

On success, remove the file.
cleanup handler will dump the content in case we failed somewhere.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 tests/setlist_resize.sh | 34 ++++++++++++++++++++++++++++------
 1 file changed, 28 insertions(+), 6 deletions(-)

diff --git a/tests/setlist_resize.sh b/tests/setlist_resize.sh
index db347ca06517..393048adac38 100755
--- a/tests/setlist_resize.sh
+++ b/tests/setlist_resize.sh
@@ -1,22 +1,41 @@
 #!/bin/sh
 
 set -e
-# set -x
-# exec > setlist.res
-# exec 2>&1
+
+cleanup() {
+	exec 1>&3
+	exec 2>&4
+	if [ -r "$IPSET_TMP/setlist.res" ]; then
+		cat "$IPSET_TMP/setlist.res"
+		rm -f "$IPSET_TMP/setlist.res"
+	fi
+}
+trap cleanup EXIT
+
+exec 3>&1
+exec 4>&2
+exec > "$IPSET_TMP/setlist.res" 2>&1
+
+set -x
 
 ipset=${IPSET_BIN:-../src/ipset}
 
 loop=8
 
+fail() {
+	echo "FAILED: $0 $@"
+	exit 1
+}
+
 n=0
 while [ $n -le 9 ]; do
     egrep '^(ip_set_|xt_set)' /proc/modules | while read x y; do
-    	rmmod $x >/dev/null 2>&1
+    	rmmod $x || :
     done
     if [ "`egrep '^(ip_set_|xt_set)' /proc/modules`" ]; then
     	sleep 1s
     else
+    	echo "Modules unloaded after $n attempts."
     	n=10
     fi
 done
@@ -35,7 +54,7 @@ for x in `seq 1 $loop`; do
     create 1 &
     create 2 &
     wait
-    test `$ipset l -n | wc -l` -eq 1024 || exit 1
+    test `$ipset l -n | wc -l` -eq 1024 || fail "expected 1024 sets"
     $ipset x
     # Wait for destroy to be finished and reference counts releases
     n=0
@@ -53,7 +72,10 @@ for x in `seq 1 $loop`; do
     	lsmod
     	echo $ref
     fi
-    test "$ref" -eq 0 || exit 1
+    test "$ref" -eq 0 || fail "ref was $ref"
     rmmod ip_set_hash_ip >/dev/null 2>&1
     rmmod ip_set >/dev/null 2>&1
 done
+
+rm -f "$IPSET_TMP/setlist.res"
+cleanup
-- 
2.54.0

