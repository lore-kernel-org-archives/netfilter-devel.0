Received: from mail-lj1-f171.google.com (mail-lj1-f171.google.com [209.85.208.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2ED4238DC50
	for <netfilter-devel@vger.kernel.org>; Wed,  5 Aug 2026 06:05:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785909914; cv=none; b=TyR7dFwmHzkvw9lFWMUUT0JgTWMTxgj1ihwiKOEIXp8c8XM3MTkvEgEtidFrYgqOGaX2QStf10/vMY4QjErFdUwsCWtJ+10UjcuXA2rkfroCvE88sadrkCZDo7pi2rFfIL+fddD8WeQVQ6eo1NsHANCecvyjzrE7JeerfnyAjE4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785909914; c=relaxed/simple;
	bh=bBUIb6c6mdg44l4b86guDEjHx2iXxEqjN7CxTB293lw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=LEj2ENmm0yh9xWYaBYjN8XdX+FQ5zs9gB+0rCtT7ioI0TtFRb/dRXm+lSZz+Pz4GvMeFuCQxvlMjE/PmM9qqqsGcE9ylwL1BIfPVqlohW8MuriipknMu6ZjMcrCddw8I949I91gWaOvs7diQIfucy8ZIKBxBPoH1ol9mJ4RGPn4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ND6R4G09; arc=none smtp.client-ip=209.85.208.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ND6R4G09"
Received: by mail-lj1-f171.google.com with SMTP id 38308e7fff4ca-39c7fd45465so5696411fa.1
        for <netfilter-devel@vger.kernel.org>; Tue, 04 Aug 2026 23:05:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785909910; x=1786514710; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=bydW1aFXYq/H3/grM3GNxELGvfwDk9bqHM9XnIheb34=;
        b=ND6R4G09BnjwmD/wUoIbvC32O11Hh0tfixdQyocTGsGDl5Q3VHSW0ebvQ5R2h0M9do
         KHgaspkSp6IebfEwlqnuML5zKYNyGjA5qhaOlGBRfngD5W+VlCq7XYqEwMkBOY6Bdfb1
         h/VAcIq9wVseQcaeAF806Y2zDZpVCVqguXhLvSKECnLWuUuYlvYhYnwHipO5+jL9h/wP
         PPrJyAWHyFkIed+XY4epLfv65BtSQcMe3Wye4FF3Ix0C15hRvnWeKYZaEQm0LU3e20jx
         vzc34pNQMKCpiaj+oowBi+nUWDR2Yy7QBgnH1dTNM7iqIlI3eFEHMEEo+Hrfz23HLA17
         JSxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785909910; x=1786514710;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=bydW1aFXYq/H3/grM3GNxELGvfwDk9bqHM9XnIheb34=;
        b=lBWaP5TtyAU0h+py9+0k5lK6ja0vrZF9Cuq5SN1mO99PPN+x7ayhu6oRC/hJAA4G4d
         MLCTBPGF4m/p0+cSkeJWJGb1cf3rp38D4VvEsjeEu0eAYlkz1/a+fielAH3DGfndpR7M
         QoETnGeh4HyoLMTLgcFli514W0IS63Zqt0w8pTroEkQzbXQeGtx/YSq+qRCKV8VJ+ozr
         hMvUjSERocr6LQnsunvk0acH5sPx5xsvPhKyFZL4mRS7jClFsiJ6wv/q2JAGTtx6zSA/
         H0QnOlrkAvh+0dAO55uD//JDISMhKPeXTJSZzOkI9bAyltqc2eeC6CmM+lNCFtg71NZh
         PczA==
X-Gm-Message-State: AOJu0YwvWyhP+Ew1cu4XBNOASw2CbpVN0iukXAROpXmAbLiaqAzLkALJ
	jkxONFnXOw11hlmGTkwm6/c37dfYLcUEiiFh6p5MWcRQe8B41yiXk/NJAHl2Fi8amSY=
X-Gm-Gg: AR+sD12y6kZ8/3wkqGy69m4MjZX9ow7x25yJuEM8nISx/Hq0zCMd8IOJWPtKCj7ETkE
	HHpghDdy2Zsis7NTiDO1j+Q1KUkCZQCsS2152zdXii6evGhlQiwTslKWa/IZ7FMObGQPac+uNob
	RWh2a4QBTtaSo4P/b+gtWL7mdCqxZPaenUGdnwbNxcRG3nXoATjC90MpnN01W+nLcVvHgPV4Kuz
	k7a8dgkbhuFVCrCtsSlZvc2f+PUq/53XIbeibiAvLXEzcOoCe0hXbIBIohOb2fPj7QlAvKn0p3O
	DB5mVOax3x1JKaN8P6pe+dzgOn2I0WfEFHt/ANLTvthOXZxzJlwaBP2BFa2SBmUDjV5D/yFoYaQ
	4YI+63wKrl4Ncn4XDw0BYAt6cPcMwdXrwQnlEyn6NYmYcPkD73B80J9NEP10cDUoVWw6cUgJGkS
	iKYVRJjLMtZtMTjXJg2pa84vvrP0dQ3chANFw/SfsQDCBRKtnIM3cgtXSbkElpKNTF4iP9IXkUV
	nBPwxrT4Qfn5l4Z3tvRju5xj+p6nCRqC0beiUXD8e6Q4chA
X-Received: by 2002:a05:651c:2117:b0:39c:7922:b43d with SMTP id 38308e7fff4ca-39fbb250562mr4695371fa.13.1785909909655;
        Tue, 04 Aug 2026 23:05:09 -0700 (PDT)
Received: from va-HP-Pavilion-Desktop-595-p0xxx.mshome.net ([193.0.148.216])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-39fb98b48d9sm6210401fa.7.2026.08.04.23.05.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Aug 2026 23:05:09 -0700 (PDT)
From: Valery Borovsky <vebohr@gmail.com>
To: pablo@netfilter.org,
	fw@strlen.de
Cc: netfilter-devel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	shuah@kernel.org,
	linux-kernel@vger.kernel.org,
	Valery Borovsky <vebohr@gmail.com>
Subject: [PATCH] selftests: netfilter: add functional test for nft ct timeout policies
Date: Wed,  5 Aug 2026 09:05:07 +0300
Message-ID: <20260805060507.777983-1-vebohr@gmail.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

There is no selftest coverage for nftables ct timeout objects: no test
under tools/testing/selftests/net/netfilter/ exercises "ct timeout set"
or checks that a named policy reaches the conntrack state machine.

Add nft_ct_timeout.sh with three subtests, using two netns joined by a
veth pair and reading the remaining flow lifetime from "conntrack -L":

  1. test_policy_applied: a TCP connection matched by a "ct timeout set"
     rule gets the ESTABLISHED timeout carried by the policy (120s here)
     instead of the kernel default, which is 5 days for that state (see
     nf_conntrack_proto_tcp.c, tcp_timeouts[TCP_CONNTRACK_ESTABLISHED]).

  2. test_default_preserved: a connection on a port not covered by any
     rule keeps the default. The expected value is read from
     nf_conntrack_tcp_timeout_established rather than hardcoded, so a
     host that lowered the sysctl does not fail the test spuriously.

  3. test_policy_reload: after the table is deleted and reloaded, a new
     connection through the rule receives the policy timeout again,
     covering the create/assign/destroy/re-create object lifecycle.

The test checks kernel behaviour rather than the parsing round-trip,
which the nftables.git functional tests already cover.

Signed-off-by: Valery Borovsky <vebohr@gmail.com>
---
This replaces the nft_ct timeout regression test posted in April:
https://lore.kernel.org/netfilter-devel/20260422131818.106417-1-vebohr@gmail.com/

Florian's review of that patch asked for a functional test for timeout
policies rather than a regression script, and noted that the nftables.git
tests only cover the parsing side. This is that test: it checks that the
policy reaches the conntrack state machine, and does not re-check parsing.
The executable bit is set this time.

Test output on x86_64 (nft 1.1.6, conntrack-tools 1.4.9):

  PASS: test_policy_applied: timeout 119s <= policy 120s
  PASS: test_default_preserved: timeout 431999s matches default 432000s
  PASS: test_policy_reload: timeout 119s <= policy 120s

 .../testing/selftests/net/netfilter/Makefile  |   1 +
 .../selftests/net/netfilter/nft_ct_timeout.sh | 217 ++++++++++++++++++
 2 files changed, 218 insertions(+)
 create mode 100755 tools/testing/selftests/net/netfilter/nft_ct_timeout.sh

diff --git a/tools/testing/selftests/net/netfilter/Makefile b/tools/testing/selftests/net/netfilter/Makefile
index f88dd4ef8d26..39101af5d84a 100644
--- a/tools/testing/selftests/net/netfilter/Makefile
+++ b/tools/testing/selftests/net/netfilter/Makefile
@@ -25,6 +25,7 @@ TEST_PROGS := \
 	nft_audit.sh \
 	nft_concat_range.sh \
 	nft_conntrack_helper.sh \
+	nft_ct_timeout.sh \
 	nft_fib.sh \
 	nft_fib_nexthop.sh \
 	nft_flowtable.sh \
diff --git a/tools/testing/selftests/net/netfilter/nft_ct_timeout.sh b/tools/testing/selftests/net/netfilter/nft_ct_timeout.sh
new file mode 100755
index 000000000000..a41dad2329cc
--- /dev/null
+++ b/tools/testing/selftests/net/netfilter/nft_ct_timeout.sh
@@ -0,0 +1,217 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+#
+# Functional test for nftables ct timeout objects.
+#
+# Verifies that a ct timeout policy actually changes the conntrack
+# state-machine timeout of the connections it is attached to:
+#
+#  1. test_policy_applied    - a connection matching a "ct timeout set" rule
+#                              gets the per-state timeout from the named
+#                              policy, i.e. <= POLICY_ESTAB_SECS.
+#
+#  2. test_default_preserved - a connection not matching any ct timeout rule
+#                              keeps the kernel default ESTABLISHED timeout.
+#
+#  3. test_policy_reload     - after the table is deleted and reloaded, a new
+#                              connection through the rule still receives the
+#                              policy timeout rather than the default.
+#
+# The remaining lifetime of a flow is the third field of a "conntrack -L"
+# line:
+#
+#   tcp  6  117  ESTABLISHED  src=10.0.1.1 dst=10.0.1.2 sport=... dport=...
+#           ^^^
+#
+# Topology: two netns connected by a veth pair.
+#   ns1 (10.0.1.1/24) --veth-- ns2 (10.0.1.2/24)
+# The ruleset is loaded in ns1, so ns1's conntrack table is used throughout.
+
+source lib.sh
+
+checktool "nft --version" "run test without nft"
+checktool "conntrack --version" "run test without conntrack"
+checktool "socat -h" "run test without socat"
+
+# TCP port covered by the ct timeout policy.
+PORT_POLICY=12345
+# TCP port not covered by any rule; uses the kernel default timeouts.
+PORT_DEFAULT=12346
+
+# ESTABLISHED timeout carried by the policy, in seconds. Must be well below
+# the kernel default (5 days) so the two cases cannot be confused.
+POLICY_ESTAB_SECS=120
+
+ret=0
+
+cleanup()
+{
+	ip netns pids "$ns1" 2>/dev/null | xargs -r kill
+	ip netns pids "$ns2" 2>/dev/null | xargs -r kill
+	cleanup_all_ns
+}
+
+load_ruleset()
+{
+	ip netns exec "$ns1" nft -f - <<EOF
+table ip ct_timeout_test {
+	ct timeout tcp_policy {
+		protocol tcp;
+		policy = { established: ${POLICY_ESTAB_SECS}s };
+	}
+
+	chain output {
+		type filter hook output priority filter; policy accept;
+		ip daddr 10.0.1.2 tcp dport $PORT_POLICY ct timeout set "tcp_policy"
+	}
+}
+EOF
+}
+
+listener_ready()
+{
+	ip netns exec "$ns2" ss -lnt -o "sport = :$1" | grep -q "$1"
+}
+
+conn_established()
+{
+	ip netns exec "$ns1" conntrack -L -p tcp --dport "$1" 2>/dev/null |
+		grep -q ESTABLISHED
+}
+
+# Prints the remaining lifetime, in seconds, of the first ESTABLISHED TCP
+# flow in ns1 matching the given destination port.
+established_timeout()
+{
+	ip netns exec "$ns1" conntrack -L -p tcp --dport "$1" 2>/dev/null |
+		awk '/ESTABLISHED/ { print $3; exit }'
+}
+
+# Opens a TCP connection from ns1 and holds it open in the background.
+# Prints the pid of the holder so the caller can tear it down.
+open_connection()
+{
+	# stdout/stderr must be redirected, else the background job keeps the
+	# command substitution that calls this function blocked until it exits.
+	ip netns exec "$ns1" bash -c "
+		exec 3<>/dev/tcp/10.0.1.2/$1 || exit 1
+		sleep 60
+	" >/dev/null 2>&1 &
+	echo $!
+}
+
+close_connection()
+{
+	kill "$1" 2>/dev/null
+	wait "$1" 2>/dev/null
+}
+
+# Asserts that the flow on $1 has a timeout matching expectation $2 ("policy"
+# or "default"), using $3 as the test name.
+check_timeout()
+{
+	local dport=$1 expect=$2 name=$3
+	local tval
+
+	if ! busywait "$BUSYWAIT_TIMEOUT" conn_established "$dport"; then
+		echo "FAIL: $name: connection did not reach ESTABLISHED"
+		ret=1
+		return
+	fi
+
+	tval=$(established_timeout "$dport")
+	if [ -z "$tval" ]; then
+		echo "FAIL: $name: could not read conntrack timeout"
+		ret=1
+		return
+	fi
+
+	if [ "$expect" = "policy" ]; then
+		if [ "$tval" -le "$POLICY_ESTAB_SECS" ]; then
+			echo "PASS: $name: timeout ${tval}s <= policy ${POLICY_ESTAB_SECS}s"
+		else
+			echo "FAIL: $name: timeout ${tval}s exceeds policy ${POLICY_ESTAB_SECS}s"
+			ret=1
+		fi
+	else
+		if [ "$tval" -gt "$POLICY_ESTAB_SECS" ] &&
+		   [ "$tval" -le "$default_estab" ]; then
+			echo "PASS: $name: timeout ${tval}s matches default ${default_estab}s"
+		else
+			echo "FAIL: $name: timeout ${tval}s is not the default ${default_estab}s"
+			ret=1
+		fi
+	fi
+}
+
+trap cleanup EXIT
+
+setup_ns ns1 ns2
+
+if ! ip link add veth0 netns "$ns1" type veth peer name veth0 netns "$ns2" \
+		>/dev/null 2>&1; then
+	echo "SKIP: No virtual ethernet pair device support in kernel"
+	exit $ksft_skip
+fi
+
+ip -net "$ns1" link set veth0 up
+ip -net "$ns2" link set veth0 up
+ip -net "$ns1" addr add 10.0.1.1/24 dev veth0
+ip -net "$ns2" addr add 10.0.1.2/24 dev veth0
+
+# SYSTEM:"cat" keeps each accepted connection open: cat blocks reading the
+# socket, so the flow stays ESTABLISHED until the client goes away. Sinking
+# to /dev/null instead would close it immediately and land in CLOSE_WAIT.
+ip netns exec "$ns2" socat TCP-LISTEN:$PORT_POLICY,reuseaddr,fork SYSTEM:"cat" &>/dev/null &
+ip netns exec "$ns2" socat TCP-LISTEN:$PORT_DEFAULT,reuseaddr,fork SYSTEM:"cat" &>/dev/null &
+
+busywait "$BUSYWAIT_TIMEOUT" listener_ready "$PORT_POLICY"
+busywait "$BUSYWAIT_TIMEOUT" listener_ready "$PORT_DEFAULT"
+
+# Loading the ruleset pulls in conntrack, so the sysctls below exist only
+# after this point.
+if ! load_ruleset; then
+	echo "SKIP: Could not load ct timeout ruleset"
+	exit $ksft_skip
+fi
+
+# Read the default rather than hardcoding it: a host that lowered
+# nf_conntrack_tcp_timeout_established must not fail test 2 spuriously.
+default_estab=$(ip netns exec "$ns1" \
+	cat /proc/sys/net/netfilter/nf_conntrack_tcp_timeout_established \
+	2>/dev/null)
+
+if [ -z "$default_estab" ]; then
+	echo "SKIP: conntrack tcp timeout sysctl not available"
+	exit $ksft_skip
+fi
+
+if [ "$default_estab" -le "$POLICY_ESTAB_SECS" ]; then
+	echo "SKIP: default ESTABLISHED timeout ${default_estab}s is not above the policy value"
+	exit $ksft_skip
+fi
+
+# Test 1: a flow matched by the rule gets the policy timeout.
+conn_pid=$(open_connection "$PORT_POLICY")
+check_timeout "$PORT_POLICY" policy test_policy_applied
+close_connection "$conn_pid"
+
+# Test 2: a flow not matched by any rule keeps the kernel default.
+conn_pid=$(open_connection "$PORT_DEFAULT")
+check_timeout "$PORT_DEFAULT" default test_default_preserved
+close_connection "$conn_pid"
+
+# Test 3: the policy survives a delete/reload cycle of the whole table.
+ip netns exec "$ns1" conntrack -F 2>/dev/null
+ip netns exec "$ns1" nft delete table ip ct_timeout_test
+
+if ! load_ruleset; then
+	echo "FAIL: test_policy_reload: could not reload ct timeout ruleset"
+	exit $ksft_fail
+fi
+
+conn_pid=$(open_connection "$PORT_POLICY")
+check_timeout "$PORT_POLICY" policy test_policy_reload
+close_connection "$conn_pid"
+
+exit $ret
-- 
2.53.0

