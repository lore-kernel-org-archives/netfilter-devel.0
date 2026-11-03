Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.180.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793714494;
	b=yJ8DZE/9KMKnfmqGRKhglF7nFSxybabOXgTjWtxDpTQ3P9IsmS1nZoMdk/YJFj0IxHSj
	 J6ws5FaecYjdzw6clwEtV2GIqEpCtocoTUCJ+oZ1K4OiIt7GPPy238s42JGLqFIOzkEuB
	 fLjCscr0CkYW7FtYHBXxqUHWzP1oKlySQ+8n6nGBGkRQ/Njenl9t2IRv1hy10d37na8fK
	 YWiIvMDcuqhLcKfDVM0tr/xUb8J91CX7nyB33ZVdv1oCNx+qr7Ln8UsJ+afUpIQKKTz8e
	 3wvdU6cHjJOHFx8IdRKkLeE2XH7dAYgThrvh2OKC71AjCoDFq6lrPgRsUGZ5baOq2qw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793714494;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Gm-Message-State:X-Gm-Gg:
	 X-Received:X-Received:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:Message-Id:References:
	 In-Reply-To:To:Cc:X-Mailer:X-Proofpoint-GUID:X-Proofpoint-Spam-Info:
	 X-Proofpoint-Spam-Details-Enc:X-Authority-Analysis:
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=bkyFaU7pm1UiMcf0aTZkl/EEwuv05ryAASaXqNs27JQ=;
	b=ExCR0KmNFgMjgQkfWuxTzv2yBRX9+5ynBMGGYHSOjJY1l0fg3BtYc312LT1K22cOBDjf
	 aQhEgVdz/gyrAP/hqO2YzXZtbsIXge/d7IQH2FrRXzFlFrfR0L2wlRQ3QPb7QrBesmq6C
	 UGnxqXnuEzNcZA5sFp4b2E0bOIYVtdgFZIJm7IQtaIF2b0iuE9xtjSHf3OGxBzBKxAD6U
	 JtWrPT5O8v+JmuGzlqvi2yUaq1yybcA7uOTTIIYJ1LNV92dLm3YmO951hL2jdST6FU/IA
	 k+fzeHbfLNrAsH+VyP0KlXUIMt/IRyqx9wgM9SYxzYTcM7YN1jSAK5JHE3jvnVUhEXg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=LDAMOFVR;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b="JA/etMtE";
	arc=none smtp.remote-ip=205.220.180.131
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7850A6085094
	for <netfilter-devel@vger.kernel.org>; Tue,  3 Nov 2026 14:01:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7850A6085094
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=LDAMOFVR;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=JA/etMtE
Received: from pps.filterd (m0279871.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6A3DZegW3612869
	for <netfilter-devel@vger.kernel.org>; Tue, 3 Nov 2026 14:01:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	bkyFaU7pm1UiMcf0aTZkl/EEwuv05ryAASaXqNs27JQ=; b=LDAMOFVRSOlKB/7r
	RoShEFNL0r9wORxBSEVExk4QNcBt2Rx6j5zXD842VED4vTHnl3MRYEw9U0k2cHso
	xeCY3q16TrvqW5c2qo1c6KxUhqlaUypcMu+QQuZaBomo1ToB1vk1dZNPPWGxwmqi
	66hLPi1zYumhyQFDBCUQNMLFqc9SUkUr+aDtbnjGBsaLqhJORPj4VTilO19O0VNd
	PxkLzDovsOPJe8TBV744VmJ7UjyrngPr4m+Va+CoYUFBepWbUIUY5/QnGumiAScL
	+pIxogMcu8Wmr6QFM+jNNscGH+3Kf77+PDYZa7zJA5i8IbLxxK2o2Wwd+0EQsAAW
	PUlzug==
Received: from mail-vk1-f197.google.com (mail-vk1-f197.google.com [209.85.221.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hq6m9ajtx-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <netfilter-devel@vger.kernel.org>; Tue, 03 Nov 2026 14:01:32 +0000 (GMT)
Received: by mail-vk1-f197.google.com with SMTP id 71dfb90a1353d-5eac4de614aso3434027e0c.1
        for <netfilter-devel@vger.kernel.org>; Tue, 03 Nov 2026 06:01:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1793714490; x=1794319290; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=bkyFaU7pm1UiMcf0aTZkl/EEwuv05ryAASaXqNs27JQ=;
        b=JA/etMtExvJktApGWSS/rWLKJYTjUTBst2BfeEoLJC+b0o+iUY6LSQDpgzwkrJEeSl
         QPvmmfGCcijN1URVbw38zOzwJ8D4tQXQ6nXpeEBuYDgl3SJVig7TCmNp7dSXQ1YP0xNb
         xc5oB3yIH4rrpJ9MBBv7RW5qY9RZWcRWzbb9jv//lT+1RbT0Fa9sKYkHSPFeTcAX3Hfv
         V1XOgc7e1KIrc4FhVlvewzMj9eCFxKKuxJ9jExqJjRHLrtrco73OZSa+bhSVB6+3UPtm
         HNAOcCC1ydNkipcV8ps65gKESikzcdefyv/2TAjQ3wFFrCH67wRq/JbsPcdTUJsiuFX+
         BoGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793714490; x=1794319290;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=bkyFaU7pm1UiMcf0aTZkl/EEwuv05ryAASaXqNs27JQ=;
        b=nqCCHTVwCxRU5SLaKfVQkJAQO81hKwRttJdRt4YM0EIgkdtLElBi7kJX1NZ+DmLp3T
         729THA+7wOaHSjgi6aP5+Pq00cq6xKPTomc+M59ROc0a+duog9XNCjyBMtGVzLNxfQpq
         9vBrvAK9qdl3BHwOgLRmoBy3thWk0TCcof93aiJfm2whG3qPvTYMgP7cbhxrwZtxYcco
         t0lz7Oe8E0zNlOcuZxrEXfs7kVs1uaK7OiP7dZBYq1Bv+sqT4JsdhNPXJRfEKSvqmkUX
         2UUhfXS2+8g+My9jG9dQRQSFEH2BUPruWs0ck5eUdRokR3v03GDV284GN7HKrvM/CFjr
         uy4w==
X-Gm-Message-State: APuU4Z/4fD9d0IlBl99LA1Gmk4ukqTL0kf0ouuWGg1Jgp0r1E5xadPL4
	M5txGiZn0esDBv4g+CunPUT56+BoUqcFlF+I9cy/fa1Y5elJo7lCP054k6Ulc4jNmQy4AxAtBLP
	zfK0X/oa/TRM8eR4U5zcOWWzaEkI8GLuicCjQlHtKJyniBSXLs+ZoPABePu4eRHyOem6Mqtg=
X-Gm-Gg: AYBFou0D/Nb46h6TNm4fePKg1FwWtPvmNE/67cSb6hh5DCvIXH6rgU7oolTfl4KqOZ4
	zJqfxT7r90+cwJyiCfxbmQT8Fw5HzW4Hsc2QXMpf1wv0tRdliyZpYsZXRYxUxUgcrcCEf9j3q+H
	/a+glxSM0xFsFyNyzV56LCXQIMKaWwFMfWFXp0BaIBI01/06qg6ckN4Sh8JFua86Wcaxs3pQ8kB
	bexUhlatkKkR+R8Xi6ns4VO8gdvodqwEetOry91hELl8l4RVt1MGxRDkoLPrxmM/zpwlcbtoAPT
	UNG9B4wMDERLygvxe/0AOBy9eAc/PTc5pXaPdbrPKi+g9RnNs2Ao9odIaYNa4JCvolN7I6hqRM8
	09KS6NaBfefaEuCjfXvecZanJ/kXuxVuyhXCP3obyFE69y2k7Qp2kbpx4tO7TcK8=
X-Received: by 2002:a05:6122:ec5:b0:5ea:dc36:245b with SMTP id 71dfb90a1353d-5ec6896de21mr5609946e0c.18.1793714489299;
        Tue, 03 Nov 2026 06:01:29 -0800 (PST)
X-Received: by 2002:a05:6122:ec5:b0:5ea:dc36:245b with SMTP id 71dfb90a1353d-5ec6896de21mr5609682e0c.18.1793714487766;
        Tue, 03 Nov 2026 06:01:27 -0800 (PST)
Received: from localhost ([93.66.104.131])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4b2ab010a66sm84552045e9.13.2026.11.03.06.01.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2026 06:01:26 -0800 (PST)
From: Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>
Date: Tue, 03 Nov 2026 15:00:47 +0100
Subject: [PATCH nf-next v3 6/8] selftests: netfilter: nft_flowtable.sh: add
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
Message-Id: <20261103-flowtable-sw-accel-ip6ip-sit-v3-6-60b5f063f1df@oss.qualcomm.com>
References: <20261103-flowtable-sw-accel-ip6ip-sit-v3-0-60b5f063f1df@oss.qualcomm.com>
In-Reply-To: <20261103-flowtable-sw-accel-ip6ip-sit-v3-0-60b5f063f1df@oss.qualcomm.com>
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
X-Proofpoint-GUID: IumamxlSVwnEfVYBT6Elzb3X4wCNgTQt
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTAzMDA1NSBTYWx0ZWRfX73tTdW8iFj+A
 ioC7+uw8W4WWSZTfFMukQqdvPao33r5D8fhC4t7pnkE7o7zgcYMMxHLaVR8vYen9mGWnAQiNGi2
 Wh7dqkgbIwIBEWSeQD+pIr17HJwFXmk=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTAzMDA1NSBTYWx0ZWRfXwtOmLdqu1FJC
 aupVhR079wBb9Tn4XjknNSnqEFDccW8YNPpOFofp+WmWPCOA4mcg8Pc8Sma6wyLs0ehoEHX2vhs
 W1NJmjwuPAbF8CNjS/JRXiRZsbHhog6UQ3kVlfk4JO+vmSayR2zNi1wjreh/1hvMGpLQL3ICUGu
 DfQgiY5xBIfBiluJGB22ulQ39Q+WreI8QlUeoqkvNNlSRXSBbc/CvWvIRiOSu1ugzL5vQH7/Ybu
 VgYFULL4b6Ed2yEiXxe2Z8nac7I1VTlEdVzO5QxdOPuFyQtrWDZo5tMxOPOWCqiIM6Vq9dugc6Q
 q3vdmNqNgYbKa9YQXYIZ/Y32p4SSI9l0L2n4YHXHu/4eKMyxZsaQGu17rPZ446bXGfaexNU0Suq
 d49hNkUeumBZRzL99dM8oysJjIApatguZe8iFrvEvSJT8L7t1/D7d4YsTOXtfXyGUgejStFF55U
 hHRcwMJIZwB3dFFLGxw==
X-Authority-Analysis: v=2.4 cv=C7B8WgP+ c=1 sm=1 tr=0 ts=6ae9e93c cx=c_pps
 a=JIY1xp/sjQ9K5JH4t62bdg==:117 a=cAAIdyqZgEis9HJxay2Blw==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=3WHJM1ZQz_JShphwDgj5:22
 a=EUspDBNiAAAA:8 a=bN0dAzVfwMEGxDOd9cEA:9 a=QEXdDO2ut3YA:10
 a=tNoRWFLymzeba-QzToBc:22
X-Proofpoint-ORIG-GUID: IumamxlSVwnEfVYBT6Elzb3X4wCNgTQt
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-03_02,2026-11-03_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 bulkscore=0 malwarescore=0 lowpriorityscore=0 clxscore=1015
 impostorscore=0 phishscore=0 priorityscore=1501 suspectscore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610300000 definitions=main-2611030055

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

