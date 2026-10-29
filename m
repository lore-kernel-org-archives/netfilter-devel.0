Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.180.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793280954;
	b=S7Ojrf88wvwp+Lsj5MhBm3sAjyNWmz6VhESXCSpebAajRfDkrQqH5YI/zBsiE1kj5tK0
	 Uanc2J+KizmwXkTp/HAESNDSJpqgVhY/DhCcQ5hAWzdLyXSQ8pWf5+dGTsdHlSoMx6P1G
	 HGsPaKstArGyOZyukW0ntJs0R+C1b4vH9IGaVEKcoaeAcwuNUfMH4whjMdTSmhWp8oulz
	 DjaOSBtBqqkaoeOSiYpg1jsLZIijI4dqyyWOhHHS5MgfUjZGHQpVARkJNZKncVAWVvLEf
	 qOMyeYmLBdZs+3PyMNMkFSb+vMZwqMyuTTf6p1ltpYIS7hidXBMAx7/q67+xvGz/s2Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793280954;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Gm-Message-State:X-Gm-Gg:
	 X-Received:X-Received:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:Message-Id:References:
	 In-Reply-To:To:Cc:X-Mailer:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-Spam-Info:X-Proofpoint-GUID:
	 X-Authority-Analysis:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=Z6XS9g1yfpXlXRk9/YKY1ELXgVfvsZxJEw+TI7y+Uo4=;
	b=pTtO4LsSanhxU8kuodGuSJuXbFOGQnF4Tiwf4+FlwX24+Tt56/nhDqPN9EB50t4r6Z+h
	 MKePciKjmnjgOv1i7gGMwLCzBdRoEPXgmOwVMcfjOmcKzEHBkCBeIyqeFfN5yTVMVOG8n
	 cdmJa/8DPzlvy+HL4PQ+nmlxD02oSGlQ++3ZmCZS+Bb23WNkphIQh5P+lL8qUr7hHaWQo
	 Kf+5UuhzO9ecXA2mt7KybSn29v2OAnGB5YhbfWIN1Q02HqKDK/rWpoEY07fJ3PH7IcRg6
	 oVWJBGQ5FVpRfT0cGqhRG8PHsIffv00TytqH685SazI+dremGIKnzMVlQtP4S9ecWmA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=iStT91TS;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=cwrR9PSL;
	arc=none smtp.remote-ip=205.220.180.131
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5785060A260C
	for <netfilter-devel@vger.kernel.org>; Thu, 29 Oct 2026 13:35:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5785060A260C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=iStT91TS;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=cwrR9PSL
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69TCePb43215076
	for <netfilter-devel@vger.kernel.org>; Thu, 29 Oct 2026 13:35:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	Z6XS9g1yfpXlXRk9/YKY1ELXgVfvsZxJEw+TI7y+Uo4=; b=iStT91TSpUGSJ60n
	z4Jds6W8d5YfyZoTJo3FvjhLKhpfO/uykese30NjRDN8C96RqwJcS/C0Ox0Dr5qQ
	yX46nnpIAuuk1AiQzdKIg2SmACWTVeTBJ9X00CRJGupkVScXiDVemW6t093ym9Pb
	H8n4rVQzfbvUqMo45FK7tR+jDy3Raf6zZiVl9ZBdb+pEdEH0Fqf1SqCqHfMEWHmh
	szpJbVRrKs9QiI6cCIaNvqBnr8j6hZgutx96mtlSxT22qdZkwV25bB+kTp79ER+H
	jG37l9zv9VR3MEH8GBoDwCqQ865SWSVQoaPSXpPa4LGq2geSAJSos+UV0YgSOCfD
	MPkxQg==
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com [209.85.219.69])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hky5s9wer-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <netfilter-devel@vger.kernel.org>; Thu, 29 Oct 2026 13:35:53 +0000 (GMT)
Received: by mail-qv1-f69.google.com with SMTP id 6a1803df08f44-91c7bf2d734so39177166d6.3
        for <netfilter-devel@vger.kernel.org>; Thu, 29 Oct 2026 06:35:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1793280952; x=1793885752; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Z6XS9g1yfpXlXRk9/YKY1ELXgVfvsZxJEw+TI7y+Uo4=;
        b=cwrR9PSL2ZZzhpGkaNtTtYhChbFEE5yxZqdmdziCSA3fKlsc4EtSFwX+rgIuFndDwP
         JAGdFABOlYECHE1mxU13RYKcV3bebVAOXk1mYw+ZXA3d+OZe8iKe79ssxO8rLrpuKnK9
         iNVPAui/LEKfyOjvEUfu9WA/SpFfzOM+OLTQvHlF/WyiYGKE1OnJP9GI8gafh+Dy+pDh
         Vyupf8LRaX4DFmYku33E3X55maRvS0nS1czDOdSO4fPGX9hOu2Tcv6BHAbcyRErMTqp/
         AG+9oE4ZyNdxprBs33XIJ/mrYFRXczSvac4REdPSz0oNTEgiBchsb3Rw3UleoSotB+n3
         gOHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793280952; x=1793885752;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Z6XS9g1yfpXlXRk9/YKY1ELXgVfvsZxJEw+TI7y+Uo4=;
        b=YHbxI85fbZqTTcBJlR1EGbrUbBIHFxUAFsMFiFqGQiDk9/2OEQVtNQED/xSPicl9ON
         5BVmY8rP+9jz7irXYa1z1fUtJn49ZGAd8f7+baQseRXYqqMMzCg5acilyrTpUDZAygLk
         1UOm5tpl/nzYKZxH+PR/a1xNQOvvkA8fxoc3bj8Yx8fOmv08mghSRFcVw9NNjDjJXcoR
         hXK8AfwgDHnCjbyu/P+OnCgUpmujLrP7T9krFL9A2nMr4o3JIB3Lq6VQneV2fWN/HgwH
         FXWlMw2KrtqSAYqeZXrao75PBCEJYsSWWA4Yvy5F/5qNIMIBhRfwbc8d2lc/3QqqrNff
         w+xg==
