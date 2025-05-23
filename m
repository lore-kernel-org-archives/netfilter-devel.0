Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B05EC234971
	for <netfilter-devel@vger.kernel.org>; Fri, 23 May 2025 12:21:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748002899; cv=none; b=lBy5DGH0qctxLaZsQYT1XpXQPz+Qef9b42nO0jraOjW7ibzcNjx/LMhSoNwRPckQhQL1PHC0I4UnXMAbNBtRhZ98DHFMbVM3yf1++HWbTM2kX1FuJ+Ivhjf3uROeC8iO01QGWpYMOSVOfHTfWx21aeWOZvDxl/oPr5kRQR7VPv8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748002899; c=relaxed/simple;
	bh=37mgxlcG7eYR4XgrowwrMNc8IE3713CtWJ98rgLNoG4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uTe1pBZxwwVNs07iCVmvf2H+M7GmPuy58RkZiZBgpszyix4G5qrNaAXO2M8K5iUvLcQyCCJ0VxXHNAAsqQaOj/phW/a2vGsGy7fNCsDkdXkvrBcFvtagPdYpMRQMEv2Rb26jr9EPcVv1sezeru7Rk3npjnbkITua/59KV0BRLdc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 2E79860371; Fri, 23 May 2025 14:21:36 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: sbrivio@redhat.com,
	Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next 3/3] selftests: netfilter: nft_concat_range.sh: add datapath check for map fill bug
Date: Fri, 23 May 2025 14:20:46 +0200
Message-ID: <20250523122051.20315-4-fw@strlen.de>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250523122051.20315-1-fw@strlen.de>
References: <20250523122051.20315-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

commit 0935ee6032df ("selftests: netfilter: add test case for recent mismatch bug")
added a regression check for incorrect initial fill of the result map
that was fixed with 791a615b7ad2 ("netfilter: nf_set_pipapo: fix initial map fill").

The test used 'nft get element', i.e., control plane checks for
match/nomatch results.

The control plane however doesn't use avx2 version, so we need to
send+match packets.

As the additional packet match/nomatch is slow, don't do this for
every element added/removed: add and use maybe_send_(no)match
helpers and use them.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 .../net/netfilter/nft_concat_range.sh         | 62 +++++++++++++++++--
 1 file changed, 58 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/net/netfilter/nft_concat_range.sh b/tools/testing/selftests/net/netfilter/nft_concat_range.sh
index 86b8ce742700..cd12b8b5ac0e 100755
--- a/tools/testing/selftests/net/netfilter/nft_concat_range.sh
+++ b/tools/testing/selftests/net/netfilter/nft_concat_range.sh
@@ -378,7 +378,7 @@ display		net,port,proto
 type_spec	ipv4_addr . inet_service . inet_proto
 chain_spec	ip daddr . udp dport . meta l4proto
 dst		addr4 port proto
-src
+src		 
 start		1
 count		9
 src_delta	9
@@ -1269,6 +1269,42 @@ send_nomatch() {
 	fi
 }
 
+maybe_send_nomatch() {
+	local elem="$1"
+	local what="$4"
+
+	[ $((RANDOM%20)) -gt 0 ] && return
+
+	dst_addr4="$2"
+	dst_port="$3"
+	send_udp
+
+	if [ "$(count_packets_nomatch)" != "0" ]; then
+		err "Packet to $dst_addr4:$dst_port did match $what"
+		err "$(nft -a list ruleset)"
+		return 1
+	fi
+}
+
+maybe_send_match() {
+	local elem="$1"
+	local what="$4"
+
+	[ $((RANDOM%20)) -gt 0 ] && return
+
+	dst_addr4="$2"
+	dst_port="$3"
+	send_udp
+
+	if [ "$(count_packets "{ $elem }")" != "1" ]; then
+		err "Packet to $dst_addr4:$dst_port did not match $what"
+		err "$(nft -a list ruleset)"
+		return 1
+	fi
+	nft reset counter inet filter test >/dev/null
+	nft reset element inet filter test "{ $elem }" >/dev/null
+}
+
 # Correctness test template:
 # - add ranged element, check that packets match it
 # - check that packets outside range don't match it
@@ -1776,22 +1812,34 @@ test_bug_net_port_proto_match() {
 	range_size=1
 	for i in $(seq 1 10); do
 		for j in $(seq 1 20) ; do
-			elem=$(printf "10.%d.%d.0/24 . %d1-%d0 . 6-17 " ${i} ${j} ${i} "$((i+1))")
+			local dport=$j
+
+			elem=$(printf "10.%d.%d.0/24 . %d-%d0 . 6-17 " ${i} ${j} ${dport} "$((dport+1))")
+
+			# too slow, do not test all addresses
+			maybe_send_nomatch "$elem" $(printf "10.%d.%d.1" $i $j) $(printf "%d1" $((dport+1))) "before add" || return 1
 
 			nft "add element inet filter test { $elem }" || return 1
+
+			maybe_send_match "$elem" $(printf "10.%d.%d.1" $i $j) $(printf "%d" $dport) "after add" || return 1
+
 			nft "get element inet filter test { $elem }" | grep -q "$elem"
 			if [ $? -ne 0 ];then
 				local got=$(nft "get element inet filter test { $elem }")
 				err "post-add: should have returned $elem but got $got"
 				return 1
 			fi
+
+			maybe_send_nomatch "$elem" $(printf "10.%d.%d.1" $i $j) $(printf "%d1" $((dport+1))) "out-of-range" || return 1
 		done
 	done
 
 	# recheck after set was filled
 	for i in $(seq 1 10); do
 		for j in $(seq 1 20) ; do
-			elem=$(printf "10.%d.%d.0/24 . %d1-%d0 . 6-17 " ${i} ${j} ${i} "$((i+1))")
+			local dport=$j
+
+			elem=$(printf "10.%d.%d.0/24 . %d-%d0 . 6-17 " ${i} ${j} ${dport} "$((dport+1))")
 
 			nft "get element inet filter test { $elem }" | grep -q "$elem"
 			if [ $? -ne 0 ];then
@@ -1799,6 +1847,9 @@ test_bug_net_port_proto_match() {
 				err "post-fill: should have returned $elem but got $got"
 				return 1
 			fi
+
+			maybe_send_match "$elem" $(printf "10.%d.%d.1" $i $j) $(printf "%d" $dport) "recheck" || return 1
+			maybe_send_nomatch "$elem" $(printf "10.%d.%d.1" $i $j) $(printf "%d1" $((dport+1))) "recheck out-of-range" || return 1
 		done
 	done
 
@@ -1806,9 +1857,10 @@ test_bug_net_port_proto_match() {
 	for i in $(seq 1 10); do
 		for j in $(seq 1 20) ; do
 			local rnd=$((RANDOM%10))
+			local dport=$j
 			local got=""
 
-			elem=$(printf "10.%d.%d.0/24 . %d1-%d0 . 6-17 " ${i} ${j} ${i} "$((i+1))")
+			elem=$(printf "10.%d.%d.0/24 . %d-%d0 . 6-17 " ${i} ${j} ${dport} "$((dport+1))")
 			if [ $rnd -gt 0 ];then
 				continue
 			fi
@@ -1819,6 +1871,8 @@ test_bug_net_port_proto_match() {
 				err "post-delete: query for $elem returned $got instead of error."
 				return 1
 			fi
+
+			maybe_send_nomatch "$elem" $(printf "10.%d.%d.1" $i $j) $(printf "%d" $dport) "match after deletion" || return 1
 		done
 	done
 
-- 
2.49.0

