Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D38ACC433EF
	for <netfilter-devel@archiver.kernel.org>; Wed, 29 Jun 2022 20:07:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229641AbiF2UHa (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 29 Jun 2022 16:07:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229601AbiF2UH3 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 29 Jun 2022 16:07:29 -0400
Received: from mail-qv1-xf30.google.com (mail-qv1-xf30.google.com [IPv6:2607:f8b0:4864:20::f30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2BB83ED34
        for <netfilter-devel@vger.kernel.org>; Wed, 29 Jun 2022 13:07:28 -0700 (PDT)
Received: by mail-qv1-xf30.google.com with SMTP id cu16so26558557qvb.7
        for <netfilter-devel@vger.kernel.org>; Wed, 29 Jun 2022 13:07:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=cPNHJjnlYDQYqVhDdo9waoojByAZZEshfwYFkL+Ojmc=;
        b=X9CNZ0DZux8NWdowa37x11V5+2ER91dmnHvJdSvrNHCask5JB8kkeD80JlN+I9X8cg
         5C32HmxTlFEyi9XOmIcbkgdSOIZ7CqCaKX3Z2KD2n3RMfBqI/4e/VuMrbTytRl6RLY4y
         GLfDCu00GpqR7kkNAZ5xYbaADyiwX5qNO3DeJ+dtTZyWSXYq0Ob8GD/n271UoHXgUsOF
         j22ZUO44htfCbN2iXmQbW+l3qLd36Ru/+aSnh8JBE3ryJxtlIR/3ECwoXivkNaQS64g7
         WbNfiIIIZvzwbDay1EofHOgqJhCLN+5NHJujVgwiJmTdwdtm6ZgIxjP/qwlKaRQeFF/T
         8voQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=cPNHJjnlYDQYqVhDdo9waoojByAZZEshfwYFkL+Ojmc=;
        b=fCxbZvvTDpxLmiwWg41QYO+TINdtDuLkO7U+oo2ZASCfETclEDI8wGW7jr2onI081X
         6rWJx0kbKHLSCzjO4dd9tn8oIoQsRJ/teo5F68eudkUGESTXYtKi+Y56B3e++5f28F/K
         Xq+ColLJcknefXCcxDsLeMxj+QDHsKZ6Gzu6OpBM2Yk66yR2V3dQ/5kcJGlzie9cinA9
         jc8jQ173M062J0swXi3K2aqAwqZ9n3xnT/ZPOGuZpPhWq7p4dnPcgYAkmvoDP7KrwZD0
         pIH5D5AhXZZhSBMi/X5yLnw8ekmuY8id+dsENqDNXvXwF380f3hsMWQEgExThwm/oA8d
         6kMg==
X-Gm-Message-State: AJIora/1UunwZq83bU9WJpau2PS9hSH9xqHSx0+Me8VVLGhGgniNR0vs
        KHIOESkPZVtp2miMAicDQEpaMZ18bcyxV/mW
X-Google-Smtp-Source: AGRyM1uTERg4FD8Tf348xhyvdebLuVWbFNzHTezG/07f5OMFYxuSW62MIosHFrr7Er6jGO8K4W2Itw==
X-Received: by 2002:ac8:5b8c:0:b0:305:1673:c1a6 with SMTP id a12-20020ac85b8c000000b003051673c1a6mr4283800qta.260.1656533247843;
        Wed, 29 Jun 2022 13:07:27 -0700 (PDT)
Received: from yuluo.com (cpe-68-175-122-13.nyc.res.rr.com. [68.175.122.13])
        by smtp.gmail.com with ESMTPSA id ey14-20020a05622a4c0e00b002fcb0d95f65sm11248750qtb.90.2022.06.29.13.07.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jun 2022 13:07:27 -0700 (PDT)
From:   Yuxuan Luo <luoyuxuan.carl@gmail.com>
X-Google-Original-From: Yuxuan Luo <yuluo@redhat.com>
To:     netfilter-devel@vger.kernel.org
Cc:     fw@strlen.de, marcelo.leitner@gmail.com, lucien.xin@gmail.com,
        Yuxuan Luo <yuluo@redhat.com>,
        Yuxuan Luo <luoyuxuan.carl@gmail.com>
Subject: [PATCH] xt_sctp: support a couple of new chunk types
Date:   Wed, 29 Jun 2022 16:05:45 -0400
Message-Id: <20220629200545.75362-1-yuluo@redhat.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

There are new chunks added in Linux SCTP not being traced by iptables.

This patch introduces the following chunks for tracing:
I_DATA, I_FORWARD_TSN (RFC8260), RE_CONFIG(RFC6525) and PAD(RFC4820)

Signed-off-by: Yuxuan Luo <luoyuxuan.carl@gmail.com>
---
 extensions/libxt_sctp.c   | 4 ++++
 extensions/libxt_sctp.man | 4 +++-
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/extensions/libxt_sctp.c b/extensions/libxt_sctp.c
index a4c5415f..3fb6cf1a 100644
--- a/extensions/libxt_sctp.c
+++ b/extensions/libxt_sctp.c
@@ -112,9 +112,13 @@ static const struct sctp_chunk_names sctp_chunk_names[]
     { .name = "ECN_ECNE",	.chunk_type = 12,  .valid_flags = "--------", .nftname = "ecne" },
     { .name = "ECN_CWR",	.chunk_type = 13,  .valid_flags = "--------", .nftname = "cwr" },
     { .name = "SHUTDOWN_COMPLETE", .chunk_type = 14,  .valid_flags = "-------T", .nftname = "shutdown-complete" },
+    { .name = "I_DATA",		.chunk_type = 64,   .valid_flags = "----IUBE", .nftname = "i-data"},
+    { .name = "RE_CONFIG",	.chunk_type = 130,  .valid_flags = "--------", .nftname = "re-config"},
+    { .name = "PAD",		.chunk_type = 132,  .valid_flags = "--------", .nftname = "pad"},
     { .name = "ASCONF",		.chunk_type = 193,  .valid_flags = "--------", .nftname = "asconf" },
     { .name = "ASCONF_ACK",	.chunk_type = 128,  .valid_flags = "--------", .nftname = "asconf-ack" },
     { .name = "FORWARD_TSN",	.chunk_type = 192,  .valid_flags = "--------", .nftname = "forward-tsn" },
+    { .name = "I_FORWARD_TSN",	.chunk_type = 194,  .valid_flags = "--------", .nftname = "i-forward-tsn" },
 };
 
 static void
diff --git a/extensions/libxt_sctp.man b/extensions/libxt_sctp.man
index 3e5ffa09..06da04f8 100644
--- a/extensions/libxt_sctp.man
+++ b/extensions/libxt_sctp.man
@@ -19,12 +19,14 @@ Match if any of the given chunk types is present with given flags.
 only
 Match if only the given chunk types are present with given flags and none are missing.
 
-Chunk types: DATA INIT INIT_ACK SACK HEARTBEAT HEARTBEAT_ACK ABORT SHUTDOWN SHUTDOWN_ACK ERROR COOKIE_ECHO COOKIE_ACK ECN_ECNE ECN_CWR SHUTDOWN_COMPLETE ASCONF ASCONF_ACK FORWARD_TSN
+Chunk types: DATA INIT INIT_ACK SACK HEARTBEAT HEARTBEAT_ACK ABORT SHUTDOWN SHUTDOWN_ACK ERROR COOKIE_ECHO COOKIE_ACK ECN_ECNE ECN_CWR SHUTDOWN_COMPLETE I_DATA RE_CONFIG PAD ASCONF ASCONF_ACK FORWARD_TSN I_FORWARD_TSN
 
 chunk type            available flags      
 .br
 DATA                  I U B E i u b e
 .br
+I_DATA                I U B E i u b e
+.br
 ABORT                 T t                 
 .br
 SHUTDOWN_COMPLETE     T t                 
-- 
2.31.1

