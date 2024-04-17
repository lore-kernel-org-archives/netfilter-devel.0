Received: from mail-lj1-f176.google.com (mail-lj1-f176.google.com [209.85.208.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7B4B130A75
	for <netfilter-devel@vger.kernel.org>; Wed, 17 Apr 2024 13:53:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713362040; cv=none; b=ssEqe+v05xA2NEH0XPYc77lsPaglATJnvBHQwmwNVnsuGjR0zaVSJLmNBLOm71JO0amM2bDU5tk7KaZUylPWzbTYBcBGnqgiCMEQHxe/Sm+vkJMAnkpQgjSrCYEKha4RPpwFcbhz1qHQ1l2cu3iNQtX2b2nV45Rafv63FWMIgsc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713362040; c=relaxed/simple;
	bh=CtpawhsRq2hPCdHadszMQMvM+HZWRxTTRINBX8kHQrU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Fks78w28zAbswy2SETG42py5qG4aGEcMmOuqltnREnS7zS8huDibpw3OoMkh5O/phg09r8/WRAAp1yxW8xEnMt2FEmur2ZpPQ5ibD3F74bBYQfoJiIcj3Cw8mxsdIgS5Fcfdeyw4mYY4AIDNludci4hNVGLBHfAcVpeATtnLI9o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fcI09pPk; arc=none smtp.client-ip=209.85.208.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fcI09pPk"
Received: by mail-lj1-f176.google.com with SMTP id 38308e7fff4ca-2d858501412so72381841fa.0
        for <netfilter-devel@vger.kernel.org>; Wed, 17 Apr 2024 06:53:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1713362036; x=1713966836; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=bsSBkjB7N2/g+Q8OiAUNl+NWbK+9TgfWGqjdPXG107s=;
        b=fcI09pPkobx0lkho8WD2KWH8tGY/1kPXfu795guJoQq3XLeltvOQT89m3ElX3wD28q
         RYASQZW1Crqt7bcZ1C1NNuWa/ePm6DHpHWvh9Nr86Wp257WbXqa34JdpPfG2+kKmp9Dp
         sqbLO0DLFS1uRf0iu2qXnb2bmxN5h3PcVv2WUr513Ul5dqu+DyIlg1WfnC2w7uHms6OO
         w+YsOAwpyxL23NrNBerQfShfpZ5GSqtRVzXt6nIty0YJ5q4HCbSM4r4c294MKUYhZu13
         GRqp+4Em/VcwbDouef+gm7EWMxIUBV4ajJsdylEf/IC3mf44v1Hqzf+N9TvG0NTWP2HP
         KBYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713362036; x=1713966836;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=bsSBkjB7N2/g+Q8OiAUNl+NWbK+9TgfWGqjdPXG107s=;
        b=T3ecIoSIYIhFpn3DpgPYXD50Ee+Yl1CfhNQCuQ/fNah23so8BBAJCJRYWmKUUVNxmy
         k+SGu3QALuGHKkoDahzLf4o0X0hs72HKLRsu3zn062h8Cgw+g1/y3A9fQp3KP8SFEnfQ
         ukxnpBtsS5akOoPKBczDci5/vOSVp/1YOt39PfGzFO0up9GfHLfbJpQDCsv76JD3FTpn
         /L68jeFA/V1vnqKCGliNH9/k2dtelGOYKK7TavDoAeIm+iLjhIqygRnTel8nXn779GZy
         o1+p3aaTUG8pSwcVAvJQcQFtF3k5qkmOckNZeN2nu5cOcUXOZZYBhNIYKDawxrkHeF2i
         ZisA==
X-Gm-Message-State: AOJu0YzhO55OSgRYQrfFDMfCMMsLdaQ5F3c1MBGyzRdTU97kIIs/EGDS
	3gVia9cYp14QvgcMqDOCFSbw64FUPcsFvGaV3OyZL9Bki/hzOJM6ZfkmaPBh1pI=
X-Google-Smtp-Source: AGHT+IFXtcPOK/yRmfW5QzCNvAIAIk+3rxEDYdhJaNElz0almfcINipAtQ/jvfL/UVXsWj1eKvNGew==
X-Received: by 2002:a2e:98c6:0:b0:2da:8fd4:fb1e with SMTP id s6-20020a2e98c6000000b002da8fd4fb1emr4961389ljj.21.1713362036234;
        Wed, 17 Apr 2024 06:53:56 -0700 (PDT)
Received: from localhost.localdomain ([185.246.127.40])
        by smtp.gmail.com with ESMTPSA id a23-20020a05651c031700b002d46df91965sm1921394ljp.80.2024.04.17.06.53.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Apr 2024 06:53:55 -0700 (PDT)
From: Alexander Maltsev <keltar.gw@gmail.com>
To: netfilter-devel@vger.kernel.org
Cc: Jozsef Kadlecsik <kadlec@netfilter.org>,
	Alexander Maltsev <keltar.gw@gmail.com>
Subject: [PATCH] netfilter: ipset: Add list flush to cancel_gc
Date: Wed, 17 Apr 2024 18:51:41 +0500
Message-ID: <20240417135141.18288-1-keltar.gw@gmail.com>
X-Mailer: git-send-email 2.44.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Flushing list in cancel_gc drops references to other lists right away,
without waiting for RCU to destroy list. Fixes race when referenced
ipsets can't be destroyed while referring list is scheduled for destroy.

Signed-off-by: Alexander Maltsev <keltar.gw@gmail.com>
---
 kernel/net/netfilter/ipset/ip_set_list_set.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/kernel/net/netfilter/ipset/ip_set_list_set.c b/kernel/net/netfilter/ipset/ip_set_list_set.c
index cc2e5b9..0d15f4f 100644
--- a/kernel/net/netfilter/ipset/ip_set_list_set.c
+++ b/kernel/net/netfilter/ipset/ip_set_list_set.c
@@ -552,6 +552,9 @@ list_set_cancel_gc(struct ip_set *set)
 
 	if (SET_WITH_TIMEOUT(set))
 		timer_shutdown_sync(&map->gc);
+
+	/* Flush list to drop references to other ipsets */
+	list_set_flush(set);
 }
 
 static const struct ip_set_type_variant set_variant = {
-- 
2.44.0

