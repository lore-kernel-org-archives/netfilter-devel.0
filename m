Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 726CB4EBAE4
	for <netfilter-devel@vger.kernel.org>; Wed, 14 Oct 2026 23:56:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792022196; cv=none; b=mt+qM3CuwfKDy4LjAHQyTHAGWupincQIWR1pAzd6cYGHVC010DBO6nEDQ+wB98gRRbkGbbtY1X4S+RMJdNrP+1p6mu+pJg0asn+wWzquyOG3zGWyJ6ge35aBWi8c2XX92pBAPKKwlixFiIh2HJ0vgUIPYVgGKQZNXvPJooxrQsw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792022196; c=relaxed/simple;
	bh=30D0Qm8jnT+41OzZcm79oVVnN8SNIPkLTbEEPX6X5Xs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PSp9vcoj6LUlnq/muWzEPJs0vhZcQzPMsOMUy53q7b+DsSA8Z0OFBGCgqzfSKqJ+rhMPVVkWYl2/vjTINDMPLvQnNkrpThB2vRqjE517S2idgrbyfvnO5GOuOcRCqXhBL/YZBU/DjTfHZ6d+PmMWD2OVJ8D8RgZ9OYOhskgRd/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bairaktaris.de; spf=pass smtp.mailfrom=bairaktaris.de; dkim=pass (2048-bit key) header.d=bairaktaris.de header.i=@bairaktaris.de header.b=GfST0w2W; arc=none smtp.client-ip=209.85.218.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bairaktaris.de header.i=@bairaktaris.de header.b="GfST0w2W"
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-c2dc8cb0decso174567966b.2
        for <netfilter-devel@vger.kernel.org>; Wed, 14 Oct 2026 16:56:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bairaktaris.de; s=google; t=1792022193; x=1792626993; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Q2Y2Lz9pIbNgeYo7CVu5aDkzJ2pQ4sXNINeSv3xCPBg=;
        b=GfST0w2WYot5sC8leg9gHn5xueRwknnGq/xh3OsyjpsEeS36J8+3jNnyJdE/UmHTM1
         bvM55k+Kemdjdz0KwrQc/CeLuo25Uu9Mgh/iOyT+eSGyBqD2WN6uW4WnTCnMSd5/NcpU
         dXGj1CRWPf6L1IfXBSwARzNppA2gDq3bfDJyZZnCd6+7IQTXGTetJPRSH/KMJWHd5ye3
         fF4GD2uf4CCmQtmQP9H4d92nsohk6rKKHXtENsJxQCfYYmdNXZs2tLQaKvA3RXP+SSEB
         NYFE5Ys451Fy708hDL7nuwzIFDkNMLf1orrxjWR4O2j4lRwoDXQ0+amIj0yyQKJuflsa
         ugag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792022193; x=1792626993;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Q2Y2Lz9pIbNgeYo7CVu5aDkzJ2pQ4sXNINeSv3xCPBg=;
        b=seWHWkdb1T7MMalOnFwhf5xfrIZXTfunIl2DaFSKVISZItwn4+Sx8YGvSkJZKQWZR+
         0CKbAIhuELMzF0QmX+YKXX9hvwdY5jxLG+VU18q05JddDfAwjWEFWBRIcajAW9FE5RZQ
         1JbV5yXwpgGTV3z166NIz5umSh+KjXrAfV2pv9AJap1/rUnUyY0Fqsu6SpIv/GbxxnrT
         eosfQ+kmN+92DLaFUP83hhRBtFTZzI3rnHLpxz/v5IF2w7HN8VPpz7KxueczuIk7i5PF
         MFQ4sV/2tJtSEFXKCBfX4QKg7eC38ZvUG1WftqYyl7hRMDYYT1/Ze4zZjQ5bEeAZjfYf
         aE7Q==
X-Gm-Message-State: AFq9FYLrlzhi5wumm7y13dghAUsCK1C5vLWJ93eifj5jQ6En7yVhET+C
	GdxBg8I6NlmkTM32ObBUxRGmmOFaD34MDKJ0nzRHhE/uYyZuK4tCix2qJvfS81UuyWtsqTz6Lyc
	+c/R/NLgOAQA=
