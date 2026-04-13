Received: from mail-ot1-f98.google.com (mail-ot1-f98.google.com [209.85.210.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEF7B38237C
	for <netfilter-devel@vger.kernel.org>; Mon, 13 Apr 2026 04:40:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776055217; cv=none; b=tHnZyzSAw7a+UfBp9d9ZXELyWjha8Ihf04fk4KRHyeT+IeRTEBT7R4uTEufTYUnlFc2FoeAW1953P3IQhKgw52GVMhtjBLn3OnkJsZPHZgVzo+gNft/XPM7InWM1wn/fTvMiRbmUjrx6/7h3Gfzt4RLhJi6SNdJ8rvdYi+iA8Zc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776055217; c=relaxed/simple;
	bh=32i2CGMRFLkk71ry4kqEvU3i5K2ngl/kHrRJQNNg15s=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ONPQsRTctWK07su7B7F33g4T1XzARwH95p5R/5sn6k+ZZs9kNHBWOK7fcgP/JxiReDbx7UtjzYIYjAVPm4Q8K777njD0jw/vZ8u6OI7xrV1MoOufu/C1Qt4IJx1LcmH+CEpxxnIAxAsKhbK04OXIAFKsIBtcsCMT29TXdy/7qYE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=SO588cYn; arc=none smtp.client-ip=209.85.210.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="SO588cYn"
Received: by mail-ot1-f98.google.com with SMTP id 46e09a7af769-7d7e878a7a9so530817a34.0
        for <netfilter-devel@vger.kernel.org>; Sun, 12 Apr 2026 21:40:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776055215; x=1776660015;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:dkim-signature:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yEhC8dL15vha3u2nezC8YntUF4AHPl/GJlnlwSrjKaM=;
        b=K2I4cGP89ADy6N4uTrzHH/4crbIIMRV84yzVguwlGpoABWYj/s8AMxTQ9sVgFvSJwE
         exud/ug/rysz8AKedew9nmT6uNRqoX3ZR53voGQP+YGpihPsVOPf+g3jYoM4NYeckXzx
         TstxomL1k6PIOdYGZdFtgvHW85ih0WFWOA3ej6+aNDroVGAlgT5QMQVUsnJtTF2hppXT
         8OxKGCye7pYmoge8zEYlQglPQoRUcjsOpNV2GJmDzBistCOmBRl2VQk3bpJnYuVK774+
         YV9FvyudFsj5IaN/HMwciWh2etpWAYZdgOY28UCbvadTPzfuw4OMfnXRI53BVBvCvuWV
         2Xkg==
X-Forwarded-Encrypted: i=1; AJvYcCVS8AA0pPrWTIQfyKiLnKWOGTXV+GVINsodO5nPxLVCgYkakBhDm9urGFlpvkTxcImHb3I8TywinhpDIWYKar8=@vger.kernel.org
X-Gm-Message-State: AOJu0YwHgxEQ6nVwcCG11z5KYRPWqBh7vqzAEEsFElA4a82EInZ/VSHr
	kXgDYmzOObYc9JNoe+yise0NveH+uIqVpL/5BQdOyIdCNVHFVEgkma9QXZikCH5drD267Ud8PEW
	VNger8M27X7f327eJ+wVcKbAMxWC1KSVbQVwHT9PhF42h0R2e0488rwuL9anJkUYIjeWjAQeBIm
	acY/H+r2bi0pmgj8EMrM5Zwtj7ek36jRpENlfPMnsMD7K3dFX3GfACUQTcDonUhDGS9J3St4xe3
	7eDGyp82nbGaODqgnxdbWwuMY16gtFzBcEDEug5qbE=
X-Gm-Gg: AeBDieuP5adS47NHf/NmGvNoa7ypYgR7y32Aalpf+/pIYPWSU+5XkI1gUSdbBSx7t62
	gQC12IeQqP/NQMdOZygAKNc1Bj7XHRz2AIsNFFxC2/5QEWc0b5tYxgCb4H7u2vC/9ChwrULWl0E
	3ujuUr33DoomGA9Ru8564r8b57U6IMSYMpATbhyr+e2C7nsSgI6CPf7iVQx0vJPuZmHcHWgST+p
	q02S7zj/05LsFBWfRTt+01HFCUjQJ6RtWT/EkJWI/VnyjvIg5uaPegcUTkxY8OMnrcBzCnSwKp2
	sGLN05Ay/Yigfg1d1GrN5uH6ggG2GBN94fMA280ymJfxJ+eEoKs1phTcpJJse53R0M2E4O2Kq6x
	+t9cmrC7xwJBVZxLQ0P4pc1iNKxOgYeUsY5tDSK0eI5haA8mTuVouLLt3B/rlvfSSnCmccQLdSq
	cOD+jWSAV4pSi8lCYekdnTtDbx/U1F8eW0Yj4pUZGodfFI6+MVj0GPHny59ib/DV76atYX+uS8+
	A==
X-Received: by 2002:a05:6830:44a4:b0:7db:fe64:9464 with SMTP id 46e09a7af769-7dc27da28a5mr5825785a34.3.1776055214797;
        Sun, 12 Apr 2026 21:40:14 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-15.dlp.protect.broadcom.com. [144.49.247.15])
        by smtp-relay.gmail.com with ESMTPS id 586e51a60fabf-423ddd32ab3sm1299630fac.16.2026.04.12.21.40.13
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 12 Apr 2026 21:40:14 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-qv1-f70.google.com with SMTP id 6a1803df08f44-8a5bf7ee420so13279756d6.0
        for <netfilter-devel@vger.kernel.org>; Sun, 12 Apr 2026 21:40:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1776055212; x=1776660012; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=yEhC8dL15vha3u2nezC8YntUF4AHPl/GJlnlwSrjKaM=;
        b=SO588cYnpMSCK8ejZkVQ8h2BFBcwM1VVp/9ajY/xxmPZ+Ir/4sPgpSVTN8K24cZSwf
         ZPcgEJZ8NBlyX2z9e6sYnGQ6Bu2poj9Pfuo6Rk4i2sdaDSXn+K/FK90LQq2bst/JlWR7
         sjFL0ZA9gV8Eb99crGO11wK0VmQVqPiuWlerQ=
X-Forwarded-Encrypted: i=1; AFNElJ+DYqMFnjGcj362jNN7mfx1aCAkSAePI+MTlxyvr0HOsWcn2cz1gPYKcdNVutfqwykcZMLWRo8OXxwz7RNIKUE=@vger.kernel.org
X-Received: by 2002:a05:6214:2424:b0:89c:5159:ea52 with SMTP id 6a1803df08f44-8ac8627aaacmr140468936d6.7.1776055212429;
        Sun, 12 Apr 2026 21:40:12 -0700 (PDT)
X-Received: by 2002:a05:6214:2424:b0:89c:5159:ea52 with SMTP id 6a1803df08f44-8ac8627aaacmr140468666d6.7.1776055211924;
        Sun, 12 Apr 2026 21:40:11 -0700 (PDT)
Received: from keerthanak-ph5-dev.. ([192.19.161.250])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8aca5222c8esm38017646d6.28.2026.04.12.21.40.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Apr 2026 21:40:11 -0700 (PDT)
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
Subject: [PATCH v5.15-v6.1] netfilter: nft_set_pipapo: do not rely on ZERO_SIZE_PTR
Date: Mon, 13 Apr 2026 04:32:47 +0000
Message-ID: <20260413043247.3327855-1-keerthana.kalyanasundaram@broadcom.com>
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
 net/netfilter/nft_set_pipapo.c | 20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

diff --git a/net/netfilter/nft_set_pipapo.c b/net/netfilter/nft_set_pipapo.c
index 863162c82330..2072c89a467d 100644
--- a/net/netfilter/nft_set_pipapo.c
+++ b/net/netfilter/nft_set_pipapo.c
@@ -525,6 +525,8 @@ static struct nft_pipapo_elem *pipapo_get(const struct net *net,
 	int i;
 
 	m = priv->clone;
+	if (m->bsize_max == 0)
+		return ret;
 
 	res_map = kmalloc_array(m->bsize_max, sizeof(*res_map), GFP_ATOMIC);
 	if (!res_map) {
@@ -1365,14 +1367,20 @@ static struct nft_pipapo_match *pipapo_clone(struct nft_pipapo_match *old)
 		       src->bsize * sizeof(*dst->lt) *
 		       src->groups * NFT_PIPAPO_BUCKETS(src->bb));
 
-		if (src->rules > (INT_MAX / sizeof(*src->mt)))
-			goto out_mt;
+		if (src->rules > 0) {
+			if (src->rules > (INT_MAX / sizeof(*src->mt)))
+				goto out_mt;
+
+			dst->mt = kvmalloc_array(src->rules, sizeof(*src->mt),
+						 GFP_KERNEL);
+			if (!dst->mt)
+				goto out_mt;
 
-		dst->mt = kvmalloc(src->rules * sizeof(*src->mt), GFP_KERNEL_ACCOUNT);
-		if (!dst->mt)
-			goto out_mt;
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

