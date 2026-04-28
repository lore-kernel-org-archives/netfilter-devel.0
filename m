Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E2AD44D022
	for <netfilter-devel@vger.kernel.org>; Tue, 28 Apr 2026 17:41:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777398114; cv=none; b=qTQfinbYhOCg952lNf+PtETg/tI6Xm4O+Rg2O0V9oH4X86oqKnIEmfXQ3UYdpPInibMm7NDU7ghSqBeWJRPWrGdh0UVCZ6Mke+leOFLNdGX4ynmZFE7OPYeW8IYGhv6C/zDr79f7sy13a7uycpMSv13WiWnFhv9Juaq6HzFJCWA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777398114; c=relaxed/simple;
	bh=8mUgn8gYZ7wybOzSRhjEXcennaKpyJGHLCbcD26Pb/M=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=TlbOsAAEACc2JHXQwPop0w+ePQMJjyE059LyhXN64ZZH8ctl0okNYw5GAFqaxNpU1cn8JZ14Z65ZlwESpGaj/P6Jeoo1N3kEfwJ0yD54OoSMpXH4Ykzp9+9zDAbPb0vPqrTDGj5WASp70NQz3sEao2Dqz5XXBn9J38aRMB8zlUs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 39F3760420; Tue, 28 Apr 2026 19:41:51 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH conntrack-tools] tests: nfct: make it suitable for CI pipeline
Date: Tue, 28 Apr 2026 19:41:26 +0200
Message-ID: <20260428174130.14287-1-fw@strlen.de>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

1. make run-test.sh call test prog via unshare -n.
2. remove various modprobe calls, these are all built into
   nf_conntrack.ko.
3. make test.c exit nonzero when bad tests are detected.
4. remove dccp+udplite, they fail on modern kernels due to removal of
   these protocols.
5. update test-live.sh.  Auto-rexec via unshare. Streamline output:

Check timeout policy test-generic for protocol 13
    [NEW] unknown  13 3 src=10.0.0.1 dst=8.8.8.8 [UNREPLIED] src=8.8.8.8 dst=10.0.0.1
Check timeout policy test-tcp for protocol tcp
    [NEW] tcp      6 2 SYN_SENT src=10.0.0.1 dst=8.8.8.8 sport=5050 dport=80 [UNREPLIED] src=8.8.8.8 dst=10.0.0.1 sport=80 dport=5050
Check timeout policy test-icmp for protocol icmp
    [NEW] icmp     1 4 src=10.0.0.1 dst=8.8.8.8 type=8 code=0 id=41473 [UNREPLIED] src=8.8.8.8 dst=10.0.0.1 type=0 code=0 id=41473

The effective timeout is validated by checking the new timeout reported
via ctnetlink.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 tests/nfct/run-test.sh       |  15 +----
 tests/nfct/test-live.sh      | 125 +++++++++++++++++++++++------------
 tests/nfct/test.c            |   4 ++
 tests/nfct/timeout/03udplite |  16 -----
 tests/nfct/timeout/07dccp    |  16 -----
 5 files changed, 89 insertions(+), 87 deletions(-)
 mode change 100644 => 100755 tests/nfct/run-test.sh
 mode change 100644 => 100755 tests/nfct/test-live.sh
 delete mode 100644 tests/nfct/timeout/03udplite
 delete mode 100644 tests/nfct/timeout/07dccp

diff --git a/tests/nfct/run-test.sh b/tests/nfct/run-test.sh
old mode 100644
new mode 100755
index f5f220baebf1..88999f8c8517
--- a/tests/nfct/run-test.sh
+++ b/tests/nfct/run-test.sh
@@ -7,16 +7,5 @@ then
 	exit 1
 fi
 
