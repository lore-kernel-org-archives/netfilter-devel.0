Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BAB11DE4DC;
	Fri,  4 Jul 2025 19:12:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751656333; cv=none; b=NMvUcCUAuYFUDNDDohu54QXO68Kwiudx0TKWQGKqeqzQZIPZsG8azUES7QGX0bTb5cFCiLl6CsdmjcszLBGz+/jUkZSt7EHI9O4CRgK39sPx4UfeHQsds7k7YLhkhBR5DnSif4AzZ1+mAm1azz4ZgI9xOQUpWKKww6COMLwymvQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751656333; c=relaxed/simple;
	bh=fvcdIZm57nHeXyPVMFTsLNkqJnF7CdR+EZaQb7/o7S4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O/S16nbRIpq9IAEEkfseKlx0NmeIsMlbfIMVTMk6oFaWvBD6Os4i1sxm2G8s/6CYxHpNi4dYcvz5/YBC/Yw99JcpzJ79p8YBHi8dPaATRb8M6W9IssSRDjTbyu7Zem4ZMVt6ugXbVTsP9qhrALWyY1XsRjcfvw5lBUUUX1S2TZY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TGrqN2SP; arc=none smtp.client-ip=209.85.208.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TGrqN2SP"
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-60780d74c8cso1881278a12.2;
        Fri, 04 Jul 2025 12:12:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1751656330; x=1752261130; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IXkY2a1ytDNpXrtT0yG/AIElqJZI3+JhPKOh06544zU=;
        b=TGrqN2SPU+DLKP+0iQppPXTtHrk8q00/vMwdFTTtyGMiJK0PS7klT0Bwr7pzSfPa7l
         fz1iM1P0LtRaCJBVbUGFRR1i8XW/xJnB0rLnJtJW9RW85MMW9A6svN87K1J1JoGrBZ5Q
         VYLQF26Aug7OXQO+iNqw7vQZ4YKBM5lWxuICZKjrakBtFaEzPFqNVpXGvR3wFP2jsoPS
         ba/HZ0kN0Vu15sHry+dqip/3kIIK3FrVNg5bQ4HVq9vtIzTZOo7glKB82qM2HIXpyabc
         fvdTZeNu+uJ2nrmbnyIs8ttUmmDUhq60LA5SRf358Hei9vr05J0Jghv4Alk7tOvKxLfG
         Nkog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751656330; x=1752261130;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IXkY2a1ytDNpXrtT0yG/AIElqJZI3+JhPKOh06544zU=;
        b=VXS85cS/ct0zga3JrqnnpembWjvHZwUFFMqWZ4EHayNCjzBf+/zfTh3U0E8fe7XQVr
         +mvlEmKXfgjHahGcaBDIrKUHOKnNRiTbvJYcPCTb7n/yfJq2ya1umaUXGdGsarq+p4HM
         2uIoGEi+VCDyJBQtLEIQDz2g1QLPwaK8nuZLsn59/lK5fmxUv28oupAFkmU+80Gq7LVf
         mkeTVeT7CUrzL3SIlQpUEqSNgf0ttlOOWfRNSUIu31VkJNev0C8WceGZD3Cm7I4RSSTH
         VGQoHIWedL2T+61td5jedtwxIATJxkUkuwewzoBpZJLSl0JWw48ivJ91QSGlMOVRbd38
         PVpg==
X-Forwarded-Encrypted: i=1; AJvYcCXGeWolKB5ilcnAeSQP70bv/SBksLkBvIIttudkF9P9nk2w0tzCrVIfyB+FAJYEHzWxhW1aI+c=@vger.kernel.org
X-Gm-Message-State: AOJu0YzqWapkO+sAT2kcBwDYfmQGpAkxZMMGihY1SuhFzIlFPMj0X8Ts
	DCksLGLtCEOr00sUTra2AzOXcjvrqWZ4wDoASUG9/dHAk7YKRH772xq7
X-Gm-Gg: ASbGncuktDJ7B1JPf6R7AJOPDPPeDWLK0VUSOEttAaRndtEc+suwQ7XBBW5TUjwyWHz
	WwJN7JcAdU91ehP71J/cntIl7u5Gouk8riI2CALqfldaTQlYHfo+0cDerG9vJ/UM2mVC/drPng+
	dWaWyjHYugyBpttY1XaCAN9IUb4X5cYvLNLHPnNKKc9ofh1G1cL/e1MjMwAG0jVyRfqh9XXoxr6
	v0sh+r7MdAtLy3HyLc6NviUx0BnPRH02QTMqW6p+4JgJVS72J//7HoDa1sUc13dJvTzyeHIKSm0
	M9ercMytqb5cqgrSjLjKqMkk8dVkx3MZGMY95vqdIdSZhAEXqZQaz7GD3NRvtCf8/loAlpOCpeJ
	TOoVPGZuKG0gbk00JyTloPwaCriNfsBhNmXoi+zcylpDlA8E6Bb/2wRdDhN31xpHaP2OBKZDJMR
	PKRbydLKEhWKfux2A=
