Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.168.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793559753;
	b=lan8pLi7vC1UBvY+ByPbznlCY2eMuFNFFsCe9vR9I03Gg5qhzNG5uCPX58/7DH6fdnxG
	 Jugjb4p53ZxtrzuktlWyGBx2JZOeqxdnvgRZ6sxMcYQu+revhXFhXix5dY+W5HU7crNzS
	 B1RFjZoUrzwtpl86LK5JABB12ZMK92KBjFDyOXNLH7imAltfotnhg75Z6O11bzWb2zbRx
	 Hchf3OPWxRFySCov1dJ/Wl8zC9+oJqUecacQeTAm0hJDMon1sneX8TjahLiliJjUrZDuK
	 gmZOHb/K63l5zTfu5Coc0Cj/GQQ/EyLwWdmkbQp0wkXUi07I26gjU4DKne6QG37ttiw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793559753;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Gm-Message-State:X-Gm-Gg:
	 X-Received:X-Received:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:Message-Id:References:
	 In-Reply-To:To:Cc:X-Mailer:X-Proofpoint-Spam-Details-Enc:
	 X-Authority-Analysis:X-Proofpoint-ORIG-GUID:X-Proofpoint-GUID:
	 X-Proofpoint-Spam-Info:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=bkyFaU7pm1UiMcf0aTZkl/EEwuv05ryAASaXqNs27JQ=;
	b=qM96iNp7mNu22/ydT1o9TnBxYHP7DlspH3PcnXMx/B7lBLEPd5swZYrcnGrBs7Lk4Qac
	 HDKN/VP6m3rEUhjxgr1RXAWbAD5EwNk6WcgtSHeVhwMBpfpRbDTcJ+fDb/I0AtV8Y+6dv
	 9C5KjzDCMLutB5VAc1+MoFNjvrNSKyjbDpw7a/LcK59VS8UuyOC8sGUOTWJyQic/OTMIH
	 aK4YJzc6CoELD3I+Lj5td8IM1gpt1YOlTkSc35EJuQjJ/9Hej7o2qoUzzl9Uo7gk5kD2j
	 22g7RUfCUrwZ8gXnBTNHwVoIIFpF2q/HHYAP+HOQMPvsjIkEn7022QWdy+G52Vj4wIQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=SYR1ltU+;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=MrzkMnWW;
	arc=none smtp.remote-ip=205.220.168.131
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A373E606A327
	for <netfilter-devel@vger.kernel.org>; Sun,  1 Nov 2026 19:02:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A373E606A327
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=SYR1ltU+;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=MrzkMnWW
Received: from pps.filterd (m0279862.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6A1HQG36888168
	for <netfilter-devel@vger.kernel.org>; Sun, 1 Nov 2026 19:02:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	bkyFaU7pm1UiMcf0aTZkl/EEwuv05ryAASaXqNs27JQ=; b=SYR1ltU+h+DcYgUS
	KwUm0gjiC5pxOnmN0rOWydYeeAQUt2Y5GWUV9Ssqisgziv5GYDbOASmCtvnRklNM
	APIZSukBaEgcR3cERN5oruncVgcULyq4erxjZw8TgDl1wWIHHGNuka3Q1Q95btu0
	pnxBUwc0ZZ0C/7h5DlIidVGslPUtUURR3NQzhfWVggWB8/1hcLjTcAAtzN/xPHgj
	FnP4bpvTxS78Vlwbejci9vIiNuUZsZVVXVTIzzdyPh06ygnBRAA+iE/8kkFVpgH9
	A4x57MuD7p9gUqjd4rPOuJkPlnmenqRuznfsc52aM4vJf4VqlMmbmYqUDytuTE1u
	mbNusQ==
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com [209.85.219.71])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hn93ekv3m-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <netfilter-devel@vger.kernel.org>; Sun, 01 Nov 2026 19:02:31 +0000 (GMT)
Received: by mail-qv1-f71.google.com with SMTP id 6a1803df08f44-91c7bb3e2acso13768396d6.2
        for <netfilter-devel@vger.kernel.org>; Sun, 01 Nov 2026 11:02:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1793559751; x=1794164551; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=bkyFaU7pm1UiMcf0aTZkl/EEwuv05ryAASaXqNs27JQ=;
        b=MrzkMnWWxj+1T9HABI6xBvJwGSQLbYo4iE6lfkI1NvW8OVeXZhecN+LkSQWhxGAOT9
         nYe59VJfFzevnVGjaaj+LMMbo+sd+CQ4iFyqDRLNeMUFyY3TxfixG1a6ddpS2l2bUajn
         05JgH8LgLximpWeSdmwFnEGqQUAT4gzPX6XbmXySPrLDQ+yt7AWbOksnSkkzG7TvudGX
         6bKpEn3rMNZ4OEi/3J1z0f/e/L3jsVsNREu8jaL2dCoycnxKs6G/idBQwUZS+AerXWZ7
         IW79arVsPxQaNofBgQozxxNFJBaHOpRzVfvxngwy7/7gwssMfwYjDw0tYvIKXZy9l3M1
         Nc1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793559751; x=1794164551;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=bkyFaU7pm1UiMcf0aTZkl/EEwuv05ryAASaXqNs27JQ=;
        b=iD8aaQMysPNsQcCaec92f1Q2f3iN392syHuC2Gjd54sCGN9a8t+ro3LckawL/wgh5G
         01+PTElbX8VHpRRnx4lWTlYhqY4USswg3Kt5Xm6SL/TbieQbo8S604aDFB4EV/sw51H2
         bb+G3+Z01KM5GtjvsKi4lX6rkEdexpz1hNp+urbs4uJzDhnKOfUc/+Dz8ryQ/GETRvCG
         UYCQ5+VjYzPm7YlCyzPaLPdMqpa74ELo9NmESzMkscSOsljdbFJfi+//hv0UtkfqWAt4
         L4afK/lH2Xixc2nL6wJhos4aPTyqvK0hAVoWgmYZdfObN4z6Mz+hEQBAzJw/a39bW1rz
         3YRA==
