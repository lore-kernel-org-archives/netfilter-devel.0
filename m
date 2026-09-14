Received: from mail-ej2-f0.google.com (mail-ej2-f0.google.com [74.125.228.128])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA4773B6BFD
	for <netfilter-devel@vger.kernel.org>; Mon, 14 Sep 2026 07:25:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.228.128
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789370752; cv=none; b=m9lyFxaOJ33W7fRSFMKhogjffRNYhNURz24B4Bd+M6eGJPDQ5vQgfKKSliqRXRqziwsDDQcvUbYfJCJLj+ySvHOVQZmHoXU7CNcxCGEDJJOmQ26mS7JlLxLbhcv0QfaopKGywoS1DVCtPFvaO9eWtfE8JWFFObzBM86eD6u3F8E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789370752; c=relaxed/simple;
	bh=/5cvRTrFfz/Hxyg59lii8xrAR/C8qUp8JZkBnKf7ZY8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rtwSAmklwE67CuOWvCXW47QjVwPWdWqhSp1kguYVMoy2DPkBAA6s9WSSiOYx9H/EGKK1teicEgLlEAassAUI9w/e1zDV8p2taWoY0uf6K1GVgCy6YZU8BlxuZc7v80aXUzYY1ffFbq1JvU4cB2BBwStUIkmpEzPIvvu/m/ZKKtM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bairaktaris.de; spf=pass smtp.mailfrom=bairaktaris.de; dkim=pass (2048-bit key) header.d=bairaktaris.de header.i=@bairaktaris.de header.b=Crt4HjjQ; arc=none smtp.client-ip=74.125.228.128
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bairaktaris.de header.i=@bairaktaris.de header.b="Crt4HjjQ"
Received: by mail-ej2-f0.google.com with SMTP id a640c23a62f3a-c293a9e09b9so121800766b.1
        for <netfilter-devel@vger.kernel.org>; Mon, 14 Sep 2026 00:25:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bairaktaris.de; s=google; t=1789370747; x=1789975547; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=kwSzHdiS35KC6+q+6DPvVMpYsOp6yZOwPrNeT4BG5Kk=;
        b=Crt4HjjQ9gm0rGNRuHk42lLJHTHvrCPq6RUjjt0bqnWrrsHWvKx/Wf/9YDyJfgCn62
         YWnSK4vwsgCcShqj4WTgCScdYaWrFHzxwfC06+M8N75OiOznygke1syeAzMvvMRTFj11
         WdSO9uxoxj/3O4oCh5LHdFw9BfRggj1Omsi6vnuZLYLj0GkQAH+03AfxQVptUn5lwfYR
         hoOSsZ7WhY5Ac0WW2uVnKq+scmCbgGrDHmbaJrpn4VRweUDkNS3ZdP3BdGzaKF0s/H+9
         x3gpdxdPxcoZpfI0+rJp5+6tC/LCA7gkIon2iCzwkTVyJOSqb9HPF0Dl1lHEb5UupSki
         4BmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789370747; x=1789975547;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=kwSzHdiS35KC6+q+6DPvVMpYsOp6yZOwPrNeT4BG5Kk=;
        b=qVos1Hw2s/P8Qcr0KaV19VRCHp5SJ98EhHCmqeqlfdP1lhgV7j/BoUpHHCWW31/ulf
         BN2qWUL4Qu/p9hSrpTn2255elseKOItbTjHVNtrBkUgjgHpspd2hdRjklLO/28G0E4pQ
         sDlEamDt0f8ObMQhQHi1SSL2QTwtGtuJz3+b/sVuKx12F1I4NIRa4raYau0IibOwjKoo
         mAwcsE0DMkZYmFIa69yTgyk9VPrz8aVjkRbBgm+Usz/0P6kwZqzlfJLsZkZW4ht7wYx7
         LPkl9kVyoFNxh4c07q4x21fmSVHojgIyuVgOdMhVmAa+YYxIJG98rBi44wX14eYSAFJy
         F+4A==
