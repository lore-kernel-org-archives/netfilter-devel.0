Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.216.245.30
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794931164;
	b=pdvorAU0VZMspLVTNh3+N6/cauE9x3GxSj1PgOuuiPKBgsFOT+gSI1lJQ7XqQ53/Y0S2
	 6Dc0vJaX0DsCbkenl4j2ZxRH/Ua2p85J0m+Vn+dLv1dwlgg3dJL195+47zJEYG91HJsXt
	 jv1OD0c0/RWoevZocj2cWmpHUdPwea4YQmKOcX3HgKBDvGaaxGQ7nBGr7Wt2tPb6fI5M/
	 MIl4KACtrSxkI2SyuSUs0IwNblgdSKOXNbJG4IYLJE8tZg1cSrr2nTLWgWALKO9GCZFZW
	 tbVeGmq189Xc/agglLgIA/Cb4a5iM7gnQhoGOR591gFUfDRozlyrv5B6bV4PSF3T0DA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794931164;
	h=DMARC-Filter:Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=oLMlAhVT/Ku6NAXQGVYFQ04OYBY4qSQw/93fDsA9lZI=;
	b=LqltGYoHwXNYLxZZVnJ98vRh/n1AN+cBBJ0siv92j4yWoraDwMhQ+W4Fy9goKLl1oLPv
	 ONksJjFjfAk0ohtq1cbb4UStHecU200U6gMOqHaqUAPTrY7su8EXvLlCVFlqBl7nfniOm
	 Kc2T0j37Jpc93Do9q8cbxpa62KZdwHRZtir1MxCqRFmi+jBv/uR4Tcg/7JpD59wki1VCa
	 +xYllgUcjS8irG3EnCyOEsE2WrkC/y5R/683upRFGgDBCliGccmivComH6zvsZG7QQCd4
	 8ak+gGQbY3kbs/bNXiPwuk1Om58ZD9X9FHR5t4zwsaUW7d3j/OjSjaCMpxZfQyi2CZg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=strlen.de;
	spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc;
	arc=none smtp.remote-ip=91.216.245.30
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2021C606A334
	for <netfilter-devel@vger.kernel.org>; Tue, 17 Nov 2026 15:59:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2021C606A334
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 8DD8160342; Tue, 17 Nov 2026 16:59:21 +0100 (CET)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH libnetfilter_log 2/2] tests: add shell test framework covering nfulnl hook/family hwheader logic
Date: Tue, 17 Nov 2026 16:59:00 +0100
Message-ID: <20261117155900.31418-3-fw@strlen.de>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261117155900.31418-1-fw@strlen.de>
References: <20261117155900.31418-1-fw@strlen.de>
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

utils/nfulnl_test.sh was a single monolithic script covering one hook
(prerouting) on loopback only.

Add a small nftables-style shell test instead.

tests/shell/run-tests.sh discovers and runs executable scripts under
tests/shell/testcases/, each a self-contained test exiting 0 (pass),
77 (skip) or non-zero (fail).

tests/shell/lib.sh holds the common
nfulnl_test-capture/cleanup helpers. Every test runs inside its own
`unshare -n` network namespace.

Testcases added:
 - 0001-prerouting-loopback: baseline, port of the old script, now
   also asserting the HWTYPE/HWLEN/HWHEADER triplet
 - 0002-output-no-hwheader: hwheader must be absent past LOCAL_OUT
 - 0003-forward-hwheader: hwheader present at NF_INET_FORWARD
 - 0004-netdev-ingress-hwheader: NFPROTO_NETDEV ingress hook
 - 0005-arp-hwheader: NFPROTO_ARP, NF_ARP_IN, NF_ARP_OUT
 - 0006-bridge-forward-indev: the actual regression test - bridges
   two netns together and asserts indev/hw_addr in the log follow the
   real ingress port per direction at NF_BR_FORWARD, not whatever
   skb->dev was last repointed to

