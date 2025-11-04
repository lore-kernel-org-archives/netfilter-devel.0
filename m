Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFF6C32E75C
	for <netfilter-devel@vger.kernel.org>; Tue,  4 Nov 2025 14:58:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762268298; cv=none; b=XqiErhqq2bL8C/Nwme+jx53dnWyRD9QmNpA7aYMpnQkMoQ+6/dSznUpBSCfniAY38dl9sCyrYBKXMko8vQbHvOZYP3r5KFbPzzMLATn9NkSd9BxTKPxHBsEmhHDzcDpmPbujZVloQasfL1F/a8VU0hwA9/e9OFfkzZFh2PCQVT0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762268298; c=relaxed/simple;
	bh=fdY4s91tI+lPau1JubbQ0x8fEYiPT2Mrr0LtPH6xCk0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iTps0R5uoyIC2k3670dZmLTyHniFjLnH6P0ofCIYouqRnCTcq3y74yimh6xJ3uNTsAIcdVKTwS3YjXRNJI3FU2d8OQjqRtZ8ZUN3oviI68rDyD9ZNgoQ4cbmoKX4ARLjumQXNLuNpDc8Oimm/uMjy9UKV725mO64gakLMPA4JII=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=b3d9KQkf; arc=none smtp.client-ip=209.85.218.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="b3d9KQkf"
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-b7260435287so29960666b.3
        for <netfilter-devel@vger.kernel.org>; Tue, 04 Nov 2025 06:58:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762268295; x=1762873095; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/+3n/wt4G7GIqXmLm7jMx2L0Drt9lvIRoMC4cC/d+Ac=;
        b=b3d9KQkf9g4KTjypWXlyDn1GOhzYLMmfmNGuXWdPwOvVv6BK5D3FIA6NV/hGDVKX2C
         uPo3RvDuLTEvc2HcMU06YvXgd5cM4pghrbrnWgYzIEBGDfkgh78jLMMY87Mpf/0pd55O
         uMRRDc3sRnQVUPiv0G9t3fnVLTm0dJun/7lAa0Y8BDEyT49B8xIS684Nq6Nj6chrk4eT
         d4PQB7n0naub1McgbllVlHf4Jdkk9i4PIolQpwwBsopSpYatqnD1CwcuM/2nCn+kJsmI
         24my6JH+Y5nFSXcbEaqs5xdaVo6XtyskGrw5Lu1T+FGqd/8Gn4el3F7Spm9YlyGZlEOB
         SX+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762268295; x=1762873095;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/+3n/wt4G7GIqXmLm7jMx2L0Drt9lvIRoMC4cC/d+Ac=;
        b=KH9usKw7YcJ5HDIFglqZGmnna4t6VHnllZd7S6yLkS9MPgtu8EmJjTHJFrXEc8ir+G
         jomsUgpjt3HzQrARDYEBorcKPxTm/CTHgp9tL0XmxLd3gTEKRn+NUwxgRCpTu+6FQUft
         Cihx1vIsBnbKe4yegCdtVk/S+wjQED70la9JFVJWldix+1uyN7OWWk2yaH9oaXk5GEvB
         HnjH0wN5C9HZFMKM9navVKMDGhXFTyDeQgviYip3v8tb6YI9s7++VVquBtOvq+xkVtrP
         q/svG25qEtlPXNHlzFaU5/GzOd9SRY97nEnt31DJ6pqa1DV0yYMeV++9NeivWtHjhG8s
         teFQ==
X-Gm-Message-State: AOJu0YwshgO5b9ETRZSFvy8yEahhyrak4HOeL98W+rTyKafO79NDH2oo
	e5gr0ZvA9aRCYh4eajSq/f9aVptEguW/q5N2vJOMX1i5/hZSMUm7jK3/
