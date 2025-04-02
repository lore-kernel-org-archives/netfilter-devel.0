Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B44A51C8603
	for <netfilter-devel@vger.kernel.org>; Wed,  2 Apr 2025 09:19:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743585585; cv=none; b=nKs1R4ulcPtzZUdb16aR8czrFliiVX/S278aYFOQqXZipYMBaVQoTshikiPK+ZTDb0qWhm/VDU+IKFu1Z0qYCqLUz/GXJDF2yRKg5C/V6x6qMj4MP2hCl84nt2uFMZIglALsN9sy4W+bjRgsoVBfKRBZ5eel48e7QMQQ2uAA2X8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743585585; c=relaxed/simple;
	bh=56k/nXtSoEKiefDLs2SanhGP1IiNe6zIp1dCZn/XcV4=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=kiOXkscQW4ToXOduX2j7oRAt6+zUaM274oXEw3vwg6wan1kuGj1SxUJ4zp5nFiXjNRlDkDRcLrkvpw+HaXQNFKTegE2SmuQymRUcDxx3Wmit2YIgvxkirOJuNEZBX3P3jdgVhhLj6ua6HQh89Y/wO9u5D4mOtCDtMgRPwfpJ/bE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=optusnet.com.au; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=AvEMooi0; arc=none smtp.client-ip=209.85.216.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=optusnet.com.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AvEMooi0"
Received: by mail-pj1-f49.google.com with SMTP id 98e67ed59e1d1-301e05b90caso11152245a91.2
        for <netfilter-devel@vger.kernel.org>; Wed, 02 Apr 2025 02:19:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1743585581; x=1744190381; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:sender:from:to:cc:subject:date:message-id:reply-to;
        bh=ZVDuz4V+3/2NtrM9uV01J4vucut9/5Twb1m+wv0wLEk=;
        b=AvEMooi0enUQNZy5aqjPrJRiTigAJn2JSwRWWSAu2K9TphxMQJy+J9htvXzLvG9ZzZ
         n3A4tlf6TaYreD9QH2yAzqpVxhdLmPFVUogezSlheN0bH+Fsxae5TH/nV1zSpOdRUIjV
         EW+8l0moaNQcYUCJCmkwLophj+PSOTPkckIdJ+xPF0Q+SU0ZnLaHvljHygaMqi0sh7IA
         GO+gSmGheoo8NXn5ra3yiyTsnnIuwoJPhIZBaUcf76MuerAINwrUB0a/T6LvcQAtZ1/u
         OOs3dx1bncgV/hi9EPhYzYncf4Ivu7Z4qS/6fN9BZVIWsSLfvwjw8p1zxN5Lv2nhDHzV
         ykNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743585581; x=1744190381;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:sender:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZVDuz4V+3/2NtrM9uV01J4vucut9/5Twb1m+wv0wLEk=;
        b=Cd+Nl42/y/2621/c88nz0Z/ddTEZiPs7OOvUnUothWi15hHq+Q8iUPhzh6XRow8yOc
         3CjE7eq8pQJpCWRitbGBINMO02Wr2M57uDWPYc3LZEqZNOVMonJ3disA1xEeT4A093JL
         mJ6Fl03bnAtjR+FYD6BMMhnR7gTvEfuh1fr1cuT1KI5oD1ixX0fCmq9QTw8Xol63I3ej
         EMyd2ujDij3xnvlvF2XoqTEj7/Dv0/wMG7ZEHgqu5eLx6RDqi+2mzCNuSPRcBr8sUIva
         UJNkU8naEVfwPuW/LTUN8Yu0dKO2j/qJgAZHqh2uNjqCS0tYfolkW7KHzzv8K+i8Dfso
         XaDw==
X-Gm-Message-State: AOJu0YybrZFXEr41AWMRtZcMHcNKJzEWrGx1L0kmMXv6WyIjekqIyAIh
	B1h1c1nOypOkDpgt5RRWaWe1CCa6oteTgCOQIjPRLYiCvfMuPf8RgYFWjw==
