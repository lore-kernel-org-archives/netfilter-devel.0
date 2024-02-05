Received: from mail-oo1-f44.google.com (mail-oo1-f44.google.com [209.85.161.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBE3EAD32
	for <netfilter-devel@vger.kernel.org>; Mon,  5 Feb 2024 04:45:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707108352; cv=none; b=AYxNtkKSVhnUdf+B3BBdhDVbqvKPtc67nqm2sQpp70F7Ai/EtrgWsHdrau9Ox2T+FOp58kjWu9y/6sAmj4WdkW2tQLF7sNEaJFVRwbiv3NcDKeDYkNxTQ4vwWgdSLjXi2pIzY7RDGfKpAQ/tYzzwT6Ewamp/65siC7WVqz5ggWs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707108352; c=relaxed/simple;
	bh=nnZDfL2lYVUfyeGMgfLB2kVMymyfHCXbZUS54zB1Tvo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References; b=e2fhR4EFEs2PPjBMABIG3PUm48ifVaZhO/z7HKnI0cHE8KgjC8zNr4VpJI8kxX6orYrQ13XyMLtUSIqR/0S/3IyShznxQepCRwrpF2e8lW8PIeNBZ0mfqO4AYUsmYVxqI3fTs+fz87qvWy2bpAW2rQwGHRSubBivmYH+3o2iaLc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=CPbdZ1+p; arc=none smtp.client-ip=209.85.161.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="CPbdZ1+p"
Received: by mail-oo1-f44.google.com with SMTP id 006d021491bc7-5986d902ae6so2579466eaf.3
        for <netfilter-devel@vger.kernel.org>; Sun, 04 Feb 2024 20:45:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1707108350; x=1707713150; darn=vger.kernel.org;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=+l8cKr2Ar+3gm80Z7qi74idXrPpugT+r6d47IRBYS9g=;
        b=CPbdZ1+pUknOpXGs8c2aOTW5Z/0RnCricIOUqj9lIyuCZTDewS0tSvqPvJirN0Yexj
         mV6+s8KfSJQcEW4eMdf1jZRPH2vH4zso1MqDFPEP2QSmf8zzfDHk+4CQ/N0mU9ZM52S8
         i8EuPEVihCOs9gN968SbEka5bYUf1QlogvoZc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707108350; x=1707713150;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+l8cKr2Ar+3gm80Z7qi74idXrPpugT+r6d47IRBYS9g=;
        b=N6OWFC7I2STXrQXqgukTaSUN8BOPBB1zTE5qsP+l+3PgBeroQWr0g6OPevP1wyWqd/
         6/BJ4T86Fx2nndh4JWgNllfR3+h6AAyDlJgybevRSUMVN1J4rVYLws2BqCvx/s7Plox0
         8/DFxNEzuX8p5GwbfCd3Nq9kbVh8ccaBsiIV8sSQxKAjOu4PBJp4pC9OpeET/TT2fUaQ
         m2MLTZgLOWSjLmAX6W06qtq1mYAqO9mciGagFfjsMHzu0Iz/IctbAb+MSoxJgk0eWaKC
         EnRXXQ4r3hVv5o0KB0ONVHubU8UnO7Ewjfb8lN6N6yzhnOo81CNHgQzMNS0M/UzBi2ol
         cVuw==
X-Gm-Message-State: AOJu0Yy0gKUzAMK5PrwINt8MpdO9IuumK5X60beCoAKX7juIHL+lRlBx
	xZIFgEdGOt3/lgEyOmrDpkh1Lsm5YOUDg9B8Yoke1eqGpjWB27+V/FX7ChSf7A==
X-Google-Smtp-Source: AGHT+IGLMowC6WyzR8w+BTpjGzc6iPM2N0JN8gb7a+0G98ERsVa31G2lPl8Fn3u/yexX5CCcsFV/3w==
X-Received: by 2002:a05:6358:7e4c:b0:176:3457:c380 with SMTP id p12-20020a0563587e4c00b001763457c380mr16650091rwm.6.1707108349845;
        Sun, 04 Feb 2024 20:45:49 -0800 (PST)
X-Forwarded-Encrypted: i=0; AJvYcCVjQV4S2ybY8pGan8KqUeVvYMJi6ijevtOYAi0NyG00pUt9STw260/xIUjHY7i2uw5xni2OohqS+qNGSbUbKsqZuDqV2Q//VCP9PIj/7DK0RDDOtyTww/A1cEFgL+2W1iETz2CrEzhIGoRJo3ocAYwZzPB3w+Iy2kqOUyZRO91u9tJU1Uz6MIXEdBS3RvE2/wBuzY4a9qzlUlXEDWbHFLH8Bq1cZioblAuauN69ktdN0zf1WKSiUoicD6c4IEGjIvFzTC4plu5SSoY/NHVVfo4pJG8P70dzemWzIMbWkSvieh5uAhddCkpI6oHq92o361e+MtbmX/fMnwbG7q+ZABmKaKH2qeB4MfPegltEx+SfOI1wtb0bSZB75b17qW1/ivM8i1qfKpDDJTBkJbh/gOF1gIDFjeAFq9PFaT5z6+Nb7RUj7pDUJHU55aY1njeP4CvpE2w/4CsWz26PaL2GeI6Ay0GuQTynkUQ68PlguRc//Of+p8hwhiDjYm0+d2JNsOIbl6moQvmu+wYo91LWwnzQyM6Ft/M=
Received: from akaher-virtual-machine.eng.vmware.com ([66.170.99.2])
        by smtp.gmail.com with ESMTPSA id bn23-20020a056a00325700b006dbda7bcf3csm5629859pfb.83.2024.02.04.20.45.47
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 04 Feb 2024 20:45:49 -0800 (PST)
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
	Dan Carpenter <dan.carpenter@linaro.org>,
	Sasha Levin <sashal@kernel.org>,
	Ajay Kaher <ajay.kaher@broadcom.com>
Subject: [PATCH v5.4.y] netfilter: nf_tables: fix pointer math issue in  nft_byteorder_eval()
Date: Mon,  5 Feb 2024 10:14:53 +0530
Message-Id: <1707108293-1004-2-git-send-email-ajay.kaher@broadcom.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1707108293-1004-1-git-send-email-ajay.kaher@broadcom.com>
References: <1707108293-1004-1-git-send-email-ajay.kaher@broadcom.com>
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
[Ajay: Modified to apply on v5.4.y]
Signed-off-by: Ajay Kaher <ajay.kaher@broadcom.com>
---
 include/net/netfilter/nf_tables.h | 4 ++--
 net/netfilter/nft_byteorder.c     | 5 +++--
 net/netfilter/nft_meta.c          | 2 +-
 3 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 0a49d44..cf314ce 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -130,9 +130,9 @@ static inline u16 nft_reg_load16(u32 *sreg)
 	return *(u16 *)sreg;
 }
 
-static inline void nft_reg_store64(u32 *dreg, u64 val)
+static inline void nft_reg_store64(u64 *dreg, u64 val)
 {
-	put_unaligned(val, (u64 *)dreg);
+	put_unaligned(val, dreg);
 }
 
 static inline u64 nft_reg_load64(u32 *sreg)
diff --git a/net/netfilter/nft_byteorder.c b/net/netfilter/nft_byteorder.c
index 7b0b8fe..9d250bd 100644
--- a/net/netfilter/nft_byteorder.c
+++ b/net/netfilter/nft_byteorder.c
@@ -38,20 +38,21 @@ void nft_byteorder_eval(const struct nft_expr *expr,
 
 	switch (priv->size) {
 	case 8: {
+		u64 *dst64 = (void *)dst;
 		u64 src64;
 
 		switch (priv->op) {
 		case NFT_BYTEORDER_NTOH:
 			for (i = 0; i < priv->len / 8; i++) {
 				src64 = nft_reg_load64(&src[i]);
-				nft_reg_store64(&dst[i], be64_to_cpu(src64));
+				nft_reg_store64(&dst64[i], be64_to_cpu(src64));
 			}
 			break;
 		case NFT_BYTEORDER_HTON:
 			for (i = 0; i < priv->len / 8; i++) {
 				src64 = (__force __u64)
 					cpu_to_be64(nft_reg_load64(&src[i]));
-				nft_reg_store64(&dst[i], src64);
+				nft_reg_store64(&dst64[i], src64);
 			}
 			break;
 		}
diff --git a/net/netfilter/nft_meta.c b/net/netfilter/nft_meta.c
index ec2798f..ac7d3c7 100644
--- a/net/netfilter/nft_meta.c
+++ b/net/netfilter/nft_meta.c
@@ -247,7 +247,7 @@ void nft_meta_get_eval(const struct nft_expr *expr,
 		strncpy((char *)dest, out->rtnl_link_ops->kind, IFNAMSIZ);
 		break;
 	case NFT_META_TIME_NS:
-		nft_reg_store64(dest, ktime_get_real_ns());
+		nft_reg_store64((u64 *)dest, ktime_get_real_ns());
 		break;
 	case NFT_META_TIME_DAY:
 		nft_reg_store8(dest, nft_meta_weekday(ktime_get_real_seconds()));
-- 
2.7.4

