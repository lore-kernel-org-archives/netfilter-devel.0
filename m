From: Mart Frauenlob <mart.frauenlob@chello.at>
Subject: Re: [PATCH] iptables manpage: Update REDIRECT target
Date: Wed, 10 Apr 2013 18:48:49 +0200
Message-ID: <516597F1.80707@chello.at>
References: <516593A2.8040308@chello.at>
Reply-To: mart.frauenlob@chello.at
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------040608070203070902030308"
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from fep17.mx.upcmail.net ([62.179.121.37]:34823 "EHLO
	fep17.mx.upcmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964833Ab3DJRQE (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 10 Apr 2013 13:16:04 -0400
Received: from edge01.upcmail.net ([192.168.13.236])
          by viefep17-int.chello.at
          (InterMail vM.8.01.05.05 201-2260-151-110-20120111) with ESMTP
          id <20130410164935.KYDW11712.viefep17-int.chello.at@edge01.upcmail.net>
          for <netfilter-devel@vger.kernel.org>;
          Wed, 10 Apr 2013 18:49:35 +0200
In-Reply-To: <516593A2.8040308@chello.at>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multi-part message in MIME format.
--------------040608070203070902030308
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit

On 10.04.2013 18:31, netfilter-devel-owner@vger.kernel.org wrote:
> Hello,
>
> this patch renames libipt_REDIRECT.man to libxt_REDIRECT.man thus
> informing about the IPv6 version.
> Also the list of valid protocols for port mapping is updated to:
> tcp, udp, dccp and sctp.
>
> I hope the address provided for IPv6 localhost ::1 is correct?

I'm very sorry, I messed up the author lines, resending.


--------------040608070203070902030308
Content-Type: text/plain; charset=windows-1252;
 name="manpage-Rename-libipt_REDIRECT.man-to-libxt_REDIRECT.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="manpage-Rename-libipt_REDIRECT.man-to-libxt_REDIRECT.patch"

>From 2032b842833bd4737e6bd1317ea8fa386d2e3fca Mon Sep 17 00:00:00 2001
From: Mart Frauenlob <mart.frauenlob@chello.at>
Date: Wed, 10 Apr 2013 16:58:26 +0200
Subject: [PATCH] manpage: Rename libipt_REDIRECT.man to libxt_REDIRECT.man.
 Update list of protocols valid for port mapping.

---
 extensions/libipt_REDIRECT.man |   25 -------------------------
 extensions/libxt_REDIRECT.man  |   23 +++++++++++++++++++++++
 2 files changed, 23 insertions(+), 25 deletions(-)
 delete mode 100644 extensions/libipt_REDIRECT.man
 create mode 100644 extensions/libxt_REDIRECT.man

diff --git a/extensions/libipt_REDIRECT.man b/extensions/libipt_REDIRECT.man
deleted file mode 100644
index 90ab19d..0000000
--- a/extensions/libipt_REDIRECT.man
+++ /dev/null
@@ -1,25 +0,0 @@
-This target is only valid in the
-.B nat
-table, in the
-.B PREROUTING
-and
-.B OUTPUT
-chains, and user-defined chains which are only called from those
-chains.  It redirects the packet to the machine itself by changing the
-destination IP to the primary address of the incoming interface
-(locally-generated packets are mapped to the 127.0.0.1 address).
-.TP
-\fB\-\-to\-ports\fP \fIport\fP[\fB\-\fP\fIport\fP]
-This specifies a destination port or range of ports to use: without
-this, the destination port is never altered.  This is only valid
-if the rule also specifies
-\fB\-p tcp\fP
-or
-\fB\-p udp\fP.
-.TP
-\fB\-\-random\fP
-If option
-\fB\-\-random\fP
-is used then port mapping will be randomized (kernel >= 2.6.22).
-.RS
-.PP
diff --git a/extensions/libxt_REDIRECT.man b/extensions/libxt_REDIRECT.man
new file mode 100644
index 0000000..7f7de5d
--- /dev/null
+++ b/extensions/libxt_REDIRECT.man
@@ -0,0 +1,23 @@
+This target is only valid in the
+.B nat
+table, in the
+.B PREROUTING
+and
+.B OUTPUT
+chains, and user-defined chains which are only called from those
+chains.  It redirects the packet to the machine itself by changing the
+destination IP to the primary address of the incoming interface
+(locally-generated packets are mapped to the localhost address,
+127.0.0.1 for IPv4 and ::1 for IPv6).
+.TP
+\fB\-\-to\-ports\fP \fIport\fP[\fB\-\fP\fIport\fP]
+This specifies a destination port or range of ports to use: without
+this, the destination port is never altered.  This is only valid
+if the rule also specifies one of the following protocols:
+\fBtcp\fP, \fBudp\fP, \fBdccp\fP or \fBsctp\fP.
+.TP
+\fB\-\-random\fP
+If option
+\fB\-\-random\fP
+is used then port mapping will be randomized (kernel >= 2.6.22).
+.RS
+.PP
-- 
1.7.2.5


--------------040608070203070902030308--
