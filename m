Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 461F72E265A
	for <netfilter-devel@vger.kernel.org>; Wed,  3 Dec 2025 13:21:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764768069; cv=none; b=sfHMjD2m1Ic5TGHva5Y/6XPA6CW0gParPW3eVKztoUeVs7XVc3CyjSHw8JYwjha/Fqmd4sSghfbZFuiWPX7KUFkSjn7AQa1Qzvrmar6jLmNvzfIqMW1iVkFOCPVBJl/LfDprN9v6Kv+RBYW7QwCIhqkBG7DiEvBWYJ5a9++T8Jk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764768069; c=relaxed/simple;
	bh=kXb9EXDI0w6rlp0MQqZEPQpBKY6yd2TMS5PpRbp7jfI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=BhMLTilqsnDfc4gpH3HVjuxDve9RfGnJfZsJsd2WrjJ1g7m6Upn2N5ZrO9o27PB9exXib7aAxHQlKqGBp/QSeH2ZiUNtHFiOd37fYR1PyF3BAjt1/7eMx/vQm6wypH9wVsGqT6c6QnRCjDp4jEo3IvuSYviv9T+6RQ2ndLYyx60=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NnhFXwuN; arc=none smtp.client-ip=209.85.221.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NnhFXwuN"
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-42e2d02a3c9so2897219f8f.3
        for <netfilter-devel@vger.kernel.org>; Wed, 03 Dec 2025 05:21:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764768066; x=1765372866; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Ixub8XFHVSgu8xKWFM7EAHafTMzwTmdJy3P9B7hAoq0=;
        b=NnhFXwuNmhwLaN+lis/q9ciFf+mpYG8Esrv7wdUUghPCdlZMQTVqFgqtKAl0sXURda
         1raQ392fPlFy89izTsUl5z7IvKpVeJoYiOi6LW3NS5c1nuYMMZ+rWIhn8DB8XoN/hSNT
         DBrFh87vwZm6d5Cd9TxrJy8GiL4EgckwLWBfVT7dhrczMXYxwpmSCT8XVZbgzinbv1gC
         xrJH8nCQksVQI12LdbrB81bNc9K3jeRwfvFh6ioehKcwXiJYp/HbvtgK4iO9CbNrOz2D
         p9y2je/P13lreRYmENJWqDdygXhI5cjv0U2FA3Mb6FfAgTOTNcGwou00/lLu9viWGJWo
         q04w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764768066; x=1765372866;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ixub8XFHVSgu8xKWFM7EAHafTMzwTmdJy3P9B7hAoq0=;
        b=CqIG9XTJxA42XikHnpPW1z7Z6pEBFg+vEeUpNXNYP6vawrsTJnWaCBF6IWAwvwmZmn
         zEijnBU7zuoyRmmITAUfeEv1Cy+v7JC1P46n5Ms1gBy8nkbRh0YcXUuV+xWXJFnfxiy7
         7dNAODM2Dft1fWI0s0lzRtaJFqH69ZEQ/hElkpM84Mi6rt6TE3CA/Ofzi1kNG35EHDya
         gLDfEDNbRUMKnRSIzEFi1KEZPadrP0df1QXZkxP3a16HdxgK9BJUGIMbUb/dk4QmX1kq
         UeEhe0eNUHzq6bKBkvT85HK6nGKPzgUTj4u/1PBrYe0vDsY7I3qMXy0SyrEvzG1PLLq5
         UMGw==
X-Forwarded-Encrypted: i=1; AJvYcCW8OUp4+itBXDEIt9auEjkVU6ZJ9SdvTaVjPYOTRZ4f5l9SnQ590yQ/DhTz7MPPZdIiWH4rvBCERE7pUH2CKAM=@vger.kernel.org
X-Gm-Message-State: AOJu0YyrjX3KY0two5oH+B4+lFTuXMuZudb2Fhm8nJhU1LGU6zM33/mw
	FMod8xIz+7fJLxoyvwYyyjVYZhPGpTaP6FtN4s9IqQUevSC/ivwSKAB6
