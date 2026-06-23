Received: from mail-qv1-f99.google.com (mail-qv1-f99.google.com [209.85.219.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69F423A960F
	for <netfilter-devel@vger.kernel.org>; Tue, 23 Jun 2026 06:43:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.99
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782197011; cv=none; b=hNNoGou3DdTgg/iJ2cX9Ws0yLuN0XEpVnzupFhc2UrN/TOVdhInSUMVJI/MtxkK7H8hWwXmbwoZaOqTOObUXoB4sLBZy+1BNwZXaUZCjxOSf0iQtUYGjHQ4rUUc/6KkDN1tMU1y7Lh9Vr1JgXcqFysSmmjblBWw9UaB5zFe5OP4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782197011; c=relaxed/simple;
	bh=hwdcxQZyp1DiMpjzaka9N2DHGUC+C3QJjPD7Z9vvutk=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=O6Sh7eqH+9AWAMbELy1OWIIXDGHKKKastkty4ZMpFiJkJ200Z25/ATupjGtjCIayrWcxhu84UwoB890agsFCJ65xc4qeRrP7TxmvZ7Yx09cirfyimk6QWNR9Ict6ICq+ENkxvRy7JaAFTi27PacYQ/2UBSCDhzuYmb4rYRNsszo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=PBUsv3iF; arc=none smtp.client-ip=209.85.219.99
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="PBUsv3iF"
Received: by mail-qv1-f99.google.com with SMTP id 6a1803df08f44-8e3d22c38a8so6594696d6.0
        for <netfilter-devel@vger.kernel.org>; Mon, 22 Jun 2026 23:43:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782197009; x=1782801809;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:dkim-signature:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fy4aFh7UcrzBTSJogToF7QAZLN083cdJaTVBVx/OKCs=;
        b=kTMZU6UdSxAXKpHbWYChY3HJqIXSkBrh9PIUU5LIFQ46FqG0cGY2RBUBjuIeTaex/W
         KFvRQygI0Rl6IANxjGDuzLKbUgCB25ZiD731ZFBriI6SeMUifIDAHUYKBQNSoC4Ye7R6
         MyAW+MWEfrygxX0UyzRr9av/rPkxHV+eUoxdJoF0wFvhjPTI1iaNwDO1639ReJF/e/YJ
         UDZHNM7T9AFeacePlDAoGPq2+HQHhY/SkQstyayTc0kB6wFHNfEIf/PCNpIF9O+EoXus
         u+tbKYcG4G2QAkAkmJwpjlyOJLqbcnfL6YAJuCorDH8tS0W2HnIkNkjz3PKO9NW90/WC
         Ym+w==
X-Forwarded-Encrypted: i=1; AHgh+RrHbKW4V6z8+/rlFfTl0ewB+bYjd3N64HFipXZ9yYIRiF7OfS8cWH/wULPhl+b7pKeioqj28YrBI5VlXnWDaAA=@vger.kernel.org
X-Gm-Message-State: AOJu0YyGftrbzAKUDW/wHuhI2ugHMjuynR4RBPUktMVztJOa1xLurIkB
	Jid0UQctV4ZWlTypRESCTr66+ZUF4zYINCa+tCKDTgyr29bBc4D+WcWN9Y//D62B4iyiDLL+uot
	UrUHcWxrzNjOQ9d353ykTku3VmHdxPn4vRFVs3UvKfJ4qo9mk2waLiWa033oJbmdt3Pm4stGUG1
	toRR7UT6sc2fNaMdgQlJhucq8OgLtdvpKFkt8bK0ItinPQ2fj609cUfG+mLfhIyw9oshZy8uH4d
	RK/ZGU93H7NAcE7bK4hnjDOklDdxg==
X-Gm-Gg: AfdE7ckdMrYMswq6nr9+o3Ep9w3OFk9IUw1W/3QRLnu4wZQgGjDjCxFluTsnBiKxXqK
	p/PtB+nYvHN05m3pHAN11sS9LGRuWPodQhMa4ejCFur1Y2VqMMGLOxHn2GejPeMiESZOptEyXWD
	lRcSQ14JD3gWZTC67VGK7grGB7esEffNK0Ur6GZEhCUXdsEwGg2/l/CaTZpt6XKItFNtR7UMhEa
	XZ3oYPf3ocVevoSbY/G3LmZIX+9J07YgHVZrvT4eEWbLFXRoVL/3ESnkdqkQbA51i+SHFXjMKez
	c/QCoaNDQRW3Lx+QlD86/AnZMEBKk+gWhjfFaHo4vGYFi3VFRmbTcAJqETDMOcWwlmppC6cx3Yv
	e9G4JJon+a5iWfG/2F40Tna2XVkZOBWgTm8lQdRRp0RgDh2+p4H1Dsp5ekBqZQzBfZF0a1RfrE8
	m8lbgBUVgsMQLWqTF8i9P6M5eqWzmBeuVNhqp9k2CdwNsefAHOuw==
X-Received: by 2002:a05:6214:27c7:b0:8db:d4f1:f12d with SMTP id 6a1803df08f44-8e4008293a8mr28562716d6.6.1782197009334;
        Mon, 22 Jun 2026 23:43:29 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-23.dlp.protect.broadcom.com. [144.49.247.23])
        by smtp-relay.gmail.com with ESMTPS id 6a1803df08f44-8df8304266csm6922596d6.25.2026.06.22.23.43.27
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 22 Jun 2026 23:43:29 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-dl1-f72.google.com with SMTP id a92af1059eb24-138156c0492so4707125c88.1
        for <netfilter-devel@vger.kernel.org>; Mon, 22 Jun 2026 23:43:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1782197007; x=1782801807; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=fy4aFh7UcrzBTSJogToF7QAZLN083cdJaTVBVx/OKCs=;
        b=PBUsv3iFQzf3S16YaoJvUl7nxLpID7JZ9ISmn2WvvFZh+EBUUVUpEIzpcmA1zD5Msu
         yJOGoFNuNknIZKcfa3L+VJd7gPym/NDiWS7Z4MOxQN9evuTOw+7ozPFU1mRFMnwGAE+n
         u2fnAvTrdUufJVeCfIChacn4jkY2L+dHBFmYY=
X-Forwarded-Encrypted: i=1; AFNElJ877Gb1VH28jHaQBQRaMKvOU6pwXpuOorcxf5E/TghxWTEVyk5n8MBk5XaG5IoocFw8m3tfXyv3HY8dJqJiLm0=@vger.kernel.org
X-Received: by 2002:a05:7022:69d:b0:138:267:af4a with SMTP id a92af1059eb24-139c5cdad1bmr1260122c88.8.1782197006835;
        Mon, 22 Jun 2026 23:43:26 -0700 (PDT)
X-Received: by 2002:a05:7022:69d:b0:138:267:af4a with SMTP id a92af1059eb24-139c5cdad1bmr1260089c88.8.1782197006208;
        Mon, 22 Jun 2026 23:43:26 -0700 (PDT)
Received: from shivania.lvn.broadcom.net ([192.19.161.250])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-139adcb7aabsm13598321c88.5.2026.06.22.23.43.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Jun 2026 23:43:25 -0700 (PDT)
From: Shivani Agarwal <shivani.agarwal@broadcom.com>
To: stable@vger.kernel.org,
	gregkh@linuxfoundation.org
Cc: pablo@netfilter.org,
	fw@strlen.de,
	phil@nwl.cc,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	horms@kernel.org,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	ajay.kaher@broadcom.com,
	alexey.makhalov@broadcom.com,
	vamsi-krishna.brahmajosyula@broadcom.com,
	yin.ding@broadcom.com,
	tapas.kundu@broadcom.com,
	Yiming Qian <yimingqian591@gmail.com>,
	Sasha Levin <sashal@kernel.org>,
	Shivani Agarwal <shivani.agarwal@broadcom.com>
Subject: [PATCH v2 v6.6-v6.1] netfilter: nf_tables: always walk all pending catchall elements
Date: Mon, 22 Jun 2026 23:14:04 -0700
Message-Id: <20260623061404.1288986-1-shivani.agarwal@broadcom.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e

From: Florian Westphal <fw@strlen.de>

[ Upstream commit 7cb9a23d7ae40a702577d3d8bacb7026f04ac2a9 ]

During transaction processing we might have more than one catchall element:
1 live catchall element and 1 pending element that is coming as part of the
new batch.

If the map holding the catchall elements is also going away, its
required to toggle all catchall elements and not just the first viable
candidate.

Otherwise, we get:
 WARNING: ./include/net/netfilter/nf_tables.h:1281 at nft_data_release+0xb7/0xe0 [nf_tables], CPU#2: nft/1404
 RIP: 0010:nft_data_release+0xb7/0xe0 [nf_tables]
 [..]
 __nft_set_elem_destroy+0x106/0x380 [nf_tables]
 nf_tables_abort_release+0x348/0x8d0 [nf_tables]
 nf_tables_abort+0xcf2/0x3ac0 [nf_tables]
 nfnetlink_rcv_batch+0x9c9/0x20e0 [..]

Fixes: 628bd3e49cba ("netfilter: nf_tables: drop map element references from preparation phase")
Reported-by: Yiming Qian <yimingqian591@gmail.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
[ Shivani: Modified to apply on v6.6.y-v6.1.y ]
Signed-off-by: Shivani Agarwal <shivani.agarwal@broadcom.com>
---
 net/netfilter/nf_tables_api.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 201e2cc04539..3de8895bb991 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -627,7 +627,6 @@ static void nft_map_catchall_deactivate(const struct nft_ctx *ctx,
 		elem.priv = catchall->elem;
 		nft_set_elem_change_active(ctx->net, set, ext);
 		nft_setelem_data_deactivate(ctx->net, set, &elem);
-		break;
 	}
 }
 
@@ -5243,7 +5242,6 @@ static void nft_map_catchall_activate(const struct nft_ctx *ctx,
 		nft_clear(ctx->net, ext);
 		elem.priv = catchall->elem;
 		nft_setelem_data_activate(ctx->net, set, &elem);
-		break;
 	}
 }
 
-- 
2.25.1

