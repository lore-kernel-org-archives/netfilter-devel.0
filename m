Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.218.41
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794704178;
	b=ErFiWtV1HBK7/mbmryxyEnmdNROTaHpLmUFa9R4Z9aeN/CzcBNU5+vUuxwZiOKTQ5l5d
	 C+XDob+xRX+W3iRA7ZCa5f/ibrQEYGJOmNa1NlbexS9RPpNMngW1lBCgduQMa4YYQpDDl
	 G2o0J9xOYhuE4Yy9vS2YquB/fy/vzj1zZ6rwPhx8jIzs3FP+q6n1NBkL8d6s9gW6LQCKc
	 rIgBVDZwii3nG8d7v2cmWd0ZPyBJstkaEfcnB97iOom2lhzd4zaAiXiRA9NYLUzOyWS4/
	 W8qXUbGv/EO6Inmvdh5P+hbXEo7npN7du1YYQKcwvNOPJLtjOd8z8tL4xSsrjM50ExQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794704178;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=Uog2DUXpaE9MlsvIhp7brTPyfcLl2qmPjN0vFybGnao=;
	b=UgsjUbGqcbhzlqZmTHKFAYNMoLR14/EikjbzSKPDloohT+sXGzF+WU+q2BFF3WFKUzIm
	 PJpYqEznznIgXVg9q/WxCp/avfOOqBPSEt5osI89J75VAPqAuPvfT8g22beQ4cKYIaezP
	 bvfDxlQge4nd2JMh6BTzmRU+k/7K2rDVfRqP0XGadbQUPCOdEz3QN0TwUmaRe5WSoKFPk
	 oDuz5oFbrM+jUHE4srl9jpbYhXxCcgPlTYmYtH34qUyo3ddzjof0sqo+RpI5WcpKOjssX
	 mvIzMhw58vFpH1jfhYCfl0Gh6NmzVVE/m8Mcvl2HJxXECNyfpU3zbFNPMGQ+aGL7ZwQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=bairaktaris.de;
	spf=pass smtp.mailfrom=bairaktaris.de;
	dkim=pass header.d=bairaktaris.de header.i=@bairaktaris.de header.a=rsa-sha256 header.s=google header.b=ycuiTXa1;
	arc=none smtp.remote-ip=209.85.218.41
Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28C73606A893
	for <netfilter-devel@vger.kernel.org>; Sun, 15 Nov 2026 00:56:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 28C73606A893
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bairaktaris.de header.i=@bairaktaris.de header.a=rsa-sha256 header.s=google header.b=ycuiTXa1
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-c50abd5b4fcso168935666b.1
        for <netfilter-devel@vger.kernel.org>; Sat, 14 Nov 2026 16:56:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bairaktaris.de; s=google; t=1794704175; x=1795308975; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Uog2DUXpaE9MlsvIhp7brTPyfcLl2qmPjN0vFybGnao=;
        b=ycuiTXa1MAM5lRMTWMtvjlVPMwTTuWOj7vJObAa2/tujat7iI21TXdAx5DMNXXcikF
         ThbJQK7409FWPK4AwZwJrflqN5AjK44+qXXV8BtJJCjMEbBZiqYb7OOJRKJIL1ygZozs
         vrW2ExfWeZP3FTOEcPUavwequI5rjwzODV1JN5YG01nMC/5pVM7POPtyGbau16HBWjl4
         VroAaK+WRIxuv/zKsAKSQLdrH0/ZKPBYAs2T1VTygnMlFzdnw1WekPvb4VuBMnBJH2bm
         8JVH59FEP/W+r01BV9CI0Nxf5xTVd1FSQUMLQH3Dcll86nZvcHRrfFnqw/1dwWOPjFKw
         wtIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794704175; x=1795308975;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Uog2DUXpaE9MlsvIhp7brTPyfcLl2qmPjN0vFybGnao=;
        b=MQNo6BMji7GSiq3dNSvwM4k1wDrKLv1XP8ZAJpurn7ukEG0ffICu5LpmbPaFgoddbh
         fy2y7beC22C2O3HE8jPmAHf3pUgMtduc23B6KU37X9xN+BAPTQiytRqAmo708oDWw2mV
         XHiJZEPGN/rxqwISOt87S5RIcj6utTgBJrXW1+M5scrRbRvNYAtyt0S0VJL4szIpwl/u
         xm5ExdPftYFpxSrxJu38GYz1tjKNU80+PNi5mVHbZEt2w144dzwD5740ihh1vGAHFV/T
         7aNOa++HMolJTH8QdEj8t1FpiqZ01rIXt/czKALWSEEDZB9yv+wUj45fRby9Ka0bAWZg
         ZJBw==