X-Gm-Message-State: AFq9FYLmUy/8t2uT+RqRlk8i+vZ9ry59sHe+QtaUO6OTF8m4VlcnkGbq
	kThLAe25EMCT1C6IaLOkSp/aT6u8pZtiCbgULyF5f2L5JIshReUc9tM8u3VHdj0VGkmeYSvX7Ht
	PcBFn/fiOJeSovQ7/eAqw+rtMd1MrHT2jImcNYcYmMhVuZuV0wvZ57FvRsAak8wuP7YaH/JujeV
	BCxbM=
X-Gm-Gg: AYBFou1Hx6twppnypISqmn3ly2crl8v3dkTwRV7hgUA1q6GTAcaHs5IIUfyvHWdRfkA
	g1dD1A+fXQtdxKTqGACNeTZKGfl83NrMSu5NJa79a2ZqYCJFgYdEarnAE/dYfAJv1HPqArJBzRt
	tz2tj8DgymsVD1180HJzvpwKMEG14wLWYD27crBNNrZCwiRGVeS7FxAFe3yOJ7xXTrP9ULx5C9z
	7Kiglh1SZ1TLxQZcLjXMd4ycU0j5YM4h/BDOV9xUlTqqSn3dCD74dUtSWwMkNUCU9+ToLkXiOon
	KIBDPl8hlcjshYc3/6f0XMX8nnwbozU0DPGsL4Yilkb5PqDoPN0eMquTJZLDz88wRv7iY83qYvy
	YKAiHYzB9TzHz7hpiVk/2BKwygBX3TCqRLAY8KYwiL2mZfRQbyXXKCLEl2cxUmh8=
