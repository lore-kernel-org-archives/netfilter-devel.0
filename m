From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH] iptables: update pf.os
Date: Mon, 30 Jan 2017 11:30:16 +0100
Message-ID: <20170130103016.3264-1-xose.vazquez@gmail.com>
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel <netfilter-devel@vger.kernel.org>
To: unlisted-recipients:; (no To-header on input)
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f46.google.com ([74.125.82.46]:37530 "EHLO
        mail-wm0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752750AbdA3KaZ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 30 Jan 2017 05:30:25 -0500
Received: by mail-wm0-f46.google.com with SMTP id v77so41015502wmv.0
        for <netfilter-devel@vger.kernel.org>; Mon, 30 Jan 2017 02:30:24 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Sync with latest OpenBSD release.
Changelog: http://cvsweb.openbsd.org/cgi-bin/cvsweb/src/etc/pf.os

Cc: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel <netfilter-devel@vger.kernel.org>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 utils/pf.os | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/utils/pf.os b/utils/pf.os
index 01fb85be..e285851e 100644
--- a/utils/pf.os
+++ b/utils/pf.os
@@ -1,5 +1,5 @@
 # $FreeBSD: head/etc/pf.os 258865 2013-12-03 04:32:02Z eadler $
-# $OpenBSD: pf.os,v 1.26 2012/08/03 12:25:16 jsg Exp $
+# $OpenBSD: pf.os,v 1.27 2016/09/03 17:08:57 sthen Exp $
 # passive OS fingerprinting
 # -------------------------
 #
@@ -315,6 +315,9 @@ S22:64:1:52:M*,N,N,S,N,W0:	Linux:2.2:ts:Linux 2.2 w/o timestamps
 16384:64:1:64:M*,N,N,S,N,W3,N,N,T:	OpenBSD:4.9::OpenBSD 4.9
 16384:64:0:64:M*,N,N,S,N,W3,N,N,T:	OpenBSD:4.9:no-df:OpenBSD 4.9 (scrub no-df)
 
+16384:64:1:64:M*,N,N,S,N,W6,N,N,T:      OpenBSD:6.1::OpenBSD 6.1
+16384:64:0:64:M*,N,N,S,N,W6,N,N,T:      OpenBSD:6.1:no-df:OpenBSD 6.1 (scrub no-df)
+
 # ----------------- DragonFly BSD -----------------
 
 57344:64:1:60:M*,N,W0,N,N,T:		DragonFly:1.0:A:DragonFly 1.0A
-- 
2.11.0

