Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.168.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793280937;
	b=IP8VCV9HxICBntF4cY+oXvsZd+c0qpQvdMqdQ1cU/AlB/k0j4m2DjzTmqf1TToTpCRQf
	 gjdMZ0qmJQwbbO8kz4dMRGeA3SwqJChxy7BlmZXPD1JGsMdoJvvHqj9vwEQgCNvqGt36/
	 3wWSjBBuC3c3cu15ixpOYlcMtLi+4IVRuM7aHPhO0L+DRlGeF3QOfVq0NWEFEoTFfr8Gc
	 T2evSTcNMIbkdokT3r74VOb1qY5PAvgZXcMpQW6BNFIkfWnLGYbsjkINVsxKm7of9ZFdX
	 6e0RCI54h01w4AN1g8caHrLGWRzUQlcvxwHh3EGVQ+RhiZooMQWc5GMHQToNMWXeHJA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793280937;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Gm-Message-State:X-Gm-Gg:
	 X-Received:X-Received:Received:From:Subject:Date:Message-Id:
	 MIME-Version:Content-Type:Content-Transfer-Encoding:X-B4-Tracking:
	 X-Change-ID:To:Cc:X-Mailer:X-Proofpoint-Spam-Info:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-ORIG-GUID:
	 X-Proofpoint-GUID:X-Authority-Analysis:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=7+/RPMRcApb38IJk84iUeQLEGtR8QdU2HEBTyYQ+mr0=;
	b=CzHwQDkOJsungEzp9RwR/dcKVTdSUDbJeJEjwiRvT/Hau9rSDFyn9LGzV5K1v8K/rkJO
	 JQCdFNPyJcjtnKv6Va8p2XxsMo6vlzefphYla5OXln+Ly5XDt9NNTyrC5xsFi882MjBcA
	 uTDdnRsEapkXinDP+9Dk21e8k0132UVRKoT0B94pyA442XPFLkTvS7/1clcIXG46U2bZ8
	 hx3hFqJboMghFdxCxk6fqCG4SNa4dzyCuLCsTl2DfKjxashES/GV1gm7lDx6fkjw2ec4k
	 IzT8URgP2Mm1JKlIIWqqssnNJT3yAsZJGJ+KAlsFZJXINq9Xg0ZHze0iO9mRvtjEy9w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=nSQI+uZS;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=HVsCxP3j;
	arc=none smtp.remote-ip=205.220.168.131
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C58CF606A320
	for <netfilter-devel@vger.kernel.org>; Thu, 29 Oct 2026 13:35:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C58CF606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=nSQI+uZS;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=HVsCxP3j
