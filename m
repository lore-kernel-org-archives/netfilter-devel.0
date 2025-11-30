Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D283E2836F
	for <netfilter-devel@vger.kernel.org>; Sun, 30 Nov 2025 17:25:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764523527; cv=none; b=MOrO1RzoEsQr7HS8wV7tZLDul/6b9DZ9JYiA4lnV3XE1oibMnDhKN5EaY4D+iFMgkY5ekLoU4F+43xLBaTc0wHoICu8/4CN7gIl+txYijHyup8D+kmjK+L7eKzaQgEP8BVqh/U9szcsQTgzcJH+AZPnZxl7hzSCiXfDYysA621I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764523527; c=relaxed/simple;
	bh=yGqfxjf40dVFBHjf9P3ah8dcX2o57hhsYtugmHdG3XI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Kp5Bn1AbuV/PD3uPeKIzFxYUBNF6gqpk0XUBnQxgwU7oGKEL5PRu2Qb0A3gYGxgN/jr+1e0ERBgvTuocm4V6SoGGCSJ11/cJCzpIIk7pMuq9vPH/33EO8ED17bXjL9LWXrOT2P+QwjGekSiBKm615/EvUUzCsAAh4jLOGXZOM3E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Bgs5hMWV; arc=none smtp.client-ip=209.85.208.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Bgs5hMWV"
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-640c6577120so6092621a12.1
        for <netfilter-devel@vger.kernel.org>; Sun, 30 Nov 2025 09:25:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764523524; x=1765128324; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=TmP+iBDrXAFEAg/gg0z9T+sbSzNZC5V0CnRcFDXOjao=;
        b=Bgs5hMWVAwR01pxYsN5gf6PVY3x5aazrbuYKDUUjaR55rlOd5JTh4Zt5SucnMNnINY
         vB/vcXl9A/5VN2UrVKkhuiGGjc3rjlovrti6Ox8x4ch35SU9Ugr9Z70UGXwEuGMI/TIV
         j9GdDTptu3Gjo5kdAoXtu/ZMlNkS7jAb/usNgt7SPproqITj8SajqhV4LcRCx7yyR/X+
         aDwD0//jom1JotHRtCZeM4CKCpkCu86rn2z/sqluVfweXsUYIsVW2KJJVPhD1jktFR4Q
         Iuy31dtUYctwg6rMV8Hec6YB2zXfz7s9eBqYEjwHYFm8wZn/D7ETDgKCEAZM40Gs6l/m
         c5DQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764523524; x=1765128324;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TmP+iBDrXAFEAg/gg0z9T+sbSzNZC5V0CnRcFDXOjao=;
        b=o15kGgmiHzGwNx+u6l+j21Ul2h89/MeidoO/RglOsZ+bJAe97QFcexy4jYgUWR7maa
         e9uSGVc+MI8qAaXxLyLc45SgsCIspwsgRfLKpikZfYb3etaC/aljAKzqkIWFSOofmgAc
         0l5aQkcFwYGIVu7scMZ6dXAio4udvi0bJtL22W8J1zoC8d6sfwWFalxQu/7j14sJWawz
         fd5dX5YaUxJuHNe7bdRjKK1v5UH9jHMlwMrUrm+lwhz3RCzQP34oTeogc8puU4ciG+dD
         b5MS1nPihwZbEQXb42aT6ys9j7fxJ0D2pV4Vbrz8gRWQReHUKal5SuUa8/7qjBZXNohw
         FOng==
X-Gm-Message-State: AOJu0Yxcdhu0k1EOY3/jRjqQv4US09hMZO9j9lxT8DNNGmAQcgIbhbpF
	YSWG71QDismeFdgbWHU3tY8jQHBL04I08rglkn7EjmCIS4TL/ldjM5BaYFkCRg==
X-Gm-Gg: ASbGnct3AiWiRhSx7xfuuggkrqFQVg/SraCtr9xRp3HxZtMPPdjYEZRc2lBmiuSsbU3
	hOUK4Gza+jbRaPRUtOOkNw4s+c9kTlEhrTvdLwCCR0e6KNPi9008HrTfGoeHqRY3AngdAKS9u2j
	YRVU3rplIkrbiboVehlwhysVrKpNGMX8HUmy4KySPOJkDcFsCD2ecCVBIB9CD6Mruxfqa8YjLzj
	O8mhJSikBquoj4wvr0+ViX0TKj69dngsY2exIBQYiauVz8sKt6is3yrMi0N/U6h94qdBh9+A9if
	108Xw39Geo89akcTgoOwQl+nAX0yYhSB2vz2foUQEtgQrA0yg4g5bbjYqswcBrSt7BNsvxbiudR
	p206y3Yvstv+qSH6Y6OzCRzvaPl1N+BhU+Pk1+e+HXeDR13SqlG0blU5XjT7+lxRf8nGSnxd9x1
	sJnQZsm0sg6LUqjZo++94YPux+
X-Google-Smtp-Source: AGHT+IGOvIw+nIp3Nm+brV2wycXVKo9yABc+ineJTYCS6m2WyOOpZo2bWREOzl42x/OlrWbPiA+JVw==
X-Received: by 2002:a17:907:948e:b0:b73:70c9:1780 with SMTP id a640c23a62f3a-b767183c122mr4274437366b.41.1764523523562;
        Sun, 30 Nov 2025 09:25:23 -0800 (PST)
Received: from ice-home.lan ([92.253.236.24])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b76f59e93acsm962440666b.50.2025.11.30.09.25.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 30 Nov 2025 09:25:23 -0800 (PST)
From: Serhii Ivanov <icegood1980@gmail.com>
To: netfilter-devel@vger.kernel.org
Cc: Serhii Ivanov <icegood1980@gmail.com>
Subject: [PATCH] Some common changes in ulogs: 1) Added debug log to indicate when stack is created. Helps to debug settings in configs for users
Date: Sun, 30 Nov 2025 19:25:20 +0200
Message-ID: <20251130172520.2589387-1-icegood1980@gmail.com>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

2) Properly include defines via
+#include <ulogd/ulogd.h>  instead of explicit -#include "../config.h"
To be honest explicit way is right way to go, but by 'properly' i mean
how other plugins do i.e. 'by voting'
---
 output/ulogd_output_XML.c | 3 +--
 src/ulogd.c               | 1 +
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/output/ulogd_output_XML.c b/output/ulogd_output_XML.c
index 0e1ae7b..c661174 100644
--- a/output/ulogd_output_XML.c
+++ b/output/ulogd_output_XML.c
@@ -20,7 +20,7 @@
 
 #include <sys/types.h>
 #include <inttypes.h>
-#include "../config.h"
+#include <ulogd/ulogd.h>
 #ifdef BUILD_NFLOG
 #include <libnetfilter_log/libnetfilter_log.h>
 #endif
@@ -30,7 +30,6 @@
 #ifdef BUILD_NFACCT
 #include <libnetfilter_acct/libnetfilter_acct.h>
 #endif
-#include <ulogd/ulogd.h>
 #include <sys/param.h>
 #include <time.h>
 #include <errno.h>
diff --git a/src/ulogd.c b/src/ulogd.c
index 917ae3a..9004286 100644
--- a/src/ulogd.c
+++ b/src/ulogd.c
@@ -1111,6 +1111,7 @@ static int create_stack(const char *option)
 
 	/* add head of pluginstance stack to list of stacks */
 	llist_add(&stack->stack_list, &ulogd_pi_stacks);
+	ulogd_log(ULOGD_DEBUG, "pluginstance stack created: '%s'\n", option);
 	free(buf);
 	return 0;
 
-- 
2.51.0

