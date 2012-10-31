From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Subject: [libnftables - PATCH] build: Add autogen.sh script
Date: Wed, 31 Oct 2012 11:30:50 +0200
Message-ID: <1351675850-14224-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Cc: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:1257 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932293Ab2JaJay (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 31 Oct 2012 05:30:54 -0400
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
1.7.12.4