X-Gm-Message-State: AFq9FYIbf7g/eLvRjJCqDvhMbfhrJcDQyi7nSbvpiN1UdvOeGedoood2
	alarVv0AfM2JcRZmT8XvYTM210dTk7KzDr/PAkJunKO7xHF4AtzyQoD1OU4WZMsG83fnv7NcRZY
	e4XsSTmdIWklbWv2w+oaAhRHqp7DmSSPrP9dse+HplWvNh/himDUTx7LvfkK+5eIjUz22Snc=
X-Gm-Gg: AYBFou2qFZt6oNcYPmtEVDfp7izNgHHkgms63IXcxzEOmfM10mXtpfNiDJhBFH1jPQP
	WsjrmC9qy6PJo78Ng13bMiYC8cv4WgIwI0WlwgwwP5U3PW0HLTCDb1zlvzJrChktX+B0M+WiMZG
	A2vp8smA6VTpHnWjza5yHCYWh4/nkurboE8GR43yFTgYOmLfrLg6m/9Rj3a8WHk4264NL2HV1ag
	UPPrRfe/HKWWkQS7TA8jusocBc7L9/KqxrrJdEaOqn1mySbfWY7qOuoFSyN4gNG5oBXFe2V6ry8
	3BlGellwSGIUvKx0X/LqxVdTCb24uOHATgM6TqKM2ntbpUj/LvB4aXAz8pLYSk50e/OOI0c9pse
	ewDDCl72zFGVIrWv4+ZjBGPwKQV5PEs7CCB4zkoiUfkcXnIBRN3vqO5z4ZEhDK2IO2jc4sTlFN0
	r8I7+cXpaWcgf7A7TEFt5TlA==
X-Received: by 2002:a05:620a:170d:b0:93c:635e:6f3e with SMTP id af79cd13be357-94408a5d003mr856598085a.35.1793280952269;
        Thu, 29 Oct 2026 06:35:52 -0700 (PDT)
X-Received: by 2002:a05:620a:170d:b0:93c:635e:6f3e with SMTP id af79cd13be357-94408a5d003mr856593785a.35.1793280951737;
        Thu, 29 Oct 2026 06:35:51 -0700 (PDT)