-gcc test.c -o test
-#
-# XXX: module auto-load not support by nfnetlink_cttimeout yet :-(
-#
-# any or all of these might be built-ins rather than modules, so don't error
-# out on failure from modprobe
-modprobe nf_conntrack_ipv4 || true
-modprobe nf_conntrack_ipv6 || true
-modprobe nf_conntrack_proto_udplite || true
-modprobe nf_conntrack_proto_sctp || true
-modprobe nf_conntrack_proto_dccp || true
-modprobe nf_conntrack_proto_gre || true
-./test timeout
+test -x test || gcc test.c -o test
+exec unshare -n ./test timeout
diff --git a/tests/nfct/test-live.sh b/tests/nfct/test-live.sh
old mode 100644
new mode 100755
index 22570875f4e6..6f752ee61f59
--- a/tests/nfct/test-live.sh
+++ b/tests/nfct/test-live.sh
@@ -3,71 +3,112 @@
 # simple testing for cttimeout infrastructure using one single computer
 #
 
-WAIT_BETWEEN_TESTS=10
-
-# flush cttimeout table
-nfct flush timeout
-
-# flush the conntrack table
-conntrack -F
+if [ "$1" != "run" ] ;then
+	exec unshare -n ./$0 "run"
+fi
+
+die() {
+	echo "$@"
+	exit 1
+}
+
+warn() {
+	echo "WARN: $@"
+}
+
+tmp=$(mktemp)
+cleanup()
+{
+	ip link del eth0
+	rm -f "$tmp"
+}
+trap cleanup EXIT
+
+ret=0
+check_timeout() {
+	local proto="$1"
+	local timeout="$2"
+
+	if ! grep '[NEW]' "$tmp" | grep "$proto $timeout";then
+		warn "Did not find expected output, got:"
+		cat "$tmp"
+		echo ----- EOF -----
+		ret=1
+	fi
+}
+
+add_rule() {
+	local proto="$1"
+	local name="$2"
+
+	echo "Check timeout policy $name for protocol $proto"
+	iptables -I OUTPUT -t raw -p "$proto" -j CT --timeout "$name" || die "can't add -p $proto -j CT $name"
+}
+
+rm_rules() {
+	local proto="$1"
+	local name="$2"
+
+	iptables -D OUTPUT -t raw -p $proto -j CT --timeout "$name" || warn "can't remove $proto $name rule"
+	nfct del timeout "$name" || warn "can't remove $name policy"
+}
+
+ip link add eth0 type dummy
+ip link set eth0 up
+ip link set lo up
+ip addr add 10.0.0.1/8 dev eth0
+ip route add default via 10.0.0.99 dev eth0
+
+WAIT_BETWEEN_TESTS=5
 
 #
 # No.1: test generic timeout policy
 #
+conntrack -E -p 13 > "$tmp" 2>/dev/null &
+pid=$!
 
-echo "---- test no. 1 ----"
-
-conntrack -E -p 13 &
-
-nfct add timeout test-generic inet generic timeout 100
-iptables -I OUTPUT -t raw -p all -j CT --timeout test-generic
-hping3 -c 1 -V -I eth0 -0 8.8.8.8 -H 13
-
-killall -15 conntrack
-
-echo "---- end test no. 1 ----"
+nfct add timeout "test-generic" inet generic timeout 3 || die "can't add generic timeout"
+add_rule 13 "test-generic"
+hping3 -c 1 -I eth0 -0 8.8.8.8 -H 13 > /dev/null 2>&1
+check_timeout 13 3
+kill $pid
 
 sleep $WAIT_BETWEEN_TESTS
-
-iptables -D OUTPUT -t raw -p all -j CT --timeout test-generic
-nfct del timeout test-generic
+rm_rules 13 "test-generic"
 
 #
 # No.2: test TCP timeout policy
 #
 
-echo "---- test no. 2 ----"
+conntrack -E -p tcp > "$tmp" 2>/dev/null &
+pid=$!
 
-conntrack -E -p tcp &
+nfct add timeout test-tcp inet tcp syn_sent 2 || die "can't add tcp timeout policy"
+add_rule "tcp" "test-tcp"
+hping3 -S -p 80 -s 5050 8.8.8.8 -c 1 > /dev/null 2>&1
 