X-Gm-Message-State: APuU4Z9wDUbBvcInMKTr7J8zPHfYeS2JYuFak4NMSMu8xemqBVrc/nZw
	Og2dn/flfEQl+6dTkC2dQ2I5lOmv3mtpJ4D5mMh3MQA9GCCnyjEXV/APgxKcY2TSeqeIj0ivRU3
	dkdpm4XLU
X-Gm-Gg: AYBFou3YwQOfZAeL/t1y99q3ngIUzAw8BLbX+4qQi1sLKSjBHbE8JoN/oo68aHpOcg7
	N5CncQZBQvQebG4Jy6X3EXcNbUdRESqZpPR1n45mUdNR/1T0MTMap4Hf2SqTgmh7F9bH90OQ7c9
	ISbnwAGT+CTaw1lloGMCjBLm9GmhQeeLtkuYZEYi4kDfL/V7flgsGF6xqiVKWS6yaOwErdmoMoc
	c6YMJC1hyDGZc/6u54RYqzy4TNSoMcJbNmUhnD1MqHZ/vbRSR9j1OQMhsekX4Uh/UXYusqSCaLk
	AgHRVLElKmq/b0+oy4IBtjbRGyaaPqsu3xxgMUStJegHXGJU4EijS6faztwpz1gG08Kl/nzW2Nd
	zSviHVlNqdMCNb99BDhLzDuA9YE/XFI47sU/v80vB8bLlZXsooraQwloAD5vHqGx9x179q6d4BS
	nCAdhbMgM+gOrUEVQpXssJaXnpqLUO6DYQ+kaROILR9vXUgsCgYK6CTx0PLy+nj47QS1HMS1xwF
	uP3/yk8h9xMiogI3GokT8ZMDQSrZlx8JF2SctHZhLRGt7XoaguyLJ9zuY4ml+jflXXrn0scWfXb
	rV/NsGXxzrGL1qs62sSqreMEEv5RvuGwuRnj7dP25vOdKb5/x88+qPkHwwtszLnllu/ilHpdwTa
	hQVmXL1IAQx7UwR0cQ9A+CBpaJ2m9NyCNvLnVTU1Efq5MneAWeDcK1+WN0wKc/IobUaxwVRxCvJ
	Uf/0W9tWyX15AnYhDwSuxkVrXIHKVSlUUW8wNr+3cGlSk/ejzMFc1eGH/Vv+NYTw5eGWqb1XSak
	L+LH8ROaU7do5p03w1SM2c0t6UGNYUqqIR2hopHpPkWEzVjTTfSccRKneIzeY9Dst0/vPKsfqa4
	kwafk/xbfAumKzAO7J0iD0NHuUh4X2F2VEdshpwMAPfu22hwXgzK+3vo7kLezDfYRgamlERk
X-Received: by 2002:a17:907:ea91:b0:c4d:2cb4:7bbd with SMTP id a640c23a62f3a-c50963fae13mr575498666b.47.1794704175500;
        Sat, 14 Nov 2026 16:56:15 -0800 (PST)
Received: from Desktop (p200300f2470a670069e45948b1a17361.dip0.t-ipconnect.de. [2003:f2:470a:6700:69e4:5948:b1a1:7361])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c5095b921d4sm266313166b.83.2026.11.14.16.56.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Nov 2026 16:56:14 -0800 (PST)
From: Julius Bairaktaris <julius@bairaktaris.de>
To: netfilter-devel@vger.kernel.org
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Phil Sutter <phil@nwl.cc>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Ido Schimmel <idosch@nvidia.com>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	Eric Woudstra <ericwouds@gmail.com>,
	netdev@vger.kernel.org,
	bridge@lists.linux.dev,
	coreteam@netfilter.org,
	linux-kselftest@vger.kernel.org
