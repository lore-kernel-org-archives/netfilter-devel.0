Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82DAB20E334;
	Thu,  5 Jun 2025 08:57:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749113871; cv=none; b=crJhRtXTuy4BUTrVA0rSxjB1VCHduttgoqOepe38VAfwN/64jLy7uKkvPJMh0JoLEKC1A+/eBPzaxw6cr+Rfuglspmm7cFnrhIZhkq4/TtE1+0Gxl/b6mQD5Pa1YQCoMcPXePp39KqCDJvQlp+6qb8qIfhbrBx2rzdwDM8w3Td8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749113871; c=relaxed/simple;
	bh=3k7loa7FwpD+HksOyDpBuUMBWur1CM0CDn38JzW7abY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Cc3Ll0Zc9jWyqMaWQ0xfTUvd4L2oA5RhzLeBQpWJAnn2IPMKdxUW73Ics68ZgNl5AwHjUrxfWHZ6j+PWCgxTAv6SQM2QhI17jaeWfPLsRvITuKTDzUdjRBHqzhObvUNClE6BXQrfssTI3JtQJ1AdlZEsU9MSBOaetbEaveYnvhQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=bYVfveT5; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=EEE64MSM; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="bYVfveT5";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="EEE64MSM"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 9EFCE60753; Thu,  5 Jun 2025 10:57:47 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1749113867;
	bh=ET9rWgLx8st+2tQyLAgBHdR9XZ9oppxVMy8l4pULz4o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bYVfveT5eaPZEk4EX/OLCiJid6OwzEZF0cd34amtKRWoxg3pFg0vBZWMoDrfiJ5/V
	 oBdndgzalxQ7lsNPCFjqnJnlZPSpz4VPlPE6j/+Qe7SfycQnTI94mtthLbAuNQsquM
	 AxkbeTKfMwb9DU9SdYv6d0YtzGBhPbaWF6QHgULZSK7Dn8jaw8PE0Umw0MuPwpxBHp
	 rPsyGx+OaWBHg7cfGynZwX3rvF+VTm9bApMwsBrdwo6u1crqdl9AibtE8KWnZ+m4DS
	 qjacq4noggUDFWTezoAUkAxoAlGPauSEADpPL1tu8U60SYbW3hiYYNM/t/zhZa2tSv
	 T1IwqLTD4hDpg==
X-Spam-Level: 
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 853D36075D;
	Thu,  5 Jun 2025 10:57:41 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1749113861;
	bh=ET9rWgLx8st+2tQyLAgBHdR9XZ9oppxVMy8l4pULz4o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EEE64MSMsF4IzCumcpFobGY21UGyyANB0KpLzaioLToYwsKStYi0aRsVJNmAee3Zt
	 atXHt/Dq2uOEeWlYMpyO1ZU+LJxJ1jZxdlfzX4HkhtTGHSyzeqICLdTV8EzLZMbyjw
	 +1rY585Fike3j78TM3YG/SQKF6Q0fG10NF/k/8nhl545XBSttleOcwIKYp+lF+3z/c
	 q1dE37gSdzD7zig7hzysm3f5Q6dTPvtok8Q+udAHfYLMYg7nyAK4ceBhhDfha7TGAC
	 v+WCFS+XmjE+axEK+KBd7xHI52FtIrCiHEr9dADgWWYX6TuG6A+oC/YJf/cGIgHzuM
	 aYaM67wKN+MwQ==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net 3/5] selftests: netfilter: nft_concat_range.sh: add datapath check for map fill bug
Date: Thu,  5 Jun 2025 10:57:33 +0200
Message-Id: <20250605085735.52205-4-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20250605085735.52205-1-pablo@netfilter.org>
References: <20250605085735.52205-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Florian Westphal <fw@strlen.de>

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
Reviewed-by: Stefano Brivio <sbrivio@redhat.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
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
2.30.2

