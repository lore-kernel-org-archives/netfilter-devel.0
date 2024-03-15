Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C54DD14A8E
	for <netfilter-devel@vger.kernel.org>; Fri, 15 Mar 2024 07:34:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710488050; cv=none; b=AY/DaX40g7R9NtkuXqxEV3FKSk869fzWJ/lcT2pJqxD+pgZS0NJkKJyXiOdDKrR27Vhtc2fpGV5+vnVftQipcYvBMr9HQ4q3J+0kB04e+AU27ebo4MwyxdZ1Mz9117O6lnfnSCuz6keWEyjch4pbfeKX9LYSzO2R0+kx/0B+BLQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710488050; c=relaxed/simple;
	bh=ZF6NoaL/gJenjxARNx7hMsv5SnExPHooWsMW/hsGdTo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=URsCC7Pz/+N7b8IvynPPa02axsrWiS1OLkWgnaTp/niCail+wAW03ZHlEjl39BT4CP3MaoqsBqGwXFt6gXpYknOL0XsHeY3C+FjVQwv6jHdzK3cD6yEi27tS344R2HDbOLv2T+Ku/spRqTL+QTKsy1k6m6BTFrK4KpjNywiGdew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=optusnet.com.au; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CoRjTDD4; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=optusnet.com.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CoRjTDD4"
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-1dde2c0f769so11657565ad.3
        for <netfilter-devel@vger.kernel.org>; Fri, 15 Mar 2024 00:34:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1710488048; x=1711092848; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=88FdNOp4rpryjgPQTL5V38lv3ja6ZfKp0ekSUCtPqlw=;
        b=CoRjTDD4NS12jNJ5DY1VwCF4SL48oT/tTocw2Cb5G+RUTE7QmtDWb6L4gJVeIduYS/
         MrIqKWuqv22W9dWXpSiLQy6fBhKCZihZEAQt7VIN67ia5ZeUStZ4rVYiy9drVNhtruiV
         TVTI6BZc7QGLF9xX09L7wfoWARESCC9pcmeabWMIrotUrAyc/PBxlZKrbD8H18g4McsP
         kH4CmHkJY2A2cu9Y2DfKkiSwJ7GsSwGqxinM2j6jaQDLhkYj+D5TUHgBxwxhelVkKI+Z
         3GpNs6WWJqB9mmE85EUxrXPKIoxX0Bl0RzInSGbuNOo+ThwU/RHTU8XXg3XTeZ+CeSHY
         mmsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710488048; x=1711092848;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=88FdNOp4rpryjgPQTL5V38lv3ja6ZfKp0ekSUCtPqlw=;
        b=M+qwMGIAVSrMF5ZeCKqW6cCIR/VIbAzfEHKxaFsZgX+3A0IBZ5Qp7r2WB4DqZGJTXH
         q3va53NAXQhCJzPaA1jaW/wD10Mbx5FB+2LpBufIhLK8GfI1m9QtME3SSslVMc06371F
         PUvA5njR7J1BloZH3kjLzSitafkDy0uD7spowGsnG6p84nryZHZ/7AN8HB+DmiP2Zw79
         eAv3jnqbukn/R91SLgo2+4sA8be+Gm/8nMr3cEhhGgPLg2BHAODhvX7mN7IGZMWYVNqA
         BJInTDvCsP5egNWA3G87IKTaszfZSfPFyPQdHJ+c4w0PV4mwKZNAC1d75Ymding/ugoR
         H70w==
X-Gm-Message-State: AOJu0YxD00CtYWZeIyAW/OemPpL7+KDiQbPBRBiDmafWtxjO51IGIqRc
	aZgABt9Z/O7bRh/13FDANSoWKUabwda5Y9WnsInl/lg+YNj8Cr32LzBSFpSs
X-Google-Smtp-Source: AGHT+IFz+knvBIt7Lh3E9JYOIUxToS9tzdw3iAT0rxcLnQGwjLHuMl2BEIaj+dXLQKVHintDgqBUeQ==
X-Received: by 2002:a17:902:d4d0:b0:1dd:5f85:118c with SMTP id o16-20020a170902d4d000b001dd5f85118cmr4330090plg.62.1710488048110;
        Fri, 15 Mar 2024 00:34:08 -0700 (PDT)
Received: from slk15.local.net (n58-108-84-186.meb1.vic.optusnet.com.au. [58.108.84.186])
        by smtp.gmail.com with ESMTPSA id k18-20020a170902c41200b001dd75d4c78csm3049142plk.221.2024.03.15.00.34.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Mar 2024 00:34:07 -0700 (PDT)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From: Duncan Roe <duncan_roe@optusnet.com.au>
To: pablo@netfilter.org
Cc: netfilter-devel@vger.kernel.org
Subject: [PATCH libnetfilter_queue 09/32] src: Convert nfq_fd() to use libmnl
Date: Fri, 15 Mar 2024 18:33:24 +1100
Message-Id: <20240315073347.22628-10-duncan_roe@optusnet.com.au>
X-Mailer: git-send-email 2.35.8
In-Reply-To: <ZcyaQvJ1SvnYgakf@calendula>
References: <ZcyaQvJ1SvnYgakf@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

struct nfq_handle has a struct mnl_socket * now, use that.

Signed-off-by: Duncan Roe <duncan_roe@optusnet.com.au>
---
 src/libnetfilter_queue.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/libnetfilter_queue.c b/src/libnetfilter_queue.c
index 2051aca..5e09eb7 100644
--- a/src/libnetfilter_queue.c
+++ b/src/libnetfilter_queue.c
@@ -381,7 +381,7 @@ struct nfnl_handle *nfq_nfnlh(struct nfq_handle *h)
 EXPORT_SYMBOL
 int nfq_fd(struct nfq_handle *h)
 {
-	return nfnl_fd(nfq_nfnlh(h));
+	return mnl_socket_get_fd(h->nl);
 }
 /**
  * @}
-- 
2.35.8

