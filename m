Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=220.197.32.19
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793353197;
	b=JdLZaj6nH5jsxhEQ8Sf5Jb/NNnNV8mBrOtFjfyax4GqlFsFkfIcC3uQb3Sla4AA0PGNx
	 upijdV9tpKqtFS8qgDtqTWTxzSvmfYeJ4yOetVOtWrtZzP6SjIPkheHqUZxp7LiIYV0uF
	 fu+5pDOeQaT/ac/l2KQe44zDhSa7+DQXcjIfTIiSVdoxGaZ3ravVDI/C7QKPr6FJ/8aHt
	 z13p1V3c/aEMsqrz2oMUQ3+h9USkGMXM/QV5HYrmIdS3nX2DYDs9AKvMtOPgdapnbJzEO
	 +yE+AViiWqi4QriQwpVOA/hNoh5p+ddcWiw91lY3IhxefWz2Q7xIXAkbt/0KzQ/8/9A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793353197;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding:
	 X-CM-TRANSID:X-Coremail-Antispam:X-CM-SenderInfo;
	bh=zOMWdRYZ72p10sJ4dbOah+fIXgGE+K9ZB0ijg3sy0YQ=;
	b=mJjAe/LPra5MjQtsnRoMvqc3HAjgiq26ezl1o4XyNyjxsr2FaqOt+V8/I3Q5OdUvtRgM
	 m0Yn9Ee2ntzrPLYD2881C8kGpOmIcsiL8JKKxZS1LYLmyDY34ZH+Yj8jX5msfljMoJu4N
	 RauyxgOehnMvRaL9GQ7et0OUPW/OZoEK5Rq4NqwLR+mtw7mbZjAdZypenx1WzmrJcAiUK
	 pAzSlOBE/ErufQR05bteldZRZVj1HuB9rGNZ2sWI0C6ho5WP7+mqTotX4IlnBvwmFWlVe
	 pI/qlHF3fxjDNTUwF//Ax8A97ZfiYVKC2rnS8Y4ELjZNmD3uDazrUZIxoGOvzYuG01Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=yeah.net;
	spf=pass smtp.mailfrom=yeah.net;
	dkim=pass header.d=yeah.net header.i=@yeah.net header.a=rsa-sha256 header.s=s110527 header.b=dZhKe9z3;
	arc=none smtp.remote-ip=220.197.32.19
Received: from mail-m16.yeah.net (mail-m16.yeah.net [220.197.32.19])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF204606A31C;
	Fri, 30 Oct 2026 09:39:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BF204606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yeah.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yeah.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=yeah.net header.i=@yeah.net header.a=rsa-sha256 header.s=s110527 header.b=dZhKe9z3
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yeah.net;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=zO
	MWdRYZ72p10sJ4dbOah+fIXgGE+K9ZB0ijg3sy0YQ=; b=dZhKe9z3niOR/6rcF2
	hYCkNiH/ufb7i+lfbmzUzv1pT3TLTegypO1sKL/vvDf9QDwVog4Y9aHnHAlCaIEV
	J/YqAe+xcQOyK9gA7ns+oYld1nT/Z1I8/ml9ro5zdEGDvnh6nhxXCOpUAZPVz/Wq
	UuBSdqkrMZUoRTkt+vuYPQIkw=
Received: from deepin (unknown [])
	by gzsmtp1 (Coremail) with UTF8SMTPA id Mc8vCgC3H4TXZeRqOkrbBQ--.62508S2;
	Fri, 30 Oct 2026 17:39:36 +0800 (CST)
From: Ziran Zhang <zhangcoder@yeah.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: netdev@vger.kernel.org,
	netfilter-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Ziran Zhang <zhangcoder@yeah.net>
Subject: [PATCH] include/linux/jhash.h: fix kernel-doc parameter name
Date: Fri, 30 Oct 2026 17:38:33 +0800
Message-ID: <20261030093834.13043-1-zhangcoder@yeah.net>
X-Mailer: git-send-email 2.51.0
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:Mc8vCgC3H4TXZeRqOkrbBQ--.62508S2
X-Coremail-Antispam: 1Uf129KBjvdXoWrtF43tw4fCr4kXw1ktr4fZrb_yoW3GFbEkw
	4fX3ykZw48CF18Zr40kFZ7tr12gw1xJF18uFn5Jw15t3s09an8t397Crn7tw47GanrCrWr
	AF1qg34fJrnxWjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUvcSsGvfC2KfnxnUUI43ZEXa7xR_UUUUUUUUU==
X-CM-SenderInfo: x2kd0wpfrgv2o61htxgoqh3/1tbiNxhjJGrkZdjEUgAA3N

The kernel-doc comment for jhash() documents the first parameter as @k,
but the function signature uses key.

Fix the parameter name in the comment to match the signature.

No functional changes.

Signed-off-by: Ziran Zhang <zhangcoder@yeah.net>
---
 include/linux/jhash.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/jhash.h b/include/linux/jhash.h
index 7c1c1821c..d320de0af 100644
--- a/include/linux/jhash.h
+++ b/include/linux/jhash.h
@@ -58,7 +58,7 @@
 #define JHASH_INITVAL		0xdeadbeef
 
 /* jhash - hash an arbitrary key
- * @k: sequence of bytes as key
+ * @key: sequence of bytes as key
  * @length: the length of the key
  * @initval: the previous hash, or an arbitrary value
  *
-- 
2.51.0

