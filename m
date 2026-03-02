Received: from mail-lj1-f181.google.com (mail-lj1-f181.google.com [209.85.208.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F551175A89
	for <netfilter-devel@vger.kernel.org>; Mon,  2 Mar 2026 16:05:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772467548; cv=none; b=Ad7XVTIxEWM7OPm5Xbe1Jtk0jtEqWLsQPbzdQpsMht8goU9RL3zanWEqYeb3itWWS5jcfjDnn2yVCf0dqO+tFliHQYDerrf/XAP/0Ms/eL7NuOWACMg/vLhJCdCsGxUaBz5FOU3jVMUAyuhKlaywbbxSepOVz8wdvZaW0rm+Nco=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772467548; c=relaxed/simple;
	bh=KXBlLdsSABz7BwvMOI5DXgSj7zeiYnuFwRrrtdYPGGM=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=qSgAo/ADwDGfEQ812D1acb3XyVdyYCzjZZGRjgUYJUUAFYyfOdTOqXhSFts3V8Y1sf9qRvenzRH23k+Nwqp7ZLMkkeKiCjlsRcp+EMuSU6foEHwu405JLq1WC98TAQbp81rMSLTeY6hCIOxDRzRFAY35XULF7nPyMb8AdPEwBqo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nQ6pL0j5; arc=none smtp.client-ip=209.85.208.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nQ6pL0j5"
Received: by mail-lj1-f181.google.com with SMTP id 38308e7fff4ca-389f933034cso60220281fa.2
        for <netfilter-devel@vger.kernel.org>; Mon, 02 Mar 2026 08:05:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772467545; x=1773072345; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=KFW5wh5vekmY9Ki6mE60YsBw5N4zJvJ0KF42qLg3aJA=;
        b=nQ6pL0j5bCQAPvhq+4HdqNXmZolRfPoH/6+0O3lhssD3nlQgYVzWLzFtfwMO1KF9xS
         /0TjKBvASTsb6Dhbg2st59RbRBeFiqLaBn7RRKhBlleXTtRgHIaINnM5o3BXc8n9glVW
         oK8xCnqd8npL83KqptnMHmUjl2fd5KDbdl0qCDqAlVGMY6CSHy4ckgz+da8scsshNqEW
         9uzKkW4+ZC2fIMOsvBy4WfnTendX9Fh71whoj5I7AOdygegR614/n+l19Y0YhRb6pVbx
         z1uHyz3daEg0J3jJCbZNJyU8BCt4q6GhHHWrVKADZe7SqI+pfp/CfbgHi44i73mhC9aY
         Lhcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772467545; x=1773072345;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KFW5wh5vekmY9Ki6mE60YsBw5N4zJvJ0KF42qLg3aJA=;
        b=P7JKwqG/El8HlVILVJXgAUioNC8ausT5gGBzfSzZFK/gOzw3ewmy+7ND3DCjCB2KBy
         mpJzkjwt5StFPJMUQP+Yc1LqtKa+bxQsrx28XaaydWBuX6ToBMNS8m5WVFVfUcGdRea7
         78u09CXzwQEEg1eAXi8mPagHC+ESDQxvg9h92yfYn3Zl8Zapshb05TFzFNqEvOSZhVg6
         /hbDLMG/TROrU9T/p+N82rqGKx9+D0+HaZKqWKe54mILm131QiiakInD/If7CsFNSNHT
         3vz8zEYj9OvtdAq3Kq6dmtSgcLL+no1WO4MI9CrnuG6jyoKuYiLgghYHa0mIAaKsuuvC
         +tVA==
X-Gm-Message-State: AOJu0YxHFcXB6drdzToNwZBpUyt5TrFmR3FceytWb+Yew7hW3PbpCf9P
	4W4FinB1hngOzkrzdIfUefPrxwza8U7od2VKm1ya8KSBJvq83zdauaiqMtNfnA19
X-Gm-Gg: ATEYQzw2rRa9BbsPAU7KYHDqbQgzUisQz7Sul8Sx/6RObQsXRdbLEa1/onOVYpIjvUZ
	9Gxx565xXzWIYoADCwu4ri8sUp0gh4ynyHZfusX9IzgHOZ8ZWjF05GQDJ1vf1povkS103XCFkjZ
	CUbjERTD5LvmuO372U7msETm2DAXhEeFq0JGPA+NPnQv8+lJhE+snQ8MuMnM0ZYQRU9V8KNl5ZU
	lV3vzVO4/LsoSnfbFcrdi7i6tGVSXpHX81KhxgdvSGMDLRCndhiD/IIAhRo7Vt9JhL3oBO6KkPC
	rU/yWK0hokPtO/IrXm6QrRtfFBGVu3ZWxZKD19yZA4FuyjMkVxXqBIHrFqwWcWCeYE9jGVjm6AY
	4a/R7Gf2XmhxQwHq7CWu410evpgMvEAlR251FVlZra/Fuj7ODpw/9qqGkc2PvnBw/Y4M/g55arX
	B9FRLiZ2pWL1Fb2lFlPD1tr2L0DuOYTWu/MgyTfr6k+7XfAu2MYhXu6erDPuebF2hHk7Wy2mpG6
	3ZLP1KtR5lVM95oJo5A72sAvbkC6oJknFw=
X-Received: by 2002:a05:651c:388:b0:383:1232:379a with SMTP id 38308e7fff4ca-389ff118f5fmr63504081fa.2.1772467544790;
        Mon, 02 Mar 2026 08:05:44 -0800 (PST)
Received: from lnb0tqzjk.rasu.local (109-252-125-213.nat.spd-mgts.ru. [109.252.125.213])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5a122e05d97sm38582e87.43.2026.03.02.08.05.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Mar 2026 08:05:44 -0800 (PST)
From: Anton Moryakov <ant.v.moryakov@gmail.com>
To: netfilter-devel@vger.kernel.org
Cc: pablo@netfilter.org,
	Anton Moryakov <ant.v.moryakov@gmail.com>
Subject: [PATCH] rule: fix NULL pointer dereference in do_list_flowtable
Date: Mon,  2 Mar 2026 19:05:39 +0300
Message-Id: <20260302160539.248755-1-ant.v.moryakov@gmail.com>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Static analysis found a potential NULL pointer dereference in
do_command_list() when handling CMD_OBJ_FLOWTABLE.

If cmd->handle.table.name is not specified, the table pointer remains
NULL after the cache lookup block. However, do_list_flowtable() expects
a valid table pointer and dereferences it via ft_cache_find().

This is inconsistent with other object types (CMD_OBJ_SET, CMD_OBJ_CHAIN,
etc.) which require a valid table for single-object listing.

Add a NULL check before calling do_list_flowtable() to prevent the
potential crash and return ENOENT error, consistent with existing
error handling patterns.

Signed-off-by: Anton Moryakov <ant.v.moryakov@gmail.com>
---
 src/rule.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/src/rule.c b/src/rule.c
index 8f8b77f1..0c3372ba 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -2655,6 +2655,10 @@ static int do_command_list(struct netlink_ctx *ctx, struct cmd *cmd)
 	case CMD_OBJ_TUNNELS:
 		return do_list_obj(ctx, cmd, NFT_OBJECT_TUNNEL);
 	case CMD_OBJ_FLOWTABLE:
+	    if (!table) {
+        	errno = ENOENT;
+        	return -1;
+    	}
 		return do_list_flowtable(ctx, cmd, table);
 	case CMD_OBJ_FLOWTABLES:
 		return do_list_flowtables(ctx, cmd);
-- 
2.39.2