X-Received: by 2002:a05:620a:404c:b0:93b:d7a1:ba16 with SMTP id af79cd13be357-94421725362mr1333070685a.65.1793559750750;
        Sun, 01 Nov 2026 11:02:30 -0800 (PST)
X-Received: by 2002:a05:620a:404c:b0:93b:d7a1:ba16 with SMTP id af79cd13be357-94421725362mr1333065585a.65.1793559750104;
        Sun, 01 Nov 2026 11:02:30 -0800 (PST)
Received: from localhost ([93.66.104.131])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4aa80f047bfsm287704435e9.3.2026.11.01.11.02.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 Nov 2026 11:02:27 -0800 (PST)
From: Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>
Date: Sun, 01 Nov 2026 20:02:00 +0100
Subject: [PATCH nf-next v2 6/8] selftests: netfilter: nft_flowtable.sh: add
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
Message-Id: <20261101-flowtable-sw-accel-ip6ip-sit-v2-6-c6c282cab5cb@oss.qualcomm.com>
References: <20261101-flowtable-sw-accel-ip6ip-sit-v2-0-c6c282cab5cb@oss.qualcomm.com>
In-Reply-To: <20261101-flowtable-sw-accel-ip6ip-sit-v2-0-c6c282cab5cb@oss.qualcomm.com>
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
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTAxMDA3NSBTYWx0ZWRfX+hJhUGU7yptw
 1L3+DLxXxLAE9lSLVoAD6prQ2T7XA+76UWvqqg+hx27r1ziIEK7XSs7V2SqS+ETv81jPwHd0L/9
 ZtD67y2ScObZDg5yJeKI33RTnddGMupVFqs9g2O1MOpTgeUPWtNhX6q4RyU6zxABn0osfB974wl
 tAAQjQnMbMxyDKUHUCeUNizTHuOdstlZe1OFJM2j8xaxAlIZR0l+vzazQKCr4i2bez0tdjG2WNE
 HhZsSzazyGJATr4IZq4bTEE01obCn1CdGDQnzWFvEgf4vSn/ZcJQRCpNUsIrGwtAKg3SZaPlE8q
 VRFKt5ZxIT26IIerjmjA/N87TrqvCKR5YBWESIJw5liAkbp5PTANh2Dyz1TelMnCf7cBiR2B8ar
 o32uCLTojHP6E+yUptLIiiuSzSb6CB1PRd15bz14nVe8tMNpPhoO2wczSSw/OxIhteCNaD3HUWr
 xbwUC3kerfTy49LpHXw==
X-Authority-Analysis: v=2.4 cv=FciiV5+6 c=1 sm=1 tr=0 ts=6ae78cc7 cx=c_pps
 a=UgVkIMxJMSkC9lv97toC5g==:117 a=cAAIdyqZgEis9HJxay2Blw==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=_K5XuSEh1TEqbUxoQ0s3:22
 a=EUspDBNiAAAA:8 a=bN0dAzVfwMEGxDOd9cEA:9 a=QEXdDO2ut3YA:10
 a=1HOtulTD9v-eNWfpl4qZ:22
X-Proofpoint-ORIG-GUID: MUlT39cgS1ldzIUluIbvgpeiF52tjG5Z
X-Proofpoint-GUID: MUlT39cgS1ldzIUluIbvgpeiF52tjG5Z
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTAxMDA3NSBTYWx0ZWRfX7mxDrJEjwueX
 OSbqLnOCI85sSSCxTQJ/zmstMEc/WzQ2mno7fgRDFjyKv6yxoqSlIp3hPuGCEpoiOkRQfsLKL3N
 o4uPiAiXd2CbA+oj7YoC5jA5ykFKf10=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-01_06,2026-10-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 bulkscore=0 impostorscore=0 suspectscore=0 malwarescore=0
 lowpriorityscore=0 priorityscore=1501 phishscore=0 adultscore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610300000 definitions=main-2611010075

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

