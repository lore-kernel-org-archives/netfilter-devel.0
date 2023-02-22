Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6FC5DC61DA4
	for <netfilter-devel@archiver.kernel.org>; Wed, 22 Feb 2023 10:51:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231451AbjBVKvy (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 22 Feb 2023 05:51:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229834AbjBVKvw (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 22 Feb 2023 05:51:52 -0500
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 419E338654
        for <netfilter-devel@vger.kernel.org>; Wed, 22 Feb 2023 02:51:51 -0800 (PST)
Received: by mail-wr1-x42f.google.com with SMTP id 6so6869625wrb.11
        for <netfilter-devel@vger.kernel.org>; Wed, 22 Feb 2023 02:51:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:reply-to:message-id:date
         :subject:cc:to:from:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/aFMtzLHSjwxug/UT3knUgkl1m9Xd7n5GNpJHWzyBRU=;
        b=O33vCs/v8g1N6Tch81zs+xqtBR/IdfRwZz4HRN7fPMKtRSYassqGqQMePzXhfcCF0r
         kFw5QykVYyOSOpy/dZgnjLcSXJV5kqRvJ0Kj13WKwg7PtoXXW1aQctURVtzApvke1kua
         YfL+kjXvcaTh3VtStC5JwTrIWS2MQuAoHi/w0cFO0Kf9fZHtIit/lsZ8IbTWpmwq7dSy
         WCKjobpmz43CxpD/KH0sc4dn6ejwNzPgaW8nanBzE6TMxGm6tjDqFjpEw1BV4jYBeqG9
         ICQD07oar0mG0SJUnn9MxtlxSJPCIC/7bFqJXjHLvfZF2IWRUfV/+mTpzv9SYa47lM8T
         Rjlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:reply-to:message-id:date
         :subject:cc:to:from:sender:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=/aFMtzLHSjwxug/UT3knUgkl1m9Xd7n5GNpJHWzyBRU=;
        b=Ny38RYfUxswpczk4QV/LimL82b9ycMVIRNlv4+FwB65sv5DF2BSdR6IkSoqrhBdAvB
         FsKC3sufhKZC+9pVRj3bJj9wAmiDJtmC0xT92J/JN6iQ/nQTQuMzvb+p+AKLV8A6CoOk
         YiOA9ynVAAAFZDeQSbu6zKgVbiNTaPcOg+js/GlAzoDGb/lTa79ZlWbgFe7nyncVeqt8
         0o8XQB9y1n1ycx2zJerN6k//eaMutK86MDfGMPQAlAs9APuwj6ravWO24XI3BrYLbt63
         FN1am4ZHV8y9EU5dFnuhmOTxgq5WD4g0JamILx15jYeGq3nTJHgkFOU191KNoaNymxHV
         2Frg==
X-Gm-Message-State: AO0yUKU0Ee10ozSolcRBAt37m2Z54jgyugjAARMFpSAi7/mk99fgZW5z
        qoObk2hB9O637Vx8mCKOxJuMc10AzlvX133t
X-Google-Smtp-Source: AK7set/Jszzy0bROmM/gL3mzio/TsdYw6Os69bJ8AGYif3qR5RTRrxoqm/SopboM4fGRecLa3B4vjA==
X-Received: by 2002:adf:fcd0:0:b0:2c5:4a20:cad8 with SMTP id f16-20020adffcd0000000b002c54a20cad8mr7585573wrs.60.1677063109325;
        Wed, 22 Feb 2023 02:51:49 -0800 (PST)
Received: from thomas-OptiPlex-7090.nmg.localnet (d528f5fc4.static.telenet.be. [82.143.95.196])
        by smtp.gmail.com with ESMTPSA id e16-20020adfe390000000b002c54c8e70b1sm7237679wrm.9.2023.02.22.02.51.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Feb 2023 02:51:48 -0800 (PST)
Sender: Thomas Devoogdt <thomas.devoogdt@gmail.com>
From:   Thomas Devoogdt <thomas@devoogdt.com>
X-Google-Original-From: Thomas Devoogdt <thomas.devoogdt@barco.com>
To:     netfilter-devel@vger.kernel.org
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Thomas Devoogdt <thomas.devoogdt@barco.com>
Subject: [PATCH v2] [iptables] include: netfilter: add xt_LOG.h to fix an include error on Linux < 3.4
Date:   Wed, 22 Feb 2023 11:51:36 +0100
Message-Id: <20230222105136.2234231-1-thomas.devoogdt@barco.com>
X-Mailer: git-send-email 2.39.2
Reply-To: <20230222072349.509917-1-thomas.devoogdt@barco.com>
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

Took the source from Linux v6.2.

Signed-off-by: Thomas Devoogdt <thomas.devoogdt@barco.com>
---
v2: added the xt_LOG.h header rather than fixing /extensions/libxt_LOG.c
---
 include/linux/netfilter/xt_LOG.h | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)
 create mode 100644 include/linux/netfilter/xt_LOG.h

diff --git a/include/linux/netfilter/xt_LOG.h b/include/linux/netfilter/xt_LOG.h
new file mode 100644
index 00000000..167d4ddd
--- /dev/null
+++ b/include/linux/netfilter/xt_LOG.h
@@ -0,0 +1,20 @@
+/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
+#ifndef _XT_LOG_H
+#define _XT_LOG_H
+
+/* make sure not to change this without changing nf_log.h:NF_LOG_* (!) */
+#define XT_LOG_TCPSEQ		0x01	/* Log TCP sequence numbers */
+#define XT_LOG_TCPOPT		0x02	/* Log TCP options */
+#define XT_LOG_IPOPT		0x04	/* Log IP options */
+#define XT_LOG_UID		0x08	/* Log UID owning local socket */
+#define XT_LOG_NFLOG		0x10	/* Unsupported, don't reuse */
+#define XT_LOG_MACDECODE	0x20	/* Decode MAC header */
+#define XT_LOG_MASK		0x2f
+
+struct xt_log_info {
+	unsigned char level;
+	unsigned char logflags;
+	char prefix[30];
+};
+
+#endif /* _XT_LOG_H */
-- 
2.39.2

