From: Philip Craig <philipc@snapgear.com>
Subject: [PATCH] Only build iptables-xml when shared libraries are enabled
Date: Mon, 20 Jul 2009 14:44:45 +1000
Message-ID: <4A63F63D.8000904@snapgear.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------000803030005020900080305"
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from rex.securecomputing.com ([203.24.151.4]:36862 "EHLO
	cyberguard.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750933AbZGTEoq (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 20 Jul 2009 00:44:46 -0400
Received: from localhost (localhost.localdomain [127.0.0.1])
	by bne.snapgear.com (Postfix) with ESMTP id E8B99EBBB3
	for <netfilter-devel@vger.kernel.org>; Mon, 20 Jul 2009 14:44:45 +1000 (EST)
Received: from bne.snapgear.com ([127.0.0.1])
	by localhost (bne.snapgear.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 4WuA5qPjAc+W for <netfilter-devel@vger.kernel.org>;
	Mon, 20 Jul 2009 14:44:45 +1000 (EST)
Received: from [192.168.0.3] (philipc2.sw.moreton.com.au [10.46.1.58])
	by bne.snapgear.com (Postfix) with ESMTP
	for <netfilter-devel@vger.kernel.org>; Mon, 20 Jul 2009 14:44:45 +1000 (EST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multi-part message in MIME format.
--------------000803030005020900080305
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit



--------------000803030005020900080305
Content-Type: text/plain;
 name="x"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="x"

Only build iptables-xml when shared libraries are enabled

There is no static version of iptables-xml currently.
I'm building for a target that has no libdl.

Signed-off-by: Philip Craig <philipc@snapgear.com>

diff --git a/Makefile.am b/Makefile.am
index a9e3ad3..657ef41 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -81,7 +81,7 @@ ip6tables_static_SOURCES    = ${ip6tables_multi_SOURCES} xtables.c
 ip6tables_static_CFLAGS     = ${ip6tables_multi_CFLAGS} -DNO_SHARED_LIBS=1
 ip6tables_static_LDADD      = libiptc/libip6tc.la extensions/libext6.a -lm
 
-bin_PROGRAMS     = iptables-xml
+bin_PROGRAMS     =
 sbin_PROGRAMS    =
 noinst_PROGRAMS  =
 man_MANS         = iptables.8 iptables-restore.8 iptables-save.8 \
@@ -98,6 +98,7 @@ sbin_PROGRAMS += ip6tables-static
 endif
 endif
 if ENABLE_SHARED
+bin_PROGRAMS  += iptables-xml
 if ENABLE_IPV4
 sbin_PROGRAMS += iptables iptables-multi iptables-restore iptables-save
 endif

--------------000803030005020900080305--
