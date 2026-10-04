Received: from mail-ej2-f43.google.com (mail-ej2-f43.google.com [74.125.228.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F201B2E401
	for <netfilter-devel@vger.kernel.org>; Sun,  4 Oct 2026 17:16:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.228.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791134187; cv=none; b=JWuDmbsDUcdQ3bCzzJTAwYr91GFlWsOTG6rfKCMGpwraiFvJ5nHqZTb6CEm2EWuLUzLXtduiH5BmynOdC2RV9C1YIoKim5llAfB82Oluqd/31lPG8Nx0nx3Gf9ZphxUixVBdMsl+U/jNRdUrJ9k7MBx7uLsqQOOyPPL1cB/X5cY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791134187; c=relaxed/simple;
	bh=S806Z0hpfXTXnNB+NFCPkJEG1mGTEr4a/1c81/36Cfc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AxD7gTwV0u9B7gKrnFyUJ2nTmqeXnGFAJLMFFLH+rku/30k8n1WyLS2VIc8LWHxF8Lo2I+bnjJ7Z8jYSpowIaROa7YPZX6+JZWz9/LSZ5p34gOHaNGZ5NLH7nqJuIpPA0dffQ1HT7sTKQJmnManIxCLpd401PGHk7mOxPASeFxo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bairaktaris.de; spf=pass smtp.mailfrom=bairaktaris.de; dkim=pass (2048-bit key) header.d=bairaktaris.de header.i=@bairaktaris.de header.b=aK/CG+Mh; arc=none smtp.client-ip=74.125.228.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bairaktaris.de header.i=@bairaktaris.de header.b="aK/CG+Mh"
Received: by mail-ej2-f43.google.com with SMTP id a640c23a62f3a-c2a1f611461so77679966b.1
        for <netfilter-devel@vger.kernel.org>; Sun, 04 Oct 2026 10:16:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bairaktaris.de; s=google; t=1791134183; x=1791738983; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=z21Sm0vXyjYwz54boCuRf17DcAnvOs66BHPm2naaN0E=;
        b=aK/CG+MhHaFWHYi85wq2FUZpBY9c0iUdWZO9qj7XymE5yug2YSsjRm8A5r0sLNHE+A
         KMdg9vlM4qJoOW44GPdwBEXaB7qn4rBQtMqQbvgBTUucs/iI2ochx6YjqZ3S0fK35E+X
         /hpuE3UoBR9SdX7np1soJzgunHug4Hxskyql3yPvttx2L1veHeAfBf0FrWBl2SCwQjkE
         dq/gTzamV3GYH4Amv1diO2bqrWtY9uJp8RL8+IKXgjfVgejcYH6IGIxhuLCP3UI8DyJE
         4vMN4EggZBRsy+C3p4hWcFdvJiuWSA4W9v7ukNRVl0THHRBIhpOpXoL+z9tUDBDMgXBE
         YsQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791134183; x=1791738983;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=z21Sm0vXyjYwz54boCuRf17DcAnvOs66BHPm2naaN0E=;
        b=fuRRTThHdf1prDccxn3OpJphrK2gFvCZ4XFrT8srC7ByseB2DvG8kgGiab+PKPVEVY
         cEYiai9W+ibC3T8/0lvcNcSk3PbBNV0Xg6gnh56oQHiQMP0F0TxOOORGlRANOjSmiuAd
         6njgmogclEjkhoaSJco38p6EnFzJLpysq0Uo26UPtHW1IvNY4g2pHZW6DWbRBS3OxTgx
         bxnmXRbwqk0U/UBVfCFomP5tJ9MaEREIbFKtD9YZqdgZhgcXfgmQunZdeQGTr0qZjSll
         0X/04z7Rn1aUZw+dqE3/y/myYOx7Y8QCvUx9oLiHstIzCobPDf0/7lfuPYroQ9MNPo2G
         Kbqw==
X-Gm-Message-State: AFuF++lOckt11YISqLyN3nowdRNNV/1ODd1SncYfyy1/yfGB0S5KmLjK
	w3oIxHxUl4+yl6KIluWzP2PZTKgXE4UE/2r9XhDAg04gBvkpfn4/s8Tqrm06NNBIu2TwYOMmTlM
	Jvs40kQ==
X-Gm-Gg: AYBFou2d5FGtrQMCl6Eqa0WNuigoDLslOh/vsb0GkdGz7DEMV4B9Z4mLCvGIP8GVG3v
	nb3Sihjih4M2u5h/1K+TaMjKKcYKTXPtApWYIPKiVXaLga6iT3WSohm8LnIoMkfW7hOIPB0TQA4
	eMmLiwtip0wsclzpT54IUV+9QAyU4rHdXPvhXRLuRLxj0yW3+LbE4E4buJOESeLJMuUtq4bgtkP
	afSsF9S/6YH9OZ1mBjAZG2y+u99av3BjPgrMQcRfcu3BVCpZvQaS9MDX7c6ATJkVFH3rUoyyArn
	M8/Nk4gWNTtPgoO5ndq4+IFRHS6ZYnHFhJVUbfIQ2ujG3wHmIvXRNxwfQOq2Io2oEmdKwMQ9ivm
	kN0e3rRjGoex7yOvWM9zx9v2IXIBE/o3wE2y6u4aTeBojMqKHrjbyb9ZKmz5NCALs3/e9Flr+Pb
	k1OOH7ciAs0g8fhtwDl7zBNVlTqS0jwwJtQoqNGLG7RNBvswHHx1rUkIggOG4TcaWFYYsvvQqAY
	1ktnN3TG1K9iV4eT+X45RLOBaCjiD7nAxDtsRZYRMBeQU3qXm3OgxJyUYMoAFQgLTfuZ8YtH/RW
	4KHGn7ikcqV/7C8jTg/u6mb/TL5axpXKlKt9qDZmIiEip/3jTgvZAoxlIt3hGndGWwctjyUAX7+
	XzQqk4kxc/25jHfhUBH3KbNsAIzrwMvK0NhggruM6RDFRz6SWrskl8lpzXT9K7FdkEf2p0rY+ON
	tIT6evRY0fZML3Y4igrlRSineudeaW/+wnNA==
X-Received: by 2002:a17:906:dc90:b0:c2d:d4dd:8b5 with SMTP id a640c23a62f3a-c2e4ad60fdamr781095366b.19.1791134183248;
        Sun, 04 Oct 2026 10:16:23 -0700 (PDT)
Received: from Desktop (pd9513667.dip0.t-ipconnect.de. [217.81.54.103])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c2e4cd278cesm314885266b.37.2026.10.04.10.16.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 Oct 2026 10:16:22 -0700 (PDT)
From: Julius Bairaktaris <julius@bairaktaris.de>
To: netfilter-devel@vger.kernel.org
Cc: pablo@netfilter.org,
	fw@strlen.de,
	phil@nwl.cc,
	coreteam@netfilter.org,
	netdev@vger.kernel.org,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	horms@kernel.org,
	andrew+netdev@lunn.ch,
	shuah@kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	nbd@nbd.name
Subject: [PATCH nf-next 3/3] selftests: netfilter: nft_flowtable.sh: check upper device counters
Date: Sun,  4 Oct 2026 19:16:16 +0200
Message-ID: <20261004171616.3544880-4-julius@bairaktaris.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261004171616.3544880-1-julius@bairaktaris.de>
References: <20261004171616.3544880-1-julius@bairaktaris.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The bridge and tunnel tests forward through devices above the flowtable
device: br0, the tunnels, and the VLAN devices under them. Each test
sends the file in both directions, twice for IPv4 (masquerade and dnat)
and once for IPv6, so check that these devices count between n and n + 1
times the file size on rx and on tx.

Assisted-by: Claude:claude-fable-5-1
Signed-off-by: Julius Bairaktaris <julius@bairaktaris.de>
---
 .../selftests/net/netfilter/nft_flowtable.sh  | 67 +++++++++++++++++++
 1 file changed, 67 insertions(+)

diff --git a/tools/testing/selftests/net/netfilter/nft_flowtable.sh b/tools/testing/selftests/net/netfilter/nft_flowtable.sh
index 449c518bd947..e89f86916f4e 100755
--- a/tools/testing/selftests/net/netfilter/nft_flowtable.sh
+++ b/tools/testing/selftests/net/netfilter/nft_flowtable.sh
@@ -272,6 +272,43 @@ check_counters()
 	fi
 }
 
+dev_bytes()
+{
+	local ns=$1
+	local dev=$2
+
+	ip -net "$ns" -s link show dev "$dev" | \
+		awk '/RX:/ { getline; rx = $1 } /TX:/ { getline; tx = $1 } END { print rx, tx }'
+}
+
+# Fails if the fast path does not update the device counters.
+check_dev_bytes()
+{
+	local what=$1
+	local ns=$2
+	local dev=$3
+	local rx0=$4
+	local tx0=$5
+	local n=${6:-2}
+	local min=$((filesize * n))
+	local max=$((filesize * (n + 1)))
+	local rx tx
+
+	read -r rx tx < <(dev_bytes "$ns" "$dev")
+	rx=$((rx - rx0))
+	tx=$((tx - tx0))
+
+	if [ "$rx" -lt "$min" ] || [ "$tx" -lt "$min" ] ||
+	   [ "$rx" -gt "$max" ] || [ "$tx" -gt "$max" ]; then
+		echo "FAIL: $what: $dev counted rx $rx tx $tx bytes," \
+		     "expected $min to $max" 1>&2
+		ret=1
+		return
+	fi
+
+	echo "PASS: $what"
+}
+
 check_dscp()
 {
 	local what=$1
@@ -626,12 +663,18 @@ ip netns exec "$nsr1" nft -a insert rule inet filter forward 'meta oif tun6 acce
 ip netns exec "$nsr1" nft -a insert rule inet filter forward \
 	'meta oif "veth0" tcp sport 12345 ct mark set 1 flow add @f1 counter name routed_repl accept'
 
+read -r tun_rx tun_tx < <(dev_bytes "$nsr1" tun0)
+
 if ! test_tcp_forwarding_nat "$ns1" "$ns2" 1 "IPIP tunnel"; then
 	echo "FAIL: flow offload for ns1/ns2 with IPIP tunnel" 1>&2
 	ip netns exec "$nsr1" nft list ruleset
 	ret=1
 fi
 
+check_dev_bytes "IPIP tunnel counters" "$nsr1" tun0 "$tun_rx" "$tun_tx"
+
+read -r tun_rx tun_tx < <(dev_bytes "$nsr1" tun6)
+
 if test_tcp_forwarding "$ns1" "$ns2" 1 6 "[dead:2::99]" 12345; then
 	check_counters "flow offload for ns1/ns2 IP6IP6 tunnel"
 else
@@ -640,6 +683,8 @@ else
 	ret=1
 fi
 
+check_dev_bytes "IP6IP6 tunnel counters" "$nsr1" tun6 "$tun_rx" "$tun_tx" 1
+
 # Create vlan tagged devices for IPIP traffic.
 ip -net "$nsr1" link add link veth1 name veth1.10 type vlan id 10
 ip -net "$nsr1" link set veth1.10 up
@@ -686,12 +731,21 @@ ip -net "$nsr2" addr add fee1:5::2/64 dev tun6.10 nodad
 ip -6 -net "$nsr2" route delete default
 ip -6 -net "$nsr2" route add default via fee1:5::1
 
+read -r tun_rx tun_tx < <(dev_bytes "$nsr1" tun0.10)
+read -r vlan_rx vlan_tx < <(dev_bytes "$nsr1" veth1.10)
+
 if ! test_tcp_forwarding_nat "$ns1" "$ns2" 1 "IPIP tunnel over vlan"; then
 	echo "FAIL: flow offload for ns1/ns2 with IPIP tunnel over vlan" 1>&2
 	ip netns exec "$nsr1" nft list ruleset
 	ret=1
 fi
 
+check_dev_bytes "IPIP tunnel counters over VLAN" "$nsr1" tun0.10 "$tun_rx" "$tun_tx"
+check_dev_bytes "VLAN counters under IPIP tunnel" "$nsr1" veth1.10 "$vlan_rx" "$vlan_tx"
+
+read -r tun_rx tun_tx < <(dev_bytes "$nsr1" tun6.10)
+read -r vlan_rx vlan_tx < <(dev_bytes "$nsr1" veth1.10)
+
 if test_tcp_forwarding "$ns1" "$ns2" 1 6 "[dead:2::99]" 12345; then
 	check_counters "flow offload for ns1/ns2 IP6IP6 tunnel over vlan"
 else
@@ -700,6 +754,9 @@ else
 	ret=1
 fi
 
+check_dev_bytes "IP6IP6 tunnel counters over VLAN" "$nsr1" tun6.10 "$tun_rx" "$tun_tx" 1
+check_dev_bytes "VLAN counters under IP6IP6 tunnel" "$nsr1" veth1.10 "$vlan_rx" "$vlan_tx" 1
+
 # Restore the previous configuration
 ip -net "$nsr1" route change default via 192.168.10.2
 ip -net "$nsr2" route change default via 192.168.10.1
@@ -740,12 +797,16 @@ table ip nat {
 }
 EOF
 
+read -r br_rx br_tx < <(dev_bytes "$nsr1" br0)
+
 if ! test_tcp_forwarding_nat "$ns1" "$ns2" 1 "on bridge"; then
 	echo "FAIL: flow offload for ns1/ns2 with bridge NAT" 1>&2
 	ip netns exec "$nsr1" nft list ruleset
 	ret=1
 fi
 
+check_dev_bytes "bridge counters" "$nsr1" br0 "$br_rx" "$br_tx"
+
 if ip -net "$nsr1" link show tun0 > /dev/null 2>&1 &&
    ip -net "$nsr2" link show tun0 > /dev/null 2>&1; then
 	ip -net "$nsr1" route change default via 192.168.100.2
@@ -819,12 +880,18 @@ ip -net "$ns1" addr add 10.0.1.99/24 dev eth0.10
 ip -net "$ns1" route add default via 10.0.1.1
 ip -net "$ns1" addr add dead:1::99/64 dev eth0.10 nodad
 
+read -r br_rx br_tx < <(dev_bytes "$nsr1" br0)
+read -r vlan_rx vlan_tx < <(dev_bytes "$nsr1" veth0.10)
+
 if ! test_tcp_forwarding_nat "$ns1" "$ns2" 1 "bridge and VLAN"; then
 	echo "FAIL: flow offload for ns1/ns2 with bridge NAT and VLAN" 1>&2
 	ip netns exec "$nsr1" nft list ruleset
 	ret=1
 fi
 
+check_dev_bytes "bridge counters with VLAN" "$nsr1" br0 "$br_rx" "$br_tx"
+check_dev_bytes "VLAN counters under bridge" "$nsr1" veth0.10 "$vlan_rx" "$vlan_tx"
+
 # restore test topology (remove bridge and VLAN)
 ip -net "$nsr1" link set veth0 nomaster
 ip -net "$nsr1" link set veth0 down
-- 
2.53.0

