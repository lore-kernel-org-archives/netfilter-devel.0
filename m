Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F086BC07E95
	for <netfilter-devel@archiver.kernel.org>; Tue, 13 Jul 2021 23:48:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CD67761369
	for <netfilter-devel@archiver.kernel.org>; Tue, 13 Jul 2021 23:48:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236901AbhGMXvW (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 13 Jul 2021 19:51:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235437AbhGMXvW (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 13 Jul 2021 19:51:22 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2509C0613DD
        for <netfilter-devel@vger.kernel.org>; Tue, 13 Jul 2021 16:48:30 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id h4so56309pgp.5
        for <netfilter-devel@vger.kernel.org>; Tue, 13 Jul 2021 16:48:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=JH8KUHFsuNuZdJHUWEpqo4+J28fbezh4S+r2wiQbJzE=;
        b=rzQxgMmKHA6o19yyh4kNIvpnadnr8tE/hYcUbiVl8EnEHViV+c+M8Q1tLxBQxPZAS/
         rxp/9WhOqfiUzXDGEiKmcu6OQBVouoJZO0i5S7CvDX1w71kotrfS4NuJJNYy6P0M0Kor
         gnTB2nSheQanOUJT/Li/JL6qu+yfg8XqcGlI3Ohy1v06dkDhUNAZwXrmYxthrV07K9Gj
         YK55Awiye9UFmZJqxCrp34xHc/0ng/OWt8hrb9X+n9HkUgLfEJzeSXGLLtn7MLCo+xUD
         8obEgSYrJKiMwCFp1ydfyfN4gBUbQZEachzoA/250FNQJk3UnxGe6QbCsOLDaOaoRGOv
         TcJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=JH8KUHFsuNuZdJHUWEpqo4+J28fbezh4S+r2wiQbJzE=;
        b=Tf/5h8Xc6p0jdCqbP75A09HYKCx94Wm/viVU/9EVcEbfGLlE3sqdFakvWRAA+1gsfb
         sbwVsvlJXbV29C5j2b61guSo/txLhrJjGQpcibCorfzsto/nJkVUL6APVzkHgyJjpDEp
         ssZkFii6MC9VAUpyzkL+KHzzjtVUYmOYCnKvelypONyD21LInBsleL5YypGLeT+FDZYA
         lnXwbAfhDf24s2dsNfrRvu27UdMO4+6EEXDQsSJVLg1yLbQ9pcVZ4AuCPsmsd3tsPSME
         rA4chjVDO7ocekHxzip0rJCT8JQ6eqppFjFnBwIs3uQZrKfNpwU6RXu0jvJKTM0j+8xC
         WNZg==
X-Gm-Message-State: AOAM532GwnMjTQrZY/HXYEJ/DzPUu6J2ltCVpFGM2hXjoTXlMwN3Ua9q
        btOX213em5dJbsUN0Z929WWKaPr0JgGDXA==
X-Google-Smtp-Source: ABdhPJzfqfowb+wchkAv0aSkCgx6eZ821zsxf0E4T9+eZRDKCuUSdtuJq8iRGePWIhdYwUM8RhHtIA==
X-Received: by 2002:aa7:9af7:0:b029:32b:34a7:2e73 with SMTP id y23-20020aa79af70000b029032b34a72e73mr7209075pfp.62.1626220110402;
        Tue, 13 Jul 2021 16:48:30 -0700 (PDT)
Received: from europa.local (ip68-231-38-231.ph.ph.cox.net. [68.231.38.231])
        by smtp.gmail.com with ESMTPSA id n6sm213280pgb.60.2021.07.13.16.48.29
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 13 Jul 2021 16:48:30 -0700 (PDT)
From:   Erik Wilson <erik.e.wilson@gmail.com>
X-Google-Original-From: Erik Wilson <Erik.E.Wilson@gmail.com>
Received: by europa.local (Postfix, from userid 501)
        id E6C95C06B679; Tue, 13 Jul 2021 16:48:28 -0700 (MST)
To:     netfilter-devel@vger.kernel.org
Cc:     Erik Wilson <Erik.E.Wilson@gmail.com>
Subject: [PATCH] xtables: Call init_extensions6() for static builds
Date:   Tue, 13 Jul 2021 16:48:23 -0700
Message-Id: <20210713234823.36131-1-Erik.E.Wilson@gmail.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Initialize extensions from libext6 for cases where xtables is built statically.

Closes: https://bugzilla.netfilter.org/show_bug.cgi?id=1550
Signed-off-by: Erik Wilson <Erik.E.Wilson@gmail.com>
---
 iptables/xtables-monitor.c    | 1 +
 iptables/xtables-restore.c    | 1 +
 iptables/xtables-save.c       | 1 +
 iptables/xtables-standalone.c | 1 +
 iptables/xtables-translate.c  | 1 +
 5 files changed, 5 insertions(+)

diff --git a/iptables/xtables-monitor.c b/iptables/xtables-monitor.c
index 4b980980..21d4bec0 100644
--- a/iptables/xtables-monitor.c
+++ b/iptables/xtables-monitor.c
@@ -628,6 +628,7 @@ int xtables_monitor_main(int argc, char *argv[])
 #if defined(ALL_INCLUSIVE) || defined(NO_SHARED_LIBS)
 	init_extensions();
 	init_extensions4();
+	init_extensions6();
 #endif
 
 	if (nft_init(&h, AF_INET, xtables_ipv4)) {
diff --git a/iptables/xtables-restore.c b/iptables/xtables-restore.c
index d2739497..72832103 100644
--- a/iptables/xtables-restore.c
+++ b/iptables/xtables-restore.c
@@ -364,6 +364,7 @@ xtables_restore_main(int family, const char *progname, int argc, char *argv[])
 #if defined(ALL_INCLUSIVE) || defined(NO_SHARED_LIBS)
 		init_extensions();
 		init_extensions4();
+		init_extensions6();
 #endif
 		break;
 	case NFPROTO_ARP:
diff --git a/iptables/xtables-save.c b/iptables/xtables-save.c
index cfce0472..98cd0ed3 100644
--- a/iptables/xtables-save.c
+++ b/iptables/xtables-save.c
@@ -203,6 +203,7 @@ xtables_save_main(int family, int argc, char *argv[],
 #if defined(ALL_INCLUSIVE) || defined(NO_SHARED_LIBS)
 		init_extensions();
 		init_extensions4();
+		init_extensions6();
 #endif
 		tables = xtables_ipv4;
 		d.commit = true;
diff --git a/iptables/xtables-standalone.c b/iptables/xtables-standalone.c
index 7b71db62..1a6b7cf7 100644
--- a/iptables/xtables-standalone.c
+++ b/iptables/xtables-standalone.c
@@ -57,6 +57,7 @@ xtables_main(int family, const char *progname, int argc, char *argv[])
 #if defined(ALL_INCLUSIVE) || defined(NO_SHARED_LIBS)
 	init_extensions();
 	init_extensions4();
+	init_extensions6();
 #endif
 
 	if (nft_init(&h, family, xtables_ipv4) < 0) {
diff --git a/iptables/xtables-translate.c b/iptables/xtables-translate.c
index 33ba68ec..49f44b6f 100644
--- a/iptables/xtables-translate.c
+++ b/iptables/xtables-translate.c
@@ -482,6 +482,7 @@ static int xtables_xlate_main_common(struct nft_handle *h,
 #if defined(ALL_INCLUSIVE) || defined(NO_SHARED_LIBS)
 	init_extensions();
 	init_extensions4();
+	init_extensions6();
 #endif
 		tables = xtables_ipv4;
 		break;
-- 
2.28.0