X-Gm-Gg: AYBFou32rGjGNFfrUDAIAHGiN5NZ8ZjlrhpfTsxYk3/qvqVrNG7m353vHp50+Hv7frN
	zA6jJ/ZRYxsQRHEkicGuSFk0wu3UKNmA4GhIQIHsgtXjKznkmBBziEpf9bOT9wxmt0cI1ZPBcGW
	yqNdzb/mlUprlwEYC7sDWpqdpXTu6MZlxDWglD2pFrFbbeRJoD8a72W5yoPT1xs6zvJS8iYsnrc
	PgLHyPT9MdEI7j3gFN+Gd/yuu/qsqGy4SP1ZowUE/S7nUYxGt9ytSdzTX2KLB3qYR+rMZY6i/+R
	aYGHK9OtrLKeNSrxy/3qBHD1WBS85kGklanxcxALsnghlAtfi9PL/c9V86DtqVyuineVp0pZ6Ll
	pISRrLr6eNpHdkisy+LmfbiErYRe7fDhION2KSdcS14BLwOai452PO2caiiv1HwIjynqprFixom
	VPRJK57Gc+R4g6JS8uSW5iI9P+NG2oFeCLjayPES61XsrQxHWbMMq1SvLLsTuOkVWt+cuJUKm3A
	S+SdNxGoCysQMwZI+bQXzTTycDSX3oGiNgCQ1t56q1VsSUHBjADYGFZKhvqNESj7qfE8XTc+JVl
	nc0MqVV7OOpYxFz2e1qsqUuMDQJ2zGcVX2S1dAm2mmy1JfUGT6OfrGkS69oogtNXolKs6i9LsJ6
	QCsjaLOGP09k6LRnoGwlWgXcTwW/di5dhcnhgFdIEvS3nywJn3Yvv3XvZD/Gpzg036Ab7glhxqj
	2J0cGBZIFjKCTYnp7hwZybAJ4=
X-Received: by 2002:a17:907:7b97:b0:c2e:2944:d6cb with SMTP id a640c23a62f3a-c31a9fed205mr1609413966b.13.1792022192731;
        Wed, 14 Oct 2026 16:56:32 -0700 (PDT)
Received: from Desktop (p54affd5a.dip0.t-ipconnect.de. [84.175.253.90])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c3edab12007sm46101666b.82.2026.10.14.16.56.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Oct 2026 16:56:32 -0700 (PDT)
From: Julius Bairaktaris <julius@bairaktaris.de>
To: netfilter-devel@vger.kernel.org
Cc: pablo@netfilter.org,
	fw@strlen.de,
	kadlec@netfilter.org,
	phil@nwl.cc,
	horms@kernel.org,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	shuah@kernel.org,
	razor@blackwall.org,
	idosch@nvidia.com,
	ericwouds@gmail.com,
	dqfext@gmail.com,
	netdev@vger.kernel.org,
	coreteam@netfilter.org,
	linux-kselftest@vger.kernel.org,
	bridge@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH nf-next v7 2/2] selftests: netfilter: nft_flowtable.sh: roam a host between two bridge ports
Date: Thu, 15 Oct 2026 01:56:27 +0200
Message-ID: <20261014235628.197976-3-julius@bairaktaris.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261014235628.197976-1-julius@bairaktaris.de>
References: <20261014235628.197976-1-julius@bairaktaris.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Move a host to another port of a bridge on the router while its flow is
offloaded, and check that the transfer continues and is offloaded again.
The cases are plain and vlan bridge ports, "bridge fdb replace", a
pinned and then deleted fdb entry, an aged out entry (the flow must
stay), the plain case over IPv6 and on a vlan_filtering bridge.

Without the gc check the transfer stalls when the host moves.

Assisted-by: Claude:claude-fable-5-1
Assisted-by: Claude:claude-opus-5-5
Signed-off-by: Julius Bairaktaris <julius@bairaktaris.de>
---
 .../selftests/net/netfilter/nft_flowtable.sh  | 204 ++++++++++++++++++
 1 file changed, 204 insertions(+)

diff --git a/tools/testing/selftests/net/netfilter/nft_flowtable.sh b/tools/testing/selftests/net/netfilter/nft_flowtable.sh
index 449c518bd947d..e6b345ff45b5d 100755
--- a/tools/testing/selftests/net/netfilter/nft_flowtable.sh
+++ b/tools/testing/selftests/net/netfilter/nft_flowtable.sh
@@ -851,6 +851,210 @@ test_ipip
 
 test_bridge
 
