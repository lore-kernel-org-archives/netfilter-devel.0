Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F261C35BDC9
	for <netfilter-devel@vger.kernel.org>; Sun, 22 Feb 2026 19:59:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771790345; cv=none; b=pMgck5DUXnDRz/UM3cChI5O7mjCTSNV0gOnmonum5PVtZ3DppSD/H9jX8BvnZWpJeK6zvNnoA2MDqD+wd7jD1XSszoCJi2sWqaLya8HM3u6nRFXGsdd0VDEqzO+5VnXu/VtUJt46RCRaZY8qX3v+HVCDx24stDcO7kVBk7tZYOo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771790345; c=relaxed/simple;
	bh=YUxeWiumDIevi3pfAqr7wG32llGuW6KcesoGqx9k/lI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=okUfaxF188HcUbIWrBLo6EE4SUEcxtMGMhWAyL7/iq+/r4nVBUZknterXoG9wckQjBhIv3J1EK9w46gknobuaJJQNWgu0h5TDtzb8/RlkSuo5McggqwWJsfnGRrklrFRJekL8AMVIuJN0MzLgAmUDMZrcfYbty70TqfM8H0+/mE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Bjz2q4W3; arc=none smtp.client-ip=209.85.208.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Bjz2q4W3"
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-65a2fea1a1eso7610709a12.0
        for <netfilter-devel@vger.kernel.org>; Sun, 22 Feb 2026 11:59:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771790342; x=1772395142; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gYuYJwbEOhynhWIFlwCSfc7cGmzyMZHQheg8tgUujHU=;
        b=Bjz2q4W3gsHOOFKzISBXThuyGAakODBeQmNZRMVEaJIaiUUdp+o5MLdOcDguLcG5b2
         TGxT3fOW72ff6f0fi09NAwtzPYm6wUYsGEwISohL7e5ZrHncP9iPiQUXKYaB0TX6bdMc
         3T6K7q565EXqA2Jt+CZW/8zseyZ8k6hw06se6ZNf1QsH8icABob0xj1W7/VfLE+FmsYs
         FrQXxC4ICOFYQElml3XwoFP9mr1k2iKAkCRmdUSQSGh1kmZv/XviSrk68ifgAE1qNMhK
         p3STw0FqxOy8B3adUfXGdKcQ8FogTLAPaOmdCYDScfQQroSoDvQFITeii4mhaKtriVN7
         xMZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771790342; x=1772395142;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=gYuYJwbEOhynhWIFlwCSfc7cGmzyMZHQheg8tgUujHU=;
        b=sMD0Ln5r7XBLYNkOnUWqRwKgWg/zCFfbwA9eHa8+47MuCDE21JW0ttYuxjFJTkg24F
         uJWPejunuWqr+tuSDnbbZjkT4lKj2kLJOI9BE+1yBzc3GosFR53vvNMVUPrP2HSAOpzT
         bctCL99lW0FxTdJreyiN75vhHD0IQau/sjb8lmz/QHG7xXlxlINk4l/FZbxQAT9a/ZrH
         uoLPBvk84NJhQta1W9jc0HPxPIt5UvYvLxwZCV6YL1/iWlCWAQnkTi5SOvAk1cPSu79v
         C5sltoI1XZCLZ/PvFUzsohUkiGd2N5AMzwq8AZ3s2ham1xcVOrF01rGfPYIxW4YU6D/a
         +1tg==
X-Gm-Message-State: AOJu0YzXAiJFb5+5+TJkErVQANgYM64mg6zJI3wK1gM1dUhfLc1XRYDC
	vD2Sp4tD24SQKkKNhYQviNZwbnHY1M59gCy/f3D8sML/zpksnZR4JmoD
X-Gm-Gg: AZuq6aLwWxQf+omkUhsWkfaGbT0Ga9aXEAoTlfBywpm+rfTI7sf7FyTAz+d15Cbk/A+
	/YTwCHkCTtwBV2nfwjfCoXYIBysGzmYESryXfCnhyf1Z8RVBaImvGABKAhkFZQpO2V2045qFQDq
	Q82deC6BvKMrc9sCHQl02fuov8F+mFLvgtwZ7EMKT8K70hUQVj30P3MIBkHdacDpsAraJwysjxN
	C1n/mn51F4mCfa8gPqeRc/jApsSeFoKF9BpzIMzynRKPMFmuRbZXCEMFx/Hc3ydd9OgxDX1TRry
	w14DkJyBgb22EvfOyWKEi7p63GmCHSbAfXJEO+sBRoxN3HTvUsuQJYkVMv91mv95VIdu9JsCL+y
	aHollaAnyfvlK9B9TmiTOwLOkA3NFPOUVVtXtQy4iVspsNIVsIEnwWibLZQN68IBjLEKqUz/tch
	R35MsNHfK3wYllRPdgW5WlbKn0q3oo+sK0BB6xx7uYN+OYiDt1Vt/L9XOgCnetjSXU4lbhN+R8k
	WCR5uzrxJtksWqOfWjJQuLUPIdx0L8m/Sz/20PTp9uP8KyK1Sjs5dfKD2c7SJ03vA==
X-Received: by 2002:a17:907:2d25:b0:b8f:c684:db3f with SMTP id a640c23a62f3a-b9054196076mr677551666b.12.1771790342007;
        Sun, 22 Feb 2026 11:59:02 -0800 (PST)
Received: from eric (2001-1c00-020d-1300-1b1c-4449-176a-89ea.cable.dynamic.v6.ziggo.nl. [2001:1c00:20d:1300:1b1c:4449:176a:89ea])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b9084c5c514sm246125466b.5.2026.02.22.11.59.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 22 Feb 2026 11:59:01 -0800 (PST)
From: Eric Woudstra <ericwouds@gmail.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Phil Sutter <phil@nwl.cc>,
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
Subject: [PATCH v18 nf-next 1/4] netfilter: utils: nf_checksum(_partial) correct data!=networkheader
Date: Sun, 22 Feb 2026 20:58:40 +0100
Message-ID: <20260222195845.77880-2-ericwouds@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260222195845.77880-1-ericwouds@gmail.com>
References: <20260222195845.77880-1-ericwouds@gmail.com>
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
index 008419db815a..4f8b5442b650 100644
--- a/net/netfilter/utils.c
+++ b/net/netfilter/utils.c
@@ -124,16 +124,25 @@ __sum16 nf_checksum(struct sk_buff *skb, unsigned int hook,
 		    unsigned int dataoff, u8 protocol,
 		    unsigned short family)
 {
+	unsigned int nhpull = skb_network_offset(skb);
 	__sum16 csum = 0;
 
+	if (WARN_ON_ONCE(!skb_pointer_if_linear(skb, nhpull, 0)))
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
 
+	if (WARN_ON_ONCE(!skb_pointer_if_linear(skb, nhpull, 0)))
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
2.53.0

