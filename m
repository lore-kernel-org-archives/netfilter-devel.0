Received: from mail-oo1-f51.google.com (mail-oo1-f51.google.com [209.85.161.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B9B92E7375
	for <netfilter-devel@vger.kernel.org>; Thu, 28 May 2026 15:28:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.161.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779982092; cv=pass; b=Q02wQKiDwntOfz0flkr0WYHY/mOfwMX1RWwOWuOs8SB7Ak4X2mqXy/sOx0o8F55WI5GjzEp27CIyeiZDHnyURp4MAqKcEKr4jk4RUV+H7WfbDmIDHesTpLXe223zWN1vGm2HvUT5HAaITa6gKgTKkTaabbL3npmKD8hNvE7z3bg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779982092; c=relaxed/simple;
	bh=QQZRMUyG4rdg9VbIhpDJ4B7GggxoScpV42/zNaHlETA=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=JmH+UyKhDdF/llYdNX50rAJhMhlCho59nVF1U0RcDLBQ7IwzONqQXdlzs4rVoGaUjUz2IVSqETmxTp6RnkdA3eBnzKKF9UQcJytoO9wkNZAYtz1JxkKhMXwhk7ykoHjmaKoKm8NQ9p8wnEr1/rH2/n6bb3XHZ1vqS8dQ2zc3WXc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GfuDqkcx; arc=pass smtp.client-ip=209.85.161.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GfuDqkcx"
Received: by mail-oo1-f51.google.com with SMTP id 006d021491bc7-69de16f5f79so994444eaf.0
        for <netfilter-devel@vger.kernel.org>; Thu, 28 May 2026 08:28:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779982091; cv=none;
        d=google.com; s=arc-20240605;
        b=BjWMFHyhPVhhcIp8xZ8uZYFqJxsc7+93SngJf+GDGBZkYFXXinaeRJ/vJl70qBYARj
         5v/Qi8NNDpMiQ/T/xSDDrP5sEJpz+5PbXrx2mZJhOjuahS2PECQEv/FfMrSUrzzVA0Os
         WQexBDblbNwo03MwC2PPFkIIMAKMUYL7fu0CuQRLJFewo5S8YxMk9edVCIZV3jAWksIG
         ZNZquxeKD9zkbWpE8Q53qxHwDfabcXxLMK5aiBw0bYqibElrDyodlmXdCakvZTDEefvf
         Q29eVtNyJN1rYm+BpAtCdkGarIH1e+NXo0BIVZqPr1c0AuUEaulCIunXgY3KcowZpfWM
         JyLQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=i0leLrUUC77byTFf4T2aIVlZtxOK+NbeHXiUHb/7zfE=;
        fh=WfDUM6w1yLHsEaN7UGT3Bpqsfj5pWvU8m5f1mwx23f0=;
        b=f0OdRWkJBWQko7k7HX8cyB/eicGV2MccHMl999ICS62AII9hgPhrSMvqgBoUGbM5Jg
         yjgJRZSTYSfm0w9BzzegLjj+aITZLsuKVmtSctCxjXnRmFN+F+Z5+5SxxBexcw19KuF/
         xs1iQAyGPbd7JVPxvTIqYOLkG1mafVVmEc89h4MtzDQQ8mEc32yKDV/lbziHD4F22mcj
         5ElzqPFm0qI+hT88fUOVLCFiQkyNmXWp5nYUkv1q38VS1jUqTofo54tWt2Q/cxPGgc+F
         Jf8lrZja9IOQMpSCmSHa2XI5lh+b9NCLzYwQzv1UaWbudlr8NgcGaxbcOahaJ1gCO6JJ
         6y1g==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779982091; x=1780586891; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=i0leLrUUC77byTFf4T2aIVlZtxOK+NbeHXiUHb/7zfE=;
        b=GfuDqkcxzhGtWCb6j9Jt2pXXoNhUxA+e5Bj90cyAGSaO5tTVYQCMR32CQMI2TAU4VQ
         0ktrTPAvf9T32ffX9N604td1xtaVktw1drvJ3ut2zvn8vNhRkUPYLpihkJfSQfD2jQdi
         kTvp6+5Y0LYdnAir/AvH5YZgWpzTCV8+FZT6IB8bgLbhBJS8X05RW/2hH25RLc6R9tSM
         BCA3S3XDnS5/TBZQVT5+P+6C8mzu7FAlbZtj/XRJ+oo+ciE1QxPHNf69/a12zlU4O5P4
         v4/1hJS/NVZBojFdQ2ysczS6WTCtIPC+XH2CzVazt5jn42iAxDqqNtDXdspsVwrje6Xa
         YrlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779982091; x=1780586891;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=i0leLrUUC77byTFf4T2aIVlZtxOK+NbeHXiUHb/7zfE=;
        b=d/eql51H0Z+56TNEg+b5ZJameDhQ0e/SSPzm0dqfSpZO6O6hSP26RZYiIUHFqrd5fE
         +q6+LqndAxvOQ17cKMehWn3WqFHMXeU6GqReXR3bWkP1aOecB/IlUYi7LBlU3mx4jp/Q
         vGCcJM07qBI5KoGsXNkIvQTHEDu4krfv1JbwgKhQQwvXfw0KPsAMiHdoyEqTYg0WzBoU
         CepbpG+5IyezZvjw0IUGMX6HsDacBXXFaClwR7fo/Imp14+LGp3Bv00JF5vKRaWhK//a
         Q50o+jqfX6BGlykuTAx9PT/zFkepHxXWgCaWDpDAMjwhJNg5Vs//HXIwKeNf8eTWsuVj
         iTLw==
X-Gm-Message-State: AOJu0YzAG3MEbK13wvxO0O6+xzK3/Wrmjuf3RQ7rZodOuTLVcQZBBB5d
	qkYFQexTlv+USqR6oUWm4lN6x6Qk+A0kjaixjevjHDvxjeBrDnu0dRvlujepN1QC1D1XNwCZe5Q
	lWqDThqlyh60w9J9Z5ebqHYDmNILNH0Y=
X-Gm-Gg: Acq92OG1/A8ZYMrlRxvB7yJy/h8NeWK+hE8I+3wLjjIf8Gz+nMKiF0U5RZ5zBMh5OyZ
	+6kne0qq/d+InTyB3yWcEI6Fwm0Wih0W1DxolIXClPKdLGo+HBYZ7DYPKS5ZGYRALbR0wq8ifwJ
	HSvV77VSdLmmHTmPON9fiNrJ1huJmM/SAfmwV3jLKzc9XVfL/kfSXnd6RgD26oHEqebI66ZMU5l
	kDWDKA9tanwoluX5aaLR3yTEUTg02QvEgHgzB6IdKX4Fb1FNIWBOrD1Q0zA9s/nHCEm+z7LfAAf
	ukzu1x2VEhSGYDZG6fz8WvZjDA==
X-Received: by 2002:a05:6820:1995:b0:67b:bd89:90ed with SMTP id
 006d021491bc7-69d7eca473fmr15377134eaf.41.1779982091287; Thu, 28 May 2026
 08:28:11 -0700 (PDT)
Received: from 469456477896 named unknown by gmailapi.google.com with
 HTTPREST; Thu, 28 May 2026 08:28:10 -0700
Received: from 469456477896 named unknown by gmailapi.google.com with
 HTTPREST; Thu, 28 May 2026 08:28:10 -0700
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Siho Lee <25esihoya@gmail.com>
Date: Thu, 28 May 2026 08:28:10 -0700
X-Gm-Features: AVHnY4IdqTJ7zDmth5WMGZnzwixk6rFBEMqwDoQ3EpXt7LiTgL1t7notH1b99jM
Message-ID: <CAOYEF6nkrD4o_Kw_gxbv7Vefxpp=E6N4X_s-3KEcS1f3Hb1uAg@mail.gmail.com>
Subject: [PATCH v2 net] netfilter: nft_payload: validate offset for all
 csum_type paths
To: Pablo Neira Ayuso <pablo@netfilter.org>, Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org, netdev@vger.kernel.org, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

From e11e35dfd10960ea8ca4258dfa6ed7aeb207179f Mon Sep 17 00:00:00 2001
From: Siho Lee <25esihoya@gmail.com>
Date: Fri, 29 May 2026 00:23:35 +0900
Subject: [PATCH v2] netfilter: nft_payload: validate offset for all csum_type
 paths

When csum_type is NFT_PAYLOAD_CSUM_NONE and csum_flags is 0, the
bounds check inside the csum condition block is skipped entirely.

For NFT_PAYLOAD_LL_HEADER, offset is computed as:
    offset = skb_mac_header(skb) - skb->data - vlan_hlen
which evaluates to -14 (or -18 with VLAN) after eth_type_trans()
pulls the Ethernet header. This is a valid negative offset that
refers to the Ethernet header area (used by bridge/vlan rules).

However, without any bounds check in the csum=NONE path:
- skb_ensure_writable(skb, max(offset + priv->len, 0)):
  max() converts negative values to 0, making it a no-op.
- skb_store_bits(skb, offset, src, priv->len):
  A negative offset that exceeds skb headroom writes out of bounds.

Add proper validation after the csum condition block:
- Negative offsets: ensure they fall within skb_headroom(skb)
  (bridge/vlan rules legitimately access the Ethernet header)
- Positive offsets: ensure offset + len does not exceed skb->len

Also remove the max() wrapper from skb_ensure_writable() since
the new validation guarantees the offset is within range.

Fixes: d5953d680f7e ("netfilter: nft_payload: sanitize offset and
length before calling skb_checksum()")
Cc: stable@vger.kernel.org
Signed-off-by: Siho Lee <25esihoya@gmail.com>
---
 net/netfilter/nft_payload.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nft_payload.c b/net/netfilter/nft_payload.c
index 01e13e5255a9..2c891c13bbf5 100644
--- a/net/netfilter/nft_payload.c
+++ b/net/netfilter/nft_payload.c
@@ -892,7 +892,17 @@ static void nft_payload_set_eval(const struct
nft_expr *expr,
 			goto err;
 	}

-	if (skb_ensure_writable(skb, max(offset + priv->len, 0)) ||
+	/* Negative offset (LL_HEADER with bridge/vlan) must be within headroom.
+	 * Positive offset must be within skb length.
+	 */
+	if (offset < 0) {
+		if (-offset > (int)skb_headroom(skb))
+			goto err;
+	} else if (offset + priv->len > skb->len) {
+		goto err;
+	}
+
+	if (skb_ensure_writable(skb, offset + priv->len) ||
 	    skb_store_bits(skb, offset, src, priv->len) < 0)
 		goto err;

-- 
2.43.0
