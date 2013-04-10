From: Mart Frauenlob <mart.frauenlob@chello.at>
Subject: [PATCH] iptables manpage: Update SNAT target
Date: Wed, 10 Apr 2013 18:31:08 +0200
Message-ID: <516593CC.1010908@chello.at>
Reply-To: mart.frauenlob@chello.at
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------010501040209070503000005"
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from fep32.mx.upcmail.net ([62.179.121.50]:39178 "EHLO
	fep32.mx.upcmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936705Ab3DJQbz (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 10 Apr 2013 12:31:55 -0400
Received: from edge04.upcmail.net ([192.168.13.239])
          by viefep32-int.chello.at
          (InterMail vM.8.01.05.05 201-2260-151-110-20120111) with ESMTP
          id <20130410163153.TLMX12904.viefep32-int.chello.at@edge04.upcmail.net>
          for <netfilter-devel@vger.kernel.org>;
          Wed, 10 Apr 2013 18:31:53 +0200
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multi-part message in MIME format.
--------------010501040209070503000005
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hello,

this patch renames libipt_SNAT.man to libxt_SNAT.man thus informing 
about the IPv6 version.
Also the list of valid protocols for port mapping is updated to:
tcp, udp, dccp and sctp.


Best regards

Mart

--------------010501040209070503000005
Content-Type: text/plain; charset=windows-1252;
 name="manpage-Rename-libipt_SNAT.man-to-libxt_SNAT.man.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="manpage-Rename-libipt_SNAT.man-to-libxt_SNAT.man.patch"

>From 8136feb4b69ac27cb50d8f1db95bf2d03e9ba8a9 Mon Sep 17 00:00:00 2001
From: AllKind <allkind@fastest.cc>
Date: Wed, 10 Apr 2013 16:44:49 +0200
Subject: [PATCH] manpage: Rename libipt_SNAT.man to libxt_SNAT.man.
 Update list of protocols valid for port mapping.

---
 extensions/libipt_SNAT.man |   37 -------------------------------------
 extensions/libxt_SNAT.man  |   34 ++++++++++++++++++++++++++++++++++
 2 files changed, 34 insertions(+), 37 deletions(-)
 delete mode 100644 extensions/libipt_SNAT.man
 create mode 100644 extensions/libxt_SNAT.man

diff --git a/extensions/libipt_SNAT.man b/extensions/libipt_SNAT.man
deleted file mode 100644
index 626b592..0000000
--- a/extensions/libipt_SNAT.man
+++ /dev/null
@@ -1,37 +0,0 @@
-This target is only valid in the
-.B nat
-table, in the
-.B POSTROUTING
-chain.  It specifies that the source address of the packet should be
-modified (and all future packets in this connection will also be
-mangled), and rules should cease being examined.  It takes one type
-of option:
-.TP
-\fB\-\-to\-source\fP [\fIipaddr\fP[\fB\-\fP\fIipaddr\fP]][\fB:\fP\fIport\fP[\fB\-\fP\fIport\fP]]
-which can specify a single new source IP address, an inclusive range
-of IP addresses, and optionally, a port range (which is only valid if
-the rule also specifies
-\fB\-p tcp\fP
-or
-\fB\-p udp\fP).
-If no port range is specified, then source ports below 512 will be
-mapped to other ports below 512: those between 512 and 1023 inclusive
-will be mapped to ports below 1024, and other ports will be mapped to
-1024 or above. Where possible, no port alteration will occur.
-
-In Kernels up to 2.6.10, you can add several \-\-to\-source options. For those
-kernels, if you specify more than one source address, either via an address
-range or multiple \-\-to\-source options, a simple round-robin (one after another
-in cycle) takes place between these addresses.
-Later Kernels (>= 2.6.11-rc1) don't have the ability to NAT to multiple ranges
-anymore.
-.TP
-\fB\-\-random\fP
-If option
-\fB\-\-random\fP
-is used then port mapping will be randomized (kernel >= 2.6.21).
-.TP
-\fB\-\-persistent\fP
-Gives a client the same source-/destination-address for each connection.
-This supersedes the SAME target. Support for persistent mappings is available
-from 2.6.29-rc2.
diff --git a/extensions/libxt_SNAT.man b/extensions/libxt_SNAT.man
new file mode 100644
index 0000000..d1e6f0d
--- /dev/null
+++ b/extensions/libxt_SNAT.man
@@ -0,0 +1,34 @@
+This target is only valid in the
+.B nat
+table, in the
+.B POSTROUTING
+chain.  It specifies that the source address of the packet should be
+modified (and all future packets in this connection will also be
+mangled), and rules should cease being examined.  It takes the
+following options:
+.TP
+\fB\-\-to\-source\fP [\fIipaddr\fP[\fB\-\fP\fIipaddr\fP]][\fB:\fP\fIport\fP[\fB\-\fP\fIport\fP]]
+which can specify a single new source IP address, an inclusive range
+of IP addresses. Optionally a port range,
+if the rule also specifies one of the following protocols:
+\fBtcp\fP, \fBudp\fP, \fBdccp\fP or \fBsctp\fP.
+If no port range is specified, then source ports below 512 will be
+mapped to other ports below 512: those between 512 and 1023 inclusive
+will be mapped to ports below 1024, and other ports will be mapped to
+1024 or above. Where possible, no port alteration will occur.
+In Kernels up to 2.6.10, you can add several \-\-to\-source options. For those
+kernels, if you specify more than one source address, either via an address
+range or multiple \-\-to\-source options, a simple round-robin (one after another
+in cycle) takes place between these addresses.
+Later Kernels (>= 2.6.11-rc1) don't have the ability to NAT to multiple ranges
+anymore.
+.TP
+\fB\-\-random\fP
+If option
+\fB\-\-random\fP
+is used then port mapping will be randomized (kernel >= 2.6.21).
+.TP
+\fB\-\-persistent\fP
+Gives a client the same source-/destination-address for each connection.
+This supersedes the SAME target. Support for persistent mappings is available
+from 2.6.29-rc2.
-- 
1.7.2.5


--------------010501040209070503000005--
