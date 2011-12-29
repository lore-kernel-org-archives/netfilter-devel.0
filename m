From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 4/5] Add examples/.gitignore
Date: Thu, 29 Dec 2011 22:24:49 +0100
Message-ID: <1325193891-20905-5-git-send-email-jengelh@medozas.de>
References: <1325193891-20905-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:59721 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753986Ab1L2VY5 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 29 Dec 2011 16:24:57 -0500
In-Reply-To: <1325193891-20905-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

---
 examples/.gitignore |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)
 create mode 100644 examples/.gitignore

diff --git a/examples/.gitignore b/examples/.gitignore
new file mode 100644
index 0000000..12c9223
--- /dev/null
+++ b/examples/.gitignore
@@ -0,0 +1,3 @@
+/nfacct-add
+/nfacct-del
+/nfacct-get
-- 
1.7.3.4

