Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88BF2C433FE
	for <netfilter-devel@archiver.kernel.org>; Sun, 14 Nov 2021 14:02:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 74F9D60F41
	for <netfilter-devel@archiver.kernel.org>; Sun, 14 Nov 2021 14:02:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233170AbhKNOFD (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 14 Nov 2021 09:05:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233961AbhKNOE0 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 14 Nov 2021 09:04:26 -0500
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4318EC061766
        for <netfilter-devel@vger.kernel.org>; Sun, 14 Nov 2021 06:01:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=hMlQewvosTcMJZ/fpS3RVQdMOXh5q0uJD2cbaSGb0DM=; b=RR0PMI6iSfgOIcvFX13dHpCj7k
        ZSTcEgX7ZYP9Xra81OTcFs/oWe87HPb0Yhx4w7S2FRJS+oFSsvTT+cZSS4iWCyTjMj6rGcTppTFGz
        fbOAY5+X5+8RMyhSjiW1S8f9JP7UkomB1lYi8FQTJOxE1PvK7zTVDjsdvCrIzXM6TEvx8nqhB+uSA
        wOEaIA5nI2YM7ehevKiq8O3GYLl9uV1M90vO6cBVUeyAxb886dOVNqFPzmtvvvzmiGBneqZJyXIie
        Po8E0q06xFNltceNfiFMFFYVC9YQ7BgCKE2/9wGUrEpaI2V5mv0KKpuTeTmW2p1NB5fZGzFScYYlP
        6Uobr0PA==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1mmG4F-00Cdsh-Ah
        for netfilter-devel@vger.kernel.org; Sun, 14 Nov 2021 14:01:11 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [ulogd2 PATCH v3 05/16] build: move CPP `-D` flag.
Date:   Sun, 14 Nov 2021 14:00:47 +0000
Message-Id: <20211114140058.752394-6-jeremy@azazel.net>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211114140058.752394-1-jeremy@azazel.net>
References: <20211114140058.752394-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The `ULOGD2_LIBDIR` macro is only used in one place, so move the flag
defining it out of the common `regular_CFLAGS` variable to the
`AM_CPPFLAGS` variable in the Makefile where it is needed.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 configure.ac    | 2 +-
 src/Makefile.am | 5 +++--
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/configure.ac b/configure.ac
index 4e502171292e..1d795bad325d 100644
--- a/configure.ac
+++ b/configure.ac
@@ -157,7 +157,7 @@ AC_ARG_WITH([ulogd2libdir],
         [ulogd2libdir="${libdir}/ulogd"])
 AC_SUBST([ulogd2libdir])
 
-regular_CFLAGS="-Wall -Wextra -Wno-unused-parameter -DULOGD2_LIBDIR=\\\"\${ulogd2libdir}\\\"";
+regular_CFLAGS="-Wall -Wextra -Wno-unused-parameter";
 AC_SUBST([regular_CFLAGS])
 
 dnl AC_SUBST(DATABASE_DIR)
diff --git a/src/Makefile.am b/src/Makefile.am
index 998e776a8079..e1d45aee4b6c 100644
--- a/src/Makefile.am
+++ b/src/Makefile.am
@@ -1,7 +1,8 @@
 
 AM_CPPFLAGS = -I$(top_srcdir)/include \
-	      -DULOGD_CONFIGFILE="\"$(sysconfdir)/ulogd.conf\"" \
-	      -DULOGD_LOGFILE_DEFAULT="\"$(localstatedir)/log/ulogd.log\""
+	      -DULOGD_CONFIGFILE='"$(sysconfdir)/ulogd.conf"' \
+	      -DULOGD_LOGFILE_DEFAULT='"$(localstatedir)/log/ulogd.log"' \
+	      -DULOGD2_LIBDIR='"$(ulogd2libdir)"'
 AM_CFLAGS = ${regular_CFLAGS}
 
 sbin_PROGRAMS = ulogd
-- 
2.33.0

