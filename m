Return-Path: <SRS0=sEEs=Z2=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C654C2D0B1
	for <netfilter-devel@archiver.kernel.org>; Wed,  4 Dec 2019 18:18:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2BFA42084B
	for <netfilter-devel@archiver.kernel.org>; Wed,  4 Dec 2019 18:18:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731825AbfLDSSZ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 4 Dec 2019 13:18:25 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:38439 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731347AbfLDSSY (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 4 Dec 2019 13:18:24 -0500
Received: by mail-wr1-f68.google.com with SMTP id y17so350072wrh.5
        for <netfilter-devel@vger.kernel.org>; Wed, 04 Dec 2019 10:18:23 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=ooQllG+NjTqw1czxs8zap/sgk/J2yMCcQ3dFqRs11sw=;
        b=RMEwGxtdhSEoPMRvKPcxb5tYRl82c3VD3QwyZCIvarxUu/iohWhnUkBWSP789rtZ2H
         ybXCt0vKyBLGZkMkZXGGRTEKJ/x/9m7BKD1uEkenBips3W9ZnIIM79Lf5A7YdutwBo8E
         yhOqxviOgv9aH2ZgdU6gEYY/StrGwbZalnzO+MdCK2whoAnmT7ibZlqE3Uoo5FUHAwRS
         2TWc28FejfLHDTvvKQt8JZZuIXPndsRfFRMfun2Ghn3xkeDolbg9pMdsk1gkoKgslXil
         1YhWSHKZ9BvPHuXt7z7AVjs2MdSCX1229p4KsldqJH4gsyasEMeFA3UVv3JJu7R8j38j
         xAlA==
X-Gm-Message-State: APjAAAWUqH7Oha7qkcqWFMje9tmN3MYdvbU0bQAryHwfY90FUfXO5CJz
        1QdRcZq23rQzB2mrbp2tO2rlXyR3v20=
X-Google-Smtp-Source: APXvYqwEA214P/1hijEtzn8Gcka0oA1PjJTlO2AqByOmU1b7edA4bZBV1MOVn7JNc8LKxrPQIPt60w==
X-Received: by 2002:adf:dc06:: with SMTP id t6mr5667312wri.378.1575483502788;
        Wed, 04 Dec 2019 10:18:22 -0800 (PST)
Received: from localhost (static.68.138.194.213.ibercom.com. [213.194.138.68])
        by smtp.gmail.com with ESMTPSA id l7sm5040783wmh.0.2019.12.04.10.18.21
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Dec 2019 10:18:22 -0800 (PST)
Subject: [iptables PATCH 5/7] iptables: mention iptables-apply(8) in manpages
From:   Arturo Borrero Gonzalez <arturo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Date:   Wed, 04 Dec 2019 19:18:21 +0100
Message-ID: <157548350119.125234.9202118906807658929.stgit@endurance>
In-Reply-To: <157548347377.125234.12163057581146113349.stgit@endurance>
References: <157548347377.125234.12163057581146113349.stgit@endurance>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Laurence J. Lane <ljlane@debian.org>

Add iptables-apply(8) to the SEE ALSO section of *-save(8) and *-restore(8).

Arturo says:
 This patch is forwarded from the iptables Debian package, where it has been
 around for many years now.

Signed-off-by: Laurence J. Lane <ljlane@debian.org>
Signed-off-by: Arturo Borrero Gonzalez <arturo@netfilter.org>
---
 iptables/iptables-restore.8.in |    2 +-
 iptables/iptables-save.8.in    |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/iptables/iptables-restore.8.in b/iptables/iptables-restore.8.in
index f751492d..b4b62f92 100644
--- a/iptables/iptables-restore.8.in
+++ b/iptables/iptables-restore.8.in
@@ -87,7 +87,7 @@ from Rusty Russell.
 .br
 Andras Kis-Szabo <kisza@sch.bme.hu> contributed ip6tables-restore.
 .SH SEE ALSO
-\fBiptables\-save\fP(8), \fBiptables\fP(8)
+\fBiptables\-apply\fP(8),\fBiptables\-save\fP(8), \fBiptables\fP(8)
 .PP
 The iptables-HOWTO, which details more iptables usage, the NAT-HOWTO,
 which details NAT, and the netfilter-hacking-HOWTO which details the
diff --git a/iptables/iptables-save.8.in b/iptables/iptables-save.8.in
index 29ef2829..7683fd37 100644
--- a/iptables/iptables-save.8.in
+++ b/iptables/iptables-save.8.in
@@ -62,7 +62,7 @@ Rusty Russell <rusty@rustcorp.com.au>
 .br
 Andras Kis-Szabo <kisza@sch.bme.hu> contributed ip6tables-save.
 .SH SEE ALSO
-\fBiptables\-restore\fP(8), \fBiptables\fP(8)
+\fBiptables\-apply\fP(8),\fBiptables\-restore\fP(8), \fBiptables\fP(8)
 .PP
 The iptables-HOWTO, which details more iptables usage, the NAT-HOWTO,
 which details NAT, and the netfilter-hacking-HOWTO which details the

