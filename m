Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 359223AEF27
	for <netfilter-devel@vger.kernel.org>; Wed, 10 Jun 2026 10:41:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781088061; cv=none; b=uMnU8wlgMhsJW83hQN9tF6AeLd1eXyd0zmNhwkDdTz64esKWYMLSuzUB6Xit8TMzVoradx92pI7/wgmdLRZ+uF8xlh3JrnCXQ8+Yl9RIsQDso3gpwwngCKg/Lk+dOQUKG8cy0PxP+6236gqyf3KIhKemudvu+MpDSZmToX6/wtY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781088061; c=relaxed/simple;
	bh=OGLH7jXzbsIii2mYqUyRub3wuJrPU46nL/mOrml4hmM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=kDAApJacIfPF7rnc2rzc6IRwqwHFsBJCF+ttB4pWwxeRjQQhuc792PpMIP7W+jj3aXw8A3RN95ULRFr6n4HKjFLewuai35hBftuT7LDa7ceZ2dgvaNeOwbxrv5hUbmsyIAp/iEafgxEx86R7z40e5Ep6bkPpKDS7wAfQB+3FSSs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kiJrBUJ0; arc=none smtp.client-ip=209.85.221.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kiJrBUJ0"
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-45efb698ef2so3215617f8f.3
        for <netfilter-devel@vger.kernel.org>; Wed, 10 Jun 2026 03:40:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781088058; x=1781692858; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0Jw5k2pr2Uxq2pN8ORiGv1jSaTS+XZ+Vd2/C3ba/TNc=;
        b=kiJrBUJ0TYe6M+d8go/FJoIvTPlsGqlqkTFBBPuGnSYzj0l3n3+wkQihvaFoe4Dbvj
         DZTD+z4jNAQ2S49XqMks9g1gK6czazL+jMJGETSv2B/6iDANCo/rmnOIJqD67BIOqc+y
         H20NERmOb2mIG6xWhQiGxFyM1mg0jxU139bewyGXpoVfEMM7KzGT4+qXU7tzcJ8XfjUy
         sVVcuinyKI8WZJUicZ7NVXKVLd9T9bE/MPWnbmAOkBm04/itjtuGe3tPQ3f4Avc8jQuZ
         9BrUT401SMpTJ92K2VqxdhKhfFfJZU2cCtWg6n62fcXEfrff3X8sFwf5D9ySQwfNigJ3
         4Ulg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781088058; x=1781692858;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=0Jw5k2pr2Uxq2pN8ORiGv1jSaTS+XZ+Vd2/C3ba/TNc=;
        b=fOeMktgOc83tpEAm6m62xWFqLCSPCACXGn6oLSrT2lpvjrZYrO1MbR2DWbc8OA/4LR
         PiY/R/kdDH18/6kBDZCZYlxi16a39d5JCTxmJL1ATL0N78RHZv3IyronYqR7QXPgMgAo
         qqhZJSLT96tZ1KzLR5/7nidD1A5OJfo8TWURehZAymQNpSP5AM3VugCRsFt98gioTWtF
         PeQ14xQTWpqRGu55ssKJipWHV63Y4bfFk6Czl0NYAC4ePWsjH9swvCIDFd8KPTB5lTFB
         jaOFHzf/V+BR7RwurK4vqxJQJk2PLEqXmuIeIhETtHj4Nt4vuOuKBSh5JvZ2xk2C4D8Y
         mzAQ==
X-Gm-Message-State: AOJu0YzynqnQYPuivEe0YOGQONqktNcr7anNAViJQA5yckFrT8LyOAgx
	+Acy9Pf6Fr5+Yk91sloZAQ1GvfsCW6Es90D59cntvbHmOODtcNSRaitcMvp0Ybvhw48=
X-Gm-Gg: Acq92OGPZOayrj5GjNZXkKZPTruD+tveQywXhp/2X2YUX5vNN7rIU67ytcJ62lCvQEn
	EAWgxD72RPjuhTt4bzqBVT63oCuE2ZukExArZl/qh7fih1+zpUqSHPOLGy+7aM/Uf/2ENuKGHZF
	yX7jhw0qgvKyQwitVt/X9W2dtFaJkTAmTRHsRtKtBLC2nwtdnW7uNxOnEaN68BCS1xwu/1Tklkj
	GZqgd8cc1Oob7DC/TOO5/ntrtf1jFJ7SRbflTFj0BPWKVMdwivEO4DRhsGjh7TEP/nmAn8OdxhE
	vNX5zI1Su/7ahznF1nqwuN4cNSl9pbtZxdcRtITWgYBYH8PRa9GZIfm554HPLWaFDTVyeJCCmKE
	XwpXgaVlR8BbOkV/Hvy2Fm/pacBT9mZ78GOUxZ+A5xl4vs6qKDwicYDKi0vFwhXKHEcxGOEtuUc
	fRgW8HT28mgk+A0ucHSMFbEIRY3D+AZx0oU3Y95wmbx/bq6XKd9hk4w2bf5rmEKc6JlWcs1b47K
	ncX1joXgw==
X-Received: by 2002:a5d:5e08:0:b0:43d:77a8:3baf with SMTP id ffacd0b85a97d-4603062bc2amr39185597f8f.32.1781088058536;
        Wed, 10 Jun 2026 03:40:58 -0700 (PDT)
Received: from manta01.. (host-85-36-215-182.business.telecomitalia.it. [85.36.215.182])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4601f345209sm75828687f8f.17.2026.06.10.03.40.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Jun 2026 03:40:58 -0700 (PDT)
From: Davide Ornaghi <d.ornaghi97@gmail.com>
To: netfilter-devel@vger.kernel.org
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	coreteam@netfilter.org,
	Davide Ornaghi <d.ornaghi97@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH v2 2/2] netfilter: nft_meta_bridge: fix stale stack leak via IIFHWADDR register
Date: Wed, 10 Jun 2026 12:39:13 +0200
Message-Id: <20260610103913.1949008-3-d.ornaghi97@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260610103913.1949008-1-d.ornaghi97@gmail.com>
References: <20260610103913.1949008-1-d.ornaghi97@gmail.com>
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

