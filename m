From: Jan Engelhardt <jengelh@inai.de>
Subject: [PATCH 4/4] Update .gitignore
Date: Sun, 20 May 2012 00:08:12 +0200
Message-ID: <1337465292-28924-5-git-send-email-jengelh@inai.de>
References: <1337465292-28924-1-git-send-email-jengelh@inai.de>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:38053 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753779Ab2ESWIT (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 19 May 2012 18:08:19 -0400
In-Reply-To: <1337465292-28924-1-git-send-email-jengelh@inai.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Jan Engelhardt <jengelh@medozas.de>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 qa/.gitignore    |    2 ++
 utils/.gitignore |    1 +
 2 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/qa/.gitignore b/qa/.gitignore
index c6d43bb..5e22175 100644
--- a/qa/.gitignore
+++ b/qa/.gitignore
@@ -1,2 +1,4 @@
+/ct_events_reliable
+/ct_stress
 /test_api
 /test_filter
diff --git a/utils/.gitignore b/utils/.gitignore
index 04897ba..63dfcb2 100644
--- a/utils/.gitignore
+++ b/utils/.gitignore
@@ -2,6 +2,7 @@
 /conntrack_create_nat
 /conntrack_delete
 /conntrack_dump
+/conntrack_dump_filter
 /conntrack_events
 /conntrack_filter
 /conntrack_flush
-- 
1.7.7

