Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED7362144CF;
	Wed,  7 May 2025 07:50:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746604223; cv=none; b=IbXe1vg4U7TMy9PIXqIujUj0wrRwV1sM+V6G2NRWAOx9cmaNyr9p1jmpjBtaDOGxlpo1KoluqvVfCqkfYVb+Ap/2vlnuxGN5lwN4J5YwP4jcUka2eUNKv8XMiZe1Lfzka1AiB57OW6UQqPaq4JL+AIQkqUPCERVYxh5cI9RgT28=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746604223; c=relaxed/simple;
	bh=k9WN5C6c0MSo4vv8176fjyELkFhQfKNM6dkz0aqATrY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=RzT3PRX0Yfjq4fPXnlf8Pochc4dYG3mJRl3YPSMD2T0UlDBhpkcR7Ncy0E81+5RZmGNuVKq0yL5kIbdWG9tJQ94sQMdv6ClZM07Jgix44VVGOc6p/9TQG5vgvQtYZW8bdcl/MJccmC8IW5pU6UsKAbzGAbSubw2giW4x7ZQGfrc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1uCZXm-0001Ja-Oa; Wed, 07 May 2025 09:50:18 +0200
From: Florian Westphal <fw@strlen.de>
To: <netdev@vger.kernel.org>
Cc: netfilter-devel <netfilter-devel@vger.kernel.org>,
	Florian Westphal <fw@strlen.de>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next] selftests: netfilter: fix conntrack stress test failures on debug kernels
Date: Wed,  7 May 2025 09:49:55 +0200
Message-ID: <20250507075000.5819-1-fw@strlen.de>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Jakub reports test failures on debug kernel:
FAIL: proc inconsistency after uniq filter for ...

This is because entries are expiring while validation is happening.

Increase the timeout of ctnetlink injected entries and the
icmp (ping) timeout to 1h to avoid this.

To reduce run-time, add less entries via ctnetlink when KSFT_MACHINE_SLOW
is set.

also log of a failed run had:
 PASS: dump in netns had same entry count (-C 0, -L 0, -p 0, /proc 0)

... i.e. all entries already expired: add a check and set failure if
this happens.

While at it, include a diff when there were duplicate entries and add
netns name to error messages (it tells if icmp or ctnetlink failed).

Fixes: d33f889fd80c ("selftests: netfilter: add conntrack stress test")
Reported-by: Jakub Kicinski <kuba@kernel.org>
Closes: https://lore.kernel.org/netdev/20250506061125.1a244d12@kernel.org/
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 .../net/netfilter/conntrack_resize.sh         | 63 ++++++++++++-------
 1 file changed, 42 insertions(+), 21 deletions(-)

diff --git a/tools/testing/selftests/net/netfilter/conntrack_resize.sh b/tools/testing/selftests/net/netfilter/conntrack_resize.sh
index aabc7c51181e..9e033e80219e 100755
--- a/tools/testing/selftests/net/netfilter/conntrack_resize.sh
+++ b/tools/testing/selftests/net/netfilter/conntrack_resize.sh
@@ -9,8 +9,13 @@ checktool "nft --version" "run test without nft tool"
 init_net_max=0
 ct_buckets=0
 tmpfile=""
+tmpfile_proc=""
+tmpfile_uniq=""
 ret=0
 
+insert_count=2000
+[ "$KSFT_MACHINE_SLOW" = "yes" ] && insert_count=400
+
 modprobe -q nf_conntrack
 if ! sysctl -q net.netfilter.nf_conntrack_max >/dev/null;then
 	echo "SKIP: conntrack sysctls not available"
