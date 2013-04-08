From: Mart Frauenlob <mart.frauenlob@chello.at>
Subject: [PATCH] iptables manpage: Update protocol list for MASQUERADE and
 REDIRECT
Date: Mon, 08 Apr 2013 13:30:30 +0200
Message-ID: <5162AA56.70008@chello.at>
Reply-To: mart.frauenlob@chello.at
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------090109020602010106070600"
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from fep23.mx.upcmail.net ([62.179.121.43]:38841 "EHLO
	fep23.mx.upcmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934906Ab3DHLbR (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 8 Apr 2013 07:31:17 -0400
Received: from edge02.upcmail.net ([192.168.13.237])
          by viefep23-int.chello.at
          (InterMail vM.8.01.05.05 201-2260-151-110-20120111) with ESMTP
          id <20130408113115.MWDV17478.viefep23-int.chello.at@edge02.upcmail.net>
          for <netfilter-devel@vger.kernel.org>;
          Mon, 8 Apr 2013 13:31:15 +0200
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multi-part message in MIME format.
--------------090109020602010106070600
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hello,

this patch updates the list of protocols valid for the --to-ports option 
of the MASQUERADE and REDIRECT targets.

If I read the source correctly (no C programmer), icmp is also valid.
In that case the error message for !portok is missing icmp.

What does one specify, what is mapped with --to-ports and -p icmp?

Best regards

Mart

P.S. Is it ok to base on master, or should I use stable/next?

--------------090109020602010106070600
Content-Type: text/plain; charset=windows-1252;
 name="manpage-Update-protocol-list-for-MASQUERADE-and-REDIRECT.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="manpage-Update-protocol-list-for-MASQUERADE-and-REDIRECT.pat";
 filename*1="ch"

>From 8e78fab467dbca6d1e27218cc4db091545a49027 Mon Sep 17 00:00:00 2001
From: Mart Frauenlob <mart.frauenlob@chello.at>
Date: Mon, 8 Apr 2013 13:11:49 +0200
Subject: [PATCH] manpage: Update protocol list for MASQUERADE and REDIRET.

---
 extensions/libip6t_MASQUERADE.man |    6 +++---
 extensions/libipt_MASQUERADE.man  |    6 +++---
 extensions/libipt_REDIRECT.man    |    6 +++---
 3 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/extensions/libip6t_MASQUERADE.man b/extensions/libip6t_MASQUERADE.man
index c63d826..b5b7677 100644
--- a/extensions/libip6t_MASQUERADE.man
+++ b/extensions/libip6t_MASQUERADE.man
@@ -16,10 +16,10 @@ any established connections are lost anyway).
 This specifies a range of source ports to use, overriding the default
 .B SNAT
 source port-selection heuristics (see above).  This is only valid
-if the rule also specifies
-\fB\-p tcp\fP
+if the rule also specifies one of the following protocols:
+.B tcp, udp, dccp, sctp
 or
-\fB\-p udp\fP.
+.B icmp.
 .TP
 \fB\-\-random\fP
 Randomize source port mapping
diff --git a/extensions/libipt_MASQUERADE.man b/extensions/libipt_MASQUERADE.man
index 2dae964..807ddbd 100644
--- a/extensions/libipt_MASQUERADE.man
+++ b/extensions/libipt_MASQUERADE.man
@@ -16,10 +16,10 @@ any established connections are lost anyway).
 This specifies a range of source ports to use, overriding the default
 .B SNAT
 source port-selection heuristics (see above).  This is only valid
-if the rule also specifies
-\fB\-p tcp\fP
+if the rule also specifies one of the following protocols:
+.B tcp, udp, dccp, sctp
 or
-\fB\-p udp\fP.
+.B icmp.
 .TP
 \fB\-\-random\fP
 Randomize source port mapping
diff --git a/extensions/libipt_REDIRECT.man b/extensions/libipt_REDIRECT.man
index 90ab19d..635ddd4 100644
--- a/extensions/libipt_REDIRECT.man
+++ b/extensions/libipt_REDIRECT.man
@@ -12,10 +12,10 @@ destination IP to the primary address of the incoming interface
 \fB\-\-to\-ports\fP \fIport\fP[\fB\-\fP\fIport\fP]
 This specifies a destination port or range of ports to use: without
 this, the destination port is never altered.  This is only valid
-if the rule also specifies
-\fB\-p tcp\fP
+if the rule also specifies one of the following protocols:
+.B tcp, udp, dccp, sctp
 or
-\fB\-p udp\fP.
+.B icmp.
 .TP
 \fB\-\-random\fP
 If option
-- 
1.7.2.5


--------------090109020602010106070600--
