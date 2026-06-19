Received: from mail-qt1-f226.google.com (mail-qt1-f226.google.com [209.85.160.226])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7422369D50
	for <netfilter-devel@vger.kernel.org>; Fri, 19 Jun 2026 09:58:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.226
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781863093; cv=none; b=rH5xAHC7QJEXnV7lS18bsjUhKwzh5LsNkymBi4qUHfULvKsXvudLhZUJNw/jye27Z8XaEG5sxxqe75aKBoJVHbgBnDrK4M74zHbbJRSTZ7/PX9BHd77wmhPzEluPKClQupz0UaoKck0up3Hm/XhB+te8VbSvdbPBIodRyvbOf+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781863093; c=relaxed/simple;
	bh=uTQGVxJp6sa5nGg1fan4r/Fv6LYC2ueA0DG3l4AmA8E=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=G3WrH2C+LTlDt4OqlOoq8xmn/jwqND3t72BU1kaId+21dRsT7bbRGbgDNkOzKRxhkVWVtwLXeUwzWSpb/qPdmE2R4qzJ2TFWRJS5diKKkJK4dbuHod/Z3rVc9idxzwDU23ol1Q7eyEFaV051UepPmYfePnjEbmvFTGqs/XA1gUU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=WyIWBXhZ; arc=none smtp.client-ip=209.85.160.226
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="WyIWBXhZ"
Received: by mail-qt1-f226.google.com with SMTP id d75a77b69052e-5176fc0cc72so20957771cf.1
        for <netfilter-devel@vger.kernel.org>; Fri, 19 Jun 2026 02:58:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781863088; x=1782467888;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=K+BCE++6dnn9vpZ/E1d7WFQ8H+QlVa8C9fwXmSQekOc=;
        b=I6sa8QSn6Puf5L/OlZsDMLaIPb1Pplgdz0KbyRUX2XNAiRKSJk7khB3/dL/x+mXSgi
         tKgpTQSp3b9qbkM6y0FcoJY/Rs/gxnIQuTSBoD3ILFE6MLOLbnJWvX9TgAUauhlxY+BT
         rBDjSX8zslDC6jKTLAqoVFNUHXxFwRAIuABcY5PfpR+gJgQxRv3vaSjILObpHh5t7xgT
         6C7IZQHO2kMb9buGe/GHSel5MKuvJtSkEwtLml9i5zULrxZq5RiGTKKJ2VwLC5pCtIhV
         SEvs1BTifvbc9MxeDYWi02SMcGGPjow7LppSARjTPTI9lBk7TfC3gWKTcjl+eadYd2t7
         /A4w==
X-Forwarded-Encrypted: i=1; AFNElJ+QMx8mAq7JrsE7jjpZmbQCD0tG5BfBj1K9SrzfoqrpAp8ee954agrVxdaIdK+tD+IKd8K4PjxLZ0hI/K8Wob8=@vger.kernel.org
X-Gm-Message-State: AOJu0YwGWF6Mx1WCR6y427XVELa82dTJK4vyanKMat1V2Z+U5Cl+Q3jo
	2M7ZIFT3UHwUIhbdFLqsDcqKluiu80r3qP6L8NkcE9ZxOhK+ARK1ZBTNsCDNS9fwa7qAkDdzvnc
	0MCDKh316PtO6+cclkRwIAuDsFU27C0cPgPCRbNCWAjQzvhwU60JvEolm9R7EnSAfl+ucchF7Nb
	hYDax18edd0I9C7aQxG1l9hZto5aoVeLFns2AjY2DKFpyxHweJFE6yXvvdFMntIJcxOKICc0dbm
	IpE2QVjJrYGUEJ14qwoIvhbGQpc8A==
X-Gm-Gg: AfdE7cloXQJIyD/Z5naGF867dsLJ8Kk2j+mXMITvRDGdmwLavUnVqeICmb6RB2fWsOS
	olJf7cZfniA+oXeJ/SlRCWbmVTzTBiNSqprlOGnhJHWkUzn9YRvB5+E1tVGFWxNkP4p1hb1Ef0t
	iSULrPn8F/9SRbteL/edhKeaXhKCZmTK6LCUY8H1JmnxaRxpOflz8yhRewkmlSzQEg2PgJsXtHx
	HaSF/uzLoMruwFVPEiMVCyTQwmHq9Ct1ZzDpJ/RVbY9YdHrBCLVoitt/QOgpzUyflw/paI9AtjK
	RMDMGbvabMklDdfYf2YgqdKloK80uubLoVGZ81pQjMJPfd0hCu83wGOo0FmOFRI7+FyejzXMu04
	8bksMCaD4j++6+LZv6KJ7fvkeJbRBrf9A71Df48IFpqrjrtmrcwwxgvC7FjVjg6yOLrQmU3D36p
	5z8QyIvxc56vQyXPP+llxq/AWrkgjH8JqTqWamNVo9VQmKc2QfHw==