X-Gm-Message-State: AFuF++kgbdz9pHxPUra5hQgkoMnb/pgpUZtiGb4D38nEXG86Ta8Q4vUn
	f/6JXEo0VKggZ4mgZrU2PSYN8LSQfzqriezE5wEFz7voCQTyLF6tVCycaO9PDyD+RetmeUx3PfV
	4tgyILkDPelhCywc0
X-Gm-Gg: AYBFou09rL0dZfhWEOytLd8cCH7+Jq9xrvQmGpQSNttmDiYVJ2nVNCrFfvF31ZYkzQ9
	SMK1nTqF4q3HHeWSWDbZaHQU2QIRoTufyyT+rd4rXBfPGu/I/6aUXLuHwfTZurot115qRefOENQ
	m/aI4wI0Z6qoskBD/XB4lpjsdx3wBgjnAuhXnl8vBXkJm1q1T5RoZZiEkuJHcEUYUq4DDTTu6Bg
	gn+VVlyV9pv/XVEdOtUc6rPeC5Iu4l6p1NbEIZuADEVJHXXCI5Vnb+t+RM7zlroTCfyZCesySUb
	qoXdyGG9bH6hVTDQzlCiI70k8B/11LVlTy4aswyyJsSbTbLKbUPxSp/bd3bPUxu8lywFwOf+y9m
	oXVbtDih1U6aNB4BE6vqGvN0qVf+cYyUbdl9nmvPNgJGasU0kZIr55KmlQDbY8BU5POHv3bkRmC
	mabGxj6d6e8+rs24WSLwyyJWm8rUJlfr+EIbNSxGZIFHDJjV6EJfdBdPZUju/PO/BWop4tDbH/V
	wNVS79rf+LDCvY7Wr9J2dM5xzXi6r89P0MLOThr641GXPwPfTf/8LbMaW4lCo3mjUl79IQCkMrO
	qIztNVfoT63gIB7SsXqE8LWB5u97JZnH+V5tRFiJIlc/jx0fftkpxRejFnT0regac4zRbwfhI/p
	hV5zGQrKbz4Bm1a1orC+BfOeJ2irCKsSTDQwJXG9AezDGtQ0AOm8YhY5+HPIsrNOYBFlIYSpPtY
	Mc8IF7Gr/N
X-Received: by 2002:a17:907:1c8b:b0:c29:44b0:1428 with SMTP id a640c23a62f3a-c29b87811c1mr97003666b.42.1789370746820;
        Mon, 14 Sep 2026 00:25:46 -0700 (PDT)
Received: from Desktop.fritz.box ([185.152.145.208])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c2965c4e8a1sm382835666b.6.2026.09.14.00.25.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Sep 2026 00:25:46 -0700 (PDT)
From: Julius Bairaktaris <julius@bairaktaris.de>
To: netfilter-devel@vger.kernel.org
Cc: pablo@netfilter.org,
	fw@strlen.de,
	kadlec@netfilter.org,
	phil@nwl.cc,
	horms@kernel.org,
	davem@davemloft.net,
	razor@blackwall.org,
	ericwouds@gmail.com,
	dqfext@gmail.com,
	netdev@vger.kernel.org,
	coreteam@netfilter.org,
	linux-kselftest@vger.kernel.org
Subject: [PATCH nf-next v5 3/3] selftests: netfilter: nft_flowtable.sh: roam a host between two bridge ports
Date: Mon, 14 Sep 2026 09:25:41 +0200
Message-ID: <20260914072541.897040-4-julius@bairaktaris.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260914072541.897040-1-julius@bairaktaris.de>
References: <20260914072541.897040-1-julius@bairaktaris.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add a test where a host behind a bridge on the router moves to another
port of that bridge while its flow is offloaded, as a station moving
between two access points attached to ports of one bridge. The host keeps
its address and mac on a bridge of its own and roams by moving that
bridge's port, so only the fdb changes. A sender streams tcp to the host;
the test checks that the flow was offloaded before the roam, that the
host's received byte counter advances after it, and that the flow is
offloaded again. The test runs once with plain veth bridge ports and once
with vlan devices as bridge ports.

Without the teardown the reply direction keeps going to the old port and
the transfer stalls. CONFIG_NET_SWITCHDEV is needed for the bridge to
notify the fdb move.

