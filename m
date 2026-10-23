Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.47
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792782596;
	b=ZjiYWv/H9PCBWQo19Tz8wBcQG/+muSHIahR6NhI1hMvLMqWej8jcvqbm5n+KzBqNEUjt
	 IMJbi9RKweiflZWWxbX3tf0o23zjOcDt2CqSn4Lekh5XUprI9MC+hKQP/S4AAIqQfQXYz
	 HWW/PdzWjmpLbVKZbqAFO9/7iyB82zyBrXTmeT7HVrsKKct3PNyAV5FyLd2QAUBXlDo58
	 h79yUPpsKvGmF8Eyu/d0rByD0X/zMAd0X6/49DuzRTy6WxGC+rq/L2hzads8rkuRVmNlq
	 e1744rWrhxvYPdQ+FSWov0GmTD3e6q76Dx/IdbqtcviFVtkDT0sJLsrAfWZyDeG86NQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792782596;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=FcyFTCENZhMk1gsRfGkQPunafzE8ryqo5EEaseCkA28=;
	b=rJoAVHi3dZjkk/qRO5R2ojLrBbQzPce+UXvAP9MfVWWFJhmTsmr4VMIzA/LykIfCOmtH
	 dYqocEIbLos1ozHtRzcxRW21Zjcbnx12luNZy//yaz4vzf/vxHNxmmV16ybXdaYI+tC1C
	 osHIXhwdgDdVfMC7J3y4XVLIkp6+la89ioEX2mZCJecdVY2BL1XjhYp1d34P2JZKuXQhh
	 z2RGAZ30Tpy5vCHr17dAIo2VZ0Mk9994ALsCgmWj8ZmFN42znmqUxit3A3C2lGiQciHGJ
	 fwP/3U84TU1J/LdjxpxReTH/Bf2/NYaktOM5dGCFYRUdbkcVXAd17zB1XgRea0K7HPA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b="UsKdk5a/";
	arc=none smtp.remote-ip=209.85.128.47
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E4D4606A31E
	for <netfilter-devel@vger.kernel.org>; Fri, 23 Oct 2026 19:09:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0E4D4606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=UsKdk5a/
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-4a2000d5fb1so7073355e9.1
        for <netfilter-devel@vger.kernel.org>; Fri, 23 Oct 2026 12:09:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792782594; x=1793387394; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=FcyFTCENZhMk1gsRfGkQPunafzE8ryqo5EEaseCkA28=;
        b=UsKdk5a/14muLNQmjISM36bSjDpPBg3M+GjyVFTQRl+Qgb9ND51SiPddkCZZKcsQcY
         vXbUCiBpJDu3dzJIrdfcCF7j5kkKpmKf5xoGTAPtggF5pgHAFX1O9ca2sLkv6O6NdUkS
         Oht+Njc7Bw6CkbSZ7Zvk/iwns5CMIkMVAent+2MfQ+bMVniKb71WfWXO3yGOoRVv2cEp
         nRzm05jlYOgEg6t8pXLI5b7YmzcTNlm7b2mphgSe7t6/wmWtMttqrmZ6Kq8Dh32xTbsF
         TQD//RuVKVc7w2hD5xp/XPjc7vnerZ2wQgc9RIvi2C5M6M+NStrOoAaAcPRXz7cKbQqi
         gaqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792782594; x=1793387394;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=FcyFTCENZhMk1gsRfGkQPunafzE8ryqo5EEaseCkA28=;
        b=MC4fAluGDfF5qQB0LinnuNI0yAaJsWZIftxGguwaN0xYEQVWl7A1xjlU+M455YK9Ko
         muHUFOZ4xaIN3RWYnd/oMswGO/EXzgFjIuKJ0PsJWkbk6PQXPalNZoRS4nrCa/GdyNBY
         v+fGmxgx4pbro5kX1rr7SM4hPZVcQSVDh+9ucYlNMdMgyWtFgkscxONIfWDujRn/Yamc
         KqwmSndz1SQv4uVyFpsSUnKHYCO+6R/mlFhsdKIDKbPzdBZSHOYzpUCf1u5VNxeD8wCV
         KsJSC5XAWfWdIkmKItmai7qCeF+eRlOMhRLOUfKWc/eSYKn1/zuOsbYAFcn6jGWeDNgp
         HcQA==
X-Forwarded-Encrypted: i=1; AKwUvBwfwtBR5Vh/ATcFFg4zM7PiJIiJTRyl19/eGJdB3S50AbiTaapAUNQrfgYhREhTO30tUKJ7rXQBVRkq8AzaiQA=@vger.kernel.org
X-Gm-Message-State: AFq9FYLPKhZ7MThOSvuIHLc8sWRr7hCLoKzuXsD3gaNbkQdOm7lliigD
	KMZHpEILnikPU8gSu2KpRw/FLwLZwSfC5xsp9cpaWXKDd3PaxNILDHLL
