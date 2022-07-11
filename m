Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19136C433EF
	for <netfilter-devel@archiver.kernel.org>; Mon, 11 Jul 2022 14:27:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229536AbiGKO1C (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 11 Jul 2022 10:27:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229478AbiGKO1C (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 11 Jul 2022 10:27:02 -0400
Received: from mail-qt1-x832.google.com (mail-qt1-x832.google.com [IPv6:2607:f8b0:4864:20::832])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C4443E777
        for <netfilter-devel@vger.kernel.org>; Mon, 11 Jul 2022 07:27:01 -0700 (PDT)
Received: by mail-qt1-x832.google.com with SMTP id w1so7118126qtv.9
        for <netfilter-devel@vger.kernel.org>; Mon, 11 Jul 2022 07:27:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=GJoZ0ZdcMpsGQR1aPIKZfzn2AbPiQH95WRrbJO8R//M=;
        b=QLXXvTjkaj/xgymbkGfGv0bK/sJoWZo6j3Bq/vkyptI1f+fxlQfDA4hVPFbXsmvwFx
         xsE4DdESab3vMBHWsUXbpiAK5oJCesu78G9vwAm2tR+AMNwBU4UfKFRy9m4+o9Vvw/Zn
         AoY8jPaEL+HBxKPtmmHuIPoFhYOjbMiUVYSkJ7w9E7ZTrfpaPm/sLArgeAvog8t2unmH
         mpGNKQjH+hmm22i6tcOKhPzgtAs/rW9qa7Q2l0GXuACb8jey+jR/qNymZPKzP1ZSkuHX
         XFSxu3cOHMpPG19/Fqidnovf3RmTeIAnjC5vrGI4NXd4iTcdBZneDDHebbntNg8yOWQE
         tznQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=GJoZ0ZdcMpsGQR1aPIKZfzn2AbPiQH95WRrbJO8R//M=;
        b=QeGIlmmEsC0Ne8eHDXMm6UStzdcSU+tLimwq8s6kKAcQ7Woo4WCUnsD6jb2skIe2q7
         fyZLSIMShxmv4abBFY8OuRn4qDEBOfP7xZi3YgL3a1gU4pVOW2MPTQO15lzO7qGbgpk+
         nhPlpBGvpKW5GttRZIJiHH9cCF4IVOOjVp8lkBSJxinv9nrPVvixu4Z9l1b+Rq+Ikj46
         LqPRlA/3imKYw8uJu1STaCo2FF9AanPku4PPxQvIdB3ajmeZKVM8eysbjbeliWegNGKT
         hDXK4UTApkexU/LLmKj9oPVeeuSLuXIiGRhZubWAP06UG0Mo/7VViX6Nvamj4rT8JDnx
         y7NA==
X-Gm-Message-State: AJIora8if0mWTqkHJToLlB7x05x0IIVp/YXA68lchNA0K3Sx/o3HBTsr
        KcVIL/ZK3zQyUWa6sDKeAuzoIknPEao=
X-Google-Smtp-Source: AGRyM1uxL6aW9ezkrCZlf2iskMyu+ww2jxbC3dnAVF94X+yocEBh5Ad3FE+iHboxJsAyqH6G9esVpg==
X-Received: by 2002:a05:622a:1901:b0:31e:bb55:dc44 with SMTP id w1-20020a05622a190100b0031ebb55dc44mr496940qtc.168.1657549620211;
        Mon, 11 Jul 2022 07:27:00 -0700 (PDT)
Received: from yuluo.com (cpe-68-175-122-13.nyc.res.rr.com. [68.175.122.13])
        by smtp.gmail.com with ESMTPSA id d3-20020a05620a240300b006afc53e0be2sm6804336qkn.117.2022.07.11.07.26.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Jul 2022 07:26:59 -0700 (PDT)
From:   Yuxuan Luo <luoyuxuan.carl@gmail.com>
X-Google-Original-From: Yuxuan Luo <yuluo@redhat.com>
To:     netfilter-devel@vger.kernel.org
Cc:     fw@strlen.de, marcelo.leitner@gmail.com, lucien.xin@gmail.com,
        Yuxuan Luo <yuluo@redhat.com>,
        Yuxuan Luo <luoyuxuan.carl@gmail.com>
Subject: [IPTABLES][PATCHv2] xt_sctp: support a couple of new chunk types
Date:   Mon, 11 Jul 2022 10:21:46 -0400
Message-Id: <20220711142145.364328-1-yuluo@redhat.com>
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
index 4016e4fb..6f04f1db 100644
--- a/extensions/libxt_sctp.t
+++ b/extensions/libxt_sctp.t
@@ -27,3 +27,7 @@
 -p sctp -m sctp --chunk-types all ASCONF_ACK;=;OK
 -p sctp -m sctp --chunk-types all FORWARD_TSN;=;OK
 -p sctp -m sctp --chunk-types all SHUTDOWN_COMPLETE;=;OK
+-p sctp -m sctp --chunk-types all I_DATA;=;OK
+-p sctp -m sctp --chunk-types all RE_CONFIG;=;OK
+-p sctp -m sctp --chunk-types all PAD;=;OK
+-p sctp -m sctp --chunk-types all I_FORWARD_FSN;=;OK
-- 
2.31.1

