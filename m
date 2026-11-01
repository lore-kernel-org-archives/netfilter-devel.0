Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.180.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793559758;
	b=eDpHMkQmqPFPwU0Esx2bQiLWGlj63jVeq/x3OxpVGgT9DZ3v3uDvzBOdqt0Ej3F5NR5t
	 afOjbEcFYF3VntOa8hIVPwNHb12E1+WDJj91gDsV0VqGSfWnFvpXY7TC8uMqJW3SE1xOv
	 rWBAdoU4mkWD2bDVl5gdqpp8tRFKe5XWcXZlo+KSzuICapqUPnV0odEP70jiNCBJh6bT8
	 iGPB7N3zeUUlzOgWzrnvHPhkelTgW2Xr7cLMbvZmD6VM1K6yILCK88pRPC9aaoeGIso22
	 yWTsvT+V0rr3FbkttdbjWrV6ca1T4SJh+dH5K2S3UgdmId5WSgP1EY9/p0lBzEzRy+Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793559758;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Gm-Message-State:X-Gm-Gg:
	 X-Received:X-Received:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:Message-Id:References:
	 In-Reply-To:To:Cc:X-Mailer:X-Proofpoint-Spam-Info:X-Proofpoint-GUID:
	 X-Authority-Analysis:X-Proofpoint-ORIG-GUID:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=crtlCQWUpiltNN3I3i9wQGUeGiNDUE1VlL/TwhcNurA=;
	b=gvfvHjWIqJa9/FcG0IQoUjTgSLAxmGdd1szNSgPEB1FfKHayOG5RDUrPlMrABbQPKsgr
	 XZj+DAbKuNBkeON/Pq5WtoslIw2Y1virvXaxddIyfwBNqnVGfIEQc2zMGGx1O8BXfMp+r
	 YCDa/dGSi4dhuIewE01qX3myjG4Oddu8vg//+EDezTpbhLepQbtrxvoZIazX/Kw4auSo+
	 wf1d3gYsff5WIrjK8rOSH2HB3fMOK1nsekj52vEtBDfjzjNWA+fVxLWDo3fDqe+xOVy0r
	 xzxPbfWOGYjpCpAo4vJ3vCkdEdf8OP4JuiD3w9MORhL5JHFtQ/JJdPRtSVaFnuxWHaA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=XyhXTGwb;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=auZ7sBgD;
	arc=none smtp.remote-ip=205.220.180.131
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57C27606A325
	for <netfilter-devel@vger.kernel.org>; Sun,  1 Nov 2026 19:02:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 57C27606A325
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=XyhXTGwb;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=auZ7sBgD
Received: from pps.filterd (m0279868.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6A1HQJSF1099915
	for <netfilter-devel@vger.kernel.org>; Sun, 1 Nov 2026 19:02:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	crtlCQWUpiltNN3I3i9wQGUeGiNDUE1VlL/TwhcNurA=; b=XyhXTGwbqeE+uakl
	fQd8vr1Ij2y6nOaBHDh7OT49W6MLrWmjl75FbNYpcXLWEx4KMwMcUzYwW0ALol+J
	ALOvwAQsN47Ulvexm5q5tdhuijT3klht/8gwu4cBIiXgvSS8CntiZxTcVZYsdza2
	ps4dvBPZQtWcSWsmRX/2FRTUF3b0MNJOqh4jdpO2TzJVJ4lKKtFpmrXxiq1OhMfK
	7y6o6b/8/+Zu07VVRJQPBH02KZrwPdMzO8sKsOQQiDRZ+5H7b3thLs7KEZIE7mpl
	AS5t6wJ/snRUEkLjM89JlnNrRrduNVsMMhGC7P/cNUfnlsE3zUk0EV9PLKZOE49K
	LUiszA==
Received: from mail-vs1-f70.google.com (mail-vs1-f70.google.com [209.85.217.70])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hn7nfv3t7-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <netfilter-devel@vger.kernel.org>; Sun, 01 Nov 2026 19:02:36 +0000 (GMT)
Received: by mail-vs1-f70.google.com with SMTP id ada2fe7eead31-7cc3a482af7so2231523137.3
        for <netfilter-devel@vger.kernel.org>; Sun, 01 Nov 2026 11:02:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1793559756; x=1794164556; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=crtlCQWUpiltNN3I3i9wQGUeGiNDUE1VlL/TwhcNurA=;
        b=auZ7sBgD3g8qzmsgbzqQfAtlSiPXz+xhsLMXEgRYSZnrpOjaMHuvYQJL/ax+zWy47L
         Dva9vww5XhoWm7ogZXP26BPH53P2szCHuIUIy2hkpo0PjfURXvEeu7JzPxbF+pYlC/YM
         jMteOnXO5Y49mKfHbFDkInbC4Y4sZ6AjmL+DujuXyUrMe8xuXoNF0s3os2JK8cKHbd8W
         NMnMYLT4ewJbYEHJl2h6CabqtlEsKIJ3IJwmSHp+c93t694ihBaXqU3kokM8hSRt0RyD
         S4ssLUYvVdf0oYgjT3wUk+/qbQ6eQg7rwMY4phmFcCpwJHgLUkpBDSLZIHum4s9MNC/8
         gzzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793559756; x=1794164556;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=crtlCQWUpiltNN3I3i9wQGUeGiNDUE1VlL/TwhcNurA=;
        b=CCm42R2RttDIAXiascACi5eMjtid4r5JIxiLjaQexvdYbQSa6q36XXMhsqdC4cg+/j
         kFbfNvTT42O+RVp1UTQuz7p3Jk2VpgYRn0Ot5AXauXHFAchaJYxVt2aitj0yZlaFGomL
         2DjgdWBcMPO2WYomzDRwG/c0eXbzMATk5UEvmi7M48XF2HfBvcp7b9NW5Q/JYhhjJ98V
         7PQxKa37Plivd/F2uYw5YF44rDYpSDYJpTuzsutBlJUbcBeaSQnc2g6PLydfTr+eE66H
         ARBa1M15MJ3BOFjoC3uojOKWS9s1EYrRifILiIiZeOS5Uq230eLu9ha3Dkp5tuTNASnV
         03rA==
X-Gm-Message-State: APuU4Z99FinoAM4vBfCjef2+sWGHGMj4A5FmopsOpDDpBSiO1g3kQZTv
	KUHKPxTkbcO7AHM8auE3+0bfSiTybzsPjkHb4ZcLfITwESmyqq1J8c0GUO/R930VX2NuBQrMS1a
	k+N1gbyuP/OMYpDuIvaU1zxg8nphlI1w0fCX/+kcMQsDlTJRvi93wgXnvPWn2VmQDN6Gp1I8=
X-Gm-Gg: AYBFou3Ghw3jA4w5aPHcAztAVFUVLZBBsOyF3jmNgu+B2Ug0c+fJLLz0WrcPTYVs32c
	4Y6xntQOvZupBUH8iOtNi4UmL6ZBl7Uic7RtkyyOGVV5epYdDK9/2vP+GpiK+aaS9VsON9n6/rA
	zgouFXN9JB4KL75Z3JjWOqD4oIxRAeO9gMArMVjWXroTyWGqiMTHMqh/AYpE5IKPDfp0dgLsGKA
	tp/H9vkzIeXAfN0kzCywniDa9t4fZZc9OdzIrGNAW/gMYj61Km9Lo6J2AxbdBmW8wRSZqRGHK8J
	LZLBjzuElGO2kSyDDixmQGLjswTzyIsMmZ0/V6CCLeX8fNw4fJki/vZKYnlr1JWr7pmj3ANGBK/
	y/q1NzXtGF/VgfVYSNf90msePjFSWst8D9EFC12zDOVEUA1Hc/Tf28c10LV9erho=
X-Received: by 2002:a05:6102:4447:b0:7a0:eb10:79b5 with SMTP id ada2fe7eead31-7d072615354mr2633206137.10.1793559755413;
        Sun, 01 Nov 2026 11:02:35 -0800 (PST)
X-Received: by 2002:a05:6102:4447:b0:7a0:eb10:79b5 with SMTP id ada2fe7eead31-7d072615354mr2633199137.10.1793559754854;
        Sun, 01 Nov 2026 11:02:34 -0800 (PST)
Received: from localhost ([93.66.104.131])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e71b723bfsm14637453f8f.15.2026.11.01.11.02.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 Nov 2026 11:02:33 -0800 (PST)
From: Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>
Date: Sun, 01 Nov 2026 20:02:02 +0100
Subject: [PATCH nf-next v2 8/8] selftests: netfilter: nft_flowtable.sh: add
 SIT flowtable selftest
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
Message-Id: <20261101-flowtable-sw-accel-ip6ip-sit-v2-8-c6c282cab5cb@oss.qualcomm.com>
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
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTAxMDA3NSBTYWx0ZWRfXw0sOZLtAvrYd
 eFoQs/g2pEAaUiiVtTnNstIyEAlVR5kvAe0LtEj+uTcUuMrMOZQBfh/UgL8GcDcJYUin/JsA22g
 IEemkoSQyZpkm1xS8A1pbj6lepHp+hc=
X-Proofpoint-GUID: jbUCIkUZUQ7GHs4-c_KnH2FslPTG-WNV
X-Authority-Analysis: v=2.4 cv=FJ2OVOos c=1 sm=1 tr=0 ts=6ae78ccc cx=c_pps
 a=N1BjEkVkxJi3uNfLdpvX3g==:117 a=cAAIdyqZgEis9HJxay2Blw==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=ZpdpYltYx_vBUK5n70dp:22
 a=EUspDBNiAAAA:8 a=XuXj8uMZMfGkPmKnGZ0A:9 a=a1GBzH_hwgqQkvkP:21
 a=QEXdDO2ut3YA:10 a=crWF4MFLhNY0qMRaF8an:22
X-Proofpoint-ORIG-GUID: jbUCIkUZUQ7GHs4-c_KnH2FslPTG-WNV
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTAxMDA3NSBTYWx0ZWRfX7VyVcQc/8QeA
 K7DHhYcLOCXtB0bxeOvDo553WBwoFMMZ1guxsruQI0iDEoU19jFAVjB3+JlvTjnXndS8sKmPYNl
 13p9cVCbYctfsCviYrgZGCIZO3cfaQEPHI6yVxoPWQ2Gah6h9MdmabtQ8LyG0g0HPO6Hi17b7e/
 ZigHyN04pl4XHIkj0oZEJoCZ+WG/B01eJ/OPKMbQ7LKgyhpz8OtzqMPstqSJH9FzTNbnVBwVRT/
 WHuKhXBiKJWMVqO+/51AYs5Hy2mBMaGYQIhewdHZCRVHTbdAYPRWqcOxI/Vj7bm/wBfEi4NGPOe
 A+2nLIU6fnLela2o29CAOJ4wfSilURO+6bqVALPxDmzQ3eVqEiPouD8qZWc8EMuXXjjfBSqJoFl
 YyMqoCnIA3ezDQNz/t2SwUL5fnhQs42lN/2rNyhM5AYXodRNB3vm/KZHJADgJTBH6BIBPLv7lpf
 0+0ZPZT8QmMdK3OcRNA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-01_06,2026-10-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 priorityscore=1501 impostorscore=0 adultscore=0 suspectscore=0
 spamscore=0 bulkscore=0 malwarescore=0 lowpriorityscore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610300000 definitions=main-2611010075

Similar to IPIP, IP6IP6 and IPv4 over IPv6, introduce specific selftest
for SIT flowtable sw acceleration in nft_flowtable.sh.

Add sit1 and sit1.10 devices, route IPv6 over them, and add
tunnel-specific flow-add rules so check_counters() verifies offload in
the original direction.  Append the unconditional accept rules after
the ct-mark counter rule so packets that cannot be offloaded are still
counted instead of bypassing the counters.  Enable CONFIG_IPV6_SIT in
the selftest config and restore the IPv6 default routes at cleanup to
prevent tunnel routes leaking to subsequent tests (e.g. IPsec).

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>
---
 tools/testing/selftests/net/netfilter/config       |  1 +
 .../selftests/net/netfilter/nft_flowtable.sh       | 53 ++++++++++++++++++++++
 2 files changed, 54 insertions(+)

diff --git a/tools/testing/selftests/net/netfilter/config b/tools/testing/selftests/net/netfilter/config
index 629b2b29ed1a..930374aabec1 100644
--- a/tools/testing/selftests/net/netfilter/config
+++ b/tools/testing/selftests/net/netfilter/config
@@ -35,6 +35,7 @@ CONFIG_IP_SCTP=m
 CONFIG_IPV6=y
 CONFIG_IPV6_MULTIPLE_TABLES=y
 CONFIG_IPV6_TUNNEL=m
+CONFIG_IPV6_SIT=m
 CONFIG_IP_VS=m
 CONFIG_IP_VS_PROTO_TCP=y
 CONFIG_IP_VS_RR=m
diff --git a/tools/testing/selftests/net/netfilter/nft_flowtable.sh b/tools/testing/selftests/net/netfilter/nft_flowtable.sh
index dcbae9a3d92b..efab3854ddb8 100755
--- a/tools/testing/selftests/net/netfilter/nft_flowtable.sh
+++ b/tools/testing/selftests/net/netfilter/nft_flowtable.sh
@@ -597,6 +597,10 @@ ip -net "$nsr1" addr add 192.168.210.1/24 dev tun6
 ip -net "$nsr1" addr add fee1:3::1/64 dev tun6 nodad
 ip netns exec "$nsr1" sysctl net.ipv4.conf.tun6.forwarding=1 > /dev/null
 
+ip -net "$nsr1" link add name sit1 type sit local 192.168.10.1 remote 192.168.10.2 ttl 255
+ip -net "$nsr1" link set sit1 up
+ip -net "$nsr1" addr add fe01:3::1/64 dev sit1 nodad
+
 ip -net "$nsr2" link add name tun0 type ipip local 192.168.10.2 remote 192.168.10.1
 ip -net "$nsr2" link set tun0 up
 ip -net "$nsr2" addr add 192.168.100.2/24 dev tun0
@@ -608,6 +612,10 @@ ip -net "$nsr2" addr add 192.168.210.2/24 dev tun6
 ip -net "$nsr2" addr add fee1:3::2/64 dev tun6 nodad
 ip netns exec "$nsr2" sysctl net.ipv4.conf.tun6.forwarding=1 > /dev/null
 
+ip -net "$nsr2" link add name sit1 type sit local 192.168.10.2 remote 192.168.10.1 ttl 255
+ip -net "$nsr2" link set sit1 up
+ip -net "$nsr2" addr add fe01:3::2/64 dev sit1 nodad
+
 ip -net "$nsr1" route change default via 192.168.100.2
 ip -net "$nsr2" route change default via 192.168.100.1
 
@@ -626,6 +634,9 @@ ip netns exec "$nsr1" nft -a insert rule inet filter forward 'meta oif tun0 acce
 ip netns exec "$nsr1" nft -a insert rule inet filter forward \
 	'meta oif tun6 tcp dport 12345 ct mark set 1 flow add @f1 counter name routed_orig accept'
 ip netns exec "$nsr1" nft -a insert rule inet filter forward 'meta oif tun6 accept'
+ip netns exec "$nsr1" nft -a insert rule inet filter forward \
+	'meta oif sit1 tcp dport 12345 ct mark set 1 flow add @f1 counter name routed_orig accept'
+ip netns exec "$nsr1" nft -a add rule inet filter forward 'meta oif sit1 accept'
 ip netns exec "$nsr1" nft -a insert rule inet filter forward \
 	'meta oif "veth0" tcp sport 12345 ct mark set 1 flow add @f1 counter name routed_repl accept'
 
@@ -652,6 +663,19 @@ if ! test_tcp_forwarding_nat "$ns1" "$ns2" 1 "IP4IP6 tunnel"; then
 	ret=1
 fi
 
+ip -6 -net "$nsr1" route delete default
+ip -6 -net "$nsr1" route add default via fe01:3::2
+ip -6 -net "$nsr2" route delete default
+ip -6 -net "$nsr2" route add default via fe01:3::1
+
+if test_tcp_forwarding "$ns1" "$ns2" 1 6 "[dead:2::99]" 12345; then
+	check_counters "flow offload for ns1/ns2 SIT tunnel"
+else
+	echo "FAIL: flow offload for ns1/ns2 with SIT tunnel" 1>&2
+	ip netns exec "$nsr1" nft list ruleset
+	ret=1
+fi
+
 # Create vlan tagged devices for IPIP traffic.
 ip -net "$nsr1" link add link veth1 name veth1.10 type vlan id 10
 ip -net "$nsr1" link set veth1.10 up
@@ -682,6 +706,13 @@ ip netns exec "$nsr1" nft -a insert rule inet filter forward \
 	'meta oif tun6.10 tcp dport 12345 ct mark set 1 flow add @f1 counter name routed_orig accept'
 ip netns exec "$nsr1" nft -a insert rule inet filter forward 'meta oif tun6.10 accept'
 
+ip -net "$nsr1" link add name sit1.10 type sit local 192.168.20.1 remote 192.168.20.2 ttl 255
+ip -net "$nsr1" link set sit1.10 up
+ip -net "$nsr1" addr add fe01:5::1/64 dev sit1.10 nodad
+ip netns exec "$nsr1" nft -a insert rule inet filter forward \
+	'meta oif sit1.10 tcp dport 12345 ct mark set 1 flow add @f1 counter name routed_orig accept'
+ip netns exec "$nsr1" nft -a add rule inet filter forward 'meta oif sit1.10 accept'
+
 ip -net "$nsr2" link add link veth0 name veth0.10 type vlan id 10
 ip -net "$nsr2" link set veth0.10 up
 ip -net "$nsr2" addr add 192.168.20.2/24 dev veth0.10
@@ -699,6 +730,11 @@ ip -net "$nsr2" link set tun6.10 up
 ip -net "$nsr2" addr add 192.168.220.2/24 dev tun6.10
 ip -net "$nsr2" addr add fee1:5::2/64 dev tun6.10 nodad
 ip netns exec "$nsr2" sysctl net.ipv4.conf.tun6/10.forwarding=1 > /dev/null
+
+ip -net "$nsr2" link add name sit1.10 type sit local 192.168.20.2 remote 192.168.20.1 ttl 255
+ip -net "$nsr2" link set sit1.10 up
+ip -net "$nsr2" addr add fe01:5::2/64 dev sit1.10 nodad
+
 ip -6 -net "$nsr2" route delete default
 ip -6 -net "$nsr2" route add default via fee1:5::1
 
@@ -725,11 +761,28 @@ if ! test_tcp_forwarding_nat "$ns1" "$ns2" 1 "IP4IP6 tunnel over vlan"; then
 	ret=1
 fi
 
+ip -6 -net "$nsr1" route delete default
+ip -6 -net "$nsr1" route add default via fe01:5::2
+ip -6 -net "$nsr2" route delete default
+ip -6 -net "$nsr2" route add default via fe01:5::1
+
+if test_tcp_forwarding "$ns1" "$ns2" 1 6 "[dead:2::99]" 12345; then
+	check_counters "flow offload for ns1/ns2 SIT tunnel over vlan"
+else
+	echo "FAIL: flow offload for ns1/ns2 with SIT tunnel over vlan" 1>&2
+	ip netns exec "$nsr1" nft list ruleset
+	ret=1
+fi
+
 # Restore the previous configuration
 ip -net "$nsr1" route change default via 192.168.10.2
 ip -net "$nsr2" route change default via 192.168.10.1
 ip -net "$ns2" route del default via 10.0.2.1
 ip -6 -net "$ns2" route del default via dead:2::1
+ip -6 -net "$nsr1" route delete default
+ip -6 -net "$nsr1" route add default via fee1:2::2
+ip -6 -net "$nsr2" route delete default
+ip -6 -net "$nsr2" route add default via fee1:2::1
 }
 
 # Another test:

-- 
2.56.0

