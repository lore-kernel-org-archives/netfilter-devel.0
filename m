Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE3B6C07545
	for <netfilter-devel@archiver.kernel.org>; Tue, 24 Oct 2023 13:19:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234262AbjJXNTZ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 24 Oct 2023 09:19:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234283AbjJXNTY (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 24 Oct 2023 09:19:24 -0400
Received: from a3.inai.de (a3.inai.de [IPv6:2a01:4f8:10b:45d8::f5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A58E710F
        for <netfilter-devel@vger.kernel.org>; Tue, 24 Oct 2023 06:19:21 -0700 (PDT)
Received: by a3.inai.de (Postfix, from userid 65534)
        id 01FB958740D54; Tue, 24 Oct 2023 15:19:20 +0200 (CEST)
Received: from a4.inai.de (a4.inai.de [IPv6:2a01:4f8:10b:45d8::f8])
        by a3.inai.de (Postfix) with ESMTP id 6CD2F58783417
        for <netfilter-devel@vger.kernel.org>; Tue, 24 Oct 2023 15:19:19 +0200 (CEST)
From:   Jan Engelhardt <jengelh@inai.de>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH 2/6] man: encode emdash the way groff/man requires it
Date:   Tue, 24 Oct 2023 15:19:15 +0200
Message-ID: <20231024131919.28665-2-jengelh@inai.de>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231024131919.28665-1-jengelh@inai.de>
References: <20231024131919.28665-1-jengelh@inai.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Unlike LaTeX, two/three U+002D in the source do not translate
to an en-/em-dash in man. Using \(em addresses this.
---
 extensions/libxt_hashlimit.man | 2 +-
 extensions/libxt_limit.man     | 2 +-
 extensions/libxt_time.man      | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/extensions/libxt_hashlimit.man b/extensions/libxt_hashlimit.man
index 627fcd0a..b95a52d2 100644
--- a/extensions/libxt_hashlimit.man
+++ b/extensions/libxt_hashlimit.man
@@ -20,7 +20,7 @@ Maximum initial number of packets to match: this number gets recharged by one
 every time the limit specified above is not reached, up to this number; the
 default is 5.  When byte-based rate matching is requested, this option specifies
 the amount of bytes that can exceed the given rate.  This option should be used
-with caution -- if the entry expires, the burst value is reset too.
+with caution \(em if the entry expires, the burst value is reset too.
 .TP
 \fB\-\-hashlimit\-mode\fP {\fBsrcip\fP|\fBsrcport\fP|\fBdstip\fP|\fBdstport\fP}\fB,\fP...
 A comma-separated list of objects to take into consideration. If no
diff --git a/extensions/libxt_limit.man b/extensions/libxt_limit.man
index 6fb94ccf..b477dd94 100644
--- a/extensions/libxt_limit.man
+++ b/extensions/libxt_limit.man
@@ -4,7 +4,7 @@ It can be used in combination with the
 .B LOG
 target to give limited logging, for example.
 .PP
-xt_limit has no negation support - you will have to use \-m hashlimit !
+xt_limit has no negation support \(em you will have to use \-m hashlimit !
 \-\-hashlimit \fIrate\fP in this case whilst omitting \-\-hashlimit\-mode.
 .TP
 \fB\-\-limit\fP \fIrate\fP[\fB/second\fP|\fB/minute\fP|\fB/hour\fP|\fB/day\fP]
diff --git a/extensions/libxt_time.man b/extensions/libxt_time.man
index 4c0cae06..5b749a48 100644
--- a/extensions/libxt_time.man
+++ b/extensions/libxt_time.man
@@ -58,7 +58,7 @@ rest of the system uses).
 The caveat with the kernel timezone is that Linux distributions may ignore to
 set the kernel timezone, and instead only set the system time. Even if a
 particular distribution does set the timezone at boot, it is usually does not
-keep the kernel timezone offset - which is what changes on DST - up to date.
+keep the kernel timezone offset \(em which is what changes on DST \(em up to date.
 ntpd will not touch the kernel timezone, so running it will not resolve the
 issue. As such, one may encounter a timezone that is always +0000, or one that
 is wrong half of the time of the year. As such, \fBusing \-\-kerneltz is highly
-- 
2.42.0

