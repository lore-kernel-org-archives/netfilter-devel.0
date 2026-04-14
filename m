Received: from mail-oo1-f97.google.com (mail-oo1-f97.google.com [209.85.161.97])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AC3936E48B
	for <netfilter-devel@vger.kernel.org>; Tue, 14 Apr 2026 06:40:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.97
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776148818; cv=none; b=lN8yKY01RrK/UAi8rpXeNASwNZpHSE6zU2Sgi2WF5VNNfLp3EsJ1orjVWZsNjv1Sd8o6qgS4SPsM8i42A2rh+TyZQ9HggR5foqmJvIcoIn0oR5PRmPEHi+VB+DULVMQldVLGg0iHKFKWv7XNzHEgElFTdjss9MOB2cyNEqZ/g/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776148818; c=relaxed/simple;
	bh=eUByrnPJ2nona1QXhiPKoFAJ4ou5D+Pn4Dg2jpFDt6M=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=PGfsius9L8SsrGUFTNdXtPablRKT2AM2C50zhN2ksykitEjyeHd7Bltm1qFk5rPLe+D4xlqQNPC1CIoawkCqWMrUyuXG2Me24Pk4Xjw9wMranaP53vB4+NNQcPmkMNLhLSzVRZ0637OUOGfPe7pC9oHD3XDsP89BBfAsOIgGaO4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=Ti2EBGoj; arc=none smtp.client-ip=209.85.161.97
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="Ti2EBGoj"
Received: by mail-oo1-f97.google.com with SMTP id 006d021491bc7-66dfeb899f4so139807eaf.1
        for <netfilter-devel@vger.kernel.org>; Mon, 13 Apr 2026 23:40:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776148816; x=1776753616;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:dkim-signature:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2l7i8vnpUJQTdJaWwY66SR5P0SKGOILNorZy9BBZKRQ=;
        b=DoUiVOpcQeRGCatTsBObTjqCEQhV98Sen2lUJTUd3qpqccR6+Rw+nPyYZX9/lri33O
         9Q0RoCnNDJsJFvHLmh5vN+nMV3052/vS1gTJDrfPESTd2J4qyybUjbmPNeK8T+5lLQ56
         Vov5BHvR98mIqxYpEHLDO+bTj465tVfbKozP4hheFa+D3JrJRDdPyoDBvL0NGW/XuHUC
         hHgnabkTO7yMzguGAJ5JX4+N0rY5Ok4h5YORe4SaWfOqvJrDGM3GoFx4HiO9VjLMXeNN
         kYd4Qyg2PqNw3DdlkSLxCgjmmcaB33pa8xop8+mCTqVgx42Wes4iqfb/YuWXfFQrtpLj
         NsDA==
X-Forwarded-Encrypted: i=1; AFNElJ80efjrEsrzzQQsAgT4Gv46NOGcu9Twtj8s4XmOKdhMJxHdy1shKshwHTPYPxxcHbV3ZKDL/MLH5nuHLLJ8OM8=@vger.kernel.org
X-Gm-Message-State: AOJu0YwZkwzavqUCVu26YPWCLcsFBUNMvglPpbJOux/9QE5c7OtoXzNl
	qsDSYTqIS3MoqYf0HY2dIxrL3FnJi2JPN1HXl6WzIWtLI58uCA/dYeFehO9F25x0tzSq503RAoE
	rjM1dynucrl7eSPIYNqy/suWD5MrcC84t2Z2E/xV+P3V1Se0Eylo7GZ/LA8aL6o1/24+bNgUM62
	HQSWg7MgvwPF6gLejxrlv4Vb3YOb0hxZb4xuTugrnT+Q/eEubVjz4j/qvrCMWUqeNtLKJeWzHLn
	2JSI7es7o2ic/6CiCb2S3rdQ5lJdPoYdouYHTcM5pU=
X-Gm-Gg: AeBDieuyC/QP4F6HN4Z2VZ71V0MpMjuOEV12tLD/hwQ42ccCI2seCBLuGzYwK96GLTr
	L/HnN5OFqWfEVDNXrdTI909JEpr1S+lbBr6OdA/EM7zeTYAgWiM24YMEMWEyZMPxGhkzasrHmp8
	pO1W6EyoOODRGz3ayUimkx2ukg2doRRJJA3soJu1J+nfd3AGUp7IZJyxbgSsH5LD6W09weSUdq8
	MbUSYKC1ZG2GcXfRzaZT6Jf5B1tjiyuFWTvx1qtNgv+eJP15/LRqP19Mr/SELDiU3RRXcpmWPb6
	lEDpRMI+Gz4G2R8gUYPX8InLkSvVnJAn4on5L278PxHY/h/bSpRGxQlQatM/VthqyF7inCOwjPc
	lI5eWSbvl2hvJMTRWIOi0oKmR9WO5yNTwBbUhMzC/AL4LbIGJVuw4m/DwOxSj023P+U9a1WE7bz
	b8asFi0VYF9XbIQhlxISncAEdPorUp+2p0kSB8839rtrIS/UrJqAuGE0l62Im91dEhZ55xOjZj1
	1m9VgL8MZKp
X-Received: by 2002:a05:6820:a284:10b0:682:ad5:f1d0 with SMTP id 006d021491bc7-68c291aac2bmr3392603eaf.2.1776148816286;
        Mon, 13 Apr 2026 23:40:16 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-24.dlp.protect.broadcom.com. [144.49.247.24])
        by smtp-relay.gmail.com with ESMTPS id 006d021491bc7-68bc84df866sm878004eaf.12.2026.04.13.23.40.15
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 13 Apr 2026 23:40:16 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-qk1-f198.google.com with SMTP id af79cd13be357-8cfd003bfe2so93340685a.0
        for <netfilter-devel@vger.kernel.org>; Mon, 13 Apr 2026 23:40:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1776148814; x=1776753614; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=2l7i8vnpUJQTdJaWwY66SR5P0SKGOILNorZy9BBZKRQ=;
        b=Ti2EBGojhCEoCjHxHmHkv1o2ejoAfa6151Jh1Nh6c07CljOglc3Gg6ilw9iYl3JpGB
         MyCp2ORQ054YiPpwIYlIglO58Sqv24PC0plyxkj0v9j+V8Xu5h4yyx0afm3nrrgikHhv
         YJOtXhgylpAmOE1lrjxoGAuNW8CdR6HZ2Z9N4=
X-Forwarded-Encrypted: i=1; AFNElJ9MxWlmqIl/zB42EJzYP8TogFKFCvF8/cnvfroTpUKKY45jeZe8qR6238SiFA1AgeWFfKNQXk4g7AOvY9LLDrI=@vger.kernel.org
X-Received: by 2002:a05:620a:44d1:b0:8cf:c757:f1e8 with SMTP id af79cd13be357-8ddec1f0d27mr1636847185a.7.1776148814389;
        Mon, 13 Apr 2026 23:40:14 -0700 (PDT)
X-Received: by 2002:a05:620a:44d1:b0:8cf:c757:f1e8 with SMTP id af79cd13be357-8ddec1f0d27mr1636845685a.7.1776148813891;
        Mon, 13 Apr 2026 23:40:13 -0700 (PDT)
Received: from keerthanak-ph5-dev.. ([192.19.161.250])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8aca5222c8esm71566416d6.28.2026.04.13.23.40.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Apr 2026 23:40:13 -0700 (PDT)
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
Date: Tue, 14 Apr 2026 06:32:43 +0000
Message-ID: <20260414063243.4062926-1-keerthana.kalyanasundaram@broadcom.com>
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

