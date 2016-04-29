From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH] iptables: update pf.os
Date: Fri, 29 Apr 2016 18:40:00 +0200
Message-ID: <1461948000-20076-1-git-send-email-xose.vazquez@gmail.com>
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>,
	Evgeniy Polyakov <johnpol@2ka.mxt.ru>,
	Jan Engelhardt <jengelh@medozas.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel <netfilter-devel@vger.kernel.org>
To: unlisted-recipients:; (no To-header on input)
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f51.google.com ([74.125.82.51]:34524 "EHLO
	mail-wm0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751303AbcD2QkH (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 29 Apr 2016 12:40:07 -0400
Received: by mail-wm0-f51.google.com with SMTP id v200so11340890wmv.1
        for <netfilter-devel@vger.kernel.org>; Fri, 29 Apr 2016 09:40:06 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Sync with latest *BSD release: https://gitweb.dragonflybsd.org/dragonfly.git/blob_plain/HEAD:/etc/pf.os
Changelog: http://cvsweb.openbsd.org/cgi-bin/cvsweb/src/etc/pf.os

Cc: Evgeniy Polyakov <johnpol@2ka.mxt.ru>
Cc: Jan Engelhardt <jengelh@medozas.de>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel <netfilter-devel@vger.kernel.org>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 utils/pf.os | 37 ++++++++++++++++++++++++++++---------
 1 file changed, 28 insertions(+), 9 deletions(-)

diff --git a/utils/pf.os b/utils/pf.os
index 44e0014..01fb85b 100644
--- a/utils/pf.os
+++ b/utils/pf.os
@@ -1,4 +1,5 @@
-# $OpenBSD: pf.os,v 1.20 2006/06/02 16:54:34 david Exp $
+# $FreeBSD: head/etc/pf.os 258865 2013-12-03 04:32:02Z eadler $
+# $OpenBSD: pf.os,v 1.26 2012/08/03 12:25:16 jsg Exp $
 # passive OS fingerprinting
 # -------------------------
 #
@@ -225,7 +226,13 @@ S2:64:1:60:M*,S,T,N,W0:		Linux:2.4::Linux 2.4 (big boy)
 S3:64:1:60:M*,S,T,N,W0:		Linux:2.4:.18-21:Linux 2.4.18 and newer
 S4:64:1:60:M*,S,T,N,W0:		Linux:2.4::Linux 2.4/2.6 <= 2.6.7
 S4:64:1:60:M*,S,T,N,W0:		Linux:2.6:.1-7:Linux 2.4/2.6 <= 2.6.7
-S4:64:1:60:M*,S,T,N,W7:		Linux:2.6:8:Linux 2.6.8 and newer (?)
+
+S4:64:1:60:M*,S,T,N,W5:		Linux:2.6::Linux 2.6 (newer, 1)
+S4:64:1:60:M*,S,T,N,W6:		Linux:2.6::Linux 2.6 (newer, 2)
+S4:64:1:60:M*,S,T,N,W7:		Linux:2.6::Linux 2.6 (newer, 3)
+T4:64:1:60:M*,S,T,N,W7:		Linux:2.6::Linux 2.6 (newer, 4)
+
+S10:64:1:60:M*,S,T,N,W4:	Linux:3.0::Linux 3.0
 
 S3:64:1:60:M*,S,T,N,W1:		Linux:2.5::Linux 2.5 (sometimes 2.4)
 S4:64:1:60:M*,S,T,N,W1:		Linux:2.5-2.6::Linux 2.5/2.6
@@ -298,12 +305,23 @@ S22:64:1:52:M*,N,N,S,N,W0:	Linux:2.2:ts:Linux 2.2 w/o timestamps
 # ----------------- OpenBSD -----------------
 
 16384:64:0:60:M*,N,W0,N,N,T:		OpenBSD:2.6::NetBSD 1.3 (or OpenBSD 2.6)
-16384:64:1:64:M*,N,N,S,N,W0,N,N,T:	OpenBSD:3.0-3.9::OpenBSD 3.0-3.9
-16384:64:0:64:M*,N,N,S,N,W0,N,N,T:	OpenBSD:3.0-3.9:no-df:OpenBSD 3.0-3.9 (scrub no-df)
-57344:64:1:64:M*,N,N,S,N,W0,N,N,T:	OpenBSD:3.3-3.9::OpenBSD 3.3-3.9
-57344:64:0:64:M*,N,N,S,N,W0,N,N,T:	OpenBSD:3.3-3.9:no-df:OpenBSD 3.3-3.9 (scrub no-df)
+16384:64:1:64:M*,N,N,S,N,W0,N,N,T:	OpenBSD:3.0-4.8::OpenBSD 3.0-4.8
+16384:64:0:64:M*,N,N,S,N,W0,N,N,T:	OpenBSD:3.0-4.8:no-df:OpenBSD 3.0-4.8 (scrub no-df)
+57344:64:1:64:M*,N,N,S,N,W0,N,N,T:	OpenBSD:3.3-4.0::OpenBSD 3.3-4.0
+57344:64:0:64:M*,N,N,S,N,W0,N,N,T:	OpenBSD:3.3-4.0:no-df:OpenBSD 3.3-4.0 (scrub no-df)
+
+65535:64:1:64:M*,N,N,S,N,W0,N,N,T:	OpenBSD:3.0-4.0:opera:OpenBSD 3.0-4.0 (Opera)
 
-65535:64:1:64:M*,N,N,S,N,W0,N,N,T:	OpenBSD:3.0-3.9:opera:OpenBSD 3.0-3.9 (Opera)
+16384:64:1:64:M*,N,N,S,N,W3,N,N,T:	OpenBSD:4.9::OpenBSD 4.9
+16384:64:0:64:M*,N,N,S,N,W3,N,N,T:	OpenBSD:4.9:no-df:OpenBSD 4.9 (scrub no-df)
+
+# ----------------- DragonFly BSD -----------------
+
+57344:64:1:60:M*,N,W0,N,N,T:		DragonFly:1.0:A:DragonFly 1.0A
+57344:64:0:64:M*,N,W0,N,N,S,N,N,T:	DragonFly:1.2-1.12::DragonFly 1.2-1.12
+5840:64:1:60:M*,S,T,N,W4:			DragonFly:2.0-2.1::DragonFly 2.0-2.1
+57344:64:0:64:M*,N,W0,N,N,S,N,N,T:	DragonFly:2.2-2.3::DragonFly 2.2-2.3
+57344:64:0:64:M*,N,W5,N,N,S,N,N,T:	DragonFly:2.4-2.7::DragonFly 2.4-2.7
 
 # ----------------- Solaris -----------------
 
@@ -356,13 +374,12 @@ S34:64:1:52:M*,N,W0,N,N,S:		Solaris:10:beta:Solaris 10 (beta)
 16616:255:1:48:M*,N,N,N:		MacOS:8.1-8.6:OTTCP:MacOS 8.1-8.6 (OTTCP)
 32768:255:1:48:M*,W0,N:			MacOS:9.0-9.2::MacOS 9.0-9.2
 65535:255:1:48:M*,N,N,N,N:		MacOS:9.1::MacOS 9.1 (OT 2.7.4)
-65535:64:1:64:M*,N,W0,N,N,T,S,E,E:	MacOS:10::MacOS X
 
 
 # ----------------- Windows -----------------
 
 # Windows TCP/IP stack is a mess. For most recent XP, 2000 and
-# even 98, the pathlevel, not the actual OS version, is more
+# even 98, the patchlevel, not the actual OS version, is more
 # relevant to the signature. They share the same code, so it would
 # seem. Luckily for us, almost all Windows 9x boxes have an
 # awkward MSS of 536, which I use to tell one from another
@@ -426,6 +443,8 @@ S44:128:1:48:M*,N,N,S:			Windows:XP:SP1:Windows Pro SP1, 2000 SP3
 32767:128:1:48:M*,N,N,S:		Windows:2000:SP4:Windows SP1, 2000 SP4
 32767:128:1:48:M*,N,N,S:		Windows:XP:SP1:Windows SP1, 2000 SP4
 
+8192:128:1:52:M*,N,W2,N,N,S:		Windows:Vista::Windows Vista/7
+
 # Odds, ends, mods:
 
 S52:128:1:48:M1260,N,N,S:		Windows:2000:cisco:Windows XP/2000 via Cisco
-- 
2.5.5

