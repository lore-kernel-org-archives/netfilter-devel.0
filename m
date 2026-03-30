Received: from mail-dy1-f173.google.com (mail-dy1-f173.google.com [74.125.82.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2F9F39C003
	for <netfilter-devel@vger.kernel.org>; Mon, 30 Mar 2026 21:39:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774906777; cv=none; b=LsHJ7kh+6hKzdN7qc7mcmLX+FPVUl8WO+vBOfy8xm0u8eaM46L56no9Tvcf3F2h5c8ifRMhd6k+74cNWCarvb1DEplB6FafQr82QeHTUBljR9cvZ1ze7bBO9kSBuq/BkXpBXtDlYg6X+Dcbgr37eDDTY1QTEGCsVBhF4ZUQFNcI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774906777; c=relaxed/simple;
	bh=w1xV/EUcK7/dYSGBg1rpTrGylAsD+2fDisuaSKCRvho=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qizZkc65v/fwBOx6+RWUFaf1STLElyNUSIUl4+732erPK3QHjeefpUmPWhjq+Ph8ZUsU/Wh7PmSlmsROW7ZsbQHy9nbtKOW2C6dhc8wQnb63HMHPDJEr+8WoRlzM9fxt+Kv8Wu5bFYbg4YH2OiIidJUI7fcuMKg10JlgKPIMqqs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GIXgWO7u; arc=none smtp.client-ip=74.125.82.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GIXgWO7u"
Received: by mail-dy1-f173.google.com with SMTP id 5a478bee46e88-2c17446ba8dso3081617eec.1
        for <netfilter-devel@vger.kernel.org>; Mon, 30 Mar 2026 14:39:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774906775; x=1775511575; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gEZ7uR9Nuo1arrIaibUGqQrfzt6wk555gPSPMF4RGN0=;
        b=GIXgWO7uTK0G+e4o9xW8lr23BgU0gYGdP1GNZlEnYT7x0PGzs4L7I46gIS8MnuiUgi
         4WFjpXKP0YAjhxWVNexE+0e7QPNHhNk3a9Khqpn1NymfPCkv0VAUtjOrK3FnY3ZvSgec
         nXsdTtNu0KE7HKGrhro+3UyhGZnxn7CmvClNh0oPJVJByIfwsea9Bwnrd9ZmZCxKmwqI
         aFY0R7vGDyvpRU3+U828FR0KR1eTbl6jRZ3fgrgWNiBe+B295oUjLbfRuxLBatiJ0rZO
         ftiK77wt6ShXuDcAWzaAN4sop6R6Yfn9vy3ZcBjocxHsAbK8A/RhppwhOoOxWTnJnu+j
         GQAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774906775; x=1775511575;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=gEZ7uR9Nuo1arrIaibUGqQrfzt6wk555gPSPMF4RGN0=;
        b=QgXMX+ERnMjAtvcnTj1fst4lBR9JvKCLixyzi0vUn0XMR3+dWhh9OAR4fYjRoxmGTh
         6sSVinUUtMlJgNztZbm1u18kAhDLsEtWTTJREtJqAkFJUt6U05rw+aOw9IdYsQavqH8A
         dMlWMdnA8B2RJfU2qbV6e9j54TozlZPnOqYUrQ5CWl2OVQzTiflaAbPc9jpxOtoCH6ay
         FIOKmqOaWj6cv4uuIaiqAwhm/HI80Csp2E7zS2jypaOZZS9iYPnGDPWf8Yer1GXVwXD5
         9mZVfhgOdgkBNUzgV14pPCqTYnClh4DIJGUGxwRwWFu7iFklJ6uWLwUsPYUiyQi0BiDi
         4S9g==
X-Gm-Message-State: AOJu0YzONQJaJ2JEHGrl5LdJoLFSkLjI/NA9cx5cImBBqxwlvdZykAAh
	UStEFerJtYAm/YdKYgNQhIcwFMorPeZz+RWcoXuAMWERDB42E78dp6mQV7OmAAeS
X-Gm-Gg: ATEYQzyYkDi+lAIOCOKmLeNrc+sPk4WhwC7GU4LON8RwWJrhfD8WPZtlP8LN3YXYsfI
	uL6efQyNZjGAdNni8FFTwyAeyBlXywYeaPGjOFRtbpz9Z3IHz2rFDfuBFeKFs5ebFEdfSe2dsbS
	Yd9eWzr5CDxkpFWGln1/WFEOb927dou7izbFGrmV/kQKU7/GN3QVuqDn8hOLZ0uh788hRSCRca/
	q/99RktdJSKLd8mVuKvMsNUmbiasA9Q/iObnjvC4c1ZzfQPHFHLCj6J8XdeeqlIZq7oyeYJUlHX
	hQbqY/BluHApXURZ+hkCDSAYcz1uR+wPhiPQafBL+bg9zIQDf1ARU/kQoPEc7tZQeUy8x27X/0N
	B8rU6iAoyuuX1GbKu4Or5Hr+2VqmGAlJnd57d3PAX+JyDzugSyySi6qB9YVxJydXRLrbQIwI/d7
	mdLdLFbj2iZNQsdsTP
X-Received: by 2002:a05:7300:d51a:b0:2c4:e154:dc28 with SMTP id 5a478bee46e88-2c7bd86d7c6mr687652eec.20.1774906774675;
        Mon, 30 Mar 2026 14:39:34 -0700 (PDT)
Received: from homebox ([66.75.253.8])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2c3c6e9ca80sm9442934eec.22.2026.03.30.14.39.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Mar 2026 14:39:34 -0700 (PDT)
From: Yuan Tan <yuantan098@gmail.com>
X-Google-Original-From: Yuan Tan <tanyuan98@outlook.com>
To: netfilter-devel@vger.kernel.org,
	fw@strlen.de
Cc: security@kernel.org,
	pablo@netfilter.org,
	phil@nwl.cc,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	horms@kernel.org,
	zhen.ni@easystack.cn,
	kadlec@netfilter.org,
	kees@kernel.org,
	tomapufckgml@gmail.com,
	dstsmallbird@foxmail.com,
	yifanwucs@gmail.com,
	yuantan098@gmail.com
Subject: [PATCH RESEND nf 1/1] netfilter: ipset: drop logically empty buckets in mtype_del
Date: Mon, 30 Mar 2026 14:39:24 -0700
Message-ID: <d3d1e38f2001ec225344f24e59727299f6a39a7a.1774578045.git.yifanwucs@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1774578045.git.yifanwucs@gmail.com>
References: <cover.1774578045.git.yifanwucs@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Yifan Wu <yifanwucs@gmail.com>

mtype_del() counts empty slots below n->pos in k, but it only drops the
bucket when both n->pos and k are zero. This misses buckets whose live
entries have all been removed while n->pos still points past deleted slots.

Treat a bucket as empty when all positions below n->pos are unused and
release it directly instead of shrinking it further.

Fixes: 8af1c6fbd923 ("netfilter: ipset: Fix forceadd evaluation path")
Cc: stable@vger.kernel.org
Reported-by: Juefei Pu <tomapufckgml@gmail.com>
Reported-by: Xin Liu <dstsmallbird@foxmail.com>
Signed-off-by: Yifan Wu <yifanwucs@gmail.com>
Co-developed-by: Yuan Tan <yuantan098@gmail.com>
Signed-off-by: Yuan Tan <yuantan098@gmail.com>
Reviewed-by: Phil Sutter <phil@nwl.cc>
---

This email was not CCed to the public mailing list previously, so I am
resending it with the mailing list included. Sorry for the inconvenience.

Also, as I understand it, when resending a patch, it is acceptable to carry
over a Reviewed-by or similar tag from an earlier version. Please correct
me if I have misunderstood.

 net/netfilter/ipset/ip_set_hash_gen.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/ipset/ip_set_hash_gen.h b/net/netfilter/ipset/ip_set_hash_gen.h
index 181daa9c2019..b79e5dd2af03 100644
--- a/net/netfilter/ipset/ip_set_hash_gen.h
+++ b/net/netfilter/ipset/ip_set_hash_gen.h
@@ -1098,7 +1098,7 @@ mtype_del(struct ip_set *set, void *value, const struct ip_set_ext *ext,
 			if (!test_bit(i, n->used))
 				k++;
 		}
-		if (n->pos == 0 && k == 0) {
+		if (k == n->pos) {
 			t->hregion[r].ext_size -= ext_size(n->size, dsize);
 			rcu_assign_pointer(hbucket(t, key), NULL);
 			kfree_rcu(n, rcu);
-- 
2.43.0

