Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD94D1C84A0;
	Tue, 19 Aug 2025 18:17:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755627444; cv=none; b=gNyYZKdPxmuYnYaowJw8o38e56sa5taTZt7ztlmv9I9Vs7s128U5vrirA+wGBdPxvRcyQitQPG5HYJOLwIV6CMWkYSGKisT4CJifGGlszVN5zd6EwWeyDEB+Quu5QagpWmjGP5TUZE3EftD3slgE1ZjAHgMUOnVyE4R0SQNEu14=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755627444; c=relaxed/simple;
	bh=fw5zSk4ebcWH3nnV9+5Gv/duEEdUZT8E3lwrDEugyxQ=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=Y3nFavTHPjaRlMvkYjcfeaxrMA6s4V7hzVJibThgxcLJlAsnX5pfFjy+4lJJUG8sgVwtnqJhceZR92oY6dZYA5zLXC1vzN8URTqPzHSQuX0hx2F1Za25pGCWYFNLWSCKlyhZg8VhpA3MPB4aY11xZgE+fPWk5JQ7CFG4TJ/+sWo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QlwkgNmZ; arc=none smtp.client-ip=209.85.210.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QlwkgNmZ"
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-76e2ea6ccb7so4213055b3a.2;
        Tue, 19 Aug 2025 11:17:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755627442; x=1756232242; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=rTvnrNpZQcFuNJogx1bSbEwyysM3Ecd+iaaHw5T3QnU=;
        b=QlwkgNmZ6Dnf4XPNrhqcjiabHa4vBpZVDP/3f25J6/NFQ+972NaHgoOxPN5Ggbe1Us
         wVhHj+yoi6CKTArwalWrWveDsCRRC1zTPEzOq/qrpFl0z/OPWNL0AO3fo1o9AFqNvsYP
         k0Vajp07zdCKgzSSAPJ/WgIDb9gYOiVSB6LHy/p6NqRuD/lFKmmPf3wiC5WHq37d5WBF
         Vs3Dowu1IsUI5CP0eVQ5JS9u7vONRRm3r2CFrPUgy226YpwaOmsLjGTKDs+6GbV/aQ5C
         u+3Ddl7gKFk0u3IJheHH2eq2MtPAx/i2Cxcage+sUqhhgdgegji9hH5h9A5Er91h4G/C
         OBLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755627442; x=1756232242;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=rTvnrNpZQcFuNJogx1bSbEwyysM3Ecd+iaaHw5T3QnU=;
        b=WUlpqZokPwqgdBEzMva2ZMTbEjgoXymXwHknZjGX4nnnK1qMOWZtNnVzkLIUbi5TuX
         I83DiWkeAvuVb3ORnrnFH+M7HxpSqfFa5pVL+fC68iFaw7GITXfTXpYhdMK8xbE5ArkE
         tedjct6q540LO9DPlRBBoCds+Oy/29c6JKhHSfRlo+ECNpFQIxqRy6MEhlg3Hm5iiTsr
         rtftfAS+/nrFIUTG1+hMt8FmFCOXoCbHaYkJ3lKmH3wZH8hwDdqtNK7Kx0YfMjC3VbYL
         3UYJIMEjmaRKXJAaN7cfVm2dP/9JK58zSTW4XqecLUoid0TsGr/W5PNx4JN4JhzXE68O
         JJ1Q==
X-Forwarded-Encrypted: i=1; AJvYcCXndv3kJHNETcsicIXK3Mkj+RfLwF8QDAoVgNmyVBlTfS33JHCkTqBEN+MT1l2dScgLoEAwj6yO/RiSWYo=@vger.kernel.org
X-Gm-Message-State: AOJu0YxWGINPARKqCUmVOBZNxGLOClmwbZ3mDZS6A5mv8M2dX4iD3WWO
	/nv1gd1raGMbjtFiHw0plqxEsd/hOk72l2uNbl6MvMphPZvuUVatwPPbyC/ASw==
