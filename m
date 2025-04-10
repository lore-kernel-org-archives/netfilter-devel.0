Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA523202C4A
	for <netfilter-devel@vger.kernel.org>; Thu, 10 Apr 2025 07:18:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744269485; cv=none; b=chzKOTncCmgcwqx/BDVLyvnJxNrkoeRLbunBAHO1oXioDVVmTY8HRKYjVJSPCtUjgWWpDEVmlkHfn6sTBMsXU/LQ1TIGIwS+nepglv2V7ZrL19KTIii5uWM4xOBysjNkvMZFvfwPuxlMjF/4XQoIrdJaCxcf0Q7sKM04Pkpu0GU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744269485; c=relaxed/simple;
	bh=2XMcnUMhSrUO9pBhimasxAOq9704YBgjdzHl7LJ+jws=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=XJxg0tJb5szuLwFH7MdftTrXDdJMnXJOZ/TYGGW/bln24QHureVcmXVDI/N+qWA4z9p+p9EdWVm6itKiF4Usn+87uqwwWy4e7jtJv1+nf55uSJ7vVabhRRmvGZqBUeq2gKmYjzqoiw4tsDToWmIegZ+pP0rNY7Njl+nB/Rxp3K4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=EDCrZRe4; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EDCrZRe4"
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-22580c9ee0aso4817725ad.2
        for <netfilter-devel@vger.kernel.org>; Thu, 10 Apr 2025 00:18:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1744269483; x=1744874283; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ay/DK1Y796X0/GWTd5CnHT0Jl72FswjnbGqDvKTNnaI=;
        b=EDCrZRe4rVxc6LWfaKyFyy4MAO3sImP329xCXDPeshzLEekNe1zqN16Fe+P2udQ7xH
         mttx2/3V/F3GofQoDo2bFX8bct/uW9t1VQ4PNvJaKCxiuRH/ybbtTs0WOX8kmznH175w
         gFwpJdZ9YrtnOfnp14146s5/GfVQLv76q8X9mjiloqnSULQwWieYDTLGRI1A8XZlPqdc
         1nRmyExGnU2zQLIPMsU6u764IyNGzG15r0bECF8eNCTiCJ1GrTAdqKIhPdxZlaZxDr9+
         AYQW2FDv0gwHHDFJ74H4ZaixZkCPFGNVypbueP0fRH+zV4k4qA1HF+KUUJ7mBmmALfwn
         MPLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744269483; x=1744874283;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ay/DK1Y796X0/GWTd5CnHT0Jl72FswjnbGqDvKTNnaI=;
        b=Bn5ZYP3a9PJkHB6uX+O8omFBuoFM9f5bg1PFec3zx+5t0rbmXH7dRkchnXBWVGjBoD
         pTYuALghn30NRn1mkNIESDDxrP7sAYd//kX0qyDf5+YBCj68MNOMlnozYeAVjpfQG0yA
         2/vorwGb3DMy7rBP/HFiqwhlFL6QF4H4Od1D4jVZRbTz4ZrrrhdkNNt4dRItiXtbbBMK
         823R/igJZKoJBc7ae2R4mN/G7qh+vUXmWsPYndKKms/yjrt1DlE+tearLr55HnXeV23w
         agB10z4C2aH6nZYRslFyenvT8YOyR0ZehbyHDdwuOWQWdZFVSaJR/Uydz/nGA760oVJ8
         01Zg==
X-Forwarded-Encrypted: i=1; AJvYcCW89OvYUJyKqVVZQllJitWsolEWaJ4g38NZGqicXPfSQgaqLgbOB2K3h8zE+KRMPMqu0IAtDZv79hvuinHHq1M=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxpt5vavcWrF5SGBYG2QA17CMOak9R188Cg4EviClO/tWmaRXLn
	AVAvVBMchIYhRxf6/TxWr8x8K5JhsVnXhG3FXoj1RRvCsU7lEfD5
X-Gm-Gg: ASbGncugNlF4i4wAgDR/czTtI/iOEnn5bmANhn9Zqomv/Un8cDLPxdF5cf4Twulk3p4
	kprjR2or9Tk7/u+rzU6z0utIrK/+ONXt1wEjSo5+jIBzn0dIxodNv1AMmPRy++P1LPpkAf08UIU
	twJH9qHA3RO7dKBR89QMoykU71c2uPDgfeeaJFpKytruHsxkYmk/TrDprqL5uQKRdvmdD2oWwf4
	2+SW+D3pZ5ACiMM6UK5UyXUgKm7KJ8RVeTrfOYam6rm0wytx9hKwNQ7BaDUNQ1G1nfMfD8cJrXS
	mu5oLacnOyGdBuKIdXWEv0Xj
X-Google-Smtp-Source: AGHT+IHg0Nupc8Ua8w/hUl3W8fhBebaLlZaZLcGbvnPElZ+i57KqpAM95JZC/GuZf1lFNZj081MffQ==
X-Received: by 2002:a17:903:440d:b0:223:5ca1:3b0b with SMTP id d9443c01a7336-22be0388787mr24642815ad.40.1744269482924;
        Thu, 10 Apr 2025 00:18:02 -0700 (PDT)
Received: from fire.. ([220.181.41.17])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22ac7cc9202sm23562905ad.211.2025.04.10.00.17.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Apr 2025 00:18:02 -0700 (PDT)
From: Zhongqiu Duan <dzq.aishenghu0@gmail.com>
To: coreteam@netfilter.org,
	netfilter-devel@vger.kernel.org
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Simon Horman <horms@kernel.org>,
	Zhongqiu Duan <dzq.aishenghu0@gmail.com>
Subject: [PATCH nf] netfilter: nft_quota: make nft_overquota() really over the quota
Date: Thu, 10 Apr 2025 07:17:47 +0000
Message-ID: <20250410071748.248027-1-dzq.aishenghu0@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Keep consistency with xt_quota and nfacct.

Fixes: 795595f68d6c ("netfilter: nft_quota: dump consumed quota")
Signed-off-by: Zhongqiu Duan <dzq.aishenghu0@gmail.com>
---
 net/netfilter/nft_quota.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nft_quota.c b/net/netfilter/nft_quota.c
index 9b2d7463d3d3..0bb43c723061 100644
--- a/net/netfilter/nft_quota.c
+++ b/net/netfilter/nft_quota.c
@@ -21,7 +21,7 @@ struct nft_quota {
 static inline bool nft_overquota(struct nft_quota *priv,
 				 const struct sk_buff *skb)
 {
-	return atomic64_add_return(skb->len, priv->consumed) >=
+	return atomic64_add_return(skb->len, priv->consumed) >
 	       atomic64_read(&priv->quota);
 }
 
-- 
2.43.0

