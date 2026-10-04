Received: from mail-ed2-f33.google.com (mail-ed2-f33.google.com [74.125.228.97])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E604F4718F2
	for <netfilter-devel@vger.kernel.org>; Sun,  4 Oct 2026 17:16:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.228.97
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791134209; cv=none; b=QX1+1l3/+9mXx75cHAE/rYaJ4Aa/fUOMJSbCTgaJoKnVxCrG1AZmsTIYYIV0DhMCsHCx4YDwJ6mNi7hVCDXrNTT/eF0HUnYqXvG0hYTFgoBgFuyqvMKNHgSqaX7sHQlFbYuV1WOg3llIwDr4He9INrGnqO1JauY2esPI/0djKXo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791134209; c=relaxed/simple;
	bh=Y5qEOgngxBaCHA/kBWEYUs6H+TGmwJHQkFWp/hzC6bs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WyQdZmRzL1wGf1ZMoNUzA1LR2o6QB8IeCcMNBgRGdXe8fXRK4Hix+yZ+E6ChyftcVZrmxURYRtT1T1i6hho1h42riCjYKqOcYpFe9xvEijeZbSOUeaqC71M42XOrfecqs9ipbhkWBdJtbZXhMdJwz7Z0rDlG78w2+QOkyzjuo8A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bairaktaris.de; spf=pass smtp.mailfrom=bairaktaris.de; dkim=pass (2048-bit key) header.d=bairaktaris.de header.i=@bairaktaris.de header.b=kWkRmFKX; arc=none smtp.client-ip=74.125.228.97
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bairaktaris.de header.i=@bairaktaris.de header.b="kWkRmFKX"
Received: by mail-ed2-f33.google.com with SMTP id 4fb4d7f45d1cf-6ac6fa788e6so1117186a12.1
        for <netfilter-devel@vger.kernel.org>; Sun, 04 Oct 2026 10:16:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bairaktaris.de; s=google; t=1791134204; x=1791739004; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=dHUtQGoQ43VDmpGd3bfBB5J/hFSSTUqRFc74DU6+NPk=;
        b=kWkRmFKXjXM0xC0FxMJnO6LoQmczqio07l6m6t4SxoS4hPuty0vr9Go9RpcM2pzb8M
         Vub2TL42Hh8czBNXgG7kSK41MKL8rit7M0ndzb2aTmo9gNhWWQjzHO1W41FmooNv/V7S
         sYdaVys5n3zPm7S2exm1tEhNyfTSmVOseZSG1j384ijQ5oC6upYTTEQQ/im9yp6mk22C
         1IRRDgl9Uvs8qWXYKtWcb1eBYpznbB1Zhr11Mu31e7jESXOdA3FvJXPh2CO+ZF9w2tEz
         JWV+m5Ib4rsI0zRyU07aWI5+pSvv3StVIWrxr2JYWQuc/qRG4guds8OXo/k/7YpZiLNW
         Rkag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791134204; x=1791739004;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=dHUtQGoQ43VDmpGd3bfBB5J/hFSSTUqRFc74DU6+NPk=;
        b=LoPA8/cx9jvWFobUD20ajlwKY3ZKSS8Ms0oJueKcyHxj/iYeVbX7xne19i88Ui3TK8
         08LinLYQ7ur6ZFUbDKAHHT0K5q5qS2kYYPFz9qhynt1z8JT6tLf8rzWW+AH8JRlSY3VA
         ImU3LTUSGjr8kkUawGgSOZUG2J57ro1BQYPQut16rC10CP89LfSexsAAkgXaH7kfTuen
         nGhZR9nYtVGnQD4xdTZ3Kw1bd/PlAeyonkmltqgiqtOx16rwhCpiIX1vK7UPa8MH4Dh8
         6AfmIVwfO+FIoVGkO8OVgmFFU1OxqUOM/XpR8fItEXiRAUoDsCzJz705Rz8YcMLlM5d0
         wzEw==
X-Forwarded-Encrypted: i=1; AKwUvBzf7juNBAVdpEnaUwwFzydWWbO31wPf06qsGPLqHg17+HMVetl4otnE+byKWE/8EVbmlgGOOYzLmMyfMYcylXw=@vger.kernel.org
X-Gm-Message-State: AFq9FYI7EA4HESPn+Q3ckMS6ssvXV8Kx+lXzY2SttgpDi1IfrrPTALpv
	dWtIH8RwebSoNMKlB+Odlkma1QTzat168YICj7lWIAZovPMLjuJ9C3Lj5MZg4cfFDg==
