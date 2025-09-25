Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8798C3191D3
	for <netfilter-devel@vger.kernel.org>; Thu, 25 Sep 2025 18:31:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758825064; cv=none; b=VEBoetzXw78JNWgFMTnaL3vU8Lzu+h9EuuK5cWkyIuS/e8bHLOyL0X3MpoD0OUGID/vKj11waq/o9YHUpWbm2s+Ebr77X9wSzT9o7xTKcm8/ogg/aiUDv0KeXHOljJsL4tN5SSJMVxj+hY4QghMVidaXppIoVxeYIAgBp1Sng1c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758825064; c=relaxed/simple;
	bh=fdY4s91tI+lPau1JubbQ0x8fEYiPT2Mrr0LtPH6xCk0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MLsJPhO/fNCAbnFtocTH/RjGkjhaNH1kWbf774NxCJ9n5ZnfcIHiOLYnnky9GiFSaWCr4TkwxQS6kNZhkEJ+/jtc/ZS1dy+IbxdZPdGvpFPfaAYT9kki0yWhlxTMQEZimQcHNEr0LsbOhXuA1MboFLlqYJ37C49awXCcbbv+9lE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jH2injt/; arc=none smtp.client-ip=209.85.218.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jH2injt/"
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-afcb7a16441so213240166b.2
        for <netfilter-devel@vger.kernel.org>; Thu, 25 Sep 2025 11:31:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758825060; x=1759429860; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/+3n/wt4G7GIqXmLm7jMx2L0Drt9lvIRoMC4cC/d+Ac=;
        b=jH2injt/CMkV4jSxqw2ePn/HL3j5USxEo6oglVEr0Gf+5fvQzgxX1YklXxR+bNowqw
         23L0WL5T5vGJ3V5pPabmF2G+1ppfdHpFBH3U42m/GdJGQF+y13pG43ifjGc3YwRMPsaG
         wEj/7zprVfwGp8ZhIfdHaA0/1AWKSU4/8hNvGDGITZmmSo8YVGI6cC8V9Evn+2VA+axx
         TjLpZnzbcEg9vOGmC7GT1B8Myk4L8JfLPXX068bTz43STTe0Unml5ydxshX6EzXK8mrg
         jler5Rv2Ti6gMZJUGQ2GkqcpGy1vcn+0HdtTztb6oqfAqz+Rh+uHhOTwSmjOSsjHagAk
         rrJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758825060; x=1759429860;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/+3n/wt4G7GIqXmLm7jMx2L0Drt9lvIRoMC4cC/d+Ac=;
        b=plSHO5U65yw1GyAhInxx0D1dmeBgvopZ4Q1wl2RV0borcQRpGMkPY2zLNBc277sl5C
         XSWVNVG+L9Wf/vhlZj3YxeBHfIsaXWSVCuwBe8quoMTXJu64U2tE5a8euBLaRidyteV9
         rZaJIP0o8rGfjXVOHneE7zyiMf2OsHMmFLtY1fwpUj/2Q2HPmy7I6zWajCAYKspTVGwV
         0nAt/aUq6v+xZYg3B3pwvk6GCSQIlsVv485joXx83g4uftOhoFWZCGX6KCSerseNAkov
         cvWq6cb4ga9l9GjYEOv9jTtaOaFnZBbZY8hsSWBPDA2cAfog6M3iTNK0MG/hbXLtNel1
         7NRQ==
X-Gm-Message-State: AOJu0YzgfbdrHhw0sj5WW2O7CC+j3LvvNnUDnyxNdMKjK9bmCHHPjney
	i+lG1upqjrHc2CxdcMrf4Fa3x2HDwWBNvsDPiOrjWASOGmB7Ubo23Kla
X-Gm-Gg: ASbGncsI8DDryLbLl6TjWSGpTKWo+cFjd7g2Ew+6zfkSw2HEfdzr93FxHDR3egNvjGI
	dF4vJkEvT+KrDnOE10FjXXJjYg8AdVMgFK0wreGuUWVYiYRJl01Q9wKY1GO1Hgldy/IetFAwbXl
	upDPi9dSlHORnOigkPKeLkRL6fvMLMBhmntUwJxOSt5OLURXOc2XppxEPfYuuateAjnAtYhbiTE
	ocVCZnzcTiK2DUXPraNO/8IBC1bPLKTYSLchyCDHEOt1IJsXQNLKe+W7VjfXLOro0aXyqky77Gh
	36YEjkwMeoN88UB/Gwy4cl1UOQVB5wzsVT6Y+PcMf1gKuX8ez8IIbg+Uybi2sEBKLUvFEdHQTan
	DJcquHn1dZuNLNYGjLv8ZVTDuXhA1n6Fby9DaZ9jWjy7N2CfGEeHMfLMiIBy4NkUpxusj++rSYc
	RYBeTUaYnqIdYInrLHzw==
X-Google-Smtp-Source: AGHT+IGAa02mHOQA+yISRuVyAiyglwnY2AxzVt78/ebOCI2IUEbTqhhH5+ovN3xQr0fSLhe5oRXbZA==
X-Received: by 2002:a17:906:f597:b0:b21:6dce:785 with SMTP id a640c23a62f3a-b34b7209d39mr472920266b.1.1758825059575;
        Thu, 25 Sep 2025 11:30:59 -0700 (PDT)
Received: from eric (2001-1c00-020d-1300-1b1c-4449-176a-89ea.cable.dynamic.v6.ziggo.nl. [2001:1c00:20d:1300:1b1c:4449:176a:89ea])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b3545a9c560sm211198666b.107.2025.09.25.11.30.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Sep 2025 11:30:59 -0700 (PDT)
From: Eric Woudstra <ericwouds@gmail.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Ido Schimmel <idosch@nvidia.com>
Cc: netfilter-devel@vger.kernel.org,
	netdev@vger.kernel.org,
	bridge@lists.linux.dev,
	Eric Woudstra <ericwouds@gmail.com>
Subject: [PATCH v15 nf-next 1/3] netfilter: utils: nf_checksum(_partial) correct data!=networkheader
Date: Thu, 25 Sep 2025 20:30:41 +0200
Message-ID: <20250925183043.114660-2-ericwouds@gmail.com>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250925183043.114660-1-ericwouds@gmail.com>
References: <20250925183043.114660-1-ericwouds@gmail.com>
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

