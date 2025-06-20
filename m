Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 431BA2E611C
	for <netfilter-devel@vger.kernel.org>; Fri, 20 Jun 2025 16:40:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750437637; cv=none; b=T3tKH9IO1/Dozgy1i0cdG0HUSikU3pHIR9tIH3i9SfrveM4Eta5ciMhwSoHyoibj9JKyffoTLl4butyqjigQMh1p+tAdAMCBdI9k3fvdAIL3Kj2dISeLowiPATrlVuGYt6aL/f8tW2txdmpE2CnkeKsNM933SKuk1Gcb+wZ9qM0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750437637; c=relaxed/simple;
	bh=5xZObnCiwuB34iqLVb1nVJvdFDZFpwIWpPYWvFByI1g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YyQ7Pd4XnHvuiSFuZqgUXVRyVxrMsb8T4MZnwzxbZsY+ernIW2v50qBAusjOQaneTslKGBqZPRnUsl2XugJE8xSWRPNHnUxp80MxvW0Dlo3TXOFWKgNIC6Ehny66X+xe9nvLYTXalGjN+bUahEc4yQ8cNFEXqBL/ExAdMQZQuV4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ANdYmQ6T; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ANdYmQ6T"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1750437634;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=h/by31EtfziCQvgYWmEywAEhvgKYYlXWvTMAVPw5/Pc=;
	b=ANdYmQ6TeMIX43qnj3MS56+SOmHuE7l5bKDEjw5xOPG70INHmlagVL57f+dUZtVVVMyjCn
	c/7bn3bWGMeSMTUrlhsqhIBlI+NToHZaTR7tkhBEcchxNauY28SFJ3jAuFe0GWTgiDiOCU
	UtouokKHFNrU4W0YAMRFjc6rojk3i8w=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-600-Yzum8BUKNq6P5Wn8Edc_cw-1; Fri,
 20 Jun 2025 12:40:30 -0400
X-MC-Unique: Yzum8BUKNq6P5Wn8Edc_cw-1
X-Mimecast-MFC-AGG-ID: Yzum8BUKNq6P5Wn8Edc_cw_1750437629
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 9F48C195608E;
	Fri, 20 Jun 2025 16:40:29 +0000 (UTC)
Received: from yiche-laptop.redhat.com (unknown [10.72.112.97])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id C267230001A1;
	Fri, 20 Jun 2025 16:40:27 +0000 (UTC)
From: Yi Chen <yiche@redhat.com>
To: netfilter-devel@vger.kernel.org
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH] tests: shell: Verify limit statement with new test case.
Date: Sat, 21 Jun 2025 00:40:25 +0800
Message-ID: <20250620164025.49514-1-yiche@redhat.com>
In-Reply-To: <20250617104128.27188-1-yiche@redhat.com>
References: <20250617104128.27188-1-yiche@redhat.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

1. Add rate_limit test case.
2. Consolidate frequently used functions in helper/lib.sh
3. Introduce NFT_TEST_LIBRARY_FILE variable to source helper/lib.sh in
   tests.
