Received: from mail-lj1-f169.google.com (mail-lj1-f169.google.com [209.85.208.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B3D51B4247
	for <netfilter-devel@vger.kernel.org>; Sun,  2 Mar 2025 19:44:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740944685; cv=none; b=MZv7vUhl+hJ89IQy7lnesekTTqVWHa+OsxKbjISofufX9xnqGfjjchgs4yGHzbUWhWXrYOlbdkH1mHRx8XijFvz3w7NmlL0Kj0eyXmjBJnZyn8Xr5R44uEUcjaO8s/Y5Q8MWjKR3WG4S1fpq8XUVXfugnWQ0knaEys8ZutupsBw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740944685; c=relaxed/simple;
	bh=84jiEXsqQrpnUz0aNneW4kmOqG1DElRvzvPlPctXlwE=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=HyOGGAoUY0ooeaBb+DZCeg+PiB3gvyIeyNzS4nU3Ovr8Ej1nRe4P7Vu8L57l0l7B9shSAj5wA1X4ztoimgRsY9yrhHGdt52pBfvfO4D09/uiuGqBNfgzUWfD4jzEi91YtJPOb7ckCSR548SjRcoQL3Fgkb4D8e5dwE5If16O4Vo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UbsxCEhV; arc=none smtp.client-ip=209.85.208.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UbsxCEhV"
Received: by mail-lj1-f169.google.com with SMTP id 38308e7fff4ca-30613802a59so43437801fa.0
        for <netfilter-devel@vger.kernel.org>; Sun, 02 Mar 2025 11:44:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1740944681; x=1741549481; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=UrcOKB+WXjResyLoG2eYDzwCO0Jf29qKMD4swpA8fBc=;
        b=UbsxCEhVBl2eO5dixfFROHi96N5K/MHVqhvkKeuQTh3wqCTrYmCWULATD3Rxy4PGwf
         JGThfaxOaGm3ottyMD5+ENF1R63q7gUEel6d2sv4hvrbOhkp93R8P9gNU3bA+FmWaruZ
         EtPw9Araa9D164kuxlNiTkTgiEAFJOuDI8BN68bYDGp0QwAWkRoDX3iiaRd8lCycKvcW
         fmzHuso+Isn7x/OQAHP6691kQsM/yFQ+OUz20b1H86PhG87XfIZ5Lt35YeAU013G7iL4
         kgt1s0NliWQ7SY6NYSKgNImTnS5eTyQ+8/MdprZ/7VwKYEOpoJr/9WdScNHWXKpK4XB8
         uYGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740944681; x=1741549481;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=UrcOKB+WXjResyLoG2eYDzwCO0Jf29qKMD4swpA8fBc=;
        b=rHpgtKBpc6CDfmD7Puy5DRlWcmZRv18HeVSAzXNX7oBgbEndlVevNVdn/JAJMWf4Py
         EpVxVbl56KLKaI9b/vH1EFm5elOYHhBLkiAK+3DtPV3uzcbxTVJdI1/9yR3MwzGNq8Ih
         LXq4OJQSs7xMdYeUvfydredrcg9WD4Fl3C7FW5Vb9tQfdcnoudlu9xWB4kdqvygayFQU
         14F+xvcFUkkiQbiFjf270oqwC+d0A7TsA7wz8Ivy4mszSrbOS6XcvdtLDRvStcE1YQKP
         FWUxp/6SffNSWYf0WuenOZv9UXrsxs6VKwpmi35dh+84Or1Zm8DgiMpcEUspskCNEEDR
         xvRQ==
X-Gm-Message-State: AOJu0YxVqqcIZLK3g/bS7ca7GPDmo4ukbMMD+/qLrCuhrvESaYuwcbxB
	JJKD75SCKfw9X2tEXoJ/FOMjW7uKht6lV7AVnPzDbTP+Y06Fm9qgqO7vyYzP
X-Gm-Gg: ASbGnct1yn4WWapEPhh0h0cwmpb585CgMeSIfxVa0MCI+CxryztZUi3Vsn3U640lBm3
	SjIkFbScFqDSsrFzLu4hniEghvRjukqZzMeds0H+AlClBiQrgMoMxYIfCGyGO6tSssvQetjqvad
	8VinerQlqFW9QdMo+8/FqekYIGO5EOtKLp8vuvnPShLKNAVNI4/x7hTcgy/2AWy1NTN69sfJ9FI
	jWPLj+9M5zidJYt5MokJQMBZjFMywJH0EtxtCY4UCjsnGh8IkIJuFzOwzmrYiH2wu9976dKBo4a
	RWkO96Lp/NxWb370RAA5VxKGgrX448kB/SitPxfF86njaKHMLlRjFvL56GvEuw1JK7dSUeHJ0g2
	9qH9tAog69jvHsYWNKSm9ch0weMU=
X-Google-Smtp-Source: AGHT+IEtzZ74yEGEOz6ElyidxQ7dUaRUlqCdgytQ2tXp50aYU3RWOFVjXvFOBOMyG1Awfg096UuJsg==
X-Received: by 2002:a2e:9dcb:0:b0:309:2000:4902 with SMTP id 38308e7fff4ca-30b93455f2bmr30161781fa.36.1740944681278;
        Sun, 02 Mar 2025 11:44:41 -0800 (PST)
Received: from astra-student.rasu.local (109-252-121-101.nat.spd-mgts.ru. [109.252.121.101])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-30b98a8f544sm8611281fa.68.2025.03.02.11.44.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 02 Mar 2025 11:44:39 -0800 (PST)
From: Anton Moryakov <ant.v.moryakov@gmail.com>
To: netfilter-devel@vger.kernel.org
Cc: Anton Moryakov <ant.v.moryakov@gmail.com>
Subject: [PATCH] src: fix deref of null.ret in rule.c
Date: Sun,  2 Mar 2025 22:44:35 +0300
Message-Id: <20250302194435.666393-1-ant.v.moryakov@gmail.com>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Fix potential null pointer dereference in `do_list_flowtable`.

The pointer `table` is initialized to NULL and passed to `do_list_flowtable`,
where it may be dereferenced. This can lead to a crash if `table` remains NULL.

Changes:
- Added a NULL check for the `table` pointer before calling `do_list_flowtable`.
- Return an error code (-1) if `table` is NULL to handle the case where the table is not found.

Triggers found by static analyzer Svace.

Signed-off-by: Anton Moryakov <ant.v.moryakov@gmail.com>

---
 src/rule.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/rule.c b/src/rule.c
index f7582914..59d3f3ac 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -1556,7 +1556,7 @@ static int do_delete_setelems(struct netlink_ctx *ctx, struct cmd *cmd)
 	const struct set *set = cmd->elem.set;
 	struct expr *expr = cmd->elem.expr;
 
-	if (set_is_non_concat_range(set) &&
+	if (set && set_is_non_concat_range(set) &&
 	    set_to_intervals(set, expr, false) < 0)
 		return -1;
 
-- 
2.30.2

