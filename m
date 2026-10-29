Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.168.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793280949;
	b=3F0TQkXJQ1HbLB7VybJmW7ytOgvkV34zadXDfcr5uhrsMiPCQll1smxm8/dCLu8X/2vh
	 8mbhFcbmoKG0D68lW5Yy1OXbNObngm6S0sd2H4plzybRP4J38jdgeC1/QpuPpiXyfwQu1
	 q6AsZ+2kDW8g+/4ly2ohQFue52+7ozuZbS4MGqGu9XuJn9BBr0aEnGD2jfUhateWEwgL6
	 f+UB+A0NQlKPGX4r2M3xVEw0ERvYHCMtUMWdlKNcj0gQy+Z/9WJD2acIzcb/JJ3nhApCa
	 pfQ9drbku7n9d3yZLysdV5aUWWt2yhazFkP7+B91LAXU7gkI2M7h2SOxiNu9uZZryhA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793280949;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Gm-Message-State:X-Gm-Gg:
	 X-Received:X-Received:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:Message-Id:References:
	 In-Reply-To:To:Cc:X-Mailer:X-Proofpoint-Spam-Info:
	 X-Proofpoint-Spam-Details-Enc:X-Authority-Analysis:X-Proofpoint-GUID:
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=bkyFaU7pm1UiMcf0aTZkl/EEwuv05ryAASaXqNs27JQ=;
	b=J4t3kv9u+foCYKWD1iHrlnq8mFXRm/0P45jaCsrxOOM1LqYljlqFiEiVd1fX/+kncWff
	 C1tKbsEh/KI4H+4RTjJRIaubY/7u6mMPsYa7LWiT/QibuHLv+blpnzXx+FKylyVWvtiNB
	 C7RhITbCha5LGiQVZnPZXjxdgQ/tOkFGDgKZ4YcGb25dLlPRzrdy0zWLfQ6ifNEfgrlmO
	 P7c7pTa9iyZ8iJPnJxCuHf+Z8VJ+0N4xG3LZ5tEcVjY5jOwBo/i4JaIOC1n4OGYWZQf+K
	 dimDKCr8YH4D2KDk6i7S9VWPJppHFbs1weBJnVddZGtmnc61prnyyJ4vvJBcdswQJGQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=FoqdTPxH;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=hr4Hcjth;
	arc=none smtp.remote-ip=205.220.168.131
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1789D60A2630
	for <netfilter-devel@vger.kernel.org>; Thu, 29 Oct 2026 13:35:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1789D60A2630
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=FoqdTPxH;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=hr4Hcjth
Received: from pps.filterd (m0279864.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69TCeJm22761950
	for <netfilter-devel@vger.kernel.org>; Thu, 29 Oct 2026 13:35:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	bkyFaU7pm1UiMcf0aTZkl/EEwuv05ryAASaXqNs27JQ=; b=FoqdTPxHHpMLBuHA
	ewO83g2k/YFW0Y1q1cbkUMEq21OQUJ//YhmvBFtr8kfuYnDWazB3x1gZWJ94T0Pz
	yUZ7pQ37mDeJOIdSURryJzQSsZVFzLt5QttIlJVpEEN4RaJRQxOEI5R1eEs9vlL7
	3/pebAhzcMbXf95bMNkBtBSqa/abdND8onrWC+gtvlrxCcasVqbUKPc8jk01D9OO
	QnbMZytp06Jn8+Sq+N+r+UxnphRGNLblH0eYnqXy49ZzP3nDa19kUu3YHz86bCLh
	7IdoG419IseT9/YhMO0YBARbdUH1FDHP/NHv9lv7lLdU6SfomC+EHn8eWGYMdSKK
	B/XTIQ==
Received: from mail-vs1-f70.google.com (mail-vs1-f70.google.com [209.85.217.70])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hm31b10s7-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <netfilter-devel@vger.kernel.org>; Thu, 29 Oct 2026 13:35:48 +0000 (GMT)
Received: by mail-vs1-f70.google.com with SMTP id ada2fe7eead31-7bf08dc2fc8so461122137.0
        for <netfilter-devel@vger.kernel.org>; Thu, 29 Oct 2026 06:35:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1793280947; x=1793885747; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=bkyFaU7pm1UiMcf0aTZkl/EEwuv05ryAASaXqNs27JQ=;
        b=hr4HcjthmJVKBY8bm/Qto0iyTNnkramsR95Xjsw1SJzWf6rU0M2LBdTECikOogbCvM
         DIqgiTu1Enc3urXA9zHnRtyCocChyehaRSuRSPaAaUuuPQyKHHCbG08r5jJLD+dvHNSC
         7gao/jEz+OxHGum6s0Gf7cdhzsy3G/wI8OS1k1xDHbcbprky4M5SEMqIU/clQpBcVlLx
         qz4XPlzLTVqZTP2wR96rm0CaR0vqTRRKFwnRsPO7rLVJ/cn2Vr46VLcGaCo9qe93NQW/
         0V73nlI5Jx+HFdz18fbdt5xWWBZ3GFnwogEslkOlwQR53oBPs0mo/XjvtgbCsWWj+eEY
         WIIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793280947; x=1793885747;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=bkyFaU7pm1UiMcf0aTZkl/EEwuv05ryAASaXqNs27JQ=;
        b=1SrCuzXx/JBUQqcD6rPef8/1ZUl+0jsiqzvGP5UScg2y6MPRXxTkfQ3bCb/+//x83a
         OsVau1xz9ePf+XPOvHCPbooJV5Jqd5Y2vmDnAgcJpRbRR7rswACwkFOj46ynp76V6Srs
         PDoOtQ7JoAQvxutdurrzDqUxJoBfYOZHZY+b6PirVzScgh1Pl9q8Fuf8bFTVnwfgq6pW
         cfmkh7jPOBC6aeWgE5ghiXNsGlPUNbvNB+plS0G5SCht8sXQWOlFLoL0eeBpkbu9rymm
         +73GYoqg9HhQqmUENyXHnlNYp6qPlvx3a8Zsixuvc7UGWs5Eya5O1SdroASTmOwT0+kB
         xl5Q==
X-Gm-Message-State: AFq9FYLH1eSdGsGMVwe3Zy8WNUdNKFJO4vvyww298rdfgufJFE7+XroQ
	MOqiH9k74B84F6zukuvFnO3cQTt3zNxiocqdkUXCmohGdFrIa2kXzB30a5ZMimN11/HwwhcQEy7
	5Ay1dCmxA5sJ+oshUWA/7M+TovstRjnUnyUg4muHU3tl47HgFxBfyGSp04fbbAumEu7kyKdA=
X-Gm-Gg: AYBFou0vvahZPyE5sbo65T2lhaBm7PyPaHgcBv7ye8+FagXUmZVavPhRDqk89KrvNJJ
	5vHT8uRNWAgLzOiWn5T24s0md6kMIL5BzhN3T0rYDMR9XPHsf5/V2cpscnVObrL3hlGVCPGDi0e
	Y/yjswyfGV1lEPD3y4V6Z6UJTbvLsOkx6azKInPm4QVKz3kyhus5L5Kc4+UW6v6+L/40NaZq7uj
	FfNaZCkya5C54TZPYXs/f1Vw7LdUojn87xG327lHb5yGKMs6quG044F4Ve5fbgofkwb/iEK7XKp
	mtXdzO8R1y/U/P807iotqm3b57N0/VXbhFEjg9/EaP/PGyGhk2+/ZZa24lCBcIy2qRdmGm5aeMH
	nxqzLtiEc1zq7zwdWPsKCs+K06SYZhWVc8zpMZslnCRpXHW3nnp1+VbEiHk7ZTyiJIq+3nZZDB5
	3T+TOb2VbrBuer2wE90mA0HA==
X-Received: by 2002:a05:6102:6ce:b0:7cc:56a:58da with SMTP id ada2fe7eead31-7d03a5c76bdmr2580940137.23.1793280947134;
        Thu, 29 Oct 2026 06:35:47 -0700 (PDT)
X-Received: by 2002:a05:6102:6ce:b0:7cc:56a:58da with SMTP id ada2fe7eead31-7d03a5c76bdmr2580907137.23.1793280946541;
        Thu, 29 Oct 2026 06:35:46 -0700 (PDT)
Received: from localhost (net-93-144-6-81.cust.dsl.teletu.it. [93.144.6.81])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e3ecd3418sm30851162f8f.41.2026.10.29.06.35.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Oct 2026 06:35:45 -0700 (PDT)
From: Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>
Date: Thu, 29 Oct 2026 14:35:17 +0100
Subject: [PATCH nf-next 6/8] selftests: netfilter: nft_flowtable.sh: add
 IPv4 over IPv6 flowtable selftest
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261029-flowtable-sw-accel-ip6ip-sit-v1-6-6a17c54f9fb7@oss.qualcomm.com>
References: <20261029-flowtable-sw-accel-ip6ip-sit-v1-0-6a17c54f9fb7@oss.qualcomm.com>
In-Reply-To: <20261029-flowtable-sw-accel-ip6ip-sit-v1-0-6a17c54f9fb7@oss.qualcomm.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>, Florian Westphal <fw@strlen.de>,
        Phil Sutter <phil@nwl.cc>, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>,
        David Ahern <dsahern@kernel.org>, Ido Schimmel <idosch@nvidia.com>,
        Shuah Khan <shuah@kernel.org>
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kselftest@vger.kernel.org,
        Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>
X-Mailer: b4 0.14.3
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDI5MDA1MyBTYWx0ZWRfX5u/vZobT0cv+
 7K1FMHV6r9hLTo67NWcSQui3kQfiDvbQfniLRaFoGqa+voFyh9B5JM8rgLt1OZY6tVoZiHg9IDc
 7saloWVAVD0BJjws4fhv1JtnEQN27Ok=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDI5MDA1MyBTYWx0ZWRfX61vmXu8giVXc
 M5SJt6KVSvoWVera1MAVT+0/9yMYPxEwTBU2T3HXK5VXeHJ1B6U4k/mp5gQytu0r5GgYfZDuECh
 32DkwavQU40oqlSgoIwsJv9vFn1SCrEHCN1XWtbv8MvLYMQlOp0MHj+q81Oq6htnQ10wtrIvnaP
 ptcfBqf6b40izYyN+EkWb5jZ0ZdruoUlpGMRXnAyQ8ZyROAyTYh7RcLGu++mTJFAdPuE71RL1W5
 xuVWlSwBRN5g0n5U327+aNSaT9mTt1q2CdFESn6ab3OQOGRbNvIfmTZBCJwRIpT8pE1AyCOdR6o
 YVtYsbGfzf/tL/U1mKRd2Ff7iUGDypspACq/kYENx2fAzAipyRa+ibetp3tA5GrXCGlz/2wCvlG
 s7y5j9dBx+zPpeSxnxnDoKuqOzuEcbr+B7JVQ0J3JoBoRxFc+3EvdpB0wwA/b0KljMqUxB/lsgj
 fRCVUgVdTT9kOm3KqFQ==
X-Authority-Analysis: v=2.4 cv=A8T5rKWG c=1 sm=1 tr=0 ts=6ae34bb4 cx=c_pps
 a=N1BjEkVkxJi3uNfLdpvX3g==:117 a=7fYLNvKHbgS61GKHX+yayQ==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=DJpcGTmdVt4CTyJn9g5Z:22
 a=EUspDBNiAAAA:8 a=bN0dAzVfwMEGxDOd9cEA:9 a=QEXdDO2ut3YA:10
 a=crWF4MFLhNY0qMRaF8an:22
X-Proofpoint-GUID: AzqpEM76owQZsHocYONfuAsSGU0NFZYJ
X-Proofpoint-ORIG-GUID: AzqpEM76owQZsHocYONfuAsSGU0NFZYJ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-10-29_04,2026-10-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 spamscore=0 bulkscore=0 priorityscore=1501 impostorscore=0
 malwarescore=0 clxscore=1015 suspectscore=0 lowpriorityscore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610190000 definitions=main-2610290053

Similar to IPIP and IP6IP6, introduce specific selftest for IPv4 over IPv6
flowtable sw acceleration in nft_flowtable.sh

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>
---
 .../selftests/net/netfilter/nft_flowtable.sh       | 33 +++++++++++++++++++---
 1 file changed, 29 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/net/netfilter/nft_flowtable.sh b/tools/testing/selftests/net/netfilter/nft_flowtable.sh
index 449c518bd947..dcbae9a3d92b 100755
--- a/tools/testing/selftests/net/netfilter/nft_flowtable.sh
+++ b/tools/testing/selftests/net/netfilter/nft_flowtable.sh
@@ -579,9 +579,8 @@ if ! test_tcp_forwarding_nat "$ns1" "$ns2" 1 ""; then
 	ip netns exec "$nsr1" nft list ruleset
 fi
 
-# IPIP tunnel test:
-# Add IPIP tunnel interfaces and check flowtable acceleration.
-test_ipip() {
+# IP tunnel tests:
+test_ip_tnls() {
 if ! ip -net "$nsr1" link add name tun0 type ipip \
      local 192.168.10.1 remote 192.168.10.2 >/dev/null;then
 	echo "SKIP: could not add ipip tunnel"
@@ -594,7 +593,9 @@ ip netns exec "$nsr1" sysctl net.ipv4.conf.tun0.forwarding=1 > /dev/null
 
 ip -net "$nsr1" link add name tun6 type ip6tnl local fee1:2::1 remote fee1:2::2 encaplimit none
 ip -net "$nsr1" link set tun6 up
+ip -net "$nsr1" addr add 192.168.210.1/24 dev tun6
 ip -net "$nsr1" addr add fee1:3::1/64 dev tun6 nodad
+ip netns exec "$nsr1" sysctl net.ipv4.conf.tun6.forwarding=1 > /dev/null
 
 ip -net "$nsr2" link add name tun0 type ipip local 192.168.10.2 remote 192.168.10.1
 ip -net "$nsr2" link set tun0 up
@@ -603,7 +604,9 @@ ip netns exec "$nsr2" sysctl net.ipv4.conf.tun0.forwarding=1 > /dev/null
 
 ip -net "$nsr2" link add name tun6 type ip6tnl local fee1:2::2 remote fee1:2::1 encaplimit none || ret=1
 ip -net "$nsr2" link set tun6 up
+ip -net "$nsr2" addr add 192.168.210.2/24 dev tun6
 ip -net "$nsr2" addr add fee1:3::2/64 dev tun6 nodad
+ip netns exec "$nsr2" sysctl net.ipv4.conf.tun6.forwarding=1 > /dev/null
 
 ip -net "$nsr1" route change default via 192.168.100.2
 ip -net "$nsr2" route change default via 192.168.100.1
@@ -640,6 +643,15 @@ else
 	ret=1
 fi
 
+ip -net "$nsr1" route change default via 192.168.210.2
+ip -net "$nsr2" route change default via 192.168.210.1
+
+if ! test_tcp_forwarding_nat "$ns1" "$ns2" 1 "IP4IP6 tunnel"; then
+	echo "FAIL: flow offload for ns1/ns2 with IP4IP6 tunnel" 1>&2
+	ip netns exec "$nsr1" nft list ruleset
+	ret=1
+fi
+
 # Create vlan tagged devices for IPIP traffic.
 ip -net "$nsr1" link add link veth1 name veth1.10 type vlan id 10
 ip -net "$nsr1" link set veth1.10 up
@@ -661,7 +673,9 @@ ip netns exec "$nsr1" nft -a insert rule inet filter forward 'meta oif tun0.10 a
 
 ip -net "$nsr1" link add name tun6.10 type ip6tnl local fee1:4::1 remote fee1:4::2 encaplimit none
 ip -net "$nsr1" link set tun6.10 up
+ip -net "$nsr1" addr add 192.168.220.1/24 dev tun6.10
 ip -net "$nsr1" addr add fee1:5::1/64 dev tun6.10 nodad
+ip netns exec "$nsr1" sysctl net.ipv4.conf.tun6/10.forwarding=1 > /dev/null
 ip -6 -net "$nsr1" route delete default
 ip -6 -net "$nsr1" route add default via fee1:5::2
 ip netns exec "$nsr1" nft -a insert rule inet filter forward \
@@ -682,7 +696,9 @@ ip netns exec "$nsr2" sysctl net.ipv4.conf.tun0/10.forwarding=1 > /dev/null
 
 ip -net "$nsr2" link add name tun6.10 type ip6tnl local fee1:4::2 remote fee1:4::1 encaplimit none || ret=1
 ip -net "$nsr2" link set tun6.10 up
+ip -net "$nsr2" addr add 192.168.220.2/24 dev tun6.10
 ip -net "$nsr2" addr add fee1:5::2/64 dev tun6.10 nodad
+ip netns exec "$nsr2" sysctl net.ipv4.conf.tun6/10.forwarding=1 > /dev/null
 ip -6 -net "$nsr2" route delete default
 ip -6 -net "$nsr2" route add default via fee1:5::1
 
@@ -700,6 +716,15 @@ else
 	ret=1
 fi
 
+ip -net "$nsr1" route change default via 192.168.220.2
+ip -net "$nsr2" route change default via 192.168.220.1
+
+if ! test_tcp_forwarding_nat "$ns1" "$ns2" 1 "IP4IP6 tunnel over vlan"; then
+	echo "FAIL: flow offload for ns1/ns2 with IP4IP6 tunnel over vlan" 1>&2
+	ip netns exec "$nsr1" nft list ruleset
+	ret=1
+fi
+
 # Restore the previous configuration
 ip -net "$nsr1" route change default via 192.168.10.2
 ip -net "$nsr2" route change default via 192.168.10.1
@@ -847,7 +872,7 @@ ip -net "$nsr1" addr add dead:1::1/64 dev veth0 nodad
 ip -net "$nsr1" link set up dev veth0
 }
 
-test_ipip
+test_ip_tnls
 
 test_bridge
 

-- 
2.56.0

