Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F8DD3B6C07
	for <netfilter-devel@vger.kernel.org>; Sat, 11 Apr 2026 18:57:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775933848; cv=none; b=H8HvIyeDAtjm85z0Zayilb1aDSbszpt9c9hmk8zZvPuT06dCoX2GiXFUV95ie190FIUQGSW7xorzRKYzp/exp96usO01MRiZly2QhC8A7m67PM841K8tQADrFYK3ijB4v1LGTqBWDnCfA5/gla+mA2Csn0aP2ayxlL3DXlkqgDY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775933848; c=relaxed/simple;
	bh=s8DvPKpa7mA+qHyXVl0NHzUIBYxwCvFo6gHuWEJk5ds=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=FTQomQe+zxhA74VdxdnIR7GULyelx9DrnxKizikpEktBjhskLlRiBRtQKIaoanW6iVdfMaX33GTJdaCxBYL3KmDBcYcLSutvX051AE9HhkvAhRA1O6kbU2SkARBdSCihgKhmaVON0MfWiXlotGdq2B0b/MeCkIV4eGOV8bJuIiE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hYeH1gIm; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hYeH1gIm"
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-4887fd35e60so21508375e9.2
        for <netfilter-devel@vger.kernel.org>; Sat, 11 Apr 2026 11:57:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775933845; x=1776538645; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=asmRMjtAdynfNNM/fvaGPOkC+0FMwoOWdK0OJmKnM5g=;
        b=hYeH1gImvN7NJBo9KDzRBfBCU34VMqRUt3zcgO3EWYAsUqIY5OTjRLykxui8j5YE+L
         XOfSgf5Ktids1LRZsNLletkNN9fgWzWM/0YSYo/l5NiRTt6XKsttoOnDhLty1t4+Bw7z
         /pSrJZ1CAMvWigIzzRCz6oBAPrxKYkN/4Ml7zKuVJGLsl3kmUWJy9lX/xJWy28H5irfm
         IQUUXCSxLLeWFulg0mLsBmgj5JwH1PxeAAObMroxcbsQHLFDn5/cf3wUC5PlZEVxXo6w
         SCffgYGNqdPVFQGYyn4nd9Woq3OiPmOxpFv/4EL5o6aVzXJZosgZ/1KY1CCl8L3XLk21
         py9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775933845; x=1776538645;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=asmRMjtAdynfNNM/fvaGPOkC+0FMwoOWdK0OJmKnM5g=;
        b=QoRICbMVMDKTAQhyS97y43wbK5K53oxB2eUjLK9ABI0Hxo3fOSklPHmGeFwCV6AQUI
         o0D4UWhYNsT/nAtOTmoRVBpEKIPQEP+HzVpksMsxQAOdQpePaCAbubs8BWf8/prOyR+3
         HqpERt06dQEU4Mm57N+qkUPpTa4z83/vR4t4ze2TUo6qdgGyKyn41vILFDgmeN1UjhHh
         /Udw/YsNVfQrD5ycRSV543tsJ5N9SWXZWsBe/apBnjfLJQDm5UtXm0eZlDLhXAIyHX6X
         KgHk8BHkYL0/Gj5DI39WwGRDQZVNhYK2V6/sMSzBag0LTSNfaO76dY3VKAFHpcy+1LnN
         W+6g==
X-Forwarded-Encrypted: i=1; AJvYcCX107IQ78SrpJw7MkLdC0SV90LTxu/f/+dsd5rWkKPHkmWb1UlTGOXl2UXAD4C4P+rs9JsEtq/xTNmHr4q2ezg=@vger.kernel.org
X-Gm-Message-State: AOJu0YzPUIW1HSKosTQIHJeq2t6VoYb77dbLGSqhjqTMvDaE/MgDCx46
	7m9FI7i66//bJjAzlM/gViT8qkP01Swr8vF8w1grmni+JwRmtBMtaWDL