@@ -23,7 +28,7 @@ ct_buckets=$(sysctl -n net.netfilter.nf_conntrack_buckets) || exit 1
 cleanup() {
 	cleanup_all_ns
 
-	rm -f "$tmpfile"
+	rm -f "$tmpfile" "$tmpfile_proc" "$tmpfile_uniq"
 
 	# restore original sysctl setting
 	sysctl -q net.netfilter.nf_conntrack_max=$init_net_max
@@ -54,7 +59,7 @@ insert_ctnetlink() {
 		ip netns exec "$ns" bash -c "for i in \$(seq 1 $bulk); do \
 			if ! conntrack -I -s \$((\$RANDOM%256)).\$((\$RANDOM%256)).\$((\$RANDOM%256)).\$((\$RANDOM%255+1)) \
 					  -d \$((\$RANDOM%256)).\$((\$RANDOM%256)).\$((\$RANDOM%256)).\$((\$RANDOM%255+1)) \
-					  --protonum 17 --timeout 120 --status ASSURED,SEEN_REPLY --sport \$RANDOM --dport 53; then \
+					  --protonum 17 --timeout 3600 --status ASSURED,SEEN_REPLY --sport \$RANDOM --dport 53; then \
 					  return;\
 			fi & \
 		done ; wait" 2>/dev/null
@@ -191,7 +196,7 @@ insert_flood()
 	local n="$1"
 	local r=0
 
-	r=$((RANDOM%2000))
+	r=$((RANDOM%$insert_count))
 
 	ctflood "$n" "$timeout" "floodresize" &
 	insert_ctnetlink "$n" "$r" &
@@ -232,49 +237,61 @@ check_dump()
 	local proto=0
 	local proc=0
 	local unique=""
-
-	c=$(ip netns exec "$ns" conntrack -C)
+	local lret=0
 
 	# NOTE: assumes timeouts are large enough to not have
 	# expirations in all following tests.
-	l=$(ip netns exec "$ns" conntrack -L 2>/dev/null | tee "$tmpfile" | wc -l)
+	l=$(ip netns exec "$ns" conntrack -L 2>/dev/null | sort | tee "$tmpfile" | wc -l)
+	c=$(ip netns exec "$ns" conntrack -C)
+
+	if [ "$c" -eq 0 ]; then
+		echo "FAIL: conntrack count for $ns is 0"
+		lret=1
+	fi
 
 	if [ "$c" -ne "$l" ]; then
-		echo "FAIL: count inconsistency for $ns: $c != $l"
-		ret=1
+		echo "FAIL: conntrack count inconsistency for $ns -L: $c != $l"
+		lret=1
 	fi
 
 	# check the dump we retrieved is free of duplicated entries.
-	unique=$(sort "$tmpfile" | uniq | wc -l)
+	unique=$(uniq "$tmpfile" | tee "$tmpfile_uniq" | wc -l)
 	if [ "$l" -ne "$unique" ]; then
-		echo "FAIL: count identical but listing contained redundant entries: $l != $unique"
-		ret=1
+		echo "FAIL: listing contained redundant entries for $ns: $l != $unique"
+		diff -u "$tmpfile" "$tmpfile_uniq"
+		lret=1
 	fi
 
 	# we either inserted icmp or only udp, hence, --proto should return same entry count as without filter.
-	proto=$(ip netns exec "$ns" conntrack -L --proto $protoname 2>/dev/null | wc -l)
+	proto=$(ip netns exec "$ns" conntrack -L --proto $protoname 2>/dev/null | sort | uniq | tee "$tmpfile_uniq" | wc -l)
 	if [ "$l" -ne "$proto" ]; then
-		echo "FAIL: dump inconsistency for $ns: $l != $proto"
-		ret=1
+		echo "FAIL: dump inconsistency for $ns -L --proto $protoname: $l != $proto"
+		diff -u "$tmpfile" "$tmpfile_uniq"
+		lret=1
 	fi
 
 	if [ -r /proc/self/net/nf_conntrack ] ; then
-		proc=$(ip netns exec "$ns" bash -c "wc -l < /proc/self/net/nf_conntrack")
+		proc=$(ip netns exec "$ns" bash -c "sort < /proc/self/net/nf_conntrack | tee \"$tmpfile_proc\" | wc -l")
 
 		if [ "$l" -ne "$proc" ]; then
 			echo "FAIL: proc inconsistency for $ns: $l != $proc"
-			ret=1
+			lret=1
 		fi
 
-		proc=$(ip netns exec "$ns" bash -c "sort < /proc/self/net/nf_conntrack | uniq | wc -l")
-
+		proc=$(uniq "$tmpfile_proc" | tee "$tmpfile_uniq" | wc -l)
 		if [ "$l" -ne "$proc" ]; then
 			echo "FAIL: proc inconsistency after uniq filter for $ns: $l != $proc"
-			ret=1
+			diff -u "$tmpfile_proc" "$tmpfile_uniq"
+			lret=1
 		fi
 	fi
 
-	echo "PASS: dump in netns had same entry count (-C $c, -L $l, -p $proto, /proc $proc)"
+	if [ $lret -eq 0 ];then
+		echo "PASS: dump in netns $ns had same entry count (-C $c, -L $l, -p $proto, /proc $proc)"
+	else
+		echo "FAIL: dump in netns $ns had different entry count (-C $c, -L $l, -p $proto, /proc $proc)"
+		ret=1
+	fi
 }
 
 test_dump_all()
@@ -287,8 +304,10 @@ test_dump_all()
 	ct_flush_once "$nsclient1"
 	ct_flush_once "$nsclient2"
 
+	ip netns exec "$nsclient1" sysctl -q net.netfilter.nf_conntrack_icmp_timeout=3600
+
 	ctflood "$nsclient1" $timeout "dumpall" &
-	insert_ctnetlink "$nsclient2" 2000
+	insert_ctnetlink "$nsclient2" $insert_count
 
 	wait
 
@@ -398,6 +417,8 @@ EOF
 done
 
 tmpfile=$(mktemp)
+tmpfile_proc=$(mktemp)
+tmpfile_uniq=$(mktemp)
 test_conntrack_max_limit
 test_dump_all
 test_floodresize_all
-- 
2.49.0

