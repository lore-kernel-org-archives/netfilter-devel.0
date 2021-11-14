Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B269DC433EF
	for <netfilter-devel@archiver.kernel.org>; Sun, 14 Nov 2021 15:52:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9181360EE2
	for <netfilter-devel@archiver.kernel.org>; Sun, 14 Nov 2021 15:52:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234744AbhKNPzn (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 14 Nov 2021 10:55:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231888AbhKNPzj (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 14 Nov 2021 10:55:39 -0500
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2188C061746
        for <netfilter-devel@vger.kernel.org>; Sun, 14 Nov 2021 07:52:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=hMlQewvosTcMJZ/fpS3RVQdMOXh5q0uJD2cbaSGb0DM=; b=quT1ccG04w9Q9pruC719No8g5O
        88GXTExrir6x7zkrLjDj7Da4pq/KD3Kayn0VHQB8Wp++iAgxkGykrUM0YakioC0MpQeW2q9IBD6yW
        E11SmU8qDzS++UlS/O/WcqfpaWyAGl3aLQnS2t94jgj3zFARYOkzch1+blq3LVsSXr5zdxRyu9SRH
        fdC/DUYU5jpdKhxdRrxgFJCtydvOdyIlV/jChCweNN3BRIEjgoEo3c6X98hqCve8PCE0+mOKNeIT/
        ZPGOaSOPhl6kapVKkPXP/1rNsGvfEkKCyhi9VCaoCYm5IVgfBb9L0QyJWlQ7F7VX7ZBT8xWI3TPJH
        B3L9Lijg==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1mmHo9-00CfJ1-0A
        for netfilter-devel@vger.kernel.org; Sun, 14 Nov 2021 15:52:41 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [ulogd2 PATCH v4 05/15] build: move CPP `-D` flag.
Date:   Sun, 14 Nov 2021 15:52:21 +0000
Message-Id: <20211114155231.793594-6-jeremy@azazel.net>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211114155231.793594-1-jeremy@azazel.net>
References: <20211114155231.793594-1-jeremy@azazel.net>
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

