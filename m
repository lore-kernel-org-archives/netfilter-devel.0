Received: from mail-qk1-f170.google.com (mail-qk1-f170.google.com [209.85.222.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7EC318C08
	for <netfilter-devel@vger.kernel.org>; Sat,  2 Mar 2024 16:08:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709395690; cv=none; b=AUtVjimRREAR40hU7XiSTtl9p7iTtK3tJ6NeZORbh+GMHWG0eISSBnu4OsQFEyu8Qd6wqk7tQF8fivcl9Ez2hnacN9JHO0hOEYqAqAH9zYvA0LhgJQ315SqMY6PHY2CfLu7tfi+Ckk7vNbGPc1OGKBMI0JHTU5RyOr1PH2lVlyc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709395690; c=relaxed/simple;
	bh=1Iy1idfMxR3qu8fVUtwFnOqXZYmuzXmfBR1V24QLUzA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PkDFmES3A54SfNye8IfYHFTLbntS05/yjtScHb6OdPqENjpkq+MSyMvV/EnKtjD61UbNhbPaeG/w8AB5/Cc2wEy0GETFhD6jYCrXekwtMEK5uSjSsAWPSLkJKZ0KRYBwk5QjCy4AIGcFKPRF9gpmHA9QcENVnY9BGOWmXnp83/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HamwdWCW; arc=none smtp.client-ip=209.85.222.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HamwdWCW"
Received: by mail-qk1-f170.google.com with SMTP id af79cd13be357-7872614af89so316572685a.0
        for <netfilter-devel@vger.kernel.org>; Sat, 02 Mar 2024 08:08:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1709395687; x=1710000487; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yCbqzy7fXYXQmFuSvIkT8pTtY8ZEruyNjzozQ12o38k=;
        b=HamwdWCWLYFQGH5h4Ireo0+qZ3tqa/A4FJNSdU5UpkmuE+0yIhfG9ebZ5wViey3byT
         KQ6jCCDhImsobFJIBhetFbP4NP7W+1H9Ok4Imc93rM8kEh95oqgsVkWR10x5+hHrsehA
         mTtva+S8AKzes1uRn8wskv0NPEoQxUhXs54yiPp6QbheMmgPo34XH9o7Dyo0ZhP7R5k+
         lptFCwfxenBfXOQ/NpoHax4T2ICN6R/Z4AueZY8L9X4qfO+xvcHzp5cXna71Dbrmj+7A
         a8ZYx6D8gtG4PCZgW0yZ998uWONfwVoncgq+LaB9GfovSpqND+GO/8jDvgkGN86AqwuD
         K1nQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709395687; x=1710000487;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yCbqzy7fXYXQmFuSvIkT8pTtY8ZEruyNjzozQ12o38k=;
        b=HlPM/Nkz6XM5wL+jVRkfT+acvPPmD2VWYmSngZfIwwUY17dHZxUqnMMBu2YxRq5kfR
         4kndQviHKlCBWh1M5S2RnbfCMNNUonBWZiFUPq+twCX7TmReI1YSbBoVttTst3CJLt4A
         CIrKi739YdqVG1TErzf3JCxYi6bHexEM5c+0hjUMdVVFZMRUkfNqWnUvIQ8Jv1GvIXVa
         9oSpj7ianGKExV0/i6t41iiXQ02yutmQIUUl1JwChtTgvjd96xqL4uBA5hHb95MjJLVC
         0r8RVGko7LOj+DAvpHNp1xfk472qqTmxJLEoYGVmquZo6Mb52cva9z+Xz9B3995sy+TS
         Uhqw==
X-Gm-Message-State: AOJu0Yy/hR3poVCq6QyuHa6l7y+/CjsJxaIWoBbgVHj7z/hOIsdIUub2
	gAhlbaHeGMZPx7QUtuS0qwcZ96qg3fhlu4Qg90sYwwSBo14LW20Tpi1ds/Vj
X-Google-Smtp-Source: AGHT+IEkjgChnhw7N4bdfCubVWX8D6ElGHQ2v7UJwQ5OX5w6aXiypyRl90bdmcjzalGcXDvj1EE23w==
X-Received: by 2002:a05:620a:2715:b0:788:1dbc:7438 with SMTP id b21-20020a05620a271500b007881dbc7438mr1978653qkp.4.1709395687374;
        Sat, 02 Mar 2024 08:08:07 -0800 (PST)
Received: from fedora.phub.net.cable.rogers.com ([2607:fea8:79d7:c400::557b])
        by smtp.gmail.com with ESMTPSA id k1-20020a05620a0b8100b00787c7c0a078sm2666118qkh.121.2024.03.02.08.08.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 02 Mar 2024 08:08:06 -0800 (PST)
From: Donald Yandt <donald.yandt@gmail.com>
To: netfilter-devel@vger.kernel.org
Cc: Donald Yandt <donald.yandt@gmail.com>
Subject: [PATCH conntrack-tools v2 2/3] conntrackd: use size_t for element indices
Date: Sat,  2 Mar 2024 11:08:01 -0500
Message-ID: <20240302160802.7309-3-donald.yandt@gmail.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240302160802.7309-1-donald.yandt@gmail.com>
References: <20240302160802.7309-1-donald.yandt@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The indices of the allocated vector data can be represented more
precisely by using size_t as the index type. The size_t type integer
is used in memory allocation routines and is capable of handling any
allocated object size or index.

Signed-off-by: Donald Yandt <donald.yandt@gmail.com>
---
 src/vector.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/src/vector.c b/src/vector.c
index 0af8db7..fb1014f 100644
--- a/src/vector.c
+++ b/src/vector.c
@@ -23,9 +23,7 @@
 
 struct vector {
 	char *data;
-	unsigned int cur_elems;
-	unsigned int max_elems;
-	size_t size;
+	size_t cur_elems, max_elems, size;
 };
 
 #define DEFAULT_VECTOR_MEMBERS	8
-- 
2.44.0