X-Gm-Gg: AYBFou3/BF8lIR1AYt+x7+6jx+i20pt9tNkvyG/FwiYgK7hU5q2JwdnVoSPyPWDZumC
	ONtFuSMXhIKA0s+F3KmIzL1NyI/cqUIYwMaDqnHpFqjtDiq/9D+i+K21laLI6qWftolSmUXUmly
	4ixiqz7KzkQ0n/hZo4Uzgmno0bHzTgpk4Fy6PYoc2jgS4e9Q8Eccxu131N/1VqgQFGDmHLJPc6S
	cfLvsT2TT9cygRMW6YbWPZwjUBZTs3Gb+I5mlqz4Ktd+rQSpfeNUxS9RXp98Q9Uy7Uqob9Ocnow
	GA702AdIKXo+BESyYzypbhBXtc2Mj2k+FuE84sDNbyvYuSXlDydIP+JWCp3uKP+RHXQepMHgqox
	OfBS6coDbnLgE854CuBVUSBt8H8LXsNxzddw2hKPZJ/efZ60JEHALw/nBCGbImB6eFCnlp+dnNy
	uf5+ENCe4ZzGEW/Jyyqn8qb6KW1D3AOX+Xjv/S71YCv39+hZGCIA4YtC5FP/qMC2nI4XgXuDlFB
	JlGOsDCfWkANYe1oQnrOTnqiL9VGty9pdQ2XSS/jxHaFRg3Gju2Yni+FvQdh7tbazg/ne+01CJJ
	MZQwy/iM+/RBAX6nv/y3Mm+znC1xt7+p0oRg3ccMBjR/Attb9EHqgWKHHk7Rp6zh+ZhimOeA92W
	advYK9VcC8NWsuYYF721kvZoA1VFynBzzIZ3OGIpfwGb+J6tO5pZH1PJ7B48/+DHunZ3Z7rsH1s
	PTzRhbCuNP7JeStbGsPvPEYzQ=
X-Received: by 2002:a05:6402:52c1:b0:6ac:7737:e50d with SMTP id 4fb4d7f45d1cf-6af9e2fd054mr5882545a12.29.1791134203816;
        Sun, 04 Oct 2026 10:16:43 -0700 (PDT)
Received: from Desktop (pd9513667.dip0.t-ipconnect.de. [217.81.54.103])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6afb014784bsm2256819a12.3.2026.10.04.10.16.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 Oct 2026 10:16:42 -0700 (PDT)
From: Julius Bairaktaris <julius@bairaktaris.de>
To: pablo@netfilter.org,
	fw@strlen.de
Cc: phil@nwl.cc,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	netdev@vger.kernel.org,
	lorenzo@kernel.org,
	nbd@nbd.name,
	matthias.bgg@gmail.com,
	angelogioacchino.delregno@collabora.com,
	andrew+netdev@lunn.ch,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	horms@kernel.org,
	corbet@lwn.net,
	rdunlap@infradead.org,
	skhan@linuxfoundation.org,
	linux-doc@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mediatek@lists.infradead.org,
	linux-arm-kernel@lists.infradead.org,
	saeedm@nvidia.com,
	leon@kernel.org,
	tariqt@nvidia.com,
	mbloch@nvidia.com,
	linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH nf-next v3 3/3] selftests: netfilter: nft_flowtable.sh: check the priority a flow carries
Date: Sun,  4 Oct 2026 19:16:36 +0200
Message-ID: <20261004171636.3545085-4-julius@bairaktaris.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261004171636.3545085-1-julius@bairaktaris.de>
References: <20261004171636.3545085-1-julius@bairaktaris.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Count the forwarded TCP packets that leave with priority 0:3 and those
that leave with none, first without a priority and then with "meta
priority set 0:3" ahead of "flow add". With the priority set, every
packet must carry it, including those the flowtable forwards. Runs for
IPv4 and IPv6.

Assisted-by: Claude:claude-fable-5-1
Signed-off-by: Julius Bairaktaris <julius@bairaktaris.de>
---
 .../selftests/net/netfilter/nft_flowtable.sh  | 110 ++++++++++++++++++
 1 file changed, 110 insertions(+)

diff --git a/tools/testing/selftests/net/netfilter/nft_flowtable.sh b/tools/testing/selftests/net/netfilter/nft_flowtable.sh
index 449c518bd947..73c7b1ec2208 100755
--- a/tools/testing/selftests/net/netfilter/nft_flowtable.sh
+++ b/tools/testing/selftests/net/netfilter/nft_flowtable.sh
@@ -458,6 +458,106 @@ fi
 	check_dscp "dscp_fwd" "$pmtu"
 }
 