X-Gm-Gg: AYBFou0/G+tdtss9PewDODrk2JxyzIlWPUtGb6aUkU/VmAbFJ4KZV4OEPnOWRH4u8HQ
	5gBJpxF6lQjNEPmjieIB5HTn6lwV/Isx6LXI+qaK0Ty1vH0lfG+x0YBp3A8SsQasLOlT5D7YqVB
	Riv6L0sHe692gU68DuS2PKzbxuHl+MLPGXJh4zkpg3GpzP6STTEZK/wIlpSbxPvmReDEiqa/QwV
	/Ipf52vGJYDFESOKh6M2WU8wGuMJQcnC4OL+cEiSerxO8dIdxayfMkHJ6t/cGzCzaiE8zZPRQBP
	Uo3iG/diX3flRw91T96SunY8Ls9s3OgcHgXfRY2z5uQoTQEu0TafenSlItF37P9n1KpcmzhICF4
	LBTBgb6WzEF/viyt0EH+HAsQbSj8lNs9W3vuiYFtYiFCfOQ0ro+YtshIws6hGTGKzCciAGXESQg
	aq+VpZ7g4pcILjAxyr1ErX97wiSiRMOOzfuFf+6GPB4IWH23d6VxTG7DOFVOukOmxR1WyTlFflD
	5Q931Hor6ABJbYlgtnckyqX4TU5jq7smaThgBGnCNI3cs5obZLXjSEevQ34kCheX9vf+T5HCiO2
	gLD8Lcy9oPT03bJxRCw5EYSdQJWSxQr9E/4wp/fZeNCVvCui5oYzK3IO2wgdGjQo43/A6bmajTZ
	Eq2TFZjKBI9387+HdHTeKmeOs/bYBE+wrdbZwy8gut+M4npHGpPS4VKxesYYvThfriGSA/OaekY
	4cwETdG94PoV6geDf6jDj78+Y=
X-Received: by 2002:a05:600c:1d0a:b0:4a2:1a:a121 with SMTP id 5b1f17b1804b1-4a211f0e0e1mr46468395e9.18.1792782594355;
        Fri, 23 Oct 2026 12:09:54 -0700 (PDT)
Received: from saif-MS-7E77.lan ([196.187.138.214])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a35a04ad39sm11352595e9.1.2026.10.23.12.09.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Oct 2026 12:09:53 -0700 (PDT)
From: SaifAllah benMassaoud <saifmassaoudi18@gmail.com>
To: pablo@netfilter.org
Cc: fw@strlen.de,
	fmancera@suse.de,
	netfilter-devel@vger.kernel.org,
	SaifAllah benMassaoud <saifmassaoudi18@gmail.com>
Subject: [PATCH nf-next v2] netfilter: nft_limit: reject configs whose per-packet cost can overflow
Date: Fri, 23 Oct 2026 20:09:14 +0100
Message-ID: <20261023190914.1487094-1-saifmassaoudi18@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261015225705.76031-1-saifmassaoudi18@gmail.com>
References: <20261015225705.76031-1-saifmassaoudi18@gmail.com>
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

Byte-rate limits using long time units (e.g. bytes/week) can overflow
priv->nsecs * skb->len in the packet-path cost calculation, silently
defeating the configured rate limit.

Reject such configurations at rule-add time instead, using the GRO
maximum packet size as a conservative bound on skb length for the
multiplication check.

Fixes: d2168e849ebf ("netfilter: nft_limit: add per-byte limiting")
Signed-off-by: SaifAllah benMassaoud <saifmassaoudi18@gmail.com>

diff --git a/net/netfilter/nft_limit.c b/net/netfilter/nft_limit.c
index d92455fc8665..07dc5c55b0a0 100644
--- a/net/netfilter/nft_limit.c
+++ b/net/netfilter/nft_limit.c
@@ -13,7 +13,7 @@
 #include <linux/netfilter.h>
 #include <linux/netfilter/nf_tables.h>
 #include <net/netfilter/nf_tables.h>
-#include <net/gro.h>
+#include <linux/netdevice.h>
 
 struct nft_limit {
 	spinlock_t	lock;
@@ -59,7 +59,7 @@ static inline bool nft_limit_eval(struct nft_limit_priv *priv, u64 cost)
 static int nft_limit_init(struct nft_limit_priv *priv,
 			  const struct nlattr * const tb[], bool pkts)
 {
-	u64 unit, tmp, tokens, rate_with_burst;
+	u64 unit, tokens, rate_with_burst;
 	bool invert = false;
 
 	if (tb[NFTA_LIMIT_RATE] == NULL ||
@@ -74,8 +74,7 @@ static int nft_limit_init(struct nft_limit_priv *priv,
 	if (check_mul_overflow(unit, NSEC_PER_SEC, &priv->nsecs))
 		return -EOVERFLOW;
 
-	if (!pkts &&
-	    check_mul_overflow(priv->nsecs, GRO_MAX_SIZE, &tmp))
+	if (!pkts && priv->nsecs > U64_MAX / GRO_MAX_SIZE)
 		return -EOVERFLOW;
 
 	if (tb[NFTA_LIMIT_BURST])
