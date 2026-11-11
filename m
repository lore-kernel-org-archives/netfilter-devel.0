Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=67.231.145.42
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794357126;
	b=uRyIrfLdIpTzhWpPfxFOaE/IdVElfPH7YSST8Dt9Of+8k3ojy9vXy/m+YlzCacjEZsXQ
	 krlj3TDliECQwq7+LNfEHR/Jvn/Gh4W5DqUN4mkPa+3zBGdWdSepexzbjve/RYr3pb6Qr
	 4wu7FVLLRCEfI5TyMhjJENu5zM8JQptiNrhJNN2EV8XwW3U/3jk791NEIk3Ys3Un0Uylt
	 XPahMNWUb3b224rC53U00J4bsKI7qchscZPg+D3mqUKP+90DtBlPxR5hVlUrMo0PxbYHa
	 cpVSFrEEAWBzmLr2bWYfqwfizMRGVQ+QMjTmTgAOVnApjxIR0VCgPD8Kr+zn+5vs97A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794357126;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:From:To:CC:
	 Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding:Content-Type:X-Originating-IP:
	 X-Proofpoint-Spam-Details-Enc:X-Authority-Analysis:
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-Spam-Info:X-Proofpoint-GUID:
	 X-Proofpoint-Virus-Version;
	bh=vucapibEdcB8Yy+kavdEXjoEXYAeGPMXpTgamm4m77E=;
	b=Qb6A6p7XVjMk7E+ilZOCqvfqIV1ChysNUuBQ3QKDHObEwRFjNZQ6aUVLJyObQp6gZVNq
	 b3YuIyMTD6tqihr88VsLxOryi3uAqn2hqH6bugorun2vkgBYKgv3nnBSSs2cZmNALqCW7
	 mSL4cwG/Mcu+HaVB/8NVECGBNZGCrSkhPfxxDHUYwdODH7Xy0hK9KtsEpPhYncyyZwn5g
	 +xO8puWOPogaq1y3Qwt4Is6VUOwYhinKBgHLTaqdhxIL9RwDygL/DqaXqJOKI6e2McMeJ
	 /8DY9yLuufVXLmgh8YaFTHvBCFaZOCYxWPD+dn54Hx5cP7DEYG35a8ElgEVm8zhZlvw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=meta.com;
	spf=pass smtp.mailfrom=meta.com;
	dkim=pass header.d=meta.com header.i=@meta.com header.a=rsa-sha256 header.s=pps82601-s2048-2026-q3 header.b=K9lY1cjO;
	arc=none smtp.remote-ip=67.231.145.42
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8AF4606A31C;
	Wed, 11 Nov 2026 00:32:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E8AF4606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.a=rsa-sha256 header.s=pps82601-s2048-2026-q3 header.b=K9lY1cjO
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6AAMKC6F1257070;
	Tue, 10 Nov 2026 16:31:31 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=pps82601-s2048-2026-q3; bh=vucapibEd
	cB8Yy+kavdEXjoEXYAeGPMXpTgamm4m77E=; b=K9lY1cjOjiswPad8G7Hi3EryH
	XSlPxCb6cFa/+nxnQfiEN8L9lX7XiT7wUTYvg+COViXANVJ4qqdcx1jsJ9d+Chex
	DuLSNB0pQYE0k+MlbAzl99Y3674NUKDAQ+NBnN9tkuszfqF7KbZddyuYSSgOriUx
	GkX1tzA3fNo4lxRyF5VEUlI5m0Zk/e1lLsj7YOru98SpITukUhRkRO3E/ActmVQ6
	cF0/rgYRDFT+12BbQX+eK72yOtkdnrFS6FAJrhfyI+jtvIWcHNtPZEhhdoQyyS2F
	MiPONP/y/NRpvl2SHQGKfxmSb/yAdWT90bUlXsSZKtQIHB5+LjeiY6xPD1X7A==
