Received: from mail-pg1-f172.google.com (mail-pg1-f172.google.com [209.85.215.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71E9F37BE6B
	for <netfilter-devel@vger.kernel.org>; Tue, 18 Aug 2026 01:56:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787018214; cv=none; b=Y2JYPJwQVeDYCgShz9+pXtq2+w7qVHnHisEhKhqWJU4cJQ9hbIrH4mJ41fyUWWlNvRi+1EELXCV1nAz/HOhf9dINYeVRUGeb5fH24wZVLXk1ZWmI9VV9+Fpth//lVxFdTkeMt0YR2vRI7/a4JAoXMB9K63X84E/r6mP9PhWJXgY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787018214; c=relaxed/simple;
	bh=5Eu7BGMkaNG+b6vtviXf9F/j3zYjYvzwD20ZxJgj4Ug=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rbRCeJWNJ+Cfx8vkWMAAmPMlhZOWFRnH9HNYjp8LanAQEyifP7Q29/Znh50EAFFSK0tjGdCpPrOUIcVeASx2HzSTvoGxnruoAFQkTmin/nJEHHF0zGAVp/uxgeE05N2dWFg2AsA0CQLG/cNlhWOHQMwWRlZI2KOdLS6CPZtSArQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=nebusec.ai; spf=pass smtp.mailfrom=nebusec.ai; dkim=pass (2048-bit key) header.d=nebusec.ai header.i=@nebusec.ai header.b=CzmjDvWI; arc=none smtp.client-ip=209.85.215.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=nebusec.ai
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nebusec.ai
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nebusec.ai header.i=@nebusec.ai header.b="CzmjDvWI"
Received: by mail-pg1-f172.google.com with SMTP id 41be03b00d2f7-ca12086c06eso3047327a12.0
        for <netfilter-devel@vger.kernel.org>; Mon, 17 Aug 2026 18:56:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=nebusec.ai; s=google; t=1787018213; x=1787623013; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=dNFVmMdqAa8jGqZcV6ZGOB1ScoKTBsJr9+JbTOqCfyE=;
        b=CzmjDvWIuGV6kneC3rEbSOylLlOkQa50E/m4Ir5+6um0waLJbD+JCRUQJo9Q3BZydQ
         3SMrthUyZIakisVBQGEIqfxLhoTwzytJrV1iOJrkfgMF3QSNjPaOHTELVzLmxMEkCfmI
         J6HbT1QGx4ggurGj97mgfH5GvJMKelx0w8uIRtCqIt6iikw/0zg1s6S+iZg/T/j8YP1w
         Jlp+dPbOkz41bx/91Xkr2KS9A4VKmdA5hk35TPqvA+yaplXxalNI0RP1Lf+jwWOcxjzT
         la+xGL9Kq31ymFx+s35va2iKPF3r2yKqapjlw+TYUKFIMM81u8anHzLMDmehlE71tL6X
         buQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787018213; x=1787623013;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=dNFVmMdqAa8jGqZcV6ZGOB1ScoKTBsJr9+JbTOqCfyE=;
        b=F7PeopaWXdqiBYGG2uiO6gfTuUoMYWYjHNOia+EYjpXQOe3jdP1uSGcdZyLQF6+R7v
         LyK62BD+1IU3erGqaSBtv/hBsOlUtKP0gQFXHbijwykNGmvIBFFT3uHZjC+zonTedy5/
         dyLQsFExpZmHKhVuetYr66kuMqy8IrOqO9dI0UBW/DNVNVx89MzwW5TaVkhmeTQUMaJ0
         HKop5353eEOjqcPosUnUqcuhligRf2qmwAyuvYH03uqxrQuGS1PhSg7BwLy7XSh1slKL
         Ffm2yK4oBTfC7qLpTS4gr1JjDp/HgkAbVwqLOQNnonHYj/sU1/FWsah9B/STzJtVgnlN
         VhWw==
X-Gm-Message-State: AOJu0YweGBUrdSH+qfWy1y036k8VjkckCyz/GaSmYFwbD8CmrTAXqYhn
	GzAJPw4ksXMGJALpgQsoIFoOu4gREvpFMjkNBd9eSiAHnn8suxyg92+1gj4APrsJXYTlgAD/ySH
	O4pCqUL5V
X-Gm-Gg: AR+sD13F6Xauk429FOS8l9iFrH6xgOTTbL3Q9XeLVxrO+poceq9NXuFnzkRuP8BcVA7
	O6vPqwysImWXCyvbO7eWyepD6qiTMHqsJdsu6lsO4DZ+zgRcl3Ufy4/ghQBSHElwMMhXSdWkpg+
	WF2MFan3UBN0GEv6aS6V+PoDfZiRS1R9FYUe4IvGaVmaHmO9rm/MMHR1s4C1bda1YnAbSlYXYZ5
	dK9FE8w74Htd6gym1qgNyYm6oSh6ARfLAT/OMr3s4S1hdvzCqokvaHQc1m9pHmv00ADJfonTr2U
	Bz/upEJlWjThG1B37N5VdJ+wPOlD4udcBe+NU4Kclis+wgUa3kWbFHJgbKWn+baAOTVpSFNYtF4
	wwR4CR2RoExcKBQbHnCCMJdr7RwtMf+n/9hFVacLVZm9IM7Gerjer8IAYoWgXbENHk4vMUCfN8/
	OYE5dMfsJkMIiHqTQLJMZWcyZi+N7ggkU9d7Oqyx32CIUyREYtvGTT0ODRUjsgJcYGhRV/1w==
X-Received: by 2002:a05:6a20:4321:b0:3c3:875d:c546 with SMTP id adf61e73a8af0-3cc71af3552mr31487231637.7.1787018212671;
        Mon, 17 Aug 2026 18:56:52 -0700 (PDT)
Received: from enjou-Legion-Y7000P-2019 ([165.232.167.5])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1415315900csm10913110c88.11.2026.08.17.18.56.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Aug 2026 18:56:52 -0700 (PDT)
From: Ren Wei <weir@nebusec.ai>
To: netfilter-devel@vger.kernel.org
Cc: pablo@netfilter.org,
	fw@strlen.de,
	phil@nwl.cc,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	horms@kernel.org,
	luciano.coelho@nokia.com,
	kaber@trash.net,
	quic_manojbm@quicinc.com,
	quic_subashab@quicinc.com,
	vega@nebusec.ai,
	rakukuip@gmail.com,
	weir@nebusec.ai
Subject: [PATCH nf 1/1] netfilter: xt_IDLETIMER: validate label before debug logging in checkentry
Date: Tue, 18 Aug 2026 09:56:48 +0800
Message-ID: <b139065e9f62868ac5ed0900faf1dcd13c7e68f8.1786933680.git.rakukuip@gmail.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1786933680.git.rakukuip@gmail.com>
References: <cover.1786933680.git.rakukuip@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Luxiao Xu <rakukuip@gmail.com>

Both idletimer_tg_checkentry() and idletimer_tg_checkentry_v1() invoke
pr_debug() with "%s" on info->label before idletimer_tg_helper() verifies
that the 28-byte label is properly NUL-terminated.

If a user-supplied label is not NUL-terminated, printk format string
parsing reads past the end of the allocated target structure until it
encounters a zero byte. In builds with DEBUG enabled or when dynamic debug
is active for this callsite, this triggers a slab-out-of-bounds read
(detected by KASAN) and can disclose adjacent kernel memory into the logs.

Fix this by moving the pr_debug() calls after idletimer_tg_helper() has
successfully validated the label string.

Fixes: 0902b469bd25 ("netfilter: xtables: idletimer target implementation")
Fixes: 68983a354a65 ("netfilter: xtables: Add snapshot of hardidletimer target")
Cc: stable@vger.kernel.org
Reported-by: Vega <vega@nebusec.ai>
Assisted-by: Codex:gpt-5.4
Signed-off-by: Luxiao Xu <rakukuip@gmail.com>
Signed-off-by: Ren Wei <weir@nebusec.ai>
---
 net/netfilter/xt_IDLETIMER.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/xt_IDLETIMER.c b/net/netfilter/xt_IDLETIMER.c
index bfcf2d44e93d..8f7b1ece0136 100644
--- a/net/netfilter/xt_IDLETIMER.c
+++ b/net/netfilter/xt_IDLETIMER.c
@@ -318,14 +318,15 @@ static int idletimer_tg_checkentry(const struct xt_tgchk_param *par)
 	struct idletimer_tg_info *info = par->targinfo;
 	int ret;
 
-	pr_debug("checkentry targinfo%s\n", info->label);
-
 	ret = idletimer_tg_helper(info);
 	if(ret < 0)
 	{
 		pr_debug("checkentry helper return invalid\n");
 		return -EINVAL;
 	}
+
+	pr_debug("checkentry targinfo%s\n", info->label);
+
 	mutex_lock(&list_mutex);
 
 	info->timer = __idletimer_tg_find_by_label(info->label);
@@ -360,8 +361,6 @@ static int idletimer_tg_checkentry_v1(const struct xt_tgchk_param *par)
 	struct idletimer_tg_info_v1 *info = par->targinfo;
 	int ret;
 
-	pr_debug("checkentry targinfo%s\n", info->label);
-
 	if (info->send_nl_msg)
 		return -EOPNOTSUPP;
 
@@ -372,6 +371,8 @@ static int idletimer_tg_checkentry_v1(const struct xt_tgchk_param *par)
 		return -EINVAL;
 	}
 
+	pr_debug("checkentry targinfo%s\n", info->label);
+
 	if (info->timer_type > XT_IDLETIMER_ALARM) {
 		pr_debug("invalid value for timer type\n");
 		return -EINVAL;
-- 
2.43.0
