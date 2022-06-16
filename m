Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29203C43334
	for <netfilter-devel@archiver.kernel.org>; Thu, 16 Jun 2022 22:48:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378037AbiFPWse (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 16 Jun 2022 18:48:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378308AbiFPWsd (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 16 Jun 2022 18:48:33 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B946262126
        for <netfilter-devel@vger.kernel.org>; Thu, 16 Jun 2022 15:48:29 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id x138so2666041pfc.12
        for <netfilter-devel@vger.kernel.org>; Thu, 16 Jun 2022 15:48:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=DiAI8dpzUBvNwkrpWyAmurNvSNGqp25iOtpvZnIpaFE=;
        b=Xy2IzQNT/gZvmbCWWWwPfUBL9fTEuMizyQix3no8WQRCH4wEZCy2o7u76N5DjoxPrQ
         R4pmfQL+G6//BByHKcz1KaNmB4MHYhDbXVbkU/qYGdF/bjTuUu9L9PIR/52JICQgo+eU
         MZrczV3ENtxwa+AzTqvluI7MJZjhc8pw15b+Q=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=DiAI8dpzUBvNwkrpWyAmurNvSNGqp25iOtpvZnIpaFE=;
        b=TESorymu4bF3ge+Hg1pGQc9h7MbgaFmmzwgFy2HWeCanLlZ0iXzrIhbOtwC7GmrcAH
         9xY66SMdKZOLLv1sBw9P5KwLPwGv2ZTgbcE3g/bekgLD65BwTm8+RIzxB1rv+gSkdCKO
         jAx45mKup+BiLaWmS8U18gNpOWWeA7chVBKXTsmEAohU6VTvNB2s5neTMwkRcUNL3/Az
         jF2RT6wTbY+TKKNzqD5D330SKDfKwfUTFSbkYWhi0yIRO8UTof63xi4ue7pDToWRFx91
         WA41HZRRk2iz4kKTPIgZkrF/NwzXzlCKAGP/touMsrHlwnTi0XPgegWd8k3kzj7fV5vX
         Z/wQ==
X-Gm-Message-State: AJIora+XjAFzfvqytrigjwYSjSykCvmuqelFFJtp9nrWxbBbEazfy2Uf
        pUKqoVY3hHkcYr20RQkAdGB8Zg9kYoACnJl7
X-Google-Smtp-Source: AGRyM1tbgYioWsoJmf2N+JHpWQGmRF+zEBJ/Qc28B0tagaQWuFDOcEKoMkUfxHAnoXx7GgX+VfsfGQ==
X-Received: by 2002:a05:6a00:2291:b0:51b:e4c5:627 with SMTP id f17-20020a056a00229100b0051be4c50627mr6954340pfe.20.1655419709105;
        Thu, 16 Jun 2022 15:48:29 -0700 (PDT)
Received: from lbrmn-mmayer.ric.broadcom.net ([192.19.161.250])
        by smtp.gmail.com with ESMTPSA id iz20-20020a170902ef9400b001676daaf055sm2130639plb.219.2022.06.16.15.48.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jun 2022 15:48:28 -0700 (PDT)
Received: by lbrmn-mmayer.ric.broadcom.net (Postfix, from userid 1000)
        id EE93546A377B; Thu, 16 Jun 2022 15:48:26 -0700 (PDT)
From:   Markus Mayer <mmayer@broadcom.com>
To:     Netfilter Mailing List <netfilter-devel@vger.kernel.org>
Cc:     Markus Mayer <mmayer@broadcom.com>
Subject: [PATCH] netfilter: add nf_log.h
Date:   Thu, 16 Jun 2022 15:48:18 -0700
Message-Id: <20220616224818.2720999-1-mmayer@broadcom.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Since libxt_NFLOG is now using the UAPI version of nf_log.h, it should
be bundled alongside the other netfilter kernel headers.

This copy of nf_log.h was taken from Linux 5.18.

Signed-off-by: Markus Mayer <mmayer@broadcom.com>
---

Not bundling the header with iptables leads to one of two scenarios:

* building iptables >=1.8.8 fails due to the missing header

* building iptables >=1.8.8 succeeds, but silently uses the header copy it
  finds under /usr/include/linux/netfilter, which may not match the version
  of the other netfilter headers, resulting in a potential "Franken-build"
  that would be difficult to detect (unlikely for nf_log.h, since it seems
  pretty stable, but not impossible)

 include/linux/netfilter/nf_log.h | 15 +++++++++++++++
 1 file changed, 15 insertions(+)
 create mode 100644 include/linux/netfilter/nf_log.h

diff --git a/include/linux/netfilter/nf_log.h b/include/linux/netfilter/nf_log.h
new file mode 100644
index 000000000000..2ae00932d3d2
--- /dev/null
+++ b/include/linux/netfilter/nf_log.h
@@ -0,0 +1,15 @@
+/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
+#ifndef _NETFILTER_NF_LOG_H
+#define _NETFILTER_NF_LOG_H
+
+#define NF_LOG_TCPSEQ		0x01	/* Log TCP sequence numbers */
+#define NF_LOG_TCPOPT		0x02	/* Log TCP options */
+#define NF_LOG_IPOPT		0x04	/* Log IP options */
+#define NF_LOG_UID		0x08	/* Log UID owning local socket */
+#define NF_LOG_NFLOG		0x10	/* Unsupported, don't reuse */
+#define NF_LOG_MACDECODE	0x20	/* Decode MAC header */
+#define NF_LOG_MASK		0x2f
+
+#define NF_LOG_PREFIXLEN	128
+
+#endif /* _NETFILTER_NF_LOG_H */
-- 
2.25.1

