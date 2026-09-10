Received: from mail-ej2-f7.google.com (mail-ej2-f7.google.com [74.125.228.135])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FC74396B76
	for <netfilter-devel@vger.kernel.org>; Thu, 10 Sep 2026 09:01:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.228.135
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789030870; cv=none; b=HO1wBqDKz9YcY5LRCf8ggNje+sw7sSfoShm5UOYnw1onqFQBCI5gSSe9ulULpV+zIFLPB/n17uvh2nFmV0dlzCScBGHioz8lqQ545ioQ8IpXuuHdfprvBCo9hG5JfqMYB5RQjDYChAg1JjsioLTAL14rh/YyeDuoBhCvuophrkc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789030870; c=relaxed/simple;
	bh=9VC8+RYrNRRiaQZd+CDVz83hUbh0LCzg9iGqE7yiAIE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ph19Fu/gmlc5uQ7HmaQV5jfkAeWyO9KvIqHu2eayKMjbHTlTks5e6/2Q4BQ/zxIlB5Re12iaOYVakSEBTvfcVWbTY9cqPECMZUYKvIoa5nTNr2mrHne00LTgzlRTTGsB5oDGagjLARWMJjCut8yvnHrIyE4J3kL5MwnU06qrDXA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bairaktaris.de; spf=pass smtp.mailfrom=bairaktaris.de; dkim=pass (2048-bit key) header.d=bairaktaris.de header.i=@bairaktaris.de header.b=OdIv4lCP; arc=none smtp.client-ip=74.125.228.135
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bairaktaris.de header.i=@bairaktaris.de header.b="OdIv4lCP"
Received: by mail-ej2-f7.google.com with SMTP id a640c23a62f3a-c29390fa872so69991066b.1
        for <netfilter-devel@vger.kernel.org>; Thu, 10 Sep 2026 02:01:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bairaktaris.de; s=google; t=1789030857; x=1789635657; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=VXVlYl1gjLPwgKI1iO6doAk96CF1C9KclFcluRlvCtI=;
        b=OdIv4lCPZJ15YKMdPEdVIqkiJCLqIB+7qndbE+aaWygcCfekkYABRFD9aFFmBo5QMz
         WtzNzCezWtQY73Z6E8wIWbo3QDyAbI/D5vkkulSAxhRwjcvyLe/xzRW3zfccfLpWuL6t
         /Qk/YeAruQ/ECN7wwjBH7OOS6KxBBxG1i35GYc9FKjCHrD3azfBMYZK5Q1E1UpxAaduI
         zQjcKMEPbT/25nxVVaKxKa8grXUD+2MICcg4XL13wZ0GxQcrKbx8N5OaQ0H4YGo5/1D+
         bazxsLzEDLGp4ZEGunEMZxupArVlcogcKXmYYDWWkZT6N0b+WkR7hHkBrDwSjw4i/b/m
         FTuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789030857; x=1789635657;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=VXVlYl1gjLPwgKI1iO6doAk96CF1C9KclFcluRlvCtI=;
        b=fFr7ld1bDbYVZ8aJGFH8ftWIR0NtZkTdGKoF7musx+2ns0AKqrkw7bPpsTqDzXr/CF
         HjYyoB93HWqck1g+OXv9MRwh7ACzdEUNTPl4AKC3hlWE60m5UisNehGVwIS3rYuih9Bj
         uDdBxVLU/l/n66KOFhfSE8zVqxjQzrRXn08wa08fdpCymQwA+N8IcH8H2mJuXnY+55bL
         4TVji72kSKt8yRWToQW9bKrYRgSE+2dPXMP718TpmsKxcMxLC/8IdI5smUGfRviQ6X7e
         rTCd1OH8CJV4cBOjOtagbeQ3sZIRG9v69UPxWzwWOld1GhcHS3Viiwalyi8aKV7Omtf0
         HuHw==
