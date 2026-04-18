Received: from mail-wm1-f68.google.com (mail-wm1-f68.google.com [209.85.128.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54E442DF719
	for <netfilter-devel@vger.kernel.org>; Sat, 18 Apr 2026 19:58:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.68
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776542342; cv=none; b=jcbJtseFoThEBI+wTLhlJDsChKqc6R+byyyy/ScTzM+XL8uqwZ/kIIyOS6FXjkuoamiPlFpQFAA1T8cxOgDkr2HJZ6T++jfOjmpgDGMdIgoG6cs1i9dr0E2TBkNZ3UM7J/Id5mGSbkOAoN1oT+Hn0ItkZdwzYXm06Z1gahf7Uz0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776542342; c=relaxed/simple;
	bh=g+jbqedVJeXVkDa41E9XlF9r/7lQOFTqNLPXjDQEnlQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=jHMu0M0upUtMjq0YKf6iyp8COOPl3E4reVVv+YRHWZQPwZoB7jM4zH+GG38zZkwr65tvZ4KKNGfzJbjr3YhCWG70LompHAiFQ+YqeVjfzUz5pM8grH0HnFDWwuQ0TjjLqq8C2lD2kL7wvWvAJ9BU3s7FEnB86kTwek3Sqbpn+Zo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Snvl1j2j; arc=none smtp.client-ip=209.85.128.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Snvl1j2j"
Received: by mail-wm1-f68.google.com with SMTP id 5b1f17b1804b1-488a041eae5so11074935e9.1
        for <netfilter-devel@vger.kernel.org>; Sat, 18 Apr 2026 12:58:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776542338; x=1777147138; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=tm2PCGa1F10nJuRUcP6mAyFe2uLBjcoG5dv2Op3y66U=;
        b=Snvl1j2jPaRYyS/BArRe630VPb4NfR7OSMs9o2Lf/4Ir7Woa8sYFSdSU4/AbOqJZn2
         rjDCY2xWDxTTn5b/kgk2VfTWR0Q8sq9+VaBxNOGuaBDYxv2+Mwbu8RTwbDLcMtOOuzbg
         plG2kntcEsywSVXyqfWE6Y/QYhLFzGH9mt+SMDkttE/NAD1tGL9Jpw74Q3ls7gNNzmIq
         UVYe+109de7YeZkRayHeh+HElHFq2DGy98BuC6cNJJw9GBKDVDCyZ8SoSOUxymY5N75Y
         pBRWSFkiqY4CwK8kPEKKjHfQucVVfF6HJ3QRa4gkPlv/3dIoOlSuBNmyNFbCFWRUQGBI
         VKcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776542338; x=1777147138;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tm2PCGa1F10nJuRUcP6mAyFe2uLBjcoG5dv2Op3y66U=;
        b=LEzQTRZYTebXnZUvziA/weSYvsjp4DLuZEAE/+Tq94+vR4Uu0BkgiMEwX9ywotgQMA
         a/N9gn7m8zgL/hP5kFwHu0SzfGz06Z1CEtwtmaZna5SW7yT7eoVKVBW5YQFukdR9Oxql
         AJ7u0Bd2jHQNmU93XTSogaGHIwlbr+31gZiFbfBBLQ74yoxPExG7y4bs6EUEuNdPH1Fv
         IHqFSFFMzQB2K8q4cF/yjpf1X6oNtzDu23xPZVlulWPx6wJUdUugdtofznXyjGtOsQNV
         PsRX5wemFCnnOTqHp2aUem8ZCJiJ7fA918mDlyS8aOCFbc7JDkOXFJSmWHaw14a89/kD
         wm1w==
X-Forwarded-Encrypted: i=1; AFNElJ95uc0dX6v9uDC+xjB7mRM+FJLw+DL931iPQWVR8tgWbgVIyyA0bxHoL5XiA4u45K/WNlHM1qD6jlaaLMZjP9k=@vger.kernel.org
X-Gm-Message-State: AOJu0YxsWwDLK4fj3NiKWESoGz+KZH9SlUJnR568TDIwzs7K8+Gwyb3X
	H3ey5ejJ9FIya7CJ5TGiKpgSbzoyTMgdeT6Uq8tCNeX0RjAlPrVm6+NM
X-Gm-Gg: AeBDieuZEUZeT5c1MTb32hv7MG04A5kAhgbPG1SFViBfv3gVchkBX4rSCdFK4gVIYya
	f7G7zAgoPosy7eSs6d/LDYzqn3GXZC3iYA9OBGJcIiH8bqFio9806iD7KYpvdvH0Ykp8ts7QU7m
	+GpX9Nt2AMna7W8Mnb0Y7To53p7HMEIAIi7lQfUnQEfHteHgDbYFEyF9dK9Nwo1+Ztvg+exT+AW
	7fGIjuLeYeVPfpdDrqu1uFUT2BQ2+H9AhAqEl1AHoV3irdT50gotjlYL06rpO1sp63L4TlHT/s6
	0YLyFJ4HVLPSshw+UR7xOJBGiqp06QznhBc8ZVOIunZu2+5ZBFfDnhEDmdTD7Kj5i5mh1Rrbzsp
	7U97w7+a0ntXeWIVMk1Rlawckxs2s9YjWlBtSN65+pGWc4YHJeAaNwhDoLT4y8fP46ryK0oe82L
	g6/9xsx45Cp1o=
X-Received: by 2002:a05:600c:a404:b0:47e:e2eb:bc22 with SMTP id 5b1f17b1804b1-488fb73b2a3mr96678055e9.5.1776542337501;
        Sat, 18 Apr 2026 12:58:57 -0700 (PDT)
Received: from yiche-laptop ([2a09:0:1:2::30c5])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-488fb78becdsm72593675e9.5.2026.04.18.12.58.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Apr 2026 12:58:57 -0700 (PDT)
From: Yi Chen <yiche.cy@gmail.com>
To: Yi Chen <yiche.cy@gmail.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Phil Sutter <phil@nwl.cc>,
	Long Xin <lucien.xin@gmail.com>,
	"David S . Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Eric Dumazet <edumazet@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Shuah Khan <shuah@kernel.org>
Cc: coreteam@netfilter.org,
	netfilter-devel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	netdev@vger.kernel.org
Subject: [PATCH net v2] selftests: netfilter: conntrack_sctp_collision.sh: Introduce SCTP INIT collision test
Date: Sun, 19 Apr 2026 03:58:43 +0800
Message-ID: <20260418195843.303946-1-yiche.cy@gmail.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The existing test covered a scenario where a delayed INIT_ACK chunk
updates the vtag in conntrack after the association has already been
established.

A similar issue can occur with a delayed SCTP INIT chunk.

Add a new simultaneous-open test case where the client's INIT is
delayed, allowing conntrack to establish the association based on
the server-initiated handshake.

When the stale INIT arrives later, it may get recorded and cause a
following INIT_ACK from the peer to be accepted instead of dropped.
This INIT_ACK overwrites the vtag in conntrack, causing subsequent
SCTP DATA chunks to be considered as invalid and then dropped by
nft rules matching on ct state invalid.

This test verifies such stale INIT chunks do not cause problems.

Signed-off-by: Yi Chen <yiche.cy@gmail.com>
Acked-by: Xin Long <lucien.xin@gmail.com>
---
v1 -> v2:
- Simplify conf_delay() by passing arguments.
- Avoid calling exit() inside the function.
- Enable nft log by setting net.netfilter.nf_log_all_netns=1.
- Add a description for the "ct invalid drop" rule match.
---
 .../net/netfilter/conntrack_sctp_collision.sh | 85 ++++++++++++++-----
 1 file changed, 63 insertions(+), 22 deletions(-)

diff --git a/tools/testing/selftests/net/netfilter/conntrack_sctp_collision.sh b/tools/testing/selftests/net/netfilter/conntrack_sctp_collision.sh
index d860f7d9744b..31823050391e 100755
--- a/tools/testing/selftests/net/netfilter/conntrack_sctp_collision.sh
+++ b/tools/testing/selftests/net/netfilter/conntrack_sctp_collision.sh
@@ -2,18 +2,32 @@
 # SPDX-License-Identifier: GPL-2.0
 #
 # Testing For SCTP COLLISION SCENARIO as Below:
-#
+# 1. Stale INIT_ACK capture:
 #   14:35:47.655279 IP CLIENT_IP.PORT > SERVER_IP.PORT: sctp (1) [INIT] [init tag: 2017837359]
 #   14:35:48.353250 IP SERVER_IP.PORT > CLIENT_IP.PORT: sctp (1) [INIT] [init tag: 1187206187]
 #   14:35:48.353275 IP CLIENT_IP.PORT > SERVER_IP.PORT: sctp (1) [INIT ACK] [init tag: 2017837359]
 #   14:35:48.353283 IP SERVER_IP.PORT > CLIENT_IP.PORT: sctp (1) [COOKIE ECHO]
 #   14:35:48.353977 IP CLIENT_IP.PORT > SERVER_IP.PORT: sctp (1) [COOKIE ACK]
 #   14:35:48.855335 IP SERVER_IP.PORT > CLIENT_IP.PORT: sctp (1) [INIT ACK] [init tag: 164579970]
+#   (Delayed)
+#
+# 2. Stale INIT capture:
+#   14:35:48.353250 IP SERVER_IP.PORT > CLIENT_IP.PORT: sctp (1) [INIT] [init tag: 1187206187]
+#   14:35:48.353275 IP CLIENT_IP.PORT > SERVER_IP.PORT: sctp (1) [INIT ACK] [init tag: 2017837359]
+#   14:35:48.353283 IP SERVER_IP.PORT > CLIENT_IP.PORT: sctp (1) [COOKIE ECHO]
+#   14:35:48.353977 IP CLIENT_IP.PORT > SERVER_IP.PORT: sctp (1) [COOKIE ACK]
+#   14:35:47.655279 IP CLIENT_IP.PORT > SERVER_IP.PORT: sctp (1) [INIT] [init tag: 2017837359]
+#   (Delayed)
+#   14:35:48.855335 IP SERVER_IP.PORT > CLIENT_IP.PORT: sctp (1) [INIT ACK] [init tag: 164579970]
 #
 # TOPO: SERVER_NS (link0)<--->(link1) ROUTER_NS (link2)<--->(link3) CLIENT_NS
 
 source lib.sh
 
+checktool "nft --version" "run test without nft"
+checktool "tc -h" "run test without tc"
+checktool "modprobe -q sctp" "load sctp module"
+
 CLIENT_IP="198.51.200.1"
 CLIENT_PORT=1234
 
@@ -24,7 +38,8 @@ CLIENT_GW="198.51.200.2"
 SERVER_GW="198.51.100.2"
 
 # setup the topo
-setup() {
+topo_setup() {
+	# setup_ns cleans up existing net namespaces first.
 	setup_ns CLIENT_NS SERVER_NS ROUTER_NS
 	ip -n "$SERVER_NS" link add link0 type veth peer name link1 netns "$ROUTER_NS"
 	ip -n "$CLIENT_NS" link add link3 type veth peer name link2 netns "$ROUTER_NS"
@@ -38,35 +53,53 @@ setup() {
 	ip -n "$ROUTER_NS" addr add $SERVER_GW/24 dev link1
 	ip -n "$ROUTER_NS" addr add $CLIENT_GW/24 dev link2
 	ip net exec "$ROUTER_NS" sysctl -wq net.ipv4.ip_forward=1
+	sysctl -wq net.netfilter.nf_log_all_netns=1
 
 	ip -n "$CLIENT_NS" link set link3 up
 	ip -n "$CLIENT_NS" addr add $CLIENT_IP/24 dev link3
 	ip -n "$CLIENT_NS" route add $SERVER_IP dev link3 via $CLIENT_GW
+}
 
-	# simulate the delay on OVS upcall by setting up a delay for INIT_ACK with
-	# tc on $SERVER_NS side
-	tc -n "$SERVER_NS" qdisc add dev link0 root handle 1: htb r2q 64
-	tc -n "$SERVER_NS" class add dev link0 parent 1: classid 1:1 htb rate 100mbit
-	tc -n "$SERVER_NS" filter add dev link0 parent 1: protocol ip u32 match ip protocol 132 \
-		0xff match u8 2 0xff at 32 flowid 1:1
-	if ! tc -n "$SERVER_NS" qdisc add dev link0 parent 1:1 handle 10: netem delay 1200ms; then
+conf_delay()
+{
+	# simulate the delay on OVS upcall by setting up a delay for INIT_ACK/INIT with
+	local ns=$1
+	local link=$2
+	local chunk_type=$3
+
+	# use a smaller number for assoc's max_retrans to reproduce the issue
+	ip net exec "$CLIENT_NS" sysctl -wq net.sctp.association_max_retrans=3
+
+	tc -n "$ns" qdisc add dev "$link" root handle 1: htb r2q 64
+	tc -n "$ns" class add dev "$link" parent 1: classid 1:1 htb rate 100mbit
+	tc -n "$ns" filter add dev "$link" parent 1: protocol ip \
+		u32 match ip protocol 132 0xff match u8 "$chunk_type" 0xff at 32 flowid 1:1
+	if ! tc -n "$ns" qdisc add dev "$link" parent 1:1 handle 10: netem delay 1200ms; then
 		echo "SKIP: Cannot add netem qdisc"
-		exit $ksft_skip
+		return $ksft_skip
 	fi
 
 	# simulate the ctstate check on OVS nf_conntrack
-	ip net exec "$ROUTER_NS" iptables -A FORWARD -m state --state INVALID,UNTRACKED -j DROP
-	ip net exec "$ROUTER_NS" iptables -A INPUT -p sctp -j DROP
-
-	# use a smaller number for assoc's max_retrans to reproduce the issue
-	modprobe -q sctp
-	ip net exec "$CLIENT_NS" sysctl -wq net.sctp.association_max_retrans=3
+	ip net exec "$ROUTER_NS" nft -f - <<-EOF
+	table ip t {
+		chain forward {
+			type filter hook forward priority filter; policy accept;
+			meta l4proto icmp counter accept
+			ct state new counter accept
+			ct state established,related counter accept
+			ct state invalid log flags all counter drop comment \
+			"Expect to drop stale INIT/INIT_ACK chunks"
+			counter
+		}
+	}
+	EOF
+	return 0
 }
 
 cleanup() {
-	ip net exec "$CLIENT_NS" pkill sctp_collision >/dev/null 2>&1
-	ip net exec "$SERVER_NS" pkill sctp_collision >/dev/null 2>&1
+	# cleanup_all_ns terminates running processes in the namespaces.
 	cleanup_all_ns
+	sysctl -wq net.netfilter.nf_log_all_netns=0
 }
 
 do_test() {
@@ -81,7 +114,15 @@ do_test() {
 
 # run the test case
 trap cleanup EXIT
-setup && \
-echo "Test for SCTP Collision in nf_conntrack:" && \
-do_test && echo "PASS!"
-exit $?
+
+echo "Test for SCTP INIT_ACK Collision in nf_conntrack:"
+(topo_setup && conf_delay $SERVER_NS link0 2) || exit $?
+if ! do_test; then
+	exit $ksft_fail
+fi
+
+echo "Test for SCTP INIT Collision in nf_conntrack:"
+(topo_setup && conf_delay $CLIENT_NS link3 1) || exit $?
+if ! do_test; then
+	exit $ksft_fail
+fi
-- 
2.53.0