-nfct add timeout test-tcp inet tcp syn_sent 100
-iptables -I OUTPUT -t raw -p tcp -j CT --timeout test-tcp
-hping3 -V -S -p 80 -s 5050 8.8.8.8 -c 1
+check_timeout 6 2
+kill $pid
 
 sleep $WAIT_BETWEEN_TESTS
-
-iptables -D OUTPUT -t raw -p tcp -j CT --timeout test-tcp
-nfct del timeout test-tcp
-
-killall -15 conntrack
-
-echo "---- end test no. 2 ----"
+rm_rules "tcp" "test-tcp"
 
 #
 # No. 3: test ICMP timeout policy
 #
 
-echo "---- test no. 3 ----"
+conntrack -E -p icmp > "$tmp" 2>/dev/null &
+pid=$!
 
-conntrack -E -p icmp &
+nfct add timeout test-icmp inet icmp timeout 4 || die "can't add test-icmp policy"
+add_rule "icmp" "test-icmp"
 
-nfct add timeout test-icmp inet icmp timeout 50
-iptables -I OUTPUT -t raw -p icmp -j CT --timeout test-icmp
-hping3 -1 8.8.8.8 -c 2
+hping3 -1 8.8.8.8 -c 2 > /dev/null 2>&1
 
-iptables -D OUTPUT -t raw -p icmp -j CT --timeout test-icmp
-nfct del timeout test-icmp
+check_timeout 1 4
+kill "$pid"
 
-killall -15 conntrack
+sleep $WAIT_BETWEEN_TESTS
+rm_rules "icmp" "test-icmp"
 
-echo "---- end test no. 3 ----"
+exit $ret
diff --git a/tests/nfct/test.c b/tests/nfct/test.c
index a833dcc9e99b..bce927829190 100644
--- a/tests/nfct/test.c
+++ b/tests/nfct/test.c
@@ -97,4 +97,8 @@ int main(int argc, char *argv[])
 	closedir(d);
 
 	fprintf(stdout, "OK: %d BAD: %d\n", ok, bad);
+	if (bad)
+		return 1;
+
+	return ok > 0 ? 0 : 1;
 }
diff --git a/tests/nfct/timeout/03udplite b/tests/nfct/timeout/03udplite
deleted file mode 100644
index 8ed345901651..000000000000
--- a/tests/nfct/timeout/03udplite
+++ /dev/null
@@ -1,16 +0,0 @@
-# add policy object `test'
-nfct add timeout test inet udplite unreplied 10 ; OK
-# get policy object `test'
-nfct get timeout test ; OK
-# delete policy object `test'
-nfct delete timeout test ; OK
-# get unexistent policy object `dummy'
-nfct get timeout test ; BAD
-# delete policy object `test', however, it does not exists anymore
-nfct delete timeout test ; BAD
-# add policy object `test'
-nfct add timeout test inet udplite unreplied 1 replied 2 ; OK
-# get policy object `test'
-nfct get timeout test ; OK
-# delete policy object `test'
-nfct delete timeout test ; OK
diff --git a/tests/nfct/timeout/07dccp b/tests/nfct/timeout/07dccp
deleted file mode 100644
index 1d885853f577..000000000000
--- a/tests/nfct/timeout/07dccp
+++ /dev/null
@@ -1,16 +0,0 @@
-# add policy object `test'
-nfct add timeout test inet dccp request 100 ; OK
-# get policy object `test'
-nfct get timeout test ; OK
-# delete policy object `test'
-nfct delete timeout test ; OK
-# get unexistent policy object `dummy'
-nfct get timeout test ; BAD
-# delete policy object `test', however, it does not exists anymore
-nfct delete timeout test ; BAD
-# add policy object `test'
-nfct add timeout test inet dccp request 1 respond 2 partopen 3 open 4 closereq 5 closing 6 timewait 7 ; OK
-# get policy object `test'
-nfct get timeout test ; OK
-# delete policy object `test'
-nfct delete timeout test ; OK
-- 
2.53.0

