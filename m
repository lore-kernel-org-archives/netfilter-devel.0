From: Mart Frauenlob <mart.frauenlob@chello.at>
Subject: [PATCH] libxt_multiport.man: Update list of valid protocols
Date: Tue, 09 Apr 2013 20:51:53 +0200
Message-ID: <51646349.9090801@chello.at>
Reply-To: mart.frauenlob@chello.at
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------050602010804010601040600"
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from fep12.mx.upcmail.net ([62.179.121.32]:38579 "EHLO
	fep12.mx.upcmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932780Ab3DISwn (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 9 Apr 2013 14:52:43 -0400
Received: from edge04.upcmail.net ([192.168.13.239])
          by viefep12-int.chello.at
          (InterMail vM.8.01.05.05 201-2260-151-110-20120111) with ESMTP
          id <20130409185240.HDRX14414.viefep12-int.chello.at@edge04.upcmail.net>
          for <netfilter-devel@vger.kernel.org>;
          Tue, 9 Apr 2013 20:52:40 +0200
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multi-part message in MIME format.
--------------050602010804010601040600
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hello,

this patch updates the list of valid protocols in the man page section 
of the multiport match to: tcp, udp, udplite, dccp and sctp.

Best regards

Mart


--------------050602010804010601040600
Content-Type: text/plain; charset=windows-1252;
 name="libxt_multiport.man-Update-list-of-valid-protocols.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="libxt_multiport.man-Update-list-of-valid-protocols.patch"

>From 52bfcc21d8e0ff9b87529b9c02ea63ec686c5dda Mon Sep 17 00:00:00 2001
From: Mart Frauenlob <mart.frauenlob@chello.at>
Date: Tue, 9 Apr 2013 20:46:44 +0200
Subject: [PATCH] libxt_multiport.man: Update list of valid protocols.

---
 extensions/libxt_multiport.man |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/extensions/libxt_multiport.man b/extensions/libxt_multiport.man
index caf5c56..7eb083e 100644
--- a/extensions/libxt_multiport.man
+++ b/extensions/libxt_multiport.man
@@ -1,9 +1,8 @@
 This module matches a set of source or destination ports.  Up to 15
 ports can be specified.  A port range (port:port) counts as two
-ports.  It can only be used in conjunction with
-\fB\-p tcp\fP
-or
-\fB\-p udp\fP.
+ports.  It can only be used in conjunction with one of the
+following protocols:
+\fBtcp\fP, \fBudp\fP, \fBudplite\fP, \fBdccp\fP and \fBsctp\fP.
 .TP
 [\fB!\fP] \fB\-\-source\-ports\fP,\fB\-\-sports\fP \fIport\fP[\fB,\fP\fIport\fP|\fB,\fP\fIport\fP\fB:\fP\fIport\fP]...
 Match if the source port is one of the given ports.  The flag
-- 
1.7.2.5


--------------050602010804010601040600--
