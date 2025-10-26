Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C15426B0B3
	for <netfilter-devel@vger.kernel.org>; Sun, 26 Oct 2025 20:41:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761511273; cv=none; b=QkKAMHciOUilr9LyLAPxrVzQ0jERRYu0c9+wI8sWIO1h+zRRtGYPa2D3o7SU58uCrSo/AYZnIww/PtANZcDKKyWIWy9x6dQi9cr8fSDk8eS0jhKL0wo5EOw9LDN2+vD96SIK+2ZHNX0W1KTepAYDpEeVIvuWx+GwgUcjcv1U1ak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761511273; c=relaxed/simple;
	bh=mxd5oQsDYm5ytPCIeqz91gppoGXqRQLmdDYIUnG1MDQ=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=OaItfHpy97L6wTL0ew1MxRh/GoqmxQebe9Y+fFNIPHj+/+J0cCEIeFIeRUcN+UtRjGSYO9JvqkFdOKC9YPSIzEavPpWG+C/h3AYvbA3+nRKsiaDvHU/KfeucOauQ9QcOY1yir9+EalxFdRBdkN3+EqmbMmOF6d0xwUmdFdnfO5k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CaKdDjQ+; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CaKdDjQ+"
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-475ca9237c2so21379355e9.3
        for <netfilter-devel@vger.kernel.org>; Sun, 26 Oct 2025 13:41:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761511270; x=1762116070; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=qA2l1z7qfqetfxnKnT98HUkq+xYJ2/Rl8Yu3qhDFwc8=;
        b=CaKdDjQ+jRo7KH2OCPVos4aDZ5pPfKAB7xxuHLwFp0MAjFPigfcF4h9TnaD0+o8F33
         VwnkfQj8lvEyy1SuEvnQfoE+zewnRfRkx4FDW4NZbqSBVB5RbnIYH1ViFz8FBh1bAgfu
         k2ZnMgphjGUYLh7HuUjhsqE/9+XvBymxP995Szj4f8FyEM0gNf1obXCPRp2jKNXWSkU5
         MOGBAaImVLa8qiyolPyJv/N+UlVXknAL1ljk7geCaF7/q5EXuKGhmY7/LerDX3VR226W
         7OgezMAHDJSB1hzn+YtgQy9wx8DsixWjeUMrLYvZMqGIIij+awjnvBCqfZ5lee0eG5k0
         +b0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761511270; x=1762116070;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qA2l1z7qfqetfxnKnT98HUkq+xYJ2/Rl8Yu3qhDFwc8=;
        b=AO/p9dGN58DKdGiLuAN7gAP8lhM2I5lNWbn8rGjUxGBc+HQ1sZxU31cQkWrVToQpnM
         Vw5sDlvFLFU9jyUiSy/LKnrFR59ezjCLqmoHV26mAOoY9t4R0DQqvzYLKIxsnm/yzxHh
         Yr9DPS3ynMarfVH7MtMk7NfYR/e7YEImBRFcEww2tshcSi1ZRS6eVRwiYx0XBeSNvuoN
         Qdn+NFmMSjlbs6RkEkRmNInyBTmE5l8jP7OSy/Uy64GxJyADfKsTo/4R+XfuPqFnsWYO
         Y2a6Q1gqMLu1CMHyJh4aMWYB8+lbr+SakZsnjqWZ4jTbkWCR0cLMq6O96Tj6ctEVRhh9
         sMkw==
X-Gm-Message-State: AOJu0YwR9lEkaXQCDEK9SY0a4g9uCjD9zZIoprZJAqkcBV0g30st6M4R
	1bLNkHhfxJJmjvIQ2fGOOnBpLesnAd8PMxAFSB2Y8Iz+G/agqtP3qvj6gZnt/A==
X-Gm-Gg: ASbGnctFKa9l/OgtTOynC1zVRcA9wiWOqZvFwdNAHdcTF8ylGvf0uZWLGotEH3KAdjl
	ZlzJkiy7Zwwnd2/+8e7Tfzvd/vSYIkceAnDtvpajeVSlvonSVD1rdYE+BCxndgAvf4dH4wef6U7
	G8S/zApNBNP1KE+TvntXPI2dk9y6dVCEXW6riIoUdCJqwaz2wS3G7KXyXK34p44cLlSeJ+rVgqL
	nNUG3sOUGgitpHXR+apKgATYghwSWDV6kyDAuADUNHviJk9rbxS49HnjfZAa4IoVzJBMAtKoytP
	csvAzl6zFO3deW6LI2algo4kq5IbvHiHLWGb0v0l8nXYanRc/yOpGdWx+iYS3oOZQgrlSMHF8tB
	NRtwhzAvVjoKVK8z9EGntrqHq0llMx4T2idg0pB/hYzNtctofJeg8kcrpG5bLRPRGy9m6W2z4Rw
	==
X-Google-Smtp-Source: AGHT+IGWmGOB8bMFf2eQN4q5JyUvj0NvA7LiClbK1c632LRDnm/aI9UTh4eqxvLNbsOjonkfO0g8SQ==
X-Received: by 2002:a05:6000:2287:b0:426:d5ac:8660 with SMTP id ffacd0b85a97d-4299075246cmr6872193f8f.58.1761511269754;
        Sun, 26 Oct 2025 13:41:09 -0700 (PDT)
Received: from desktop ([51.154.145.205])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-429952da645sm10011498f8f.30.2025.10.26.13.41.08
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Oct 2025 13:41:09 -0700 (PDT)
From: Gyorgy Sarvari <skandigraun@gmail.com>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nftables] tests: shell: fix typo in vmap_timeout test script
Date: Sun, 26 Oct 2025 21:41:07 +0100
Message-ID: <20251026204107.2438565-1-skandigraun@gmail.com>
X-Mailer: git-send-email 2.51.1
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

While executing the test suite from tests/shell folder, the following error
is displayed many times:

tests/shell/testcases/maps/vmap_timeout: line 48: [: : integer expected

Looking at the script, a non-existing variable (expires) is tested instead of
the existing one (expire).

This change corrects this.

Reproduction:
NFTABLESLIB=/usr/lib/nftables
tests/shell/run-tests.sh -v

Signed-off-by: Gyorgy Sarvari <skandigraun@gmail.com>
---
 tests/shell/testcases/maps/vmap_timeout | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tests/shell/testcases/maps/vmap_timeout b/tests/shell/testcases/maps/vmap_timeout
index 8ac7e8e7..55d1c1b9 100755
--- a/tests/shell/testcases/maps/vmap_timeout
+++ b/tests/shell/testcases/maps/vmap_timeout
@@ -45,7 +45,7 @@ for i in $(seq 1 100) ; do
 		expire=$((RANDOM%utimeout))
 
 		expire_str=""
-		if [ "$expires" -gt 0 ]; then
+		if [ "$expire" -gt 0 ]; then
 			expire_str="expires ${expire}s"
 		fi
 
