Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8096279DA5
	for <netfilter-devel@vger.kernel.org>; Fri, 16 Feb 2024 23:31:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708126296; cv=none; b=qk4RkhURfWVoHIfxIuDWqhPSN455aLZiS4gGV6eeAQyQ+gWneXfJyA3nAiLkhfuWpcx+mlvFaz/hqafhO4mDLFfRVcOGY2Jn7g6dNJJnn2lYC4BsnxpKsYC0C+zk0q3V9o3Kot1EseP1Tk3fOblPxEmJ20pU4VTf57hoa4YSKgA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708126296; c=relaxed/simple;
	bh=jOdQW5rW0KnYyOq1p/yDKH9PCkLL/4PmnhZS1DjdHKg=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=PXrq23pk5jGFMNd+97YoYLEtRqCiRt20Iw/+56iwdWALH3wjDhIP23CEFCYHk+Sd08zYoqu30H2lukbQognsny3BjcZud3sAvM1S8cCA/mMHmUG5D/XjPpEMHyymba1yfLKd6bLBL9d8JJDFbwGE7fLPm8i6kk/a92gwhhajaWE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=i6xb+ltJ; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="i6xb+ltJ"
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-1d932f6ccfaso23170205ad.1
        for <netfilter-devel@vger.kernel.org>; Fri, 16 Feb 2024 15:31:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1708126294; x=1708731094; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=uN4qOGv2a6E3MQcDzEdcHEHjdiL8tvE8cOZTYxiPwL4=;
        b=i6xb+ltJvOyyeoUSgcEbRjqGbQ+I+3C7PIufIW08s02wpB7G0GMPPlH7kA8ygfcKuK
         TLz4Oa37GcJ8EOdxnOqqXixJHu4t/3W/OszBTnwRbhO6OqAVnaf5gXUroPb/Ed5VbmNP
         5E+6nezOOxuFn9TEGvO9Qb2k9lKMu3FXn52v4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708126294; x=1708731094;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=uN4qOGv2a6E3MQcDzEdcHEHjdiL8tvE8cOZTYxiPwL4=;
        b=N9Q1WR3/ijJAhnxsGodtQYzu+XYs2U0XU80S5R8VyOJwHDiJR3d+KRNeh7EOsRy/bE
         45+LJ5uEA0kzph+sheNCgG7HR+O6ZOxXF1u1K3uf6B6nH4aIJOYutj/ACOlpeBDDTeRi
         pI0kI4aw9GqmodFYligKLFvHqDE6wdB/mNUQFucbdthxX4WCAZpRbbMO5F3G2Y53PXk/
         TC9aP5LCJtSCKI+75NMSfXEwqKyMo9lkOHz3tKkK0GQLle9Ssk4PmKWfesPUxf+8BKFQ
         HskUS8HwTfMVGu5jGxFXxeZD9Whu1Ow1EH1O/h5cXBCn/pGcImPPtN04X0Cz+OYpzB3x
         VnZg==
X-Forwarded-Encrypted: i=1; AJvYcCVoEI6NWJ5e53X0DG8H4pJbrGWj2PNIQm7Lo1SZ+Dolb8B8Nsits4yba3qR7J6fRsExshVJOttBjmBBdNY1AtMfHa5Uxp7AqJk6WYWLAzax
X-Gm-Message-State: AOJu0YyEL07NfKLSPaGgPHqcW6A/7uLSzX8cXF7oIj3PHeTKAXmv9C2G
	vLuHkDsoeCqomss6ClPIQbmlyOWQEhNg9zyD29ttHju/67cKcv59ihJXVrL/oQ==
X-Google-Smtp-Source: AGHT+IHYCWfbnUZ5HuqCPPkKFAYJgYB1thSC9ROdHinB5aTKmF0kNsJglIf3SEJgNPB6vkQ1wKYPdg==
X-Received: by 2002:a17:902:a987:b0:1db:9c20:5c91 with SMTP id bh7-20020a170902a98700b001db9c205c91mr4503197plb.26.1708126293947;
        Fri, 16 Feb 2024 15:31:33 -0800 (PST)
Received: from www.outflux.net ([198.0.35.241])
        by smtp.gmail.com with ESMTPSA id kn14-20020a170903078e00b001d8f82c61cdsm371747plb.231.2024.02.16.15.31.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Feb 2024 15:31:33 -0800 (PST)