Received: from localhost (net-93-144-6-81.cust.dsl.teletu.it. [93.144.6.81])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4aa820492cesm71866705e9.13.2026.10.29.06.35.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Oct 2026 06:35:50 -0700 (PDT)
From: Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>
Date: Thu, 29 Oct 2026 14:35:19 +0100
Subject: [PATCH nf-next 8/8] selftests: netfilter: nft_flowtable.sh: add
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
Message-Id: <20261029-flowtable-sw-accel-ip6ip-sit-v1-8-6a17c54f9fb7@oss.qualcomm.com>
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
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDI5MDA1MyBTYWx0ZWRfX231NcACGOO3L
 LJ/UWtqYykUBRXleNVPioksRz3zREWwloaggPBYFkeQ54YyYAcOkYpymleOhFZETSwqNQdH6NZU
 N4k2+FwT9Saz8OEItBTDN2/vdZZXQjAOh80lvjw53KrgDHAY3Q42zVB0IUZUixtUpM4GNPbZlyj
 hd40iHq1WyzmPCc+qSM2P+9VaZX1L/Xpb5EgRmbMa5toe3/eo5ExZfSne93GuzP4feVt8IfWimS
 qsZ7kw+CvsQf7Hz/yw8VC3oMJDoOVCHXJDMOTaq74yMYJGZe/Jx2uxRbK9U61OzHwYns3HA5RGd
 pz2YAbIwZvSAWQk8Ya1HSr/+WBbdVrUrSirOjGpSEH+fuVAIXqSlB+sZaVRJhxKbYxRjWfM98/g
 0nw/E9yUkcYsASJdyhkIAKYM9TPd0YpG1yYHLg5NDl0oPvB3sVZZfYDxnmtN3zxDVc1a9p55cWW
 lLqliylkwMv+BDTNChw==
X-Proofpoint-ORIG-GUID: FliNbKZntNoCplbeYVzp56wh6j7Oz7iH
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDI5MDA1MyBTYWx0ZWRfX9aT46s1Fznxj
 Tk7TKOfC5LGL22I+fJVQG6Xo9gHLYcNKdxa+5FtPGHK7McFNuy9Y/jc3/VZ2tozNJwGUGRV/ACj
 6mp4Z9Y3CSbcotGRKf8uWKETgnXhp1g=
X-Proofpoint-GUID: FliNbKZntNoCplbeYVzp56wh6j7Oz7iH
X-Authority-Analysis: v=2.4 cv=f/vdl+yM c=1 sm=1 tr=0 ts=6ae34bb9 cx=c_pps
 a=wEM5vcRIz55oU/E2lInRtA==:117 a=7fYLNvKHbgS61GKHX+yayQ==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=yx91gb_oNiZeI1HMLzn7:22
 a=EUspDBNiAAAA:8 a=XuXj8uMZMfGkPmKnGZ0A:9 a=a1GBzH_hwgqQkvkP:21
 a=QEXdDO2ut3YA:10 a=OIgjcC2v60KrkQgK7BGD:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-10-29_04,2026-10-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 suspectscore=0 priorityscore=1501 impostorscore=0
 malwarescore=0 bulkscore=0 spamscore=0 lowpriorityscore=0 phishscore=0
 adultscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2610190000
 definitions=main-2610290053

Similar to IPIP, IP6IP6 and IPv4 over IPv6, introduce specific selftest
for SIT flowtable sw acceleration in nft_flowtable.sh.

Also add tunnel-specific flow-add rules for sit1 and sit1.10 so that
check_counters() properly verifies offload occurred, and restore IPv6
default routes at cleanup to prevent tunnel routes leaking to subsequent
tests (e.g. IPsec).

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
index dcbae9a3d92b..3a393c8deab9 100755
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
+ip netns exec "$nsr1" nft -a insert rule inet filter forward 'meta oif sit1 accept'
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
+ip netns exec "$nsr1" nft -a insert rule inet filter forward 'meta oif sit1.10 accept'
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

