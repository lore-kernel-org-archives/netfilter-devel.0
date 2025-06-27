Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7932C2E266E
	for <netfilter-devel@vger.kernel.org>; Fri, 27 Jun 2025 14:28:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751034496; cv=none; b=GmWQ1gsDf3rRBkJ89gEjrqHQYUmTD2qdSlQf0SylBO1kCThIhHxK0Spm/49bepPjR/LM+U7aq/XIF99PhayRgUXkqkMm4ZHb9knMgkUZFHnLd2k0m7FumqVj9LO7TVLyaAngYZuP5dSKQ9BshRgY0qHhJ1Km4iJeRjxjap+qVFk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751034496; c=relaxed/simple;
	bh=p1dhIdPeGMl0O29nIojKYVINVjWX//+6P/1C/cZ706c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QI80pZQAenZtj8RI9cWBOpNuepf3H5INS+g/nVPVAa/7MaFyPAKxX0ceCC89Y5wDYL7xvyscmsjT4bFBQsbbeOLP10wcAR7W1zTrLA7STtT4S6VQ43vJkkCUDUnBxNuvTh8iZUCpyEI9e4hhdLd6M6K053UgAAZLGEBfKgO1Csc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 61E71608B7; Fri, 27 Jun 2025 16:28:12 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf 1/4] selftests: netfilter: conntrack_resize.sh: extend resize test
Date: Fri, 27 Jun 2025 16:27:50 +0200
Message-ID: <20250627142758.25664-2-fw@strlen.de>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250627142758.25664-1-fw@strlen.de>
References: <20250627142758.25664-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Extend the resize test:
 - continuously dump table both via /proc and ctnetlink interfaces while
   table is resized in a loop.
 - if socat is available, send udp packets in additon to ping requests.
 - increase/decrease the icmp and udp timeouts while resizes are happening.
   This makes sure we also exercise the 'ct has expired' check that happens
   on conntrack lookup.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 .../net/netfilter/conntrack_resize.sh         | 80 +++++++++++++++++--
 1 file changed, 75 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/net/netfilter/conntrack_resize.sh b/tools/testing/selftests/net/netfilter/conntrack_resize.sh
index 9e033e80219e..aa1ba07eaf50 100755
--- a/tools/testing/selftests/net/netfilter/conntrack_resize.sh
+++ b/tools/testing/selftests/net/netfilter/conntrack_resize.sh
@@ -12,6 +12,9 @@ tmpfile=""
 tmpfile_proc=""
 tmpfile_uniq=""
 ret=0
+have_socat=0
+
+socat -h > /dev/null && have_socat=1
 
 insert_count=2000
 [ "$KSFT_MACHINE_SLOW" = "yes" ] && insert_count=400
@@ -123,7 +126,7 @@ ctflush() {
         done
 }
 
-ctflood()
+ct_pingflood()
 {
 	local ns="$1"
 	local duration="$2"
@@ -152,6 +155,28 @@ ctflood()
 	wait
 }
 
+ct_udpflood()
+{
+	local ns="$1"
+	local duration="$2"
+	local now=$(date +%s)
+	local end=$((now + duration))
+
+	[ $have_socat -ne "1" ] && return
+
+        while [ $now -lt $end ]; do
+ip netns exec "$ns" bash<<"EOF"
+	for i in $(seq 1 100);do
+		dport=$(((RANDOM%65536)+1))
+
+		echo bar | socat -u STDIN UDP:"127.0.0.1:$dport" &
+	done > /dev/null 2>&1
+	wait
+EOF
+		now=$(date +%s)
+	done
+}
+
 # dump to /dev/null.  We don't want dumps to cause infinite loops
 # or use-after-free even when conntrack table is altered while dumps
 # are in progress.
@@ -169,6 +194,48 @@ ct_nulldump()
 	wait
 }
 
+ct_nulldump_loop()
+{
+	local ns="$1"
+	local duration="$2"
+	local now=$(date +%s)
+	local end=$((now + duration))
+
+        while [ $now -lt $end ]; do
+		ct_nulldump "$ns"
+		sleep $((RANDOM%2))
+		now=$(date +%s)
+	done
+}
+
+change_timeouts()
+{
+	local ns="$1"
+	local r1=$((RANDOM%2))
+	local r2=$((RANDOM%2))
+
+	[ "$r1" -eq 1 ] && ip netns exec "$ns" sysctl -q net.netfilter.nf_conntrack_icmp_timeout=$((RANDOM%5))
+	[ "$r2" -eq 1 ] && ip netns exec "$ns" sysctl -q net.netfilter.nf_conntrack_udp_timeout=$((RANDOM%5))
+}
+
+ct_change_timeouts_loop()
+{
+	local ns="$1"
+	local duration="$2"
+	local now=$(date +%s)
+	local end=$((now + duration))
+
+        while [ $now -lt $end ]; do
+		change_timeouts "$ns"
+		sleep $((RANDOM%2))
+		now=$(date +%s)
+	done
+
+	# restore defaults
+	ip netns exec "$ns" sysctl -q net.netfilter.nf_conntrack_icmp_timeout=30
+	ip netns exec "$ns" sysctl -q net.netfilter.nf_conntrack_udp_timeout=30
+}
+
 check_taint()
 {
 	local tainted_then="$1"
@@ -198,10 +265,13 @@ insert_flood()
 
 	r=$((RANDOM%$insert_count))
 
-	ctflood "$n" "$timeout" "floodresize" &
+	ct_pingflood "$n" "$timeout" "floodresize" &
+	ct_udpflood "$n" "$timeout" &
+
 	insert_ctnetlink "$n" "$r" &
 	ctflush "$n" "$timeout" &
-	ct_nulldump "$n" &
+	ct_nulldump_loop "$n" "$timeout" &
+	ct_change_timeouts_loop "$n" "$timeout" &
 
 	wait
 }
@@ -306,7 +376,7 @@ test_dump_all()
 
 	ip netns exec "$nsclient1" sysctl -q net.netfilter.nf_conntrack_icmp_timeout=3600
 
-	ctflood "$nsclient1" $timeout "dumpall" &
+	ct_pingflood "$nsclient1" $timeout "dumpall" &
 	insert_ctnetlink "$nsclient2" $insert_count
 
 	wait
@@ -368,7 +438,7 @@ test_conntrack_disable()
 	ct_flush_once "$nsclient1"
 	ct_flush_once "$nsclient2"
 
-	ctflood "$nsclient1" "$timeout" "conntrack disable"
+	ct_pingflood "$nsclient1" "$timeout" "conntrack disable"
 	ip netns exec "$nsclient2" ping -q -c 1 127.0.0.1 >/dev/null 2>&1
 
 	# Disabled, should not have picked up any connection.
-- 
2.49.0

