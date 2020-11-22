Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B2A6C6379D
	for <netfilter-devel@archiver.kernel.org>; Sun, 22 Nov 2020 14:05:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BD94820786
	for <netfilter-devel@archiver.kernel.org>; Sun, 22 Nov 2020 14:05:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="JkL2AlXI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727882AbgKVOFh (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 22 Nov 2020 09:05:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727850AbgKVOFg (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 22 Nov 2020 09:05:36 -0500
Received: from kadath.azazel.net (kadath.azazel.net [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4F89C061A4B
        for <netfilter-devel@vger.kernel.org>; Sun, 22 Nov 2020 06:05:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=txpXbQxru/bCifD196lQEsMZ6ymgJxc0EtvT43oj3jM=; b=JkL2AlXIaaWSeMlPeg1O7OZBid
        mAZrQpprsNdJEnKkfEbucwy9ZGcKFNcBZghmWuMAeyFPtudr3lAcPdyvw91yGHpZymHnRRrZUMhY3
        /vl9xqa3zfFu+MWxU6edzDVNxVJIk0vwuDkQGIaKYHDP2k2cpG2nv2Lr1PgFzVDAmMDjPgkSSjb4O
        1CFy2ZYxxHO2YPY17PL+XkaathCw547IgfRbkOJmKHWULF7tvbPOm/zllBu3L8tu0iMpHZKHkMs0f
        d2IFw2Xt3/VqksUzmmvQNZLoF9pEzDadPIQqepF40Qer0zxnSuQ5xxlzvywX1qtyU/GoyAeuZPi4C
        9HjEtXbw==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtp (Exim 4.92)
        (envelope-from <jeremy@azazel.net>)
        id 1kgpzh-0002wq-U0; Sun, 22 Nov 2020 14:05:34 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Jan Engelhardt <jengelh@inai.de>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH xtables-addons 3/4] geoip: add man-pages for MaxMind scripts.
Date:   Sun, 22 Nov 2020 14:05:29 +0000
Message-Id: <20201122140530.250248-4-jeremy@azazel.net>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201122140530.250248-1-jeremy@azazel.net>
References: <20201122140530.250248-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 geoip/Makefile.am              |  4 +++-
 geoip/xt_geoip_build_maxmind.1 | 40 ++++++++++++++++++++++++++++++++++
 geoip/xt_geoip_dl_maxmind.1    | 22 +++++++++++++++++++
 3 files changed, 65 insertions(+), 1 deletion(-)
 create mode 100644 geoip/xt_geoip_build_maxmind.1
 create mode 100644 geoip/xt_geoip_dl_maxmind.1

diff --git a/geoip/Makefile.am b/geoip/Makefile.am
index 5323c82eb7c4..8c0b6af80054 100644
--- a/geoip/Makefile.am
+++ b/geoip/Makefile.am
@@ -4,4 +4,6 @@ bin_SCRIPTS = xt_geoip_fetch
 
 pkglibexec_SCRIPTS = xt_geoip_build xt_geoip_build_maxmind xt_geoip_dl xt_geoip_dl_maxmind
 
-man1_MANS = xt_geoip_build.1 xt_geoip_dl.1 xt_geoip_fetch.1
+man1_MANS = xt_geoip_build.1 xt_geoip_dl.1 \
+	    xt_geoip_build_maxmind.1 xt_geoip_dl_maxmind.1 \
+	    xt_geoip_fetch.1
diff --git a/geoip/xt_geoip_build_maxmind.1 b/geoip/xt_geoip_build_maxmind.1
new file mode 100644
index 000000000000..e20e44848b82
--- /dev/null
+++ b/geoip/xt_geoip_build_maxmind.1
@@ -0,0 +1,40 @@
+.TH xt_geoip_build_maxmind 1 "2010-12-17" "xtables-addons" "xtables-addons"
+.SH Name
+.PP
+xt_geoip_build_maxmind \(em convert GeoIP.csv to packed format for xt_geoip
+.SH Syntax
+.PP
+\fI/usr/libexec/xt_geoip/\fP\fBxt_geoip_build_maxmind\fP [\fB\-D\fP
+\fItarget_dir\fP] [\fB\-S\fP \fIsource_dir\fP]
+.SH Description
+.PP
+xt_geoip_build_maxmind is used to build packed raw representations of the range
+database that the xt_geoip module relies on. Since kernel memory is precious,
+much of the preprocessing is done in userspace by this very building tool. One
+file is produced for each country, so that no more addresses than needed are
+required to be loaded into memory. The ranges in the packed database files are
+also ordered, as xt_geoip relies on this property for its bisection approach to
+work.
+.PP
+Since the script is usually installed to the libexec directory of the
+xtables-addons package and this is outside $PATH (on purpose), invoking the
+script requires it to be called with a path.
+.PP Options
+.TP
+\fB\-D\fP \fItarget_dir\fP
+Specifies the target directory into which the files are to be put. Defaults to ".".
+.TP
+\fB\-S\fP \fIsource_dir\fP
+Specifies the source directory of the MaxMind CSV files. Defaults to ".".
+.TP
+\fB\-s\fP
+"System mode". Equivalent to \fB\-D /usr/share/xt_geoip\fP.
+.SH Application
+.PP
+Shell commands to build the databases and put them to where they are expected
+(usually run as root):
+.PP
+xt_geoip_build_maxmind \-s
+.SH See also
+.PP
+xt_geoip_dl_maxmind(1)
diff --git a/geoip/xt_geoip_dl_maxmind.1 b/geoip/xt_geoip_dl_maxmind.1
new file mode 100644
index 000000000000..00a73d7ee90d
--- /dev/null
+++ b/geoip/xt_geoip_dl_maxmind.1
@@ -0,0 +1,22 @@
+.TH xt_geoip_dl_maxmind 1 "2010-12-17" "xtables-addons" "xtables-addons"
+.SH Name
+.PP
+xt_geoip_dl_maxmind \(em download MaxMind GeoIP database files
+.SH Syntax
+.PP
+\fI/usr/libexec/xt_geoip/\fP\fBxt_geoip_dl_maxmind\fP [\fI licence-key file\fP]
+.SH Description
+.PP
+Downloads the MaxMind GeoLite2 databases for IPv4 and IPv6 and unpacks them to
+the current directory.  The alternate \fBxt_geoip_dl\fP script can be
+used for the DB-IP Country Lite databases.
+.PP
+Since the script is usually installed to the libexec directory of the
+xtables-addons package and this is outside $PATH (on purpose), invoking the
+script requires it to be called with a path.
+.SH Options
+.PP
+None.
+.SH See also
+.PP
+xt_geoip_build_maxmind(1)
-- 
2.29.2

