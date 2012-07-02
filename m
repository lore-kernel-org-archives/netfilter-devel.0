From: Florian Westphal <fw@strlen.de>
Subject: [PATCH] libxt_devgroup: add man page snippet
Date: Mon,  2 Jul 2012 23:03:12 +0200
Message-ID: <1341262992-10676-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:47007 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932078Ab2GBVEh (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 2 Jul 2012 17:04:37 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 extensions/libxt_devgroup.man |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)
 create mode 100644 extensions/libxt_devgroup.man

diff --git a/extensions/libxt_devgroup.man b/extensions/libxt_devgroup.man
new file mode 100644
index 0000000..4a66c9f
--- /dev/null
+++ b/extensions/libxt_devgroup.man
@@ -0,0 +1,7 @@
+Match device group of a packets incoming/outgoing interface.
+.TP
+[\fB!\fP] \fB\-\-src\-group\fP \fIname\fP
+Match device group of incoming device
+.TP
+[\fB!\fP] \fB\-\-dst\-group\fP \fIname\fP
+Match device group of outgoing device
-- 
1.7.3.4