Not wired into "make check": testcases need root (netns,
nft).

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 tests/shell/lib.sh                            | 140 ++++++++++++++++++
 tests/shell/run-tests.sh                      |  66 +++++++++
 .../testcases/nfulnl/0001-prerouting-loopback |  36 +++++
 .../testcases/nfulnl/0002-output-no-hwheader  |  43 ++++++
 .../testcases/nfulnl/0003-forward-hwheader    |  74 +++++++++
 .../nfulnl/0004-netdev-ingress-hwheader       |  29 ++++
 .../shell/testcases/nfulnl/0005-arp-hwheader  |  69 +++++++++
 .../nfulnl/0006-bridge-forward-indev          |  88 +++++++++++
 8 files changed, 545 insertions(+)
 create mode 100644 tests/shell/lib.sh
 create mode 100755 tests/shell/run-tests.sh
 create mode 100755 tests/shell/testcases/nfulnl/0001-prerouting-loopback
 create mode 100755 tests/shell/testcases/nfulnl/0002-output-no-hwheader
 create mode 100755 tests/shell/testcases/nfulnl/0003-forward-hwheader
 create mode 100755 tests/shell/testcases/nfulnl/0004-netdev-ingress-hwheader
 create mode 100755 tests/shell/testcases/nfulnl/0005-arp-hwheader
 create mode 100755 tests/shell/testcases/nfulnl/0006-bridge-forward-indev

