Received: from mail-lj1-f170.google.com (mail-lj1-f170.google.com [209.85.208.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A2A21E98E8;
	Thu, 30 Jan 2025 14:21:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738246876; cv=none; b=QmojCxpy9cmWQKahGnuWF0NztIWW4H001BhWu/BCOwK34FLICy5gGeBAf++Il2N+XvUH8CzCreowMUpbUpFS9HPQ/PREFVL2pHLk3x3rogjc5XNN6fWwRq0sR3/MstzHdSkIJ+xf72RjZIZoxuOf/BSVSlkz6nNvw0SUjtbgd5M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738246876; c=relaxed/simple;
	bh=lkIu+bK/7i65naCB7GW3Dr/1YmtGp4aS+gL+NfU6sw8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=NH2il46E8NqcSBLen35i3eKUGj9oit5OlWZRjw68C8W9EFwFDa+hs/1bYXWq9GC9VgFsPCR0zm/5TtGgW6bcHGBGQLoO340vcJCC2c+uQfl5r4Eh2j0UnH/zgKKbeSMPKzqbNf4CtUJEpamimW0Sa55/H5WPniEHVnmz7Y9UuQQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lX58kytE; arc=none smtp.client-ip=209.85.208.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lX58kytE"
Received: by mail-lj1-f170.google.com with SMTP id 38308e7fff4ca-3043e84c687so7133841fa.1;
        Thu, 30 Jan 2025 06:21:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1738246872; x=1738851672; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=JW/dGS/QQlGhVIErJx0J3DWxHQJv8GSH4QvW2RtihtY=;
        b=lX58kytEQk6yeG9HDx30Sx1b/yloCJg12Fpxl+Xk69PP3WGq/rBPdAHV1jUFnO1cXn
         UJyLylMsRg/02anrxEjcnFLZOXnFbslmxRvqlWcIYaKz46u1Cs6cZUda2FaXhhBB8n4A
         +4ro38lt4iJImYGWSBMXvShZevazwkUVTuQmcyXJaB0EkT4Sk0/0F3mknRpso8UFxJap
         EDsO0w4frQgpLeUJzICo/7mJGNgX/YxWU3H7dLO8LJF9Sc2Ih+c2VlC/lW+uGQ95OO5k
         y+VZZoiPQuFDaRJd6W3eDEvN+FPSzasGEpDbbrgXcbaJk6U/WMsR7LYiMBiPIeqtP0HT
         0Rgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738246872; x=1738851672;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=JW/dGS/QQlGhVIErJx0J3DWxHQJv8GSH4QvW2RtihtY=;
        b=ZFfNMmOs88DdZ0CgZFajE6sZY0aq72RG8RT82V3CLItx8WOz1HqvjneyI4fN6QRYaD
         LOgD9zoCa75GxYlhGGCD4wfLqEoDI2qgihMIzU0TeLhNYa5q+MJ8ILewEM5cksig2V6+
         GJ7GPDpJCj2guvxUcwFudjuFUNHqewZ4KxhNmNtFBSuEjU+iUfOxuRIMrr+LtSje0zyY
         B0Hu0rjwftHBiYTHH1W2EsNi7O9avD+P/ejynsHR/YPrpe3CVyZbwiN1TZen42gG6pud
         ELoRig0Ny6ziYezuuaany/vpWJOmgJqeJkYooYaYgr7hac2F2fVsyAAidsmV/vRw6+fI
         cJFA==
X-Forwarded-Encrypted: i=1; AJvYcCWQzEHUMPmIbMLETBXgAXm1mTNbT/BjZyYxjcW7YXxzhiSKzpRJayPNQwRSM+bg0IoD5kI/oNE=@vger.kernel.org, AJvYcCWaBkOYrvAlnl1LyrKRAU1/+BvTnI/nPHpZJvveSzfvKVstqFVzJTIQy8/90i8domCzPMrrufYeNOuH3ql4dDQF@vger.kernel.org
X-Gm-Message-State: AOJu0Yys93z/6d/KdKhvAVt/bqbdeb91vAhmUXgm5DIqpZU61A6Lzx30
	j0ggqQasQena148q5vK/0pX09QZ6f90vit7JCDtu4W54RnMfQNIc
X-Gm-Gg: ASbGncsdKjA8GufA+2Pr5wdBFGJ6tdLKy2Ac/s+jk1cWd+YxEzz0GRIhZD018L5jTUb
	6FEPA0a/3esAHoQr1uxME0gW6P3jtXda82UKeYYGFO5rpC2Y6rt5cFm9CwdvL3sOiujM9h5C9ts
	mVuCY+iJAEw2IPxG37iRQK7LQdGHtZJMpksgowqMxgaHj1i6mLXUC4V4l2o3yGHtbpbVnPDgYFD
	2Kf81LmCzrWQrS8d++gdcFq2Wa35ITSZc95mQdlKk69ImTfsruStGMFrPNaq6KD3AjUWlsWH/kS
	SWvzp22BUG3d+V/yjWGlonts4nBF
X-Google-Smtp-Source: AGHT+IFVselTUFg+lVbhMNmY49WFj6tGrORd5gdc60mJaL7QKFOza4XBghy2bAKDKd3ZIB3ee72vLA==
X-Received: by 2002:a05:651c:2115:b0:302:3a28:76cf with SMTP id 38308e7fff4ca-307968e725emr34869531fa.25.1738246872213;
        Thu, 30 Jan 2025 06:21:12 -0800 (PST)
Received: from hydra-ppc64.kdaintranet ([83.217.203.236])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-307a30886ecsm2086761fa.30.2025.01.30.06.21.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Jan 2025 06:21:11 -0800 (PST)
From: Denis Kirjanov <kirjanov@gmail.com>
To: pablo@netfilter.org,
	kadlec@netfilter.org
Cc: davem@davemloft.net,
	netfilter-devel@vger.kernel.org,
	netdev@vger.kernel.org,
	Denis Kirjanov <kirjanov@gmail.com>
Subject: [PATCH nf-next] netfilter: ip6_tables: replace the loop with xt_entry_foreach
Date: Thu, 30 Jan 2025 09:20:37 -0500
Message-ID: <20250130142037.1945-1-kirjanov@gmail.com>
X-Mailer: git-send-email 2.47.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

We already have an iterator in the form of
xt_entry_foreach macro.

Signed-off-by: Denis Kirjanov <kirjanov@gmail.com>
---
 net/ipv6/netfilter/ip6_tables.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/net/ipv6/netfilter/ip6_tables.c b/net/ipv6/netfilter/ip6_tables.c
index 7d5602950ae7..84effcf4ff98 100644
--- a/net/ipv6/netfilter/ip6_tables.c
+++ b/net/ipv6/netfilter/ip6_tables.c
@@ -840,14 +840,12 @@ copy_entries_to_user(unsigned int total_size,
 
 	loc_cpu_entry = private->entries;
 
-	/* FIXME: use iterator macros --RR */
-	/* ... then go back and fix counters and names */
-	for (off = 0, num = 0; off < total_size; off += e->next_offset, num++){
+	num = 0;
+	xt_entry_foreach(e, loc_cpu_entry, total_size) {
 		unsigned int i;
 		const struct xt_entry_match *m;
 		const struct xt_entry_target *t;
 
-		e = loc_cpu_entry + off;
 		if (copy_to_user(userptr + off, e, sizeof(*e))) {
 			ret = -EFAULT;
 			goto free_counters;
-- 
2.47.2

