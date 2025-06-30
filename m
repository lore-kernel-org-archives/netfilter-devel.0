Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EB83185B48
	for <netfilter-devel@vger.kernel.org>; Mon, 30 Jun 2025 14:15:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751292936; cv=none; b=Q3TNvz6xnPXbXH1e2ki77p1txMrdscqVaaJ2cSfVDw/UHVRr7jdJFqevTCexbQQ3EbfjeBvXQIl8LIAx7prX+TKCKv/k+g+Gex6Ab36fieGjtd36kA9eRdH9+C1LeLVopPUQraSEZSq423+7gyJLQ43ANW0KraNF0+nYkitlZoY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751292936; c=relaxed/simple;
	bh=k7HVfRBcVEn/cv7Ii7Xfl78nJUcQOvy1wL/tL+tKUWo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=oTTRSY9HoGCb3ML7knHXwnhMmGZaSzqndU1u8Dhx5ga45ecZNRTE/NnBh4L39fXD6yF2VuyG+G1yol1G1+YrF1f4QSa6qAPI9rFJi/oFkvIQWauxXj2ffyzJPmy0Q37F/4ZXZrTuY2ZDPdtrj/Orzq2Sa9Ti/7CdnnhhKOdB5YM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=KAu76okH; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="KAu76okH"
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-450ce671a08so13884355e9.3
        for <netfilter-devel@vger.kernel.org>; Mon, 30 Jun 2025 07:15:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1751292933; x=1751897733; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Mj2lbaVnuejNtTsW0BNrwlSH/DV1F95gQSwzYTbO4jM=;
        b=KAu76okHfT/HKBexxPdtGZZC6X6Yu360TeQQiudnsNLZaCG4npUbj0Jj/VTll38d3W
         /69d/fIMGsrWHJOFSRzj7KzN3gU0SWoUddREObmLl++U3+Xmpt1WasyH9QmK7lAOC7Mp
         D3/sO0CybvlSWaEvbc8oh60PXB5hSwNQrZL5qHcIsFq7ygCgsowi2DUt0mF5Hs0JCHIM
         aRv4LuR122wR5f+3oqLQAYf2HMODOODKSmErAjTGSuzfIbUFf8HPni6Gj912YLG/Xh/w
         2rWwmpHoOeXsSIF2ijSkBPYiGqRfZqC0xowjtZToWNvAFcOegMA6i0pDAl417pl6lj4c
         /Igg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751292933; x=1751897733;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Mj2lbaVnuejNtTsW0BNrwlSH/DV1F95gQSwzYTbO4jM=;
        b=XDR3iNcBHho5vWAqltRQEsPSTUitL0K89NTtDujeSSZJYTSYhBAJIBQdGS1kiJOquB
         rQ7iTT5NGG2mcaUDZCfI7c1TwOhQp9ZwKBObBQn1vBDwFoYYlTYrU/7LMvbiEsZLpWAd
         JTmgPwagU/pVQ+NXLjMBDqhqB5MtCmsVHaoEfeuo+vb5o33kHrrY36OtH11EGZO/IuRA
         gdKYPaE92FhqxGZOM8D53gGqgyQxA7gIymzl8NxxIJXjTp1f7E8Z/pDbcuxETSjUOlGY
         MMC9HFKTu43zhedw7N+uJDMwN/3+UZPWVBGtc/dHVBZep77OPjW0GrBDSwvG/kJbBKIp
         IoAA==
X-Gm-Message-State: AOJu0Yx9si1K0VcE4ssndZ47e12KHFxLk8Jx+R5YQuhikyI748cIt8rK
	MF3VVqOEzeyUpvIolAfutU8svIZsaDezWguk5RbvMAtklUB72dt2yIv8EefIuvXlteCiiXptxN6
	y3pPC
X-Gm-Gg: ASbGncsQ3rEGmkoQ5wkjqCq0OKc4/c422cg+OFghqfYaDd4gPVyx8wTmeem6K33Vwed
	LkGu6BS1o9eZN02suJqDH7LKBK/RzTp8HLW1caQglwtEngSznZ4u3Uno7A4MIb8suX210nVvhY+
	3iIj4gCQukcDsebQjegu3kFmGX1+NsjESLjHDvVGb8EWVj04RIN/NjuUinnrCQMu6m0YnUSp4NR
	YdKR3g0xkwwSJFI18uqlNQ7T8iWAs9VfbCWK2xs8F42aV0KD6YLhKnlJ+J312I195sViy/hfVAm
	RyBfDFlfCuh8S3hpLbYI2zV1IdEf4ZgF1jVi+/NQllBOE6naov8r5b5LEqi9mPNa1MNLFucyECE
	=
X-Google-Smtp-Source: AGHT+IHEOKav7GiEnzJSWw0VBLi7bW9kB1YVlldIEfAn4q05DSMC3Ym//FUS6e86mGD52LFDn+EAcA==
X-Received: by 2002:a05:600c:358a:b0:453:66f:b96e with SMTP id 5b1f17b1804b1-4538ee3b88bmr128908565e9.11.1751292932733;
        Mon, 30 Jun 2025 07:15:32 -0700 (PDT)
Received: from blackdock.suse.cz ([193.86.92.181])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-453a1914d10sm27468455e9.4.2025.06.30.07.15.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Jun 2025 07:15:32 -0700 (PDT)
From: =?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>
To: netfilter-devel@vger.kernel.org
Cc: =?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>
Subject: [PATCH nft] doc: Clarify cgroup meta variable
Date: Mon, 30 Jun 2025 16:15:26 +0200
Message-ID: <20250630141526.1102067-1-mkoutny@suse.com>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

The documentation mentions control group id where the meaning is a class
id associated to the cgroup of a socket. This used to be fine until
there came cgroup v2 that use similar terminolgy (cgroup id) for very
different thing -- a numeric identifier of a particular (v2) cgroup.

This contemporary cgroup id isn't exposed by netfilter (v2 matching is
based on paths externally). Fix the docs and decrease confusion by more
precise description of the metavariable.

Signed-off-by: Michal Koutný <mkoutny@suse.com>
---
 doc/primary-expression.txt | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Yes, the manpage nft(8) made me believe, the filtering would work with
v2 cgroup id.

diff --git a/doc/primary-expression.txt b/doc/primary-expression.txt
index ea231fe5..97ce95da 100644
--- a/doc/primary-expression.txt
+++ b/doc/primary-expression.txt
@@ -117,7 +117,7 @@ devgroup
 outgoing device group|
 devgroup
 |cgroup|
-control group id |
+control group net_cls.classid |
 integer (32 bit)
 |random|
 pseudo-random number|
-- 
2.49.0

