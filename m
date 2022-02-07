Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD6BAC433EF
	for <netfilter-devel@archiver.kernel.org>; Mon,  7 Feb 2022 14:21:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240192AbiBGOSD (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 7 Feb 2022 09:18:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1389012AbiBGNvA (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 7 Feb 2022 08:51:00 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5B9EC043181
        for <netfilter-devel@vger.kernel.org>; Mon,  7 Feb 2022 05:50:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=rlQZPR9ILOYJuCf2aAXEjwK+v9g2SqN1RBfxrRrdEuA=; b=Woc6ML/ANC2VwW0s3vCXFDNiPH
        F3v98WP7eR/vWl2UlWcQpD6i4D7raWbtp1mC0xv8+xykpFuObrdVZPlD62SucjuMwXu7GLSr1GxiS
        /1gJHxdrohjftW7TKsxmcjaF5/729qwxSnPerEAXmaG89Nn1s1/vSAI8nHQcn1khLD55xinsuZ1GD
        KE0odKIrN9JvKWLwnzYPwY7X2TC/bQKvOSMZ1cxKVnXVed3C/u4etky19/DRyV8JTWplnnutqmHsF
        QuzR0feJRNJd3gcXQX2bhBczXadNzeo1iabhkm6CvkpugPcqIRI+F4tgc33eQzXpBrCJE+YeocDp5
        U41InnJQ==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1nH4Pv-0007f7-GX; Mon, 07 Feb 2022 14:50:55 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [libnetfilter_conntrack PATCH 2/2] tests: Add simple tests to TESTS variable
Date:   Mon,  7 Feb 2022 14:50:48 +0100
Message-Id: <20220207135048.17147-2-phil@nwl.cc>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220207135048.17147-1-phil@nwl.cc>
References: <20220207135048.17147-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This way, 'make check' and 'make distcheck' call them. Omit
ct_stress/ct_events_reliable, they require root.

For test_connlabel to find qa-connlabel.conf during 'make distcheck',
use of 'srcdir' env variable is needed. Add this as a third option to
not break existing use-cases.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 tests/Makefile.am      | 2 ++
 tests/test_connlabel.c | 8 ++++++++
 2 files changed, 10 insertions(+)

diff --git a/tests/Makefile.am b/tests/Makefile.am
index 56c78d9424326..16fbe6a77aa6d 100644
--- a/tests/Makefile.am
+++ b/tests/Makefile.am
@@ -5,6 +5,8 @@ check_PROGRAMS = test_api test_filter test_connlabel ct_stress \
 
 EXTRA_DIST = qa-connlabel.conf
 
+TESTS = test_api test_filter test_connlabel
+
 test_api_SOURCES = test_api.c
 test_api_LDADD = ../src/libnetfilter_conntrack.la
 
diff --git a/tests/test_connlabel.c b/tests/test_connlabel.c
index 99b1171857db3..f6f222b309a84 100644
--- a/tests/test_connlabel.c
+++ b/tests/test_connlabel.c
@@ -1,4 +1,5 @@
 #include <assert.h>
+#include <limits.h>
 #include <stdio.h>
 #include <stdlib.h>
 #include <time.h>
@@ -60,6 +61,13 @@ int main(void)
 	l = nfct_labelmap_new("qa-connlabel.conf");
 	if (!l)
 		l = nfct_labelmap_new("tests/qa-connlabel.conf");
+	if (!l) {
+		char testconf[PATH_MAX];
+
+		snprintf(testconf, PATH_MAX,
+			 "%s/qa-connlabel.conf", getenv("srcdir"));
+		l = nfct_labelmap_new(testconf);
+	}
 	assert(l);
 	puts("qa-connlabel.conf:");
 	dump_map(l);
-- 
2.34.1

