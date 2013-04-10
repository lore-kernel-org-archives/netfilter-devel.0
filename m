From: Mart Frauenlob <mart.frauenlob@chello.at>
Subject: [PATCH] iptables manpage: Update MASQUERADE target
Date: Wed, 10 Apr 2013 18:29:07 +0200
Message-ID: <51659353.6080704@chello.at>
Reply-To: mart.frauenlob@chello.at
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------050409000400050403040404"
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from fep14.mx.upcmail.net ([62.179.121.34]:61999 "EHLO
	fep14.mx.upcmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932992Ab3DJQaA (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 10 Apr 2013 12:30:00 -0400
Received: from edge04.upcmail.net ([192.168.13.239])
          by viefep14-int.chello.at
          (InterMail vM.8.01.05.05 201-2260-151-110-20120111) with ESMTP
          id <20130410162957.WTK1854.viefep14-int.chello.at@edge04.upcmail.net>
          for <netfilter-devel@vger.kernel.org>;
          Wed, 10 Apr 2013 18:29:57 +0200
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multi-part message in MIME format.
--------------050409000400050403040404
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hello,

this patch on the man page unifies the IPv4 and IPv6 entries of the 
MASQUERADE target and updates the list of protocols valid for port mapping.

Though there's no error thrown, if -p is used with --to-ports,
the !portok error message does not talk about icmp,
and I got no definite answer yet, and I don't think it does icmp type 
conversion, I choose to not put the icmp protocol into the list.
Please correct me on that subject, if I'm wrong.

Also please ignore the previous patch for MASQUERADE and REDIRECT.

Best regards

Mart

--------------050409000400050403040404
Content-Type: text/plain; charset=windows-1252;
 name="manpage-Add-libxt_MASQUERADE.man-remove-libipt-and-l.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="manpage-Add-libxt_MASQUERADE.man-remove-libipt-and-l.patch"

>From 8e0f5f1ddbd851c05d711fcdaad12dce1b00c1dc Mon Sep 17 00:00:00 2001
From: AllKind <allkind@fastest.cc>
Date: Wed, 10 Apr 2013 16:53:58 +0200
Subject: [PATCH] manpage: Add libxt_MASQUERADE.man remove libipt and libipt6 version.
 Update list of protocols valid for port mapping.

---
 extensions/libip6t_MASQUERADE.man |   30 ------------------------------
 extensions/libipt_MASQUERADE.man  |   30 ------------------------------
 extensions/libxt_MASQUERADE.man   |   28 ++++++++++++++++++++++++++++
 3 files changed, 28 insertions(+), 60 deletions(-)
 delete mode 100644 extensions/libip6t_MASQUERADE.man
 delete mode 100644 extensions/libipt_MASQUERADE.man
 create mode 100644 extensions/libxt_MASQUERADE.man

diff --git a/extensions/libip6t_MASQUERADE.man b/extensions/libip6t_MASQUERADE.man
deleted file mode 100644
index c63d826..0000000
--- a/extensions/libip6t_MASQUERADE.man
+++ /dev/null
@@ -1,30 +0,0 @@
-This target is only valid in the
-.B nat
-table, in the
-.B POSTROUTING
-chain.  It should only be used with dynamically assigned IPv6 (dialup)
-connections: if you have a static IP address, you should use the SNAT
-target.  Masquerading is equivalent to specifying a mapping to the IP
-address of the interface the packet is going out, but also has the
-effect that connections are
-.I forgotten
-when the interface goes down.  This is the correct behavior when the
-next dialup is unlikely to have the same interface address (and hence
-any established connections are lost anyway).
-.TP
-\fB\-\-to\-ports\fP \fIport\fP[\fB\-\fP\fIport\fP]
-This specifies a range of source ports to use, overriding the default
-.B SNAT
-source port-selection heuristics (see above).  This is only valid
-if the rule also specifies
-\fB\-p tcp\fP
-or
-\fB\-p udp\fP.
-.TP
-\fB\-\-random\fP
-Randomize source port mapping
-If option
-\fB\-\-random\fP
-is used then port mapping will be randomized.
-.RS
-.PP
diff --git a/extensions/libipt_MASQUERADE.man b/extensions/libipt_MASQUERADE.man
deleted file mode 100644
index 2dae964..0000000
--- a/extensions/libipt_MASQUERADE.man
+++ /dev/null
@@ -1,30 +0,0 @@
-This target is only valid in the
-.B nat
-table, in the
-.B POSTROUTING
-chain.  It should only be used with dynamically assigned IP (dialup)
-connections: if you have a static IP address, you should use the SNAT
-target.  Masquerading is equivalent to specifying a mapping to the IP
-address of the interface the packet is going out, but also has the
-effect that connections are
-.I forgotten
-when the interface goes down.  This is the correct behavior when the
-next dialup is unlikely to have the same interface address (and hence
-any established connections are lost anyway).
-.TP
-\fB\-\-to\-ports\fP \fIport\fP[\fB\-\fP\fIport\fP]
-This specifies a range of source ports to use, overriding the default
-.B SNAT
-source port-selection heuristics (see above).  This is only valid
-if the rule also specifies
-\fB\-p tcp\fP
-or
-\fB\-p udp\fP.
-.TP
-\fB\-\-random\fP
-Randomize source port mapping
-If option
-\fB\-\-random\fP
-is used then port mapping will be randomized (kernel >= 2.6.21).
-.RS
-.PP
diff --git a/extensions/libxt_MASQUERADE.man b/extensions/libxt_MASQUERADE.man
new file mode 100644
index 0000000..efcb91b
--- /dev/null
+++ b/extensions/libxt_MASQUERADE.man
@@ -0,0 +1,28 @@
+This target is only valid in the
+.B nat
+table, in the
+.B POSTROUTING
+chain.  It should only be used with dynamically assigned IP (dialup)
+connections: if you have a static IP address, you should use the SNAT
+target.  Masquerading is equivalent to specifying a mapping to the IP
+address of the interface the packet is going out, but also has the
+effect that connections are
+.I forgotten
+when the interface goes down.  This is the correct behavior when the
+next dialup is unlikely to have the same interface address (and hence
+any established connections are lost anyway).
+.TP
+\fB\-\-to\-ports\fP \fIport\fP[\fB\-\fP\fIport\fP]
+This specifies a range of source ports to use, overriding the default
+.B SNAT
+source port-selection heuristics (see above).  This is only valid
+if the rule also specifies one of the following protocols:
+\fBtcp\fP, \fBudp\fP, \fBdccp\fP or \fBsctp\fP.
+.TP
+\fB\-\-random\fP
+Randomize source port mapping
+If option
+\fB\-\-random\fP
+is used then port mapping will be randomized (kernel >= 2.6.21).
+.RS
+.PP
-- 
1.7.2.5


--------------050409000400050403040404--
