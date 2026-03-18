Received: from mail-dy1-f195.google.com (mail-dy1-f195.google.com [74.125.82.195])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFD261F239B
	for <netfilter-devel@vger.kernel.org>; Wed, 18 Mar 2026 02:57:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.195
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773802629; cv=none; b=SA0lgHR8uLVytxWEoBb2tIJFef2HC/74sJHBtGZ8Daug+TaUQR7tTG+g9H6NFvdiptkhwjIOIm9ptLGkq1x1zB3rqRTaujydSUFKlj/0ebhk2nOUrgQhgU00KnTR66UVAvsiZfAhVpr2axG9IjKIIDqFihDLtdTpqsW/HrZirLM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773802629; c=relaxed/simple;
	bh=z4+QvH+TUpUIjYRhEgTxJeZhbWVmho7XnB8fRdwlEG8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=QjVNMwFhac/1Vs5urlLxOPOIGjWCDrCFfjuCzYczqyU8J5tC2crJ5dHERcQbcLURzbyddb6jVK33iJS8k5ZcWI2MFGMhnIp7c7SSGJk8OvCezXmSoz1zRhTSbmp7Ilt/9xAWtOETGyHBQmECQTupgGeke+eiy2USacjyTbJbq6A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=IGAjDy61; arc=none smtp.client-ip=74.125.82.195
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IGAjDy61"
Received: by mail-dy1-f195.google.com with SMTP id 5a478bee46e88-2b6b0500e06so7628983eec.1
        for <netfilter-devel@vger.kernel.org>; Tue, 17 Mar 2026 19:57:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773802627; x=1774407427; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=9+mMmf/GitB9L1jBesSILiOox4z7ggg6WNKP1tStGFo=;
        b=IGAjDy61udPxpfl1GF0b9VlpzxegBlIRZ98iPJpwsDJT/zW7R3rLCjVl7XCBpZujTP
         CVpim0x61dCBr+8BPCjH9Znfrx8Y+WzrJm5qd45/skFcfSmj75SCGfClQB+zOYgRsIsH
         q6aY8VtT0xjjnhfBT4eLLefAf1aNSWazg9KSWXxUJJlOFEvFrKnACJhCuaWG21lABBB4
         +lCDz9fYN1W0J/yhvmSVhl+dsrZVDdM82U91N1x6jUYlbnMyYRkG/9XFX71QDUYt8nkq
         iO3ISo5kow0Efu2kF/z2+zsH/03rAzacYRTyvOnw/ctW2IHBq7Dsc6ZOgfeSbdVq6V/l
         z5Gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773802627; x=1774407427;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9+mMmf/GitB9L1jBesSILiOox4z7ggg6WNKP1tStGFo=;
        b=S/Q9s5k36qWvQgIo/4laBGJsyL1nxJv/sMrNhzJrIPyssCppTHQUskRcU65xaaG7ZA
         55rDRWsfsWSqzje/t4x7NQcyoBL5qMhQn2TzOCYnWkOswIENhuj3hZ8UO6N+rG4PvZY8
         msnPG4OPmyHo3t7h3KM//1gXqA2tu2wEe75gtG9LgeN9r91uqwY/mqjFRC56KCWk/Dk6
         LxqVbz3ECFnEarvCMtWXgEPCL2/6TG5GraFkeSCFALSwYKE0SBI7NvaQTOiX20UFhrMO
         ktt3PxCfyuq15wl78+h/XfaIznss++TpXmVMSQ56rKoI8SJl9tEDSpB/0+t7k9vVnE0O
         4b+g==
X-Gm-Message-State: AOJu0Yz9X2bnt36t4SWloUUI/gLLXsLlOspLYVuvMNsO4bn1Ol/0oE7z
	4jcoW1fnYcOuQA1OZZf7LRo4Bpd1sZoBeiM+pbU8rsQ2Vsg0kitpHLs/AiIZ4Li+nu0=
X-Gm-Gg: ATEYQzyTWvejNIHwlZaGB8d9Tb21n5fFPOjTX2pbApJOueO8OZ3KbqBRRYVX7hacclM
	sWONlGX/kwlTCWWxNRKzSbJicN+voP5Z/T6+492xvzHXDubSto53bplUvu8wCoKdBssL1/M8l6x
	LHF4wOPjcM6EBZL4UwpzPyC5Mdd31Z7p0mP1DXBYufk0FJ5Zv5EfP5B2OTGnrtf1Vuzu+l369oV
	fvir5cBq96qL1ANn2TMmx6a/3kKHIk8jnIwJKb06EFAG+xAYHUtRhCQTFqppdWh1PwmtkPawFk3
	e808PUUFXPqGklV8WJvmEGemjyxxaRa4u+DcrEqukRud0VwW8Zg5v57bTQb9PSPsv2UHsjfDSFl
	GIzfLjKdvP5LCOsnhBRwova5ZGLMIcRUs55ShoKV8SgtRkSVCj5nDJjijTqGGLoP3lgKDZUY8Ob
	NFI/3yrPgCRWkbcZt9AuVq6EZHBV7oBuAeiztjb6ib6jstwjH8DF7iQMQMcw==
X-Received: by 2002:a05:7300:3205:b0:2be:e4b:60c2 with SMTP id 5a478bee46e88-2c0e507ed98mr868420eec.5.1773802627323;
        Tue, 17 Mar 2026 19:57:07 -0700 (PDT)
Received: from cl-pc (2607-8700-5500-3d9a-0000-0000-0000-0003.16clouds.com. [2607:8700:5500:3d9a::3])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2c0e560fb5fsm2521485eec.31.2026.03.17.19.57.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Mar 2026 19:57:06 -0700 (PDT)
From: chlorodose <chlorodose@gmail.com>
To: netfilter-devel@vger.kernel.org
Cc: chlorodose <chlorodose@gmail.com>
Subject: [PATCH] src: Export nftnl_set_clone symbol
Date: Wed, 18 Mar 2026 10:56:51 +0800
Message-ID: <20260318025651.151116-1-chlorodose@gmail.com>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Seems that nftnl_set_clone is forgot to be exported, we add it back.

Signed-off-by: chlorodose <chlorodose@gmail.com>
---
 src/set.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/src/set.c b/src/set.c
index 54674bc..e5e51b6 100644
--- a/src/set.c
+++ b/src/set.c
@@ -360,6 +360,7 @@ uint64_t nftnl_set_get_u64(const struct nftnl_set *s, uint16_t attr)
 	return val ? *val : 0;
 }
 
+EXPORT_SYMBOL(nftnl_set_clone);
 struct nftnl_set *nftnl_set_clone(const struct nftnl_set *set)
 {
 	struct nftnl_set *newset;
-- 
2.52.0