+# Roam a host between two ports of a bridge on the router while its flow is
+# offloaded, as a station moving between two access points attached to ports
+# of one bridge. The host keeps its address and mac on a bridge of its own
+# and roams by moving that bridge's port, so only the fdb changes. With a vid
+# the bridge ports are vlan devices, whose ifindex differs from the device
+# the flow transmits on. With "replace" the router's fdb entry is sticky and
+# the move is a "bridge fdb replace". With "del" the host stays, its entry is
+# pinned to the other port and then deleted, and a ping relearns it. With
+# "age" the host stays and its entry ages out, which must not tear the flow
+# down. A flow that stays on the fast path leaves no more than a few packets
+# in the forward chain, the counter tells offloaded from slow path. The
+# plain roam also runs over IPv6, and on a vlan_filtering bridge, whose fdb
+# entries are keyed by the pvid of the untagged ports.
+test_bridge_roam()
+{
+	local vid=$1 how=$2 fam=${3:-4} vf=$4
+	local p0=sr0 p1=sr1 r0=rr0 r1=rr1
+	local mac=02:00:00:09:01:99
+	local what="roaming on bridge${vf:+ with vlan_filtering}"
+	what="$what${vid:+ with vlan ports}${how:+ by fdb $how}"
+	local hn=10.9.1 wn=10.9.2 dot=. len=24 nodad= ip6= srv=10.9.2.99
+	local min=10000000
+	local dev old new slow lpid cpid max=100 win=2
+
+	if [ "$fam" = 6 ]; then
+		hn=dead:9:1 wn=dead:9:2 dot=:: len=64 nodad=nodad ip6=-6
+		srv="[dead:9:2::99]"
+		what="$what over IPv6"
+	fi
+
+	setup_ns rns1 rnsr rns2
+
+	if ! ip -net "$rnsr" link add br0 type bridge ${vf:+vlan_filtering 1} 2>/dev/null; then
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
+	ip -net "$rnsr" addr add $hn${dot}1/$len dev br0 $nodad
+	ip -net "$rnsr" link set br0 up
+	ip -net "$rnsr" addr add $wn${dot}1/$len dev rw0 $nodad
+	ip -net "$rnsr" link set rw0 up
+	ip netns exec "$rnsr" sysctl -q net.ipv4.ip_forward=1
+	ip netns exec "$rnsr" sysctl -q net.ipv6.conf.all.forwarding=1
+
+	ip -net "$rns1" link add stbr type bridge
+	ip -net "$rns1" link set stbr address $mac
+	ip -net "$rns1" link set "$p0" master stbr
+	ip -net "$rns1" link set stbr up
+	ip -net "$rns1" addr add $hn${dot}99/$len dev stbr $nodad
+	ip $ip6 -net "$rns1" route add default via $hn${dot}1
+
+	ip -net "$rns2" addr add $wn${dot}99/$len dev w0 $nodad
+	ip -net "$rns2" link set w0 up
+	ip $ip6 -net "$rns2" route add default via $wn${dot}1
+
+	# no neighbour probes, so the host only sends when it receives
+	ip -net "$rnsr" neigh replace $hn${dot}99 lladdr $mac nud permanent dev br0
+	ip -net "$rns1" neigh replace $hn${dot}1 nud permanent dev stbr \
+		lladdr "$(ip -net "$rnsr" -br link show br0 | awk '{print $3}')"
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
+	rx_bytes() { ip netns exec "$rns1" ss -tin "dst $srv" 2>/dev/null |
+		grep -o 'bytes_received:[0-9]*' | head -1 | cut -d: -f2; }
+	rx_started() { local n; n=$(rx_bytes); [ "${n:-0}" -gt 0 ]; }
+	# forward chain packets of the reply direction since the last call
+	slow_pkts() { ip netns exec "$rnsr" nft reset counter inet filter roam_repl |
+		grep -o 'packets [0-9]*' | cut -d' ' -f2; }
+	roam_listener_ready() { ss -N "$rns2" -lnt -o "sport = :12345" | grep -q 12345; }
+
+	roam_stop() { kill "$cpid" "$lpid" 2>/dev/null; wait "$cpid" "$lpid" 2>/dev/null; }
+
+	timeout "$SOCAT_TIMEOUT" ip netns exec "$rns2" socat -u \
+		OPEN:/dev/zero TCP$fam-LISTEN:12345,reuseaddr &
+	lpid=$!
+	if ! busywait "$BUSYWAIT_TIMEOUT" roam_listener_ready; then
+		echo "FAIL: $what: listener did not start" 1>&2
+		ret=1
+		kill "$lpid" 2>/dev/null; wait "$lpid" 2>/dev/null
+		return
+	fi
+	timeout "$SOCAT_TIMEOUT" ip netns exec "$rns1" socat -u \
+		TCP$fam:$srv:12345 OPEN:/dev/null &
+	cpid=$!
+
+	if ! busywait "$BUSYWAIT_TIMEOUT" rx_started; then
+		echo "FAIL: $what: transfer did not start" 1>&2
+		ret=1
+		roam_stop
+		return
+	fi
+	sleep 2
+	slow_pkts > /dev/null
+	old=$(rx_bytes)
+	sleep 2
+	new=$(rx_bytes)
+	slow=$(slow_pkts)
+	if [ -z "$slow" ] || [ $((${new:-0} - ${old:-0})) -lt $min ] ||
+	   [ "$slow" -gt 100 ]; then
+		echo "FAIL: $what: not offloaded before the roam:" \
+		     "$((${new:-0} - ${old:-0})) bytes, ${slow:-no} forward chain packets" 1>&2
+		ret=1
+		roam_stop
+		return
+	fi
+
+	if [ "$how" = age ]; then
+		# ageing_time is in centiseconds
+		ip -net "$rnsr" link set br0 type bridge ageing_time 200
+		max=0 win=10
+	elif [ "$how" = del ]; then
+		bridge -n "$rnsr" fdb replace $mac dev "$r1" master static sticky
+		sleep 2
+		bridge -n "$rnsr" fdb del $mac dev "$r1" master static
+		ip netns exec "$rns1" ping $ip6 -c 2 -W 1 -q $hn${dot}1 >/dev/null 2>&1
+	else
+		# roam: move the host bridge to the other port and send on it
+		if [ "$how" = replace ]; then
+			bridge -n "$rnsr" fdb replace $mac dev "$r0" master static sticky
+		fi
+		ip -net "$rns1" link set "$p0" nomaster
+		ip -net "$rns1" link set "$p1" master stbr
+		ip netns exec "$rns1" ping $ip6 -c 2 -W 1 -q $hn${dot}1 >/dev/null 2>&1
+		if [ "$how" = replace ]; then
+			bridge -n "$rnsr" fdb replace $mac dev "$r1" master static sticky
+		fi
+	fi
+
+	# the bytes in flight at the roam drain within the first seconds; a
+	# stale flow delivers nothing after that, a torn down one resumes and
+	# is offloaded again.
+	sleep 4
+	old=$(rx_bytes)
+	sleep 4
+	new=$(rx_bytes)
+	slow_pkts > /dev/null
+	sleep $win
+	slow=$(slow_pkts)
+	roam_stop
+
+	if [ "$how" = age ] &&
+	   bridge -n "$rnsr" fdb show br br0 | grep -q "$mac.*master"; then
+		echo "FAIL: $what: the host's fdb entry did not age out" 1>&2
+		ret=1
+	elif [ $((${new:-0} - ${old:-0})) -lt $min ]; then
+		echo "FAIL: $what: transfer stalled after the roam" 1>&2
+		ret=1
+	elif [ -z "$slow" ] || [ "$slow" -gt $max ]; then
+		echo "FAIL: $what: $slow forward chain packets after the roam" 1>&2
+		ret=1
+	else
+		echo "PASS: flow offload for $what"
+	fi
+}
+
+test_bridge_roam ""
+test_bridge_roam 100
+test_bridge_roam "" replace
+test_bridge_roam "" del
+test_bridge_roam "" age
+test_bridge_roam "" "" 6
+test_bridge_roam "" "" 4 vf
+
 KEY_SHA="0x"$(ps -af | sha1sum | cut -d " " -f 1)
 KEY_AES="0x"$(ps -af | md5sum | cut -d " " -f 1)
 SPI1=$RANDOM
-- 
2.53.0

