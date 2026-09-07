Received: from mail-oa1-f53.google.com (mail-oa1-f53.google.com [209.85.160.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 314AB448B9A
	for <netfilter-devel@vger.kernel.org>; Mon,  7 Sep 2026 12:03:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788782642; cv=none; b=iHri4oAA/mHPSpk9WQ8ZYSncOLvrQtNgI4/tWwSDCrW/v2gP/gwsBHhMfr0dpoMk2b2c1OVxy2sinXYP2WoomO+m3V8+N+yVd5AW9hMfzDZeMseWLZJ7UPEp52KpInzBcLSkGMbIcXxUx3M08ha+J84HwKrvJkOC0X/BVs1Ab+Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788782642; c=relaxed/simple;
	bh=iNcAvDsCMWMPqeX0n+cuPSqJfU9belC57C2dBepOcxI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GSM8QChOpbiPZM47Qfm0um2wptc3ZQsxfJrbYhTFAIW+gkVAZQZRBW7/zKOt0F1MhDvrdqA9oYi18/qRdkN5BUkjXnEbbgu0Gv2lbeaZpAc2fY4eMAJUhpAuWzgorp/fxZfgB3GG4a2/4pN2SJx7c/9aYJvYeG/FB2IE+IX8j74=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=nebusec.ai; spf=pass smtp.mailfrom=nebusec.ai; dkim=pass (2048-bit key) header.d=nebusec.ai header.i=@nebusec.ai header.b=bUXYJPX8; arc=none smtp.client-ip=209.85.160.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=nebusec.ai
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nebusec.ai
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nebusec.ai header.i=@nebusec.ai header.b="bUXYJPX8"
Received: by mail-oa1-f53.google.com with SMTP id 586e51a60fabf-46ac75b44b2so1375921fac.0
        for <netfilter-devel@vger.kernel.org>; Mon, 07 Sep 2026 05:03:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=nebusec.ai; s=google; t=1788782639; x=1789387439; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=lEqj1TTWjxSkZwYSyC8qfEGljr+Gp1rlIvOYHuUYhJc=;
        b=bUXYJPX8nJUCf+F5Lpf3OQ673ztV/tK7nqC7hJUKPKCjoRZmOGD64Ru/70BLeD7L2c
         qlxORFfFDLEW543SYKZno3sByyDRIQN4PA0JCjHPXhJ1Hdp6sycj2d2sTM8rlB+ALMV9
         zcf50w5BR7beOiO6HbiVl3GJWSyHj2KD1MkkBop/iQWKWbO1ddKwvd52cnNqR7fCycKX
         fTam8a8EfdqnpBnpE9ye2H54ZcR4t9j184anu+HMEFK+OVM5h2wb/DFOqlaXwTA5b0Aw
         2VQNfs4WDYIwMbYMM64YxkHVLkLyZAaEFpLyJ5Xah42h4sYa7SzyCvvxSCs5zq2Pybjm
         GDSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788782639; x=1789387439;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=lEqj1TTWjxSkZwYSyC8qfEGljr+Gp1rlIvOYHuUYhJc=;
        b=JFvKvFwiO818QlcfzKy+bFTvfD0GBizLFbQKMsSnSJEL3hWcDC7LoEh9GcgbF3XkGO
         8WahE0KinasKP/2/QEyiq2nwdl4DH145eOyfjEkEvcHzvMG8qYmWQIwFGlcGvYcJi0qy
         ppLHRnyHOK5CZMQBTp6LBMx+7rBoB3zCfaHTPb4dXEpgM3ffCvHI1TKEERfHZjhE8bWt
         CX5sbfI/KD8UTljPnfGkS033zZziz2PGcvchT/o2RRaWiCvWMNRSZFYgF9gUZez231XK
         qUqlakLmkUUz1lzbJJqWsjnQJWEpwccrC8UL7mPYwFBWtO4Nc48xFR3Plux1l+6c/3uD
         70iA==
X-Gm-Message-State: AFuF++nLBN64z9/pRPEJIu8GZdV4e3BQ0kbOzgV9YG21Sn/wEKyOH/z/
	Z4ILrmbenexHuKZGK5r53rjtqwcRLUN4pxIkUBJP5DwfuFl6IYL1WZFm8TKP18gMQ1zYdpGucr1
	iX3oRt8aBFjo=
X-Gm-Gg: AYBFou1yhV2hOWYm8OCLMiqcldwiKV+yBHaz1nTAYH936EwAgzpJNCKUDTh/E13+pXo
	26DZ/LU39ZML1A0fdNAsKfRUNsUrLple+MMC5sP/CYX6KEh0rRqC9tWfqFf5tyVq5sYgk5vf/qy
	ATuCeI+2PGdU5YdiQjvTf6jrKGa90Aff+8D5mi3WxsaQwIo4QkdbAyHGvJYG2TigxognOgVNmrw
	QnWK1g4QsywKas1zeZXtCQ489N13hUCIfUWuCC7iggk3FbwJnN7V32BCZ+YzC2i62OiSSuUTEn4
	o9f2J55/aBK5G1uNmhnAe0EwLmtq8CBLRQSzWdTzmiSExT3U9lmP7s69gxVD3zV7BOdNASgRm/H
	5Lcibs4G1CX37UD5oS6acTh4RI8CZxHIFuD8Mn8vJGFKSrpOzH+OI2bFGR1S99JLg2qyOP1/7tq
	Lvecz12MtYebPnyZZaAjVVca2E3mTmCUqyquDuTq42G1MjLADQnmDDOdB+Yx65ww3kTOmh
X-Received: by 2002:a05:6820:2219:b0:6b7:8415:d77c with SMTP id 006d021491bc7-6b78415d829mr11361600eaf.39.1788782638744;
        Mon, 07 Sep 2026 05:03:58 -0700 (PDT)
Received: from Roxy.sysu.edu.cn ([2602:feda:30:ae86:295:dff:fe84:68f4])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-33808be8fb2sm4994245eec.14.2026.09.07.05.03.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Sep 2026 05:03:57 -0700 (PDT)
From: Zhiling Zou <zhilinz@nebusec.ai>
To: netfilter-devel@vger.kernel.org
Cc: pablo@netfilter.org,
	fw@strlen.de,
	phil@nwl.cc,
	davem@davemloft.net,
	edumazet@google.com,
	pabeni@redhat.com,
	horms@kernel.org,
	luciano.coelho@nokia.com,
	kaber@trash.net,
	vega@nebusec.ai,
	zhilinz@nebusec.ai
Subject: [PATCH nf 1/1] netfilter: xt_IDLETIMER: restrict to init_net
Date: Mon,  7 Sep 2026 20:03:40 +0800
Message-ID: <b5fe02dadeae419360ff9b991810f4655cdbd807.1788781051.git.zhilinz@nebusec.ai>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1788781051.git.zhilinz@nebusec.ai>
References: <cover.1788781051.git.zhilinz@nebusec.ai>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

IDLETIMER keeps its timer registry, reference counts, and sysfs files in
module-global state, while Xtables invokes checkentry and destroy for
rules in individual network namespaces. A matching label from another
namespace can therefore reuse and control an existing timer.

The sysfs interface is global and cannot represent per-namespace labels
with the current target design. Reject IDLETIMER rules outside init_net
so that global state stays in the namespace it was built for.

Fixes: 0902b469bd25 ("netfilter: xtables: idletimer target implementation")
Cc: stable@vger.kernel.org
Reported-by: Vega <vega@nebusec.ai>
Signed-off-by: Zhiling Zou <zhilinz@nebusec.ai>
---
 net/netfilter/xt_IDLETIMER.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/net/netfilter/xt_IDLETIMER.c b/net/netfilter/xt_IDLETIMER.c
index fe7d8d19629b4..155d6cc61dfde 100644
--- a/net/netfilter/xt_IDLETIMER.c
+++ b/net/netfilter/xt_IDLETIMER.c
@@ -28,6 +28,7 @@
 #include <linux/kobject.h>
 #include <linux/workqueue.h>
 #include <linux/sysfs.h>
+#include <net/net_namespace.h>
 
 struct idletimer_tg {
 	struct list_head entry;
@@ -308,6 +309,9 @@ static int idletimer_tg_checkentry(const struct xt_tgchk_param *par)
 	struct idletimer_tg_info *info = par->targinfo;
 	int ret;
 
+	if (!net_eq(par->net, &init_net))
+		return -EOPNOTSUPP;
+
 	ret = idletimer_tg_helper(info);
 	if(ret < 0)
 		return -EINVAL;
@@ -341,6 +345,9 @@ static int idletimer_tg_checkentry_v1(const struct xt_tgchk_param *par)
 	struct idletimer_tg_info_v1 *info = par->targinfo;
 	int ret;
 
+	if (!net_eq(par->net, &init_net))
+		return -EOPNOTSUPP;
+
 	if (info->send_nl_msg)
 		return -EOPNOTSUPP;
 
-- 
2.43.0

