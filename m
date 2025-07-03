Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCEF02E7BDB
	for <netfilter-devel@vger.kernel.org>; Thu,  3 Jul 2025 13:57:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751551061; cv=none; b=D3EwUUaEsCLY7TOgc7hOS8LIYTBHrYMi7fLDMIUuHPoPgDbGmer1wJMnrAukrRBQkGJQiunn1gpRvDGUfrbS4S6KPeND6qVBCwnWH0AzzZjRk1F4RP+WjX+K8miFjbhJOdlTDoJdQe8Uro8DPPZzobevbJ3vPvcbmD94yOfDrTI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751551061; c=relaxed/simple;
	bh=7eQfDvRE7ZmXX0N466DQ1N+G8uJoD1H3Y3kpV1WJsYw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=EIED0emag2FBi9guVRFJHdJj64Y0BV7YVuCs5CTp2alPeLP0EIsxWVRYEjJXma50xbUGUbyp5Rle0qYvLUa6kN+Yj/xCMbjnAJMtj+75w2KzKfdgBiItKq43IaOCAfQQzVCjSjiC2l5KJFJciw7cS1OcCmPnpQPg7PbeHrxfagM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Y3zLMswE; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Y3zLMswE"
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-234b440afa7so82619525ad.0
        for <netfilter-devel@vger.kernel.org>; Thu, 03 Jul 2025 06:57:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1751551059; x=1752155859; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=fTAmEybBISnB4GHa/vy+AL0HmvmWpur2BNUAvepC21M=;
        b=Y3zLMswEFaYbAtOHtPE4nY0L05GaVxjD1LgneyWznHvwNLz52HJwctFFLKMuQuP4C/
         wHGYIWvMkj5qRZAJQQAB2u30pi3gBwz0BZKmGJtFagcbAoaC/AB3kPVrMMGkjS7e/TyA
         X5qrsRNbG0DHE84kgQXj1q9C6VL2JJLTVOh++ahqnk/WQyGkRPf6KYqogJI9T2+0XSPd
         aNAprhLgR64aaVICNEYdv4zgKRwg8XLeldgMBgT+tvZ7PvD4ctUlxddsFHqxRHVqNJBT
         LTJLesELHEn1ihe8HbRFdlvURRjTd0H5xty/mdu1GcoJuL+z3ZdxY6SB4suLgR5WY7Gc
         MhBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751551059; x=1752155859;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=fTAmEybBISnB4GHa/vy+AL0HmvmWpur2BNUAvepC21M=;
        b=jB+cAwFgdb7A7RevFuIhWdlXHusKDXDx78ZR3Dp3Sg2TpG7C0Ck9zJVTHqXiigFpvW
         2ttok6ltziLissQffNzPPjWppQDYUFicJ5J6Pn0i1ItuC93VKwPKR7NYdp6s+pWQ1RiA
         0ZsC2mQbJWMfQf9kzgFUcZqVYRa6F9vOvLqGb60Pu/Gj6fKOQi+Z1ReotItOaI830mqn
         sRdFw8lMgJK4H3riFVFZMdG4vNnq7AO9Wan9gVfCbsIZkeqCwkBUJUHrVvoYHz6n4E1t
         gHQcys2gGKP0fNsHIIKd+tQi4viilLVS990twRonbd3uWMqmZCXzvZPyiiwWFcYEvyh7
         DdRA==
X-Forwarded-Encrypted: i=1; AJvYcCXamypg9Tjuw2J/lvH3pH44ILa6XQq3PmcCZJn6+Qt8CYEh6H+vtQTP171eBrXcDnxoTE3gSQewAJd0myZgUY8=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyf3lVj5DJCd/YJLB1C39w4NRqAqkbqwo2iGRPcdGJbGgTA/Xc5
	UKUgL4gi1F74IFzUEg/touccxpjAn2vHRK/F/B2EDCPlNf7lM7i2K3Gs
X-Gm-Gg: ASbGncv80/Ds8iqcp4gYNaBIY/I0c+9L+YnxMWr2qR5Znh7a8nIM5vQ/i1ITQYascmq
	f4+0SJAXNvGLQjad45nsM8A3hNFZKIbEN4tEmXSf84O9T/4mlQ0CiCscRQ/YYqDV8tyQa375Wze
	1jppO2xGJFMNHZwW61PgnrXLqANxxbRus7qesL1dx7ok9gtj29Ah/L0Qc+UAlmPtaO+1bMJm7t5
	ZBkyH+n0ILloZ/X1FS4+qaCYdFXMXoWdeEba1+ozDElkRpptSKQkrBazGs6A240xAFiFzKR/8VM
	V3tYdG3Ef26UOfrvK2r4whkOK2OMJ3Hju3kFfZFsSpSSRovs+CX4y83OM2x5rGOptv0jO+Q=
X-Google-Smtp-Source: AGHT+IFxGI6AqulxJOvlU9i6CiQP8qY6f9PP6joROdQGcP2jttDCnxNixNOo0yv0i8k7aY8ch1JexQ==
X-Received: by 2002:a17:902:d542:b0:224:910:23f0 with SMTP id d9443c01a7336-23c6e5d95a2mr93913675ad.49.1751551059029;
        Thu, 03 Jul 2025 06:57:39 -0700 (PDT)
Received: from A014158-NC01.ESG.360ES.CN ([220.181.41.16])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-23acb2f2569sm163856005ad.64.2025.07.03.06.57.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Jul 2025 06:57:38 -0700 (PDT)
From: Zhongqiu Duan <dzq.aishenghu0@gmail.com>
To: coreteam@netfilter.org,
	netfilter-devel@vger.kernel.org
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Simon Horman <horms@kernel.org>,
	Zhongqiu Duan <dzq.aishenghu0@gmail.com>
Subject: [PATCH nft] tests: shell: use the given NFT instead of the one in the search path
Date: Thu,  3 Jul 2025 13:57:17 +0000
Message-ID: <20250703135717.13735-1-dzq.aishenghu0@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Fixes: aa44b61a560d ("tests: shell: check for removing table via handle with incorrect family")
Signed-off-by: Zhongqiu Duan <dzq.aishenghu0@gmail.com>
---
 tests/shell/testcases/transactions/handle_bad_family | 2 --
 1 file changed, 2 deletions(-)

diff --git a/tests/shell/testcases/transactions/handle_bad_family b/tests/shell/testcases/transactions/handle_bad_family
index 592241890a69..c9a723d7edcd 100755
--- a/tests/shell/testcases/transactions/handle_bad_family
+++ b/tests/shell/testcases/transactions/handle_bad_family
@@ -1,7 +1,5 @@
 #!/bin/bash
 
-NFT=nft
-
 HANDLE=$($NFT -a -e add table ip x | cut -d '#' -f 2 | awk '{ print $2 }' | head -1)
 
 # should fail
-- 
2.43.0