X-Gm-Gg: AeBDiesKF0b0nkuMYrFwdWwJ1jt3usoZUSosSKXc7L4z+OOQvsFzbbIyqypdh5bFrQz
	xihrpn66zn62kTAboFDcIA7kCFxu8Skn1H3YDehqf14OG29hEHp7BVZwocxFupsglJJnheXNSnN
	oOtrgB2YDcShzz5BngDrRwNBGzvAya2jIOAinwunO1XlLVLM0sZxT6EaviE7j4OX0lMXdThSLTD
	SHqbjjTLcrBZs0UqzzXer3Aa4rtNiV5+dP/0ggmUlqTSfWGkJ70Vw4eYfVVu/HpaS6KU7RzJth9
	6dR1I2ZEsVp4IVQ/+y8pxNtBGLf3gIYumOHu0gUOOkWQYgYfOl9PdQE2jS/FJCE5Vecjjp9QCl3
	KvRV/Ao98EUAy4Y/lT9QZMFeml47fJ3EfgQoI4QecZNN41Fk+dEpKuUCwKgHQJRfa+KO5sOsbKM
	YzZsgv7q7MPsRYZmgLGKwEY6MC8GjYuBgVXUzJZWv8lVuZh2MCinmdsWN7SvJRw84RIXHyNh5cB
	Mytg0Xg4quO
X-Received: by 2002:a05:600c:350c:b0:488:9661:2570 with SMTP id 5b1f17b1804b1-488d67ce8c2mr100910025e9.8.1775933844696;
        Sat, 11 Apr 2026 11:57:24 -0700 (PDT)
Received: from dohko.chello.ie (188-141-5-72.dynamic.upc.ie. [188.141.5.72])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-488d5d703c1sm52012375e9.3.2026.04.11.11.57.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 11 Apr 2026 11:57:24 -0700 (PDT)
From: David Carlier <devnexen@gmail.com>
To: pablo@netfilter.org
Cc: fw@strlen.de,
	phil@nwl.cc,
	kadlec@netfilter.org,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	David Carlier <devnexen@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH] netfilter: nfnl_cthelper: apply per-class values when updating policies
Date: Sat, 11 Apr 2026 19:57:21 +0100
Message-ID: <20260411185721.234936-1-devnexen@gmail.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When a userspace conntrack helper with multiple expectation classes is
updated via nfnetlink, every class ends up with the first class's
max_expected and timeout values.

nfnl_cthelper_update_policy_all() validates each new policy into the
corresponding slot of the temporary new_policy array, but the second
loop that commits the values into the live helper dereferences
new_policy as a pointer instead of indexing it, so every iteration
reads new_policy[0] regardless of i.  An update that changes per-class
values is silently collapsed onto class 0's values with no error
returned to userspace.

Index the temporary array by i in the commit loop so each class gets
its own validated values.

Fixes: 2c422257550f ("netfilter: nfnl_cthelper: fix runtime expectation policy updates")
Cc: stable@vger.kernel.org
Signed-off-by: David Carlier <devnexen@gmail.com>
---
 net/netfilter/nfnetlink_cthelper.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nfnetlink_cthelper.c b/net/netfilter/nfnetlink_cthelper.c
index 0d16ad82d70c..34af6840803e 100644
--- a/net/netfilter/nfnetlink_cthelper.c
+++ b/net/netfilter/nfnetlink_cthelper.c
@@ -346,8 +346,8 @@ static int nfnl_cthelper_update_policy_all(struct nlattr *tb[],
 	for (i = 0; i < helper->expect_class_max + 1; i++) {
 		policy = (struct nf_conntrack_expect_policy *)
 				&helper->expect_policy[i];
-		policy->max_expected = new_policy->max_expected;
-		policy->timeout	= new_policy->timeout;
+		policy->max_expected = new_policy[i].max_expected;
+		policy->timeout	= new_policy[i].timeout;
 	}
 
 err:
-- 
2.53.0

