From: Mart Frauenlob <mart.frauenlob@chello.at>
Subject: Re: [PATCH] iptables manpage: Update LOG target
Date: Wed, 10 Apr 2013 18:47:32 +0200
Message-ID: <516597A4.4090606@chello.at>
References: <5165937E.4060302@chello.at>
Reply-To: mart.frauenlob@chello.at
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------080902030206080007030108"
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from fep14.mx.upcmail.net ([62.179.121.34]:57600 "EHLO
	fep14.mx.upcmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936102Ab3DJQsT (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 10 Apr 2013 12:48:19 -0400
Received: from edge03.upcmail.net ([192.168.13.238])
          by viefep14-int.chello.at
          (InterMail vM.8.01.05.05 201-2260-151-110-20120111) with ESMTP
          id <20130410164817.CASE1854.viefep14-int.chello.at@edge03.upcmail.net>
          for <netfilter-devel@vger.kernel.org>;
          Wed, 10 Apr 2013 18:48:17 +0200
In-Reply-To: <5165937E.4060302@chello.at>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multi-part message in MIME format.
--------------080902030206080007030108
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit

On 10.04.2013 18:30, netfilter-devel-owner@vger.kernel.org wrote:
> Hello,
>
> this patch on the man page unifies the IPv4 and IPv6 entries of the LOG
> target.

I'm very sorry, I messed up the author lines, resending.


--------------080902030206080007030108
Content-Type: text/plain; charset=windows-1252;
 name="manpage-Rename-libipt_LOG.man-to-libxt_LOG.man.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="manpage-Rename-libipt_LOG.man-to-libxt_LOG.man.patch"

>From e1127e6875136ae9f0c8a721c5868b649e249c3b Mon Sep 17 00:00:00 2001
From: Mart Frauenlob <mart.frauenlob@chello.at>
Date: Wed, 10 Apr 2013 16:32:54 +0200
Subject: [PATCH] manpage: Rename libipt_LOG.man to libxt_LOG.man.

---
 extensions/libip6t_LOG.man |   34 ----------------------------------
 extensions/libipt_LOG.man  |   34 ----------------------------------
 extensions/libxt_LOG.man   |   34 ++++++++++++++++++++++++++++++++++
 3 files changed, 34 insertions(+), 68 deletions(-)
 delete mode 100644 extensions/libip6t_LOG.man
 delete mode 100644 extensions/libipt_LOG.man
 create mode 100644 extensions/libxt_LOG.man

diff --git a/extensions/libip6t_LOG.man b/extensions/libip6t_LOG.man
deleted file mode 100644
index 0a48640..0000000
--- a/extensions/libip6t_LOG.man
+++ /dev/null
@@ -1,34 +0,0 @@
-Turn on kernel logging of matching packets.  When this option is set
-for a rule, the Linux kernel will print some information on all
-matching packets (like most IPv6 IPv6-header fields) via the kernel log
-(where it can be read with
-.I dmesg
-or 
-.IR syslogd (8)).
-This is a "non-terminating target", i.e. rule traversal continues at
-the next rule.  So if you want to LOG the packets you refuse, use two
-separate rules with the same matching criteria, first using target LOG
-then DROP (or REJECT).
-.TP
-\fB\-\-log\-level\fP \fIlevel\fP
-Level of logging, which can be (system-specific) numeric or a mnemonic.
-Possible values are (in decreasing order of priority): \fBemerg\fP,
-\fBalert\fP, \fBcrit\fP, \fBerror\fP, \fBwarning\fP, \fBnotice\fP, \fBinfo\fP
-or \fBdebug\fP.
-.TP
-\fB\-\-log\-prefix\fP \fIprefix\fP
-Prefix log messages with the specified prefix; up to 29 letters long,
-and useful for distinguishing messages in the logs.
-.TP
-\fB\-\-log\-tcp\-sequence\fP
-Log TCP sequence numbers. This is a security risk if the log is
-readable by users.
-.TP
-\fB\-\-log\-tcp\-options\fP
-Log options from the TCP packet header.
-.TP
-\fB\-\-log\-ip\-options\fP
-Log options from the IPv6 packet header.
-.TP
-\fB\-\-log\-uid\fP
-Log the userid of the process which generated the packet.
diff --git a/extensions/libipt_LOG.man b/extensions/libipt_LOG.man
deleted file mode 100644
index f2574f8..0000000
--- a/extensions/libipt_LOG.man
+++ /dev/null
@@ -1,34 +0,0 @@
-Turn on kernel logging of matching packets.  When this option is set
-for a rule, the Linux kernel will print some information on all
-matching packets (like most IP header fields) via the kernel log
-(where it can be read with
-.I dmesg
-or 
-.IR syslogd (8)).
-This is a "non-terminating target", i.e. rule traversal continues at
-the next rule.  So if you want to LOG the packets you refuse, use two
-separate rules with the same matching criteria, first using target LOG
-then DROP (or REJECT).
-.TP
-\fB\-\-log\-level\fP \fIlevel\fP
-Level of logging, which can be (system-specific) numeric or a mnemonic.
-Possible values are (in decreasing order of priority): \fBemerg\fP,
-\fBalert\fP, \fBcrit\fP, \fBerror\fP, \fBwarning\fP, \fBnotice\fP, \fBinfo\fP
-or \fBdebug\fP.
-.TP
-\fB\-\-log\-prefix\fP \fIprefix\fP
-Prefix log messages with the specified prefix; up to 29 letters long,
-and useful for distinguishing messages in the logs.
-.TP
-\fB\-\-log\-tcp\-sequence\fP
-Log TCP sequence numbers. This is a security risk if the log is
-readable by users.
-.TP
-\fB\-\-log\-tcp\-options\fP
-Log options from the TCP packet header.
-.TP
-\fB\-\-log\-ip\-options\fP
-Log options from the IP packet header.
-.TP
-\fB\-\-log\-uid\fP
-Log the userid of the process which generated the packet.
diff --git a/extensions/libxt_LOG.man b/extensions/libxt_LOG.man
new file mode 100644
index 0000000..f2574f8
--- /dev/null
+++ b/extensions/libxt_LOG.man
@@ -0,0 +1,34 @@
+Turn on kernel logging of matching packets.  When this option is set
+for a rule, the Linux kernel will print some information on all
+matching packets (like most IP header fields) via the kernel log
+(where it can be read with
+.I dmesg
+or 
+.IR syslogd (8)).
+This is a "non-terminating target", i.e. rule traversal continues at
+the next rule.  So if you want to LOG the packets you refuse, use two
+separate rules with the same matching criteria, first using target LOG
+then DROP (or REJECT).
+.TP
+\fB\-\-log\-level\fP \fIlevel\fP
+Level of logging, which can be (system-specific) numeric or a mnemonic.
+Possible values are (in decreasing order of priority): \fBemerg\fP,
+\fBalert\fP, \fBcrit\fP, \fBerror\fP, \fBwarning\fP, \fBnotice\fP, \fBinfo\fP
+or \fBdebug\fP.
+.TP
+\fB\-\-log\-prefix\fP \fIprefix\fP
+Prefix log messages with the specified prefix; up to 29 letters long,
+and useful for distinguishing messages in the logs.
+.TP
+\fB\-\-log\-tcp\-sequence\fP
+Log TCP sequence numbers. This is a security risk if the log is
+readable by users.
+.TP
+\fB\-\-log\-tcp\-options\fP
+Log options from the TCP packet header.
+.TP
+\fB\-\-log\-ip\-options\fP
+Log options from the IP packet header.
+.TP
+\fB\-\-log\-uid\fP
+Log the userid of the process which generated the packet.
-- 
1.7.2.5


--------------080902030206080007030108--
