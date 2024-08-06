Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 396B81BE852;
	Tue,  6 Aug 2024 10:28:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722940104; cv=none; b=N7/RJGspK3avzZBB/MBwqbGlHYNRlIJ9thOQ9QhG/jT+SNh+xwKlFAL4IvsMbaDZxI5x1exdKN5D+EfOk5vkQixrBRT+R7mU+AO6ZoLlcJTJdci80oMWVVooE1MtBVxZuSyVLU9V6aAAXX8nVnjp/JhpC6LbwuPi6czEJYzQPis=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722940104; c=relaxed/simple;
	bh=EOfE/ebGBtf74dVOWosTb1GOhybI3Ox0SBCawLRaCoM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=DF0GrFZXikv0dssyo6jKyiJjEuDGt70Un0HQ9k469lhHIbekJbMw88r7Z1SHDMdJyEsClQBGa6Hswy9dvV1jlATU2pmNVk7nDou3mSEj/d7uCvo2qIIzjtlOSmoQfvqlg0E55jml+4rZCTtcbDE8Io/TyBfLHzLV/lm7UVw13Hw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=eOF/5z63; arc=none smtp.client-ip=209.85.218.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eOF/5z63"
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-a728f74c23dso55110266b.1;
        Tue, 06 Aug 2024 03:28:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1722940100; x=1723544900; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=UCjUVgAD+QJaA2D+lUO0OlTYuB0Hq3DzdOOGhevVtH0=;
        b=eOF/5z637hf+kH8imK9S7XbQvbFiCFNN01QmcAoUGhRAZp+j0UmQtQqAPfF/zlqR3R
         FLdHVpJK5P0hKcbKc8ZjnBrnqTPauBc9Qv0uQWmvi9o7caUopfn1LYSiitawBDDiz82m
         ppOwieYyj61MQDxkBHRUaVfMEhCE3pP0ErKxiAsXfmigVevlx+MoSO6mQk+fphAS488j
         Ajg/uKlFzvtl7MHCT5zmbvHsQte8HvVvWtemMz/01wvp/iHs1YcH2mMEgFPx9X44lJIW
         kmDJRMAUrCXdqKOth96PXPbKARmNjZtbJveYa4oMn4JnbrjgRn3ZrCeau5KLaQgYLk8R
         6b6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722940100; x=1723544900;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=UCjUVgAD+QJaA2D+lUO0OlTYuB0Hq3DzdOOGhevVtH0=;
        b=tFuOwDKlpGeV+a3/UuOj/SE9TdvMQd/fpFKMJTdgCBBY7QGEtl/I2jxCr1Pw0ig4St
         0NrIiWgpQllybz8kxmxyWp1cjf7HiFEQdr1RIrZiAj5cPFvxM2ixJNPOcI1ceZCbykE0
         Bk91NMJZJ6FOl+iYj5rz06+JxFrirSD0bAk3FN2RWeOJ8ogJ6PO3Ta40ObQlvp0pPa3t
         0Ts1TIjF82swdVij3nDlJ4PlelV3vMBRCKqr8V32d3Zpv0WBI/FxfR1EE1WfobtI5zb1
         8+6UXEkhsX2aTXJD/MEfMeztACIUyM0i4sHsvK/PmEbDcKh3ey2hrEsvcWO1vaHdpRwY
         XlHg==
X-Forwarded-Encrypted: i=1; AJvYcCVUCRUe1wfhzWQCoiXNYkcKCCRNFEzqZ+kKFcwJvNSOxOFU0Otfi0zoIzvDp3rqN+gJU/QGNwtss0w8Jq++Y+RGTJ7y0rOTjyZmkeLKU3a0o0ScgorAKkU9bGqWfDKvwIQHoLGQ
X-Gm-Message-State: AOJu0YwhZGm36tAULoF/fzACuDnbKDuxMQXBpyS0uUrLooIS0U5POSG7
	CbppvifZ0dyxu0m0BY7SWfW/Z74EvEvn6tJWFNqw9/SCiSpeZSC8bzsoD+nd5X8=
X-Google-Smtp-Source: AGHT+IEt/cUUCVUWP3fXZhXdOB0/5qvGanQLCmKshHZRnKBQXnTNEG4+a6ZKjkqhp7eIKZ0+DtFK5A==
X-Received: by 2002:a17:907:c2a:b0:a7a:c106:364f with SMTP id a640c23a62f3a-a7dc506c508mr1081841366b.43.1722940099279;
        Tue, 06 Aug 2024 03:28:19 -0700 (PDT)
Received: from fedora.iskraemeco.si ([193.77.86.250])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a7dc9bc3d09sm541145166b.17.2024.08.06.03.28.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Aug 2024 03:28:18 -0700 (PDT)
From: Uros Bizjak <ubizjak@gmail.com>
To: netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Uros Bizjak <ubizjak@gmail.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH] netfilter: nf_tables: Add __percpu annotation to *stats pointer in nf_tables_updchain()
Date: Tue,  6 Aug 2024 12:26:58 +0200
Message-ID: <20240806102808.804619-1-ubizjak@gmail.com>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Compiling nf_tables_api.c results in several sparse warnings:

nf_tables_api.c:2740:23: warning: incorrect type in assignment (different address spaces)
nf_tables_api.c:2752:38: warning: incorrect type in assignment (different address spaces)
nf_tables_api.c:2798:21: warning: incorrect type in argument 1 (different address spaces)

Add __percpu annotation to *stats pointer to fix these warnings.

Found by GCC's named address space checks.

There were no changes in the resulting object files.

Signed-off-by: Uros Bizjak <ubizjak@gmail.com>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Jozsef Kadlecsik <kadlec@netfilter.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>
---
 net/netfilter/nf_tables_api.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 481ee78e77bc..805227131f10 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -2642,7 +2642,7 @@ static int nf_tables_updchain(struct nft_ctx *ctx, u8 genmask, u8 policy,
 	struct nft_table *table = ctx->table;
 	struct nft_chain *chain = ctx->chain;
 	struct nft_chain_hook hook = {};
-	struct nft_stats *stats = NULL;
+	struct nft_stats __percpu *stats = NULL;
 	struct nft_hook *h, *next;
 	struct nf_hook_ops *ops;
 	struct nft_trans *trans;
-- 
2.45.2

