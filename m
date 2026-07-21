Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A596C356756
	for <netfilter-devel@vger.kernel.org>; Tue, 21 Jul 2026 07:46:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784619997; cv=none; b=IsvcIEEf3VQcsWKjotfpM+gTEPNCvB5QgpxgJy1YKDi44X+iHjqf+qhG5ojObWMCTYZfalQuNlnA5rJWy73LwkKPcoEyeilrRnAEPMuKYVpf0tSzEmDDzcRqP/SYSjTgc4cBBtoFVKGUBPbnKoafhCmw5i4EPAq7GX3Fj/RXPw4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784619997; c=relaxed/simple;
	bh=Xh5pZArqkpUPwbdC3HrsP43ayVdjsn/KE1TOqfsmuiA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ITGOgBQo9lulXkq3IPPQ6VmVDb702Xn1KkisQ52S5KhNku+jwz7CbHvNHnLS6J5ZcSDkDicDbdp38TO8zmIw96FXi2Owtq/uTjjVuNpVPNyOFK9lFy3UQ9o5i3CA96+I5oWOl9pXj8ThVbMP+/gfy5eiM0F3DtzX2pVrbKGZS0o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ruuyBQV5; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ruuyBQV5"
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-495590ba856so18632875e9.2
        for <netfilter-devel@vger.kernel.org>; Tue, 21 Jul 2026 00:46:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784619994; x=1785224794; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=R6QmHVkLPhD/A6B0ICYsWWWaHDnOGP1js/9llqBRVqg=;
        b=ruuyBQV5DexkhyOPZ8oxyKKzCZW7AlKNXLVzPSmBf6QL54KQKgxPMcCQs+Zm/Qgi9b
         ru1gvcxc3CY26TWswUAdMbbjlkMFZJJtT7Jfn3PIszNH8X0LAAaS1qHhI2s/oUo6+6E0
         5zsXDLNZX4bxwvlc7J5g+QOe6+Bu745M9pA02iTxAeCk4qInzoaS4H8lVv/NkPbSDijA
         lqJ2sebC/MQ9UHJ8PygK8ZhVvHab9+LmD2zo5UO5wsAQJlGK3HTmd3ZTY4ARVYHnR+ka
         cv6Om2T6bU2C3CpP4xHbleXlDtLNAmq27znNqOIKPRWJuHFpTbuM+/ESFHbnZYo/FiyH
         Uy2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784619994; x=1785224794;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=R6QmHVkLPhD/A6B0ICYsWWWaHDnOGP1js/9llqBRVqg=;
        b=bbvglihSac6OOWY68qBY6bNBdM502OUL0J0DRRV2JC1v7TUEAxCrS4WOI69yy/aD0O
         Ug/Yl5vW33KX93JoyWdT2oSvCCQDDfBnYyAYTa9leK4ZdfWpR60YJVXO4eR2guVJetiP
         7nZGZzOcuGBmWcs3Cvdfrrlbw0WYcU9bQsHmK8/5Exlgwugdbmfm3JsHvnJtn4WmexMx
         zBvAJjw7crpEuAHhKpxBa1APPICq+dl//2RqwU8UWr2gXgzL82uq4riQFUlihYFxMn7o
         u0jmfQFBgsS4b9ndhJMgWAEqTJi45ngzOOhShzuOMCp0NLeTQNpAf1NMRsaMz/+ZG+C+
         cLtw==
X-Gm-Message-State: AOJu0YzrngKcWzXFuKE2m97KU4/gW4DGBg9NEZxqc7PzujG49fJGlYSF
	UORKRiZof84PsmbU32utd9W7+h6yPCkxckQes7KjZSdsQtkPLk9QyWRWycQB6JALIJJaLw==
X-Gm-Gg: AfdE7cnsFc+Ej+LKEQ3UF5fomkDGIom5SLpdDUZM3UH1ifPwxbk2n3P8pZCPa9eI7hH
	gXWpGRSW+ltRUDCJ/8siVifRn4enqUT4lG65gGL/iKY5N7YN62ITf4R/Xg6ytDhPhShp494UM22
	RiAKaeMsNQJtY7Nqx4EdeI5Fce5qfCGLtjEsgE2KJBTl3XLtw0W8gJBG4a4kZjKj6C1Zbd6xqO8
	Htw60UFEFdvlelp41qzpQzWoHFnk8cbR4FlmW8Wix89b+E65LLy8/gxyedmplt6SPBtsr8V3G9A
	vDaMLSKJXml+rTpYNVtD5W8R9Pjd500T0sexZrO85Dmqlj8ar81aTuLgeGmJqRcwz2hIPyY97hJ
	DhOn2x60SceMUn0jC3oAJ3l23QpeO5PJslOfD5bFctJBarL7C4k4WVP66Zc9kfqklu380AiLiqs
	ZQ7pJ6xez17ZpWbmRud2WB4gXxU0ByNjAfhnRDkDJ5xpHxEoyMV0LuekFRl79vg04ntNE=
X-Received: by 2002:a05:600c:5246:b0:495:6482:9d8c with SMTP id 5b1f17b1804b1-49564829df7mr44387495e9.37.1784619993730;
        Tue, 21 Jul 2026 00:46:33 -0700 (PDT)
Received: from DESKTOP-VQ38ID8.localdomain ([85.153.228.203])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4955a9e5f26sm142105435e9.0.2026.07.21.00.46.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jul 2026 00:46:33 -0700 (PDT)
From: Talha Berk Arslan <talha.anything.info@gmail.com>
To: netfilter-devel@vger.kernel.org
Cc: pablo@netfilter.org,
	fw@strlen.de,
	phil@nwl.cc,
	coreteam@netfilter.org
Subject: [PATCH] netfilter: xt_hashlimit: fix uninitialized rateinfo.burst read on shared table
Date: Tue, 21 Jul 2026 10:46:29 +0300
Message-ID: <20260721074629.668-1-talha.anything.info@gmail.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When two xt_hashlimit rules share the same table name, htable_find_get()
matches on name+family only, ignoring mode/revision. If Rule A creates
the table without XT_HASHLIMIT_RATE_MATCH in its mode, rateinfo_init()
takes the default branch and only initializes rateinfo.credit,
rateinfo.credit_cap, and rateinfo.cost (union offsets 0-23).

The rateinfo union is 32 bytes; rateinfo.burst sits at union offset 24
and is never written by the default branch. Since dsthash_alloc_init()
uses kmem_cache_alloc() without zeroing, burst contains stale slab data.

If Rule B shares the same table but has XT_HASHLIMIT_RATE_MATCH set in
its own cfg->mode, hashlimit_mt_common() reads dh->rateinfo.burst, which
is uninitialized.

Fix by zeroing the rateinfo union immediately after allocation.

Signed-off-by: Talha Berk Arslan <talha.anything.info@gmail.com>
---
 net/netfilter/xt_hashlimit.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/netfilter/xt_hashlimit.c b/net/netfilter/xt_hashlimit.c
index 2704b4b60..8943ed608 100644
--- a/net/netfilter/xt_hashlimit.c
+++ b/net/netfilter/xt_hashlimit.c
@@ -244,6 +244,7 @@ dsthash_alloc_init(struct xt_hashlimit_htable *ht,
 	} else
 		ent = kmem_cache_alloc(hashlimit_cachep, GFP_ATOMIC);
 	if (ent) {
+		memset(&ent->rateinfo, 0, sizeof(ent->rateinfo));
 		memcpy(&ent->dst, dst, sizeof(ent->dst));
 		spin_lock_init(&ent->lock);
 
-- 
2.54.0.windows.1

