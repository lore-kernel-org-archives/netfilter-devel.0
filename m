Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31399C25B48
	for <netfilter-devel@archiver.kernel.org>; Thu, 26 Oct 2023 08:55:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229642AbjJZIzQ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 26 Oct 2023 04:55:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344700AbjJZIzL (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 26 Oct 2023 04:55:11 -0400
Received: from a3.inai.de (a3.inai.de [IPv6:2a01:4f8:10b:45d8::f5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FD5E1A2
        for <netfilter-devel@vger.kernel.org>; Thu, 26 Oct 2023 01:55:08 -0700 (PDT)
Received: by a3.inai.de (Postfix, from userid 65534)
        id 1E898587266A2; Thu, 26 Oct 2023 10:55:07 +0200 (CEST)
Received: from a4.inai.de (a4.inai.de [IPv6:2a01:4f8:10b:45d8::f8])
        by a3.inai.de (Postfix) with ESMTP id 6303258726687;
        Thu, 26 Oct 2023 10:55:06 +0200 (CEST)
From:   Jan Engelhardt <jengelh@inai.de>
To:     netfilter-devel@vger.kernel.org
Cc:     phil@nwl.cc
Subject: [PATCH 02/10] man: encode emdash the way groff/man requires it
Date:   Thu, 26 Oct 2023 10:54:58 +0200
Message-ID: <20231026085506.94343-2-jengelh@inai.de>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231026085506.94343-1-jengelh@inai.de>
References: <20231026085506.94343-1-jengelh@inai.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Unlike LaTeX, two/three U+002D in the source do not translate to an
en and em-dash in man. Using \(en and \(em, respectively, addresses
this.

Signed-off-by: Jan Engelhardt <jengelh@inai.de>
---
 extensions/libxt_hashlimit.man | 2 +-
 extensions/libxt_limit.man     | 2 +-
 extensions/libxt_rateest.man   | 2 +-
 extensions/libxt_time.man      | 2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/extensions/libxt_hashlimit.man b/extensions/libxt_hashlimit.man
index 8a35d564..79a37986 100644
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
diff --git a/extensions/libxt_rateest.man b/extensions/libxt_rateest.man
index 42a82f32..1989ff6c 100644
--- a/extensions/libxt_rateest.man
+++ b/extensions/libxt_rateest.man
@@ -68,7 +68,7 @@ The names of the two rate estimators for relative mode.
 \fB\-\-rateest\-pps2\fP [\fIvalue\fP]
 Compare the estimator(s) by bytes or packets per second, and compare against
 the chosen value. See the above bullet list for which option is to be used in
-which case. A unit suffix may be used - available ones are: bit, [kmgt]bit,
+which case. A unit suffix may be used \(em available ones are: bit, [kmgt]bit,
 [KMGT]ibit, Bps, [KMGT]Bps, [KMGT]iBps.
 .PP
 Example: This is what can be used to route outgoing data connections from an
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

