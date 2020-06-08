Return-Path: <SRS0=kOBD=7V=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8ED0C433DF
	for <netfilter-devel@archiver.kernel.org>; Mon,  8 Jun 2020 21:25:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9F117206D5
	for <netfilter-devel@archiver.kernel.org>; Mon,  8 Jun 2020 21:25:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726774AbgFHVZ5 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 8 Jun 2020 17:25:57 -0400
Received: from correo.us.es ([193.147.175.20]:39816 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726730AbgFHVZ5 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 8 Jun 2020 17:25:57 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 8240FC2FE6
        for <netfilter-devel@vger.kernel.org>; Mon,  8 Jun 2020 23:25:55 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 724AADA789
        for <netfilter-devel@vger.kernel.org>; Mon,  8 Jun 2020 23:25:55 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 68212DA722; Mon,  8 Jun 2020 23:25:55 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 3B641DA78A
        for <netfilter-devel@vger.kernel.org>; Mon,  8 Jun 2020 23:25:53 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 08 Jun 2020 23:25:53 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 20D2F42EF4E0
        for <netfilter-devel@vger.kernel.org>; Mon,  8 Jun 2020 23:25:53 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH libnetfilter_queue] configure: disable doxygen by default
Date:   Mon,  8 Jun 2020 23:25:50 +0200
Message-Id: <20200608212550.28118-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

doxygen documentation was not enabled in previous releases, let's
recover this default behaviour. This is implicitly fixing up `make
distcheck' to build the tarballs.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 configure.ac | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/configure.ac b/configure.ac
index 0de144c350d5..96e18be694a9 100644
--- a/configure.ac
+++ b/configure.ac
@@ -38,15 +38,14 @@ AC_CONFIG_FILES([Makefile src/Makefile utils/Makefile examples/Makefile
 
 AC_ARG_WITH([doxygen], [AS_HELP_STRING([--with-doxygen],
 	    [create doxygen documentation])],
-	    [with_doxygen="$withval"], [with_doxygen=yes])
-
-AS_IF([test "x$with_doxygen" != xno], [
+	    [], [with_doxygen=no])
+AS_IF([test "x$with_doxygen" = xyes], [
 	AC_CHECK_PROGS([DOXYGEN], [doxygen])
 ])
 
 AM_CONDITIONAL([HAVE_DOXYGEN], [test -n "$DOXYGEN"])
-if test -z "$DOXYGEN"; then
-	dnl Only run doxygen Makefile if doxygen installed
-	AC_MSG_WARN([Doxygen not found - continuing without Doxygen support])
-fi
 AC_OUTPUT
+
+echo "
+libnetfilter_queue configuration:
+  doxygen:                      ${with_doxygen}"
-- 
2.20.1

