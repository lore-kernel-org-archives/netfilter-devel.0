Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 017FB15AD8B;
	Sun, 13 Oct 2024 18:55:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728845748; cv=none; b=KvntYkDj/Hfyy+8KrwegEcW1M5YyGKiwLDFATeebQYVQGUWpZWih+c5SvoM53uesmEwhMerm/i5alVbScSmXCeUG6aRURbCTU97ddHJ6kseHU2KD6tZ2fgKpU+Rk3NAa7a6Jw1PXaysqDBgqsa+SaxbAzTScf3eHfUmYg5cpJKU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728845748; c=relaxed/simple;
	bh=qiG8ZutskEM+cPKvaIWJXoyJOE3LBvwNvOeYgLppLjY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kfSwmEIKuR5PG4eJ3EUZsYQXyZYsvWoD/Ub1HKdeVTXPE+cl6xrMH25TEZ4rt2wyVnez94NEiYNefAP+xKumXe6MIlx0jEVsDV/+sE3bLbk9KF0Som2yxAkWrzpNVRrPnwmEX+QX3+fHk2Img/PdhCCdTsQrzTaLr2zT2qbPXhA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KcIvCWS6; arc=none smtp.client-ip=209.85.218.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KcIvCWS6"
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-a993a6348e0so289235766b.1;
        Sun, 13 Oct 2024 11:55:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1728845744; x=1729450544; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3I/LHRTPLqJJONKYwwXQsldQo/OPnYwvoagC0qSu+YY=;
        b=KcIvCWS6TbcUIXjc4VGJYclYU+DK4WBey9cmqhcT2WwA0XYPqs292K9J6mz4kvAdP6
         YDhoLsi06ImPcsPKPFPYFKVAzpCXFIH6+Im3AAiuYkTXoekRbUYzrY0f2J/7dLUJpC9r
         /ScwIDeW7xB9Bx9WcgzycdyhqRWY989gZ97whmFT3rNtdqG7VSALp7YEolY550usUsPT
         YSDcdfsr/onR7LE4tlU37KyVXguOZVKFTRZH8HVmTGp9QlKxe5gdeBpGcloQu1+7REvW
         QIIYl5X8X6hAFQhZNxN/mJGDpS7RWpCgVQSr+6rUvUJS1/pcZppprH0UZK5Ty/7D/Um3
         Dq2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728845744; x=1729450544;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3I/LHRTPLqJJONKYwwXQsldQo/OPnYwvoagC0qSu+YY=;
        b=lDmCCp02vkfSn1rrGgd3ATUaFkdtbZdvq9nLGEZbTLtjj0eA2/Pka9H6bSh6M/v031
         1tJ41P7aQJR8aaP0jcDDce6xUlcviMEQY6OP5xMI8ieFWUfCoYEIb4lCBcgRZJFelhEx
         ysQZJYga02mjGtAAkZm7jPbHSaivvmDGNwPiAtuQWjIj/ynXYbh6R+CyCYI7E6c2Tz/+
         THsZTh+A1pN3HB0GmGtdSlmYvX8y91y6wi6LUc9IqLvDSYJLJwR2s6s1gy2gvAxYMv/z
         nx/AWsxromPsx2+bSDQizfvUKS04belG69cyQigsUzTQQTjv5eR0HhqTj+w89znVzdrj
         jo9Q==
X-Forwarded-Encrypted: i=1; AJvYcCX1eTJSwomfmL8mzarDHtbALHAHWFC9LZ0+7OsXfGvIfcQmYDA/XZTBxl5K/ju1RH1eDT+J5J9NzLh/BMpkdcfL@vger.kernel.org, AJvYcCXIGSvda660x9wq5KeKWjUfVYaBvpzH9fsNYIZIPn+wS5ml0+3GnsX9Owd1W0ZP+ZbgzQSSlVEmSRKHAbU=@vger.kernel.org
X-Gm-Message-State: AOJu0YxoPUAQ1jBmIyzCcQtBXPkN4W+iu9ck+zphMflAEZDpxuhHrrN7
	egY8N3E5dkKGWSLvl9QWq48NEpuv57+EiSVQbMa4hLZbETjxfjLi
X-Google-Smtp-Source: AGHT+IEK/qY7kO3EuTXV/jRfrEbLu6Bs8uGBQ+icVQCx2B6S9pRxxPh+utvTvacXCNe8KWGJaLv35w==
X-Received: by 2002:a05:6402:26d1:b0:5c5:da5e:68e with SMTP id 4fb4d7f45d1cf-5c95ac09876mr10710253a12.3.1728845744129;
        Sun, 13 Oct 2024 11:55:44 -0700 (PDT)
Received: from corebook.localdomain (2001-1c00-020d-1300-1b1c-4449-176a-89ea.cable.dynamic.v6.ziggo.nl. [2001:1c00:20d:1300:1b1c:4449:176a:89ea])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a9a12d384b9sm13500866b.172.2024.10.13.11.55.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 13 Oct 2024 11:55:43 -0700 (PDT)
From: Eric Woudstra <ericwouds@gmail.com>
To: "David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Roopa Prabhu <roopa@nvidia.com>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Jiri Pirko <jiri@resnulli.us>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	"Frank Wunderlich" <frank-w@public-files.de>,
	Daniel Golle <daniel@makrotopia.org>,
	Eric Woudstra <ericwouds@gmail.com>
Cc: netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	bridge@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org
Subject: [PATCH RFC v1 net-next 09/12] netfilter: nft_flow_offload: Add NFPROTO_BRIDGE to validate
Date: Sun, 13 Oct 2024 20:55:05 +0200
Message-ID: <20241013185509.4430-10-ericwouds@gmail.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20241013185509.4430-1-ericwouds@gmail.com>
References: <20241013185509.4430-1-ericwouds@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Need to add NFPROTO_BRIDGE to nft_flow_offload_validate() to support
the bridge-fastpath.

Signed-off-by: Eric Woudstra <ericwouds@gmail.com>
---
 net/netfilter/nft_flow_offload.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nft_flow_offload.c b/net/netfilter/nft_flow_offload.c
index bb15aa55e6fb..6719a810e9b5 100644
--- a/net/netfilter/nft_flow_offload.c
+++ b/net/netfilter/nft_flow_offload.c
@@ -421,7 +421,8 @@ static int nft_flow_offload_validate(const struct nft_ctx *ctx,
 
 	if (ctx->family != NFPROTO_IPV4 &&
 	    ctx->family != NFPROTO_IPV6 &&
-	    ctx->family != NFPROTO_INET)
+	    ctx->family != NFPROTO_INET &&
+	    ctx->family != NFPROTO_BRIDGE)
 		return -EOPNOTSUPP;
 
 	return nft_chain_validate_hooks(ctx->chain, hook_mask);
-- 
2.45.2

