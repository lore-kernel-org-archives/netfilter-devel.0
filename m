From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [conntrack-tools PATCH] nfct.8: reword some sentences
Date: Thu, 20 Aug 2015 13:36:38 +0200
Message-ID: <20150820113638.31943.11731.stgit@nfdev2.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:60132 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751406AbbHTMsE (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 20 Aug 2015 08:48:04 -0400
Received: from localhost (unknown [127.0.0.1])
	by smtp.cica.es (Postfix) with ESMTP id 1048751F1CE
	for <netfilter-devel@vger.kernel.org>; Thu, 20 Aug 2015 11:36:44 +0000 (UTC)
Received: from smtp.cica.es ([127.0.0.1])
	by localhost (mail.cica.es [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id dLjRqanehGhL for <netfilter-devel@vger.kernel.org>;
	Thu, 20 Aug 2015 13:36:39 +0200 (CEST)
Received: from nfdev2.cica.es (unknown [IPv6:2a00:9ac0:c1ca:31:5054:ff:fe87:6a8a])
	by smtp.cica.es (Postfix) with ESMTP id 0FF1951F0CE
	for <netfilter-devel@vger.kernel.org>; Thu, 20 Aug 2015 13:36:38 +0200 (CEST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

There are some sentences that sound bit weird. Let's fix that.

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 nfct.8 |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/nfct.8 b/nfct.8
index 6f5190a..1a6f99b 100644
--- a/nfct.8
+++ b/nfct.8
@@ -1,4 +1,4 @@
-.TH NFCT 8 "Feb 29, 2012" "" ""
+.TH NFCT 8 "Aug 20, 2015" "" ""
 
 .\" Man page written by Pablo Neira Ayuso <pablo@netfilter.org> (Feb 2012)
 
@@ -8,9 +8,9 @@ nfct \- command line tool to interact with the connection tracking system
 .BR "nfct subsystem command [parameters]"
 .SH DESCRIPTION
 .B nfct
-is the command line tool that allows you Netfilter's manipulate Connection Tracking System.
+is the command line tool that allows you to manipulate Netfilter's Connection Tracking System.
 .SH SUBSYS
-By the time this manpage has been written, the supported subsystem are
+By the time this manpage has been written, the supported subsystem is
 .B timeout
 .TP
 .BI "timeout "

