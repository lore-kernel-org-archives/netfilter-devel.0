Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28E4D177AA1
	for <netfilter-devel@vger.kernel.org>; Mon, 25 Mar 2024 03:19:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711336793; cv=none; b=BqJ3i36YyupMz1amRQ1PYmWhfksYUg0iRo9qkq7QqPvFXSFWuaJS3lDLEd7sM52fvVBpTeI6k082smRDL9KCYD+EOYGliHAfY7bPKHnTotFuL6vUUGubr4zqYvB97+E61pgNl+dJ6Bo9Q3V0bkL1tR5+uOOO9TIaToswrXYYhao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711336793; c=relaxed/simple;
	bh=jGVKX92ZwFKBLKzn/dxfqUCOUrlcyhcMKzhxyiI4QVQ=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=E77WMwZRozIOXm4IGyhu1hHvJyB7bI81igSySXH/0VNbZdq2mtC0L9JHdAxvHf8hCsDsIkWC7XEnhPCYklX4AW2xjiVhQEULwJiaPy/1V6YCb3pRi1Z+IcAt3G2a7ImLdOvPaE7gSWqB64/fVcfRgMldRrNwq+2YW0XxTQZ3z+s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kFaLBra1; arc=none smtp.client-ip=209.85.210.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kFaLBra1"
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-6e6c0098328so2520280b3a.3
        for <netfilter-devel@vger.kernel.org>; Sun, 24 Mar 2024 20:19:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1711336791; x=1711941591; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=p0JAZ+K0KIVIAOPlV+P7YD9x1MUItiNcLZ/TShHxuPY=;
        b=kFaLBra1x5rJ2qY23jUuLIk9dV1Yc8XTSPHs2zqO6+DcC2aY1NNwhN96zgIA+5pC0c
         X4cHHhsTsr4IiucuvBlUDD44VX3tbWFzWnckvKP8gU6OhhIozqeNEkMsdkZCjMLckIOl
         nC12zVNfh+CV9u4trJVSKj4HRjgEbFINM+eAhzn4dsMdIKXtIulJ6Y6D4aYDDYMYv/b0
         Msdp5j3Z5n0rb6MPRyAiTBQ9gxvf/p4q+4Bw5cqQZ6lgcud57EQVawv/0kHp/+rgnP50
         x5gugPmDXWBNj1IIgxtqgw4ISC4DhP1Pu0alAnN2bRxg/adldBiQ2AkXJRQrI1CVCMqE
         /I1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711336791; x=1711941591;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=p0JAZ+K0KIVIAOPlV+P7YD9x1MUItiNcLZ/TShHxuPY=;
        b=sY3gvcJ11IL/7gDwUDb1O7l/SPfJ4g/0F6s+xWe9uJXIpz5+P9olacNyrdD6USFHie
         ZVkRH8G9WSSCDKonGP/VvtZDPCmbYOs6Ai7TLCXW0zgw0leeeXjEdFoOTxYw/RNQYmmW
         u9HCEl83m98APNXGP7KtAkXLUEtMn2xq16dwXUKQawmBSLSNuQKNjx7hC1pgk87T5BqO
         dhRaSUJDmtdhcowrjjO3DgrxOo1/Wdg1cbHbq2pzMaXDsfbV1FDXmeXNldBw5eHV8/1W
         b1gPpSlw+Hpg6E+gKoFVoKMAxCL0DI5+AfM08aaK6Dh9tE4h0YE71oCor9LCs8oXblf2
         jcIw==
X-Gm-Message-State: AOJu0YxkGYvhuz4b9/f1CMcMCvOkZR2+xuf+tBppAxxg5todPXoe9KJ3
	4hPvXu8UYa6M/m0w/A7Cg3xOoY0GsWkbMkteB+dYEmCfBX28nx6S
X-Google-Smtp-Source: AGHT+IE9XxA0KQlfNj4tWV/9mqb9boFADGCVO5Jgr0GO0R8ySuObGC+E34cNtMy/C50gTLMkw4DidQ==
X-Received: by 2002:a05:6a21:3298:b0:1a3:534b:3211 with SMTP id yt24-20020a056a21329800b001a3534b3211mr5754480pzb.8.1711336791321;
        Sun, 24 Mar 2024 20:19:51 -0700 (PDT)
Received: from KERNELXING-MB0.tencent.com ([43.132.141.24])
        by smtp.gmail.com with ESMTPSA id b15-20020a170902d50f00b001e0bae4490fsm1254080plg.154.2024.03.24.20.19.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 24 Mar 2024 20:19:50 -0700 (PDT)
From: Jason Xing <kerneljasonxing@gmail.com>
To: pablo@netfilter.org,
	kadlec@netfilter.org
Cc: netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	kerneljasonxing@gmail.com,
	Jason Xing <kernelxing@tencent.com>
Subject: [PATCH net-next 0/3] netfilter: use NF_DROP instead of -NF_DROP
Date: Mon, 25 Mar 2024 11:19:42 +0800
Message-Id: <20240325031945.15760-1-kerneljasonxing@gmail.com>
X-Mailer: git-send-email 2.33.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Jason Xing <kernelxing@tencent.com>

Just simply replace the -NF_DROP with NF_DROP since it is just zero.

Jason Xing (3):
  netfilter: using NF_DROP in test statement in nf_conntrack_in()
  netfilter: use NF_DROP in iptable_filter_table_init()
  netfilter: use NF_DROP in ip6table_filter_table_init()

 net/ipv4/netfilter/iptable_filter.c  | 2 +-
 net/ipv6/netfilter/ip6table_filter.c | 2 +-
 net/netfilter/nf_conntrack_core.c    | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

-- 
2.37.3