X-Received: by 2002:a05:622a:15cf:b0:517:82af:3d4f with SMTP id d75a77b69052e-519e491b529mr40823801cf.6.1781863087515;
        Fri, 19 Jun 2026 02:58:07 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-29.dlp.protect.broadcom.com. [144.49.247.29])
        by smtp-relay.gmail.com with ESMTPS id 6a1803df08f44-8de60889098sm997696d6.14.2026.06.19.02.58.07
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 19 Jun 2026 02:58:07 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-dy1-f198.google.com with SMTP id 5a478bee46e88-30beab99453so3155786eec.1
        for <netfilter-devel@vger.kernel.org>; Fri, 19 Jun 2026 02:58:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1781863086; x=1782467886; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=K+BCE++6dnn9vpZ/E1d7WFQ8H+QlVa8C9fwXmSQekOc=;
        b=WyIWBXhZupzBFdl1r8dQIqLHoIx7lcpk1uOHh8p4P+6Nwu4tyARNVP9EiDJbIEJutM
         gfH4DdwDV36PILIutZIVEpHgFJaCIvGK2EGhsb+eIeVgsa3cGgwD/NlP95Xssbj4uIIm
         hsjXbBK/xWIusy9F5RbiMiS5rusFFaQM/anY8=
X-Forwarded-Encrypted: i=1; AFNElJ++/lFl/r1jkuG+qTKqZ1k+6nXnmYX7+pdhwxhaCKQXLispIIEcDW/LWIVviKWWS5CXGXyObuK/n/8yb5wcRGw=@vger.kernel.org
X-Received: by 2002:a05:7301:4083:b0:2da:2ec2:64e5 with SMTP id 5a478bee46e88-30c070ee980mr1774509eec.18.1781863086296;
        Fri, 19 Jun 2026 02:58:06 -0700 (PDT)
X-Received: by 2002:a05:7301:4083:b0:2da:2ec2:64e5 with SMTP id 5a478bee46e88-30c070ee980mr1774490eec.18.1781863085710;
        Fri, 19 Jun 2026 02:58:05 -0700 (PDT)
Received: from shivania.lvn.broadcom.net ([192.19.161.250])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-30c06d5bec5sm1851910eec.26.2026.06.19.02.58.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Jun 2026 02:58:05 -0700 (PDT)
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
	Inseo An <y0un9sa@gmail.com>,
	Li hongliang <1468888505@139.com>,
	Sasha Levin <sashal@kernel.org>,
	Shivani Agarwal <shivani.agarwal@broadcom.com>
Subject: [PATCH v6.1 3/3] netfilter: nf_tables: unconditionally bump set->nelems before insertion
Date: Fri, 19 Jun 2026 02:28:50 -0700
Message-Id: <20260619092850.1274076-4-shivani.agarwal@broadcom.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260619092850.1274076-1-shivani.agarwal@broadcom.com>
References: <20260619092850.1274076-1-shivani.agarwal@broadcom.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit def602e498a4f951da95c95b1b8ce8ae68aa733a ]

In case that the set is full, a new element gets published then removed
without waiting for the RCU grace period, while RCU reader can be
walking over it already.

To address this issue, add the element transaction even if set is full,
but toggle the set_full flag to report -ENFILE so the abort path safely
unwinds the set to its previous state.

As for element updates, decrement set->nelems to restore it.

A simpler fix is to call synchronize_rcu() in the error path.
However, with a large batch adding elements to already maxed-out set,
this could cause noticeable slowdown of such batches.

Fixes: 35d0ac9070ef ("netfilter: nf_tables: fix set->nelems counting with no NLM_F_EXCL")
Reported-by: Inseo An <y0un9sa@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Florian Westphal <fw@strlen.de>
[ Minor conflict resolved. ]
Signed-off-by: Li hongliang <1468888505@139.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
[ Shivani: Modified to apply on 6.1.y ]
Signed-off-by: Shivani Agarwal <shivani.agarwal@broadcom.com>
---
 net/netfilter/nf_tables_api.c | 28 +++++++++++++++-------------
 1 file changed, 15 insertions(+), 13 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 15bfdf07c..196ac4e76 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -6388,6 +6388,7 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 	struct nft_data_desc desc;
 	enum nft_registers dreg;
 	struct nft_trans *trans;
+	bool set_full = false;
 	u64 timeout;
 	u64 expiration;
 	int err, i;
@@ -6680,10 +6681,18 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 	if (err < 0)
 		goto err_elem_free;
 
+	if (!(flags & NFT_SET_ELEM_CATCHALL)) {
+		unsigned int max = nft_set_maxsize(set), nelems;
+
+		nelems = atomic_inc_return(&set->nelems);
+		if (nelems > max)
+			set_full = true;
+	}
+
 	trans = nft_trans_elem_alloc(ctx, NFT_MSG_NEWSETELEM, set);
 	if (trans == NULL) {
 		err = -ENOMEM;
-		goto err_elem_free;
+		goto err_set_size;
 	}
 
 	ext->genmask = nft_genmask_cur(ctx->net);
@@ -6715,23 +6724,16 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 		goto err_element_clash;
 	}
 
-	if (!(flags & NFT_SET_ELEM_CATCHALL)) {
-		unsigned int max = nft_set_maxsize(set);
-
-		if (!atomic_add_unless(&set->nelems, 1, max)) {
-			err = -ENFILE;
-			goto err_set_full;
-		}
-	}
-
 	nft_trans_elem(trans) = elem;
 	nft_trans_commit_list_add_tail(ctx->net, trans);
-	return 0;
 
-err_set_full:
-	nft_setelem_remove(ctx->net, set, &elem);
+	return set_full ? -ENFILE : 0;
+
 err_element_clash:
 	kfree(trans);
+err_set_size:
+	if (!(flags & NFT_SET_ELEM_CATCHALL))
+		atomic_dec(&set->nelems);
 err_elem_free:
 	nf_tables_set_elem_destroy(ctx, set, elem.priv);
 err_parse_data:
-- 
2.53.0