diff --git a/tests/shell/lib.sh b/tests/shell/lib.sh
new file mode 100644
index 000000000000..28995c24f421
--- /dev/null
+++ b/tests/shell/lib.sh
@@ -0,0 +1,140 @@
+# Common helpers sourced by testcases/nfulnl/*.
+#
+# A testcase is expected to:
+#   source "$(dirname "$0")/../../lib.sh"
+#   trap nfulnl_cleanup EXIT	# extend, don't replace, if the testcase has
+#				# its own cleanup (netns teardown etc.)
+#   nfulnl_capture [netns]
+#   ... generate traffic, use nft log group 0 ...
+#   nfulnl_wait
+# and then grep/assert on $NFULNL_OUT.
+#
+# nfulnl_test(1) always binds group 0 (and 100), so every nft ruleset in
+# these testcases must use "log group 0".
+
+SKIP_RC=77
+NFULNL_TEST_NAME="${0##*/}"
+
+# Make sure a failure inside a helper function (nfulnl_capture, nfulnl_wait,
+# ...) still runs the ERR trap below, and print a command trace when
+# NFULNL_TEST_VERBOSE is set, so a standalone run gives more to go on than a
+# bare exit code.
+set -E
+[ -n "${NFULNL_TEST_VERBOSE:-}" ] && set -x
+
+# Locate the nfulnl_test helper binary built under utils/.
+: "${NFULNL_TEST_BIN:=}"
+if [ -z "$NFULNL_TEST_BIN" ]; then
+	for candidate in \
+		"$(dirname "$0")/../../../../utils/nfulnl_test" \
+		"$(pwd)/utils/nfulnl_test"; do
+		if [ -x "$candidate" ]; then
+			NFULNL_TEST_BIN="$candidate"
+			break
+		fi
+	done
+fi
+
+# nfulnl_dump_out: print whatever nfulnl_test captured so far, for
+# post-mortem debugging. Safe to call even if capture never started.
+nfulnl_dump_out() {
+	if [ -n "$NFULNL_OUT" ] && [ -s "$NFULNL_OUT" ]; then
+		echo "---- $NFULNL_TEST_NAME: nfulnl_test output ($NFULNL_OUT) ----" >&2
+		cat "$NFULNL_OUT" >&2
+		echo "---- end nfulnl_test output ----" >&2
+	fi
+}
+
+die() {
+	echo "FAIL: $NFULNL_TEST_NAME: $@" >&2
+	nfulnl_dump_out
+	exit 1
+}
+
+skip() {
+	echo "SKIP: $NFULNL_TEST_NAME: $@" >&2
+	exit $SKIP_RC
+}
+
+# Reports the failing command/line whenever `set -e` aborts a testcase, eg.
+# a setup command (ip, nft, ping, ...) failing - those currently exit with
+# no message at all since their own stdout is usually redirected away.
+# Deliberately a no-op once a testcase does `set +e` for its assertion
+# section: bash still runs the ERR trap there for things like
+# `cnt=$(grep -c ...)` even though -e is off, and those failures are
+# expected/handled by the `die` calls that follow, not errors in themselves.
+nfulnl_on_err() {
+	local rc=$? line="$1" cmd="$2"
+	case $- in
+	*e*) ;;
+	*) return 0 ;;
+	esac
+	# nfulnl_wait already reports the process it ran and its output before
+	# propagating failure via a plain "return $rc"; skip the generic message
+	# for that case, it would only point at the "return" statement itself,
+	# not anything a test author wrote.
+	case "$cmd" in
+	"return "*) return 0 ;;
+	esac
+	echo "FAIL: $NFULNL_TEST_NAME: line $line: '$cmd' exited with status $rc" >&2
+	nfulnl_dump_out
+}
+trap 'nfulnl_on_err "$LINENO" "$BASH_COMMAND"' ERR
+
+[ -x "$NFULNL_TEST_BIN" ] || skip "nfulnl_test binary not found/built (looked for \$NFULNL_TEST_BIN, utils/nfulnl_test)"
+command -v nft >/dev/null || skip "nft not found"
+
+NFULNL_PID=
+NFULNL_OUT=
+
+# nfulnl_capture [netns]
+#
+# Starts nfulnl_test in the background (optionally inside netns <netns>),
+# redirecting its output to a tempfile ($NFULNL_OUT). The caller is
+# responsible for calling `nfulnl_wait` once traffic generation is done.
+nfulnl_capture() {
+	local ns="$1"
+	NFULNL_OUT=$(mktemp)
+
+	if [ -n "$ns" ]; then
+		ip netns exec "$ns" timeout 5 "$NFULNL_TEST_BIN" > "$NFULNL_OUT" &
+	else
+		timeout 5 "$NFULNL_TEST_BIN" > "$NFULNL_OUT" &
+	fi
+	NFULNL_PID=$!
+
+	# give nflog_bind_group()/nft a moment to come up before traffic flows
+	sleep 1
+}
+
+# Waits for the backgrounded nfulnl_test (started by nfulnl_capture) to
+# finish. Under normal operation that's `timeout 5` killing it once the
+# capture window elapses, which `wait` reports as rc 124 - that is success,
+# not a failure, so it must not be returned as-is: under `set -e` it is the
+# right-most (ie. checked) element of a `&&` list, so returning it verbatim
+# would silently abort the testcase right here, before any of its assertions
+# ever run.
+nfulnl_wait() {
+	local rc=0
+	[ -n "$NFULNL_PID" ] || return 0
+	wait "$NFULNL_PID" || rc=$?
+	if [ "$rc" -ne 0 ] && [ "$rc" -ne 124 ]; then
+		echo "FAIL: $NFULNL_TEST_NAME: nfulnl_test exited with status $rc (expected 124 from the timeout, or 0)" >&2
+		nfulnl_dump_out
+		return "$rc"
+	fi
+	return 0
+}
+
+# Runs as an EXIT trap, so under `set -e` any command here that fails (eg.
+# `kill` on a PID that has already exited on its own - the common case,
+# since nfulnl_wait() only returns after the capture has ended) would abort
+# the rest of the trap and silently replace the testcase's real exit status
+# with the failed command's, turning a PASS into an unexplained FAIL. `set
+# +e` so a failure here can't do that; stdout/stderr are left alone so a
+# genuine problem (eg. permission denied) is still visible.
+nfulnl_cleanup() {
+	set +e
+	[ -n "$NFULNL_PID" ] && kill "$NFULNL_PID"
+	[ -n "$NFULNL_OUT" ] && rm -f "$NFULNL_OUT"
+}
diff --git a/tests/shell/run-tests.sh b/tests/shell/run-tests.sh
new file mode 100755
index 000000000000..9bcd43e5fa55
--- /dev/null
+++ b/tests/shell/run-tests.sh
@@ -0,0 +1,66 @@
+#!/bin/bash
+#
+# Minimal test runner for tests/shell/testcases/, modeled after nftables'
+# tests/shell/run-tests.sh and ipset's tests/ harness, but scaled down to
+# this project's size: each testcase is run inside its own network
+# namespace (via `unshare -n`), sets up whatever topology it needs on top
+# of that (plain interfaces, or further `ip netns` peers for multi-host
+# setups), drives nfulnl_test, and exits 0 (pass), 77 (skip) or anything
+# else (fail).
+#
+# Usage: tests/shell/run-tests.sh [testcase ...]
+#   With no arguments, runs every executable file under testcases/.
+
+set -u
+
+SKIP_RC=77
+TESTDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
+
+if [ "$(id -u)" -ne 0 ]; then
+	echo "Most testcases require root (netns/nft support) - re-run with sudo." >&2
+fi
+
+if [ "$#" -gt 0 ]; then
+	tests=("$@")
+else
+	tests=()
+	while IFS= read -r -d '' f; do
+		tests+=("$f")
+	done < <(find "$TESTDIR/testcases" -type f -perm -u+x -print0 | sort -z)
+fi
+
+# Each testcase's combined stdout+stderr is captured to its own file under
+# here rather than just a shell variable, so a failure can be inspected
+# after the fact (full output, not just whatever fit on screen) - the whole
+# directory is removed at the end unless some test failed.
+LOGDIR=$(mktemp -d "${TMPDIR:-/tmp}/nfulnl-tests.XXXXXX")
+
+npass=0
+nfail=0
+nskip=0
+
+for t in "${tests[@]}"; do
+	name="${t#"$TESTDIR"/testcases/}"
+	log="$LOGDIR/${name//\//_}.log"
+	(cd "$TESTDIR" && NFULNL_TEST_BIN="${NFULNL_TEST_BIN:-}" unshare -n -- "$t") > "$log" 2>&1
+	rc=$?
+	if [ "$rc" -eq 0 ]; then
+		echo "PASS: $name"
+		npass=$((npass + 1))
+	elif [ "$rc" -eq "$SKIP_RC" ]; then
+		echo "SKIP: $name"
+		nskip=$((nskip + 1))
+	else
+		echo "FAIL: $name (rc=$rc)"
+		nfail=$((nfail + 1))
+	fi
+done
+
+echo
+echo "Results: $npass passed, $nfail failed, $nskip skipped"
+if [ "$nfail" -ne 0 ]; then
+	echo "Full logs for this run kept in $LOGDIR"
+	exit 1
+fi
+rm -rf "$LOGDIR"
+exit 0
diff --git a/tests/shell/testcases/nfulnl/0001-prerouting-loopback b/tests/shell/testcases/nfulnl/0001-prerouting-loopback
new file mode 100755
index 000000000000..abdd70656407
--- /dev/null
+++ b/tests/shell/testcases/nfulnl/0001-prerouting-loopback
@@ -0,0 +1,36 @@
+#!/bin/bash
+#
+# Baseline: log ICMP/ICMPv6 in the prerouting chain on loopback.
+# NF_INET_PRE_ROUTING is the simplest nfulnl_pre_egress() case (hooknum <=
+# NF_INET_FORWARD for pf IPv4/IPv6) and indev == skb->dev always holds here,
+# so NFULA_HWADDR and the NFULA_HWTYPE/HWLEN/HWHEADER triplet must both be
+# present.
+
+source "$(dirname "$0")/../../lib.sh"
+trap nfulnl_cleanup EXIT
+set -e
+
+nfulnl_capture
+ip link set lo up
+
+nft -f - <<EOF
+table inet filter {
+	chain icmp-log {
+		type filter hook prerouting priority 0; policy accept;
+		icmp type echo-request counter log group 0 prefix "test icmp "
+		icmpv6 type echo-request counter log group 0 prefix "test icmp6 "
+	}
+}
+EOF
+
+ping -q -c 2 127.0.0.1
+ping6 -q -c 2 ::1
+
+nfulnl_wait
+
+set +e
+cnt4=$(grep -c '^hw_protocol=0x0800 hook=0 hw_addrlen=6 hw_addr=00:00:00:00:00:00 hw_type=0x0304 hw_hdrlen=14 hw_header=[0-9a-f]\{28\} mark=0 indev=1 prefix="test icmp " payload_len=84' "$NFULNL_OUT")
+cnt6=$(grep -c '^hw_protocol=0x86dd hook=0 hw_addrlen=6 hw_addr=00:00:00:00:00:00 hw_type=0x0304 hw_hdrlen=14 hw_header=[0-9a-f]\{28\} mark=0 indev=1 prefix="test icmp6 " payload_len=104' "$NFULNL_OUT")
+
+[ "$cnt4" -eq 2 ] || die "expected 4 ipv4 log lines with hwheader, got $cnt4"
+[ "$cnt6" -eq 2 ] || die "expected 4 ipv6 log lines with hwheader, got $cnt6"
diff --git a/tests/shell/testcases/nfulnl/0002-output-no-hwheader b/tests/shell/testcases/nfulnl/0002-output-no-hwheader
new file mode 100755
index 000000000000..6f8bb22f8385
--- /dev/null
+++ b/tests/shell/testcases/nfulnl/0002-output-no-hwheader
@@ -0,0 +1,43 @@
+#!/bin/bash
+#
+# Check NFULA_HWTYPE/HWLEN/HWHEADER attributes are not present in
+# output and postrouting hooks.
+
+source "$(dirname "$0")/../../lib.sh"
+trap nfulnl_cleanup EXIT
+set -e
+
+nfulnl_capture
+ip link set lo up
+
+nft -f - <<EOF
+table inet filter {
+	chain icmp-log-out {
+		type filter hook output priority 0; policy accept;
+		meta l4proto icmp counter log group 0 prefix "test icmp-out "
+	}
+
+	chain icmp-log-post {
+		type filter hook postrouting priority 0; policy accept;
+		meta l4proto icmp counter log group 0 prefix "test icmp-post "
+	}
+}
+EOF
+
+ping -q -c 2 127.0.0.1
+nfulnl_wait
+
+set +e
+
+cnt=$(grep -c 'prefix="test icmp-out "' "$NFULNL_OUT")
+[ "$cnt" -ge 1 ] || die "expected at least one icmp-out log line, got $cnt"
+
+bad=$(grep 'prefix="test icmp-out "' "$NFULNL_OUT" | grep -c 'hw_header=')
+[ "$bad" -eq 0 ] || die "hw_header must not be present on icmp-out, found $bad line(s)"
+
+cnt=$(grep -c 'prefix="test icmp-post "' "$NFULNL_OUT")
+[ "$cnt" -ge 1 ] || die "expected at least one icmp-out log line, got $cnt"
+
+bad=$(grep 'prefix="test icmp-post "' "$NFULNL_OUT" | grep -c 'hw_header=')
+[ "$bad" -eq 0 ] || die "hw_header must not be present on icmp-post, found $bad line(s)"
+
diff --git a/tests/shell/testcases/nfulnl/0003-forward-hwheader b/tests/shell/testcases/nfulnl/0003-forward-hwheader
new file mode 100755
index 000000000000..13cc0c3ab60f
--- /dev/null
+++ b/tests/shell/testcases/nfulnl/0003-forward-hwheader
@@ -0,0 +1,74 @@
+#!/bin/bash
+#
+# NF_INET_FORWARD coverage: three netns (ns1 -- router -- ns2), router
+# forwards ICMP between them. indev == skb->dev always holds for plain IP
+# forwarding (no bridging involved), so this is a basic presence/coverage
+# test for nfulnl_put_hwheader() at the forward hook, not a regression test
+# for the indev-vs-skb->dev divergence (see 0004-bridge-forward-indev for
+# that).
+
+source "$(dirname "$0")/../../lib.sh"
+
+command -v ip >/dev/null || skip "ip(8) not found"
+
+rnd=$(mktemp -u XXXXXX)
+nsr="nfulnl-r-$rnd"
+ns1="nfulnl-1-$rnd"
+ns2="nfulnl-2-$rnd"
+
+cleanup() {
+	set +e
+	nfulnl_cleanup
+	ip netns del "$ns1"
+	ip netns del "$ns2"
+	ip netns del "$nsr"
+}
+trap cleanup EXIT
+set -e
+
+ip netns add "$nsr"
+ip netns add "$ns1"
+ip netns add "$ns2"
+
+ip link add veth1 netns "$nsr" type veth peer name veth1p netns "$ns1"
+ip link add veth2 netns "$nsr" type veth peer name veth2p netns "$ns2"
+
+ip -net "$nsr" link set lo up
+ip -net "$nsr" link set veth1 up
+ip -net "$nsr" link set veth2 up
+ip -net "$nsr" addr add 10.9.1.1/24 dev veth1
+ip -net "$nsr" addr add 10.9.2.1/24 dev veth2
+ip netns exec "$nsr" sysctl -q net.ipv4.ip_forward=1
+
+ip -net "$ns1" link set lo up
+ip -net "$ns1" link set veth1p up
+ip -net "$ns1" addr add 10.9.1.2/24 dev veth1p
+ip -net "$ns1" route add default via 10.9.1.1
+
+ip -net "$ns2" link set lo up
+ip -net "$ns2" link set veth2p up
+ip -net "$ns2" addr add 10.9.2.2/24 dev veth2p
+ip -net "$ns2" route add default via 10.9.2.1
+
+indev_idx=$(ip -net "$nsr" -o link show veth1 | cut -d: -f1 | tr -d ' ')
+
+ip netns exec "$nsr" nft -f - <<EOF
+table inet filter {
+	chain fwd-log {
+		type filter hook forward priority 0; policy accept;
+		icmp type echo-request counter log group 0 prefix "test fwd "
+	}
+}
+EOF
+
+nfulnl_capture "$nsr"
+
+ip netns exec "$ns1" ping -q -c 2 -I veth1p 10.9.2.2
+nfulnl_wait
+
+set +e
+cnt=$(grep 'prefix="test fwd "' "$NFULNL_OUT" | grep -c 'hw_header=')
+[ "$cnt" -ge 1 ] || die "expected hw_header on forwarded ICMP, got $cnt matching lines"
+
+badindev=$(grep 'prefix="test fwd "' "$NFULNL_OUT" | grep -v "indev=$indev_idx " | wc -l)
+[ "$badindev" -eq 0 ] || die "expected indev=$indev_idx on all forwarded log lines, found $badindev mismatches"
diff --git a/tests/shell/testcases/nfulnl/0004-netdev-ingress-hwheader b/tests/shell/testcases/nfulnl/0004-netdev-ingress-hwheader
new file mode 100755
index 000000000000..ac127e004a9a
--- /dev/null
+++ b/tests/shell/testcases/nfulnl/0004-netdev-ingress-hwheader
@@ -0,0 +1,29 @@
+#!/bin/bash
+#
+# Regression test for nfulnl_pre_egress()'s NFPROTO_NETDEV branch: logging
+# from a `netdev`-family ingress hook (NF_NETDEV_INGRESS == 0, no relation
+# to NF_INET_FORWARD's numbering) must still get the hwheader triplet.
+
+source "$(dirname "$0")/../../lib.sh"
+trap nfulnl_cleanup EXIT
+set -e
+
+ip link set lo up
+
+nft -f - <<EOF
+table netdev filter {
+	chain ingress-log {
+		type filter hook ingress device lo priority 0; policy accept;
+		meta l4proto icmp counter log group 0 prefix "test netdev-ingress "
+	}
+}
+EOF
+
+nfulnl_capture
+
+ping -q -c 2 127.0.0.1
+nfulnl_wait
+
+set +e
+cnt=$(grep 'prefix="test netdev-ingress "' "$NFULNL_OUT" | grep -c 'hw_header=')
+[ "$cnt" -ge 1 ] || die "expected hw_header on netdev ingress hook, got $cnt matching lines"
diff --git a/tests/shell/testcases/nfulnl/0005-arp-hwheader b/tests/shell/testcases/nfulnl/0005-arp-hwheader
new file mode 100755
index 000000000000..f9dd63645e69
--- /dev/null
+++ b/tests/shell/testcases/nfulnl/0005-arp-hwheader
@@ -0,0 +1,69 @@
+#!/bin/bash
+#
+# Regression test for nfulnl_pre_egress()'s NFPROTO_ARP branch: only
+# NF_ARP_IN (0) should get the hwheader triplet, exercised here via a real
+# ARP exchange between two directly connected netns (loopback has no ARP).
+
+source "$(dirname "$0")/../../lib.sh"
+
+command -v ip >/dev/null || skip "ip(8) not found"
+
+rnd=$(mktemp -u XXXXXX)
+nsa="nfulnl-a-$rnd"
+nsb="nfulnl-b-$rnd"
+
+cleanup() {
+	set +e
+	nfulnl_cleanup
+	ip netns del "$nsa"
+	ip netns del "$nsb"
+}
+trap cleanup EXIT
+set -e
+
+ip netns add "$nsa"
+ip netns add "$nsb"
+
+ip link add veth0 netns "$nsa" type veth peer name veth0 netns "$nsb"
+
+ip -net "$nsa" link set lo up
+ip -net "$nsb" link set lo up
+ip -net "$nsa" link set veth0 up
+ip -net "$nsb" link set veth0 up
+ip -net "$nsa" addr add 10.9.9.1/24 dev veth0
+ip -net "$nsb" addr add 10.9.9.2/24 dev veth0
+
+ip netns exec "$nsa" nft -f - <<EOF
+table arp filter {
+	chain in {
+		type filter hook input priority 0; policy accept;
+		counter log group 0 prefix "test arp-in "
+	}
+}
+EOF
+
+nfulnl_capture "$nsa"
+ip netns exec "$nsa" ping -q -c 2 10.9.9.2
+nfulnl_wait
+
+set +e
+cnt=$(grep 'prefix="test arp-in "' "$NFULNL_OUT" | grep -c 'hw_header=')
+[ "$cnt" -ge 1 ] || die "expected hw_header on arp input hook, got $cnt matching lines"
+
+ip netns exec "$nsa" nft -f - <<EOF
+flush ruleset
+table arp filter {
+	chain out {
+		type filter hook output priority 0; policy accept;
+		counter log group 0 prefix "test arp-out "
+	}
+}
+EOF
+nfulnl_capture "$nsa"
+
+# will fail
+ip netns exec "$nsa" ping -q -c 2 10.9.9.3 || true
+nfulnl_wait
+
+cnt=$(grep 'prefix="test arp-out "' "$NFULNL_OUT" | grep -c 'hw_header=')
+[ "$cnt" -eq 0 ] || die "expected no hw_header on arp output hook, got $cnt matching lines"
diff --git a/tests/shell/testcases/nfulnl/0006-bridge-forward-indev b/tests/shell/testcases/nfulnl/0006-bridge-forward-indev
new file mode 100755
index 000000000000..cbf760d5b219
--- /dev/null
+++ b/tests/shell/testcases/nfulnl/0006-bridge-forward-indev
@@ -0,0 +1,88 @@
+#!/bin/bash
+#
+# Regression test for the indev-vs-skb->dev fix in
+# nfnetlink_put_hwaddr()/nfulnl_put_hwheader(): on the bridge forward hook,
+# __br_forward() sets indev to the ingress port and repoints skb->dev to the
+# egress port before invoking NF_BR_FORWARD. Before the fix, HWADDR/HWTYPE/
+# HWLEN/HWHEADER were silently dropped here (indev != skb->dev); after the
+# fix they must be present *and* indev/hw_addr must reflect the actual
+# ingress port for each direction, not whatever skb->dev was last set to.
+#
+# Topology: nsa --veth-a--> [ br0 in nsbr ] <--veth-b-- nsb
+# Pinging nsa <-> nsb crosses br0 purely at L2 (no IP on br0, no routing),
+# i.e. NF_BR_FORWARD, with the ingress port alternating by direction.
+
+source "$(dirname "$0")/../../lib.sh"
+
+command -v ip >/dev/null || skip "ip(8) not found"
+
+rnd=$(mktemp -u XXXXXX)
+nsbr="nfulnl-br-$rnd"
+nsa="nfulnl-bra-$rnd"
+nsb="nfulnl-brb-$rnd"
+
+cleanup() {
+	set +e
+	nfulnl_cleanup
+	ip netns del "$nsa"
+	ip netns del "$nsb"
+	ip netns del "$nsbr"
+}
+trap cleanup EXIT
+set -e
+
+ip netns add "$nsbr"
+ip netns add "$nsa"
+ip netns add "$nsb"
+
+ip link add veth-a netns "$nsbr" type veth peer name veth0 netns "$nsa"
+ip link add veth-b netns "$nsbr" type veth peer name veth0 netns "$nsb"
+
+ip -net "$nsbr" link add name br0 type bridge
+ip -net "$nsbr" link set veth-a master br0
+ip -net "$nsbr" link set veth-b master br0
+ip -net "$nsbr" link set lo up
+ip -net "$nsbr" link set veth-a up
+ip -net "$nsbr" link set veth-b up
+ip -net "$nsbr" link set br0 up
+
+ip -net "$nsa" link set lo up
+ip -net "$nsa" link set veth0 up
+ip -net "$nsa" addr add 10.9.3.1/24 dev veth0
+
+ip -net "$nsb" link set lo up
+ip -net "$nsb" link set veth0 up
+ip -net "$nsb" addr add 10.9.3.2/24 dev veth0
+
+idx_a=$(ip -net "$nsbr" -o link show veth-a | cut -d: -f1 | tr -d ' ')
+idx_b=$(ip -net "$nsbr" -o link show veth-b | cut -d: -f1 | tr -d ' ')
+mac_a=$(ip -net "$nsa" -o link show veth0 | grep -oP 'link/ether \K[0-9a-f:]+')
+mac_b=$(ip -net "$nsb" -o link show veth0 | grep -oP 'link/ether \K[0-9a-f:]+')
+
+ip netns exec "$nsbr" nft -f - <<EOF
+table bridge filter {
+	chain fwd-log {
+		type filter hook forward priority 0; policy accept;
+		meta l4proto icmp counter log group 0 prefix "test brfwd "
+	}
+}
+EOF
+
+nfulnl_capture "$nsbr"
+ip netns exec "$nsa" ping -q -c 2 10.9.3.2
+nfulnl_wait
+
+set +e
+lines=$(grep 'prefix="test brfwd "' "$NFULNL_OUT")
+[ -n "$lines" ] || die "no bridge-forward log lines captured at all"
+
+cnt=$(echo "$lines" | grep -c 'hw_header=')
+[ "$cnt" -ge 1 ] || die "expected hw_header on bridge forward hook, got $cnt matching lines (indev-vs-skb->dev regression?)"
+
+# echo-request: ingress port is veth-a, source mac is nsa's veth0
+reqcnt=$(echo "$lines" | grep "physindev=$idx_a " | grep -ic "hw_addr=$mac_a ")
+[ "$reqcnt" -ge 1 ] || die "expected a log line with physindev=$idx_a (veth-a) and hw_addr=$mac_a (nsa), found $reqcnt"
+
+# echo-reply: ingress port is veth-b, source mac is nsb's veth0
+repcnt=$(echo "$lines" | grep "physindev=$idx_b " | grep -ic "hw_addr=$mac_b ")
+[ "$repcnt" -ge 1 ] || die "expected a log line with indev=$idx_b (veth-b) and hw_addr=$mac_b (nsb), found $repcnt"
-- 
2.56.1

