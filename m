Received: from mail-vs1-f98.google.com (mail-vs1-f98.google.com [209.85.217.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCEC43822A9
	for <netfilter-devel@vger.kernel.org>; Thu, 18 Jun 2026 09:03:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781773431; cv=none; b=YANkbWZnl9m3rPXGGqeH39t67xhvIocYp36tamdZ9fPXF7Wvb0TnDZ0QgZPMRPnDTtceUSLUM6BIJH9f4x9khsK2aYAAgZjcKqw0Wph8qbY7xcDGKfIcvW5DLkIUce/l7Q/cVZHSt2qMyUtoF33zdbybQOVu4A//CdmFpoZ9Is4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781773431; c=relaxed/simple;
	bh=pDfYODN8eSb3Osdiy8pGUbcCjj+Vd5hRyuhJN7tkHGY=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=l+ehOR+LTCFJd3yO1LwHmBlap8wTN/YyhrJ9goCp2LfegQKaXsWrNdASt61NlBn0gX22CkDWveNSqPMT5KZZuvELvtRVuAjTkYlzgIjr9MwU6eB0QPEj1NvAxWXkiYQHaN4WePBFOybLb4vLw3M82wOs4ntQftNp1CbPHeqMqNc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=Dr/Ydqrn; arc=none smtp.client-ip=209.85.217.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="Dr/Ydqrn"
Received: by mail-vs1-f98.google.com with SMTP id ada2fe7eead31-6c6507549c3so1553423137.0
        for <netfilter-devel@vger.kernel.org>; Thu, 18 Jun 2026 02:03:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781773429; x=1782378229;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:dkim-signature:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QpNixvCXNM3odqaYWueSGP2Z43EAIlNiUuWGIkEd9i8=;
        b=Hb1rTDznU91bOPRoXFq4dR4SK5ECK3rhtvOdmiv4oJUEaXkDmX+yuf3qrAT6F14V88
         B6bsTSHxaiW5ugDcVY1b30ImEThgWIxyr/7bRQ4Uebaarvacpl11T/cNlym+8Z6S0/rY
         xB9gdyvzWuL1Cg4iRH5QRm8XtA1/4F+63LYoqg6LjJTAWjAWlmWj4IM3/4rYOUbl+xw7
         4hd3FJMyQ3TJXzLBt8Af742yeJ4klRrwauQMD6MaHfTK1wBxQ1VecGOmaM73H2af+7lK
         6eUqw2smH/TsbUEwKP2Kc6riH46iOtjx6UX7/mJOvo7WSCP5RM9qrkEaAzZnVdAbmJk1
         0kyw==
X-Forwarded-Encrypted: i=1; AFNElJ/StZe9mD7AKPcEziD67r0hYYnlqDXY5tnow28lNGRFNL3ndc23dC/iCZ+y/hgPkXUaSHYOM9rhhQ+poth3Xv4=@vger.kernel.org
X-Gm-Message-State: AOJu0YxB1Fvl7RtzGRbkWai+x+uPLVCeDvW9UE1PeJZSOkSeTEDkR6U8
	K9JSzKPrs79bG5KjEK5OmJnoS41ruDMtwDwctvjPMbQAKnnibcfyiNCH6ff9fdZI/posz64ytwE
	V1D/YsjWydImYs9RO2UohDugkPnCp0Fs7FLtcS6UTnZOuThYe0Y6Ur6RGY+0xGbB4JzOjEjv+71
	8bhBn42HzEtoWJYA9gSEe6lXIt0ERkXkokPmarlqX841Pejtvwc9yW2P4newmAdeGwfrRh413q8
	QD4Us5RkuL8Ej7+7HQ90tI+fasPDQ==
X-Gm-Gg: AfdE7clj+C8aYqv4bq+kyg7Js6S/7FJFksKPU0W69O1B/80kM2B4xpCL5L1g8M/Ifi4
	oFYP++tI6a7UmQHEdYWt7MynyP4Dc70nEhz/4isw/oXZwGvVm6g9ug8UEEQ8U5DWYx0HpA2xzOV
	IvE/3SuP/UT9JYrZVpzlN3jve/qYFkTHIEEigPC2bMD0Le4v0zZRCXc2r2ihIYS4B5Vazb52MEs
	1KzBa+sExIZFRYLfmcDbiBkO4V+2dR645dXnv/po1USLH8H9LJDqr0L2sV2anYehmkt5NOJk10L
	HfbuwyGZZlqWln1AqRbN0W7SPFzznqULcw0fndCaUp4Ygp8TMhYxYepFFnxeyLbgVZlGcH0i7dE
	6B3VKJvyYF3kkHcC7o9HHfatStg5rkjntBEd46NFiwsyLS5A+X9PlJUC6MRyO+5EH3+DnJmI/rK
	l0ZqgdUlMlBQubpOWdJ9Lu8KwXdPmR8QYK0ijaS2UafnvDD/x1N/CA
X-Received: by 2002:a05:6102:358d:b0:634:92c:bdca with SMTP id ada2fe7eead31-727b3a02018mr1261590137.3.1781773428573;
        Thu, 18 Jun 2026 02:03:48 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-117.dlp.protect.broadcom.com. [144.49.247.117])
        by smtp-relay.gmail.com with ESMTPS id ada2fe7eead31-720877819b8sm915441137.25.2026.06.18.02.03.48
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 18 Jun 2026 02:03:48 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-qt1-f199.google.com with SMTP id d75a77b69052e-519851d4973so16774601cf.1
        for <netfilter-devel@vger.kernel.org>; Thu, 18 Jun 2026 02:03:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1781773428; x=1782378228; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=QpNixvCXNM3odqaYWueSGP2Z43EAIlNiUuWGIkEd9i8=;
        b=Dr/Ydqrnwbh4TDAFnHL3FK7c9/Rv/ES8ODcuQahihVpAlAZWYGJb3gyzyybRI8NjpO
         YBBOLM/1Gt6yBlv/pDpl6C8fnEnql4CCMW5USxOQU4nFITglkckgSy3hqJkJscqf7MYj
         rlnjuWlh4EKQsZ6SmByMvOUMijYrOV5j4x3YQ=
X-Forwarded-Encrypted: i=1; AFNElJ+g3cmnZ7FVy3uF5dZr1kpU6kUSXLQ1v6OZlm4fjumf39iyDfJW8XwQ6Qe+oeQsabjo0KsgTgYcngfW+Pe2/3A=@vger.kernel.org
X-Received: by 2002:a05:622a:22a4:b0:517:5ed7:d28f with SMTP id d75a77b69052e-519c4de0e85mr37505751cf.25.1781773427824;
        Thu, 18 Jun 2026 02:03:47 -0700 (PDT)
X-Received: by 2002:a05:622a:22a4:b0:517:5ed7:d28f with SMTP id d75a77b69052e-519c4de0e85mr37505371cf.25.1781773427211;
        Thu, 18 Jun 2026 02:03:47 -0700 (PDT)
Received: from shivania.lvn.broadcom.net ([192.19.161.250])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-517fb61eaf4sm191285561cf.4.2026.06.18.02.03.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Jun 2026 02:03:46 -0700 (PDT)
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
Subject: [PATCH v6.6-v6.1] netfilter: nf_tables: always walk all pending catchall elements
Date: Thu, 18 Jun 2026 01:34:38 -0700
Message-Id: <20260618083438.1269242-1-shivani.agarwal@broadcom.com>
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
index 196ac4e76..0581f6479 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -620,7 +620,6 @@ static void nft_map_catchall_deactivate(const struct nft_ctx *ctx,
 
 		elem.priv = catchall->elem;
 		nft_setelem_data_deactivate(ctx->net, set, &elem);
-		break;
 	}
 }
 
@@ -5241,7 +5240,6 @@ static void nft_map_catchall_activate(const struct nft_ctx *ctx,
 
 		elem.priv = catchall->elem;
 		nft_setelem_data_activate(ctx->net, set, &elem);
-		break;
 	}
 }
 
-- 
2.53.0

