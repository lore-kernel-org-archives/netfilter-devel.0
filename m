Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87A87C25B72
	for <netfilter-devel@archiver.kernel.org>; Thu, 26 Oct 2023 08:55:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344794AbjJZIzX (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 26 Oct 2023 04:55:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234948AbjJZIzT (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 26 Oct 2023 04:55:19 -0400
Received: from a3.inai.de (a3.inai.de [IPv6:2a01:4f8:10b:45d8::f5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7573B1A1
        for <netfilter-devel@vger.kernel.org>; Thu, 26 Oct 2023 01:55:12 -0700 (PDT)
Received: by a3.inai.de (Postfix, from userid 65534)
        id 006DE58726691; Thu, 26 Oct 2023 10:55:08 +0200 (CEST)
Received: from a4.inai.de (a4.inai.de [IPv6:2a01:4f8:10b:45d8::f8])
        by a3.inai.de (Postfix) with ESMTP id D1DBA58726696;
        Thu, 26 Oct 2023 10:55:06 +0200 (CEST)
From:   Jan Engelhardt <jengelh@inai.de>
To:     netfilter-devel@vger.kernel.org
Cc:     phil@nwl.cc
Subject: [PATCH 10/10] man: reveal rateest's combination categories
Date:   Thu, 26 Oct 2023 10:55:06 +0200
Message-ID: <20231026085506.94343-10-jengelh@inai.de>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231026085506.94343-1-jengelh@inai.de>
References: <20231026085506.94343-1-jengelh@inai.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Phil Sutter <phil@nwl.cc>

The .\" prefix made these paragraphs invisible in at least regular
man page output. Turn them into tags instead.

Signed-off-by: Jan Engelhardt <jengelh@inai.de>
---
 extensions/libxt_rateest.man | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/extensions/libxt_rateest.man b/extensions/libxt_rateest.man
index d6ba3675..22301e7f 100644
--- a/extensions/libxt_rateest.man
+++ b/extensions/libxt_rateest.man
@@ -4,22 +4,26 @@ estimators and matching on the difference between two rate estimators.
 .PP
 For a better understanding of the available options, these are all possible
 combinations:
-.\" * Absolute:
+.TP
+Absolute:
 .IP \(bu 4
 \fBrateest\fP \fIoperator\fP \fBrateest-bps\fP
 .IP \(bu 4
 \fBrateest\fP \fIoperator\fP \fBrateest-pps\fP
-.\" * Absolute + Delta:
+.TP
+Absolute + Delta:
 .IP \(bu 4
 (\fBrateest\fP minus \fBrateest-bps1\fP) \fIoperator\fP \fBrateest-bps2\fP
 .IP \(bu 4
 (\fBrateest\fP minus \fBrateest-pps1\fP) \fIoperator\fP \fBrateest-pps2\fP
-.\" * Relative:
+.TP
+Relative:
 .IP \(bu 4
 \fBrateest1\fP \fIoperator\fP \fBrateest2\fP \fBrateest-bps\fP(without rate!)
 .IP \(bu 4
 \fBrateest1\fP \fIoperator\fP \fBrateest2\fP \fBrateest-pps\fP(without rate!)
-.\" * Relative + Delta:
+.TP
+Relative + Delta:
 .IP \(bu 4
 (\fBrateest1\fP minus \fBrateest-bps1\fP) \fIoperator\fP
 (\fBrateest2\fP minus \fBrateest-bps2\fP)
-- 
2.42.0

