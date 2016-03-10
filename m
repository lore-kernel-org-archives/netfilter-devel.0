From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [iptables PATCH 1/2] extensions/libxt_rpfilter.man: fix typo,
 specifiy vs specify
Date: Thu, 10 Mar 2016 11:35:46 +0100
Message-ID: <145760614615.4027.14453402278808172625.stgit@r2d2.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:50078 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932895AbcCJLRc (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 10 Mar 2016 06:17:32 -0500
Received: from localhost (unknown [127.0.0.1])
	by smtp.cica.es (Postfix) with ESMTP id BA9B451F188
	for <netfilter-devel@vger.kernel.org>; Thu, 10 Mar 2016 10:35:51 +0000 (UTC)
Received: from smtp.cica.es ([127.0.0.1])
	by localhost (mail.cica.es [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Gtu3t3NNnl9B for <netfilter-devel@vger.kernel.org>;
	Thu, 10 Mar 2016 11:35:46 +0100 (CET)
Received: from r2d2.cica.es (r2d2.cica.es [IPv6:2a00:9ac0:c1ca:27::150])
	by smtp.cica.es (Postfix) with ESMTP id A745051F16E
	for <netfilter-devel@vger.kernel.org>; Thu, 10 Mar 2016 11:35:46 +0100 (CET)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Reported by Debian lintian tool.

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 extensions/libxt_rpfilter.man |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/extensions/libxt_rpfilter.man b/extensions/libxt_rpfilter.man
index f7f56d2..a3c0fcd 100644
--- a/extensions/libxt_rpfilter.man
+++ b/extensions/libxt_rpfilter.man
@@ -8,7 +8,7 @@ Also, packets arriving via the loopback interface are always permitted.
 This match can only be used in the PREROUTING chain of the raw or mangle table.
 .TP
 \fB\-\-loose\fP
-Used to specifiy that the reverse path filter test should match
+Used to specify that the reverse path filter test should match
 even if the selected output device is not the expected one.
 .TP
 \fB\-\-validmark\fP