Subject: [PATCH nf-next v10 3/3] selftests: netfilter: nft_flowtable.sh: roam a host between two bridge ports
Date: Sun, 15 Nov 2026 01:55:55 +0100
Message-ID: <20261115005555.645727-4-julius@bairaktaris.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261115005555.645727-1-julius@bairaktaris.de>
References: <20261115005555.645727-1-julius@bairaktaris.de>
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Move a host to another port of a bridge on the router while its flow is
offloaded, and check that the transfer continues and is offloaded again.
The cases are plain and vlan bridge ports, vlan ports whose real devices
are ports of another bridge, "bridge fdb replace", a pinned and then
deleted fdb entry, an aged out entry (the flow must stay), the plain
case over IPv6, and a vlan_filtering bridge with untagged ports, with
tagged plain and vlan ports, and with the router address on a vlan
device on the bridge. Two cases give the ports vid 10 untagged while
their pvid stays 1, with a host that tags what it sends: the router
address on a vlan device on the bridge, and on the bridge with pvid 10.
With "stack" the bridge port is a vlan device of another bridge, and
with "stackout" the host moves from behind that bridge to a port of the
outer one. Three cases check that the flow follows what the bridge
delivers: the host's port is disabled and its vlan leaves the port
(the flow must stop in both), and vlan_filtering is turned off before
the host roams.

Without the gc check the transfer stalls when the host moves.

Signed-off-by: Julius Bairaktaris <julius@bairaktaris.de>
---
v10: cases for an untagged vlan that is not the port pvid, a move from
behind the inner to a port of the outer bridge, a disabled port, a vlan
leaving the port and vlan_filtering turned off; IPv6 off on the host for
the IPv4 cases, whose router solicitations refreshed the fdb entry of
the "age" case; lines wrapped to 80 columns; rns1, rnsr and rns2
initialised for shellcheck
v9: https://lore.kernel.org/netfilter-devel/20261108155344.35845-3-julius@bairaktaris.de/

 .../selftests/net/netfilter/nft_flowtable.sh  | 364 ++++++++++++++++++
 1 file changed, 364 insertions(+)

diff --git a/tools/testing/selftests/net/netfilter/nft_flowtable.sh b/tools/testing/selftests/net/netfilter/nft_flowtable.sh
index 449c518bd947d..80caf262f1112 100755
--- a/tools/testing/selftests/net/netfilter/nft_flowtable.sh
+++ b/tools/testing/selftests/net/netfilter/nft_flowtable.sh
@@ -851,6 +851,370 @@ test_ipip
 
 test_bridge
 
