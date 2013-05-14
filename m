From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Subject: [libnftables PATCH 2/7] build: add an autogen.sh script
Date: Tue, 14 May 2013 13:51:17 +0300
Message-ID: <1368528682-10041-3-git-send-email-tomasz.bursztyka@linux.intel.com>
References: <519216B6.7060701@linux.intel.com>
 <1368528682-10041-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Cc: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:2739 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753284Ab3ENKvd (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 14 May 2013 06:51:33 -0400
In-Reply-To: <1368528682-10041-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
---
 autogen.sh | 4 ++++
 1 file changed, 4 insertions(+)
 create mode 100755 autogen.sh

diff --git a/autogen.sh b/autogen.sh
new file mode 100755
index 0000000..a0c4395
--- /dev/null
+++ b/autogen.sh
@@ -0,0 +1,4 @@
+#!/bin/sh -e
+
+autoreconf -fi;
+rm -Rf autom4te*.cache;
-- 
1.8.2.1

