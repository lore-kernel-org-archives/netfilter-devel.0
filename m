Received: from mail-ua1-f99.google.com (mail-ua1-f99.google.com [209.85.222.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65BAF3815DF
	for <netfilter-devel@vger.kernel.org>; Mon, 13 Apr 2026 04:40:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.99
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776055233; cv=none; b=i4I17MFxiy9rsKk3knELLSkQB3LvbIPV0fDmJxsmZA6UBmZygj1jfxAVYZ/nIJR+ytFAHQDick7oxoLBzI3aVjE+/4hkhJh6e5kYpnGxVZUpy3P18xLcKO+FvEou7iurwXWd4rDJnvuXtg8bIWPZbSxnVsG2wkm5sC/rK//O7p4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776055233; c=relaxed/simple;
	bh=eUByrnPJ2nona1QXhiPKoFAJ4ou5D+Pn4Dg2jpFDt6M=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=LEle8RnXFyZvBgo/m8O+nHADK4mDJJ7TOauB4N7KkETiHgZGUbvPLvvLdaSTYghpKbSwVF7BmIA6P1GxG+K24q+B699ZHajGyExUA8bPL4obQ1FQjUs/hgxa+alPLIViD4NcahAe7u1XaofsKIW/VDqtOmvrkLjdW5eCBshybXI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=Bsl+aEeG; arc=none smtp.client-ip=209.85.222.99
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="Bsl+aEeG"
Received: by mail-ua1-f99.google.com with SMTP id a1e0cc1a2514c-94ac2903796so70948241.2
        for <netfilter-devel@vger.kernel.org>; Sun, 12 Apr 2026 21:40:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776055231; x=1776660031;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:dkim-signature:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2l7i8vnpUJQTdJaWwY66SR5P0SKGOILNorZy9BBZKRQ=;
        b=AZUZ+an2SpFYb7uX3GqlzqYdKVpu13mxnyNuTblnknKZrG/G0KFtA13sF1lil9g7/U
         A+nnJg4bd8Kcz3JscdnQ0s2jptvHCZM9d94NP06SWaAin4eZeTsicS67X51c9d/L9Vz2
         4TUVsK2RRcSdCc64cgrJGWiOfJZ5jW4GqiMNpenE48Swrdh/1Tfv3XSLWZQAK+WMepMH
         BEX+HsumPQ7N5OEd5qQrShl5ebpkbDoGpWaf4Hr41BDmxhlF0PJnQXnycpPGxQfRY+8+
         WDqu5o3H+3MYkVEPEIHKYyZGGlcy+NZEnBCKGpC+RQoiBMvgmaxn1m0zQL16V3g28JPI
         MsvQ==
X-Forwarded-Encrypted: i=1; AFNElJ9q+HjGFGs9RjU96vYamDWb1QwfsUtKeGGHmUVZu32NGyikM9M+5zMjCJqkn5j0l2VspvuIS07VrwkkaPtOqYc=@vger.kernel.org
X-Gm-Message-State: AOJu0YwVcheL2zJr0WIjZjB1KuPuz2Bf5U149wVl8816m6usDa1A8p58
	BvCgvZjtCF7pJjiyIWjTMGiArTg7JixJQhmq8htenIimTm85JeDo/TYOv0re8Z5Z8W53oSRn7aq
	2orEAwpuQUUJ7KY8R6oqhtIfJ8/3X0KfTrtHkaN+n7YC6kSvHmJhXHaI3O7/WeN80Yb3Zbs05zD
	PKNLoW9Ceh7lkBzHILo9iqlO7ihdNT+NK0tqbz1iRUI8UzTsdeLdwFjnRPQQKwPmqqexE3dDGQt
	dwP343BTex5ZCUCuUmjdnSwTVOyur76fW1d7tFZ7XE=
X-Gm-Gg: AeBDietrBESk1VQpap6pQ9M1V2gS2yWnYJc7hluAxBVwQ2DoP56p2S9FQH4msIQM5ek
	GyGBaygxY8yfDpwcEuD0UbnqYu7MohOMwWaDBdqhmGQZ952AFXjfJJwk67MsGRgvvOpRUHzQmcl
	tlIAQwOiCWEqFlb4BxWEqVEcuI3qUkDpO5ZG4KL7YW9jbboAerwYXD7OqOUt/fGggH/2FVMyoES
	ZTHEq1TaRS1X15RP8lyCXfUW4wM1l4pYCLC9+8E98gK5sq3aY2jFO9nTNBvacO15abWNlLBIN57
	1McNSLiXs7vbyXNF5NVPedW8hYqPjrCtD8tvgck6CH+/YS/V7CwD/g2mqFhZ2zfvOfGFnHJfHp8
	gPTRKKsmw3P2/mx+8tbXOK40WbC60nzNnomLOgDGWBKUxMjGkliz+t9RLXxA49a5Y7B9kxyGNdR
	8hwDp+L+RdS1+eL1jKwYbNLIzIjTpd949W6aDlfGr325h24SlV4+Jow4rUc9XdwxsiJ3q/iY/qT
	g==
X-Received: by 2002:a05:6102:2416:b0:5db:f553:4ca0 with SMTP id ada2fe7eead31-60a339f920emr1320540137.1.1776055231296;
        Sun, 12 Apr 2026 21:40:31 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-24.dlp.protect.broadcom.com. [144.49.247.24])
        by smtp-relay.gmail.com with ESMTPS id a1e0cc1a2514c-9567ba161fasm172756241.5.2026.04.12.21.40.30
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 12 Apr 2026 21:40:31 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-dy1-f200.google.com with SMTP id 5a478bee46e88-2ca8a374558so41652eec.0
        for <netfilter-devel@vger.kernel.org>; Sun, 12 Apr 2026 21:40:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1776055229; x=1776660029; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=2l7i8vnpUJQTdJaWwY66SR5P0SKGOILNorZy9BBZKRQ=;
        b=Bsl+aEeG4YLqFSpfbtV7Jd9pMFk2JSju6AQGoN4NqSduQqZnCgkIF8Ld5R94KaR51M
         sZC4bVByMRuFyGBgGuFzVzda/YmbojVV8OZcHIi1Rt4g0GOAK5gxZsC4S8UrTTrtYUOW
         nA/q1LToHVseQb6q9tXlIO6+Si3rQ2LsU54pA=
X-Forwarded-Encrypted: i=1; AFNElJ/cjiFn3Z7uQqUqZv2sQ2bec4zNLwruc2ChAHkoH13E8mizFyAuxdHZ5TBKdWWi+hYW6llXQbZPm3Vt0GIiFvw=@vger.kernel.org
X-Received: by 2002:a05:7301:1e84:b0:2cb:de38:c76f with SMTP id 5a478bee46e88-2d5c3f14ed2mr2494761eec.6.1776055228849;
        Sun, 12 Apr 2026 21:40:28 -0700 (PDT)
X-Received: by 2002:a05:7301:1e84:b0:2cb:de38:c76f with SMTP id 5a478bee46e88-2d5c3f14ed2mr2494757eec.6.1776055228195;
        Sun, 12 Apr 2026 21:40:28 -0700 (PDT)
Received: from keerthanak-ph5-dev.. ([192.19.161.250])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2d562db64c4sm14677061eec.27.2026.04.12.21.40.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Apr 2026 21:40:27 -0700 (PDT)
From: Keerthana K <keerthana.kalyanasundaram@broadcom.com>
To: stable@vger.kernel.org,
	gregkh@linuxfoundation.org
Cc: pablo@netfilter.org,
	kadlec@netfilter.org,
	fw@strlen.de,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	ajay.kaher@broadcom.com,
	alexey.makhalov@broadcom.com,
	vamsi-krishna.brahmajosyula@broadcom.com,
	yin.ding@broadcom.com,
	tapas.kundu@broadcom.com,
	Stefano Brivio <sbrivio@redhat.com>,
	Mukul Sikka <mukul.sikka@broadcom.com>,
	Brennan Lamoreaux <brennan.lamoreaux@broadcom.com>,
	Keerthana K <keerthana.kalyanasundaram@broadcom.com>
Subject: [PATCH v5.10] netfilter: nft_set_pipapo: do not rely on ZERO_SIZE_PTR
Date: Mon, 13 Apr 2026 04:33:04 +0000
Message-ID: <20260413043304.3327873-1-keerthana.kalyanasundaram@broadcom.com>
X-Mailer: git-send-email 2.43.7
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e

From: Florian Westphal <fw@strlen.de>

commit 07ace0bbe03b3d8e85869af1dec5e4087b1d57b8 upstream

pipapo relies on kmalloc(0) returning ZERO_SIZE_PTR (i.e., not NULL
but pointer is invalid).

Rework this to not call slab allocator when we'd request a 0-byte
allocation.

Reviewed-by: Stefano Brivio <sbrivio@redhat.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Mukul Sikka <mukul.sikka@broadcom.com>
Signed-off-by: Brennan Lamoreaux <brennan.lamoreaux@broadcom.com>
[Keerthana: In older stable branches (v6.6 and earlier), the allocation logic in
pipapo_clone() still relies on `src->rules` rather than `src->rules_alloc`
(introduced in v6.9 via 9f439bd6ef4f). Consequently, the previously
backported INT_MAX clamping check uses `src->rules`. This patch correctly
moves that `src->rules > (INT_MAX / ...)` check inside the new
`if (src->rules > 0)` block]
Signed-off-by: Keerthana K <keerthana.kalyanasundaram@broadcom.com>
---
 net/netfilter/nft_set_pipapo.c | 21 +++++++++++++++------
 1 file changed, 15 insertions(+), 6 deletions(-)

diff --git a/net/netfilter/nft_set_pipapo.c b/net/netfilter/nft_set_pipapo.c
index a4fdd1587bb3..83606dfde033 100644
--- a/net/netfilter/nft_set_pipapo.c
+++ b/net/netfilter/nft_set_pipapo.c
@@ -524,6 +524,9 @@ static struct nft_pipapo_elem *pipapo_get(const struct net *net,
 	struct nft_pipapo_field *f;
 	int i;
 
+	if (m->bsize_max == 0)
+		return ret;
+
 	res_map = kmalloc_array(m->bsize_max, sizeof(*res_map), GFP_ATOMIC);
 	if (!res_map) {
 		ret = ERR_PTR(-ENOMEM);
@@ -1363,14 +1366,20 @@ static struct nft_pipapo_match *pipapo_clone(struct nft_pipapo_match *old)
 		       src->bsize * sizeof(*dst->lt) *
 		       src->groups * NFT_PIPAPO_BUCKETS(src->bb));
 
-		if (src->rules > (INT_MAX / sizeof(*src->mt)))
-			goto out_mt;
+		if (src->rules > 0) {
+			if (src->rules > (INT_MAX / sizeof(*src->mt)))
+				goto out_mt;
 
-		dst->mt = kvmalloc(src->rules * sizeof(*src->mt), GFP_KERNEL);
-		if (!dst->mt)
-			goto out_mt;
+			dst->mt = kvmalloc_array(src->rules, sizeof(*src->mt),
+						 GFP_KERNEL);
+			if (!dst->mt)
+				goto out_mt;
+
+			memcpy(dst->mt, src->mt, src->rules * sizeof(*src->mt));
+		} else {
+			dst->mt = NULL;
+		}
 
-		memcpy(dst->mt, src->mt, src->rules * sizeof(*src->mt));
 		src++;
 		dst++;
 	}
-- 
2.43.7

