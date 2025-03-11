Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58E741DF26B
	for <netfilter-devel@vger.kernel.org>; Tue, 11 Mar 2025 02:28:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741660137; cv=none; b=jg4RleH4YH/WgwOkYQAqiOPD65XAKflNnKQopeVF54Ps1TgcLXUEkotHzFiXydy1C3xWM5oREAQ2KyKihjB0VMzylDDbzFic52nm6l7WkCJewvqSV2YzWjHuyocOE9lfZTO8Xw3kaW+65096N7Tq33fwqzKKXtiIIf5igvHKBCU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741660137; c=relaxed/simple;
	bh=b2UvzZoFaSLtubkXfwaDUPuCUKSh9xEp/aq0yqHyNu8=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=bpL2Uo8g7v71oByiPVif/XtGSmil/nKe/pE4tAeq+q2u8aEnPrk+IMaXJdYVdpfAVTUR8RiS9omTofWBBntEMLw8MGk439Xo9YZ3VelFP2JrgPhCbsNwmVqIkYn0zgksBwaoWlMyHpC+mBA4cqp/ZQvjnceGMbbdB7IVQ2leYZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=optusnet.com.au; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XYnoUluF; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=optusnet.com.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XYnoUluF"
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-223fb0f619dso92445665ad.1
        for <netfilter-devel@vger.kernel.org>; Mon, 10 Mar 2025 19:28:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1741660135; x=1742264935; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:sender:from:to:cc:subject:date:message-id:reply-to;
        bh=gl4UV76bqWadUr3+nJ8/v2g6g2ftf68NI8q8PiaFObA=;
        b=XYnoUluFQmqbZbslwRyEd3653UUAElkC1Icvch8PBnsky4IafzFcLxc3C9J4SV7sJq
         n9r2ENpWoKngXAD2V56mtcQ3cWvNv13JXjYhlfAOJqR1KjtPseL83yFlVobnSfaX/mdv
         VsArwzB09HZkvXD/Ual154cYW7zlz13VI6qkFiWY4FzLFmKbc+xVRmJWT3t/jF+crlJt
         GTIE5Z96o7mk9OGonH4egWOz20Js1vkNqlPL1i8s0tFV1MGCCDc6qqSrPu/wpAuQyJft
         WIfoTPbJjLOyBgAhM5K8SaUmXZ6Z2N57bAtc5d1KKdAqcO8iuFFVZbDX+YcmTJyW1kIq
         Gk+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741660135; x=1742264935;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:sender:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gl4UV76bqWadUr3+nJ8/v2g6g2ftf68NI8q8PiaFObA=;
        b=gDjYxJnR69A/NDRaWwnwK54BS4S7VJiAwU32KjO83Zffq9pprB9akyKS6i+5WEwSns
         30fHGY7IwusCrAs0EjMFYPARNrKq7qdPNBINtSrEeFoOu5AtC53VYpQs1snuOV9DNmcW
         YeqnFsf98DXlpLuZfDGkgZh+jjLXXZrlTb/Knyk5A5OrYuD670O7Osinq351ouhTRVft
         IRJOpkmBWdfA/z9+Q3DVeg39A6DNvP7K0HwatAx5nrRQiefQh7k2OTyTgIV9Zws9UZSC
         +EiDME6Az6IxESOQGKJrcPM+EavGVBlq/tqpijGDywN1slphkTqveCa+TE1YPB0PWa/k
         VvXQ==
X-Gm-Message-State: AOJu0YwOHMKqoVyhLC6RyUkgVdkHFdQTUU+4DsmHVqIAwjChQ7EbDVu2
	NXHp0/RQayY6aOdQ1aori6yeOTPssdgqK923vnn7dMacsATTG57YPfLDAQ==
X-Gm-Gg: ASbGncvImAE7awCJ4GXsu/1qxgoHSbwwZRXNei0Zgo5yb7hoSVaAsheVV1DB5Ejt3FM
	2PkwmhoWdetiUfTf2O62X0n2g8JnE27j0H9LcXlB1OXi+Jjw31LTNHMYQPSKOsypCbo6S53L+4b
	PDQEshzNwBanml71s+XfFTaJY9300WZE7g4ccYkNmXjSaSSQEb5CDwrSNqW1+2PkOsETMED9p3T
	zifzp5fCGpXIO0Ma+cie345hoR9yOjQCfQgsGJ6++w8Ci58oj2i4bTPYZ51ztd8GuB6ceQPvPKp
	vSGB5a+pQCU0cAu3vcQuMEh96dQJt3bWOAmb0q1Gvjv1i/2uy9i8HasM2XGk9Di5EsbJzqsk1WU
	u8uGx5mrye2EjRtwV1VkimeYMRGpipw==
X-Google-Smtp-Source: AGHT+IGsSA+gyYX0G+421XWAZTrwspdvfuEZLbm8uqlHAp+h4E5QPfl+Mt6YrUgCsrXsBjIL5rLcGg==
X-Received: by 2002:a17:903:184:b0:223:5c77:7ef1 with SMTP id d9443c01a7336-22592e2d704mr26241715ad.21.1741660135004;
        Mon, 10 Mar 2025 19:28:55 -0700 (PDT)
Received: from slk15.local.net (n175-33-111-144.meb22.vic.optusnet.com.au. [175.33.111.144])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-224109e8448sm85767435ad.59.2025.03.10.19.28.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Mar 2025 19:28:54 -0700 (PDT)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From: Duncan Roe <duncan_roe@optusnet.com.au>
To: netfilter-devel@vger.kernel.org
Cc: fw@netfilter.org,
	pablo@netfilter.org
Subject: [PATCH libnetfilter_queue] build: doc: Fix silly error in test
Date: Tue, 11 Mar 2025 13:28:49 +1100
Message-Id: <20250311022849.10397-1-duncan_roe@optusnet.com.au>
X-Mailer: git-send-email 2.35.8
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Without this patch, the doxygen bug workaround in the previous commit is
ineffective since the test for doxygen's being a target version always
fails.

Fixes: 60aa4279fabf ("build: doc: Fix `fprintf` in man pages from using single quotes")
Signed-off-by: Duncan Roe <duncan_roe@optusnet.com.au>
---
 doxygen/build_man.sh | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/doxygen/build_man.sh b/doxygen/build_man.sh
index 8fda7ee..50ab884 100755
--- a/doxygen/build_man.sh
+++ b/doxygen/build_man.sh
@@ -79,7 +79,7 @@ post_process(){
     fix_newlines=true || fix_newlines=false

   # Decide if we need to fix double-to-single-quote conversion
-  [ $doxymajor -eq 1 -a $doxyminor -ge 9 -a $doxyminor < 13 ] &&
+  [ $doxymajor -eq 1 -a $doxyminor -ge 9 -a $doxyminor -lt 13 ] &&
     fix_quotes = true || fix_quotes=false

   # Work through the "real" man pages
--
2.46.3

