Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 988133D3D1C
	for <netfilter-devel@vger.kernel.org>; Sat,  9 May 2026 22:01:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778364087; cv=none; b=FP2skhJwlYI6lnl/PPy4spPPppI5NmcwiInCwhHcR3I0Tfh0ipKcNiChGQ7NQ1AmKWUcWtpRgOvmzCiZ8jbbztce01yNb33MQf/qu6tNtufBBf6X2Yt+QbyxHfWkz1YKKjTqWmr5rCZiF+L2hEpMRexKou0Vdv0wMpAgbzaIbxk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778364087; c=relaxed/simple;
	bh=AUB+nV9/XWGT3eKr+7UqHlx3HPmPLGTdlxbaT27IuA4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=mMPsDLFCfEHeAAkI9Uh7pj5Owva6QqdwUYGWZtJUzWKOtwuihrhTX+PVhxdBbcxpuIeVu7TUbFzcZcUD58zaWsyllWTJ692cetAYiPmy5vJuWJ2RK++DTo3p50Ldbsz03pPlnG+bT9jA5/VvZ5ONCAsS68agcihufXoXkidajmY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 447B660712; Sun, 10 May 2026 00:01:22 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH conntrack-tools] tests: cli-test.sh: improve logging for CI pipelines
Date: Sun, 10 May 2026 00:01:13 +0200
Message-ID: <20260509220117.1076896-1-fw@strlen.de>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

make logs more grep-friendly by adding FAIL/PASS
prefix to subtests.  Also make sure failing subtest has its retval
propagated.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 tests/conntrack/cli-test.sh | 54 ++++++++++++++++++-------------------
 1 file changed, 27 insertions(+), 27 deletions(-)

diff --git a/tests/conntrack/cli-test.sh b/tests/conntrack/cli-test.sh
index a0da740442dc..0b967ad53d75 100755
--- a/tests/conntrack/cli-test.sh
+++ b/tests/conntrack/cli-test.sh
@@ -10,57 +10,61 @@ DPORT=21
 ret=0
 lret=0
 
+assert() {
+	local r="$1"
+
+	if [ $r -ne 0 ]; then
+		[ "$ret" -eq 0 ] && ret="$r"
+		echo "FAIL: bulk-load-stress.sh: $@"
+	else
+		echo "PASS: bulk-load-stress.sh: $@"
+	fi
+}
+
 case $1 in
 	dump)
-		echo "Dumping conntrack table"
 		$CONNTRACK -L
-		ret=$?
+		assert $? "Dumping conntrack table"
 		;;
 	flush)
-		echo "Flushing conntrack table"
 		$CONNTRACK -F
-		ret=$?
+		assert $? "Flushing conntrack table"
 		;;
 	new)
-		echo "creating a new conntrack"
 		$CONNTRACK -I --orig-src $SRC --orig-dst $DST \
 		 --reply-src $DST --reply-dst $SRC -p tcp \
 		 --orig-port-src $SPORT  --orig-port-dst $DPORT \
 		 --reply-port-src $DPORT --reply-port-dst $SPORT \
 		--state LISTEN -u SEEN_REPLY -t 50
-		ret=$?
+		assert $? "creating a new conntrack"
 		;;
 	new-simple)
-		echo "creating a new conntrack (simplified)"
 		$CONNTRACK -I -s $SRC -d $DST \
 		-p tcp --sport $SPORT  --dport $DPORT \
 		--state LISTEN -u SEEN_REPLY -t 50
-		ret=$?
+		assert $? "creating a new conntrack (simplified)"
 		;;
 	new-nat)
-		echo "creating a new conntrack (NAT)"
 		$CONNTRACK -I -s $SRC -d $DST \
 		-p tcp --sport $SPORT  --dport $DPORT \
 		--state LISTEN -u SEEN_REPLY -t 50 --dst-nat 8.8.8.8
-		ret=$?
+		assert $? "creating a new conntrack (NAT)"
 		;;
 	get)
-		echo "getting a conntrack"
 		$CONNTRACK -G -s $SRC -d $DST \
 		-p tcp --sport $SPORT --dport $DPORT
-		ret=$?
+		assert $? "getting a conntrack"
 		;;
 	change)
-		echo "change a conntrack"
 		$CONNTRACK -U -s $SRC -d $DST \
 		-p tcp --sport $SPORT --dport $DPORT \
 		--state TIME_WAIT -u ASSURED,SEEN_REPLY -t 500
-		ret=$?
+		assert $? "change a conntrack"
 		;;
 	delete)
 		$CONNTRACK -D -s $SRC -d $DST \
 		-p tcp --sport $SPORT --dport $DPORT
-		ret=$?
+		assert $? "delete a conntrack"
 		;;
 	output)
 		proc=$(cat /proc/net/nf_conntrack | wc -l)
@@ -75,15 +79,15 @@ case $1 in
 				echo "now $proc"
 			fi
 		fi
-		ret=$?
+		assert $? "output: check proc and netlink entry count"
 		;;
 	dump-expect)
 		$CONNTRACK -L expect
-		ret=$?
+		assert $? "conntrack -L expect"
 		;;
 	flush-expect)
 		$CONNTRACK -F expect
-		ret=$?
+		assert $? "conntrack -F expect"
 		;;
 	create-expect)
 		conntrack -L
@@ -94,36 +98,32 @@ case $1 in
 		-p tcp --orig-port-src $SPORT --orig-port-dst $DPORT \
 		-t 200 --tuple-port-src 10240 --tuple-port-dst 10241\
 		--mask-port-src 10 --mask-port-dst 300
-		ret=$?
+		assert $? "create conntrack expectation"
 		;;
 	get-expect)
 		$CONNTRACK -G expect --orig-src 4.4.4.4 --orig-dst 5.5.5.5 \
 		--p tcp --orig-port-src 10240 --orig-port-dst 10241 \
 		--reply-port-src $DPORT --reply-port-dst $SPORT
-		ret=$?
+		assert $? "get conntrack expectation"
 		;;
 	delete-expect)
 		$CONNTRACK -D expect --orig-src 4.4.4.4 \
 		--orig-dst 5.5.5.5 -p tcp --orig-port-src 10240 \
 		--orig-port-dst 10241 \
 		--reply-port-src $DPORT --reply-port-dst $SPORT
-		ret=$?
+		assert $? "delete conntrack expectation"
 		;;
 	all-ns)
 		unshare -n "$0" all
-		ret=$?
+		assert $? "all-ns"
 		;;
 	all)
 		for T in new delete new-simple flush new-nat \
 			dump \
 			change output \
 			flush ; do
-			echo "Checking: $T"
 			"$0" "$T"
-			lret=$?
-
-			[ "$lret" -ne 0 ] && echo "FAIL: $T"
-			[ "$ret" -eq 0 ] && ret=$lret
+			assert $? "all: $T"
 		done
 		;;
 	*)
-- 
2.54.0