+check_priority()
+{
+	local what="$1"
+	local pmtu="$2"
+	local ok=1
+
+	local counter
+	counter=$(ip netns exec "$nsr1" nft reset counter netdev priocheck prio3 | grep packets)
+	local pc3=${counter%*bytes*}
+	pc3=${pc3#*packets}
+
+	counter=$(ip netns exec "$nsr1" nft reset counter netdev priocheck prio0 | grep packets)
+	local pc0=${counter%*bytes*}
+	pc0=${pc0#*packets}
+
+	local failmsg="FAIL: pmtu $pmtu: $what counters do not match, expected"
+
+	case "$what" in
+	"prio_none")
+		if [ "$pc3" -gt 0 ] || [ "$pc0" -eq 0 ]; then
+			echo "$failmsg prio3 == 0, prio0 > 0, but got $pc3,$pc0" 1>&2
+			ret=1
+			ok=0
+		fi
+		;;
+	"prio_fwd")
+		if [ "$pc3" -eq 0 ] || [ "$pc0" -gt 0 ]; then
+			echo "$failmsg prio3 > 0, prio0 == 0, but got $pc3,$pc0" 1>&2
+			ret=1
+			ok=0
+		fi
+		;;
+	*)
+		echo "FAIL: pmtu $pmtu: unknown priority check $what" 1>&2
+		ret=1
+		ok=0
+	esac
+
+	if [ "$ok" -eq 1 ] ;then
+		echo "PASS: $what: priority packet counters match"
+	fi
+}
+
+test_tcp_forwarding_set_priority()
+{
+	local pmtu="$3"
+	local proto="$4"
+	local dstip="$5"
+	local dstport="$6"
+	local lret=0
+
+ip netns exec "$nsr1" nft -f - <<EOF
+table netdev priocheck {
+   counter prio0 { }
+   counter prio3 { }
+
+   chain egress0 {
+      type filter hook egress device "veth0" priority 0; policy accept
+      meta l4proto tcp meta priority 0:3 counter name "prio3"
+      meta l4proto tcp meta priority none counter name "prio0"
+   }
+
+   chain egress1 {
+      type filter hook egress device "veth1" priority 0; policy accept
+      meta l4proto tcp meta priority 0:3 counter name "prio3"
+      meta l4proto tcp meta priority none counter name "prio0"
+   }
+}
+EOF
+	if [ $? -ne 0 ]; then
+		echo "SKIP: Could not load netdev:egress for veth0 and veth1"
+		return 0
+	fi
+
+	if ! test_tcp_forwarding_ip "$1" "$2" "$pmtu" "$proto" "$dstip" "$dstport"; then
+		lret=1
+	fi
+	check_priority "prio_none" "$pmtu"
+
+	# The flow stores the priority set before it is added, so the packets
+	# the flowtable forwards leave with it too, in both directions.
+ip netns exec "$nsr1" nft -f - <<EOF
+table inet prioset {
+   chain forward {
+      type filter hook forward priority -1; policy accept
+      meta priority set 0:3
+   }
+}
+EOF
+	if ! test_tcp_forwarding_ip "$1" "$2" "$pmtu" "$proto" "$dstip" "$dstport"; then
+		lret=1
+	fi
+	check_priority "prio_fwd" "$pmtu"
+
+	ip netns exec "$nsr1" nft delete table inet prioset
+	ip netns exec "$nsr1" nft delete table netdev priocheck
+
+	return $lret
+}
+
 test_tcp_forwarding_nat()
 {
 	local nsa="$1"
@@ -516,6 +616,11 @@ else
 	ret=1
 fi
 
+if ! test_tcp_forwarding_set_priority "$ns1" "$ns2" 0 6 "[dead:2::99]" 12345; then
+	echo "FAIL: IPv6 flow offload for ns1/ns2 with priority update" 1>&2
+	ret=1
+fi
+
 # delete default route, i.e. ns2 won't be able to reach ns1 and
 # will depend on ns1 being masqueraded in nsr1.
 # expect ns1 has nsr1 address.
@@ -572,6 +677,11 @@ if ! test_tcp_forwarding_set_dscp "$ns1" "$ns2" 1 4 10.0.2.99 12345; then
 	exit 0
 fi
 
+if ! test_tcp_forwarding_set_priority "$ns1" "$ns2" 1 4 10.0.2.99 12345; then
+	echo "FAIL: flow offload for ns1/ns2 with priority update and pmtu discovery" 1>&2
+	ret=1
+fi
+
 ip netns exec "$nsr1" nft reset counters table inet filter >/dev/null
 
 if ! test_tcp_forwarding_nat "$ns1" "$ns2" 1 ""; then
-- 
2.53.0