Signed-off-by: Julius Bairaktaris <julius@bairaktaris.de>
Assisted-by: LLM
---
 tools/testing/selftests/net/netfilter/config  |   1 +
 .../selftests/net/netfilter/nft_flowtable.sh  | 140 ++++++++++++++++++
 2 files changed, 141 insertions(+)

diff --git a/tools/testing/selftests/net/netfilter/config b/tools/testing/selftests/net/netfilter/config
index c3c121b6f300..d4e7249cb5b2 100644
--- a/tools/testing/selftests/net/netfilter/config
+++ b/tools/testing/selftests/net/netfilter/config
@@ -60,6 +60,7 @@ CONFIG_NET_NS=y
 CONFIG_NET_PKTGEN=m
 CONFIG_NET_SCH_HTB=m
 CONFIG_NET_SCH_NETEM=m
+CONFIG_NET_SWITCHDEV=y
 CONFIG_NET_VRF=y
 CONFIG_NF_CONNTRACK=m
 CONFIG_NF_CONNTRACK_EVENTS=y
diff --git a/tools/testing/selftests/net/netfilter/nft_flowtable.sh b/tools/testing/selftests/net/netfilter/nft_flowtable.sh
index 449c518bd947..0d9f7d771fac 100755
--- a/tools/testing/selftests/net/netfilter/nft_flowtable.sh
+++ b/tools/testing/selftests/net/netfilter/nft_flowtable.sh
@@ -851,6 +851,146 @@ test_ipip
 
 test_bridge
 
