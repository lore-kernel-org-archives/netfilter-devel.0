From: Ana Rey <anarey@gmail.com>
Subject: [PATCH] libxt_devgroup: manpage corrections
Date: Mon, 15 Sep 2014 14:35:19 +0200
Message-ID: <1410784519-28428-1-git-send-email-anarey@gmail.com>
Cc: Ana Rey <anarey@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-we0-f177.google.com ([74.125.82.177]:38033 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750920AbaIOMc7 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 15 Sep 2014 08:32:59 -0400
Received: by mail-we0-f177.google.com with SMTP id u57so3863205wes.8
        for <netfilter-devel@vger.kernel.org>; Mon, 15 Sep 2014 05:32:51 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This corrects several errors in the devgroup match.

Signed-off-by: Ana Rey <anarey@gmail.com>
---
 extensions/libxt_devgroup.man |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/extensions/libxt_devgroup.man b/extensions/libxt_devgroup.man
index 4a66c9f..7696f28 100644
--- a/extensions/libxt_devgroup.man
+++ b/extensions/libxt_devgroup.man
@@ -1,7 +1,7 @@
 Match device group of a packets incoming/outgoing interface.
 .TP
-[\fB!\fP] \fB\-\-src\-group\fP \fIname\fP
+[\fB!\fP] \fB\-\-src\-group\fP \fIvalue[/mask]\fP
 Match device group of incoming device
 .TP
-[\fB!\fP] \fB\-\-dst\-group\fP \fIname\fP
+[\fB!\fP] \fB\-\-dst\-group\fP \fIvalue[/mask]\fP
 Match device group of outgoing device
-- 
1.7.10.4

