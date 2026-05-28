Received: from mail-oo1-f44.google.com (mail-oo1-f44.google.com [209.85.161.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CCB43ED109
	for <netfilter-devel@vger.kernel.org>; Thu, 28 May 2026 13:39:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.161.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779975585; cv=pass; b=ldUg/aAKAGPbBGYJjdyBHm4wtEXSRZ5FP71SEUmb23opmggvV7vluCOUseY36WUuzEL0rTwbrmj3vRlEtXLnzhOLdMvnXV5/JSesq6ajC21MJEcAD0J+5QVVuMqEkjnM3pKzpaJr1EwUEmIb7baoBsaY+IdSPnDIl7PhvpuqNcY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779975585; c=relaxed/simple;
	bh=yw019RHIYxycqtwq64UtUDUJDQ24/M2csMV8DlAPgw0=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=XHkOIKY7wbzANOHxePxg/etbigvBHyz4zzpuXLUZQ8vbLrSQufSFF99IsoKEoga2F5NQoiVVGzqgfoDe7oRrz1x1iShSTbacpNYmVDk55ZNk9ml55cbNcdd8kWG8APCtewY2cA1kKuFteeH5SAOlk0BKfFx2kQxCjA503MziS88=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lH4d2LxL; arc=pass smtp.client-ip=209.85.161.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lH4d2LxL"
Received: by mail-oo1-f44.google.com with SMTP id 006d021491bc7-69dc2c38f6dso1615017eaf.2
        for <netfilter-devel@vger.kernel.org>; Thu, 28 May 2026 06:39:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779975582; cv=none;
        d=google.com; s=arc-20240605;
        b=U0iuF78V4ueQ4TXAW5Emet9Ip/gXO3BduDva+9ef5V86IsvvR4Ft9wERzLwM188o1T
         rTnYIuxW87r1LdxIJb4BeGbksjft90k2rpeRgoQz06qwqrgMijqwn7zANU9Fi7RWT61k
         fpE1qKZUzBDJeIjbFjqhVSVxHlNtZYHIk9QFkY1azdvBngth0d+wrWa3J1ukrSh6Py1T
         l7ApkIG401ED1toJxKccesU6CCFkdYSZfFApytlJEt9kB3fgZz3LI0gQaAK4hp0K5L3N
         las9WSfTIY0DVMdzdYxnC+LU/a4kXcpmix1zfbmQqwHZw8OxWSy3k4ZjtwNvJMWirwpU
         Y0Xw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=OV5MWD99v5jJibwQ0F1rYFH202co2ScZtiupmESToJY=;
        fh=WfDUM6w1yLHsEaN7UGT3Bpqsfj5pWvU8m5f1mwx23f0=;
        b=ZEPr1rMGkaqHmu994XQx0S38OjeDUfzc/xRIYnKnP3Bm2I4N5uq2gKXIJPa6DkIgIR
         9ErSOEgo1ByAsWhTvxKsipKNAgpNA83+9DSfvQKEZanvgZjhBNnivHYrSDOU+z5i18FT
         JS/0uzHoEvzUNqlJroaeIJ12UCBQ+aWecPJOQ7BT227zaGOvUMfQNJQ5WtXwoX3mZw+d
         +nvzYErRWDXUUMqb6gymA3ltHWVdVkwblWzD7pEsodn0htTYQvlKYv4p5MtHjiCBykK+
         Az+J2r2R+B4Igbcd0bibqW4Bn545ZFYg4kj5zLDykrnW2JJEX76MOmXFD+mOzI8g0bi3
         fs8A==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779975582; x=1780580382; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=OV5MWD99v5jJibwQ0F1rYFH202co2ScZtiupmESToJY=;
        b=lH4d2LxLZepwO3Kezjd4XHcM5OYtiIVmZzGzAYcJLS/mEngBValeUxxK3RV0AHkjCL
         /K4I/+9N58xw966QiVMiztab/P6EdXYcdHlS7bgC9Q/XgPKEHbVzCCla6yPV0e6lr448
         820x3Ndwhotnz7ooe/YsjqVy++2Sq6RQ9zPIfW90OcFT9MNgG42XJ6TOfkz3MhZYzzO6
         H0dMV+wNrIiL4I2iLamLAJ7u46zWj/6BwqTyZUN8ZMayHEg0BBgXZIAGDVCoElj5A1EV
         ah5596D6oLY370pX364y2rLNqNtQ//OIJlRER1ot9l0Is+5RlJiupjpCr+rRLdEXc4Un
         cfyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779975582; x=1780580382;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=OV5MWD99v5jJibwQ0F1rYFH202co2ScZtiupmESToJY=;
        b=QJTrtngXn2+omZAC9I9EaQmk6dFlCVdV2yvKQDL929A2XIi0s46DWTZ9dZ9XVZd3mG
         AJItilMj+xw/IRVXERZdwu524Pj4/gEfKVjz52AUhVev4aSOh/WyGzPfJunn5dTs544q
         E4SKjcubsQe9Ngclqch9O2TKVQcnpG4QHhYNMl6pbG95N4UHQev7AfM/4wiV/lqjwGu0
         4lM80TEHqiel2TegpKCtqtuuY+nkqOR8LnowdnZzwzTilzDHWb93Vikt6sHdVoU8Gt5o
         icJvbq/VxiUf7tpdclykYy68i9X71dUp3wIyzFJwJNBRrteWbGKcHHfqoQ2Tkp7jbCmV
         dpsg==
X-Gm-Message-State: AOJu0YwBD7HgIBuR5k/1y3cCqGPo2EVqJyFRi6DIRcgA+hkXI4fB0UUs
	We5Zsq3xsilTh3XtlN1dECEVXeoHi6vJQgS/yyIWXwZd0iaTDtv3HYqjsRwojueJ2IUP7v9bG2Q
	yHibvjaBWxFIQQGOfcy34NM0v8z7g48M=
X-Gm-Gg: Acq92OEH3eHgkp3W1r1DlpNe0tXTuVPkNqQcKmcAgW9LWeI0VAhwxaL4/Zxl9MKiMRv
	SbEPQcy0BzYG+BdT4eJfJ1wkabPyCzNPBdxMVsb+c5vLFbkGgYS1CxvEG6eHqj0eAQy0XQbK/8R
	j/66B+OgyhKJNf7Q9JLf0nPRb3v/NEVu0TTQIDrZcSP5m9opi6oaf7GEwHY83Z4IRz/hYL9eS79
	1j32dvyjj8wjjIwYPQ2lF6JsZaJFGRLAV2exp/2L7ZBGptovZZvQDMn383LvHXvBHlUh1U3sKpU
	PjfYaVhMY5g4/u5a8SgDmOcG3g==
X-Received: by 2002:a05:6820:c203:b0:696:6585:a51 with SMTP id
 006d021491bc7-69d7eb66ac7mr12034312eaf.13.1779975582247; Thu, 28 May 2026
 06:39:42 -0700 (PDT)
Received: from 469456477896 named unknown by gmailapi.google.com with
 HTTPREST; Thu, 28 May 2026 08:39:41 -0500
Received: from 469456477896 named unknown by gmailapi.google.com with
 HTTPREST; Thu, 28 May 2026 08:39:41 -0500
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Siho Lee <25esihoya@gmail.com>
Date: Thu, 28 May 2026 08:39:41 -0500
X-Gm-Features: AVHnY4IjQLe8D3fhmXisoI-4JSwxgrf6oHHC3rTfzHf8ykBiOBRC4gfpxJ5yCMs
Message-ID: <CAOYEF6nf5-B-P7DHf_cpLaqUSoZC2FJphBqE2s4zE8MygMCb_g@mail.gmail.com>
Subject: [PATCH net] netfilter: nft_payload: move offset bounds check outside
 csum condition
To: Pablo Neira Ayuso <pablo@netfilter.org>, Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org, netdev@vger.kernel.org, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

From 574604a1b4a98ee130d7f727ad3c8a7df3f3b6f1 Mon Sep 17 00:00:00 2001
From: Siho Lee <25esihoya@gmail.com>
Date: Thu, 28 May 2026 22:39:03 +0900
Subject: [PATCH v1] netfilter: nft_payload: move offset bounds check outside
 csum condition

The bounds check for offset + priv->len was placed inside the csum
condition block. When csum_type is NFT_PAYLOAD_CSUM_NONE and
csum_flags is 0, the entire block including the bounds check is
skipped.

For NFT_PAYLOAD_LL_HEADER, offset is computed as:
    offset = skb_mac_header(skb) - skb->data - vlan_hlen
which evaluates to -14 (or -18 with VLAN) after eth_type_trans()
pulls the Ethernet header.

Without the bounds check, a negative offset reaches:
    skb_ensure_writable(skb, max(offset + priv->len, 0))
    skb_store_bits(skb, offset, src, priv->len)

max(-14 + 4, 0) == 0 makes skb_ensure_writable a no-op, and
skb_store_bits(skb, -14, ...) writes to skb headroom (OOB write).

The signed-unsigned comparison in the bounds check correctly catches
negative offsets: (unsigned int)(-10) is a large positive value that
exceeds any valid skb->len.

Move the bounds check outside the csum condition so it applies
regardless of csum_type/csum_flags.

Fixes: d5953d680f7e ("netfilter: nft_payload: sanitize offset and
length before calling skb_checksum()")
Cc: stable@vger.kernel.org
Signed-off-by: Siho Lee <25esihoya@gmail.com>
---
 net/netfilter/nft_payload.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/nft_payload.c b/net/netfilter/nft_payload.c
index 01e13e5255a9..62661e4eeb13 100644
--- a/net/netfilter/nft_payload.c
+++ b/net/netfilter/nft_payload.c
@@ -873,13 +873,13 @@ static void nft_payload_set_eval(const struct
nft_expr *expr,
 	csum_offset = offset + priv->csum_offset;
 	offset += priv->offset;

+	if (offset + priv->len > skb->len)
+		goto err;
+
 	if ((priv->csum_type == NFT_PAYLOAD_CSUM_INET || priv->csum_flags) &&
 	    ((priv->base != NFT_PAYLOAD_TRANSPORT_HEADER &&
 	      priv->base != NFT_PAYLOAD_INNER_HEADER) ||
 	     skb->ip_summed != CHECKSUM_PARTIAL)) {
-		if (offset + priv->len > skb->len)
-			goto err;
-
 		fsum = skb_checksum(skb, offset, priv->len, 0);
 		tsum = csum_partial(src, priv->len, 0);

-- 
2.43.0
