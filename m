Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB5752DA77F;
	Tue,  8 Jul 2025 15:12:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751987549; cv=none; b=okbBN/vo4KjUqvySuUs5wWhLJXJLxvVmjfboSlWfbtnCf/2QjiABb93dat9cRXW+HAjMbwYC6IoqNuYxHOUSDhP7KZz6sjHxxYsi1WPyAAL7QOtxU9CKtdaJcuu2RNvMuIxg/luMDIuJnG4RErRTECbaWxLo9V+SSJT4jARfuZc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751987549; c=relaxed/simple;
	bh=v6IbabFWuSJOoL99Vr5mXorOYaAUJ0H1qpog1nD3fAA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=js4FPwgz4SO667AwXKdi2xb1eN+jnwmRK02RV+/ar06nTwib1c5j9b6TMIANxX5HlLuKxl0BRKfFZLaTcob72oiEKi5R7uygsmxbH2QtKb0rvANAhfIEZzgJvHJL4pnGrryQtuRKfoX7BlaEQunwR4aBrSWONxiVq/kSmvFsbSw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ckf1Ruk2; arc=none smtp.client-ip=209.85.208.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ckf1Ruk2"
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-60c9d8a16e5so8270461a12.0;
        Tue, 08 Jul 2025 08:12:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1751987546; x=1752592346; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MUwk3PviXxbrCjaDtVYUnNUgKSgyua01vTosDXLn6cU=;
        b=ckf1Ruk21r425HErKE2/0kqWrSHb2DW5v1nIVpYBDmQXD+uqsBUAY1nh5e1oEvMQT/
         p6ho8F8nDNQuTiZ29Brqi5nBjnA39znLa7+bzkb/NTuOQ1Wkkk1b/NBIUQJ1SL8NpJWM
         AhHmUUSCUvUIINXLdJ7WSSXlARkYGxJIKiMADuJMxjRFidEpUE0WSp/Ixp+Ln90PUq9H
         W6jo7bORMs4Cp5zQxK/mH6FDQ9FiILewdGWqk1Nnyf28K9AekdKR2qRZ9iEvHgTjAqq/
         j8cpV5pvGCZyoZ5DANKK9G5O9aXYF9FeAzJn2aVPugu3ysXL3zmiyUgf/5aB4wOA0Hbj
         jHPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751987546; x=1752592346;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MUwk3PviXxbrCjaDtVYUnNUgKSgyua01vTosDXLn6cU=;
        b=k0URnc5hnZhEu3/JLBdvCPtmvlaJ/OeDSTNqEJs+qCeeE+0tkc74KfWztVl+FdVkNb
         n/UCaj/OKpugdOZThEX/KnViJyuP0NfHgCWgfW70trtZjLt+YK5D5RES8xsqw2F6SZrt
         boYZY8PunSwgHboZdLmVDwK0ukMSRLb2gkfF3qvdeDRQYw8mKm3U885HPn5LIleBV/lD
         6+nlJ2AITGl68x2e0y6QnBZbHZMCpz9+9h9uuejNLdWRtkTsppI7fwsHYQrrL1qTNMzR
         QpuyVMFYlh9W0VRtF2tkoM/l6R/hTR7iVGwn4mSpHB+YMtLDd8OObWPXbFXkSYo+BV/W
         tPXA==
X-Forwarded-Encrypted: i=1; AJvYcCUHZxHwlA2nRav4nDJKq0KUHExlwUDW3NMD7AeHAKVaPywK10fz7b+0W/gs9jaPrAciyabl5lU=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxrk4lC+Ii8s+gLbCFObm5HX8pO6Y060zl0g1oPQkbc/42Fsfc9
	BlKegpFhzM+Kk3KHYWPRjUnSgxgc0toQz8sGEXpkymYpF7fhNiUol6i/
X-Gm-Gg: ASbGncvlrAiCZsjI3FNQk2JCh1LLSzpnzV1r0gh/XKDrRjsoDY49qdtR3g11Xqnbz4G
	ExREqu3GXu97X4B+gFwkyzRodZc5MeGu09gi5Vu0AY8/PqV9qIjqVHINkNi9zq7fD5CJdQTa6m4
	3xE7MF3/dzWDW/hedR0ty2Wfko7V6KWrYsRQc/jA/ysSXzaRHZQnl3YediUmIazK//Co1a4kizt
	xIKud5r6OaluM/L3K+GNarT13MTpORxI03kd2TClJLsUrr/ccuoMJ29tzZUuwzPuTSp6dTzPkFP
	wLCZ6oexaE14AapCfZOIwRc6Bul2teG7V5oAM2We0+xe5RjeDNDulLIkbCua7o25Vw7WN2LfbpL
	ZKp3IWeflllpDffTpbkYb4XivhOMWxjY9JlqAukJsCTQUPtC8F0vY9ZZyBs1TuRlKV1HSGM5PTk
	Ps3ym4
X-Google-Smtp-Source: AGHT+IF6CB3epAacm3o998BsP2ZMm2GHdUUg4vM66IUxSnpFqtqKzIJwM4AxbhZA4lacg7pZxDFlyg==
X-Received: by 2002:a17:907:7251:b0:ae3:8c9b:bd61 with SMTP id a640c23a62f3a-ae6b0596e91mr365931866b.12.1751987545613;
        Tue, 08 Jul 2025 08:12:25 -0700 (PDT)
Received: from localhost.localdomain (2001-1c00-020d-1300-1b1c-4449-176a-89ea.cable.dynamic.v6.ziggo.nl. [2001:1c00:20d:1300:1b1c:4449:176a:89ea])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ae3f6b02a23sm907596766b.112.2025.07.08.08.12.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Jul 2025 08:12:25 -0700 (PDT)
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
Subject: [PATCH v14 nf-next 1/3] netfilter: utils: nf_checksum(_partial) correct data!=networkheader
Date: Tue,  8 Jul 2025 17:12:07 +0200
Message-ID: <20250708151209.2006140-2-ericwouds@gmail.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250708151209.2006140-1-ericwouds@gmail.com>
References: <20250708151209.2006140-1-ericwouds@gmail.com>
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
 net/netfilter/utils.c | 20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

diff --git a/net/netfilter/utils.c b/net/netfilter/utils.c
index 008419db815a..9ba822983bc0 100644
--- a/net/netfilter/utils.c
+++ b/net/netfilter/utils.c
@@ -124,16 +124,20 @@ __sum16 nf_checksum(struct sk_buff *skb, unsigned int hook,
 		    unsigned int dataoff, u8 protocol,
 		    unsigned short family)
 {
+	unsigned int nhpull = skb_network_header(skb) - skb->data;
 	__sum16 csum = 0;
 
+	DEBUG_NET_WARN_ON_ONCE(!skb_pointer_if_linear(skb, nhpull, 0));
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
@@ -143,18 +147,22 @@ __sum16 nf_checksum_partial(struct sk_buff *skb, unsigned int hook,
 			    unsigned int dataoff, unsigned int len,
 			    u8 protocol, unsigned short family)
 {
+	unsigned int nhpull = skb_network_header(skb) - skb->data;
 	__sum16 csum = 0;
 
+	DEBUG_NET_WARN_ON_ONCE(!skb_pointer_if_linear(skb, nhpull, 0));
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