X-Google-Smtp-Source: AGHT+IHMZLKyR1a71IPIzjjzB/OGEY+8TxYB+dudEBZs9KdUZ7JSsRwaRmRCmFRjDHMFSzaFDUrhGQ==
X-Received: by 2002:a17:907:7287:b0:adb:23e0:9297 with SMTP id a640c23a62f3a-ae3fe6923b3mr332648966b.17.1751656329451;
        Fri, 04 Jul 2025 12:12:09 -0700 (PDT)
Received: from localhost.localdomain (2001-1c00-020d-1300-1b1c-4449-176a-89ea.cable.dynamic.v6.ziggo.nl. [2001:1c00:20d:1300:1b1c:4449:176a:89ea])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ae3f6ac5fd7sm219476366b.103.2025.07.04.12.12.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Jul 2025 12:12:09 -0700 (PDT)
From: Eric Woudstra <ericwouds@gmail.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Ido Schimmel <idosch@nvidia.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>
Cc: netfilter-devel@vger.kernel.org,
	bridge@lists.linux.dev,
	netdev@vger.kernel.org,
	Eric Woudstra <ericwouds@gmail.com>
Subject: [PATCH v13 nf-next 1/3] netfilter: utils: nf_checksum(_partial) correct data!=networkheader
Date: Fri,  4 Jul 2025 21:11:33 +0200
Message-ID: <20250704191135.1815969-2-ericwouds@gmail.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250704191135.1815969-1-ericwouds@gmail.com>
References: <20250704191135.1815969-1-ericwouds@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In the conntrack hook it may not always be the case that:
skb_network_header(skb) == skb->data.

This is problematic when L4 function nf_conntrack_handle_packet()
is accessing L3 data. This function uses thoff and ip_hdr()
to finds it's data. But it also calculates the checksum.
nf_checksum() and nf_checksum_partial() both use lower skb-checksum
functions that are based on using skb->data.

When skb_network_header(skb) != skb->data, adjust accordingly,
so that the checksum is calculated correctly.

Signed-off-by: Eric Woudstra <ericwouds@gmail.com>
---
 net/netfilter/utils.c | 22 ++++++++++++++++------
 1 file changed, 16 insertions(+), 6 deletions(-)

diff --git a/net/netfilter/utils.c b/net/netfilter/utils.c
index 008419db815a..daee035c25b8 100644
--- a/net/netfilter/utils.c
+++ b/net/netfilter/utils.c
@@ -124,16 +124,21 @@ __sum16 nf_checksum(struct sk_buff *skb, unsigned int hook,
 		    unsigned int dataoff, u8 protocol,
 		    unsigned short family)
 {
+	unsigned int nhpull = skb_network_header(skb) - skb->data;
 	__sum16 csum = 0;
 
+	if (!pskb_may_pull(skb, nhpull))
+		return -ENOMEM;
+	__skb_pull(skb, nhpull);
 	switch (family) {
 	case AF_INET:
-		csum = nf_ip_checksum(skb, hook, dataoff, protocol);
+		csum = nf_ip_checksum(skb, hook, dataoff - nhpull, protocol);
 		break;
 	case AF_INET6:
-		csum = nf_ip6_checksum(skb, hook, dataoff, protocol);
+		csum = nf_ip6_checksum(skb, hook, dataoff - nhpull, protocol);
 		break;
 	}
+	__skb_push(skb, nhpull);
 
 	return csum;
 }
@@ -143,18 +148,23 @@ __sum16 nf_checksum_partial(struct sk_buff *skb, unsigned int hook,
 			    unsigned int dataoff, unsigned int len,
 			    u8 protocol, unsigned short family)
 {
+	unsigned int nhpull = skb_network_header(skb) - skb->data;
 	__sum16 csum = 0;
 
+	if (!pskb_may_pull(skb, nhpull))
+		return -ENOMEM;
+	__skb_pull(skb, nhpull);
 	switch (family) {
 	case AF_INET:
-		csum = nf_ip_checksum_partial(skb, hook, dataoff, len,
-					      protocol);
+		csum = nf_ip_checksum_partial(skb, hook, dataoff - nhpull,
+					      len, protocol);
 		break;
 	case AF_INET6:
-		csum = nf_ip6_checksum_partial(skb, hook, dataoff, len,
-					       protocol);
+		csum = nf_ip6_checksum_partial(skb, hook, dataoff - nhpull,
+					       len, protocol);
 		break;
 	}
+	__skb_push(skb, nhpull);
 
 	return csum;
 }
-- 
2.47.1

