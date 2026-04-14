Received: from mail-pj1-f98.google.com (mail-pj1-f98.google.com [209.85.216.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AD7536EA86
	for <netfilter-devel@vger.kernel.org>; Tue, 14 Apr 2026 06:39:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776148743; cv=none; b=cArj9GvMER+8GPNnixKSUHjTD1qhae2pTo+uWvaDK3DsSkPLI/yTx9hL2lRueSwD2jW9Bxlxl7tpsF9uedH720Oh2YssveJ0viOmJyw0K/Czedo4DaQTmS+M9iIYgyQspiXV8fbLWxqPhbwnU6B8w5ixx5FoSKN0b531o2JCQMo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776148743; c=relaxed/simple;
	bh=5ww9EE9Omd+lxTQKlJOWj/4hV3jbfueaHdGT5uwPtjc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=r1uRTkEissngBg9+yrQRTpolmI2v7231nV1/wuF4jolGoGd+qYRX0iTKp3Eqmfz/y4tH0BfFUrO3lCuzr+09KYkcxnH02RKrvHoz83XRrlNjuaVts4QCEFyUVb7aQcGDYujivnA2oXRRa8DVmWKHFGZ2uPXalSdxuZAiuRZYJ2U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=Eu6URQhC; arc=none smtp.client-ip=209.85.216.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="Eu6URQhC"
Received: by mail-pj1-f98.google.com with SMTP id 98e67ed59e1d1-35e57611113so389887a91.0
        for <netfilter-devel@vger.kernel.org>; Mon, 13 Apr 2026 23:39:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776148742; x=1776753542;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:dkim-signature:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GYL2a3cReHZZ5YSJ0wmm3zCuDsPFAtU2gKvk7jCr2V0=;
        b=hRTJgFZqohM8Q9pbbh2Poybag1TUHJy0aWXXE/e1Sk5Bg6t/gKk8hxClB1P9uzh0Jv
         lkeDk6WzfD68++X9Jg01fyaoSnJk+jIB++oMDWxLm+oR9Whk1WXoTK5pXH7XYwOPsq8L
         sgJuHeqrMAjBQlnQMX5h4nf2q7XA5oySeZuRUCR3m3ruWHdIR+A7pNWbHDwfNi815NZy
         +WJk6fjHABz+Fz8jNRimY2YcWNnjjJuAAeXllH49LjALpYvRucYztLsqKOKZ5okYaysp
         ZX4xZ7AtewTK3+RzwdPxSE/EMLVYFuvwwnkg75sp9yH/t1pIYEwbWnii0wRHYWbB6xhD
         956w==
X-Forwarded-Encrypted: i=1; AFNElJ/8+9evsC67LINDkVyGhg+DUW/quRa/K4SmzEBOZYEhTL1FIlelg5IYT7qYAWEp7czfQ5/gLwqHTumycgE5l8Y=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx2d6JOW4ZK5UGW8duU2HYSQMU82kzusx6cwWgv96fnaT5x3KSg
	bqshqUM+x0gm8jx69uAnJbM1pzkA6j0gtz8UEtNKSp/oLh8m+0gvr5U9UXnZeUxeqNnWEZFE1uK
	IhBvJpp9mHOYwO9ThFl0KaR8nyC7qBaOkIeFOCdOsjY9i/ZTejIDxggUocNhgXc9AhP7T13b7gd
	DxYnIrGZF86Cg9oLN95B0AJsLujplAJZJvniWFN8F2ZHVbhQeGwraDPSPX5l3k+rpD8TfLVOeWN
	vbZsrQToTQQjq9UKOcrxk4EJMu6Or2fnfQDxP//NMQ=
X-Gm-Gg: AeBDiev4P/JXvtHjTjOdNDLacJ/a30WNjkRrIWebsKVNhAba6s+zN7PqeJS0383SXJp
	RMuV0qFhffTr3aqXzv6nXrjjJ2y9GavCsFRmnDdYdccnBdOPGghaeC0OWKoYOnhMJATdoiI3rGa
	6E9eyucvUWppSryD1F1O+MXXLTDMWm21papKoq0FAn6mcQdsYZzEdaXlbA17LMk+TyOFgp4JNZv
	eFEYu3JJnHsE2G7b6FaRGhottGdrxBKB/4Poupliijgf7r5N9M7DXr4aI1zlkFv3qySWLB6E34a
	G+vKljfub0Fu2D1RH9xU1mDec9O+FL5tA9IRnsNt/WH2BSnWQbai/iP9Pisav9xUkaAwvYpHF/S
	GCAWmmgtu1Tm35k3eOhvkh9RpPtVYF+Ml6J3wEKNvejAUvypg8z2If8xQvg1YZVDcoEZU8NUwht
	DNAdrr6s38DZDochai9pl9NgUPHbTJjHDiJaZd7GwUEQqwwmeEc8sBHorV0yVygt8lDLEu09BHS
	0u4cLGwFMrg
X-Received: by 2002:a17:90b:4b8d:b0:35b:94db:fdaf with SMTP id 98e67ed59e1d1-35e44297be3mr9644057a91.4.1776148741647;
        Mon, 13 Apr 2026 23:39:01 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-15.dlp.protect.broadcom.com. [144.49.247.15])
        by smtp-relay.gmail.com with ESMTPS id 98e67ed59e1d1-35fc6efeba7sm93170a91.6.2026.04.13.23.39.01
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 13 Apr 2026 23:39:01 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-dl1-f70.google.com with SMTP id a92af1059eb24-1273683a5dcso1000923c88.1
        for <netfilter-devel@vger.kernel.org>; Mon, 13 Apr 2026 23:39:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1776148740; x=1776753540; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=GYL2a3cReHZZ5YSJ0wmm3zCuDsPFAtU2gKvk7jCr2V0=;
        b=Eu6URQhC3iV+FnxPjArmO6tA160eauufzD4dJrNcAGsjIEKmhoPe+M155F533tudRM
         aBOuuIHfTDbnk8XaO/rMhC9jeTdykKu+Ucy+WjyTaeH0N2oaKJTwr+K3CmD26fAPv1cB
         AXqdps3MPyjfegbB4WX8ZDl9c+6tZqCxukoAA=
X-Forwarded-Encrypted: i=1; AFNElJ+zIKFSAK+8Z4EoEPrRyDoSyHFC4Yokpsn55XQNnvqmu/iTt3GskpmC7v6m0Guwkpm4xLxZ3vgyQnOyJpENZgQ=@vger.kernel.org
X-Received: by 2002:a05:693c:300d:b0:2bd:d8e6:90a0 with SMTP id 5a478bee46e88-2d5c39f6544mr3735045eec.3.1776148739852;
        Mon, 13 Apr 2026 23:38:59 -0700 (PDT)
X-Received: by 2002:a05:693c:300d:b0:2bd:d8e6:90a0 with SMTP id 5a478bee46e88-2d5c39f6544mr3735024eec.3.1776148739232;
        Mon, 13 Apr 2026 23:38:59 -0700 (PDT)
Received: from keerthanak-ph5-dev.. ([192.19.161.250])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2d5630ac330sm19396261eec.29.2026.04.13.23.38.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Apr 2026 23:38:58 -0700 (PDT)
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
Subject: [PATCH v2 v5.15-v6.1] netfilter: nft_set_pipapo: do not rely on ZERO_SIZE_PTR
Date: Tue, 14 Apr 2026 06:31:31 +0000
Message-ID: <20260414063131.4054234-1-keerthana.kalyanasundaram@broadcom.com>
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
Changes in v2:
- Fixed patch apply failure

v1: https://lore.kernel.org/all/20260413043247.3327855-1-keerthana.kalyanasundaram@broadcom.com/

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
 
-		dst->mt = kvmalloc(src->rules * sizeof(*src->mt), GFP_KERNEL);
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

