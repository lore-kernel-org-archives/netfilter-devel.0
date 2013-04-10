From: Mart Frauenlob <mart.frauenlob@chello.at>
Subject: Re: [PATCH] iptables manpage: Update DNAT target
Date: Wed, 10 Apr 2013 18:47:07 +0200
Message-ID: <5165978B.70800@chello.at>
References: <5165936B.1010609@chello.at>
Reply-To: mart.frauenlob@chello.at
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------080105060805000500000707"
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from fep33.mx.upcmail.net ([62.179.121.51]:34689 "EHLO
	fep33.mx.upcmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965067Ab3DJQry (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 10 Apr 2013 12:47:54 -0400
Received: from edge03.upcmail.net ([192.168.13.238])
          by viefep33-int.chello.at
          (InterMail vM.8.01.05.05 201-2260-151-110-20120111) with ESMTP
          id <20130410164752.ZON20148.viefep33-int.chello.at@edge03.upcmail.net>
          for <netfilter-devel@vger.kernel.org>;
          Wed, 10 Apr 2013 18:47:52 +0200
In-Reply-To: <5165936B.1010609@chello.at>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multi-part message in MIME format.
--------------080105060805000500000707
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit

On 10.04.2013 18:30, netfilter-devel-owner@vger.kernel.org wrote:
> Hello,
>
> this patch renames libipt_DNAT.man to libxt_DNAT.man thus informing
> about the IPv6 version.
> Also the list of valid protocols for port mapping is updated to:
> tcp, udp, dccp and sctp.

I'm very sorry, I messed up the author lines, resending.


--------------080105060805000500000707
Content-Type: text/plain; charset=windows-1252;
 name="manpage-Rename-libipt_DNAT.man-to-libxt_DNAT.man.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="manpage-Rename-libipt_DNAT.man-to-libxt_DNAT.man.patch"

>From 556c825f00023eb900093faaf9d55ba686ae0157 Mon Sep 17 00:00:00 2001
From: Mart Frauenlob <mart.frauenlob@chello.at>
Date: Wed, 10 Apr 2013 16:43:18 +0200
Subject: [PATCH] manpage: Rename libipt_DNAT.man to libxt_DNAT.man.
 Update list of protocols valid for port mapping.

---
 extensions/libipt_DNAT.man |   39 ---------------------------------------
 extensions/libxt_DNAT.man  |   36 ++++++++++++++++++++++++++++++++++++
 2 files changed, 36 insertions(+), 39 deletions(-)
 delete mode 100644 extensions/libipt_DNAT.man
 create mode 100644 extensions/libxt_DNAT.man

diff --git a/extensions/libipt_DNAT.man b/extensions/libipt_DNAT.man
deleted file mode 100644
index d5ded35..0000000
--- a/extensions/libipt_DNAT.man
+++ /dev/null
@@ -1,39 +0,0 @@
-This target is only valid in the
-.B nat
-table, in the
-.B PREROUTING
-and
-.B OUTPUT
-chains, and user-defined chains which are only called from those
-chains.  It specifies that the destination address of the packet
-should be modified (and all future packets in this connection will
-also be mangled), and rules should cease being examined.  It takes one
-type of option:
-.TP
-\fB\-\-to\-destination\fP [\fIipaddr\fP[\fB\-\fP\fIipaddr\fP]][\fB:\fP\fIport\fP[\fB\-\fP\fIport\fP]]
-which can specify a single new destination IP address, an inclusive
-range of IP addresses, and optionally, a port range (which is only
-valid if the rule also specifies
-\fB\-p tcp\fP
-or
-\fB\-p udp\fP).
-If no port range is specified, then the destination port will never be
-modified. If no IP address is specified then only the destination port
-will be modified.
-
-In Kernels up to 2.6.10 you can add several \-\-to\-destination options. For
-those kernels, if you specify more than one destination address, either via an
-address range or multiple \-\-to\-destination options, a simple round-robin (one
-after another in cycle) load balancing takes place between these addresses.
-Later Kernels (>= 2.6.11-rc1) don't have the ability to NAT to multiple ranges
-anymore.
-.TP
-\fB\-\-random\fP
-If option
-\fB\-\-random\fP
-is used then port mapping will be randomized (kernel >= 2.6.22).
-.TP
-\fB\-\-persistent\fP
-Gives a client the same source-/destination-address for each connection.
-This supersedes the SAME target. Support for persistent mappings is available
-from 2.6.29-rc2.
diff --git a/extensions/libxt_DNAT.man b/extensions/libxt_DNAT.man
new file mode 100644
index 0000000..6c35dd9
--- /dev/null
+++ b/extensions/libxt_DNAT.man
@@ -0,0 +1,36 @@
+This target is only valid in the
+.B nat
+table, in the
+.B PREROUTING
+and
+.B OUTPUT
+chains, and user-defined chains which are only called from those
+chains.  It specifies that the destination address of the packet
+should be modified (and all future packets in this connection will
+also be mangled), and rules should cease being examined.  It takes the
+following options:
+.TP
+\fB\-\-to\-destination\fP [\fIipaddr\fP[\fB\-\fP\fIipaddr\fP]][\fB:\fP\fIport\fP[\fB\-\fP\fIport\fP]]
+which can specify a single new destination IP address, an inclusive
+range of IP addresses. Optionally a port range,
+if the rule also specifies one of the following protocols:
+\fBtcp\fP, \fBudp\fP, \fBdccp\fP or \fBsctp\fP.
+If no port range is specified, then the destination port will never be
+modified. If no IP address is specified then only the destination port
+will be modified.
+In Kernels up to 2.6.10 you can add several \-\-to\-destination options. For
+those kernels, if you specify more than one destination address, either via an
+address range or multiple \-\-to\-destination options, a simple round-robin (one
+after another in cycle) load balancing takes place between these addresses.
+Later Kernels (>= 2.6.11-rc1) don't have the ability to NAT to multiple ranges
+anymore.
+.TP
+\fB\-\-random\fP
+If option
+\fB\-\-random\fP
+is used then port mapping will be randomized (kernel >= 2.6.22).
+.TP
+\fB\-\-persistent\fP
+Gives a client the same source-/destination-address for each connection.
+This supersedes the SAME target. Support for persistent mappings is available
+from 2.6.29-rc2.
-- 
1.7.2.5


--------------080105060805000500000707--
