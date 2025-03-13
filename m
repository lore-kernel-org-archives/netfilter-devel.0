Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A6AEEADA;
	Thu, 13 Mar 2025 19:54:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741895687; cv=none; b=PbBmBZ9riAOXeGWhbk9fSeb0MZnpl8jgCLtyRf9EX0MRdK+7RjDxGCxXHh+UpLVYN4GzIZXRy1Cd6cvWwksOaVVzIvZj87QMKRqFdc0yQwPhrduNiyRbkVWgpzkE4vaCM8FT964VLadmchCKAzi5kYD1SWOwdSjHbb+3UEeQ4aA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741895687; c=relaxed/simple;
	bh=n+WE2e1+CornPIYCL0FJAGHEjkt3BbG8jB/zF/vKQlc=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=jM7QJV3JjM3i1olB6h6sKqqm7Jf1rIrnEKc5OcT54f6FYS7j2e43r7WUsq8pjeT8J03h101QcMIQi54/g8qgUai0lJvd2AQce8wzriek2CrD+8yXQxcfRPdh7BBEVrnzxm7QKgpP10z9mx2AqCieaCUTk+T3+Uy2QlIH8kvYseU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BNMKGuhu; arc=none smtp.client-ip=209.85.160.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BNMKGuhu"
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-472368b50d6so338121cf.2;
        Thu, 13 Mar 2025 12:54:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1741895685; x=1742500485; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=XGLO2paAdzUxnzkAjPVsZKGAI+FEFQuCi8XTZqvAoxs=;
        b=BNMKGuhusWl2r4N8SId9Lq6hdj28mqgOTn//zHExL8OR/FElvdcasDWY5ji1O10mXB
         BymOp6wtG47PbgQ4P6L6X9q6ofL7WsHSBdDqaK3Rgr1MjO9dLYKkjL9o9cMzObstMU2Q
         xa+26xB1/L/vDoJt3POmI+JWFZXB8lXaiBMn62X+Al8AM1WdxgohZ0DAGyZGSi+L99eP
         uI3g4jm+7H1D72bXoNmZwVkRe79W+9vfN+PzjeN6P7fbTJrPXbh/a01QXxgkgT3nOaRl
         0CKzcd/OV/Al0h6yGCsdasXYiiQZNfbPiU5whwnvo62gb79m40npKVP6dmiuVlQmG5bt
         n4kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741895685; x=1742500485;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=XGLO2paAdzUxnzkAjPVsZKGAI+FEFQuCi8XTZqvAoxs=;
        b=AWg1yF0M5uOT7Ylf8yzEYGJ+KYXOqJZ8aIj1C7Y97zD5h4pVSvat1QY4l1R6IVBz3A
         zX8h+NsMbWzz9kEBycdE8AVgDV2kkRGvMDH/K0Bie8enwNTmOwKN02eaXrUbL9duRKPJ
         ErNA81cG0DJo60e7ro0uhQ2Vw5gjCEDrv0tXuhv4H9kq2jHiLymjnAdykYLr5GCIhUgb
         SWZmTTCPEpbwJPWvhZyaN9erKQ0yLUpxs07yceITpVhFlwYCu8qXPc2P2MOxRG3c9Sbz
         4ts6+DM33pAH1cXnYMsir4fwODs6ZjBoMlusTN4ZFyFEQXx/0+RRiCa9o2WMrFzTThOx
         IjVA==
X-Forwarded-Encrypted: i=1; AJvYcCWKx9M6nXod/FjmpddpGYAMA1sYXLYKgaC4AJ9/qZzzRNpglFPI263W9U6JZH5J5e2i2lLUygGF@vger.kernel.org, AJvYcCXUR4w8zEw8trJUwOAlH9HuZAblpaBkJVUExueNVs6sQelm87mD1G0y6miIjbm7WMPCnflmawA7Yc7LXyM=@vger.kernel.org
X-Gm-Message-State: AOJu0YxfGd/EygNJQbiUTJJ4RsFerZm4ZL2G+/1kewBeXwgQ+cahdIi9
	vTyc1gZ8AAHvhsFmnrwCbjW+bhuSuqveYFRBX/NjjQVZLPCK4Hfc8KCEdLQ=
X-Gm-Gg: ASbGncv0jC7CVZ77R89Ut1mkQGs3AaUUMdvN2fpCGBR4r5dfEgjjHFzPCmyh8XtcF4u
	tEWUg0YuTUflKHaegBFjtvSHUa9B3Asxo3jXcpaot5VfN2RCnS2LVY4J4ElAx8RDzZF4L7wixRC
	AjPRd0ipKAVqrKOEZppckHsuypSPy2Ba6n9+4jrpU5QighZrUsfjhUfgMvt6JkEJU3GA957Fe29
	uAy8QBQbVG/6nh8Gy2T6mVnKOKZvf1SipVHCjAt3P52I3zilPQfZkCClMsrNAMqpdj39x9KzUBB
	EmVf4YmiN1heeHCIQzT6VvKS9wqm7iEiou0MpLswlQ==
X-Google-Smtp-Source: AGHT+IG+sFRc0BbtzznoFbw3LS6WnCpgI30gRX6xy1ivIdThQI9VEpo1hDVok8W6MQRhqUayCtE8kQ==
X-Received: by 2002:a05:622a:5e8a:b0:472:2122:5a43 with SMTP id d75a77b69052e-476665885eamr116028291cf.1.1741895684780;
        Thu, 13 Mar 2025 12:54:44 -0700 (PDT)
Received: from ise-alpha.. ([2620:0:e00:550a:642:1aff:fee8:511b])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7c573c9be96sm136377985a.61.2025.03.13.12.54.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Mar 2025 12:54:44 -0700 (PDT)
From: Chenyuan Yang <chenyuan0y@gmail.com>
To: pablo@netfilter.org,
	kadlec@netfilter.org,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	horms@kernel.org
Cc: netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Chenyuan Yang <chenyuan0y@gmail.com>
Subject: [PATCH] net: Initialize ctx to avoid memory allocation error
Date: Thu, 13 Mar 2025 14:54:41 -0500
Message-Id: <20250313195441.515267-1-chenyuan0y@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

It is possible that ctx in nfqnl_build_packet_message() could be used
before it is properly initialize, which is only initialized
by nfqnl_get_sk_secctx().

This patch corrects this problem by initializing the lsmctx to a safe
value when it is declared.

This is similar to the commit 35fcac7a7c25
("audit: Initialize lsmctx to avoid memory allocation error").

Signed-off-by: Chenyuan Yang <chenyuan0y@gmail.com>
---
 net/netfilter/nfnetlink_queue.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
index 5c913987901a..8b7b39d8a109 100644
--- a/net/netfilter/nfnetlink_queue.c
+++ b/net/netfilter/nfnetlink_queue.c
@@ -567,7 +567,7 @@ nfqnl_build_packet_message(struct net *net, struct nfqnl_instance *queue,
 	enum ip_conntrack_info ctinfo = 0;
 	const struct nfnl_ct_hook *nfnl_ct;
 	bool csum_verify;
-	struct lsm_context ctx;
+	struct lsm_context ctx = { NULL, 0, 0 };
 	int seclen = 0;
 	ktime_t tstamp;
 
-- 
2.34.1

