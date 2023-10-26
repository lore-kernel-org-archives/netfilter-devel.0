Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C460C25B6F
	for <netfilter-devel@archiver.kernel.org>; Thu, 26 Oct 2023 08:55:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234833AbjJZIzV (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 26 Oct 2023 04:55:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234917AbjJZIzS (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 26 Oct 2023 04:55:18 -0400
Received: from a3.inai.de (a3.inai.de [IPv6:2a01:4f8:10b:45d8::f5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2A5E1B5
        for <netfilter-devel@vger.kernel.org>; Thu, 26 Oct 2023 01:55:11 -0700 (PDT)
Received: by a3.inai.de (Postfix, from userid 65534)
        id 8A62A5872668E; Thu, 26 Oct 2023 10:55:08 +0200 (CEST)
Received: from a4.inai.de (a4.inai.de [IPv6:2a01:4f8:10b:45d8::f8])
        by a3.inai.de (Postfix) with ESMTP id A906158726691;
        Thu, 26 Oct 2023 10:55:06 +0200 (CEST)
From:   Jan Engelhardt <jengelh@inai.de>
To:     netfilter-devel@vger.kernel.org
Cc:     phil@nwl.cc
Subject: [PATCH 07/10] man: grammar fixes to some manpages
Date:   Thu, 26 Oct 2023 10:55:03 +0200
Message-ID: <20231026085506.94343-7-jengelh@inai.de>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231026085506.94343-1-jengelh@inai.de>
References: <20231026085506.94343-1-jengelh@inai.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

English generally uses open compounds rather than closed ones;
fix the excess hyphens in words. Fix a missing dash for the
portnr option as well.

Signed-off-by: Jan Engelhardt <jengelh@inai.de>
---
 extensions/libxt_MASQUERADE.man |  2 +-
 extensions/libxt_helper.man     | 10 +++++-----
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/extensions/libxt_MASQUERADE.man b/extensions/libxt_MASQUERADE.man
index e2009086..7cc2bb7a 100644
--- a/extensions/libxt_MASQUERADE.man
+++ b/extensions/libxt_MASQUERADE.man
@@ -15,7 +15,7 @@ any established connections are lost anyway).
 \fB\-\-to\-ports\fP \fIport\fP[\fB\-\fP\fIport\fP]
 This specifies a range of source ports to use, overriding the default
 .B SNAT
-source port-selection heuristics (see above).  This is only valid
+source port-selection heuristics (see above). This is only valid
 if the rule also specifies one of the following protocols:
 \fBtcp\fP, \fBudp\fP, \fBdccp\fP or \fBsctp\fP.
 .TP
diff --git a/extensions/libxt_helper.man b/extensions/libxt_helper.man
index 772b1350..fb8a206c 100644
--- a/extensions/libxt_helper.man
+++ b/extensions/libxt_helper.man
@@ -1,11 +1,11 @@
-This module matches packets related to a specific conntrack-helper.
+This module matches packets related to a specific conntrack helper.
 .TP
 [\fB!\fP] \fB\-\-helper\fP \fIstring\fP
-Matches packets related to the specified conntrack-helper.
+Matches packets related to the specified conntrack helper.
 .RS
 .PP
-string can be "ftp" for packets related to a ftp-session on default port.
-For other ports append \-portnr to the value, ie. "ftp\-2121".
+string can be "ftp" for packets related to an FTP session on default port.
+For other ports, append \-\-portnr to the value, ie. "ftp\-2121".
 .PP
-Same rules apply for other conntrack-helpers.
+Same rules apply for other conntrack helpers.
 .RE
-- 
2.42.0

