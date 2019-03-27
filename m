Return-Path: <SRS0=34lc=R6=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3ADF4C10F14
	for <netfilter-devel@archiver.kernel.org>; Wed, 27 Mar 2019 10:43:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 44E37217D7
	for <netfilter-devel@archiver.kernel.org>; Wed, 27 Mar 2019 10:38:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=riseup.net header.i=@riseup.net header.b="E4c2C+5X"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733109AbfC0KiJ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 27 Mar 2019 06:38:09 -0400
Received: from mx1.riseup.net ([198.252.153.129]:55556 "EHLO mx1.riseup.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727557AbfC0KiI (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 27 Mar 2019 06:38:08 -0400
Received: from capuchin.riseup.net (capuchin-pn.riseup.net [10.0.1.176])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (Client CN "*.riseup.net", Issuer "COMODO RSA Domain Validation Secure Server CA" (verified OK))
        by mx1.riseup.net (Postfix) with ESMTPS id EA0341B9057
        for <netfilter-devel@vger.kernel.org>; Wed, 27 Mar 2019 03:38:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=riseup.net; s=squak;
        t=1553683088; bh=ZtymmjrRI680dZiK6jmm3JIYNSnnFJBh+6X1pv3uFe4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E4c2C+5X5WfvLf1MPUd9iWtiIO7lRkOzzT6wf6hh9jg3+sXAttZwM3/OKj1eVriFn
         FDQ35WLuGuztaxMW+hRLwIfP1l9yqkOC/QefNdXapRJSHp1mBbgwrNdxc4NepEMqa8
         8bnTvHEgNP3FydH/21nrCAPRx7Vn4Dp6xphJ51LA=
X-Riseup-User-ID: 9319A124F9AB16CCB3E2E9830CCF641AAE57B727762F5849A2B867DB3CCEFAF6
Received: from [127.0.0.1] (localhost [127.0.0.1])
         by capuchin.riseup.net (Postfix) with ESMTPSA id 1FF381205E8;
        Wed, 27 Mar 2019 03:38:06 -0700 (PDT)
From:   Fernando Fernandez Mancera <ffmancera@riseup.net>
To:     netfilter-devel@vger.kernel.org
Cc:     Fernando Fernandez Mancera <ffmancera@riseup.net>
Subject: [PATCH 6/6 nft v3] files: pf.os: merge the signatures spllited by version
Date:   Wed, 27 Mar 2019 11:38:01 +0100
Message-Id: <20190327103801.2049-6-ffmancera@riseup.net>
In-Reply-To: <20190327103801.2049-1-ffmancera@riseup.net>
References: <20190327103801.2049-1-ffmancera@riseup.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

In order to be able to identify the OS version we need to merge the signatures
split by version. eg.

65535:64:1:60:M*,N,W1,N,N,T:	FreeBSD:4.7-4.11::FreeBSD 4.7-5.2
65535:64:1:60:M*,N,W1,N,N,T:	FreeBSD:5.0-5.2::FreeBSD 4.7-5.2

65535:64:1:60:M*,N,W1,N,N,T:	FreeBSD:4.7-5.2::FreeBSD 4.7-5.2

Signed-off-by: Fernando Fernandez Mancera <ffmancera@riseup.net>
---
 files/osf/pf.os | 40 ++++++++++++++--------------------------
 1 file changed, 14 insertions(+), 26 deletions(-)

diff --git a/files/osf/pf.os b/files/osf/pf.os
index 7612d76..35cbb47 100644
--- a/files/osf/pf.os
+++ b/files/osf/pf.os
@@ -201,12 +201,9 @@
 45046:64:0:44:M*:		AIX:4.3::AIX 4.3
 16384:64:0:44:M512:		AIX:4.3:2-3:AIX 4.3.2 and earlier
 
-16384:64:0:60:M512,N,W%2,N,N,T:		AIX:4.3:3:AIX 4.3.3-5.2
-16384:64:0:60:M512,N,W%2,N,N,T:		AIX:5.1-5.2::AIX 4.3.3-5.2
-32768:64:0:60:M512,N,W%2,N,N,T:		AIX:4.3:3:AIX 4.3.3-5.2
-32768:64:0:60:M512,N,W%2,N,N,T:		AIX:5.1-5.2::AIX 4.3.3-5.2
-65535:64:0:60:M512,N,W%2,N,N,T:		AIX:4.3:3:AIX 4.3.3-5.2
-65535:64:0:60:M512,N,W%2,N,N,T:		AIX:5.1-5.2::AIX 4.3.3-5.2
+16384:64:0:60:M512,N,W%2,N,N,T:		AIX:4.3-5.2:3:AIX 4.3.3-5.2
+32768:64:0:60:M512,N,W%2,N,N,T:		AIX:4.3-5.2:3:AIX 4.3.3-5.2
+65535:64:0:60:M512,N,W%2,N,N,T:		AIX:4.3-5-2:3:AIX 4.3.3-5.2
 65535:64:0:64:M*,N,W1,N,N,T,N,N,S:	AIX:5.3:ML1:AIX 5.3 ML1
 
 # ----------------- Linux -------------------
@@ -224,8 +221,7 @@ S4:64:1:60:M1360,S,T,N,W0:	Linux:google::Linux (Google crawlbot)
 
 S2:64:1:60:M*,S,T,N,W0:		Linux:2.4::Linux 2.4 (big boy)
 S3:64:1:60:M*,S,T,N,W0:		Linux:2.4:.18-21:Linux 2.4.18 and newer
-S4:64:1:60:M*,S,T,N,W0:		Linux:2.4::Linux 2.4/2.6 <= 2.6.7
-S4:64:1:60:M*,S,T,N,W0:		Linux:2.6:.1-7:Linux 2.4/2.6 <= 2.6.7
+S4:64:1:60:M*,S,T,N,W0:		Linux:2.4/2.6::Linux 2.4/2.6 <= 2.6.7
 
 S4:64:1:60:M*,S,T,N,W5:		Linux:2.6::Linux 2.6 (newer, 1)
 S4:64:1:60:M*,S,T,N,W6:		Linux:2.6::Linux 2.6 (newer, 2)
@@ -271,9 +267,7 @@ S22:64:1:52:M*,N,N,S,N,W0:	Linux:2.2:ts:Linux 2.2 w/o timestamps
 
 # ----------------- FreeBSD -----------------
 
-16384:64:1:44:M*:		FreeBSD:2.0-2.2::FreeBSD 2.0-4.2
-16384:64:1:44:M*:		FreeBSD:3.0-3.5::FreeBSD 2.0-4.2
-16384:64:1:44:M*:		FreeBSD:4.0-4.2::FreeBSD 2.0-4.2
+16384:64:1:44:M*:		FreeBSD:2.0-4.2::FreeBSD 2.0-4.2
 16384:64:1:60:M*,N,W0,N,N,T:	FreeBSD:4.4::FreeBSD 4.4
 
 1024:64:1:60:M*,N,W0,N,N,T:	FreeBSD:4.4::FreeBSD 4.4
@@ -281,12 +275,9 @@ S22:64:1:52:M*,N,N,S,N,W0:	Linux:2.2:ts:Linux 2.2 w/o timestamps
 57344:64:1:44:M*:		FreeBSD:4.6-4.8:noRFC1323:FreeBSD 4.6-4.8 (no RFC1323)
 57344:64:1:60:M*,N,W0,N,N,T:	FreeBSD:4.6-4.9::FreeBSD 4.6-4.9
 
-32768:64:1:60:M*,N,W0,N,N,T:	FreeBSD:4.8-4.11::FreeBSD 4.8-5.1 (or MacOS X)
-32768:64:1:60:M*,N,W0,N,N,T:	FreeBSD:5.0-5.1::FreeBSD 4.8-5.1 (or MacOS X)
-65535:64:1:60:M*,N,W0,N,N,T:	FreeBSD:4.8-4.11::FreeBSD 4.8-5.2 (or MacOS X)
-65535:64:1:60:M*,N,W0,N,N,T:	FreeBSD:5.0-5.2::FreeBSD 4.8-5.2 (or MacOS X)
-65535:64:1:60:M*,N,W1,N,N,T:	FreeBSD:4.7-4.11::FreeBSD 4.7-5.2
-65535:64:1:60:M*,N,W1,N,N,T:	FreeBSD:5.0-5.2::FreeBSD 4.7-5.2
+32768:64:1:60:M*,N,W0,N,N,T:	FreeBSD:4.8-5.1::FreeBSD 4.8-5.1 (or MacOS X)
+65535:64:1:60:M*,N,W0,N,N,T:	FreeBSD:4.8-5.2::FreeBSD 4.8-5.2 (or MacOS X)
+65535:64:1:60:M*,N,W1,N,N,T:	FreeBSD:4.7-5.2::FreeBSD 4.7-5.2
 
 65535:64:1:60:M*,N,W6,S,T:	FreeBSD:9.0-12.0::FreeBSD 9.0 - 12.0
 
@@ -378,8 +369,7 @@ S34:64:1:52:M*,N,W0,N,N,S:		Solaris:10:beta:Solaris 10 (beta)
 # S2:255:1:48:M*,W0,E:.:MacOS:8.6 classic
 
 # XXX some of these use EOL too
-16616:255:1:48:M*,W0:			MacOS:7.3-7.6:OTTCP:MacOS 7.3-8.6 (OTTCP)
-16616:255:1:48:M*,W0:			MacOS:8.0-8.6:OTTCP:MacOS 7.3-8.6 (OTTCP)
+16616:255:1:48:M*,W0:			MacOS:7.3-8.6:OTTCP:MacOS 7.3-8.6 (OTTCP)
 16616:255:1:48:M*,N,N,N:		MacOS:8.1-8.6:OTTCP:MacOS 8.1-8.6 (OTTCP)
 32768:255:1:48:M*,W0,N:			MacOS:9.0-9.2::MacOS 9.0-9.2
 65535:255:1:48:M*,N,N,N,N:		MacOS:9.1::MacOS 9.1 (OT 2.7.4)
@@ -515,8 +505,7 @@ S8:64:0:44:M512:		NeXTSTEP:3.3::NeXTSTEP 3.3
 
 # ------------------ OS/400 -----------------
 
-8192:64:1:60:M1440,N,W0,N,N,T:	OS/400:VR4::OS/400 VR4/R5
-8192:64:1:60:M1440,N,W0,N,N,T:	OS/400:VR5::OS/400 VR4/R5
+8192:64:1:60:M1440,N,W0,N,N,T:	OS/400:VR4-VR5::OS/400 VR4/R5
 4096:64:1:60:M1440,N,W0,N,N,T:	OS/400:V4R5:CF67032:OS/400 V4R5 + CF67032
 
 # XXX quirk
@@ -532,9 +521,9 @@ S16:64:0:44:M512:		QNX:::QNX demodisk
 
 # ------------------ Novell -----------------
 
-16384:128:1:44:M1460:		Novell:NetWare:5.0:Novel Netware 5.0
-6144:128:1:44:M1460:		Novell:IntranetWare:4.11:Novell IntranetWare 4.11
-6144:128:1:44:M1368:		Novell:BorderManager::Novell BorderManager ?
+16384:128:1:44:M1460:		Novell:NW:5.0:Novel Netware 5.0
+6144:128:1:44:M1460:		Novell:IW:4.11:Novell IntranetWare 4.11
+6144:128:1:44:M1368:		Novell:BM::Novell BorderManager ?
 
 6144:128:1:52:M*,W0,N,S,N,N:	Novell:Netware:6:Novell Netware 6 SP3
 
@@ -637,8 +626,7 @@ S1:255:1:60:M1460,S,T,N,W0:		LookSmart:ZyBorg::LookSmart ZyBorg
 # ----------- Embedded systems --------------
 
 S9:255:0:44:M536:			PalmOS:Tungsten:C:PalmOS Tungsten C
-S5:255:0:44:M536:			PalmOS:3::PalmOS 3/4
-S5:255:0:44:M536:			PalmOS:4::PalmOS 3/4
+S5:255:0:44:M536:			PalmOS:3-4::PalmOS 3/4
 S4:255:0:44:M536:			PalmOS:3:5:PalmOS 3.5
 2948:255:0:44:M536:			PalmOS:3:5:PalmOS 3.5.3 (Handera)
 S29:255:0:44:M536:			PalmOS:5::PalmOS 5.0
-- 
2.20.1

