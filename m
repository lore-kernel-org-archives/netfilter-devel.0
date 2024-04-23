Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58558762E8;
	Tue, 23 Apr 2024 11:11:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713870677; cv=none; b=Ox127E4RsjZQXN1cIqHn7rXrKuEDSsgajrAHV2lLra/1Rv4hjRE4OyJQ7hKkDXxJxK8ozY4PEL5ZtmrGhe9T9yWisNLHJPw7E5FPm5WiLvMFoRYCTMhcKG+YFpODVxdVgApi8YoVUL5CjrWEqH+ahqFGYOwZONhJ7o2IuyxPGhE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713870677; c=relaxed/simple;
	bh=6bIBYt6pyjgUQIF4j+Wlh43GvARIJXv97mYjiDxfHmE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D0jAfLJTRNypiJOa6FGdQpoBxum9gvE183njJzu+sT1B5nokctnf6lthZenPTYr4TGgbAouBb/sgS/z6svmrxhGkWikKRwjjeWEUQza59LXJKj6+LmX/NY4VqOYgtGbM2Jw4Wmt3LrFTrVNWF/zP4pCCm8k5W4t+MSRuIKM8Xkg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1rzE3F-0006vJ-OK; Tue, 23 Apr 2024 13:11:05 +0200
From: Florian Westphal <fw@strlen.de>
To: <netdev@vger.kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	<netfilter-devel@vger.kernel.org>,
	pablo@netfilter.org
Subject: [PATCH net-next 1/7] selftests: netfilter: nft_concat_range.sh: move to lib.sh infra
Date: Tue, 23 Apr 2024 15:05:44 +0200
Message-ID: <20240423130604.7013-2-fw@strlen.de>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240423130604.7013-1-fw@strlen.de>
References: <20240423130604.7013-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Use busywait helper instead of unconditional sleep, reduces run time
from 6m to 2:30 on my system.

The busywait helper calls the function passed to it as argument; disable
the shellcheck test for unreachable code, it generates many (false)
warnings here.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 .../net/netfilter/nft_concat_range.sh         | 62 +++++++++++--------
 1 file changed, 37 insertions(+), 25 deletions(-)

diff --git a/tools/testing/selftests/net/netfilter/nft_concat_range.sh b/tools/testing/selftests/net/netfilter/nft_concat_range.sh
index e908009576c7..877c9d3777d2 100755
--- a/tools/testing/selftests/net/netfilter/nft_concat_range.sh
+++ b/tools/testing/selftests/net/netfilter/nft_concat_range.sh
@@ -1,4 +1,4 @@
-#!/bin/sh
+#!/bin/bash
 # SPDX-License-Identifier: GPL-2.0
 #
 # nft_concat_range.sh - Tests for sets with concatenation of ranged fields
@@ -7,10 +7,10 @@
 #
 # Author: Stefano Brivio <sbrivio@redhat.com>
 #
-# shellcheck disable=SC2154,SC2034,SC2016,SC2030,SC2031
+# shellcheck disable=SC2154,SC2034,SC2016,SC2030,SC2031,SC2317
 # ^ Configuration and templates sourced with eval, counters reused in subshells
 
-KSELFTEST_SKIP=4
+source lib.sh
 
 # Available test groups:
 # - reported_issues: check for issues that were reported in the past
@@ -473,8 +473,6 @@ setup_veth() {
 	B() {
 		ip netns exec B "$@" >/dev/null 2>&1
 	}
-
-	sleep 2
 }
 
 # Fill in set template and initialise set
@@ -679,10 +677,17 @@ setup_send_udp6() {
 	fi
 }
 
