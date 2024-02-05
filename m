Received: from mail-ot1-f50.google.com (mail-ot1-f50.google.com [209.85.210.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA71DB642
	for <netfilter-devel@vger.kernel.org>; Mon,  5 Feb 2024 04:45:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707108330; cv=none; b=e1CK8bCwEFxNZB534UlJg0TxfmFpRl1bTszPr0MxEu6E6ugxbF/I3waPmFwgtGVf8VpEKh3l0fOxrrYJXrVi05yYdoGG4uyEXBr+KKua9zwUqm03fL/XtBCT1h3HaHzZLeX1/pdaxMnf1VskhPQWHijDb5ncqOr9n6sbSeF3NNE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707108330; c=relaxed/simple;
	bh=C3RFITXrVbMMXRyWOgvAlGjMpXLEn7kRJ/T5LQ+Dwo0=;
	h=From:To:Cc:Subject:Date:Message-Id; b=ChUwQGTx+oONlTiro5z7x3XQ/GIOV56Y3SWlAnqu1CCAN2ntnAhyQGm7HJVnis3EYXmaRX7xgoiPQ1gty9CYmN2TZ6Sa3xMpiSwazczYUtBU3PhOLLAP80PTWvzv87yrgj69H2fhthMGmuIF0zND/DX6ApSfYwG7Su6m5Q+VUIo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=WaiputF8; arc=none smtp.client-ip=209.85.210.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="WaiputF8"
Received: by mail-ot1-f50.google.com with SMTP id 46e09a7af769-6e117eec348so2603404a34.2
        for <netfilter-devel@vger.kernel.org>; Sun, 04 Feb 2024 20:45:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1707108328; x=1707713128; darn=vger.kernel.org;
        h=message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fFHhMPLHf/PHf1gbdd9RUwHvdq1MmSrUv9OUUxHJPew=;
        b=WaiputF8vd4U0kfeYN/ht+9dmNVvtoLGkn6tO/aNgNVvBtRt61kLewQ0/y76sW6ozQ
         KA9K6k3MLDxHn47/PRK+yIGi/lwn1j0q0TolL7cSPZLHsDrGMXi2P1KLIZxg4GKAbTiq
         sjsopiQe9FdMoQjpHzMSrXZd3U7A/BuvgNBkA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707108328; x=1707713128;
        h=message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fFHhMPLHf/PHf1gbdd9RUwHvdq1MmSrUv9OUUxHJPew=;
        b=RtFNPzK5JnBnA+lutlB6I95J3759phtqu4OW0nJI2omfOSOwE6vOBERiHe8L9QNV4v
         AXoFWaG4mGT5Bjtxaqk6B5W0v1zXRwJijaxgQ5w+D49NwnOLSOGY/Lr6sAIZJFLrxmTz
         AdNcSTe5C/0skrvzSiU5FtG9MbifqXgcB5bEcKxHJWr5tnCgvVWwK5rfnZXJ7oBbfZHf
         GhlJCuuj+bSZ74XYwktHhsFWhnBIsTK6zHcp6UAY9xgpAPZFklNg71R6dKUpbOq+fQRv
         doRkzOO4TpSA2dzQnx5TguZqzay02nfW4nKUOPBUQGRt3CSo6mdGtpyuzKKnCgnCMO0I
         +Xgw==
X-Gm-Message-State: AOJu0Yx43AJjy21OGrX0FSUWWMjrK10zIBBlqW8qgq3vK6RkQOrrNYXC
	I9bLLCNUgr3UQFnq64ITrUWi00eUBPwqXQHR8zr8oKkBgSCavT/jynJrHCgpyA==
X-Google-Smtp-Source: AGHT+IEeow1gZHkiO9dO07aro34d2nGh7UFwtbunFPEaLK9acEtkUz+jqRl//y27TNHArCGQgN03pw==
X-Received: by 2002:a05:6358:6f9c:b0:176:4d01:22af with SMTP id s28-20020a0563586f9c00b001764d0122afmr15640958rwn.4.1707108327825;
        Sun, 04 Feb 2024 20:45:27 -0800 (PST)
X-Forwarded-Encrypted: i=0; AJvYcCWSs66Oq85yGtSLJxv6+8pzpNbVa3ZXxjh/OmBQ2BKZK+SA11XTL8J0LVDMWQBaAhsxtbQZjhkwrZZU6uqBJlVN3CqB3M96uRYUbYwgREloZ8xJ0UBMhP17tepemkj7G3clddifVS60IlEvho6kH/+heAVWvtuU0Yxy89vMaXqWfxp0Poe/9qEmImyduq7WEb9vdaQbYTbVvtnLncsbWzCCjBro3Pdv4LJThOPK2OJbrTWt27Oihzf4YXI1P9QbVCsli/lUMX+lcrtyUdSddk3jWFi9S7EawSmsiRvrImwCX63omLSMvM2N3SiMJgLlDOFqlOuqjcCVvIyUH30jfOTwHOKtHMtKOhqodCSwyekMQkq9XfRDsI9lFEzNN95SUfX83N0u09K2ajrW6KoDE59e0J9ugdrcdSpgxbTf+nP1i8E+NjksQK0SXrEMq2vMSQpsV0mP7qIa2sFDbLvOK3FjlLSR8l1w9vHVn/lFQUj1glLg4RGAy7STvndwRNqN8GFQktdimCeBcxTDsOf328veer2+vfA=
Received: from akaher-virtual-machine.eng.vmware.com ([66.170.99.2])
        by smtp.gmail.com with ESMTPSA id bn23-20020a056a00325700b006dbda7bcf3csm5629859pfb.83.2024.02.04.20.45.25
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 04 Feb 2024 20:45:27 -0800 (PST)
From: Ajay Kaher <ajay.kaher@broadcom.com>
To: stable@vger.kernel.org,
	gregkh@linuxfoundation.org
Cc: pablo@netfilter.org,
	kadlec@netfilter.org,
	fw@strlen.de,
	davem@davemloft.net,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	alexey.makhalov@broadcom.com,
	florian.fainelli@broadcom.com,
	vasavi.sirnapalli@broadcom.com,
	Ajay Kaher <ajay.kaher@broadcom.com>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH v4.19.y] netfilter: nf_tables: fix pointer math issue in  nft_byteorder_eval()
Date: Mon,  5 Feb 2024 10:14:52 +0530
Message-Id: <1707108293-1004-1-git-send-email-ajay.kaher@broadcom.com>
X-Mailer: git-send-email 2.7.4
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>

From: Dan Carpenter <dan.carpenter@linaro.org>

commit c301f0981fdd3fd1ffac6836b423c4d7a8e0eb63 upstream.

The problem is in nft_byteorder_eval() where we are iterating through a
loop and writing to dst[0], dst[1], dst[2] and so on...  On each
iteration we are writing 8 bytes.  But dst[] is an array of u32 so each
element only has space for 4 bytes.  That means that every iteration
overwrites part of the previous element.

I spotted this bug while reviewing commit caf3ef7468f7 ("netfilter:
nf_tables: prevent OOB access in nft_byteorder_eval") which is a related
issue.  I think that the reason we have not detected this bug in testing
is that most of time we only write one element.

Fixes: ce1e7989d989 ("netfilter: nft_byteorder: provide 64bit le/be conversion")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
[Ajay: Modified to apply on v4.19.y]
Signed-off-by: Ajay Kaher <ajay.kaher@broadcom.com>
---
 net/netfilter/nft_byteorder.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nft_byteorder.c b/net/netfilter/nft_byteorder.c
index dba1612..8c4ee49 100644
--- a/net/netfilter/nft_byteorder.c
+++ b/net/netfilter/nft_byteorder.c
@@ -41,19 +41,20 @@ static void nft_byteorder_eval(const struct nft_expr *expr,
 
 	switch (priv->size) {
 	case 8: {
+		u64 *dst64 = (void *)dst;
 		u64 src64;
 
 		switch (priv->op) {
 		case NFT_BYTEORDER_NTOH:
 			for (i = 0; i < priv->len / 8; i++) {
 				src64 = get_unaligned((u64 *)&src[i]);
-				put_unaligned_be64(src64, &dst[i]);
+				put_unaligned_be64(src64, &dst64[i]);
 			}
 			break;
 		case NFT_BYTEORDER_HTON:
 			for (i = 0; i < priv->len / 8; i++) {
 				src64 = get_unaligned_be64(&src[i]);
-				put_unaligned(src64, (u64 *)&dst[i]);
+				put_unaligned(src64, &dst64[i]);
 			}
 			break;
 		}
-- 
2.7.4