X-Gm-Gg: ASbGncuQ2c6qjkRsUCRF+rsO9cbqW4qGYFI/tCk54CCxontrSbQ8oO4duOENI1YMPSj
	9oI+GAVP461GMRwosgmzXCFZQF59KHXy26U4MGkOUv/CvCwxNE6Kf5wgve9Ei4AX/INE0f3LHms
	kiFza57hDm/LEL/+AiB0rPjF9VgXfvt8UxuwMC88jV7zmWitTb+aoGHu1lVuO9tI6/nT9a47Hq9
	Dbl3Bk9UhemYLnAWU1hvDaO97XUaDJ9zFAjY5PoUWHrzEVFmccR0urafGVV0+OGYOXeevAfWbHz
	41bhSWR0yuFZE62I1jKJlJeegkrpSlZM01FVlfyIJqi0m0MS5I38qqjyE5Zo861BJzNI87IoXQx
	34lMsDFytdWzFdBYm0DnXuKNHX4HUSFmo
X-Google-Smtp-Source: AGHT+IH1GuQ2bh13jv12/nnH98pVSnTfL7rLhIuk6x6vKioGJbAmFPIOgkwSX0Fjli/AK36MVgdOOQ==
X-Received: by 2002:a05:6a20:7351:b0:234:4b39:182c with SMTP id adf61e73a8af0-2431b9ac277mr421016637.38.1755627441840;
        Tue, 19 Aug 2025 11:17:21 -0700 (PDT)
Received: from localhost.localdomain ([173.214.130.2])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b47640d3e3fsm282598a12.56.2025.08.19.11.17.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Aug 2025 11:17:21 -0700 (PDT)
From: Qingjie Xing <xqjcool@gmail.com>
To: netfilter-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: netdev@vger.kernel.org,
	Qingjie Xing <xqjcool@gmail.com>
Subject: [PATCH] netfilter: conntrack: drop expectations before freeing templates
Date: Tue, 19 Aug 2025 11:17:18 -0700
Message-Id: <20250819181718.2130606-1-xqjcool@gmail.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When deleting an xt_CT rule, its per-rule template conntrack is freed via
nf_ct_destroy() -> nf_ct_tmpl_free(). If an expectation was created with
that template as its master, the expectation's timeout/flush later calls
nf_ct_unlink_expect_report() and dereferences exp->master, which now points
to freed memory, leading to a NULL/poison deref and crash.

Move nf_ct_remove_expectations(ct) before the template early-return in
nf_ct_destroy() so that any expectations attached to a template are removed
(and their timers cancelled) before the template's extensions are torn down.

Signed-off-by: Qingjie Xing <xqjcool@gmail.com>
---
 net/netfilter/nf_conntrack_core.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 344f88295976..7f6b95404907 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -577,6 +577,13 @@ void nf_ct_destroy(struct nf_conntrack *nfct)
 
 	WARN_ON(refcount_read(&nfct->use) != 0);
 
+	/* Expectations will have been removed in clean_from_lists,
+	 * except TFTP can create an expectation on the first packet,
+	 * before connection is in the list, so we need to clean here,
+	 * too.
+	 */
+	nf_ct_remove_expectations(ct);
+
 	if (unlikely(nf_ct_is_template(ct))) {
 		nf_ct_tmpl_free(ct);
 		return;
@@ -585,13 +592,6 @@ void nf_ct_destroy(struct nf_conntrack *nfct)
 	if (unlikely(nf_ct_protonum(ct) == IPPROTO_GRE))
 		destroy_gre_conntrack(ct);
 
-	/* Expectations will have been removed in clean_from_lists,
-	 * except TFTP can create an expectation on the first packet,
-	 * before connection is in the list, so we need to clean here,
-	 * too.
-	 */
-	nf_ct_remove_expectations(ct);
-
 	if (ct->master)
 		nf_ct_put(ct->master);
 

base-commit: 01792bc3e5bdafa171dd83c7073f00e7de93a653
-- 
2.25.1

