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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73D83C433B4
	for <netfilter-devel@archiver.kernel.org>; Tue, 18 May 2021 18:17:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 59E2F611EE
	for <netfilter-devel@archiver.kernel.org>; Tue, 18 May 2021 18:17:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351482AbhERSTK (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 18 May 2021 14:19:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351470AbhERSTK (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 18 May 2021 14:19:10 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9157C061573
        for <netfilter-devel@vger.kernel.org>; Tue, 18 May 2021 11:17:51 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id h16so12347817edr.6
        for <netfilter-devel@vger.kernel.org>; Tue, 18 May 2021 11:17:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=TdykZK2S/jihzUWTOPuH8YrEDhlfeRIzg/wx+tPEHa4=;
        b=IvABCDP1Rran7HmmIwJdjimNIGSPNEKUOxMXcrrn79HaZxSY16hlxLRKg4WBUb5xkA
         gX6sIgVS68gLeG9cmnvrIXf8TcaQUlProfj1wcHSpcXqAELrN6pplulbA1Bv6gHq66qD
         L59GMvVtaUrGm60ckq2XNxYIQL5k86ycmk/xWSJMNSJja1/PeUcpKPWwe+QLMMcv3kIJ
         pk3/d1GY+mIUD00VmBvK/xsOrP/rac/Jv602tORToNGxPIniJSwJx/p87Fvv1UZaLWB6
         kMeAUzrG6nsTWdiUUxuvkVQSDFnlh9N4sNhv4g8FsWo8TGZetrRRxG/JNQRx0rFg/m6f
         ek5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=TdykZK2S/jihzUWTOPuH8YrEDhlfeRIzg/wx+tPEHa4=;
        b=VUWdh1wtFDn8EdDJ8hDVlJRrTdpAmBIgzM4bKPosn9YCjuvHsI9nYfcM5xBrssgYHr
         h/+SopthjLmMDZ600jDEpqfgmOgQoc/fEiCCK0ug0j3pEl+fXfiTxlWdSxVz5AsxGuwn
         0/83/rrCZz9ummBUawuQ2g9uWAehV+i0f+NpvEdIhgsFeElZdySVDYxPSZOdO/LRCrBk
         e2iWfuRml80kTd7m1OShysf15Bvla/KeA+lhqeX6jqUzyuGQDXuiImj8G9PJeYVwVdcT
         VlfvmHqsv6CEs/pLfp+SKQlKzv6GYwcnxzZFjarrKGYOmIpRwh0VL1IciI+QxvzPEjqp
         nQvQ==
X-Gm-Message-State: AOAM532WOzSXgWeluFcoGpXxbYQPd6uBxxDnrlr7bT8jPDFVmMa0j/aw
        6c9UpcidG5Jxc9SCkYL/hgcJ2nvu6JkYe3FeFEY=
X-Google-Smtp-Source: ABdhPJzzUeKqcMN5wCj3pD847VPPkur88taGdHZWKV22bClWz9UVBnS1tybapmpvDkOab8iXHYjaGg==
X-Received: by 2002:aa7:c488:: with SMTP id m8mr8430588edq.193.1621361870578;
        Tue, 18 May 2021 11:17:50 -0700 (PDT)
Received: from localhost (ptr-5gw9tx0z7f066xyxzn.18120a2.ip6.access.telenet.be. [2a02:1810:510:3800:124:6af2:167b:d993])
        by smtp.gmail.com with ESMTPSA id n17sm13224529eds.72.2021.05.18.11.17.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 May 2021 11:17:50 -0700 (PDT)
From:   Thomas De Schampheleire <patrickdepinguin@gmail.com>
To:     netfilter-devel@vger.kernel.org
Cc:     thomas.de_schampheleire@nokia.com
Subject: [ebtables PATCH 2/2] configure.ac: add option --enable-kernel-64-userland-32
Date:   Tue, 18 May 2021 20:17:30 +0200
Message-Id: <20210518181730.13436-2-patrickdepinguin@gmail.com>
X-Mailer: git-send-email 2.26.3
In-Reply-To: <20210518181730.13436-1-patrickdepinguin@gmail.com>
References: <20210518181730.13436-1-patrickdepinguin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Thomas De Schampheleire <thomas.de_schampheleire@nokia.com>

The ebtables build system seems to assume that 'sparc64' is the
only case where KERNEL_64_USERSPACE_32 is relevant, but this is not true.
This situation can happen on many architectures, especially in embedded
systems. For example, an Aarch64 processor with kernel in 64-bit but
userland built for 32-bit Arm. Or a 64-bit MIPS Octeon III processor, with
userland running in the 'n32' ABI.

While it is possible to set CFLAGS in the environment when calling the
configure script, the caller would need to know to not only specify
KERNEL_64_USERSPACE_32 but also the EBT_MIN_ALIGN value.

Instead, add a configure option. All internal details can then be handled by
the configure script.

Signed-off-by: Thomas De Schampheleire <thomas.de_schampheleire@nokia.com>
---
 configure.ac | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/configure.ac b/configure.ac
index c24ede3..3e89c0c 100644
--- a/configure.ac
+++ b/configure.ac
@@ -15,10 +15,17 @@ AS_IF([test "x$LOCKFILE" = x], [LOCKFILE="/var/lib/ebtables/lock"])
 
 regular_CFLAGS="-Wall -Wunused"
 regular_CPPFLAGS=""
+
 case "$host" in
 	sparc64-*)
-		regular_CPPFLAGS="$regular_CPPFLAGS -DEBT_MIN_ALIGN=8 -DKERNEL_64_USERSPACE_32";;
+		enable_kernel_64_userland_32=yes ;;
 esac
+AC_ARG_ENABLE([kernel-64-userland-32],
+    AC_HELP_STRING([--enable-kernel-64-userland-32], [indicate that ebtables will be built as a 32-bit application but run under a 64-bit kernel])
+)
+AS_IF([test "x$enable_kernel_64_userland_32" = xyes],
+    [regular_CPPFLAGS="$regular_CPPFLAGS -DEBT_MIN_ALIGN=8 -DKERNEL_64_USERSPACE_32"]
+)
 
 AC_SUBST([regular_CFLAGS])
 AC_SUBST([regular_CPPFLAGS])
-- 
2.26.3

