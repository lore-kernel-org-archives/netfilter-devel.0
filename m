Return-Path: <SRS0=r5Yn=RM=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF9E7C43381
	for <netfilter-devel@archiver.kernel.org>; Sat,  9 Mar 2019 10:51:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8522120851
	for <netfilter-devel@archiver.kernel.org>; Sat,  9 Mar 2019 10:51:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726443AbfCIKvJ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 9 Mar 2019 05:51:09 -0500
Received: from orbyte.nwl.cc ([151.80.46.58]:37592 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726164AbfCIKvJ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 9 Mar 2019 05:51:09 -0500
Received: from localhost ([::1]:50682 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1h2ZZL-0007MM-Ap; Sat, 09 Mar 2019 11:51:07 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [libnetfilter_conntrack PATCH] Rename 'qa' directory to 'tests'
Date:   Sat,  9 Mar 2019 11:51:00 +0100
Message-Id: <20190309105100.6299-1-phil@nwl.cc>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190308181231.2bgpj5ladgnhr5up@salvia>
References: <20190308181231.2bgpj5ladgnhr5up@salvia>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

When searching for library tests, 'qa' is easily overlooked. Use a more
common name instead.

Suggested-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 Makefile.am                        | 2 +-
 {qa => tests}/.gitignore           | 0
 {qa => tests}/Makefile.am          | 0
 {qa => tests}/ct_echo_event.c      | 0
 {qa => tests}/ct_echo_event.sh     | 0
 {qa => tests}/ct_events_reliable.c | 0
 {qa => tests}/ct_mark_filter.c     | 0
 {qa => tests}/ct_mark_filter.sh    | 0
 {qa => tests}/ct_stress.c          | 0
 {qa => tests}/inetd.conf           | 0
 {qa => tests}/nssocket.c           | 0
 {qa => tests}/nssocket.h           | 0
 {qa => tests}/nssocket_env.sh      | 0
 {qa => tests}/qa-connlabel.conf    | 0
 {qa => tests}/test_api.c           | 0
 {qa => tests}/test_connlabel.c     | 2 +-
 {qa => tests}/test_filter.c        | 0
 17 files changed, 2 insertions(+), 2 deletions(-)
 rename {qa => tests}/.gitignore (100%)
 rename {qa => tests}/Makefile.am (100%)
 rename {qa => tests}/ct_echo_event.c (100%)
 rename {qa => tests}/ct_echo_event.sh (100%)
 rename {qa => tests}/ct_events_reliable.c (100%)
 rename {qa => tests}/ct_mark_filter.c (100%)
 rename {qa => tests}/ct_mark_filter.sh (100%)
 rename {qa => tests}/ct_stress.c (100%)
 rename {qa => tests}/inetd.conf (100%)
 rename {qa => tests}/nssocket.c (100%)
 rename {qa => tests}/nssocket.h (100%)
 rename {qa => tests}/nssocket_env.sh (100%)
 rename {qa => tests}/qa-connlabel.conf (100%)
 rename {qa => tests}/test_api.c (100%)
 rename {qa => tests}/test_connlabel.c (96%)
 rename {qa => tests}/test_filter.c (100%)

diff --git a/Makefile.am b/Makefile.am
index baa98ade1a5ec..1a53c1086a508 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -2,7 +2,7 @@ include $(top_srcdir)/Make_global.am
 
 ACLOCAL_AMFLAGS = -I m4
 
-SUBDIRS	= include src utils examples qa
+SUBDIRS	= include src utils examples tests
 
 man_MANS = #nfnetlink_conntrack.3 nfnetlink_conntrack.7
 
diff --git a/qa/.gitignore b/tests/.gitignore
similarity index 100%
rename from qa/.gitignore
rename to tests/.gitignore
diff --git a/qa/Makefile.am b/tests/Makefile.am
similarity index 100%
rename from qa/Makefile.am
rename to tests/Makefile.am
diff --git a/qa/ct_echo_event.c b/tests/ct_echo_event.c
similarity index 100%
rename from qa/ct_echo_event.c
rename to tests/ct_echo_event.c
diff --git a/qa/ct_echo_event.sh b/tests/ct_echo_event.sh
similarity index 100%
rename from qa/ct_echo_event.sh
rename to tests/ct_echo_event.sh
diff --git a/qa/ct_events_reliable.c b/tests/ct_events_reliable.c
similarity index 100%
rename from qa/ct_events_reliable.c
rename to tests/ct_events_reliable.c
diff --git a/qa/ct_mark_filter.c b/tests/ct_mark_filter.c
similarity index 100%
rename from qa/ct_mark_filter.c
rename to tests/ct_mark_filter.c
diff --git a/qa/ct_mark_filter.sh b/tests/ct_mark_filter.sh
similarity index 100%
rename from qa/ct_mark_filter.sh
rename to tests/ct_mark_filter.sh
diff --git a/qa/ct_stress.c b/tests/ct_stress.c
similarity index 100%
rename from qa/ct_stress.c
rename to tests/ct_stress.c
diff --git a/qa/inetd.conf b/tests/inetd.conf
similarity index 100%
rename from qa/inetd.conf
rename to tests/inetd.conf
diff --git a/qa/nssocket.c b/tests/nssocket.c
similarity index 100%
rename from qa/nssocket.c
rename to tests/nssocket.c
diff --git a/qa/nssocket.h b/tests/nssocket.h
similarity index 100%
rename from qa/nssocket.h
rename to tests/nssocket.h
diff --git a/qa/nssocket_env.sh b/tests/nssocket_env.sh
similarity index 100%
rename from qa/nssocket_env.sh
rename to tests/nssocket_env.sh
diff --git a/qa/qa-connlabel.conf b/tests/qa-connlabel.conf
similarity index 100%
rename from qa/qa-connlabel.conf
rename to tests/qa-connlabel.conf
diff --git a/qa/test_api.c b/tests/test_api.c
similarity index 100%
rename from qa/test_api.c
rename to tests/test_api.c
diff --git a/qa/test_connlabel.c b/tests/test_connlabel.c
similarity index 96%
rename from qa/test_connlabel.c
rename to tests/test_connlabel.c
index 345ecf608647b..99b1171857db3 100644
--- a/qa/test_connlabel.c
+++ b/tests/test_connlabel.c
@@ -59,7 +59,7 @@ int main(void)
 
 	l = nfct_labelmap_new("qa-connlabel.conf");
 	if (!l)
-		l = nfct_labelmap_new("qa/qa-connlabel.conf");
+		l = nfct_labelmap_new("tests/qa-connlabel.conf");
 	assert(l);
 	puts("qa-connlabel.conf:");
 	dump_map(l);
diff --git a/qa/test_filter.c b/tests/test_filter.c
similarity index 100%
rename from qa/test_filter.c
rename to tests/test_filter.c
-- 
2.21.0

