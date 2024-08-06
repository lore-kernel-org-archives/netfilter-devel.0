Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A6E718D635;
	Tue,  6 Aug 2024 16:16:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722961006; cv=none; b=Xs2/VjxZADoxKhE6GnqSYreWNbUSJQ/DlIrhH77VdsnLNaxdLBAJU4Nt3ms4JE4tucpnx1Z2yOUEQmdPDPk5B5iZd2gp6zWu9X6xAmh5PReE7gauyAjPnYZ7LGDQxCc3JB6B2xEVi1+go6Dxzkay1OTAj0g1DvqanCvrWSSZ46A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722961006; c=relaxed/simple;
	bh=jnuGjpSlRgXaxM1DiEgYo6h/HWBTsRwnVZ+eWoy0F/A=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=A2Ez1YhNULjydnMCVCLDhT/z6EqBkMKhPmSAop17t8P30+vEz4qWtMtFlk8BKedgclq3Wt+nm8unlaktBC3+S776FiQ5D8aN+LNIOe0PLE7adBvNs92f2VRniDkv8IxUlyYyRD3rBaO/Y7qDmiSwlllCdXV7OfMILeF8py5m8/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=akRZe5/W; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="akRZe5/W"
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-42812945633so6597735e9.0;
        Tue, 06 Aug 2024 09:16:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1722961003; x=1723565803; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=dhUOJdnJc/hLxeOGAR1Kh5usonvobTBrTqOyTUajamc=;
        b=akRZe5/WAWpO6faWdpGCaoOJHnKHr2VHmpCY38Dm/P0VUm2RdVdwJP9TtDB5vzujLR
         FgPZAPnU+EKiBYepIXMBXTiTBzcOie8Va8JnEJAD4UAo5ThG0xLnlr9tj9Qw9hMBLEdB
         d2ILwM8/Vbznq+WDKFV4y9wolW0H04Da0pEmCFLiYAoc6pbPaZm4mZlHzEWaRo6NjzaU
         +FGFekK22tgVrxsd8NT9v2Y4syy2yYUgopCZWeg1iimeKUbCjAHwnRrT577IgPqPMXJ8
         Eyq3suS1DXeea4ce8Rck+JKpz60vRkdIT8cgKWQeoQ9XfpSppqsoWfSSJLLTWYGqiHjK
         cMtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722961003; x=1723565803;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=dhUOJdnJc/hLxeOGAR1Kh5usonvobTBrTqOyTUajamc=;
        b=TYr2xEZ8jDCtW2vUBxyviLQYnQczBOGFxS+V/lQEtmBNWDuSlMufuU4atenBqIHLm9
         lHTYJlktecJO8NdPVnlVbLw9PYDWXbQhvU7pru3qAcLLr1cIFuumDEGKFmly8glMEOUl
         DVOp31NXC8LSq/DCzGRAqxr9lWcn2csO6wz2xpQKPtTFbXTOyrFW0Ue/N9Q7CkUFv42S
         8AFbnljL9UyheTZlIr2HHW2iuFD1azfhV9dusETt8CAy1KOYGIyZz7NwD81vw48wjCA8
         nNZ/45sj45xsYbyvzjM5jI/HuKsHGDM83ZXjTzzu3SN1hNWt36o6f2VnieaXfh+sbpEi
         XVig==
X-Forwarded-Encrypted: i=1; AJvYcCUqt8BTgHWS5Mn4SLXmYB7esNbXnGVe3D/eBaSDT+Z7HBzmLJ3yGQxL8tUcBxnTt9EkesX+4fkMc97jHRJaAvvN@vger.kernel.org, AJvYcCXYHStfFogXp/sOJ4oU/UK5lWoWTLXxVS0npbv7Ka0Mi42UXeE61iCnyd82KHFF6Zzh9lDYyGw=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyq+hAhdYj/AGFq2zOr5qNLq5Lo1zgJed/D7fEcd8iXTXoG8I7K
	TOLcKMVPxXEiZKqtkYurAXWJsDkTxJl3Gs8bor/IokRrPmfa/wYG
X-Google-Smtp-Source: AGHT+IHyZYFc0tvUMw+IBvf4k3gdwtogqjANprD55ohy3QMIdpgiIeIvTD/pXFNTuyHrr/kbJYENGA==
X-Received: by 2002:a05:600c:3549:b0:426:59fe:ac2e with SMTP id 5b1f17b1804b1-428e6b789acmr109725775e9.29.1722961003082;
        Tue, 06 Aug 2024 09:16:43 -0700 (PDT)
Received: from imac.fritz.box ([2a02:8010:60a0:0:464:e826:cfe4:a57a])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-428e6cd8d67sm189464635e9.0.2024.08.06.09.16.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Aug 2024 09:16:42 -0700 (PDT)
From: Donald Hunter <donald.hunter@gmail.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	netfilter-devel@vger.kernel.org,
	netdev@vger.kernel.org
Cc: donald.hunter@redhat.com,
	Donald Hunter <donald.hunter@gmail.com>
Subject: [PATCH nf v1] netfilter: flowtable: initialise extack before use
Date: Tue,  6 Aug 2024 17:16:37 +0100
Message-ID: <20240806161637.42647-1-donald.hunter@gmail.com>
X-Mailer: git-send-email 2.44.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Fix missing initialisation of extack in flow offload.

Fixes: c29f74e0df7a ("netfilter: nf_flow_table: hardware offload support")
Signed-off-by: Donald Hunter <donald.hunter@gmail.com>
---
 net/netfilter/nf_flow_table_offload.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flow_table_offload.c
index ff1a4e36c2b5..e06bc36f49fe 100644
--- a/net/netfilter/nf_flow_table_offload.c
+++ b/net/netfilter/nf_flow_table_offload.c
@@ -841,8 +841,8 @@ static int nf_flow_offload_tuple(struct nf_flowtable *flowtable,
 				 struct list_head *block_cb_list)
 {
 	struct flow_cls_offload cls_flow = {};
+	struct netlink_ext_ack extack = {};
 	struct flow_block_cb *block_cb;
-	struct netlink_ext_ack extack;
 	__be16 proto = ETH_P_ALL;
 	int err, i = 0;
 
-- 
2.45.2