+# Roam a host between two ports of a bridge on the router while its flow is
+# offloaded, as a station moving between two access points attached to ports
+# of one bridge. The host keeps its address and mac on a bridge of its own
+# and roams by moving that bridge's port, so only the fdb changes. With a vid
+# the bridge ports are vlan devices, whose ifindex differs from the device
+# the flow transmits on. A flow that stays on the fast path leaves no more
+# than a few packets in the forward chain, the counter tells offloaded from
+# slow path.
+test_bridge_roam()
+{
+	local vid=$1
+	local p0=sr0 p1=sr1 r0=rr0 r1=rr1
+	local what="roaming on bridge${vid:+ with vlan ports}"
+	local dev old new slow cpid
+
+	setup_ns rns1 rnsr rns2
+
+	if ! ip -net "$rnsr" link add br0 type bridge 2>/dev/null; then
+		echo "SKIP: could not add bridge for $what"
+		[ "$ret" -eq 0 ] && ret=$ksft_skip
+		return
+	fi
+
+	ip link add sr0 netns "$rns1" type veth peer name rr0 netns "$rnsr"
+	ip link add sr1 netns "$rns1" type veth peer name rr1 netns "$rnsr"
+	ip link add rw0 netns "$rnsr" type veth peer name w0 netns "$rns2"
+	for dev in sr0 sr1; do
+		ip -net "$rns1" link set "$dev" up
+	done
+	for dev in rr0 rr1; do
+		ip -net "$rnsr" link set "$dev" up
+	done
+
+	if [ -n "$vid" ]; then
+		for dev in sr0 sr1; do
+			ip -net "$rns1" link add link "$dev" name "$dev.$vid" type vlan id "$vid"
+			ip -net "$rns1" link set "$dev.$vid" up
+		done
+		for dev in rr0 rr1; do
+			ip -net "$rnsr" link add link "$dev" name "$dev.$vid" type vlan id "$vid"
+			ip -net "$rnsr" link set "$dev.$vid" up
+		done
+		p0=sr0.$vid; p1=sr1.$vid; r0=rr0.$vid; r1=rr1.$vid
+	fi
+
+	ip -net "$rnsr" link set "$r0" master br0
+	ip -net "$rnsr" link set "$r1" master br0
+	ip -net "$rnsr" addr add 10.9.1.1/24 dev br0
+	ip -net "$rnsr" link set br0 up
+	ip -net "$rnsr" addr add 10.9.2.1/24 dev rw0
+	ip -net "$rnsr" link set rw0 up
+	ip netns exec "$rnsr" sysctl -q net.ipv4.ip_forward=1
+
+	ip -net "$rns1" link add stbr type bridge
+	ip -net "$rns1" link set stbr address 02:00:00:09:01:99
+	ip -net "$rns1" link set "$p0" master stbr
+	ip -net "$rns1" link set stbr up
+	ip -net "$rns1" addr add 10.9.1.99/24 dev stbr
+	ip -net "$rns1" route add default via 10.9.1.1
+
+	ip -net "$rns2" addr add 10.9.2.99/24 dev w0
+	ip -net "$rns2" link set w0 up
+	ip -net "$rns2" route add default via 10.9.2.1
+
+	if ! ip netns exec "$rnsr" nft -f - <<EOF
+table inet filter {
+  counter roam_repl { }
+  flowtable f1 { hook ingress priority 0; devices = { rr0, rr1, rw0 }; }
+  chain forward {
+    type filter hook forward priority 0; policy accept;
+    meta oif "rw0" tcp dport 12345 flow add @f1
+    meta iif "rw0" tcp sport 12345 counter name roam_repl flow add @f1
+  }
+}
+EOF
+	then
+		echo "SKIP: could not load ruleset for $what"
+		[ "$ret" -eq 0 ] && ret=$ksft_skip
+		return
+	fi
+
+	# the host discards what it receives, its socket byte counter is read
+	rx_bytes() { ip netns exec "$rns1" ss -tin "dst 10.9.2.99" 2>/dev/null |
+		grep -o 'bytes_received:[0-9]*' | head -1 | cut -d: -f2; }
+	rx_started() { local n; n=$(rx_bytes); [ "${n:-0}" -gt 0 ]; }
+	# forward chain packets of the reply direction since the last call
+	slow_pkts() { ip netns exec "$rnsr" nft reset counter inet filter roam_repl |
+		grep -o 'packets [0-9]*' | cut -d' ' -f2; }
+	roam_listener_ready() { ss -N "$rns2" -lnt -o "sport = :12345" | grep -q 12345; }
+
+	timeout "$SOCAT_TIMEOUT" ip netns exec "$rns2" socat -u \
+		OPEN:/dev/zero TCP-LISTEN:12345,reuseaddr &
+	busywait 1000 roam_listener_ready
+	timeout "$SOCAT_TIMEOUT" ip netns exec "$rns1" socat -u \
+		TCP:10.9.2.99:12345 OPEN:/dev/null &
+	cpid=$!
+
+	busywait "$BUSYWAIT_TIMEOUT" rx_started
+	sleep 2
+	slow_pkts > /dev/null
+	sleep 2
+	slow=$(slow_pkts)
+	if [ "${slow:-0}" -gt 100 ]; then
+		echo "FAIL: $what: $slow forward chain packets before the roam" 1>&2
+		ret=1
+		kill "$cpid" 2>/dev/null
+		return
+	fi
+
+	# roam: move the host bridge to the other port and send on it
+	ip -net "$rns1" link set "$p0" nomaster
+	ip -net "$rns1" link set "$p1" master stbr
+	ip netns exec "$rns1" ping -c 2 -W 1 -q 10.9.1.1 >/dev/null 2>&1
+
+	# the bytes in flight at the roam drain within the first seconds; a
+	# stale flow delivers nothing after that, a torn down one resumes and
+	# is offloaded again.
+	sleep 4
+	old=$(rx_bytes)
+	sleep 4
+	new=$(rx_bytes)
+	slow_pkts > /dev/null
+	sleep 2
+	slow=$(slow_pkts)
+	kill "$cpid" 2>/dev/null
+
+	if [ "${new:-0}" -le "${old:-0}" ]; then
+		echo "FAIL: $what: transfer stalled after the roam" 1>&2
+		ret=1
+	elif [ "${slow:-0}" -gt 100 ]; then
+		echo "FAIL: $what: $slow forward chain packets after the roam" 1>&2
+		ret=1
+	else
+		echo "PASS: flow offload for $what"
+	fi
+}
+
+test_bridge_roam ""
+test_bridge_roam 100
+
 KEY_SHA="0x"$(ps -af | sha1sum | cut -d " " -f 1)
 KEY_AES="0x"$(ps -af | md5sum | cut -d " " -f 1)
 SPI1=$RANDOM
-- 
2.53.0