+# set by setup_ns, which reuses a name it already holds
+rns1="" rnsr="" rns2=""
+
+# Roam a host between two ports of a bridge on the router while its flow is
+# offloaded, as a station moving between two access points attached to ports
+# of one bridge. The host keeps its address and mac on a bridge of its own and
+# roams by moving that bridge's port, so only the fdb changes. With a vid the
+# bridge ports are vlan devices, whose ifindex differs from the device the
+# flow transmits on. With "replace" the router's fdb entry is sticky and the
+# move is a "bridge fdb replace". With "del" the host stays, its entry is
+# pinned to the other port and then deleted, and a ping relearns it. With
+# "age" the host stays and its entry ages out, which must not tear the flow
+# down. A flow that stays on the fast path leaves no more than a few packets
+# in the forward chain, the counter tells offloaded from slow path. The plain
+# roam also runs over IPv6, and on a vlan_filtering bridge: with untagged
+# ports ("vf"), whose fdb entries are keyed by the pvid of the port, with
+# tagged ports ("tag"), and with untagged ports and the router address on a
+# vlan device on the bridge ("upper"). "asym" and "asymkeep" give the ports
+# vid 10 untagged while their pvid stays 1 and the host tags what it sends,
+# with the router address on a vlan device on the bridge or on the bridge with
+# pvid 10. With "stack" the port of br0 is a vlan device on br1, whose ports
+# the host moves between; with "stackout" the host moves from behind br1 to a
+# port of br0. With "block" the host's port is set to the disabled state,
+# which must stop the flow. With "vdel" the host's vlan leaves its port, which
+# must stop the flow, and with "toggle" vlan_filtering is turned off before
+# the host roams.
+test_bridge_roam()
+{
+	local vid=$1 how=$2 fam=${3:-4} vf=$4 trunk=$5
+	local p0=sr0 p1=sr1 r0=rr0 r1=rr1 rbr=br0
+	local mac=02:00:00:09:01:99
+	local what="roaming on bridge${vf:+ with vlan_filtering}"
+	[ "$vf" = tag ] && what="$what and tagged ports"
+	[ "$vf" = upper ] && what="$what and a vlan device on the bridge"
+	[ "$vf" = asym ] && what="$what, a vlan device on the bridge"
+	[ "$vf" = asymkeep ] && what="$what and the bridge pvid"
+	[ "${vf#asym}" != "$vf" ] && what="$what untagged on ports of pvid 1"
+	what="$what${vid:+ with vlan ports}"
+	case "$how" in
+	block) what="$what, the host's port disabled" ;;
+	vdel) what="$what, the vlan leaving the port" ;;
+	toggle) what="$what, vlan_filtering turned off" ;;
+	?*) what="$what by fdb $how" ;;
+	esac
+	[ "$trunk" = trunk ] &&
+		what="$what whose real devices are ports of another bridge"
+	[ "$trunk" = stack ] && what="$what on a vlan device of another bridge"
+	[ "$trunk" = stackout ] &&
+		what="$what from a vlan device of another bridge to a port"
+	local ftdevs="rr0, rr1, rw0"
+	local hn=10.9.1 wn=10.9.2 dot=. len=24 nodad="" ip6="" srv=10.9.2.99
+	local min=10000000
+	local dev old new slow fdb lpid cpid win=2
+
+	if [ "$fam" = 6 ]; then
+		hn=dead:9:1 wn=dead:9:2 dot=:: len=64 nodad=nodad ip6=-6
+		srv="[dead:9:2::99]"
+		what="$what over IPv6"
+	fi
+
+	setup_ns rns1 rnsr rns2
+	# router solicitations of the host would pass the bridge and refresh
+	# its fdb entry
+	if [ "$fam" = 4 ]; then
+		ip netns exec "$rns1" sysctl -q \
+			net.ipv6.conf.all.disable_ipv6=1 \
+			net.ipv6.conf.default.disable_ipv6=1
+	fi
+
+	if ! ip -net "$rnsr" link add br0 type bridge \
+	     ${vf:+vlan_filtering 1} 2>/dev/null; then
+		echo "SKIP: could not add bridge for $what"
+		[ "$ret" -eq 0 ] && ret=$ksft_skip
+		return
+	fi
+
+	ip link add sr0 netns "$rns1" type veth peer name rr0 netns "$rnsr"
+	ip link add sr1 netns "$rns1" type veth peer name rr1 netns "$rnsr"
+	ip link add rw0 netns "$rnsr" type veth peer name w0 netns "$rns2"
+	if [ "$trunk" = stackout ]; then
+		ip link add sr2 netns "$rns1" type veth peer name rr2 \
+			netns "$rnsr"
+		ip -net "$rns1" link set sr2 up
+		ip -net "$rnsr" link set rr2 up
+		ftdevs="$ftdevs, rr2"
+	fi
+	for dev in sr0 sr1; do
+		ip -net "$rns1" link set "$dev" up
+	done
+	for dev in rr0 rr1; do
+		ip -net "$rnsr" link set "$dev" up
+	done
+
+	if [ -n "$vid" ]; then
+		for dev in sr0 sr1; do
+			ip -net "$rns1" link add link "$dev" name "$dev.$vid" \
+				type vlan id "$vid"
+			ip -net "$rns1" link set "$dev.$vid" up
+		done
+		p0=sr0.$vid; p1=sr1.$vid
+	fi
+	if [ -n "$vid" ] && [ "${trunk#stack}" = "$trunk" ]; then
+		for dev in rr0 rr1; do
+			ip -net "$rnsr" link add link "$dev" name "$dev.$vid" \
+				type vlan id "$vid"
+			ip -net "$rnsr" link set "$dev.$vid" up
+		done
+		r0=rr0.$vid; r1=rr1.$vid
+	fi
+	if [ -n "$trunk" ]; then
+		ip -net "$rnsr" link add br1 type bridge
+		ip -net "$rnsr" link set rr0 master br1
+		ip -net "$rnsr" link set rr1 master br1
+		ip -net "$rnsr" link set br1 up
+	fi
+	if [ "${trunk#stack}" != "$trunk" ]; then
+		ip -net "$rnsr" link add link br1 name br1.$vid \
+			type vlan id "$vid"
+		ip -net "$rnsr" link set br1.$vid up
+		r0=br1.$vid; r1=br1.$vid
+	fi
+	# the host moves from behind br1 to a port of br0
+	[ "$trunk" = stackout ] && { r1=rr2; p1=sr2; }
+
+	ip -net "$rnsr" link set "$r0" master br0
+	[ "$r1" != "$r0" ] && ip -net "$rnsr" link set "$r1" master br0
+	ip -net "$rnsr" link set br0 up
+	if [ "$vf" = tag ]; then
+		for dev in "$r0" "$r1"; do
+			bridge -n "$rnsr" vlan add vid 10 dev "$dev"
+		done
+		bridge -n "$rnsr" vlan add vid 10 dev br0 self pvid untagged
+		for dev in "$p0" "$p1"; do
+			ip -net "$rns1" link add link "$dev" name "$dev.10" \
+				type vlan id 10
+			ip -net "$rns1" link set "$dev.10" up
+		done
+		p0=$p0.10; p1=$p1.10
+	elif [ "$vf" = upper ]; then
+		for dev in "$r0" "$r1"; do
+			bridge -n "$rnsr" vlan add vid 10 dev "$dev" \
+				pvid untagged
+		done
+		bridge -n "$rnsr" vlan add vid 10 dev br0 self
+		ip -net "$rnsr" link add link br0 name br0.10 type vlan id 10
+		ip -net "$rnsr" link set br0.10 up
+		rbr=br0.10
+	elif [ "$vf" = asym ] || [ "$vf" = asymkeep ]; then
+		# vid 10 leaves the ports untagged but is not their pvid; the
+		# host tags what it sends, so the entry is learned in vid 10.
+		for dev in "$r0" "$r1"; do
+			bridge -n "$rnsr" vlan add vid 10 dev "$dev" untagged
+		done
+		if [ "$vf" = asym ]; then
+			bridge -n "$rnsr" vlan add vid 10 dev br0 self
+			ip -net "$rnsr" link add link br0 name br0.10 \
+				type vlan id 10
+			ip -net "$rnsr" link set br0.10 up
+			rbr=br0.10
+		else
+			bridge -n "$rnsr" vlan add vid 10 dev br0 self \
+				pvid untagged
+		fi
+	fi
+	ip -net "$rnsr" addr add $hn${dot}1/$len dev $rbr $nodad
+	ip -net "$rnsr" addr add $wn${dot}1/$len dev rw0 $nodad
+	ip -net "$rnsr" link set rw0 up
+	ip netns exec "$rnsr" sysctl -q net.ipv4.ip_forward=1
+	ip netns exec "$rnsr" sysctl -q net.ipv6.conf.all.forwarding=1
+
+	# the host takes untagged frames into vid 10 and sends it tagged
+	host_port() {
+		ip -net "$rns1" link set "$1" master stbr
+		if [ "$vf" = asym ] || [ "$vf" = asymkeep ]; then
+			bridge -n "$rns1" vlan add vid 10 dev "$1" pvid
+			bridge -n "$rns1" vlan del vid 1 dev "$1"
+		fi
+	}
+	ip -net "$rns1" link add stbr type bridge
+	if [ "$vf" = asym ] || [ "$vf" = asymkeep ]; then
+		ip -net "$rns1" link set stbr type bridge vlan_filtering 1
+		bridge -n "$rns1" vlan add vid 10 dev stbr self pvid untagged
+		bridge -n "$rns1" vlan del vid 1 dev stbr self
+	fi
+	ip -net "$rns1" link set stbr address $mac
+	host_port "$p0"
+	ip -net "$rns1" link set stbr up
+	ip -net "$rns1" addr add $hn${dot}99/$len dev stbr $nodad
+	ip $ip6 -net "$rns1" route add default via $hn${dot}1
+
+	ip -net "$rns2" addr add $wn${dot}99/$len dev w0 $nodad
+	ip -net "$rns2" link set w0 up
+	ip $ip6 -net "$rns2" route add default via $wn${dot}1
+
+	# no neighbour probes, so the host only sends when it receives
+	ip -net "$rnsr" neigh replace $hn${dot}99 lladdr $mac nud permanent \
+		dev $rbr
+	ip -net "$rns1" neigh replace $hn${dot}1 nud permanent dev stbr \
+		lladdr "$(ip -net "$rnsr" -br link show br0 | awk '{print $3}')"
+
+	if ! ip netns exec "$rnsr" nft -f - <<EOF
+table inet filter {
+  counter roam_repl { }
+  flowtable f1 { hook ingress priority 0; devices = { $ftdevs }; }
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
+	slow_pkts() { ip netns exec "$rnsr" \
+			nft reset counter inet filter roam_repl |
+		grep -o 'packets [0-9]*' | cut -d' ' -f2; }
+	roam_listener_ready() {
+		ss -N "$rns2" -lnt -o "sport = :12345" | grep -q 12345
+	}
+
+	roam_stop() {
+		kill "$cpid" "$lpid" 2>/dev/null
+		wait "$cpid" "$lpid" 2>/dev/null
+	}
+
+	timeout $((SOCAT_TIMEOUT * 5)) ip netns exec "$rns2" socat -u \
+		OPEN:/dev/zero TCP$fam-LISTEN:12345,reuseaddr &
+	lpid=$!
+	if ! busywait "$BUSYWAIT_TIMEOUT" roam_listener_ready; then
+		echo "FAIL: $what: listener did not start" 1>&2
+		ret=1
+		kill "$lpid" 2>/dev/null; wait "$lpid" 2>/dev/null
+		return
+	fi
+	timeout $((SOCAT_TIMEOUT * 5)) ip netns exec "$rns1" socat -u \
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
+		     "$((${new:-0} - ${old:-0})) bytes," \
+		     "${slow:-no} forward chain packets" 1>&2
+		ret=1
+		roam_stop
+		return
+	fi
+
+	if [ "$how" = age ]; then
+		# ageing_time is in centiseconds
+		ip -net "$rnsr" link set br0 type bridge ageing_time 200
+		win=10
+	elif [ "$how" = del ]; then
+		bridge -n "$rnsr" fdb replace $mac dev "$r1" \
+			master static sticky
+		sleep 2
+		bridge -n "$rnsr" fdb del $mac dev "$r1" master static
+		ip netns exec "$rns1" ping $ip6 -c 2 -W 1 -q $hn${dot}1 \
+			>/dev/null 2>&1
+	elif [ "$how" = block ]; then
+		# the bridge no longer delivers there, nor may the flow; the
+		# disabled state sticks without STP and keeps the fdb
+		bridge -n "$rnsr" link set dev "$r0" state 0
+	elif [ "$how" = vdel ]; then
+		# the bridge no longer delivers to the host, nor may the flow
+		bridge -n "$rnsr" vlan del vid 1 dev "$r0"
+	else
+		# roam: move the host bridge to the other port and send on it
+		if [ "$how" = toggle ]; then
+			ip -net "$rnsr" link set br0 type bridge \
+				vlan_filtering 0
+			sleep 2
+		fi
+		if [ "$how" = replace ]; then
+			bridge -n "$rnsr" fdb replace $mac dev "$r0" \
+				master static sticky
+		fi
+		ip -net "$rns1" link set "$p0" nomaster
+		host_port "$p1"
+		ip netns exec "$rns1" ping $ip6 -c 2 -W 1 -q $hn${dot}1 \
+			>/dev/null 2>&1
+		if [ "$how" = replace ]; then
+			bridge -n "$rnsr" fdb replace $mac dev "$r1" \
+				master static sticky
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
+	# before the host's FIN passes the bridge and relearns the entry
+	fdb=$(bridge -n "$rnsr" fdb show br br0 | grep "$mac.*master")
+	roam_stop
+
+	if [ "$how" = vdel ] || [ "$how" = block ]; then
+		if [ $((${new:-0} - ${old:-0})) -gt 0 ]; then
+			echo "FAIL: $what: $((${new:-0} - ${old:-0})) bytes" \
+			     "delivered to a port that does not forward" 1>&2
+			ret=1
+		else
+			echo "PASS: flow offload for $what"
+		fi
+	elif [ "$how" = age ] && [ -n "$fdb" ]; then
+		echo "FAIL: $what: the host's fdb entry did not age out" 1>&2
+		ret=1
+	elif [ $((${new:-0} - ${old:-0})) -lt $min ]; then
+		echo "FAIL: $what: transfer stalled after the roam" 1>&2
+		ret=1
+	elif [ "$slow" != 0 ]; then
+		echo "FAIL: $what: $slow forward chain packets after the roam" \
+			1>&2
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
+test_bridge_roam "" "" 4 tag
+test_bridge_roam 100 "" 4 tag
+test_bridge_roam 100 "" 4 "" trunk
+test_bridge_roam 100 "" 4 "" stack
+test_bridge_roam 100 "" 4 "" stackout
+test_bridge_roam "" block
+test_bridge_roam "" vdel 4 vf
+test_bridge_roam "" toggle 4 vf
+test_bridge_roam "" "" 4 upper
+test_bridge_roam "" "" 4 asym
+test_bridge_roam "" "" 4 asymkeep
+
 KEY_SHA="0x"$(ps -af | sha1sum | cut -d " " -f 1)
 KEY_AES="0x"$(ps -af | md5sum | cut -d " " -f 1)
 SPI1=$RANDOM
-- 
2.53.0