Received: from pps.filterd (m0279863.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69TCeakj120536
	for <netfilter-devel@vger.kernel.org>; Thu, 29 Oct 2026 13:35:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=qcppdkim1; bh=7+/RPMRcApb38IJk84iUeQ
	LEGtR8QdU2HEBTyYQ+mr0=; b=nSQI+uZSXb+B5WRvbBvSprvLSefhchq5n0x3iq
	CYtCxEWN7OeLdJlBO+8OlvV5wwJmb8Z65c18V7wgfkw86lJ9VpiZttZZKX0ks7IY
	3Ey06xL2rxIU4FHvqPsvJVj1scze+8T2N9FKCJuNfZoUGMwRm3xoBMbXkQS4Yeda
	ogL25YwdLZBaubZuXA38XkI+UXyeJfQA6CLhu/UHZK38/NlpEOGmEJRoUAnZEQAU
	On3ZnXIDFNVn0fpPhQTSSGJvwXXAUb2N6+XUXTvraCozY0Hvi1z/Bq41PS7UsPAi
	YmSGMr7wwFNoKA99GIsyORqWREk8ShFz15BSF8P7h0gKZCHw==
Received: from mail-vs1-f70.google.com (mail-vs1-f70.google.com [209.85.217.70])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hkut3jjje-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <netfilter-devel@vger.kernel.org>; Thu, 29 Oct 2026 13:35:35 +0000 (GMT)
Received: by mail-vs1-f70.google.com with SMTP id ada2fe7eead31-7cc4149b885so1788548137.2
        for <netfilter-devel@vger.kernel.org>; Thu, 29 Oct 2026 06:35:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1793280935; x=1793885735; darn=vger.kernel.org;
        h=cc:to:content-transfer-encoding:content-type:mime-version
         :message-id:date:subject:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=7+/RPMRcApb38IJk84iUeQLEGtR8QdU2HEBTyYQ+mr0=;
        b=HVsCxP3j54es+6UhB2RAe9fZsDMdQEjfTEpoSY7T1n0m2thl9Lpyrkp/yRl5CS81QL
         dQNQ8bwTlfiuUeHhrGdqbG8/SxBs34g5L+0cpFtaC4kp6Wc6eKPewMWl/trqRzLSrbII
         HAO1LPVylenA2jh0q+2r1GmlXkoGsCrDenwoQd8ygwfqbCJb6bCOMCX1BG5xImLRIZTw
         p/gM7IYWmHRMoHB4tG+yU5skTOzJvHcNrAPpfq/R8wakr6izNauaVc3ZsjFLoRMI0+vU
         WUsapzqNS+YNxRwmWxWZha7T39xj1yyH/Iv0Kz+mmweXjeFM/5c4I2SsM/kikmIlUpHF
         +/hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793280935; x=1793885735;
        h=cc:to:content-transfer-encoding:content-type:mime-version
         :message-id:date:subject:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=7+/RPMRcApb38IJk84iUeQLEGtR8QdU2HEBTyYQ+mr0=;
        b=2bt2BmgURcGhMyvvh4KP9hZQR5/yOxi3ujNqmJLmeLI6zXS3yQGc7T2cnG/uCDNoRf
         y3X3ZX327s8KkbbZOv/5GK/YUxwJw/hK3aLJvAyk914ul+FsYv78cK52NqatQzasYUmW
         OE3jznSFu9Lu6KsX0xeio21cOOJLEAUhiAF1rMbLBkNyckwq+ti626IgfC236iVfT60x
         lAmdndzD2DB7/qufYiVQBmXhj/zyr+BVRPy7OwEDlZzwdOzbBXtdOWMQ34HxNO9CdWOB
         9um2hAhvpyICePdVYPu/9L6BymD18B/WnPeylx9HqsASJl3kQysgOJTDJ0O4C9deOQ+c
         VfaA==
X-Gm-Message-State: AFq9FYLSLfLECywXatZKWuljcKxFyJNZDNakaPE2q48/V4pJx2+Xsn7z
	GCfeCHUsm0LvB8ZIK+gBQISC7TSkDVPD4Z8a4ESerK5EjzMDeRPCFWfAxEDZ75C/D2FswzQa5gL
	/KD+/puNxtYASRNyjqoK9s2CX01LV6lps5peHgDnOYE1wYV+CHq20Z1/H1kUvNBxf7cB8QEw=
X-Gm-Gg: AYBFou1OQuOzWe3bCMGHTEw+0tmPf2Z5ZIycoxE29vbpMYApGt6szjaBISl6j1ZJ/1j
	psiyaqHIa9khXBpHiKctHi86PwToqNjKQDqK35dNKzU5zcr05c9RYau2E7LTbg3XTb+u8AJrgR+
	//gS466O2ltJk7wDMAdSUXYcmqI9sjtinYS0JiNUlTexEViOQXSLcYkKIJPxvKZV3vLYTS1gMKa
	/cBw6tqio+/UY0p0jP5jCtunM9iQQAYYBJk77iubKBHy5iWM8JCna+v3bgsltydfzAT0GUOUH/A
	6Tkx2pYHsfBJS6k5crmuQoKooM3WNOvMAE4ONwfcG6KbLgytwXmIK0tUOMqouhP9+0vthZEdU92
	ziZ4cwbMVsSADrVZa3fi6yewot+BCUKymYVMFqzM9SMq1WxzQbH/nQ4AM5UgeVT50TpQ3znK/eT
	/BAusMiTU4yxIhpGNAViPt7w==
X-Received: by 2002:a05:6102:54ac:b0:7c3:39a3:f65c with SMTP id ada2fe7eead31-7d03a294bd7mr2751740137.1.1793280934751;
        Thu, 29 Oct 2026 06:35:34 -0700 (PDT)
X-Received: by 2002:a05:6102:54ac:b0:7c3:39a3:f65c with SMTP id ada2fe7eead31-7d03a294bd7mr2751724137.1.1793280934202;
        Thu, 29 Oct 2026 06:35:34 -0700 (PDT)
Received: from localhost (net-93-144-6-81.cust.dsl.teletu.it. [93.144.6.81])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e3ece14a1sm35815214f8f.57.2026.10.29.06.35.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Oct 2026 06:35:32 -0700 (PDT)
From: Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>
Subject: [PATCH nf-next 0/8] Add IPv4 over IPv6 and SIT flowtable SW
 acceleration
Date: Thu, 29 Oct 2026 14:35:11 +0100
Message-Id: <20261029-flowtable-sw-accel-ip6ip-sit-v1-0-6a17c54f9fb7@oss.qualcomm.com>
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
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/x3MzQqEIBAA4FeJOe+AKfT3KrEHc8caEBNHKojeP
 dnjd/luEMpMAlNzQ6aDhfdY0X4acJuNKyH/qkEr3bVKj+jDfha7BEI50TpHATl1nFC4oDdmNH2
 vh0ER1CJl8nz9+xmix0hXge/zvCrhjVl3AAAA
X-Change-ID: 20261029-flowtable-sw-accel-ip6ip-sit-f3393772880e
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
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDI5MDA1MyBTYWx0ZWRfX5P8PQ4NigEm9
 lY64DvyxA63XR0hPDP55/q+aKfdtXwcH8m1IsYQnrBFXNF4prlTSH+aSQPAZYS8rPKVbb1nAmw2
 Ar71Jlg2F8G1dMMt+q5KczxH6M78toM=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDI5MDA1MyBTYWx0ZWRfXyY26lBBupaLt
 zWCtdAp9UHVIwdP1xLN+XpCLb6L0rmKWQ4x+n/rWCiEDAQZ1BlXIUGObFPJiaqXl8EKk3RE/qJn
 M7epbs97EP8Id7JR6KNu487EwksIoE7/FX0Z0MD1rlRNWni9mswLtHDyAKGBDV6UXXZJHE8VXNS
 0yGg+C+VJX6E+xU1j6EMVSr3RviY0bXwO9YhbOzqo8kQ75nBEhiFRdFuW/M+UzcYfc/m40rjwE7
 n1QV7P79V/F7rajZe5HQTYf+IXnTFkNiUrRWaNON68NT+5n3WFlKunnTT2kPop62MgeJ5DHaQh4
 vw756cX2iqktY6vQfwzGdgF4YrainO43cwxir8i9za7y8AVgV/00q4ItX6qC6rVtL/xmzjDkGaF
 km3ee3BgwH0p7u/Alqza8NfBcxUia+C4NmHDd82/pXYEWFiw7XCSuY5OSbEbJwxh5/8gd1U6iGK
 aE+wNCQWzSYnBogVJ+w==
X-Proofpoint-ORIG-GUID: ihufga0N8k3z1wK2cuDZQBlwV3rjshUH
X-Proofpoint-GUID: ihufga0N8k3z1wK2cuDZQBlwV3rjshUH
X-Authority-Analysis: v=2.4 cv=HYSB3SE8 c=1 sm=1 tr=0 ts=6ae34ba7 cx=c_pps
 a=N1BjEkVkxJi3uNfLdpvX3g==:117 a=7fYLNvKHbgS61GKHX+yayQ==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=yOCtJkima9RkubShWh1s:22
 a=EUspDBNiAAAA:8 a=q9g148jr9wMc7ZL12-MA:9 a=QEXdDO2ut3YA:10
 a=crWF4MFLhNY0qMRaF8an:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-10-29_04,2026-10-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 priorityscore=1501 adultscore=0 suspectscore=0 clxscore=1015
 spamscore=0 lowpriorityscore=0 impostorscore=0 malwarescore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610190000 definitions=main-2610290053

Similar to IPIP and IP6I6 tunnels, introduce sw acceleration for IPv4 over
IPv6 and SIT tunnels in the netfilter flowtable infrastructure.

---
Lorenzo Bianconi (8):
      net: netfilter: nf_flow_table: recognize IPv4/IPv6 in tunnel proto matching
      net: netfilter: nf_flow_table: refactor MTU check for tunnel offload
      net: ip6_tunnel: add IPv4 over IPv6 flowtable tunnel offload
      net: netfilter: nf_flow_table: use tunnel encap proto for route lookup
      net: netfilter: add IPv4 over IPv6 tunnel flowtable acceleration
      selftests: netfilter: nft_flowtable.sh: add IPv4 over IPv6 flowtable selftest
      net: netfilter: add SIT tunnel flowtable acceleration
      selftests: netfilter: nft_flowtable.sh: add SIT flowtable selftest

 net/ipv6/ip6_tunnel.c                              |  11 +-
 net/ipv6/sit.c                                     |  59 +++++++++
 net/netfilter/nf_flow_table_core.c                 |  18 ++-
 net/netfilter/nf_flow_table_ip.c                   | 133 ++++++++++++++++-----
 tools/testing/selftests/net/netfilter/config       |   1 +
 .../selftests/net/netfilter/nft_flowtable.sh       |  86 ++++++++++++-
 6 files changed, 269 insertions(+), 39 deletions(-)
---
base-commit: 734bef548a96e8774d6eef5dfa2026c6edc4e80b
change-id: 20261029-flowtable-sw-accel-ip6ip-sit-f3393772880e

Best regards,
-- 
Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>

