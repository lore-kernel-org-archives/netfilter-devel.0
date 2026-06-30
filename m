Received: from mail-lf1-f42.google.com (mail-lf1-f42.google.com [209.85.167.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D0C145BD5C
	for <netfilter-devel@vger.kernel.org>; Tue, 30 Jun 2026 15:55:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782834912; cv=none; b=KGOSQhumi5tTJ0wiRaUP5v/LEOI1OlMiscIyagbZMWqzkhYU9PuKVpo1whg2dSdHgXSx4UudlMOvvXbtG9Ln5Z5YSx+cvdxWlF+a4W2K4wpqjt7loCd6ZO1NmwtBWNcs+sr57OrugjQi66yNY/1iXlJygndW+eBNAew6YIgF+yM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782834912; c=relaxed/simple;
	bh=Yw8oCznc2OJZsMWD8OS/+WNJjaNMiuOlVPoeyrSnd5o=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=IJKsOUcYBACLNBidmHijn07fW+/5pYMDrJYH6cB6Edt92UsDRjgtCZYK+7BiPqzzX2OSawG38k4gJyK5hkwS1S36Vl++fviwuRw/bgDSdbf74a3mqr1xE7T/rKc1f1BUFGW8aY4eAnoOY1KG0fJMNDfJXCUgPoBPyE32DKJs9C4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mdDp5xzd; arc=none smtp.client-ip=209.85.167.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mdDp5xzd"
Received: by mail-lf1-f42.google.com with SMTP id 2adb3069b0e04-5aebf162770so688065e87.1
        for <netfilter-devel@vger.kernel.org>; Tue, 30 Jun 2026 08:55:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782834909; x=1783439709; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ZpeuDr4E5yKEgMHqJGuQTCwVMvwRIRIBCO7YWOuYUzo=;
        b=mdDp5xzdWzoN8DZICRJYL/PeLGM7+thRjhEDFlqm7HeJsBdO+haOQ/Up1Gog+L/krF
         2fy6s9CN8S9LQDPaNDwHxiJB1TCqT24z5lZgWtBmcWw+ZXkpIA+Pjh9FMdZRYujtXv3T
         ezf6tI+zo5LVhLIxZ3WAT0YhjpsiNIhS2wAJmnXznyXZb7zjtHshGZ7BOL+P7KYU2LtM
         b7Q+x2z30xPIe6B5XuKlLxzDTrA0M+kdxSW6pabIDSteTEzZI2ByziBI5OBGI2A2R+4j
         43oRbTnKOHsuLh5dAThL+el7gvOxpkiL7tyxUujIVF1DHpWZPW50oU0ixOYLQrkVMZpf
         i6SA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782834909; x=1783439709;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZpeuDr4E5yKEgMHqJGuQTCwVMvwRIRIBCO7YWOuYUzo=;
        b=eBAyR4G0dFrJHFYrdiSshegdO7HvOtWVL4T8A+yq7C9+xX09GxNsH/ESHB6NER24iM
         +zVddHVyu2r22uawk5vkXquR92MIJJv5PBE/e6DUGEpFLFIfgryQSXpiYRKTNHsOt3+f
         LxTcbDrBcRIdZLX7S7kkIRyxzkXfR/btAPC4UQNwCBUwoYdHTrfGCGOdl6KPzSfNQprF
         ovYlL+944qvIA/5P9/Io6RRmL3piQUW/aOoY7A+kpOn5FRMAAVmg54uZ3uSQgr4GWr06
         9kFpWC7oiOoQFpzbU+HiuXCr2oKyWSy5uu7yuI80jqN/j7zrllWhhzreaZFrMF8/PHTF
         duwg==
X-Forwarded-Encrypted: i=1; AHgh+Rp1v/TBrxKw/fv1faOhWRkUinC/qbFqVMwBxlUDpgg2jwbmtHlsSN9YvmzRZxoIHk02lEayAnAki4qCYWXzlXE=@vger.kernel.org
X-Gm-Message-State: AOJu0YzG5+KZ+SHcH670dMiNwi+N6Q/UYF5NJOAooyPSS3qDk9btK/Jq
	Wsy6hPQzYBZZHOat/gCBqvSp+GSJAefxYDxa8RzoIsoK1U3iGo2qbiWu
X-Gm-Gg: AfdE7cn/ZI6UxBUeEzJ0VU59W896MyjJ93eZF8D3Aa4fFRlMjg8p06oXsu7DUTHFkad
	VC37AhZEnFdqNhxX6bmws4TqSYxfvjl/tLtQnTC/K2zEAJQSrQYtNvnqmvxAKXX1ByD6r8cE/Z1
	S/Fw8+7lcQTkFLxPXNm952qdoJM71rGVzFKGeala5xhUnfTUk6aWAeMUV0/nZUdV58m28DBSWKJ
	96G1heu5rvgiBjorHIFigDO/dgm/GzwxuyGm+FGE9ysc65R6ZowkEZcWxisZ0lqL0EgLhUpWMgY
	ehuProX8z2BHWtL6urKoym6tT+IEjc8crkYgJKVImvCM+s2xQCjza26DesOn38YLO2GpTlbJ8VH
	Ybc7kPGXKREnC9IxO/BCHF5By9Tn6IBUpYdteNT/dtmkyt3mEN0EgzejIatfHtp9bZnBsoxQU4D
	oWTs8XEpgToue3+n10ZN+Wm4vDsvCHoTU=
X-Received: by 2002:a05:6512:405b:b0:5ae:b6cf:c745 with SMTP id 2adb3069b0e04-5aebf977c96mr795622e87.17.1782834908933;
        Tue, 30 Jun 2026 08:55:08 -0700 (PDT)
Received: from localhost.localdomain ([2a01:4f9:2a:1c13::2])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5aec21794casm46702e87.10.2026.06.30.08.55.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Jun 2026 08:55:08 -0700 (PDT)
From: Melbin K Mathew <mlbnkm1@gmail.com>
To: pablo@netfilter.org
Cc: fw@strlen.de,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Melbin K Mathew <mlbnkm1@gmail.com>
Subject: [PATCH nf] netfilter: nft_set_rbtree: reject interval-end get for open intervals
Date: Tue, 30 Jun 2026 17:55:07 +0200
Message-Id: <20260630155507.92815-1-mlbnkm1@gmail.com>
X-Mailer: git-send-email 2.39.5
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

nft_rbtree_get() uses the interval endpoint selected by
nft_array_get_cmp(). For NFT_SET_ELEM_INTERVAL_END requests, the function
uses interval->to to recover struct nft_rbtree_elem.

Open-ended intervals can have a NULL end endpoint. In that case,
nft_array_get_cmp() treats the missing endpoint as b = -1, which can
still match an interval-end query. Avoid deriving an element pointer
from a NULL endpoint and report the element as not found instead.

Return -ENOENT for interval-end requests against open-ended intervals.

Fixes: 2aa34191f06f ("netfilter: nft_set_rbtree: use binary search array in get command")
Signed-off-by: Melbin K Mathew <mlbnkm1@gmail.com>
---
Notes:
  A reduced userspace model confirms the comparator returns match for a
  NULL-ended interval when NFT_SET_ELEM_INTERVAL_END is set, and that
  container_of(NULL, ext) produces a garbage pointer (UBSAN fires).

  I have not reproduced an end-to-end crash through normal nft CLI usage.
  An instrumented WARN in this branch did not fire during interval-set
  tests with nft add/get/list. The patch is a defensive fix for the NULL
  endpoint case.

  Tested on 7.2-rc1 with KASAN and UBSAN enabled. Function tracing
  confirms nft_rbtree_get() is reached via nft get element. The added
  guard returns -ENOENT for a NULL interval endpoint in the instrumented
  test case.
---
 net/netfilter/nft_set_rbtree.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nft_set_rbtree.c b/net/netfilter/nft_set_rbtree.c
index 018bbb6df4..024a2cd3a6 100644
--- a/net/netfilter/nft_set_rbtree.c
+++ b/net/netfilter/nft_set_rbtree.c
@@ -184,10 +184,13 @@ nft_rbtree_get(const struct net *net, const struct nft_set *set,
 	if (!interval || nft_set_elem_expired(interval->from))
 		return ERR_PTR(-ENOENT);
 
-	if (flags & NFT_SET_ELEM_INTERVAL_END)
+	if (flags & NFT_SET_ELEM_INTERVAL_END) {
+		if (!interval->to)
+			return ERR_PTR(-ENOENT);
 		rbe = container_of(interval->to, struct nft_rbtree_elem, ext);
-	else
+	} else {
 		rbe = container_of(interval->from, struct nft_rbtree_elem, ext);
+	}
 
 	return &rbe->priv;
 }
-- 
2.39.5

