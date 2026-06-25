Received: from mail-yx1-f66.google.com (mail-yx1-f66.google.com [74.125.224.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97490381B07
	for <netfilter-devel@vger.kernel.org>; Thu, 25 Jun 2026 08:44:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.224.66
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782377069; cv=pass; b=lyvlu1lJzfUxapOQMkTMN1TDYI3plvblzfRDJk/90yuHaaPDNo4OmYq4TF3Rqcjbc0+K7MnpD5wsJZoSvkXP0ViXmGBd6IlWYvNjOjR3qRrfRmUjbary8o2H1sp+xR1py0lZePAGzSn6bNYCooQNTp2tqJ8wQB3MbZL+ol1hG8k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782377069; c=relaxed/simple;
	bh=6x0vDSzwbnIAM/QhhqHQ00iEvXqxkfdfKEiQts222BI=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=q1CMItsWQJd7od08FqXLfj7fAAwFL+vxgviT7kh4dHD3419Igqg/UdjisC6F2tQUeMvsqTZIl6yQLnx8S48lUfCWu+aa+KGOFrUSDtzKTeBnPIHFmoCa158s8S60Kv8e4zynim3vId2V/OJPge1v90mudNKKrQdDcy1bMji0cGk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=na9eH3ps; arc=pass smtp.client-ip=74.125.224.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="na9eH3ps"
Received: by mail-yx1-f66.google.com with SMTP id 956f58d0204a3-664345f8645so1449751d50.3
        for <netfilter-devel@vger.kernel.org>; Thu, 25 Jun 2026 01:44:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782377067; cv=none;
        d=google.com; s=arc-20260327;
        b=Gfgxh0FuFsjswmTufnnwm0hRZ6qxBuUk/yni1+KyVKVksT9bm4zoYgtNDWtcvuoo2l
         BOscdpR7bgRrwDm4OtUftI8ZwVXDips3YegT56EYhMrGTtg4Ne9VUIadIu0EQMblEHIp
         FN+UB+7gYutxfVK1dVnTl0HDxRV7BCNiLM3s8DX31oiCLFcmw4RWWndxh9/Aoo1BzSY2
         AWU7cRVClLLajtFfDKOWPEdlTNocuH7O2CMpM68r/BjpJjPa8LNmfOVxFDtYTNEjwjcy
         c//euNpmXeYCe3OJ9bJ9zSL4sUl9LP8NBniUV5Yj7zNI7na68tX6ky6hD8ekyjcVBlim
         4uHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=NQLEcmw9htWjZgCPh/azuo1R8RV/v6R/VQ+vHgKTYNQ=;
        fh=i8nWucUDDcuJZrAc5F/lTqZ3W31vqALi8eeFadgPUj8=;
        b=p5t+jyTWAD4ahloX6tDMeMY7lshVTrdDUMc53IgY0ttypMzsPSK57NTIYZFmvdQRJ5
         Oe15cUsyF8eadi1uu4bham5pxDURJGKCfb25wHw3iiq8sf84+E4gn4eFxK+bvrIlswIG
         r+/5YFKUTmfseE5121HAuRlsBGUaTn8JkfB0pqukRxDTS+bgCKapv8FkGJ8CeBv7Q53F
         p1bBvJN15+H6gopXXjzLiGnVnoO19B3aBDSIjTF6x2WaWcty9KTrKzMTOAA7XxFGejx1
         G1UX3bMtCiArJjxaGEtSVboWHLGaI0ZmJaxHIFzbxcZ1S7VUJ0lkRfsFoWJeujq1I2qT
         jeAg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782377067; x=1782981867; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=NQLEcmw9htWjZgCPh/azuo1R8RV/v6R/VQ+vHgKTYNQ=;
        b=na9eH3pspahQYyFFMmvIZpGxojcGlFtinNYqf7i3m0T+1btrFPkGT6yY4/5K8GbGhe
         B/hMJGo9aI/O6dGIcKVpXNJFlLsFoduiv7RTtdguJd69Zlypg7A8rr+8RKpYdBxOSam0
         4Ichr667EPsNFd9WRzs6JtQocT5TroUQJ8W+wnQfRX0qg9glMJ4DuNSUdtPoNZVmM36c
         jEDZIoEhEgZNowV+pX00UUp5nAKD2QiTut7SmvJOf3J3OajxGhxYRmJcuw9Z1oClIIi2
         oMmJhmORuFtnkH9HW1wg1DX+6kHYodTkRMm7dx0hCaLpncROnPEWkncLv/USboJDm4H4
         zHUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782377067; x=1782981867;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NQLEcmw9htWjZgCPh/azuo1R8RV/v6R/VQ+vHgKTYNQ=;
        b=jtVFWTsKymKMSiDqOn+SqQ7t3q3XZdC+sxKXPuvo/hKkoA8npehyULT3/xuO684xP1
         fZLTTJrZr2hYV6NJxEbRdZ362umjxHbYjzGglzo/i+JhtLAa084bNBcTWHfjAhyglKuk
         SG1y0oOd0dt5ystCbrq/0Xi9nC0wwMp8QRMBj09OZquiuOb9wXce2sBYaAc4c2ygwOSC
         SOfV0fGTQK8f9M8ELalw39KM1nPvk6rhzVlLu2ZCKvUhbZzHfB8j5LRAE+hC6KHakjrm
         N83OWE5vO4DPP/04/diRsS1lBa8vtIs6aE5ASUTn6a/ShVcQES9E34K5p0WKX/4P3LMe
         DBQw==
X-Gm-Message-State: AOJu0YwEPSMU5PzpTQTk+VQEKiz/n3sZRPYdu0J8VYLZum1XVT96rwMt
	qfKxPwoFX2UbHd03pZb28ugftw5kotYgd0pdwBEti+bgvEJeE0t/cm0LrM+B9fFzleSmD6oosPw
	z2xrd1xWT6R2JyRLGiQB16UQCpzZejx+fz02gj/c=
X-Gm-Gg: AfdE7ckQbxUqp3LTB2RLwugKb7oiOQ4BRlq9L0WWMt32Xg/I71JLIqwmz6xpXDmDuZI
	GnQ7fthDR9Gxv9CAbaxwPVPQtt3KRl9k3sorYDzQeoe2ZzTg7Vw+GkBRQpA/wUDx/3bupld3brt
	yEf3Ipw+T/N/1sE7mx4iX3MOhqb5XBe71+xXxj08SeJO2Ktp39ac5j6vUS+uB9lS49KmZsD4fOD
	NhrGn7kOjuiWeb8cvbJn/aoBeQrf765upjpwtPDK4n9OGuCSdU6h5MwWjaABCdUC4EEUtJ8kEk=
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:690e:1c09:b0:662:f2d1:f42 with SMTP id
 956f58d0204a3-66487accd47mr1071527d50.7.1782377067508; Thu, 25 Jun 2026
 01:44:27 -0700 (PDT)
Received: from 487349027555 named unknown by gmailapi.google.com with
 HTTPREST; Thu, 25 Jun 2026 04:44:26 -0400
Received: from 487349027555 named unknown by gmailapi.google.com with
 HTTPREST; Thu, 25 Jun 2026 04:44:26 -0400
From: Feng Wu <wufengwufengwufeng@gmail.com>
Date: Thu, 25 Jun 2026 04:44:26 -0400
X-Gm-Features: AVVi8Ce4l09QaJVWm1zDik7Ygakx0Zyvah4UOGwJocYRD3HYVZWOT3NNCWHYFQU
Message-ID: <CACK3muog6f15J=ZL76V68kxp9DZBrXRs173PxSVniGMwgpM_MA@mail.gmail.com>
Subject: [PATCH nf 3/3] netfilter: xt_tcpmss: add checkentry for parameter validation
To: netfilter-devel@vger.kernel.org
Cc: pablo@netfilter.org
Content-Type: text/plain; charset="UTF-8"

Add tcpmss_mt_check() that validates mss_min <= mss_max and
invert <= 1.

Signed-off-by: Feng Wu <wufengwufengwufeng@gmail.com>

diff --git a/net/netfilter/xt_tcpmss.c b/net/netfilter/xt_tcpmss.c
index b9da82691..5f7f97dba 100644
--- a/net/netfilter/xt_tcpmss.c
+++ b/net/netfilter/xt_tcpmss.c
@@ -78,10 +78,23 @@ tcpmss_mt(const struct sk_buff *skb, struct
xt_action_param *par)
 	return false;
 }

+static int tcpmss_mt_check(const struct xt_mtchk_param *par)
+{
+	const struct xt_tcpmss_match_info *info = par->matchinfo;
+
+	if (info->mss_min > info->mss_max)
+		return -EINVAL;
+	if (info->invert > 1)
+		return -EINVAL;
+
+	return 0;
+}
+
 static struct xt_match tcpmss_mt_reg[] __read_mostly = {
 	{
 		.name		= "tcpmss",
 		.family		= NFPROTO_IPV4,
+		.checkentry	= tcpmss_mt_check,
 		.match		= tcpmss_mt,
 		.matchsize	= sizeof(struct xt_tcpmss_match_info),
 		.proto		= IPPROTO_TCP,
@@ -90,6 +103,7 @@ static struct xt_match tcpmss_mt_reg[] __read_mostly = {
 	{
 		.name		= "tcpmss",
 		.family		= NFPROTO_IPV6,
+		.checkentry	= tcpmss_mt_check,
 		.match		= tcpmss_mt,
 		.matchsize	= sizeof(struct xt_tcpmss_match_info),
 		.proto		= IPPROTO_TCP,
-- 
2.50.1 (Apple Git-155)
