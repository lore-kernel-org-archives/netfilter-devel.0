Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DF204963DB
	for <netfilter-devel@vger.kernel.org>; Tue,  9 Jun 2026 16:36:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781023011; cv=none; b=TfQ4L6D3FG2asb/woGhEuiRzIaEGJ6gFKApAZv37P6YP9ADW9f9jeNr26fqNZfakQiinoPjcDweeZuzJxi3phK1P0FePddqDXKouZNEY0Kd+Hx5PTcPzOyuzxcc0oTjo+USxcf+jg4ZssyTQoxcw8vsDSnZpALx8uymoEp6JDYw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781023011; c=relaxed/simple;
	bh=OGLH7jXzbsIii2mYqUyRub3wuJrPU46nL/mOrml4hmM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=U5GO0XcuITtHc56fjgtiaYX43QgS0S38T43xhiy8v9hPBKle3IWA78WBaVSp6zE2ihf2nso1nSmViu0kTx4HQzOqu5a+axKfb9F5egK5VdAZEmgoGjPBJugp/EUjcaRcQ/JsbUO6wZJJ2l8WUTzpLcBtPz7ZZlzB/pDODKY1+TU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=AesH0hlr; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AesH0hlr"
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-490b2b037d2so50784015e9.3
        for <netfilter-devel@vger.kernel.org>; Tue, 09 Jun 2026 09:36:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781023009; x=1781627809; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0Jw5k2pr2Uxq2pN8ORiGv1jSaTS+XZ+Vd2/C3ba/TNc=;
        b=AesH0hlrNI4zuNY7MldHwTG7877NnkNAZROvw162aPqOqaVVFA1rLFvghGU0TDOC03
         9Oz4HseUfeqETnGyxY1C4uak+1jgawJtkB62iKxoB+zHScI1Q/hcoN+Twso4VuLwXXMV
         7Cq+t9U4Xr9JYLcn7TetbDFKG+ReiIYvvTwLtp1ViTloejjXWrZSpefYm8k4izUbzk1s
         omS835SlP8HXnosRDyHu94p19HalLfCtJ33sQPV0HQiszvrutnlrAaBBDerUUTeDtaio
         AeSzEQpZDzg9Qu3AuTQrK9H8CRuJjepAXfsNJOlnPa3hfQPVCJpacN7QcRGfS8RdczEv
         /oJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781023009; x=1781627809;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=0Jw5k2pr2Uxq2pN8ORiGv1jSaTS+XZ+Vd2/C3ba/TNc=;
        b=UWcCDeqSuUsV3hOWO5S+nGiXiJIE7QtSgenCFB33mEAhqXd/V84n9laLxVkV3TdGq0
         8+xd2WeeUK6vMej0NJcKh80BTAOI6RcrFhKnbug6CKgoktuaer4Vc9VjfMb7teg1WCXM
         W0oFCA7g8o5LtRGgOfy8isvWRtRSQSt3mr9c+UhA26LQ56x3VXM2Q5fvoUMVkvkENp1h
         QegD6ExNWPTgZZhbvOFCG5XQ2mt0mcZTz88S6jEfHSbbSFbsfKu22XHTlIxRU8fDTGzB
         jg1FCDId28m6QViKf/zhO/RbVQXc6tjwcqC2C1RSVEv1wUJPy+BA/Bi13dTy5sOzp8yO
         vz5g==
X-Gm-Message-State: AOJu0Yz3Wo20gzW7xVlX9oPrwH9gvD1WVfaXEGBkUOBE7FY0vete3TlG
	ZVXZm3dZ8uAkC/MyRZE+O73GXGHVVzLZlj9yTEtWo59LNJ94OjcHypFjG2+YSCtLbyU=
X-Gm-Gg: Acq92OH20O4QFRlQPgFL237KFNztqZaAHyC3cO9cUraWcU/IXtFgm3d5M5QnFxHP7eD
	Z//ZXu0N27dz0gVQCKMKzuPyiOUcdl3N9z0z8gaaMcnPR7fmjKpogeOuRKiowvbT/aX5AdPZGKr
	BDC2DyJsquDViioj6vnvfJBpHKoj4cil/NWVgJXt/v736okm5uB4y/omekJuzx+tqMQ2wRZHKGW
	2oxEAGKj6jX1/j47crJYG2+eispH35N2hzVDMQzvEMvCT0alEF3vU9w5Ntk1MMMAGvY1R5xZH7k
	yjLHkgOiMIaWS/BUISWs1srBL79Mh1kC6J88o57GKwxZ6xfkE17sTXRqory8ExkClsDQ6qjqyvU
	2qYoLDpehv9tG+DPyY8pvGv0qJIalNehtSDx0qkFPra1f1+0G5tZncfXo2C63G29hvre9/+9CeA
	rKZKEG0dfe8C8douj/GYDV+6iDFJNXZj1Xg4fKalBxEmL0+zdXZdul8JhKVZi2dBhUuaPrBQrbi
	NoaMcoC9A==
X-Received: by 2002:a05:600c:34cb:b0:490:4b89:5361 with SMTP id 5b1f17b1804b1-490c25afa03mr337809275e9.7.1781023008696;
        Tue, 09 Jun 2026 09:36:48 -0700 (PDT)
Received: from manta01.. (host-85-36-215-182.business.telecomitalia.it. [85.36.215.182])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-490bc3b5b06sm449114015e9.3.2026.06.09.09.36.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Jun 2026 09:36:48 -0700 (PDT)
From: Davide Ornaghi <d.ornaghi97@gmail.com>
To: netfilter-devel@vger.kernel.org
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	coreteam@netfilter.org,
	Davide Ornaghi <d.ornaghi97@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH 2/2] netfilter: nft_meta_bridge: fix stale stack leak via IIFHWADDR register
Date: Tue,  9 Jun 2026 18:32:15 +0200
Message-Id: <20260609163215.1102215-3-d.ornaghi97@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260609163215.1102215-1-d.ornaghi97@gmail.com>
References: <20260609163215.1102215-1-d.ornaghi97@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

NFT_META_BRI_IIFHWADDR declares its destination register with
len = ETH_ALEN (6 bytes), which the register-init tracking rounds up to
two 32-bit registers (8 bytes). nft_meta_bridge_get_eval() then does
memcpy(dest, br_dev->dev_addr, ETH_ALEN), writing only 6 bytes and
leaving the upper 2 bytes of the second register as uninitialised
nft_do_chain() stack. A downstream load of that register span leaks
those stale bytes to userspace.

Zero the second register before the memcpy so the full declared span is
written.

Fixes: cbd2257dc96e ("netfilter: nft_meta_bridge: introduce NFT_META_BRI_IIFHWADDR support")
Cc: stable@vger.kernel.org
Signed-off-by: Davide Ornaghi <d.ornaghi97@gmail.com>
---
 net/bridge/netfilter/nft_meta_bridge.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/bridge/netfilter/nft_meta_bridge.c b/net/bridge/netfilter/nft_meta_bridge.c
index 7763e78abb..219c406802 100644
--- a/net/bridge/netfilter/nft_meta_bridge.c
+++ b/net/bridge/netfilter/nft_meta_bridge.c
@@ -64,6 +64,8 @@ static void nft_meta_bridge_get_eval(const struct nft_expr *expr,
 		if (!br_dev)
 			goto err;
 
+		/* ETH_ALEN (6) is shorter than the destination register span (8) */
+		dest[1] = 0;
 		memcpy(dest, br_dev->dev_addr, ETH_ALEN);
 		return;
 	default:
-- 
2.34.1