X-Forwarded-Encrypted: i=1; AKwUvBwbssM7PAVcJy5b0jCJ7Pw7G7i8IYw1uIWtUFvlIylf4jVzJmD31nHblo2IaahYQvFayJyCm84wyV5HmTh+3jA=@vger.kernel.org
X-Gm-Message-State: AFuF++kTozADHzG2bzTRCd2qDZJVrCRp7Zz1itOPDvmIgrv1ZSKlmoRX
	ZobbxRxdrY7gIf3bS7JOhx4dqULIXvAYbpyOFgkUHI8jGbFTasllu6DOrLAcGs+kxQ==
X-Gm-Gg: AYBFou2S1As2pVxjA6TDUQnvuH/4z6QM5s8YeWBIXlPN2mqiDYO9vaIBU4fRbHA6/ra
	3Hd4uIVe2mNGnW4jJ//jRSg5yr7caTpbronvWAcIjadNmtTEZdj7s4e+A/cq8GR5W52JoQpVR8a
	8upx5qJp/SFUHWdMX/FJGiWnarjFC5qTg00hkPWmyS9cIckJPaVOJgK923237ZFfnDTcsOsb76T
	/dc814B+tSmhjFPUKX/H2TypUMCSgBcK8NmWq+w/Y0zHs6OQpAkRMVnu9/TC1PXkq++7O2juSqS
	rViogFLHlx3zx/VulryrKaZ5K0fXlg9kpVqB1caSP5KXsf1kNq7JHtqzscQ5ZZNnSORBtSSkqEv
	sXaE/5iww5rkr2ogk/iLR48sakHwy3H4577A1Rp++MEloA6hgVtSqH5set4xEdzCRcvYxGwdGsA
	zXLc8S0KRVAa4X9npqCPRTxAKWLhS+0AdBggBwmSue+OPccck4zEHNm10FsFe6C1z0LKeVPiaT1
	wgXuqrAOe1W1ZTm5jjCz8ekc2rbZCTtw2I1jzw+lO9BrsxE7NuuHMAl930zEvS1DFwx+FLu+hVd
	hvOLGuDvPJLWNqSMHn8Qze60CMoP2zr+jOQkIhOxVotmUbW3WiYzU221CNo6dErfAjoDQJTCmG8
	z33S0pA/oLxVELbZX5LpDTzR2iyy32Ofu74+6EZemPgYht7O6s7qYIuldr9SzYXDfXq4kkUxJc3
	eUnh1yHA==
X-Received: by 2002:a17:907:3eaa:b0:c26:37fb:3461 with SMTP id a640c23a62f3a-c2637fb36b0mr1280186666b.46.1789030857283;
        Thu, 10 Sep 2026 02:00:57 -0700 (PDT)
Received: from Desktop.fritz.box ([217.26.235.87])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c293eaf1ae8sm156106766b.40.2026.09.10.02.00.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Sep 2026 02:00:56 -0700 (PDT)
From: Julius Bairaktaris <julius@bairaktaris.de>
To: pablo@netfilter.org,
	netfilter-devel@vger.kernel.org
Cc: kadlec@netfilter.org,
	fw@strlen.de,
	coreteam@netfilter.org,
	netdev@vger.kernel.org,
	geldot@protonmail.com
Subject: [PATCH nf-next 4/4] selftests: netfilter: cover a TCP flow whose reply is never seen
Date: Thu, 10 Sep 2026 11:00:52 +0200
Message-ID: <20260910090052.2034970-5-julius@bairaktaris.de>
In-Reply-To: <20260910090052.2034970-1-julius@bairaktaris.de>
References: <20260910090052.2034970-1-julius@bairaktaris.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add an arm to nft_flowtable.sh in which ns2 answers over a direct link,
so that nsr1 sees the original direction only. The forward hook counter
then has to stay far below the size of the transferred file, which only
happens if the flowtable takes the connection over.

Signed-off-by: Julius Bairaktaris <julius@bairaktaris.de>
Assisted-by: Claude:claude-opus-5
---
 .../selftests/net/netfilter/nft_flowtable.sh  | 73 +++++++++++++++++++
 1 file changed, 73 insertions(+)

