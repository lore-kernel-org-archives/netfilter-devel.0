Return-Path: <SRS0=tHxH=BH=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9B5BC433E4
	for <netfilter-devel@archiver.kernel.org>; Tue, 28 Jul 2020 23:02:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9FEDB2083B
	for <netfilter-devel@archiver.kernel.org>; Tue, 28 Jul 2020 23:02:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729896AbgG1XCF (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 28 Jul 2020 19:02:05 -0400
Received: from mail.redfish-solutions.com ([45.33.216.244]:51160 "EHLO
        mail.redfish-solutions.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729816AbgG1XCF (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 28 Jul 2020 19:02:05 -0400
X-Greylist: delayed 376 seconds by postgrey-1.27 at vger.kernel.org; Tue, 28 Jul 2020 19:02:03 EDT
Received: from son-of-builder.redfish-solutions.com (son-of-builder.redfish-solutions.com [192.168.1.56])
        (authenticated bits=0)
        by mail.redfish-solutions.com (8.15.2/8.15.2) with ESMTPSA id 06SMtiRg101892
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 28 Jul 2020 16:55:44 -0600
From:   "Philip Prindeville" <philipp@redfish-solutions.com>
To:     netfilter-devel@vger.kernel.org
Cc:     Jan Engelhardt <jengelh@inai.de>,
        Philip Prindeville <philipp@redfish-solutions.com>
Subject: [PATCH 1/1] Improve detecting the kernel version logic
Date:   Tue, 28 Jul 2020 16:55:22 -0600
Message-Id: <20200728225522.642-1-philipp@redfish-solutions.com>
X-Mailer: git-send-email 2.17.2
X-Scanned-By: MIMEDefang 2.84 on 192.168.1.3
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Philip Prindeville <philipp@redfish-solutions.com>

---
 configure.ac | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/configure.ac b/configure.ac
index be62d7e7fb96269120c815ab7fcec9bf37955d43..b7a8f0cfda4cf8ab33b3947f9560e938d9f3e635 100644
--- a/configure.ac
+++ b/configure.ac
@@ -44,7 +44,7 @@ regular_CFLAGS="-Wall -Waggregate-return -Wmissing-declarations \
 
 if test -n "$kbuilddir"; then
 	AC_MSG_CHECKING([kernel version that we will build against])
-	krel="$(make -sC "$kbuilddir" M=$PWD kernelrelease | $AWK -v 'FS=[[^0-9.]]' '{print $1; exit}')"
+	krel="$(make -sC "$kbuilddir" M=$PWD kernelversion | $AWK -v 'FS=[[^0-9.]]' '{print $1; exit}')"
 	save_IFS="$IFS"
 	IFS='.'
 	set x $krel
-- 
2.17.2

