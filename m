Received: from mail-dl1-f98.google.com (mail-dl1-f98.google.com [74.125.82.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61057344DB8
	for <netfilter-devel@vger.kernel.org>; Mon, 13 Apr 2026 04:39:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776055193; cv=none; b=k5ujNAFeW3Yqt+5RcD9Q07xVD13E5HpZO/JD9+88wKv/zQyxr2QupGzpSUrTANLcakB8U/35CzsVx8eKzvYi5erkImDrg35Ow18iO3HAv69wcojXHodhZBn1hATsapzxu8d+iLmEMxmq0cm+qDQ8XkZyVSyOgC9TzIdZUjzxoIc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776055193; c=relaxed/simple;
	bh=wtSSTcWRwe559pZ1gDdmuMpz8Bc8ySi6j0tYNMZuVwg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Ycf0BAHX7j5YP0eMehGZ0wRZ0TwJHKYAZKAS2ZJctCRhMLuYkU6l1es9FlwxwD7XR7ioP3/N1OoQ3B/3SFWyXklGoEs2krZUm4IlEWL3BhoNWZFpmfltiY6/5tGWPeui0dRCZUZGPAvyNxPYcNwttXPN3QA/LQrrF3gOn93dses=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=HpSI2RVO; arc=none smtp.client-ip=74.125.82.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="HpSI2RVO"
Received: by mail-dl1-f98.google.com with SMTP id a92af1059eb24-12c22b9bdabso215174c88.2
        for <netfilter-devel@vger.kernel.org>; Sun, 12 Apr 2026 21:39:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776055191; x=1776659991;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:dkim-signature:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9qLamvoygs8XdLleM+az9cX6DHqELe8TmHOQBddVvD8=;
        b=gtsFlvcxEAtI9BU/ySsK7YCDkU1FbmRafcpnkMfqW8fdal80gvVx66SakB5L5pm1U/
         BOQ9tG58+YafExo9iXa2VbByhaCzujMk4ieW2Ru/EczFMaG/zKS4NTu31JeBXs6ObORz
         ulw4ZOj6g0xTv1XqgG6Vm/Sa9x4xQ4QxYhFECCvLqgerUGdolL5lSQye9ofj6qGWu5Gk
         ywkS5AWQrVwWS4tCBZQSmG5KEQ/DDyIweJF9jDgxIcXhMbuxxmwqBhybUXgQOBS/v8Ru
         os3uqfmKV9q0aCUHfqFRv3/zLzGrPqWvZUXqdVVlee1Bct8HiG0ORPfCWcW5lvrMPdqV
         k8rA==
X-Forwarded-Encrypted: i=1; AJvYcCVeogqmVzHsT3OZlSwo8tchjVD9i8gO6ezExcXJfSgKZt3R1RQ4MpC3X3wf6lkQM7N2RJPDRE7YU6CB7gZ1mCs=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy64LzTRu9sxpQwFCvUTafse9GHZ0VC9C+4QNOxtxpxrHAehU5g
	GzNX/9Ata1L+rfMmC2qX0s68Lc5wHliYDnmuJQpMLZ3kfmCdWb30v3l7ZYp1KbqmfQeMK8LrFse
	OM3niZDyt3RzgmnbToufZwLmBfFeB+2ebSZPd2bWdUxl12LqU5NQB8IVX+1R0ro7+++3pC+2sUs
	TRro6KMz8yJ9j79DKx3Z0W2GmN2aEauM569UqcGKXMvw72ppx9AONPlSg5fLsGTKWg+OkjNNbbw
	sQ/z87l7nG6hETSgPh8YQLUt5if+3M/JQamLrX9QVs=
X-Gm-Gg: AeBDiesI+enSJAWJXjmkmUzF+teyFGWq47hbEpKtTC4HUfKaDiotyLkiyN/NcCEgNw9
	RxESxIXJmnLyOTQXwHgY8HVCChJI7jNDTpbBZmn5Yuf+SzDZsLBCj88lldzB0OE4ubEmoFBGQXU
	bfiYxm0zhkdWuOTRPHYR6OEe7fOvWfo/kAGcqWJWgMEphhbNMT/hFC3SFF+1Ljj3GTgQnWed42M
	4Zz3DERbBzD3gcgI5XG/rT+7TL0zpzuEoxxoJWMfXukHWg7HAXDBJMkgSDeyEgLfqxa6HoDS17K
	xR0z/Og7K9wkkCuSyb97G0LwkdsSNfwbxmEjHSpl//+IbxOGAHdDWXhw46d/+JhdbxeP7QpdoEB
	I6LfWKYeXStWfHxthqsp+ouxvvq6mU5KZrZAnoLP68GR0eNHfrNLqeGW4TgwLj0Re7Lzbxuvnqb
	iWK4A+A1Y1pJ9LJwOZFATlk7dv+2TUpXRtTLSh8IGD7sePmcJ/w0FdmgmlgrJXbXGbzKeiVQtSH
	A==
X-Received: by 2002:a05:7022:672b:b0:119:e56b:46b6 with SMTP id a92af1059eb24-12c34dbed15mr2575681c88.0.1776055191120;
        Sun, 12 Apr 2026 21:39:51 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-24.dlp.protect.broadcom.com. [144.49.247.24])
        by smtp-relay.gmail.com with ESMTPS id a92af1059eb24-12c3434ec0asm287754c88.0.2026.04.12.21.39.50
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 12 Apr 2026 21:39:51 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-qt1-f200.google.com with SMTP id d75a77b69052e-50d7128e038so9780861cf.2
        for <netfilter-devel@vger.kernel.org>; Sun, 12 Apr 2026 21:39:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1776055190; x=1776659990; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=9qLamvoygs8XdLleM+az9cX6DHqELe8TmHOQBddVvD8=;
        b=HpSI2RVOGwNnCY0VhVy7LD9oFYUJyBdHxuVeVw3djJOilW/R2fsFD2cFr+pqsg+/uX
         zNkFFt3Lis3oRUqevrv02ssMtrQLNl2Gpd07xwMMD+OfKUB5Lp8KXMmknDbRPseZgSab
         6BOFACv3iZ98WfiG9WgIP+7KsPngAYBVk2jcI=
X-Forwarded-Encrypted: i=1; AFNElJ/dQ4pNrzAP8RK9JMIjC7nVCKb5woaq2D4RJzwV/kO11s9iPteFSfBQ2g4Yi+H7wrd8XsQFPvqHwsAyI3c2XCk=@vger.kernel.org
X-Received: by 2002:a05:6214:258a:b0:8ac:b300:c558 with SMTP id 6a1803df08f44-8acb300c627mr10722556d6.2.1776055189864;
        Sun, 12 Apr 2026 21:39:49 -0700 (PDT)
X-Received: by 2002:a05:6214:258a:b0:8ac:b300:c558 with SMTP id 6a1803df08f44-8acb300c627mr10722376d6.2.1776055189373;
        Sun, 12 Apr 2026 21:39:49 -0700 (PDT)
Received: from keerthanak-ph5-dev.. ([192.19.161.250])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8ac84cf55b7sm85742136d6.45.2026.04.12.21.39.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Apr 2026 21:39:48 -0700 (PDT)
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
Subject: [PATCH v6.6] netfilter: nft_set_pipapo: do not rely on ZERO_SIZE_PTR
Date: Mon, 13 Apr 2026 04:32:23 +0000
Message-ID: <20260413043223.3327827-1-keerthana.kalyanasundaram@broadcom.com>
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
index c3ada6798d4a..98cdeb9fa210 100644
--- a/net/netfilter/nft_set_pipapo.c
+++ b/net/netfilter/nft_set_pipapo.c
@@ -525,6 +525,8 @@ static struct nft_pipapo_elem *pipapo_get(const struct net *net,
 	int i;
 
 	m = priv->clone;
+	if (m->bsize_max == 0)
+		return ret;
 
 	res_map = kmalloc_array(m->bsize_max, sizeof(*res_map), GFP_ATOMIC);
 	if (!res_map) {
@@ -1394,14 +1396,20 @@ static struct nft_pipapo_match *pipapo_clone(struct nft_pipapo_match *old)
 		       src->bsize * sizeof(*dst->lt) *
 		       src->groups * NFT_PIPAPO_BUCKETS(src->bb));
 
-		if (src->rules > (INT_MAX / sizeof(*src->mt)))
-			goto out_mt;
+		if (src->rules > 0) {
+			if (src->rules > (INT_MAX / sizeof(*src->mt)))
+				goto out_mt;
 
-		dst->mt = kvmalloc(src->rules * sizeof(*src->mt), GFP_KERNEL_ACCOUNT);
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

