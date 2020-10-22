Return-Path: <SRS0=B2LC=D5=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EFBB2C388F9
	for <netfilter-devel@archiver.kernel.org>; Thu, 22 Oct 2020 17:30:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 300D72463F
	for <netfilter-devel@archiver.kernel.org>; Thu, 22 Oct 2020 17:30:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="RJJzuc8C"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S369208AbgJVRaT (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 22 Oct 2020 13:30:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S369204AbgJVRaT (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 22 Oct 2020 13:30:19 -0400
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF24CC0613D4
        for <netfilter-devel@vger.kernel.org>; Thu, 22 Oct 2020 10:30:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=XLIRaNv87IMDehcPgZz/aAp+n1fZV9b2iA1ljI7YxsQ=; b=RJJzuc8Cx9f5cjVH8/3jggsMzo
        LDIObqjZtPky78GFR41PZohe9B5unzpD40/pEd9dGfFylW3LcmJsvqordWZLClEjpgvad72J5r4Wn
        0mjYEkS8YjmkiJA4blrBHkZZLYO5+DqPfWOnau6zdXLklONkJkEsJTW7PB7rUL9QvF2evfL0dL6Fv
        EDa2aqEHA5ufyUDsFRWeaV94JlVE2oMQvFMsB33LB0qCpg6WW1+O2eQ0AGMUlUciP8LIB9aVObJMb
        OghQLTx8xyp4Zjd1LWNqEGNVWt230ExAQbD4JI1TGy4/rLgEziUuqP7FDWWjnePr44enRtAhvx+ew
        7jtCkYNA==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtp (Exim 4.92)
        (envelope-from <jeremy@azazel.net>)
        id 1kVePl-0003s0-Gr; Thu, 22 Oct 2020 18:30:13 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Jan Engelhardt <jengelh@inai.de>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH xtables-addons 3/3] pknock: pknlusr: add man-page.
Date:   Thu, 22 Oct 2020 18:30:05 +0100
Message-Id: <20201022173006.635720-4-jeremy@azazel.net>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201022173006.635720-1-jeremy@azazel.net>
References: <20201022173006.635720-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Since pknlusr is now being installed, let's give it a man-page.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 extensions/pknock/Makefile.am |  2 ++
 extensions/pknock/pknlusr.8   | 23 +++++++++++++++++++++++
 2 files changed, 25 insertions(+)
 create mode 100644 extensions/pknock/pknlusr.8

diff --git a/extensions/pknock/Makefile.am b/extensions/pknock/Makefile.am
index dcb3096afd35..fb419ede0d2b 100644
--- a/extensions/pknock/Makefile.am
+++ b/extensions/pknock/Makefile.am
@@ -6,3 +6,5 @@ AM_CFLAGS   = ${regular_CFLAGS} ${libxtables_CFLAGS}
 include ../../Makefile.extra
 
 sbin_PROGRAMS = pknlusr
+
+dist_man8_MANS = pknlusr.8
diff --git a/extensions/pknock/pknlusr.8 b/extensions/pknock/pknlusr.8
new file mode 100644
index 000000000000..da8798a463db
--- /dev/null
+++ b/extensions/pknock/pknlusr.8
@@ -0,0 +1,23 @@
+.TH pknlusr 8 "2020-10-22" "xtables-addons" "xtables-addons"
+.
+.SH NAME
+pknlusr \- userspace monitor for successful xt_pknock matches
+.
+.SH SYNOPSIS
+.SY pknlusr
+.RI [ group-id ]
+.YS
+.
+.SH DESCRIPTION
+\fIxt_pknock\fP is an xtables match extension that implements so-called \fIport
+knocking\fP.  It can be configured to send information about each successful
+match via a netlink socket to userspace.  \fBpknluser\fP listens for these
+notifications.
+.
+.SH OPTIONS
+.TP 9
+.B group-id
+The ID of the netlink multicast group used by \fIxt_pknock\fP.  Defaults to \fB1\fP.
+.
+.SH SEE ALSO
+.IR xtables-addons (8)
-- 
2.28.0

