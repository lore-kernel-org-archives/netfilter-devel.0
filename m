From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: [PATCH 22/24] Fix broken markup in manpages
Date: Tue, 4 Mar 2008 17:21:12 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0803041721030.7660@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0803040519150.7660@fbirervta.pbzchgretzou.qr>
 <47CD6296.90303@trash.net> <Pine.LNX.4.64.0803041630440.7660@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:35291 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762299AbYCDQVN (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 4 Mar 2008 11:21:13 -0500
In-Reply-To: <Pine.LNX.4.64.0803041630440.7660@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

commit 138304554be256872d3b68a70720635a353475e6
Author: Jan Engelhardt <jengelh@computergmbh.de>
Date:   Fri Feb 29 01:05:25 2008 +0100

    Fix broken markup in manpages
---
 extensions/libip6t_ah.man    |    2 +-
 extensions/libip6t_dst.man   |    2 +-
 extensions/libxt_NFQUEUE.man |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/extensions/libip6t_ah.man b/extensions/libip6t_ah.man
index 09d00fd..807f9e3 100644
--- a/extensions/libip6t_ah.man
+++ b/extensions/libip6t_ah.man
@@ -3,7 +3,7 @@ This module matches the parameters in Authentication header of IPsec packets.
 .BR "--ahspi " "[!] \fIspi\fP[:\fIspi\fP]"
 Matches SPI.
 .TP
-.BR "--ahlen " "[!] \fIlength"
+[\fB!\fP] \fB--ahlen\fP \fIlength\fP
 Total length of this header in octets.
 .TP
 .BI "--ahres"
diff --git a/extensions/libip6t_dst.man b/extensions/libip6t_dst.man
index f42d822..d895a0e 100644
--- a/extensions/libip6t_dst.man
+++ b/extensions/libip6t_dst.man
@@ -1,6 +1,6 @@
 This module matches the parameters in Destination Options header
 .TP
-.BR "--dst-len " "[!] \fIlength"
+[\fB!\fP] \fB--dst-len\fP \fIlength\fP
 Total length of this header in octets.
 .TP
 .BR "--dst-opts " "\fItype\fP[:\fIlength\fP][,\fItype\fP[:\fIlength\fP]...]"
diff --git a/extensions/libxt_NFQUEUE.man b/extensions/libxt_NFQUEUE.man
index 090a136..acd45e9 100644
--- a/extensions/libxt_NFQUEUE.man
+++ b/extensions/libxt_NFQUEUE.man
@@ -2,7 +2,7 @@ This target is an extension of the QUEUE target. As opposed to QUEUE, it allows
 you to put a packet into any specific queue, identified by its 16-bit queue
 number.  
 .TP
-.BR "--queue-num " "\fIvalue"
+\fB--queue-num\fP \fIvalue\fP
 This specifies the QUEUE number to use. Valid queue numbers are 0 to 65535. The default value is 0.
 .TP
 It can only be used with Kernel versions 2.6.14 or later, since it requires
