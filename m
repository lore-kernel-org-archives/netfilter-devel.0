From: Naohiro Ooiwa <nooiwa@miraclelinux.com>
Subject: [PATCH] Fix define value of SCTP chunk type.
Date: Fri, 29 Feb 2008 19:02:15 +0900
Message-ID: <47C7D827.6030603@miraclelinux.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------000903080205090104090408"
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ns.miraclelinux.com ([219.118.163.66]:34032 "EHLO
	mail.miraclelinux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754219AbYB2KCQ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 29 Feb 2008 05:02:16 -0500
Received: from mail.miraclelinux.com (mail.miraclelinux.com [127.0.0.1])
	by localhost (Postfix) with SMTP id 8E0737238A
	for <netfilter-devel@vger.kernel.org>; Fri, 29 Feb 2008 19:02:15 +0900 (JST)
Received: from dhcp-0161.miraclelinux.com (dhcp-0161.miraclelinux.com [10.1.0.161])
	by mail.miraclelinux.com (Postfix) with ESMTP id 7CEC372317
	for <netfilter-devel@vger.kernel.org>; Fri, 29 Feb 2008 19:02:15 +0900 (JST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multi-part message in MIME format.
--------------000903080205090104090408
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit

Hi,

This is a trivial fix.
There are wrong chunk_type values in sctp table.
The chunk_type of ASCONF and ASCNF_ACK must be 193 and 128, respectively.

Please check it.

Regards,
Naohiro


--------------000903080205090104090408
Content-Type: text/x-patch;
 name="fix_define_value_of_sctp_chunk_type.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="fix_define_value_of_sctp_chunk_type.patch"

--- iptables--20080227/extensions/libxt_sctp.c.orig	2008-01-29 22:48:05.000000000 +0900
+++ iptables--20080227/extensions/libxt_sctp.c	2008-02-29 14:43:39.000000000 +0900
@@ -125,8 +125,8 @@ static const struct sctp_chunk_names sct
     { .name = "ECN_ECNE",	.chunk_type = 12,  .valid_flags = "--------"},
     { .name = "ECN_CWR",	.chunk_type = 13,  .valid_flags = "--------"},
     { .name = "SHUTDOWN_COMPLETE", .chunk_type = 14,  .valid_flags = "-------T"},
-    { .name = "ASCONF",		.chunk_type = 31,  .valid_flags = "--------"},
-    { .name = "ASCONF_ACK",	.chunk_type = 30,  .valid_flags = "--------"},
+    { .name = "ASCONF",		.chunk_type = 193,  .valid_flags = "--------"},
+    { .name = "ASCONF_ACK",	.chunk_type = 128,  .valid_flags = "--------"},
 };
 
 static void

--------------000903080205090104090408--
