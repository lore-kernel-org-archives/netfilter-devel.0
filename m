Received: from mail-pg1-f181.google.com (mail-pg1-f181.google.com [209.85.215.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 296501E572F
	for <netfilter-devel@vger.kernel.org>; Mon, 29 Dec 2025 06:26:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766989575; cv=none; b=YLE5fxqs8NhAlZuvk2Gm5sd7JSqngNg5QhDeWU4HZY2wEWWWySZ7jY3VojnnT0Fs2E1DBh7GLVIEnBnyPDLKSSrLhidpcrQw2H/yMoV1NvI4yo0WGCBExEX+1rI6gYhKuNEOOTWXFJzEi9hDaAICDhzIsofvppMQYrnRDDnfpj8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766989575; c=relaxed/simple;
	bh=Cx3ZNi21e0whRxdOejrsqkEXKBqqTe4s7K1XZk/G/rM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=hA8fCfNGknrymd3QWrCiWlyQ81umlHGTx/dCILIcRpwJVR/FKu1vpWzWgQX+neBgsmUFZCEO5OmjN//1KiHDih4dTPXYpAvY/5ckz6ehQtxLb/OjTN2UuHg5cXi3l4Dz0FjUK9tFmM2ceBUBVk030ZUsz2Dz4xG7IwpiZU3KZOw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WbogDKi4; arc=none smtp.client-ip=209.85.215.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WbogDKi4"
Received: by mail-pg1-f181.google.com with SMTP id 41be03b00d2f7-c13771b2cf9so7387153a12.1
        for <netfilter-devel@vger.kernel.org>; Sun, 28 Dec 2025 22:26:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766989573; x=1767594373; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=8zu/58VzljRfDR9Jj04qCOwrkU6r+Shx5eeLW3+WkMw=;
        b=WbogDKi48Q3guy23cwvtab99sQ/WXESGMV1pZcEvS+SAgrME+GhudsGibtUE1+90HO
         wd+BjoWpExeU4GOX6r2UYihikD/wm5VsM1rX9rYciY7dwxz5idq/3ZpvetknkFT8g+h/
         QiDhRL/zBYv8da11UqOP3vbP9VuDQ8jY+P+u7dM0IcMsnfDfNyfVUIx5G5gsL2fJhpnI
         pOv9RO5ef0HoJfCyAvsMFoTeQnYBKS4rXEB+WAJIHEUu4dH5zcAHKWvxSCT/zxuqzzp/
         X5HaqL8JGnbVBsHP1sJJGde5f0apX2MpbZATzDmkJx5Qn8+28jUCKIOZlpBt5nlADfTd
         DIOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766989573; x=1767594373;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8zu/58VzljRfDR9Jj04qCOwrkU6r+Shx5eeLW3+WkMw=;
        b=ZyLcmfo6N82SFXs1aPiFZ/bvdzNneLqhSjj+Z6yVsDR4aUpL7CxdNTWm0oZ9R2J0by
         ckCBV6rKCa/Y7R8GeRhADCzjs4ozKpuGrsGBaz/J8+T9oE1r4XzkslU0nBrS329UIRZV
         Ypjxsy3r2HgyXrSaNUV9QS4/MEGWg6JkbXJlGwxWpeps+qQszSKUC/XwPGplcn5FEiCM
         50/I1yrI6YMwm86zkLx02hn9/OnEIWVbgILNUZe8iGD8WbvSorNqThoUU+mgQoTto6HN
         4bKBEqKLvkChiAjycw/bkr7aUNOx9KGPE27grMwMJzDFPfalUAMwFQDhLlJe/GzggY2F
         NQtw==
X-Gm-Message-State: AOJu0Yx5t8c81REYGxAqwyoT3AZ2mH/vox9pHCD2WeSnJqxYmbdZwouQ
	RcVuj8jRW+QjqPtMmxPJ3bxmHNTGyJmkZQaYcUma5KLLUHeraDZTPNXqGj+CQfwbKOY=
X-Gm-Gg: AY/fxX6pFqjD5Q/d+qrPTqNP87VKwpAojT9oy1cBqUAMF8rcCPXBzoS04AOlcAcM9D8
	ZrG+NETjW4SdCCX87UMGNPCV7nX5QxAVTSFBsZBD9RPqDmdLzxrncT8JRezXRoskWAR5xqFa1Sx
	AmY3mdjM5M3zkJ+jSAVdIgDdkpLhb9TptrnpEVu6U17s7zYzpz2NqCjdmZ2jEYdxd3FIQDdarme
	HFOt00nKK+DpRkS5Cpc7r6JBqZsLEedi5ANWlsaqBza6kkFqcrsv/9osoFPQCgHI1eQk9JHYY8t
	z0p82EjPP3ZVz0CdgyO/l/A65uYQ1hR0/I6rDmAZswghmtgMb3hlVlex7f13Val9Z5HqIE1EDLl
	JWGrc0QDwpdbWVXnSGToEkwb6bMmeOqSDiMmd7V3ja+aUFXMmAZx+VSxZTgDc6hz8p7k=
X-Google-Smtp-Source: AGHT+IFuZVHmrXrIT0+hj1OE6o0C43S73mo5NMYgDvGiVhQSU7PIqendmbSy6SO6rdgRDxnPyvx+VA==
X-Received: by 2002:a05:7301:1823:b0:2a4:3593:c7ca with SMTP id 5a478bee46e88-2b05eba4a37mr14173484eec.10.1766989572918;
        Sun, 28 Dec 2025 22:26:12 -0800 (PST)
Received: from gmail.com ([2a09:bac5:1f0f:3046::4cf:1d])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2b06a046e99sm72950584eec.6.2025.12.28.22.26.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Dec 2025 22:26:12 -0800 (PST)
From: Qingfang Deng <dqfext@gmail.com>
To: netfilter-devel@vger.kernel.org
Cc: Jan Engelhardt <jengelh@inai.de>
Subject: [PATCH xtables-addons] xt_pknock: fix do_div() signness mismatch
Date: Mon, 29 Dec 2025 14:26:07 +0800
Message-ID: <20251229062607.755-1-dqfext@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

do_div() expects an unsigned 64-bit dividend, but time64_t is signed. On
32-bit arch, this triggers a warnning:

In file included from ./arch/arm/include/asm/div64.h:107,
                 from ./include/linux/math.h:6,
                 from ./include/linux/math64.h:6,
                 from ./include/linux/time.h:6,
                 from ./include/linux/stat.h:19,
                 from ./include/linux/module.h:13,
                 from ./xtables-addons-3.30/extensions/pknock/xt_pknock.c:10:
./xtables-addons-3.30/extensions/pknock/xt_pknock.c: In function 'has_secret':
./include/asm-generic/div64.h:222:35: warning: comparison of distinct pointer types lacks a cast [-Wcompare-distinct-pointer-types]
  222 |         (void)(((typeof((n)) *)0) == ((uint64_t *)0));  \
      |                                   ^~
./xtables-addons-3.30/extensions/pknock/xt_pknock.c:747:17: note: in expansion of macro 'do_div'
  747 |                 do_div(t, 60);
      |

Change the type of variable `t` to uint64_t to fix this.

Fixes: 397b282dba9a ("xt_pknock: use walltime for building hash")
Signed-off-by: Qingfang Deng <dqfext@gmail.com>
---
 extensions/pknock/xt_pknock.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/extensions/pknock/xt_pknock.c b/extensions/pknock/xt_pknock.c
index 734e6f2..8cf04de 100644
--- a/extensions/pknock/xt_pknock.c
+++ b/extensions/pknock/xt_pknock.c
@@ -743,7 +743,7 @@ has_secret(const unsigned char *secret, unsigned int secret_len, uint32_t ipsrc,
 
 	/* Time needs to be in minutes relative to epoch. */
 	{
-		time64_t t = ktime_get_real_seconds();
+		uint64_t t = ktime_get_real_seconds();
 		do_div(t, 60);
 		epoch_min = t;
 	}
-- 
2.43.0

