Return-Path: <SRS0=sEEs=Z2=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E5DFC2BC73
	for <netfilter-devel@archiver.kernel.org>; Wed,  4 Dec 2019 18:18:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DD1FF20675
	for <netfilter-devel@archiver.kernel.org>; Wed,  4 Dec 2019 18:17:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731762AbfLDSR6 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 4 Dec 2019 13:17:58 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:33405 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731478AbfLDSR5 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 4 Dec 2019 13:17:57 -0500
Received: by mail-wr1-f68.google.com with SMTP id b6so390375wrq.0
        for <netfilter-devel@vger.kernel.org>; Wed, 04 Dec 2019 10:17:56 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:date:message-id:user-agent
         :mime-version:content-transfer-encoding;
        bh=XJM6mwmAHv0HkyeA4xMbQkhvfamB1JPPALvK71vfYVQ=;
        b=G7WDa6zhnSltJE4BHkopG2At45e33UZXu/mk7/Bm4qnBdwe0SX4qAnlKAV+Tks2fsC
         SdpR4InDWi1Ux9kDB67gGZtfumxjkJge8ZiGmNisHV/isBKpK2HscZ486fmKvwEY9YpT
         tznRcou8AOTwJi/Dufl+7doMKU8g/ddkWC/UXC96seqsJMx8l7BIRklTbToE2+gZwCgO
         MJsi4WkxP/WWr3autKsEsaIdhLBk+QaQF1kbFz+fifAa+2JYnHnUTTYTVm3VmDXWIqZz
         tggHwWd/syFSoC9JkqRhCtHvX9mjQBbAh0/rxX8zVqjiRrAzO12NQRsgii2A6xH7wJLE
         fYMg==
X-Gm-Message-State: APjAAAWUbKFCWdQ4EGSj9lauo1ds5oOoveXD2dvnG7jsiSrqnDR/T/1d
        3pVXNt58LZz1ERa7zBfkyT2hu0J93Vo=
X-Google-Smtp-Source: APXvYqy3Ly/0ZiU2B0hNyVdioirbV8GFHinkZQ2h7xnAAKQVHmg0wyvTHepGhAqUl9kyYOZWQlufaA==
X-Received: by 2002:a5d:4cc9:: with SMTP id c9mr5425981wrt.70.1575483475640;
        Wed, 04 Dec 2019 10:17:55 -0800 (PST)
Received: from localhost (static.68.138.194.213.ibercom.com. [213.194.138.68])
        by smtp.gmail.com with ESMTPSA id x17sm9167123wrt.74.2019.12.04.10.17.54
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Dec 2019 10:17:55 -0800 (PST)
Subject: [iptables PATCH 1/7] iptables: install iptables-apply script and
 manpage
From:   Arturo Borrero Gonzalez <arturo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Date:   Wed, 04 Dec 2019 19:17:53 +0100
Message-ID: <157548347377.125234.12163057581146113349.stgit@endurance>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Laurence J. Lane <ljlane@debian.org>

We have the iptables-apply script in the tree (and in the release tarball), but
is not being installed anywhere. Same for the manpage.

Arturo says:
 I'm not a strong supporter of this script, but there are many users of it, so
 better do things right and do a proper installation.
 This patch is forwarded from the iptables Debian package, where it has been
 around for many years now.

Signed-off-by: Laurence J. Lane <ljlane@debian.org>
Signed-off-by: Arturo Borrero Gonzalez <arturo@netfilter.org>
---
 iptables/Makefile.am       |    7 ++++++-
 iptables/ip6tables-apply.8 |    1 +
 2 files changed, 7 insertions(+), 1 deletion(-)
 create mode 100644 iptables/ip6tables-apply.8

diff --git a/iptables/Makefile.am b/iptables/Makefile.am
index fc834e0f..71b1b1d4 100644
--- a/iptables/Makefile.am
+++ b/iptables/Makefile.am
@@ -53,7 +53,11 @@ sbin_PROGRAMS	+= xtables-nft-multi
 endif
 man_MANS         = iptables.8 iptables-restore.8 iptables-save.8 \
                    iptables-xml.1 ip6tables.8 ip6tables-restore.8 \
-                   ip6tables-save.8 iptables-extensions.8
+                   ip6tables-save.8 iptables-extensions.8 \
+                   iptables-apply.8 ip6tables-apply.8
+
+sbin_SCRIPT      = iptables-apply
+
 if ENABLE_NFTABLES
 man_MANS	+= xtables-nft.8 xtables-translate.8 xtables-legacy.8 \
                    iptables-translate.8 ip6tables-translate.8 \
@@ -106,3 +110,4 @@ install-exec-hook:
 	for i in ${v4_sbin_links}; do ${LN_S} -f xtables-legacy-multi "${DESTDIR}${sbindir}/$$i"; done;
 	for i in ${v6_sbin_links}; do ${LN_S} -f xtables-legacy-multi "${DESTDIR}${sbindir}/$$i"; done;
 	for i in ${x_sbin_links}; do ${LN_S} -f xtables-nft-multi "${DESTDIR}${sbindir}/$$i"; done;
+	${LN_S} -f iptables-apply "${DESTDIR}${sbindir}/ip6tables-apply"
diff --git a/iptables/ip6tables-apply.8 b/iptables/ip6tables-apply.8
new file mode 100644
index 00000000..994b487a
--- /dev/null
+++ b/iptables/ip6tables-apply.8
@@ -0,0 +1 @@
+.so man8/iptables-apply.8