X-Gm-Gg: ASbGncvvdvY9N+8NHZOzuo84DLreJ+5SMG3ZPMPV18WeQ0E2fUhaDxTldRe/dmVk0ji
	9jYJM3AlFYlMOcoyxSLr/vA5JGfHjRTHqxZ8QF+e2pdNwD3Ho8NsI4bigP2/I5nxz8ZGN2iGOeP
	nsjn2Yzh1ZFhYu+fgk/0RGIq17hq0OrOc1F9xe6/WA/k5StEYDsZDAXbhcuIOBqondr7dqcHh/f
	F0V+h+lgC+6dUbbpoBcLZjZIzxy9vGSYmC3EUwK4JaICIO3X25PN2UIzMm0CKmvCyASMZfOYcAs
	VVoZgQ4F1qmf1BMOwk5b52Ry1gWNazCiILmpEsaBHbB93Mu8eCJa8Kbh3zhSBBC2MGaYQaFMtno
	5jiDV89WG91ZKKXpUw8xmL7N8RfrN6Q==
X-Google-Smtp-Source: AGHT+IEeJvICFe1Anm8uUJu1XVjBNjox8w1ijd8TmJysindbXXFvWp+R/pWbZGj3n7tMRwXNlLnSMw==
X-Received: by 2002:a17:90b:5450:b0:2ee:8ea0:6b9c with SMTP id 98e67ed59e1d1-30531fa13bbmr30309786a91.12.1743585581363;
        Wed, 02 Apr 2025 02:19:41 -0700 (PDT)
Received: from slk15.local.net (n175-33-111-144.meb22.vic.optusnet.com.au. [175.33.111.144])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3056f93413dsm1069907a91.31.2025.04.02.02.19.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Apr 2025 02:19:40 -0700 (PDT)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From: Duncan Roe <duncan_roe@optusnet.com.au>
To: netfilter-devel@vger.kernel.org
Cc: "G.W. Haywood" <ged@jubileegroup.co.uk>
Subject: [PATCH libnetfilter_queue] src: doc: Fix spelling and function name (x2)
Date: Wed,  2 Apr 2025 20:17:43 +1100
Message-Id: <20250402091742.1074-1-duncan_roe@optusnet.com.au>
X-Mailer: git-send-email 2.35.8
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Fix spelling of "humnan" and name nfq_pkt_snprintf_tcp_hdr
in description of nfq_tcp_snprintf. Same fix for nfq_udp_snprintf.

Reported-by: "G.W. Haywood" <ged@jubileegroup.co.uk>
Fixes: f40eabb01163 ("add pkt_buff and protocol helper functions")
Signed-off-by: Duncan Roe <duncan_roe@optusnet.com.au>
---
 src/extra/tcp.c | 2 +-
 src/extra/udp.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/src/extra/tcp.c b/src/extra/tcp.c
index 720afd2..1bc379f 100644
--- a/src/extra/tcp.c
+++ b/src/extra/tcp.c
@@ -168,7 +168,7 @@ union tcp_word_hdr {
 #define tcp_flag_word(tp) ( ((union tcp_word_hdr *)(tp))->words[3])
 
 /**
- * nfq_pkt_snprintf_tcp_hdr - print tcp header into one buffer in a humnan
+ * nfq_tcp_snprintf - print tcp header into one buffer in a human
  * readable way
  * \param buf: pointer to buffer that is used to print the object
  * \param size: size of the buffer (or remaining room in it).
diff --git a/src/extra/udp.c b/src/extra/udp.c
index ede2196..4d457ea 100644
--- a/src/extra/udp.c
+++ b/src/extra/udp.c
@@ -228,7 +228,7 @@ int nfq_udp_mangle_ipv6(struct pkt_buff *pktb,
 }
 
 /**
- * nfq_pkt_snprintf_udp_hdr - print udp header into one buffer in a humnan
+ * nfq_udp_snprintf - print udp header into one buffer in a human
  * readable way
  * \param buf: pointer to buffer that is used to print the object
  * \param size: size of the buffer (or remaining room in it).
-- 
2.46.3

