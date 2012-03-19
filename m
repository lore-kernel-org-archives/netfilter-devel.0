From: Adrian Bridgett <adrian@smop.co.uk>
Subject: manpage fixes for conntrack-tools
Date: Mon, 19 Mar 2012 23:54:14 +0000
Message-ID: <4F67C726.9090305@smop.co.uk>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------040100070601060400020304"
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bitcube.co.uk ([109.74.192.214]:43290 "EHLO mail.bitcube.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756138Ab2CTABZ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 19 Mar 2012 20:01:25 -0400
Received: from localhost (localhost [127.0.0.1])
	by mail.bitcube.co.uk (Postfix) with ESMTP id 672F4BFEE
	for <netfilter-devel@vger.kernel.org>; Mon, 19 Mar 2012 23:54:29 +0000 (GMT)
Received: from mail.bitcube.co.uk ([127.0.0.1])
	by localhost (lemon.bitcube.co.uk [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id NZA0zTBA3pgi for <netfilter-devel@vger.kernel.org>;
	Mon, 19 Mar 2012 23:54:25 +0000 (GMT)
Received: from [192.168.0.4] (5ac6753c.bb.sky.com [90.198.117.60])
	by mail.bitcube.co.uk (Postfix) with ESMTPSA
	for <netfilter-devel@vger.kernel.org>; Mon, 19 Mar 2012 23:54:23 +0000 (GMT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multi-part message in MIME format.
--------------040100070601060400020304
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

I see that the netfilter-failover list is closed, hence the post here 
(I'll also send it the Ubuntu maintainer).

Just a few fixes to sync the manpages and binaries with each other 
(there are some key commands missing otherwise).

Thanks,

Adrian

--------------040100070601060400020304
Content-Type: text/x-patch;
 name="conntrack-tools.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="conntrack-tools.diff"

diff -Naur conntrack-tools-1.0.0.orig/conntrack.8 conntrack-tools-1.0.0/conntrack.8
--- conntrack-tools-1.0.0.orig/conntrack.8	2011-02-17 16:42:52.000000000 +0000
+++ conntrack-tools-1.0.0/conntrack.8	2012-03-19 23:43:38.869954690 +0000
@@ -6,17 +6,17 @@
 .SH NAME
 conntrack \- command line interface for netfilter connection tracking
 .SH SYNOPSIS
-.BR "conntrack -L [table] [-z]"
+.BR "conntrack -L [table] [options] [-z]"
 .br
 .BR "conntrack -G [table] parameters"
 .br
-.BR "conntrack -D [table] paramaters"
+.BR "conntrack -D [table] parameters"
 .br
 .BR "conntrack -I [table] parameters"
 .br
 .BR "conntrack -U [table] parameters"
 .br
-.BR "conntrack -E [table] parameters"
+.BR "conntrack -E [table] [options]"
 .br
 .BR "conntrack -F [table]"
 .br
diff -Naur conntrack-tools-1.0.0.orig/conntrackd.8 conntrack-tools-1.0.0/conntrackd.8
--- conntrack-tools-1.0.0.orig/conntrackd.8	2009-12-23 23:22:43.000000000 +0000
+++ conntrack-tools-1.0.0/conntrackd.8	2012-03-19 23:48:43.948131196 +0000
@@ -41,10 +41,16 @@
 Flush the kernel conntrack table (if you use a Linux kernel >= 2.6.29, this
 option will not flush your internal and external cache).
 .TP
+.BI "-c "
+Commit external cache to conntrack table.
+.TP
 .BI "-B "
 Force a bulk send to other replica firewalls. With this command, you will
 ask conntrackd to send the state-entries that it owns to others.
 .TP
+.BI "-n "
+Request resync with other node (only FT-FW and NOTRACK modes).
+.TP
 .BI "-k "
 Kill the daemon
 .TP
@@ -67,6 +73,10 @@
 .TP
 .BI "-h "
 Display help information.
+.TP
+.BI "-C config file"
+Configuration file path.
+.TP
 .SH DIAGNOSTICS
 The exit code is 0 for correct function. Errors cause an exit code of 1.
 .SH EXAMPLES
diff -Naur conntrack-tools-1.0.0.orig/src/main.c conntrack-tools-1.0.0/src/main.c
--- conntrack-tools-1.0.0.orig/src/main.c	2009-07-21 13:18:37.000000000 +0100
+++ conntrack-tools-1.0.0/src/main.c	2012-03-19 23:50:22.934104850 +0000
@@ -47,6 +47,7 @@
 	"  -s  [|network|cache|runtime|link|rsqueue|queue], dump statistics\n"
 	"  -R, resync with kernel conntrack table\n"
 	"  -n, request resync with other node (only FT-FW and NOTRACK modes)\n"
+	"  -B, force a bulk send to other replica firewalls\n"
 	"  -x, dump cache in XML format (requires -i or -e)\n"
 	"  -t, reset the kernel timeout (see PurgeTimeout clause)\n"
 	"  -v, display conntrackd version\n"

--------------040100070601060400020304--
