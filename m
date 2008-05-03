From: Maximilian Wilhelm <max@rfc2324.org>
Subject: Fix for conntrackd manpage
Date: Sat, 3 May 2008 17:29:41 +0200
Message-ID: <20080503152941.GC22088@outback.rfc2324.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="YZ5djTAD1cGYuMQK"
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from rfc2324.org ([89.149.194.216]:33022 "EHLO rfc2324.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757341AbYECP3m (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 3 May 2008 11:29:42 -0400
Received: from max by rfc2324.org with local rfc2324.org Mailserver
	id 1JsJgD-0007hi-Br
	for <netfilter-devel@vger.kernel.org>; Sat, 03 May 2008 17:29:41 +0200
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--YZ5djTAD1cGYuMQK
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

Hi!

The attached patch fixes a little documentation error in the conntrackd
man page.

Ciao
Max
-- 
	Follow the white penguin.

--YZ5djTAD1cGYuMQK
Content-Type: text/x-diff; charset=utf-8
Content-Disposition: attachment; filename="conntrackd.8.diff"

Index: conntrackd.8
===================================================================
--- conntrackd.8	(revision 7519)
+++ conntrackd.8	(working copy)
@@ -59,7 +59,7 @@
 Dumps the states held in the external cache, i.e. those handled by other replica firewalls
 .TP
 .B conntrackd \-c
-Commits the internal cache into the kernel connection tracking system. This is used to inject the state so that the connections can be recovered during the failover.
+Commits the external cache into the kernel connection tracking system. This is used to inject the state so that the connections can be recovered during the failover.
 .SH DEPENDENCIES
 This daemon requires a Linux kernel version >= 2.6.18. TCP window tracking support requires >= 2.6.22, otherwise you have to disable it. Helpers are fully supported since >= 2.6.25, however, if you use any previous version, depending on the protocol helper and your setup (e.g. if you setup performs NAT sequence adjustments or not), your help connection may be successfully recovered.
 .TP

--YZ5djTAD1cGYuMQK--