diff --git a/tools/testing/selftests/net/netfilter/nft_flowtable.sh b/tools/testing/selftests/net/netfilter/nft_flowtable.sh
index 449c518bd947..516a544266f1 100755
--- a/tools/testing/selftests/net/netfilter/nft_flowtable.sh
+++ b/tools/testing/selftests/net/netfilter/nft_flowtable.sh
@@ -516,6 +516,79 @@ else
 	ret=1
 fi
 
+# Asymmetric path test:
+# ns2 answers over a direct link, so nsr1 sees the original direction only.
+# Such a connection never becomes assured, but the flowtable is expected to
+# take over the direction that nsr1 does see.
+check_orig_offloaded()
+{
+	local what=$1
+
+	local orig
+	orig=$(ip netns exec "$nsr1" nft reset counter inet filter routed_orig | grep packets)
+	local orig_cnt=${orig#*bytes}
+
+	local fs
+	fs=$(du -sb "$nsin")
+	local max_orig=$(( ${fs%%/*} / 2 ))
+
+	# the flowtable takes over after the first few packets, so the forward
+	# hook must see a small fraction of the transferred file.
+	if [ "$orig_cnt" -gt "$max_orig" ];then
+		echo "FAIL: $what: original counter $orig_cnt exceeds expected value $max_orig" 1>&2
+		ret=1
+		return 1
+	fi
+
+	echo "PASS: $what"
+}
+
+test_asymmetric_path()
+{
+	ip link add name eth1 netns "$ns1" type veth peer name eth1 netns "$ns2"
+	ip -net "$ns1" addr add 10.0.9.99/24 dev eth1
+	ip -net "$ns2" addr add 10.0.9.98/24 dev eth1
+	ip -net "$ns1" addr add dead:9::99/64 dev eth1 nodad
+	ip -net "$ns2" addr add dead:9::98/64 dev eth1 nodad
+	ip -net "$ns1" link set eth1 up
+	ip -net "$ns2" link set eth1 up
+
+	# ns1 keeps sending through nsr1, ns2 answers on the direct link.
+	ip -net "$ns2" route add 10.0.1.99 via 10.0.9.99 dev eth1
+	ip -6 -net "$ns2" route add dead:1::99 via dead:9::99 dev eth1
+
+	ip netns exec "$ns1" sysctl -q net.ipv4.ip_no_pmtu_disc=0
+	ip netns exec "$ns2" sysctl -q net.ipv4.ip_no_pmtu_disc=0
+
+	ip netns exec "$nsr1" nft reset counters table inet filter >/dev/null
+
+	if test_tcp_forwarding "$ns1" "$ns2" 1 4 10.0.2.99 12345; then
+		check_orig_offloaded "flow offloaded for ns1/ns2 without reply"
+	else
+		echo "FAIL: flow offload for ns1/ns2 without reply" 1>&2
+		ip netns exec "$nsr1" nft list ruleset 1>&2
+		ret=1
+	fi
+
+	ip netns exec "$nsr1" nft reset counters table inet filter >/dev/null
+
+	if test_tcp_forwarding "$ns1" "$ns2" 1 6 "[dead:2::99]" 12345; then
+		check_orig_offloaded "IPv6 flow offloaded for ns1/ns2 without reply"
+	else
+		echo "FAIL: IPv6 flow offload for ns1/ns2 without reply" 1>&2
+		ip netns exec "$nsr1" nft list ruleset 1>&2
+		ret=1
+	fi
+
+	ip netns exec "$ns1" sysctl -q net.ipv4.ip_no_pmtu_disc=1
+	ip netns exec "$ns2" sysctl -q net.ipv4.ip_no_pmtu_disc=1
+
+	ip -net "$ns1" link del eth1
+	ip netns exec "$nsr1" nft reset counters table inet filter >/dev/null
+}
+
+test_asymmetric_path
+
 # delete default route, i.e. ns2 won't be able to reach ns1 and
 # will depend on ns1 being masqueraded in nsr1.
 # expect ns1 has nsr1 address.
-- 
2.53.0

