Received: from mail-ej1-f74.google.com (mail-ej1-f74.google.com [209.85.218.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69CF05FEE4
	for <netfilter-devel@vger.kernel.org>; Sun,  1 Sep 2024 22:02:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725228166; cv=none; b=Zx4SP5+/VUyqSWo77t8lj+XMYzaBErBUTXJVePF+wADaqtkyBly3QCE6jWUvznz1Ok8DdgYBl8rDuwh+bCtHl7tjsdkGr1a5UUBIuu7Ywqjd2tNni62ZRDDaWxn70UOxNdpaTblcNF0CtgbUYsQu1F8YK5qExWHgJPA5TkMOFo0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725228166; c=relaxed/simple;
	bh=sPazC7jiPL6W2yWrc0gorq6k0/09VupGqcaXwfycA3s=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=IXZ0rQElQ7ULNlMYdydlLHT8kYv9fMUUU0OGxB3C3X7JyVMphkLnbrZK60hqc64KUgx5fNC5Cm8mVFRFkGT9mRUAL9A3v+VOu8jSnSAQcPoy6O3dRIkAkP0KXXBYzKOeIMDHaCfFceW4t63ab9KxAK+YFGxbXvBzNc1iCg4LxaU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--aojea.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=RlluxQit; arc=none smtp.client-ip=209.85.218.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--aojea.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="RlluxQit"
Received: by mail-ej1-f74.google.com with SMTP id a640c23a62f3a-a866fe9875bso139973166b.3
        for <netfilter-devel@vger.kernel.org>; Sun, 01 Sep 2024 15:02:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1725228163; x=1725832963; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=yi4puPNOO3vqPLBNgg7h/u6++JGqkxoNtt0HJpAWBeI=;
        b=RlluxQit6yrPJRhOE3rb6l+IQCqzdtxki+IWw53/lP1/0IYa4hMWTDizZhvbg+0v0a
         OAUV7EPuxvODXXTJlBscQfKhUBwY/xyfro9x27/lQCqzL+WV3A71r/ij9zPAdfRT41YX
         UPMDFJJqqLYRqElIVcCdw4RUpzivdiA8b2ynv9MaH0TrTMBExZcYvPPJ8zxW7FlJ9Qdf
         xI/SUp/nASRM9BJJONp/GLRhlgEFAJ4wq25C3mp8rm+aCRKvcq6dVFhWQQdmC1uF+XD6
         zdqEqXm5yMud44l4eWIiYK6Qx5PSFMiovvJhlNArIlB2uSRb4hacGFiq61urn7sAIqRO
         smIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725228163; x=1725832963;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=yi4puPNOO3vqPLBNgg7h/u6++JGqkxoNtt0HJpAWBeI=;
        b=hgbm3dsPMlOsAmiz7tn9gnRjmCDTlpqtdefi9s0Uyy1UOF6YvlWjHHhYLhf0SGqstV
         5CsTaDI8DJ2a+k7nLy2cgh6dWc5NBkYni2VMmmHsV+jBlwaPFrHdBH3DZ9o+LCU0U4hG
         MrgwEGzAGZu5JhwbeMFA4pRPBAZ1v2A+iI1hoYGhApiNDWpck7qne5nem4otjwU2lHfH
         7/3Xv6MAOMWzyWe7Dq+ILW14zi/VTb54eBVweSVRMmCRMHWrsghSJDagIpMXuqayISLG
         fQULpa4orNleZMdXLnLgw1VJeoaMhA9kQb9qZM8kKSOelaPJRB5rezS+uDHsIUfD4N2N
         75Bw==
X-Forwarded-Encrypted: i=1; AJvYcCWp+dai0ABnBlorqbJZbp3ibM6X5ZSJWARVvR/MyY6sIbqjwzHxz4dTAgg+OV/nNYXl/ctTATkD3/AFnitOMZU=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzjn4451P6aoS7X3VeQ8GZIiJL/UBpjBdlo8THfIITf8dLdyDGw
	Dxpmw6L920anND3LCC947KKH8oPGPPsqNd3BaGGgeGkvRtkWg2PuQQNBp7RLuoqj/NsQ3h9dWg=
	=
X-Google-Smtp-Source: AGHT+IEXdsNbR/mrJXDK3OCsKQxddoG6itCZDb7S9BODScmm9mbSltxDt4VutX7Er7HaIYElc68H//6pxA==
X-Received: from aojea.c.googlers.com ([fda3:e722:ac3:cc00:31:98fb:c0a8:b3d])
 (user=aojea job=sendgmr) by 2002:a17:907:11cb:b0:a86:6c5e:e8de with SMTP id
 a640c23a62f3a-a89a37dfe41mr860966b.11.1725228162298; Sun, 01 Sep 2024
 15:02:42 -0700 (PDT)
Date: Sun,  1 Sep 2024 22:02:28 +0000
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.46.0.469.g59c65b2a67-goog
Message-ID: <20240901220228.4157482-1-aojea@google.com>
Subject: [PATCH] ksleftest nfqueue race with dnat
From: Antonio Ojea <aojea@google.com>
To: pablo@netfilter.org, netfilter-devel@vger.kernel.org, fw@strlen.de
Cc: Antonio Ojea <aojea@google.com>
Content-Type: text/plain; charset="UTF-8"

The netfilter race happens when two packets with the same tuple are DNATed
and enqueued with nfqueue in the postrouting hook.
Once one of the packet is reinjected it may be DNATed again to a different
destination, but the conntrack entry remains the same and the return packet
is dropped.

Link: https://bugzilla.netfilter.org/show_bug.cgi?id=1766

Signed-off-by: Antonio Ojea <aojea@google.com>

---
 .../selftests/net/netfilter/nft_queue.sh      | 84 ++++++++++++++++++-
 1 file changed, 83 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/netfilter/nft_queue.sh b/tools/testing/selftests/net/netfilter/nft_queue.sh
index f3bdeb1271eb..bd7f20cf1ce5 100755
--- a/tools/testing/selftests/net/netfilter/nft_queue.sh
+++ b/tools/testing/selftests/net/netfilter/nft_queue.sh
@@ -14,6 +14,7 @@ cleanup()
 {
 	ip netns pids "$ns1" | xargs kill 2>/dev/null
 	ip netns pids "$ns2" | xargs kill 2>/dev/null
+	ip netns pids "$ns3" | xargs kill 2>/dev/null
 	ip netns pids "$nsrouter" | xargs kill 2>/dev/null
 
 	cleanup_all_ns
@@ -31,7 +32,7 @@ modprobe -q sctp
 
 trap cleanup EXIT
 
-setup_ns ns1 ns2 nsrouter
+setup_ns ns1 ns2 ns3 nsrouter
 
 TMPFILE0=$(mktemp)
 TMPFILE1=$(mktemp)
@@ -46,6 +47,7 @@ if ! ip link add veth0 netns "$nsrouter" type veth peer name eth0 netns "$ns1" >
     exit $ksft_skip
 fi
 ip link add veth1 netns "$nsrouter" type veth peer name eth0 netns "$ns2"
+ip link add veth2 netns "$nsrouter" type veth peer name eth0 netns "$ns3"
 
 ip -net "$nsrouter" link set veth0 up
 ip -net "$nsrouter" addr add 10.0.1.1/24 dev veth0
@@ -55,8 +57,13 @@ ip -net "$nsrouter" link set veth1 up
 ip -net "$nsrouter" addr add 10.0.2.1/24 dev veth1
 ip -net "$nsrouter" addr add dead:2::1/64 dev veth1 nodad
 
+ip -net "$nsrouter" link set veth2 up
+ip -net "$nsrouter" addr add 10.0.3.1/24 dev veth2
+ip -net "$nsrouter" addr add dead:3::1/64 dev veth2 nodad
+
 ip -net "$ns1" link set eth0 up
 ip -net "$ns2" link set eth0 up
+ip -net "$ns3" link set eth0 up
 
 ip -net "$ns1" addr add 10.0.1.99/24 dev eth0
 ip -net "$ns1" addr add dead:1::99/64 dev eth0 nodad
@@ -68,6 +75,11 @@ ip -net "$ns2" addr add dead:2::99/64 dev eth0 nodad
 ip -net "$ns2" route add default via 10.0.2.1
 ip -net "$ns2" route add default via dead:2::1
 
+ip -net "$ns3" addr add 10.0.3.99/24 dev eth0
+ip -net "$ns3" addr add dead:3::99/64 dev eth0 nodad
+ip -net "$ns3" route add default via 10.0.3.1
+ip -net "$ns3" route add default via dead:3::1
+
 load_ruleset() {
 	local name=$1
 	local prio=$2
@@ -143,6 +155,14 @@ test_ping() {
 	return 2
   fi
 
+    if ! ip netns exec "$ns1" ping -c 1 -q 10.0.3.99 > /dev/null; then
+	return 1
+  fi
+
+  if ! ip netns exec "$ns1" ping -c 1 -q dead:3::99 > /dev/null; then
+	return 2
+  fi
+
   return 0
 }
 
@@ -453,6 +473,67 @@ EOF
 	fi
 }
 
+udp_listener_ready()
+{
+	ss -S -N "$1" -uln -o "sport = :12345" | grep -q 12345
+}
+
+test_udp_race()
+{
+        ip netns exec "$nsrouter" nft -f /dev/stdin <<EOF
+flush ruleset
+table inet udpq {
+	chain prerouting {
+	type nat hook prerouting priority dstnat - 5; policy accept;
+		 ip daddr 10.6.6.6 udp dport 12345 counter dnat to numgen inc mod 2 map { 0 : 10.0.2.99, 1 : 10.0.3.99 }
+	}
+        chain postrouting {
+        type filter hook postrouting priority srcnat - 5; policy accept;
+                udp dport 12345 counter queue num 12
+        }
+}
+EOF
+
+	timeout 10 ip netns exec "$ns2" socat UDP-LISTEN:12345,fork EXEC:cat &
+	local rpid1=$!
+
+	busywait "$BUSYWAIT_TIMEOUT" udp_listener_ready "$ns2"
+
+	timeout 10 ip netns exec "$ns3" socat UDP-LISTEN:12345,fork EXEC:cat &
+	local rpid2=$!
+
+	busywait "$BUSYWAIT_TIMEOUT" udp_listener_ready "$ns3"
+
+	ip netns exec "$nsrouter" ./nf_queue -q 12 &
+	local nfqpid=$!
+
+	echo > "$TMPFILE1"
+	echo > "$TMPFILE2"
+	# send UDP packets with the same tuple multiple times to hit the race
+	for i in $(seq 1 10); do
+		echo "dns-packet1dns-packet2" | ip netns exec "$ns1" socat -b10 STDIO UDP:10.6.6.6:12345 >>"$TMPFILE1"
+		# expected to receive two
+		echo "dns-packet1dns-packet2" >> "$TMPFILE2"
+	done
+
+	# must wait before checking completeness of output file.
+	wait "$rpid1"
+	wait "$rpid2"
+	kill "$nfqpid"
+
+	if ! ip netns exec "$nsrouter" nft delete table inet udpq; then
+		echo "FAIL:  Could not delete udpq table"
+		exit 1
+	fi
+
+	if ! diff -u "$TMPFILE1" "$TMPFILE2" ; then
+		echo "FAIL: lost packets?!" 1>&2
+		exit 1
+	fi
+
+	echo "PASS: udp race"
+}
+
 test_queue_removal()
 {
 	read tainted_then < /proc/sys/kernel/tainted
@@ -529,6 +610,7 @@ test_tcp_localhost_connectclose
 test_tcp_localhost_requeue
 test_sctp_forward
 test_sctp_output
+test_udp_race
 
 # should be last, adds vrf device in ns1 and changes routes
 test_icmp_vrf
-- 
2.46.0.469.g59c65b2a67-goog

