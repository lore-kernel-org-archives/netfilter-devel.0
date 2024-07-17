Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F27181822F9;
	Wed, 17 Jul 2024 21:52:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721253150; cv=none; b=nDYlEDycM3irviLQ0XeiG/TUSxKjjsgIqQFZH37u33Qjnv8glBjTc/ZUlTgy+lWE2Q9gsfW98LMfFCpiKyo9vMRfgqy6cfWtFJzpZGHPb5TPbFL1VOU8Fm+4f1sa7f4E8yuuKQdC2w0oDmSQxAslq3enM2uXkdeUKZ+w4P8bznI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721253150; c=relaxed/simple;
	bh=IKEADJ2tNUJq0VP+9bqqmHsl7Y8/YjC5GhmCilnuqkg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=MyxR6Vmx7UEJ8r/B/MZC/chD/3Czm6nxD7hIayWW4KHp9yRT5iPp71AiVCpi/e/hkXZnMUpv/Q1Pe9wP/YEoyqNyTz8cbverEyQ0K7xxee89oTODhknk2468u7UbryYEjYPVEIhSW233tAHbIHhKM3o2iBGAM6HTz7nyJaa5Ft4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de
Subject: [PATCH net 3/4] selftests: netfilter: add test case for recent mismatch bug
Date: Wed, 17 Jul 2024 23:52:13 +0200
Message-Id: <20240717215214.225394-4-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20240717215214.225394-1-pablo@netfilter.org>
References: <20240717215214.225394-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Florian Westphal <fw@strlen.de>

Without 'netfilter: nf_set_pipapo: fix initial map fill' this fails:

TEST: reported issues
  Add two elements, flush, re-add       1s                              [ OK ]
  net,mac with reload                   1s                              [ OK ]
  net,port,proto                        1s                              [FAIL]
post-add: should have returned 10.5.8.0/24 . 51-60 . 6-17  but got table inet filter {
        set test {
                type ipv4_addr . inet_service . inet_proto
                flags interval,timeout
                elements = { 10.5.7.0/24 . 51-60 . 6-17 }
        }
}

The other sets defined in the selftest do not trigger this bug, it only
occurs if the first field group bitsize is smaller than the largest
group bitsize.

For each added element, check 'get' works and actually returns the
requested range.
After map has been filled, check all added ranges can still be
retrieved.

For each deleted element, check that 'get' fails.

Based on a reproducer script from Yi Chen.

Signed-off-by: Florian Westphal <fw@strlen.de>
Reviewed-by: Stefano Brivio <sbrivio@redhat.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 .../net/netfilter/nft_concat_range.sh         | 76 ++++++++++++++++++-
 1 file changed, 75 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/netfilter/nft_concat_range.sh b/tools/testing/selftests/net/netfilter/nft_concat_range.sh
index 6d66240e149c..47088b005390 100755
--- a/tools/testing/selftests/net/netfilter/nft_concat_range.sh
+++ b/tools/testing/selftests/net/netfilter/nft_concat_range.sh
@@ -27,7 +27,7 @@ TYPES="net_port port_net net6_port port_proto net6_port_mac net6_port_mac_proto
        net6_port_net6_port net_port_mac_proto_net"
 
 # Reported bugs, also described by TYPE_ variables below
-BUGS="flush_remove_add reload"
+BUGS="flush_remove_add reload net_port_proto_match"
 
 # List of possible paths to pktgen script from kernel tree for performance tests
 PKTGEN_SCRIPT_PATHS="
@@ -371,6 +371,22 @@ race_repeat	0
 perf_duration	0
 "
 
+TYPE_net_port_proto_match="
+display		net,port,proto
+type_spec	ipv4_addr . inet_service . inet_proto
+chain_spec	ip daddr . udp dport . meta l4proto
+dst		addr4 port proto
+src
+start		1
+count		9
+src_delta	9
+tools		sendip bash
+proto		udp
+
+race_repeat	0
+
+perf_duration	0
+"
 # Set template for all tests, types and rules are filled in depending on test
 set_template='
 flush ruleset
@@ -1555,6 +1571,64 @@ test_bug_reload() {
 	nft flush ruleset
 }
 
+# - add ranged element, check that packets match it
+# - delete element again, check it is gone
+test_bug_net_port_proto_match() {
+	setup veth send_"${proto}" set || return ${ksft_skip}
+	rstart=${start}
+
+	range_size=1
+	for i in $(seq 1 10); do
+		for j in $(seq 1 20) ; do
+			elem=$(printf "10.%d.%d.0/24 . %d1-%d0 . 6-17 " ${i} ${j} ${i} "$((i+1))")
+
+			nft "add element inet filter test { $elem }" || return 1
+			nft "get element inet filter test { $elem }" | grep -q "$elem"
+			if [ $? -ne 0 ];then
+				local got=$(nft "get element inet filter test { $elem }")
+				err "post-add: should have returned $elem but got $got"
+				return 1
+			fi
+		done
+	done
+
+	# recheck after set was filled
+	for i in $(seq 1 10); do
+		for j in $(seq 1 20) ; do
+			elem=$(printf "10.%d.%d.0/24 . %d1-%d0 . 6-17 " ${i} ${j} ${i} "$((i+1))")
+
+			nft "get element inet filter test { $elem }" | grep -q "$elem"
+			if [ $? -ne 0 ];then
+				local got=$(nft "get element inet filter test { $elem }")
+				err "post-fill: should have returned $elem but got $got"
+				return 1
+			fi
+		done
+	done
+
+	# random del and re-fetch
+	for i in $(seq 1 10); do
+		for j in $(seq 1 20) ; do
+			local rnd=$((RANDOM%10))
+			local got=""
+
+			elem=$(printf "10.%d.%d.0/24 . %d1-%d0 . 6-17 " ${i} ${j} ${i} "$((i+1))")
+			if [ $rnd -gt 0 ];then
+				continue
+			fi
+
+			nft "delete element inet filter test { $elem }"
+			got=$(nft "get element inet filter test { $elem }" 2>/dev/null)
+			if [ $? -eq 0 ];then
+				err "post-delete: query for $elem returned $got instead of error."
+				return 1
+			fi
+		done
+	done
+
+	nft flush ruleset
+}
+
 test_reported_issues() {
 	eval test_bug_"${subtest}"
 }
-- 
2.30.2