X-Gm-Gg: ASbGncvN8wNPJa1pBRNfnlG4wx+5Jo0ltOD0tLcKIW0Q9TFyydhvYxGsjSyo0e/rVZG
	WR2ca2vtH63CtVL9xJWKI3qJEupgrgACEfm4PE4ux/JUSdeCozoZtXcYf6ouMsKh0SyOtAZLFQ+
	+uTBap1T98RwtAh24HHIlx7yVzcHrIxtZxiedg1gd1XaZoslzn/jAmrJSif3Wsdd/O3OiZwwIM3
	irhmO22UEwnkn3nko5R+5MIETBhGIqXs/nKQ509SM59Hg3Oyo8JG8djyCi0zE/Ig4HhyOqOf8WJ
	koYSvzuAwLLknVswsyLpe8qtvmlq039FCVM9BLDvCFOGxuZt1QZ1xBzYeQNd+Dw3jXilmOdB8eO
	6MPYtSubmM8kV72eNsMPKfESqQ0sf1J5yLqxnUcL8vW0Y9LGzobIiZ72yevdWWFuGwirCL0a8js
	GsNg1uKfIwn7lNSeKYPZD5CBNd1294vGQrDhSJWhFuhqV14947ZPkdr6LK
X-Google-Smtp-Source: AGHT+IE4AeJ6aS7oH/n2k7/ppuOBNMDGhlZaf+A0cMgyYi7/c9LKJwGBVEPpcxhM5VTn/A1CjTFe7g==
X-Received: by 2002:a5d:588b:0:b0:42b:3746:3b85 with SMTP id ffacd0b85a97d-42f731c2ea0mr2446622f8f.45.1764768066307;
        Wed, 03 Dec 2025 05:21:06 -0800 (PST)
Received: from osboxes.. (108.228-30-62.static.virginmediabusiness.co.uk. [62.30.228.108])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42e1c5c3022sm39923141f8f.4.2025.12.03.05.21.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Dec 2025 05:21:05 -0800 (PST)
From: Melbin K Mathew <mlbnkm1@gmail.com>
To: pablo@netfilter.org,
	kadlec@netfilter.org,
	fw@strlen.de
Cc: phil@nwl.cc,
	netfilter-devel@vger.kernel.org,
	netdev@vger.kernel.org,
	Melbin K Mathew <mlbnkm1@gmail.com>
Subject: [PATCH] netfilter: nft_set_hash: fix potential NULL deref in nft_rhash_deactivate
Date: Wed,  3 Dec 2025 13:20:44 +0000
Message-ID: <20251203132044.57242-1-mlbnkm1@gmail.com>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In nft_rhash_deactivate(), rhashtable_lookup() may return NULL when the
set element is not found, but the function unconditionally returns
&he->priv.

Dereferencing a member of a NULL pointer is undefined behavior in C.
Although the current struct layout places 'priv' at offset 0 (making
this behave like returning NULL), this is fragile and relies on
implementation details.

Make the NULL case explicit and return NULL when the lookup fails.

Fixes: c07b3b683133 ("netfilter: nf_tables: add rhashtable set backend")

Signed-off-by: Melbin K Mathew <mlbnkm1@gmail.com>
---
 net/netfilter/nft_set_hash.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/netfilter/nft_set_hash.c b/net/netfilter/nft_set_hash.c
index ba01ce75d6de..9ff25ebf93cf 100644
--- a/net/netfilter/nft_set_hash.c
+++ b/net/netfilter/nft_set_hash.c
@@ -231,6 +231,9 @@ nft_rhash_deactivate(const struct net *net, const struct nft_set *set,
 
 	rcu_read_unlock();
 
+	if (!he)
+		return NULL;
+
 	return &he->priv;
 }
 
-- 
2.45.2

