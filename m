Received: from mail-ej1-f74.google.com (mail-ej1-f74.google.com [209.85.218.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FE372D5C97
	for <netfilter-devel@vger.kernel.org>; Mon, 20 Oct 2025 20:08:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760990905; cv=none; b=GfYHWd9aornY6ZPsQvWqPdTTN+vaYH5mrop7cXzF6PsEo5OvhOm0uFsVX/2yJ6LWh2/I5uUvxWiO8xuNqHuEAWpooZzHPL9mbcv2PtAJCTV0k9+iP1fLk0yr6pn7BiRrDBURwYJZ0Km+KhlMGvSJ37Dn2Ql04AbOQ+/0Vvirvbc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760990905; c=relaxed/simple;
	bh=zURTeIHBW5ftWZY09gq+mVzIZl1SiPncBm3alHObpAw=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=qzUWhFi5b3UPYDe033AiKGn1eS07SY63QdHflvRRie1P7iL6IhcVQDiSM8AijtyeDC+P5nzAsQZLoVGcWQVEbgNv0JYy7rzz44JdWnWBwJYRqWQq+NzVE1aq7ATUvb1HLKso6khAMxdrFczGbf3FvA1dpXcwBdXNvNubK89YZ/4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--aojea.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=HuGx11dw; arc=none smtp.client-ip=209.85.218.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--aojea.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="HuGx11dw"
Received: by mail-ej1-f74.google.com with SMTP id a640c23a62f3a-b2f9dc3264bso618751366b.1
        for <netfilter-devel@vger.kernel.org>; Mon, 20 Oct 2025 13:08:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760990901; x=1761595701; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=bKhYJeF16S2bkTsKsSx6CwQi1R/OempZEm57sbUonOw=;
        b=HuGx11dwjDGm1aURlavM4q/cJGH7IjeEmafbfp17D3AMeeyLfsQO2uTNAW9g7gWdN4
         xKP3smENXmXdR/qXQwigY+7Cd/stYY3rvZN7gvpya67MjFLOoSjpiLykx1BJqeK1FMr8
         RIXPQ1d0X4rUJVsYD+qSmMO9QwYfnqgdw672x5cMjCYri7pKI751hiC3xeSGB9OC90mO
         jns8vuYnIFxvGoV8z/cN75KWGbXvsVAPUBSJ/KPJyYGKEjU9+uZpb0qcqT+GvG80wfrt
         XIU7Dz3MJ7Nr+kv4Y0lJ6NJJjtIznwt2+YyzyDTHIx4SiuHVal2GFUaV0xxa/tMCRh1O
         dx/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760990901; x=1761595701;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=bKhYJeF16S2bkTsKsSx6CwQi1R/OempZEm57sbUonOw=;
        b=OLaWz4dyw1xhgOreI5nqslDpd9J3g2AGx+db09WfBLr/fVgKgTC5YQt0Cn+NFLMT0s
         XdGiz8AqyRxwWEl/mvcWcOBF8rvrW2+O5dR9bqbdoYwT7AkEozojaSjLsigzVWqW9cXg
         +eaVb3x5lWr/8t1wcREeVB+s5Ob/uwubGCR86ID7prErMI9fsk6oXPRwNumUAT1VtyFN
         1xfAuK3cmLVQHnkr4bJTHTebKzgoqZM5lak/jm4myFfSqXgduxkaA9XeKHqhqfFJklwc
         o1y0/8K4zKbaiSyydF3H3cJFN1YWkWQBjmkxYmOKa1H3VvLRmlctUzi/aP8H+FIlfRjm
         N/tQ==
X-Forwarded-Encrypted: i=1; AJvYcCUwA0SKGuXNjXv9kR9WxXoZ6yCegm5+6r/1h1yjnsTY5BebBGEEJku+WeEa/MwcMnOKHrBUrYRdDX3I6feeoI8=@vger.kernel.org
X-Gm-Message-State: AOJu0YwxcjAC166cm1V03WPiqzUX5ZmuaC6rqXCUt0bxjvs8V9yWQm2n
	dJr53JCHbrkIhml3TWuiWkfXDuBox/+OVKeTMAyVkCT4kSHOc2G2PSMvsdswaV9ftJld7//Mb3y
	lww==
X-Google-Smtp-Source: AGHT+IF+ednC79fM+c5eqSJAtfD6t8LrIzIQ/r6fMKGEZjvEUBYiSSbztjlhlpvYuD4H3o41OuNNlNWQfQ==
X-Received: from ejblz18.prod.google.com ([2002:a17:906:fb12:b0:b3f:8618:f2cb])
 (user=aojea job=prod-delivery.src-stubby-dispatcher) by 2002:a17:907:86a2:b0:b3e:6091:2c7d
 with SMTP id a640c23a62f3a-b6473630a96mr1591519866b.27.1760990900743; Mon, 20
 Oct 2025 13:08:20 -0700 (PDT)
Date: Mon, 20 Oct 2025 20:08:05 +0000
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.51.0.869.ge66316f041-goog
Message-ID: <20251020200805.298670-1-aojea@google.com>
Subject: [PATCH] selftests: nft_queue: conntrack expiration requeue
From: Antonio Ojea <aojea@google.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>, Florian Westphal <fw@strlen.de>
Cc: Eric Dumazet <edumazet@google.com>, netfilter-devel@vger.kernel.org, 
	Antonio Ojea <aojea@google.com>
Content-Type: text/plain; charset="UTF-8"

The nfqueue mechanism allows userspace daemons to implement complex,
dynamic filtering rules. This is particularly useful in distributed
platforms like Kubernetes, where security policies may be too numerous
or change too frequently (in the order of seconds) to be implemented
efficiently in the dataplane.

To avoid the performance penalty of crossing between kernel and
userspace for every packet, a common optimization is to use stateful
nftables rules (e.g., ct state established,related accept) to bypass the
queue for packets belonging to known flows.

However, if there is the need to reevaluate the established connections
using the existing rules, we should have a way to stop tracking the
connections so they are sent back to the queue for reevaluation.

Simply flushing the conntrack entries does not work for TCP if tcp_loose
is enabled, since the conntrack stack will recover the connection
state. Setting the conntrack entry timeout to 0 allows to remove the state
and the packet is sent to the queue.

This tests validates this scenario, it establish a TCP connection,
confirms that established packets bypass the queue, and that after
setting the conntrack entry timeout to 0 subsequent packets are
requeued.

Signed-off-by: Antonio Ojea <aojea@google.com>
---
 .../selftests/net/netfilter/nft_queue.sh      | 75 +++++++++++++++++++
 1 file changed, 75 insertions(+)

diff --git a/tools/testing/selftests/net/netfilter/nft_queue.sh b/tools/testing/selftests/net/netfilter/nft_queue.sh
index 6136ceec45e0..b25f0e23ce3d 100755
--- a/tools/testing/selftests/net/netfilter/nft_queue.sh
+++ b/tools/testing/selftests/net/netfilter/nft_queue.sh
@@ -28,8 +28,10 @@ cleanup()
 
 checktool "nft --version" "test without nft tool"
 checktool "socat -h" "run test without socat"
+checktool "conntrack -V" "run test without conntrack tool"
 
 modprobe -q sctp
+modprobe -q nf_conntrack
 
 trap cleanup EXIT
 
@@ -353,6 +355,78 @@ EOF
 	echo "PASS: tcp via loopback and re-queueing"
 }
 
+test_tcp_conntrack_timeout_requeue()
+{
+	# Set up initial nftables ruleset.
+	ip netns exec "$nsrouter" nft -f /dev/stdin <<EOF
+flush ruleset
+table inet filter {
+	chain post {
+		type filter hook postrouting priority 0; policy accept;
+		ct state established,related counter accept
+		tcp dport 12345 counter queue num 10
+	}
+}
+EOF
+	if [ $? -ne 0 ]; then
+		echo "FAIL: Failed to apply initial nftables rules."
+		exit 1
+	fi
+
+	# Start server in the background
+	ip netns exec "$ns2" socat -u TCP4-LISTEN:12345,fork STDOUT > "$TMPFILE1" 2>/dev/null &
+	local server_pid=$!
+	busywait "$BUSYWAIT_TIMEOUT" listener_ready "$ns2" "12345"
+
+	# Start nf_queue listener in ACCEPT mode
+	ip netns exec "$nsrouter" ./nf_queue -q 10 -c > "$TMPFILE2" &
+	local nfq_accept_pid=$!
+	busywait "$BUSYWAIT_TIMEOUT" nf_queue_wait "$nsrouter" 10
+
+	# Establish the connection and send the first message
+	tail -f "$TMPFILE0" | ip netns exec "$ns1" socat STDIO TCP:10.0.2.99:12345 &
+	echo "message1" >> "$TMPFILE0"
+	if ! busywait "$BUSYWAIT_TIMEOUT" grep -q "message1" "$TMPFILE1"; then
+		echo "FAIL: Did not receive first message."
+		ret=1
+		return
+	fi
+
+	# Switch nfqueue listener to DROP mode
+	kill "$nfq_accept_pid"; wait "$nfq_accept_pid" 2>/dev/null
+	ip netns exec "$nsrouter" ./nf_queue -q 10 -c -Q 0 > "$TMPFILE3" &
+	local nfq_drop_pid=$!
+	busywait "$BUSYWAIT_TIMEOUT" nf_queue_wait "$nsrouter" 10
+
+	# Send another message; it should be accepted by the 'ct state established' rule
+	echo "message2" >> "$TMPFILE0"
+	if ! busywait "$BUSYWAIT_TIMEOUT" grep -q "message2" "$TMPFILE1"; then
+		echo "FAIL: Did not receive second message."
+		ret=1
+		return
+	fi
+
+	# Set conntrack timeout to 0 to force re-evaluation
+	ip netns exec "$nsrouter" conntrack -U -p tcp --dport 12345 -d 10.0.2.99 -s 10.0.1.99 -t 0
+
+	# Send a final message. It should be queued and then dropped.
+	echo "message3" >> "$TMPFILE0"
+	if busywait "$BUSYWAIT_TIMEOUT" grep -q "message3" "$TMPFILE1"; then
+		echo "FAIL: Third message was received, but should have been dropped."
+		ret=1
+		return
+	fi
+
+	kill "$server_pid"
+	wait "$server_pid" 2>/dev/null
+	kill "$nfq_drop_pid"
+	wait "$nfq_drop_pid" 2>/dev/null
+
+	echo "PASS: tcp established re-queueing on conntrack timeout"
+
+	return 0
+}
+
 test_icmp_vrf() {
 	if ! ip -net "$ns1" link add tvrf type vrf table 9876;then
 		echo "SKIP: Could not add vrf device"
@@ -661,6 +735,7 @@ test_tcp_forward
 test_tcp_localhost
 test_tcp_localhost_connectclose
 test_tcp_localhost_requeue
+test_tcp_conntrack_timeout_requeue
 test_sctp_forward
 test_sctp_output
 test_udp_ct_race
-- 
2.51.0.869.ge66316f041-goog

