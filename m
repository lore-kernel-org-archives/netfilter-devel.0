Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CEF426AF2
	for <netfilter-devel@vger.kernel.org>; Fri, 15 Mar 2024 17:01:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710522108; cv=none; b=l1kfskFoXgMCaAjsXUNtkRPynPTYBLf14OZkEbCDxbecSWkX20EaL3G8Zna1ljh0AI95hfCgu5sL7TAFTYAgt8dw9IveykJAinRbzoCAftbfPSEGW0CGx39bgWZbfSPcPmbiLJPDPdsa5JtS5cO8hOMYpCguiLb0ZIU2qomImuc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710522108; c=relaxed/simple;
	bh=91fNVfz7iGcd/J0M+pXM00b5OKFpY/grmbF23l38i9k=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=QxRA4s4hWuYhqo834aMZIs2OYxL6E0tetWUDZGsVpjvoZr4IZx4YpxviSPOzKF7i7dIkwDD49bLkJnGCPlKsOAdec7I75nZKbWjWvyGRIxDeaq9mlpxuqGnR5uof7RHTMMjDJPLPxX26uGm8BltFo57QP5KRbfOF7KHi4BPTwzs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=blb9PvVi; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="blb9PvVi"
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-1dbd32cff0bso17585355ad.0
        for <netfilter-devel@vger.kernel.org>; Fri, 15 Mar 2024 10:01:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1710522105; x=1711126905; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ahHNVjYHfp/0dCF1HLyzXdTFUrxvavw5fyc1pNaDUgs=;
        b=blb9PvVivkJ9O0Ib6wpzUSxQDOc6HCLybTXPTknrawJRIfd9FcDLtiACks0KmGDjtu
         Rf+j/mRi0fCObSR9S+emOq9rlhzxaQ12nHyZ90YUzS6yNurPPU/Dquy0ZPf3dbByZ+nu
         tsJ1wAwbWVWVIhY5nqmTmS5LqmSorKH4ynKMFP3nVCRq0bLuXmxxUeenpvybbTpMTmn3
         5ZiQFAUyQUkyTkWUGM/LLvllpYOVsSGKt6KgBz2EuJTWazGEIcfvcwqYYNaW0EpWfsl6
         Cv7UU0OOmTpbf9zDcTAYBz1VW3dz1HNvvJvIhcFI2VlAsDXQ8LBqvxN8+u+M7AyiU2s6
         hxpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710522105; x=1711126905;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ahHNVjYHfp/0dCF1HLyzXdTFUrxvavw5fyc1pNaDUgs=;
        b=JbJhKgoUlk+6/r0a4YViqGcUBfpjhPQ9MnMw1h/51gQc0v15ypN7o64zUgCkfiPDqU
         MBR1Yil4/kRX3vRcX5XwFKSzN+pLiEXfXSuLwwsU2iqfE1/g94fu6ORKXeBX5cLHgxdO
         3aWzhph3YBiZ6hJFq2ebOtUl0N46n5e5DwzWHeyroQeSPyEHIp63u9BOt0Kau3prlome
         nG6hdWCQ2HUWO9AMbY3KNegtHnV/8m9kqCokBq9Gdhq4jlb6QuqX/MbSmnrGmqzOCh71
         Wv05/w4M4YRGDKrUG7LdBflqmJfyrG/5QWtunFP9Nwhc3WNPt6du+tbaQF4jExU+SZxR
         dBNA==
X-Gm-Message-State: AOJu0YytFWDc8AGEQNJHxJ6TG7+fsm3GcxdRxrZp1YtKqnUe7gawyX4k
	zqrlLfoIwgpRWktMRlvWgLIjZvP5bQM1amM/CW6RiBXyzC2Hn7z7l6sA8VMOUvx09p4A2EI=
X-Google-Smtp-Source: AGHT+IEqdyHui6Fiqpb5sfOFerXhyX0xQB59ppWmxoA+KFmyeWdqahAriAatVkwuOTyUd0QNUUx+yw==
X-Received: by 2002:a17:903:2349:b0:1dd:d0d3:71a9 with SMTP id c9-20020a170903234900b001ddd0d371a9mr6751746plh.45.1710522105281;
        Fri, 15 Mar 2024 10:01:45 -0700 (PDT)
Received: from sc9-mailhost1.vmware.com ([114.253.32.130])
        by smtp.gmail.com with ESMTPSA id y16-20020a17090264d000b001dee9d80bdcsm2316566pli.107.2024.03.15.10.01.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Mar 2024 10:01:44 -0700 (PDT)
From: Quan Tian <tianquan23@gmail.com>
To: netfilter-devel@vger.kernel.org
Cc: pablo@netfilter.org,
	kadlec@netfilter.org,
	fw@strlen.de,
	Quan Tian <tianquan23@gmail.com>
Subject: [PATCH nf] netfilter: nf_tables: do not reject dormant flag update for table with owner
Date: Sat, 16 Mar 2024 01:01:24 +0800
Message-Id: <20240315170124.1584-1-tianquan23@gmail.com>
X-Mailer: git-send-email 2.39.3 (Apple Git-145)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

If a table was owned by a process, its dormant flag couldn't be updated
because the code required the table to be an orphan.

$ nft -i
nft> add table ip test { flags owner ; }
nft> list table ip test
table ip test { # progname nft
	flags owner
}
nft> add table ip test { flags owner ; flags dormant ; }
Error: Could not process rule: Operation not supported
add table ip test { flags owner ; flags dormant ; }
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Fixes: 31bf508be656 ("netfilter: nf_tables: Implement table adoption support")
Signed-off-by: Quan Tian <tianquan23@gmail.com>
---
 net/netfilter/nf_tables_api.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index e93f905e60b6..f06b09b32d80 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -1219,7 +1219,8 @@ static int nf_tables_updtable(struct nft_ctx *ctx)
 	if ((nft_table_has_owner(ctx->table) &&
 	     !(flags & NFT_TABLE_F_OWNER)) ||
 	    (flags & NFT_TABLE_F_OWNER &&
-	     !nft_table_is_orphan(ctx->table)))
+	     !(nft_table_has_owner(ctx->table) ||
+	       nft_table_is_orphan(ctx->table))))
 		return -EOPNOTSUPP;
 
 	if ((flags ^ ctx->table->flags) & NFT_TABLE_F_PERSIST)
-- 
2.39.3 (Apple Git-145)

