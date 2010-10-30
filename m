From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 7/7] Update .gitignore
Date: Sun, 31 Oct 2010 00:08:21 +0200
Message-ID: <1288476502-18721-8-git-send-email-jengelh@medozas.de>
References: <1288476502-18721-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:46361 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751857Ab0J3WJK (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 30 Oct 2010 18:09:10 -0400
In-Reply-To: <1288476502-18721-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

---
 qa/.gitignore    |    2 ++
 utils/.gitignore |   18 ++++++++++++++++++
 2 files changed, 20 insertions(+), 0 deletions(-)
 create mode 100644 qa/.gitignore
 create mode 100644 utils/.gitignore

diff --git a/qa/.gitignore b/qa/.gitignore
new file mode 100644
index 0000000..c6d43bb
--- /dev/null
+++ b/qa/.gitignore
@@ -0,0 +1,2 @@
+/test_api
+/test_filter
diff --git a/utils/.gitignore b/utils/.gitignore
new file mode 100644
index 0000000..7dd7bb8
--- /dev/null
+++ b/utils/.gitignore
@@ -0,0 +1,18 @@
+/conntrack_create
+/conntrack_create_nat
+/conntrack_delete
+/conntrack_dump
+/conntrack_events
+/conntrack_filter
+/conntrack_flush
+/conntrack_get
+/conntrack_grp_create
+/conntrack_master
+/conntrack_update
+/expect_create
+/expect_create_userspace
+/expect_delete
+/expect_dump
+/expect_events
+/expect_flush
+/expect_get
-- 
1.7.1