X-Gm-Gg: ASbGncvtWy0ylu06ggsE1xzbdJEk6+7Tf4a0Mg5PRvNKGtW8mpepHr81g/d4AOLQ6Cs
	SSCh6ttimokGqAW0A9hPazATcc/YaC16Ssc/p+QhJbaovFRI/PaZW9uJ+KXUxRIqk1+h9oXlA7L
	ky1vNgLm77aekWn5Yrf9jTL2/mgVlT0epuNX+SD7yOdW6+nuZiY4uZTsgMwebKJ3kZAXo7mK9yl
	JQdK2kFLopAUEFSU88Q6nYIN0srdggPI0TDI2l568uRVP8NzBhOaoo/fPog5WOQ9Ks84riFnfVi
	YnhKoNZBgR06ZpLcUkKPpkR7SypBxh9OX4JwOGJZq6lJHIBZBqhnXT/K7CCt2m06nAsh3ozmAx7
	ffflxXKqDo2YT6T0300HEvu7K4CcYeP7/+8+P3NS/8dDQ33VWWWK9CUdiP84EvFauVhOerqHQgY
	M2f14MMo8lpT7w8lQIJMHlBvFt5bUehQCpJB04xtBFsKKREmTB/AuK6cRnf7udDhyiQalbUQ/J3
	yYlaX4YiQ==
X-Google-Smtp-Source: AGHT+IEFzOrWccwmXLur6i4lkRajTpgN21ZDLR1W8fqsPoteNCqgZfo226NwiSt+ScF8uclULXwnDg==
X-Received: by 2002:a17:907:9448:b0:b4b:caf9:8cc4 with SMTP id a640c23a62f3a-b707012901dmr1744890766b.15.1762268294801;
        Tue, 04 Nov 2025 06:58:14 -0800 (PST)
Received: from eric (2001-1c00-020d-1300-1b1c-4449-176a-89ea.cable.dynamic.v6.ziggo.nl. [2001:1c00:20d:1300:1b1c:4449:176a:89ea])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b723f6e2560sm232681666b.46.2025.11.04.06.58.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Nov 2025 06:58:14 -0800 (PST)
From: Eric Woudstra <ericwouds@gmail.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Phil Sutter <phil@nwl.cc>,
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
Subject: [PATCH v16 nf-next 1/3] netfilter: utils: nf_checksum(_partial) correct data!=networkheader
Date: Tue,  4 Nov 2025 15:57:26 +0100
Message-ID: <20251104145728.517197-2-ericwouds@gmail.com>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20251104145728.517197-1-ericwouds@gmail.com>
References: <20251104145728.517197-1-ericwouds@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In the conntrack hook it may not always be the case that:
skb_network_header(skb) == skb->data, i.e. skb_network_offset(skb)
is zero.

This is problematic when L4 function nf_conntrack_handle_packet()
is accessing L3 data. This function uses thoff and ip_hdr()
to finds it's data. But it also calculates the checksum.
nf_checksum() and nf_checksum_partial() both use lower skb-checksum
functions that are based on using skb->data.

Adjust for skb_network_offset(skb), so that the checksum is calculated
correctly.

Signed-off-by: Eric Woudstra <ericwouds@gmail.com>
---
 net/netfilter/utils.c | 28 ++++++++++++++++++++++------
 1 file changed, 22 insertions(+), 6 deletions(-)

diff --git a/net/netfilter/utils.c b/net/netfilter/utils.c
index 008419db815a..7b33fe63c5fa 100644
--- a/net/netfilter/utils.c
+++ b/net/netfilter/utils.c
@@ -124,16 +124,25 @@ __sum16 nf_checksum(struct sk_buff *skb, unsigned int hook,
 		    unsigned int dataoff, u8 protocol,
 		    unsigned short family)
 {
+	unsigned int nhpull = skb_network_offset(skb);
 	__sum16 csum = 0;
 
+	if (WARN_ON(!skb_pointer_if_linear(skb, nhpull, 0)))
+		return 0;
+
+	/* pull/push because the lower csum functions assume that
+	 * skb_network_offset(skb) is zero.
+	 */
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
@@ -143,18 +152,25 @@ __sum16 nf_checksum_partial(struct sk_buff *skb, unsigned int hook,
 			    unsigned int dataoff, unsigned int len,
 			    u8 protocol, unsigned short family)
 {
+	unsigned int nhpull = skb_network_offset(skb);
 	__sum16 csum = 0;
 
+	if (WARN_ON(!skb_pointer_if_linear(skb, nhpull, 0)))
+		return 0;
+
+	/* See nf_checksum() */
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
2.50.0

