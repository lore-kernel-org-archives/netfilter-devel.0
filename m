Received: from mail-oa1-f41.google.com (mail-oa1-f41.google.com [209.85.160.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 772312E7361
	for <netfilter-devel@vger.kernel.org>; Thu, 28 May 2026 15:28:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779982109; cv=pass; b=BM22pFhBqEoHuVoTjJJ379wcfvSsH4abpa+eIWM1D3GI/GsUcEASrxzFyor47r2G2nPSIyc9HJXuHDPHGrmzLng5K78S9+k7qIzT3kH2XoBisAZ6/22T0R/iELFxAGetoF2uhli6cQhboCfZgrdY6Ar0mjzGIifxbYymMPRcS9I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779982109; c=relaxed/simple;
	bh=QQZRMUyG4rdg9VbIhpDJ4B7GggxoScpV42/zNaHlETA=;
	h=MIME-Version:From:In-Reply-To:References:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=X6XBJys27QITSLYX2l9O78yagbFACr0FCYQQZRBD8JSUc0aOrlvgVmkeNYq2K8M3zPFiV+FoKoBdqPCRS6B2oWoLWx8IfRaQDhzHF+3DTaiNFcCG4+kBkMtBVZazNQlmGsT0GJz2wAv60p/dbicvw76HJJ9bo3emcx5r7aXq7vQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VzOoUkg1; arc=pass smtp.client-ip=209.85.160.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VzOoUkg1"
Received: by mail-oa1-f41.google.com with SMTP id 586e51a60fabf-439a7e828b1so10495220fac.1
        for <netfilter-devel@vger.kernel.org>; Thu, 28 May 2026 08:28:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779982108; cv=none;
        d=google.com; s=arc-20240605;
        b=Diup+P8j5HXELxmUmYStFeYb05gZIraLeYvJLV8dvnbLau5B73K4zuw3Z1uHZzRv74
         L/NUTZX7dQs0i5dw2ojL5aq814TW/ul6Z44GWWpPzX7rB+Dubtvd5yHaL5m1LypFKmng
         scWKMdWNZgoBQaTuWQ6nmCtsv/L9RDx9KLVw+FkCDBLiNex4fvpSuqVL1eGnYhGmBAeF
         uifgvRYgveyFeNJ78AoKu50VMBitRTi8OUVmAttp6g1CFXp1AskJcD9llHM8NoJkmdvo
         awZMnsU34eX2RyvUf1jiv52P5M+GgMI/BelKsMr8COqyfilUQX1nSMOIFbpB4mOlFbXI
         E1bw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:references:in-reply-to:from
         :mime-version:dkim-signature;
        bh=i0leLrUUC77byTFf4T2aIVlZtxOK+NbeHXiUHb/7zfE=;
        fh=WfDUM6w1yLHsEaN7UGT3Bpqsfj5pWvU8m5f1mwx23f0=;
        b=ZQWGnJvl07B3Fn97I4E8abveNnl10g1ccwdFcu78hx1K3vFnaFlMPm9vg4sRq02ttX
         oCeshW3ctFV97Dm2Yk5Pzrfho3mWPhPWsnihreEUMNnmiwRL7oSPmzzQS0XWboCRiYFh
         lP1JXTW9w4n1guNPFgKamFgP12CUu5uKbFJSj2ZaI0TAdhkU6UyrdZE2/byxg6yTeI7v
         CzbD/2z24htKdfqqGP3RlSKcHlaSJzUP01fFxifwZy1NGqIETo91qPxfdUZydtXXXcW/
         aySab/7KInY49TdpAPO+FhYNctg0ZbyGSeVpawRCcx+pMiRW3p6y1gzjRA3uoT5CgpMo
         vCSw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779982108; x=1780586908; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:references:in-reply-to:from
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=i0leLrUUC77byTFf4T2aIVlZtxOK+NbeHXiUHb/7zfE=;
        b=VzOoUkg1ZnTWLmw5dWRm1Jk2re+9L1EkyBrTXhujJ8rLD6Hqdiljyplc0oD+BdEzkv
         bKutHvPStxai+OPb7JNj7p4HFxhOOeqRVJggLYpkyFfn/FryzsfSroleu9E0xl/DIEe7
         ZwyrNaGGgeJz0tIAyHY/srpCyV/EGPEiowWZbAfpBxr6Dxh3/p1i26c/GGFd2hpMBmR8
         CrHfki0XfzHqTWPT3z3Iz+Q6x2cEDwpLwrwgXhhTmXIW3JdUrH6XmsAL3Bjc3M+W2otr
         VYU0THM8UostJZvx0NlQHMh4kVBhiGjvyq1O3DGAq64peggqV9us/ZEq+IhwVsvGrRUl
         RYHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779982108; x=1780586908;
        h=cc:to:subject:message-id:date:references:in-reply-to:from
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=i0leLrUUC77byTFf4T2aIVlZtxOK+NbeHXiUHb/7zfE=;
        b=JZBu30U2JGM7TQf03soXT4CzGitD4CX8AzidnAhQY7z6iUMbEQKRc1t/nYJFawVbSx
         u0WpQHtrqjQx9UsZHUPVvF3uldaF1vALtx708PKohUg9pGu+/AD8onvVtkewzOThCZav
         Jmn7Yts+rJW08KVrMHAtJ8MEGsRFz25W81I6ix+gc9N9Mzo/E0LAvuaYLua6do6KYifn
         18QLbAOlO9SyK/0spC9tFkTwOIILNnj/lWaS73JazQySn0NvYWr6Mnz6E1W7K5xEpQJT
         1Y09i1jR0kuSccOBiNE23zi/hAlGfsjRUNk2hWESR0q/lvpt6SbfYpGfXsteHxNmWgkJ
         H33A==
X-Gm-Message-State: AOJu0Ywud4WkmzC64O3rw8Cfm4tmim1HWV6J6nR+YbNl5pQMik0uzEvF
	XMe/ETf+Axi/CsIOc/ztiJd1qAu0O2z6hJgyzgxaopzp0BZ0/eWVY1sU8Dd3Ahxo8NmYgBPl8d0
	RU/FX2gHcI3rt6CPq4OScu7TlL5UKvWQ=
X-Gm-Gg: Acq92OHubAT4PHVud4SljtAN6xbKQlLkfcWz0tNOSdC9/6XoObuGp+781rnfumlomBw
	2eaOkGw5ebpplLFclPn0R3M7ktzed+XiLW+ET5LpbudNLiTxncziTzh+RrzSAGDE0fvUHh0sZ5y
	r9eVzQwIyJzoZq71EFWBPm8OXnGG6ivxfL436PniUO6jqa5sH/LFoZnDCFJEzcKaTV919eeqi0n
	PbDLyFKBFi7/bgPfdyb3Ffe1ud/hB5MGitOqxjdNfOebmnGRYx8LdsGnK8UwWUn4V56b0iBUNJn
	YzJZfFrgZPNZj21hznzRQdvO4g==
X-Received: by 2002:a05:6820:2188:b0:69b:85ba:bd4f with SMTP id
 006d021491bc7-69dfa8cc60bmr776345eaf.33.1779982108478; Thu, 28 May 2026
 08:28:28 -0700 (PDT)
Received: from 469456477896 named unknown by gmailapi.google.com with
 HTTPREST; Thu, 28 May 2026 08:28:27 -0700
Received: from 469456477896 named unknown by gmailapi.google.com with
 HTTPREST; Thu, 28 May 2026 08:28:27 -0700
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Siho Lee <25esihoya@gmail.com>
In-Reply-To: <ahhNSscKHjx7bebv@strlen.de>
References: <CAOYEF6nf5-B-P7DHf_cpLaqUSoZC2FJphBqE2s4zE8MygMCb_g@mail.gmail.com>
 <ahhNSscKHjx7bebv@strlen.de>
Date: Thu, 28 May 2026 08:28:27 -0700
X-Gm-Features: AVHnY4L8t6Egmo5coWR6ByJIrK5IZmT-3tpDxVljiqUtl1hxBn6WdKFJ5bAIdmA
Message-ID: <CAOYEF6mb3K6=-+h-ayyVrSmXbxLVNXYgj23g4j4tJEaxvz5u8w@mail.gmail.com>
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