From: Kees Cook <keescook@chromium.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Kees Cook <keescook@chromium.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	"Gustavo A . R . Silva" <gustavo@embeddedor.com>,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-hardening@vger.kernel.org
Subject: [PATCH] netfilter: x_tables: Use unsafe_memcpy() for 0-sized destination
Date: Fri, 16 Feb 2024 15:31:32 -0800
Message-Id: <20240216233128.work.366-kees@kernel.org>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1607; i=keescook@chromium.org;
 h=from:subject:message-id; bh=jOdQW5rW0KnYyOq1p/yDKH9PCkLL/4PmnhZS1DjdHKg=;
 b=owEBbQKS/ZANAwAKAYly9N/cbcAmAcsmYgBlz/BT+pya3GeMtcIriH/e+CPxrqjEAzWQnu8l0
 3unAX1y/EiJAjMEAAEKAB0WIQSlw/aPIp3WD3I+bhOJcvTf3G3AJgUCZc/wUwAKCRCJcvTf3G3A
 JucjD/9S6378diNRxHdllYwRjhQFF55zpJBsrgb5CoQpz4g3967S3N/XRb9FUCJZ2741ghKLG8G
 vhnAD1P4VsHm3e1EQXMeNvyEC7ktk8kg3m3S3SEYfkRqdB31Y9GDL3wIXuLI5LBsVgKiAYJ7IeE
 2fv265fAcWTklZIr4VNCtl4x/x3dUxnFtQFDqgv5W13Qq+tpIMSSbDlNB8Dr+UP+VtFPiyO9GiZ
 w5FgIxyTBZav+LGMzKcYVW7c7e3pFCUblaI+CQZu4mswl/D9D12KxufIjRwygnbGGFsC6VLDhAa
 EYAZhf9lgWuRBf5oJQh/QiImTntMQOSskI4Tnw4H4CrSeN5q5Vf0Sqyyejrpsvl/UEAN2+FwLuQ
 bQO0Jm7GBXXRWzJGIWZ2MJXpfCyxvbn/lO3Yf/jv2d5UB0yvtzThfT1OMTHGujGhGYNT+mlmTVv
 FTH5UgFzIQMOcAtT/Dk/NcoAi80rt2suzgxoH9K6CYWTOenO7+hRm6PmsxB61y04NFpDKcpJ+x/
 UYlIX8n6PtqsL4aI/Oj/JeZ7jo/cPwRDd8TSE0LGpAQPpOpiktvkX74hurPk7E1uQ+0J1e/Uetj
 dc5DhHQUArhyuNWCIbo6B9SuKk2nyGqrB42oRb/sGXMx/uUqH7bmNp2xRV8Vf3qB9i+cpUc/bS5
 +IoRHOC wkGajx1g==
X-Developer-Key: i=keescook@chromium.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit

The struct xt_entry_target fake flexible array has not be converted to a
true flexible array, which is mainly blocked by it being both UAPI and
used in the middle of other structures. In order to properly check for
0-sized destinations in memcpy(), an exception must be made for the one
place where it is still a destination. Since memcpy() was already
skipping checks for 0-sized destinations, using unsafe_memcpy() is no
change in behavior.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Jozsef Kadlecsik <kadlec@netfilter.org>
Cc: Florian Westphal <fw@strlen.de>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: Gustavo A. R. Silva <gustavo@embeddedor.com>
Cc: netfilter-devel@vger.kernel.org
Cc: coreteam@netfilter.org
Cc: netdev@vger.kernel.org
---
 net/netfilter/x_tables.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/x_tables.c b/net/netfilter/x_tables.c
index 21624d68314f..da5d929c7c85 100644
--- a/net/netfilter/x_tables.c
+++ b/net/netfilter/x_tables.c
@@ -1142,7 +1142,8 @@ void xt_compat_target_from_user(struct xt_entry_target *t, void **dstptr,
 	if (target->compat_from_user)
 		target->compat_from_user(t->data, ct->data);
 	else
-		memcpy(t->data, ct->data, tsize - sizeof(*ct));
+		unsafe_memcpy(t->data, ct->data, tsize - sizeof(*ct),
+			      /* UAPI 0-sized destination */);
 
 	tsize += off;
 	t->u.user.target_size = tsize;
-- 
2.34.1

