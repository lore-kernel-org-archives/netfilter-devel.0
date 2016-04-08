From: Mart Frauenlob <mart.frauenlob@chello.at>
Subject: [PATCH 4/4] nfct: man: add missing comands
Date: Fri,  8 Apr 2016 08:18:44 +0200
Message-ID: <1460096324-17426-5-git-send-email-mart.frauenlob@chello.at>
References: <1460096324-17426-1-git-send-email-mart.frauenlob@chello.at>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from vie01a-dmta-at03-2.mx.upcmail.net ([62.179.121.152]:15000 "EHLO
	vie01a-dmta-at03-2.mx.upcmail.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752274AbcDHGS4 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 8 Apr 2016 02:18:56 -0400
Received: from [172.31.216.43] (helo=vie01a-pemc-psmtp-pe01)
	by vie01a-dmta-at03.mx.upcmail.net with esmtp (Exim 4.72)
	(envelope-from <mart.frauenlob@chello.at>)
	id 1aoPks-0004R3-6o
	for netfilter-devel@vger.kernel.org; Fri, 08 Apr 2016 08:18:54 +0200
In-Reply-To: <1460096324-17426-1-git-send-email-mart.frauenlob@chello.at>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The missing commands: flush, disable, default-set and default-get
were added to the manpage.
The description of the subsystem has been corrected.

Signed-off-by: Mart Frauenlob <mart.frauenlob@chello.at>
---
 nfct.8 |   16 +++++++++++++++-
 1 files changed, 15 insertions(+), 1 deletions(-)

diff --git a/nfct.8 b/nfct.8
index 336d9cd..c38bdbe 100644
--- a/nfct.8
+++ b/nfct.8
@@ -23,9 +23,23 @@ Delete an object.
 .TP
 .BI "get "
 Get an existing object.
+.TP
+.BI "flush "
+Flush the accounting object table.
+.TP
+.BI "disable "
+This command is for the helper subsystem. It allows you to disable enqueueing packets to userspace for helper inspection.
+.TP
+.BI "default-set "
+This command is for the timeout subsystem. It allows you to set default protocol timeouts.
+.TP
+.BI "default-get "
+This command is for the timeout subsystem. It allows you to get the default protocol timeouts.
 .SH SUBSYS
-By the time this manpage has been written, the supported subsystem are
+By the time this manpage has been written, the supported subsystems are
 .B timeout
+and
+.B helper.
 .TP
 .BI "timeout "
 The timeout subsystem allows you to define fine-grain timeout policies.
-- 
1.7.2.5

