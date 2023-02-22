Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92E9BC61DA4
	for <netfilter-devel@archiver.kernel.org>; Wed, 22 Feb 2023 07:23:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229581AbjBVHXz (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 22 Feb 2023 02:23:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229579AbjBVHXz (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 22 Feb 2023 02:23:55 -0500
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27ECB20064
        for <netfilter-devel@vger.kernel.org>; Tue, 21 Feb 2023 23:23:54 -0800 (PST)
Received: by mail-wm1-x333.google.com with SMTP id j3so3008588wms.2
        for <netfilter-devel@vger.kernel.org>; Tue, 21 Feb 2023 23:23:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:sender:from:to:cc:subject:date:message-id:reply-to;
        bh=itHTpliXMHJPlZUjJrk0t6jeewBpscUe/eGfpDh/e6U=;
        b=bSK+Lho94ph4iYxhAOWQQBQvkzGpWza2PUJslIImWQhDVfrqHmYKpXCqwrdGbnIkyJ
         wAxwcB7lm/ftKZX9o5mAvKduhqWIQmZrUtbpBdziWr/SAU3ExDQPhEyP7wL3wZ4z10rj
         JHZZtNt+C6W3QIiccr2nTqHlmrGSEefg0e0/MejthIFH2ZKa9kTP6OSGXjpSBtP0FRN7
         jS9PwnL5+pIiPjj32Xuu09AtZ0KrNCSjBkY3dX/L5sBKfnsFfDDl4TE8ga6tXUFiXbD9
         xraCZhuyPiuEAhU9V4uu0uPgcwpbjQK0gVLkGYsYn494H8KhBXjuK5kHQWDNTBPQt+Ym
         TUBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:sender:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=itHTpliXMHJPlZUjJrk0t6jeewBpscUe/eGfpDh/e6U=;
        b=LhE8fxmf85dvKLkVp0sZaX83na/xSKu9ad0mhgsC2ORFOCk33lCmOTGbnHwiofGMnD
         HBaX/ySA27rkHu58syKMRz06HVIWbKDdg5/WkyThpAbqQNOfdMmrwWRCwpOKc9hHXCnL
         Gt75o4I8SjkmPJyMBerVSSdqr0hUUwt6nZmSSbONSZxB/glZvFX/piwtZvTip+wG5BPF
         up6NCaTIvGr6+nJJxd4vZ4tu4XfyNjO6UirN0x5YlIas3E9M8Z1z4/hPRhedwDa66GZx
         VSw7Kekw/mNqA2l4fBwjACqfyKrlhb7cH+meay3/I7uFdamqknrj6KmA/9SdEOH3zu8l
         Qc5g==
X-Gm-Message-State: AO0yUKVleOfzY6Yf2aTcHFhdMU937NpivLIXjbC89NjqK78B/lnFTbQ7
        +PvLg9IUTOn0xFDUBCc6jLVs9ALTsjeRrzjh
X-Google-Smtp-Source: AK7set/FZo6auvd5GI8efXIrUJOd3vglaom0MHQBHIMg7inXqPH3NGJwmyV4/iCnXd+NahHqYFp90w==
X-Received: by 2002:a05:600c:3420:b0:3e2:c67:1c7f with SMTP id y32-20020a05600c342000b003e20c671c7fmr5673397wmp.10.1677050632060;
        Tue, 21 Feb 2023 23:23:52 -0800 (PST)
Received: from thomas-OptiPlex-7090.nmg.localnet (d528f5fc4.static.telenet.be. [82.143.95.196])
        by smtp.gmail.com with ESMTPSA id 15-20020a05600c020f00b003dfe5190376sm5905220wmi.35.2023.02.21.23.23.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Feb 2023 23:23:51 -0800 (PST)
Sender: Thomas Devoogdt <thomas.devoogdt@gmail.com>
From:   Thomas Devoogdt <thomas@devoogdt.com>
X-Google-Original-From: Thomas Devoogdt <thomas.devoogdt@barco.com>
To:     netfilter-devel@vger.kernel.org
Cc:     Thomas Devoogdt <thomas.devoogdt@barco.com>
Subject: [PATCH] [iptables] extensions: libxt_LOG.c: fix linux/netfilter/xt_LOG.h include on Linux < 3.4
Date:   Wed, 22 Feb 2023 08:23:49 +0100
Message-Id: <20230222072349.509917-1-thomas.devoogdt@barco.com>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

libxt_LOG.c:6:10: fatal error: linux/netfilter/xt_LOG.h: No such file or directory
. #include <linux/netfilter/xt_LOG.h>
          ^~~~~~~~~~~~~~~~~~~~~~~~~~

Linux < 3.4 defines are in include/linux/netfilter_ipv{4,6}/ipt_LOG.h,
but the naming is slightly different, so just define it here as the values are the same.

https://github.com/torvalds/linux/commit/6939c33a757bd006c5e0b8b5fd429fc587a4d0f4

Signed-off-by: Thomas Devoogdt <thomas.devoogdt@barco.com>
---
 extensions/libxt_LOG.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/extensions/libxt_LOG.c b/extensions/libxt_LOG.c
index b6fe0b2e..beb1d40a 100644
--- a/extensions/libxt_LOG.c
+++ b/extensions/libxt_LOG.c
@@ -3,7 +3,27 @@
 #define SYSLOG_NAMES
 #include <syslog.h>
 #include <xtables.h>
+#include <linux/version.h>
+
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(3, 4, 0)
 #include <linux/netfilter/xt_LOG.h>
+#else
+/* Linux < 3.4 defines are in include/linux/netfilter_ipv{4,6}/ipt_LOG.h,
+   but the naming is slightly different, so just define it here as the values are the same. */
+#define XT_LOG_TCPSEQ           0x01    /* Log TCP sequence numbers */
+#define XT_LOG_TCPOPT           0x02    /* Log TCP options */
+#define XT_LOG_IPOPT            0x04    /* Log IP options */
+#define XT_LOG_UID              0x08    /* Log UID owning local socket */
+#define XT_LOG_NFLOG            0x10    /* Unsupported, don't reuse */
+#define XT_LOG_MACDECODE        0x20    /* Decode MAC header */
+#define XT_LOG_MASK             0x2f
+
+struct xt_log_info {
+        unsigned char level;
+        unsigned char logflags;
+        char prefix[30];
+};
+#endif
 
 #define LOG_DEFAULT_LEVEL LOG_WARNING
 
-- 
2.39.2