Received: from mail.thefacebook.com ([163.114.134.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4hv4hbn3s3-4
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Tue, 10 Nov 2026 16:31:30 -0800 (PST)
Received: from localhost (2620:10d:c085:108::150d) by mail.thefacebook.com
 (2620:10d:c08b:78::2ac9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.2.2562.56; Wed, 11 Nov
 2026 00:31:28 +0000
From: Todd Freed <toddfreed@meta.com>
To: <netfilter-devel@vger.kernel.org>, <toddfreed@meta.com>
CC: Pablo Neira Ayuso <pablo@netfilter.org>, Florian Westphal <fw@strlen.de>,
        Phil Sutter <phil@nwl.cc>, Nikolay Aleksandrov <razor@blackwall.org>,
        "Ido
 Schimmel" <idosch@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Eric
 Dumazet" <edumazet@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>, Paolo Abeni
	<pabeni@redhat.com>,
        Simon Horman <horms@kernel.org>, Boris Pismenny
	<borisp@nvidia.com>,
        Sabrina Dubroca <sd@queasysnail.net>,
        John Fastabend
	<john.fastabend@gmail.com>,
        Daniel Zahka <daniel.zahka@gmail.com>,
        "Willem de
 Bruijn" <willemdebruijn.kernel@gmail.com>,
        =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@kernel.org>,
        <coreteam@netfilter.org>, <bridge@lists.linux.dev>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH nf-next 0/2] netfilter: don't send decrypted skbs in clear text
Date: Tue, 10 Nov 2026 16:31:09 -0800
Message-ID: <20261111003111.3826942-1-toddfreed@meta.com>
X-Mailer: git-send-email 2.53.0
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
Content-Type: text/plain
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTExMDAwMSBTYWx0ZWRfX2GRseD0xONdl
 doqg/aK+qQ/OAzqUepCQN5fEFw5Lh9eWCC/QUt8R0jpSHNmEoq6opdOdcDM/Z/qumFjUbKHPBF/
 J2mLH6jPfNm3Y1kbnm5cgxGa+ugsS/hCYwEAV4ez6GaTsIY0Z5BveZ7kE1J4qGgI6SNs9raIq5U
 fAFl3agYQTSbbGmivcIvwDhDCpCK475CiZy6D7nd4GK5sYWWSp8OBE/ocJu3N7NxLzqvL22hJ3H
 HizLDnDFMCbVcqnYlLRTDZ90pD43F07wHG5iH/jWPfThAy4q6IISpOLyl6gTw2GwMLrwmOF7j0Z
 ZG6utsVHIhJkYLtraA90uChk+VyfSEuQuuwIdiyksh/S/6rzbGqzyDnMdjYELLtCE25d/pGt0vy
 hXEdCfwLczQvjl39zC3kVRWBvXNcoJPosecsLwGCwG85kUgZm1nhbdP1m3GxP+eOtGBDMSHsS/r
 4hSArz/6MX+3G+MF0oQ==
X-Authority-Analysis: v=2.4 cv=d59gWhjE c=1 sm=1 tr=0 ts=6af3b762 cx=c_pps
 a=CB4LiSf2rd0gKozIdrpkBw==:117 a=CB4LiSf2rd0gKozIdrpkBw==:17
 a=zJRp6_cAMcgA:10 a=VkNPw1HP01LnGYTKEx00:22 a=7x6HtfJdh03M6CCDgxCd:22
 a=8elwO82fXORLTBIkMd32:22 a=VwQbUJbxAAAA:8 a=VabnemYjAAAA:8
 a=XHK0IIDWTER3bgGQhqgA:9 a=gKebqoRLp9LExxC7YDUY:22
X-Proofpoint-ORIG-GUID: fOVwx21k6U3IXAUDAHaFWT2GcmsLkKxN
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTExMDAwMSBTYWx0ZWRfX4BHkUMX+vJxG
 oIyjzOMgOXBOZ/Fu0mUuFoamh4QO5ZlCAoy7R9kJnsi1iLcKK+MEHZmQnKnT7+qbCCK2Dzaqw//
 rQgJwbr/ABu97VGstEtjZF6twoHRkkg=
X-Proofpoint-GUID: fOVwx21k6U3IXAUDAHaFWT2GcmsLkKxN
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-10_07,2026-11-06_01,2025-10-01_01

skb->decrypted marks a packet which the device decrypted on receive, or
must encrypt on transmit (tls device offload, psp). since this series in
net, the ip stack doesn't fragment such packets, and sends no icmp error
about a received one. an error about a locally originated one is only
sent if it is routed to a local address.

  https://lore.kernel.org/netdev/20261111001831.3710881-1-toddfreed@meta.com

netfilter does both itself: the bridge refragments the packets which
bridge conntrack reassembled, and the reject code builds its own tcp
resets, and for the netdev and bridge families its own icmp errors. this
series applies the same rules there.

the psp socket-less associations series for net-next, which follows
this one, makes forwarding and bridging packets which a psp device
decrypted an intended use.

this series doesn't depend on the net series or the net-next series,
and doesn't conflict with them.

testing: on netdevsim psp, with the net series applied, nft reject of
psp socket traffic, with tcp reset and icmpx, for ipv4 and ipv6:

 - in an inet input chain and a netdev ingress chain, of the decrypted
   packets a host receives. without patch 2, the tcp resets and the
   netdev icmp errors are sent in the clear. with patch 2, they are not
   sent.
 - in an inet output chain, of the packets a host sends. with and
   without this series, tcp resets and icmp errors are sent to the local
   socket.

patch 1 is build-tested only

Todd Freed (2):
  netfilter: bridge: don't refragment decrypted skbs
  netfilter: reject: don't reply to decrypted skbs

 net/bridge/netfilter/nf_conntrack_bridge.c |  6 +++++
 net/ipv4/netfilter/nf_reject_ipv4.c        | 26 ++++++++++++++++++++
 net/ipv6/netfilter.c                       |  6 +++++
 net/ipv6/netfilter/nf_reject_ipv6.c        | 28 ++++++++++++++++++++++
 4 files changed, 66 insertions(+)


base-commit: 734bef548a96e8774d6eef5dfa2026c6edc4e80b
-- 
2.53.0-Meta