4. Replace sleep with wait_local_port_listen().
5. Other fixes: nft->$NFT; add dumps/*.nodump files

Signed-off-by: Yi Chen <yiche@redhat.com>
---
 tests/shell/helpers/lib.sh                    |  51 +++++++
 tests/shell/helpers/test-wrapper.sh           |   1 +
 .../testcases/packetpath/dumps/nat_ftp.nodump |   0
 .../packetpath/dumps/rate_limit.nodump        |   0
 tests/shell/testcases/packetpath/flowtables   |  32 +---
 tests/shell/testcases/packetpath/nat_ftp      |  32 ++--
 tests/shell/testcases/packetpath/rate_limit   | 137 ++++++++++++++++++
 7 files changed, 211 insertions(+), 42 deletions(-)
 create mode 100755 tests/shell/helpers/lib.sh
 create mode 100644 tests/shell/testcases/packetpath/dumps/nat_ftp.nodump
 create mode 100644 tests/shell/testcases/packetpath/dumps/rate_limit.nodump
 create mode 100755 tests/shell/testcases/packetpath/rate_limit

diff --git a/tests/shell/helpers/lib.sh b/tests/shell/helpers/lib.sh
new file mode 100755
index 00000000..4e01c957
--- /dev/null
+++ b/tests/shell/helpers/lib.sh
@@ -0,0 +1,51 @@
+#!/bin/bash
+
+# Frequently used functions.
+
+wait_local_port_listen()
+{
+	local listener_ns="${1}"
+	local port="${2}"
+	local protocol="${3}"
+	local pattern
+	local i
+
+	pattern=":$(printf "%04X" "${port}") "
+
+	# for tcp protocol additionally check the socket state
+	[ ${protocol} = "tcp" ] && pattern="${pattern}0A"
+	for i in $(seq 10); do
+		if ip netns exec "${listener_ns}" awk '{print $2" "$4}' \
+		   /proc/net/"${protocol}"* | grep -q "${pattern}"; then
+			break
+		fi
+		sleep 0.1
+	done
+}
+
+assert_pass()
+{
+	local ret=$?
+	if [ $ret != 0 ]; then
+		echo "FAIL: ${@}"
+		if type -t failout; then
+			failout
+		fi
+		exit 1
+	else
+		echo "PASS: ${@}"
+	fi
+}
+assert_fail()
+{
+	local ret=$?
+	if [ $ret == 0 ]; then
+		echo "FAIL: ${@}"
+		if type -t failout; then
+			failout
+		fi
+		exit 1
+	else
+		echo "PASS: ${@}"
+	fi
+}
diff --git a/tests/shell/helpers/test-wrapper.sh b/tests/shell/helpers/test-wrapper.sh
index 4a7e8b7b..6ec4e030 100755
--- a/tests/shell/helpers/test-wrapper.sh
+++ b/tests/shell/helpers/test-wrapper.sh
@@ -36,6 +36,7 @@ TESTDIR="$(dirname "$TEST")"
 START_TIME="$(cut -d ' ' -f1 /proc/uptime)"
 
 export TMPDIR="$NFT_TEST_TESTTMPDIR"
+export NFT_TEST_LIBRARY_FILE="$NFT_TEST_BASEDIR/helpers/lib.sh"
 
 CLEANUP_UMOUNT_VAR_RUN=n
 
diff --git a/tests/shell/testcases/packetpath/dumps/nat_ftp.nodump b/tests/shell/testcases/packetpath/dumps/nat_ftp.nodump
new file mode 100644
index 00000000..e69de29b
diff --git a/tests/shell/testcases/packetpath/dumps/rate_limit.nodump b/tests/shell/testcases/packetpath/dumps/rate_limit.nodump
new file mode 100644
index 00000000..e69de29b
diff --git a/tests/shell/testcases/packetpath/flowtables b/tests/shell/testcases/packetpath/flowtables
index b68c5dd4..01a775a1 100755
--- a/tests/shell/testcases/packetpath/flowtables
+++ b/tests/shell/testcases/packetpath/flowtables
@@ -3,6 +3,8 @@
 # NFT_TEST_REQUIRES(NFT_TEST_HAVE_socat)
 # NFT_TEST_SKIP(NFT_TEST_SKIP_slow)
 
+. $NFT_TEST_LIBRARY_FILE
+
 rnd=$(mktemp -u XXXXXXXX)
 R="flowtable-router-$rnd"
 C="flowtable-client-$rnd"
@@ -17,29 +19,10 @@ cleanup()
 }
 trap cleanup EXIT
 
-assert_pass()
-{
-	local ret=$?
-	if [ $ret != 0 ]
-	then
-		echo "FAIL: ${@}"
-		ip netns exec $R cat /proc/net/nf_conntrack
-		exit 1
-	else
-		echo "PASS: ${@}"
-	fi
-}
-assert_fail()
+# call back when assert failed
+failout()
 {
-	local ret=$?
-	if [ $ret == 0 ]
-	then
-		echo "FAIL: ${@}"
-		ip netns exec $R cat /proc/net/nf_conntrack
-		exit 1
-	else
-		echo "PASS: ${@}"
-	fi
+	ip netns exec $R cat /proc/net/nf_conntrack
 }
 
 ip netns add $R
@@ -67,7 +50,7 @@ sleep 3
 ip netns exec $C ping -q -6 2001:db8:ffff:22::1 -c1
 assert_pass "topo initialization"
 
-ip netns exec $R nft -f - <<EOF
+ip netns exec $R $NFT -f - <<EOF
 table ip6 filter {
         flowtable f1 {
                 hook ingress priority -100
@@ -100,7 +83,8 @@ assert_pass "set net.netfilter.nf_conntrack_tcp_timeout_established=86400"
 
 # A trick to control the timing to send a packet
 ip netns exec $S socat TCP6-LISTEN:10001 GOPEN:/tmp/socat-$rnd,ignoreeof &
-sleep 1
+wait_local_port_listen $S 10001 tcp
+
 ip netns exec $C socat -b 2048 PIPE:/tmp/pipefile-$rnd 'TCP:[2001:db8:ffff:22::1]:10001' &
 sleep 1
 ip netns exec $C echo "send sth" >> /tmp/pipefile-$rnd        ; assert_pass "send a packet"
diff --git a/tests/shell/testcases/packetpath/nat_ftp b/tests/shell/testcases/packetpath/nat_ftp
index 327047b8..4b9f6eb0 100755
--- a/tests/shell/testcases/packetpath/nat_ftp
+++ b/tests/shell/testcases/packetpath/nat_ftp
@@ -4,6 +4,7 @@
 # NFT_TEST_REQUIRES(NFT_TEST_HAVE_curl)
 # NFT_TEST_REQUIRES(NFT_TEST_HAVE_vsftpd)
 
+. $NFT_TEST_LIBRARY_FILE
 cleanup()
 {
 	for i in $R $C $S;do
@@ -14,22 +15,15 @@ cleanup()
 }
 trap cleanup EXIT
 
-assert_pass()
+# call back when assert failed
+failout()
 {
-	local ret=$?
-	if [ $ret != 0 ]
-	then
-		echo "FAIL: ${@}"
-		ip netns exec $R nft list ruleset
-		tcpdump -nnr ${PCAP}
-		test -r /proc/net/nf_conntrack && ip netns exec $R cat /proc/net/nf_conntrack
-		ip netns exec $R conntrack -S
-		ip netns exec $R conntrack -L
-		ip netns exec $S ss -nitepal
-		exit 1
-	else
-		echo "PASS: ${@}"
-	fi
+	ip netns exec $R $NFT list ruleset
+	tcpdump -nnr ${PCAP}
+	test -r /proc/net/nf_conntrack && ip netns exec $R cat /proc/net/nf_conntrack
+	ip netns exec $R conntrack -S
+	ip netns exec $R conntrack -L
+	ip netns exec $S ss -nitepal
 }
 
 rnd=$(mktemp -u XXXXXXXX)
@@ -82,7 +76,7 @@ assert_pass "topo initialization"
 reload_ruleset()
 {
 	ip netns exec $R conntrack -F 2> /dev/null
-	ip netns exec $R nft -f - <<-EOF
+	ip netns exec $R $NFT -f - <<-EOF
 	flush ruleset
 	table ip6 ftp_helper_nat_test {
 		ct helper ftp-standard {
@@ -138,7 +132,8 @@ pam_service_name=vsftpd
 background=YES
 EOF
 ip netns exec $S vsftpd ${FTPCONF}
-sleep 1
+wait_local_port_listen $S 21 tcp
+
 ip netns exec $S ss -6ltnp | grep -q '*:21'
 assert_pass "start vsftpd server"
 
@@ -147,7 +142,7 @@ assert_pass "start vsftpd server"
 reload_ruleset
 ip netns exec $S tcpdump -q --immediate-mode -Ui s_r -w ${PCAP} 2> /dev/null &
 pid=$!
-sleep 1
+sleep 0.5
 ip netns exec $C curl --no-progress-meter --connect-timeout 5 ftp://[${ip_rc}]:2121/$(basename $INFILE) -o $OUTFILE
 assert_pass "curl ftp passive mode "
 
@@ -164,6 +159,7 @@ reload_ruleset
 
 ip netns exec $S tcpdump -q --immediate-mode -Ui s_r -w ${PCAP} 2> /dev/null &
 pid=$!
+sleep 0.5
 ip netns exec $C curl --no-progress-meter -P - --connect-timeout 5 ftp://[${ip_rc}]:2121/$(basename $INFILE) -o $OUTFILE
 assert_pass "curl ftp active mode "
 
diff --git a/tests/shell/testcases/packetpath/rate_limit b/tests/shell/testcases/packetpath/rate_limit
new file mode 100755
index 00000000..84ee5621
--- /dev/null
+++ b/tests/shell/testcases/packetpath/rate_limit
@@ -0,0 +1,137 @@
+#!/bin/bash
+
+# NFT_TEST_REQUIRES(NFT_TEST_HAVE_socat)
+#
+
+. $NFT_TEST_LIBRARY_FILE
+
+cleanup()
+{
+	for i in $C $S;do
+		kill $(ip netns pid $i) 2>/dev/null
+		ip netns del $i
+	done
+}
+trap cleanup EXIT
+
+rnd=$(mktemp -u XXXXXXXX)
+C="ratelimit-client-$rnd"
+S="ratelimit-server-$rnd"
+
+ip_sc=10.167.1.1
+ip_cs=10.167.1.2
+ip1_cs=10.167.1.3
+
+ip netns add $S
+ip netns add $C
+
+ip link add s_c netns $S type veth peer name c_s netns $C
+ip -net $S link set s_c up
+ip -net $C link set c_s up
+ip -net $S link set lo up
+ip -net $C link set lo up
+ip -net $S addr add ${ip_sc}/24  dev s_c
+ip -net $C addr add ${ip_cs}/24  dev c_s
+ip -net $C addr add ${ip1_cs}/24 dev c_s
+ip netns exec $C ping ${ip_sc} -c1
+assert_pass "topo initialization"
+
+ip netns exec $S $NFT -f - <<EOF
+table ip filter {
+	set icmp1 {
+		type ipv4_addr
+		size 65535
+		flags dynamic,timeout
+	}
+
+	set http1 {
+		type inet_service . ipv4_addr
+		size 65535
+		flags dynamic
+	}
+
+	chain input {
+		type filter hook input priority filter; policy accept;
+		ip protocol icmp counter jump in_icmp
+		ip protocol tcp  counter jump in_tcp
+	}
+	chain in_tcp {
+		iifname "s_c" tcp dport 80 ct state new add @http1 { tcp dport . ip saddr limit rate over 1/minute burst 5 packets } counter reject
+		iifname "s_c" tcp dport 80 counter accept
+	}
+
+	chain in_icmp {
+		iifname "s_c" ip protocol icmp counter update @icmp1 { ip saddr timeout 3s limit rate 1/second burst 5 packets } counter accept
+		iifname "s_c" ip protocol icmp counter reject
+	}
+
+}
+EOF
+assert_pass "Apply ruleset"
+
+# icmp test
+ip netns exec $C ping -W 1 ${ip_sc} -c 5 -f -I ${ip_cs} | grep -q '5 received'
+assert_pass "saddr1, burst 5 accept"
+
+ip netns exec $C ping -W 1 ${ip_sc} -c 5 -f -I ${ip1_cs} | grep -q '5 received'
+assert_pass "saddr2, burst 5 accept"
+
+ip netns exec $C ping -W 1 ${ip_sc} -c 1 -f -I ${ip_cs} | grep -q '1 received'
+assert_fail "saddr1, burst 5 up to limit, reject"
+
+sleep 3
+ip netns exec $C ping -W 1 ${ip_sc} -c 5 -f -I ${ip_cs} | grep -q '5 received'
+assert_pass "saddr1, element timeout,burst 5 pass again"
+
+ip netns exec $C ping -W 1 ${ip_sc} -c 1 -f -I ${ip_cs} | grep -q '1 received'
+assert_fail "saddr1, burst 5 up to limit"
+
+ip netns exec $C ping -W 1 ${ip_sc} -c 6 -i 1 -I ${ip1_cs} | grep -q '6 received'
+assert_pass "saddr2, 6s test, limit rate 1/second accept"
+
+ip netns exec $C ping -W 1 ${ip_sc} -c 4 -f -I ${ip1_cs} | grep -q '4 received'
+assert_pass "saddr2, burst 4 accept"
+
+sleep 2
+ip netns exec $C ping -W 1 ${ip_sc} -c 2 -f -I ${ip1_cs} | grep -q '2 received'
+assert_pass "saddr2, burst 2 sleep 2, accept"
+
+sleep 2
+ip netns exec $C ping -W 1 ${ip_sc} -c 2 -f -I ${ip1_cs} | grep -q '2 received'
+assert_pass "saddr2, burst 2 sleep 2, accept"
+
+ip netns exec $C ping -W 1 ${ip_sc} -c 1 -f -I ${ip1_cs} | grep -q '1 received'
+assert_fail "saddr2, limit rate 1/second up to limit, reject"
+
+
+# tcp test
+ip netns exec $S socat TCP-LISTEN:80,reuseaddr,fork - > /dev/null &
+wait_local_port_listen $S 80 tcp
+
+for port in {1..5};do
+	ip netns exec $C socat -u - TCP:${ip_sc}:80,connect-timeout=1 <<< 'AAA'
+	assert_pass "tcp connection burst 5 accept"
+done
+ip netns exec $C socat -u - TCP:${ip_sc}:80,reuseport,connect-timeout=1 <<< 'AAA'
+assert_fail "tcp connection burst 5 up to limit reject"
+
+ip netns exec $S $NFT flush chain filter in_tcp
+assert_pass result "flush chain"
+
+ip netns exec $S $NFT flush set filter http1
+assert_pass result "flush set"
+
+ip netns exec $S $NFT add rule filter in_tcp iifname s_c tcp dport 80 ct state new add @http1 { tcp dport . ip saddr limit rate over 1/second burst 1 packets} counter reject
+assert_pass result "add rule limit rate over 1/second burst 1"
+ip netns exec $S $NFT add rule filter in_tcp iifname s_c tcp dport 80 counter accept
+
+sleep 1
+ip netns exec $C socat -u - TCP:${ip_sc}:80,reuseport,connect-timeout=1 <<< 'AAA'
+assert_pass result "tcp connection limit rate 1/sec burst 1 accept"
+
+ip netns exec $C socat -u - TCP:${ip_sc}:80,reuseport,connect-timeout=1 <<< 'AAA'
+assert_fail result "tcp connection limit rate 1/sec burst 1 reject"
+
+sleep 1
+ip netns exec $C socat -u - TCP:${ip_sc}:80,reuseport,connect-timeout=1 <<< 'AAA'
+assert_pass result "tcp connection limit rate 1/sec burst 1 accept"
-- 
2.49.0

