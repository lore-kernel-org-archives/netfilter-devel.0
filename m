Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D0FC3164D6
	for <netfilter-devel@vger.kernel.org>; Sun,  6 Sep 2026 13:30:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788701410; cv=none; b=K9xEfpKg8G9hM87Jcw6tXSrBH4GSURIs83nsTHu2XBSsy3ziFrnWPWVAUEreFfkF5LS3ZnB24V/OsFNzNlGSzgSs9OCB5Y4Pm9XOKTu1WjY3Fo1ZGMgpPJ3tJrIc9w5VgJ0DMkB2Cb+S+hEDTBm/fl3VXS2Af4Rd73ClrOWvv+U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788701410; c=relaxed/simple;
	bh=7PIdO0C9g6GmZA2XPlIjQayPM2GVw91N9uAC66Ycn3o=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=CNTUWfvT2l8bUz40vSGrXoVA6D58MZ7+U1mQC72ffyarQFZmjD8CwQoVSRt4+TdPTq0VC28JWbsh/Au11AzayoUKMIbY1+Rcj+mYOaL1nYG/sfnetdy3s55f+4WS3R4frfmtK6PeBjU56YbQpofx1WR4bRO4g7U9aV8a+94yOog=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=nebusec.ai; spf=pass smtp.mailfrom=nebusec.ai; dkim=pass (2048-bit key) header.d=nebusec.ai header.i=@nebusec.ai header.b=HKiV256u; arc=none smtp.client-ip=209.85.216.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=nebusec.ai
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nebusec.ai
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nebusec.ai header.i=@nebusec.ai header.b="HKiV256u"
Received: by mail-pj1-f47.google.com with SMTP id 98e67ed59e1d1-398e9698a70so2287954a91.0
        for <netfilter-devel@vger.kernel.org>; Sun, 06 Sep 2026 06:30:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=nebusec.ai; s=google; t=1788701408; x=1789306208; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=33EeFuL1jPktV95bqEOjTxPhv2IbJ6VcN5Tff/a0HkE=;
        b=HKiV256uMcdsP0ezryZTWOI5mBQbwKJN3VGKYb1j7Hw9ZJPeDnBVmqNrlepgbf6J1+
         yJrZ8knxGSz6KVrS1sMvLvYYzrmuyhz6AHF4g6BztedzsKykHS4YQjuDczX+RHPxoZRN
         Y/Yz+9igQ1ndLPyu6TjC1TrWeasmt4jQGmWkGdcXgGP+JNQSJCzKVVudUYL1wuREBWGu
         mT+PAeE2tEE0KWuFytuzxFaLCoxrd9X4BacpeWvXOH4AA0ZogGCIqnYCX1/wtvTCfUWm
         kERRENZMvW1GOsq//0ETH1bqMae0bVr3JgxHadx0Pb+bKU+X+IWjYtHm4H/yZEbHrLWS
         T9AA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788701408; x=1789306208;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=33EeFuL1jPktV95bqEOjTxPhv2IbJ6VcN5Tff/a0HkE=;
        b=B/Xa9ubN4RMKbxoU4ciwFII8oVr+Ng5fd9SIcH4/GG1SsDDQAe5t1AxbZsXiKuQ0a0
         7Sn9VWr9i8M3qwKwp8iqJuXHDHuJTNu//00ukrQdwpog3yv19lv8aeV+1GgtHu3LrRQP
         pre8X/alLL7zsVK/nqFcFxQalSrjt9hBTO6+ppaY6cSi4TjUXp+nBluXWoYcEVoTWtzx
         Hk0J5tU0Mv/B4/dIO5YhTfY3gMLWipDyTgoPWaL7FJ3LFlZW059/gGcc7C2/s4Y4hiwg
         ylfZpwadLvVEesqHRFoiZkQOMBYulPLYomelAGBB1Fjz5eQLzId6BDjoYDD6If/M5tr8
         pkIg==
X-Gm-Message-State: AFuF++lv0vM7ibNjiDMoWfxS+iLlCn6MzgkK5u/7DkZc3YDet2dVlU+U
	ks3zNwCdt+06lWqje/TwVqVWI7IaqhQVpQh7oxkhIL9WXqtdms4JAWDWZmekoxWgWDdAU7IjHCZ
	X9MYo3W5WbqA=
X-Gm-Gg: AYBFou33nli3EfmNYFkx4UzlyrBCORnbDpK0OPA0lzxgCofxjrrLVh9lWSgMcsg0PKc
	5lsPd+tlUwhlkCOTI0iur2gS3i5jjPPSgVPOj3ep0uurBji8+519QNGmHIGP8/qHpigWcYARpMp
	sq+/oGr0ESBpgOfi3t1jDENE2MLA0w7n0hSBj8wcMrWAx0nseX8dV5f9khtkfHcFR3AcFPHgnLT
	QVUFRDRQCkSVllyAH3mbzxZ9uBZT2wcyi+c5IUlAiAVPKc08kmt0pxAQVm+jXz4+lTw28N7bEda
	xCNDB2CwUQk8sGPO5P9s0gQ0IB5EOYQe0xxi9pnHga/gFgDlqNlKYDIxJy1Ko4AIQffjH7hocWM
	VEL85AE6MlsctUGytiL0dVxjESReBo21CPhYutmE0GLaiD+1Pj5uVQ7TGo2DrpdUv76xenO1WU/
	DY5Nt9yd7Kv8Fsn5PnFe/fZa1GyBrMehdSzOV+kWSTlprZgzeOUseAHySjKw3D89T6sIsrEw==
X-Received: by 2002:a17:90b:39a7:b0:398:9bd1:3211 with SMTP id 98e67ed59e1d1-39b262ab182mr25831734a91.18.1788701408178;
        Sun, 06 Sep 2026 06:30:08 -0700 (PDT)
Received: from enjou-Legion-Y7000P-2019 ([165.232.167.5])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39b26123c99sm15017769a91.11.2026.09.06.06.30.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Sep 2026 06:30:07 -0700 (PDT)
From: Ren Wei <weir@nebusec.ai>
To: netfilter-devel@vger.kernel.org,
	fw@strlen.de
Cc: pablo@netfilter.org,
	phil@nwl.cc,
	vega@nebusec.ai,
	rakukuip@gmail.com,
	weir@nebusec.ai
Subject: [PATCH nf v2 0/1] netfilter: ip6t_rt: fix zero-address non-strict match out-of-bounds read
Date: Sun,  6 Sep 2026 21:29:54 +0800
Message-ID: <cover.1788582542.git.rakukuip@gmail.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Luxiao Xu <rakukuip@gmail.com>

Hi Florian, netfilter maintainers,

This patch fixes an out-of-bounds read in net/ipv6/netfilter/ip6t_rt.c
reachable by unprivileged users with CAP_NET_ADMIN in user/net namespaces
when configuring non-strict routing match rules with addrnr == 0.

v1 -> v2:
 - Move the loop termination check (i < rtinfo->addrnr) into the for-loop
   header condition in rt_mt6() and remove the backwards break check at
   the bottom of the loop body (suggested by Florian Westphal).
 - v1 Link: https://lore.kernel.org/all/cover.1788337633.git.rakukuip@gmail.com/

Thanks,
Ren Wei
Luxiao Xu

Luxiao Xu (1):
  netfilter: ip6t_rt: fix zero-address non-strict match  out-of-bounds
    read

 net/ipv6/netfilter/ip6t_rt.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

-- 
2.43.0
