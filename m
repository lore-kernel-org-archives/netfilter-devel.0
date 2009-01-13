From: Victor Stinner <vstinner@inl.fr>
Subject: iptables manpage and ICMP type/code
Date: Tue, 13 Jan 2009 15:08:06 +0100
Message-ID: <200901131508.06692.vstinner@inl.fr>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_GBKbJ3gDp76oibK"
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp2-g19.free.fr ([212.27.42.28]:58431 "EHLO smtp2-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755083AbZAMOIJ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 13 Jan 2009 09:08:09 -0500
Received: from smtp2-g19.free.fr (localhost.localdomain [127.0.0.1])
	by smtp2-g19.free.fr (Postfix) with ESMTP id AC9FD12B6DC
	for <netfilter-devel@vger.kernel.org>; Tue, 13 Jan 2009 15:08:07 +0100 (CET)
Received: from marge.local (hachoir.org [88.160.66.91])
	by smtp2-g19.free.fr (Postfix) with ESMTP id 9063A12B6D1
	for <netfilter-devel@vger.kernel.org>; Tue, 13 Jan 2009 15:08:07 +0100 (CET)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

--Boundary-00=_GBKbJ3gDp76oibK
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

iptables supports ICMP code filtering, but it's not documented in the manpage.
Attached patch fixes the manpage, before:

       --icmp-type [!] typename
              This allows specification of the ICMP type, which can be a
              numeric ICMP type, or one of the ICMP type names shown by 
              the command
               iptables -p icmp -h

After:

       --icmp-type [!] type[/code]|typename
              This  allows  specification  of the ICMP type, which can be a
              numeric ICMP type, type and code, or one of the ICMP type names
              shown by the command
               iptables -p icmp -h

It changes also the text style: keywords are underlined.

Note: iptables builtin help was already correct:
---------------------
$ iptables -p icmp -h
(...)
icmp match options:
[!] --icmp-type typename        match icmp type
                                (or numeric type or type/code)
(...)
---------------------

-- 
Victor Stinner
http://www.inl.fr/

--Boundary-00=_GBKbJ3gDp76oibK
Content-Type: text/x-diff;
  charset="utf-8";
  name="icmp_man.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="icmp_man.patch"

diff --git a/extensions/libipt_icmp.man b/extensions/libipt_icmp.man
index 8c1bdbe..0798d7c 100644
--- a/extensions/libipt_icmp.man
+++ b/extensions/libipt_icmp.man
@@ -1,9 +1,14 @@
 This extension can be used if `\-\-protocol icmp' is specified. It
 provides the following option:
 .TP
-[\fB!\fP] \fB\-\-icmp\-type\fP \fItypename\fP
+\fB\-\-icmp\-type\fP [\fB!\fP] \fItype\fP[\fB/\fP\fIcode\fP]|\fItypename\fP
 This allows specification of the ICMP type, which can be a numeric
-ICMP type, or one of the ICMP type names shown by the command
+ICMP
+.IR type ,
+.IR type
+and
+.IR code ,
+or one of the ICMP type names shown by the command
 .nf
  iptables \-p icmp \-h
 .fi

--Boundary-00=_GBKbJ3gDp76oibK--
