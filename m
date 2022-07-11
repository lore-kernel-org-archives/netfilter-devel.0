Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0FC7EC43334
	for <netfilter-devel@archiver.kernel.org>; Mon, 11 Jul 2022 16:14:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231438AbiGKQOE (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 11 Jul 2022 12:14:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231704AbiGKQN6 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 11 Jul 2022 12:13:58 -0400
Received: from mail-qt1-x833.google.com (mail-qt1-x833.google.com [IPv6:2607:f8b0:4864:20::833])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D8AD2A267
        for <netfilter-devel@vger.kernel.org>; Mon, 11 Jul 2022 09:13:56 -0700 (PDT)
Received: by mail-qt1-x833.google.com with SMTP id ck6so7387115qtb.7
        for <netfilter-devel@vger.kernel.org>; Mon, 11 Jul 2022 09:13:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=bo4sWiEqDfQkMkbpmEMQyFSilWoGoQK9pWlDvXVgvHs=;
        b=S9ZyodPPUrxSfGB8JSFW4D8prJH6nW/THOOjSe8gpEWgnmCjBcBtWf4qiqa/aw8O/a
         yG+mOqzTwNBz0H9hM4/AtAtnqh4sqOdKzOvagDGE1wfA/3zwyUOw/eW7O9s2ZkSA/6Zi
         IyKDhwtb4SpYSEVPS7bO3vUuK9aV1iXYkJ/icDHgcs/nAyxJ3vMY9Gsj2A4Ou0NMqiDc
         Cztxjd84TtLJC6Tac9ye6RgzYq4uyEPvjgmvaKX//O+gCpwAEceoezaK7yVYrkaqqy8y
         9aYoSM8PH+NGmbupexp7vkYDZovtFzvkcvBHkJUQx7zaqhJN3Rv2KFDatvb0vEV1xHU/
         KT6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=bo4sWiEqDfQkMkbpmEMQyFSilWoGoQK9pWlDvXVgvHs=;
        b=m0fZSZdxuuXF0TFxrjz6yhnHR9O2ABhcE5AKm9tgVmhzGWXG7VE8kj5AYpDJH1Np5v
         jzzibjCREmcYMdKbqBkQcanZZ65L4S2U09o2h3CQ+6ndHwEvB9Lj7HrCBGBavDtbsL6w
         rJyRihFi9uFG5eAvw8ODJWsm8if20CBEFTtNf/Eazw6iPygZFgiHrt5WaLLOjOfMORZz
         psMDuA5NxEQke495FL9j2wm45zjbQsr/zs8ZSqEp0GfqMya+hRi/M9pK37SAv/yOrf4P
         3o7Y5HWNks1BQjGHyq5rz8QlAPe9lEEEI65EjIM9ScOytha7Ybc4uP8L2Y/r/RmiM5iX
         nEUA==
X-Gm-Message-State: AJIora+qqpBZnWfxvNQ/Sw9/tczaCfbueThr4jfb5yRPk+XyGii0tTbn
        JAW65xjEge2uBoPLJmi0SIuqyutdbEAGsA==
X-Google-Smtp-Source: AGRyM1siSWeerwEujFocG9MJ3lwo2n0qJasbkSkekdMYoKTBVUowLu+PT7n+m1mZ86uMf78f6NaE0A==
X-Received: by 2002:ac8:7f51:0:b0:31e:9c04:6a0 with SMTP id g17-20020ac87f51000000b0031e9c0406a0mr13934857qtk.514.1657556034230;
        Mon, 11 Jul 2022 09:13:54 -0700 (PDT)
Received: from yuluo.com (cpe-68-175-122-13.nyc.res.rr.com. [68.175.122.13])
        by smtp.gmail.com with ESMTPSA id j15-20020a05620a288f00b006a3325fd985sm6965600qkp.13.2022.07.11.09.13.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Jul 2022 09:13:53 -0700 (PDT)
From:   Yuxuan Luo <luoyuxuan.carl@gmail.com>
X-Google-Original-From: Yuxuan Luo <yuluo@redhat.com>
To:     netfilter-devel@vger.kernel.org
Cc:     fw@strlen.de, marcelo.leitner@gmail.com, lucien.xin@gmail.com,
        pablo@netfilter.org, Yuxuan Luo <yuluo@redhat.com>,
        Yuxuan Luo <luoyuxuan.carl@gmail.com>
Subject: [IPTABLES][PATCHv3] xt_sctp: support a couple of new chunk types
Date:   Mon, 11 Jul 2022 12:12:38 -0400
Message-Id: <20220711161237.522258-1-yuluo@redhat.com>
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
 extensions/libxt_sctp.t   | 4 ++++
 3 files changed, 11 insertions(+), 1 deletion(-)

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
diff --git a/extensions/libxt_sctp.t b/extensions/libxt_sctp.t
index 4016e4fb..4d3b113d 100644
--- a/extensions/libxt_sctp.t
+++ b/extensions/libxt_sctp.t
@@ -27,3 +27,7 @@
 -p sctp -m sctp --chunk-types all ASCONF_ACK;=;OK
 -p sctp -m sctp --chunk-types all FORWARD_TSN;=;OK
 -p sctp -m sctp --chunk-types all SHUTDOWN_COMPLETE;=;OK
+-p sctp -m sctp --chunk-types all I_DATA;=;OK
+-p sctp -m sctp --chunk-types all RE_CONFIG;=;OK
+-p sctp -m sctp --chunk-types all PAD;=;OK
+-p sctp -m sctp --chunk-types all I_FORWARD_TSN;=;OK
-- 
2.31.1