+listener_ready()
+{
+	port="$1"
+	ss -lnt -o "sport = :$port" | grep -q "$port"
+}
+
 # Set up function to send TCP traffic on IPv4
 setup_flood_tcp() {
 	if command -v iperf3 >/dev/null; then
 		flood_tcp() {
+			local n_port="${dst_port}"
 			[ -n "${dst_port}" ] && dst_port="-p ${dst_port}"
 			if [ -n "${src_addr4}" ]; then
 				B ip addr add "${src_addr4}/16" dev veth_b
@@ -699,7 +704,7 @@ setup_flood_tcp() {
 
 			# shellcheck disable=SC2086 # this needs split options
 			iperf3 -s -DB "${dst_addr4}" ${dst_port} >/dev/null 2>&1
-			sleep 2
+			busywait "$BUSYWAIT_TIMEOUT" listener_ready "$n_port"
 
 			# shellcheck disable=SC2086 # this needs split options
 			B iperf3 -c "${dst_addr4}" ${dst_port} ${src_port} \
@@ -711,6 +716,7 @@ setup_flood_tcp() {
 		}
 	elif command -v iperf >/dev/null; then
 		flood_tcp() {
+			local n_port="${dst_port}"
 			[ -n "${dst_port}" ] && dst_port="-p ${dst_port}"
 			if [ -n "${src_addr4}" ]; then
 				B ip addr add "${src_addr4}/16" dev veth_b
@@ -727,7 +733,7 @@ setup_flood_tcp() {
 
 			# shellcheck disable=SC2086 # this needs split options
 			iperf -s -DB "${dst_addr4}" ${dst_port} >/dev/null 2>&1
-			sleep 2
+			busywait "$BUSYWAIT_TIMEOUT" listener_ready "$n_port"
 
 			# shellcheck disable=SC2086 # this needs split options
 			B iperf -c "${dst_addr4}" ${dst_port} ${src_addr4} \
@@ -739,6 +745,7 @@ setup_flood_tcp() {
 		}
 	elif command -v netperf >/dev/null; then
 		flood_tcp() {
+			local n_port="${dst_port}"
 			[ -n "${dst_port}" ] && dst_port="-p ${dst_port}"
 			if [ -n "${src_addr4}" ]; then
 				B ip addr add "${src_addr4}/16" dev veth_b
@@ -755,7 +762,7 @@ setup_flood_tcp() {
 			# shellcheck disable=SC2086 # this needs split options
 			netserver -4 ${dst_port} -L "${dst_addr4}" \
 				>/dev/null 2>&1
-			sleep 2
+			busywait "$BUSYWAIT_TIMEOUT" listener_ready "${n_port}"
 
 			# shellcheck disable=SC2086 # this needs split options
 			B netperf -4 -H "${dst_addr4}" ${dst_port} \
@@ -774,6 +781,7 @@ setup_flood_tcp() {
 setup_flood_tcp6() {
 	if command -v iperf3 >/dev/null; then
 		flood_tcp6() {
+			local n_port="${dst_port}"
 			[ -n "${dst_port}" ] && dst_port="-p ${dst_port}"
 			if [ -n "${src_addr6}" ]; then
 				B ip addr add "${src_addr6}" dev veth_b nodad
@@ -790,7 +798,7 @@ setup_flood_tcp6() {
 
 			# shellcheck disable=SC2086 # this needs split options
 			iperf3 -s -DB "${dst_addr6}" ${dst_port} >/dev/null 2>&1
-			sleep 2
+			busywait "$BUSYWAIT_TIMEOUT" listener_ready "${n_port}"
 
 			# shellcheck disable=SC2086 # this needs split options
 			B iperf3 -c "${dst_addr6}" ${dst_port} \
@@ -802,6 +810,7 @@ setup_flood_tcp6() {
 		}
 	elif command -v iperf >/dev/null; then
 		flood_tcp6() {
+			local n_port="${dst_port}"
 			[ -n "${dst_port}" ] && dst_port="-p ${dst_port}"
 			if [ -n "${src_addr6}" ]; then
 				B ip addr add "${src_addr6}" dev veth_b nodad
@@ -818,7 +827,7 @@ setup_flood_tcp6() {
 
 			# shellcheck disable=SC2086 # this needs split options
 			iperf -s -VDB "${dst_addr6}" ${dst_port} >/dev/null 2>&1
-			sleep 2
+			busywait "$BUSYWAIT_TIMEOUT" listener_ready "$n_port"
 
 			# shellcheck disable=SC2086 # this needs split options
 			B iperf -c "${dst_addr6}" -V ${dst_port} \
@@ -830,6 +839,7 @@ setup_flood_tcp6() {
 		}
 	elif command -v netperf >/dev/null; then
 		flood_tcp6() {
+			local n_port="${dst_port}"
 			[ -n "${dst_port}" ] && dst_port="-p ${dst_port}"
 			if [ -n "${src_addr6}" ]; then
 				B ip addr add "${src_addr6}" dev veth_b nodad
@@ -846,7 +856,7 @@ setup_flood_tcp6() {
 			# shellcheck disable=SC2086 # this needs split options
 			netserver -6 ${dst_port} -L "${dst_addr6}" \
 				>/dev/null 2>&1
-			sleep 2
+			busywait "$BUSYWAIT_TIMEOUT" listener_ready "$n_port"
 
 			# shellcheck disable=SC2086 # this needs split options
 			B netperf -6 -H "${dst_addr6}" ${dst_port} \
@@ -865,6 +875,7 @@ setup_flood_tcp6() {
 setup_flood_udp() {
 	if command -v iperf3 >/dev/null; then
 		flood_udp() {
+			local n_port="${dst_port}"
 			[ -n "${dst_port}" ] && dst_port="-p ${dst_port}"
 			if [ -n "${src_addr4}" ]; then
 				B ip addr add "${src_addr4}/16" dev veth_b
@@ -881,7 +892,7 @@ setup_flood_udp() {
 
 			# shellcheck disable=SC2086 # this needs split options
 			iperf3 -s -DB "${dst_addr4}" ${dst_port}
-			sleep 2
+			busywait "$BUSYWAIT_TIMEOUT" listener_ready "$n_port"
 
 			# shellcheck disable=SC2086 # this needs split options
 			B iperf3 -u -c "${dst_addr4}" -Z -b 100M -l16 -t1000 \
@@ -893,6 +904,7 @@ setup_flood_udp() {
 		}
 	elif command -v iperf >/dev/null; then
 		flood_udp() {
+			local n_port="${dst_port}"
 			[ -n "${dst_port}" ] && dst_port="-p ${dst_port}"
 			if [ -n "${src_addr4}" ]; then
 				B ip addr add "${src_addr4}/16" dev veth_b
@@ -909,7 +921,7 @@ setup_flood_udp() {
 
 			# shellcheck disable=SC2086 # this needs split options
 			iperf -u -sDB "${dst_addr4}" ${dst_port} >/dev/null 2>&1
-			sleep 2
+			busywait "$BUSYWAIT_TIMEOUT" listener_ready "$n_port"
 
 			# shellcheck disable=SC2086 # this needs split options
 			B iperf -u -c "${dst_addr4}" -b 100M -l1 -t1000 \
@@ -921,6 +933,7 @@ setup_flood_udp() {
 		}
 	elif command -v netperf >/dev/null; then
 		flood_udp() {
+			local n_port="${dst_port}"
 			[ -n "${dst_port}" ] && dst_port="-p ${dst_port}"
 			if [ -n "${src_addr4}" ]; then
 				B ip addr add "${src_addr4}/16" dev veth_b
@@ -937,7 +950,7 @@ setup_flood_udp() {
 			# shellcheck disable=SC2086 # this needs split options
 			netserver -4 ${dst_port} -L "${dst_addr4}" \
 				>/dev/null 2>&1
-			sleep 2
+			busywait "$BUSYWAIT_TIMEOUT" listener_ready "$n_port"
 
 			# shellcheck disable=SC2086 # this needs split options
 			B netperf -4 -H "${dst_addr4}" ${dst_port} \
@@ -990,14 +1003,13 @@ cleanup() {
 	killall netperf				2>/dev/null
 	killall netserver			2>/dev/null
 	rm -f ${tmp}
-	sleep 2
 }
 
 # Entry point for setup functions
 setup() {
 	if [ "$(id -u)" -ne 0 ]; then
 		echo "  need to run as root"
-		exit ${KSELFTEST_SKIP}
+		exit ${ksft_skip}
 	fi
 
 	cleanup
@@ -1258,7 +1270,7 @@ send_nomatch() {
 # - check that packets outside range don't match it
 # - remove some elements, check that packets don't match anymore
 test_correctness() {
-	setup veth send_"${proto}" set || return ${KSELFTEST_SKIP}
+	setup veth send_"${proto}" set || return ${ksft_skip}
 
 	range_size=1
 	for i in $(seq "${start}" $((start + count))); do
@@ -1307,7 +1319,7 @@ test_concurrency() {
 	proto=${flood_proto}
 	tools=${flood_tools}
 	chain_spec=${flood_spec}
-	setup veth flood_"${proto}" set || return ${KSELFTEST_SKIP}
+	setup veth flood_"${proto}" set || return ${ksft_skip}
 
 	range_size=1
 	cstart=${start}
@@ -1325,7 +1337,7 @@ test_concurrency() {
 		start=$((end + range_size))
 	done
 
-	sleep 10
+	sleep $((RANDOM%10))
 
 	pids=
 	for c in $(seq 1 "$(nproc)"); do (
@@ -1407,7 +1419,7 @@ test_concurrency() {
 # - add all the elements with 3s timeout while checking that packets match
 # - wait 3s after the last insertion, check that packets don't match any entry
 test_timeout() {
-	setup veth send_"${proto}" set || return ${KSELFTEST_SKIP}
+	setup veth send_"${proto}" set || return ${ksft_skip}
 
 	timeout=3
 	range_size=1
@@ -1450,7 +1462,7 @@ test_performance() {
 	chain_spec=${perf_spec}
 	dst="${perf_dst}"
 	src="${perf_src}"
-	setup veth perf set || return ${KSELFTEST_SKIP}
+	setup veth perf set || return ${ksft_skip}
 
 	first=${start}
 	range_size=1
@@ -1523,7 +1535,7 @@ test_bug_flush_remove_add() {
 	elem1='{ 10.0.0.1 . 22-25, 10.0.0.1 . 10-20 }'
 	elem2='{ 10.0.0.1 . 10-20, 10.0.0.1 . 22-25 }'
 	for i in `seq 1 100`; do
-		nft add table t ${set_cmd}	|| return ${KSELFTEST_SKIP}
+		nft add table t ${set_cmd}	|| return ${ksft_skip}
 		nft add element t s ${elem1}	2>/dev/null || return 1
 		nft flush set t s		2>/dev/null || return 1
 		nft add element t s ${elem2}	2>/dev/null || return 1
@@ -1534,7 +1546,7 @@ test_bug_flush_remove_add() {
 # - add ranged element, check that packets match it
 # - reload the set, check packets still match
 test_bug_reload() {
-	setup veth send_"${proto}" set || return ${KSELFTEST_SKIP}
+	setup veth send_"${proto}" set || return ${ksft_skip}
 	rstart=${start}
 
 	range_size=1
@@ -1635,11 +1647,11 @@ for name in ${TESTS}; do
 			printf "[FAIL]\n"
 			err_flush
 			exit 1
-		elif [ $ret -eq ${KSELFTEST_SKIP} ]; then
+		elif [ $ret -eq ${ksft_skip} ]; then
 			printf "[SKIP]\n"
 			err_flush
 		fi
 	done
 done
 
-[ ${passed} -eq 0 ] && exit ${KSELFTEST_SKIP} || exit 0
+[ ${passed} -eq 0 ] && exit ${ksft_skip} || exit 0
-- 
2.43.2

