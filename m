Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD3A8C25B48
	for <netfilter-devel@archiver.kernel.org>; Thu, 26 Oct 2023 08:55:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229841AbjJZIzV (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 26 Oct 2023 04:55:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234946AbjJZIzS (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 26 Oct 2023 04:55:18 -0400
Received: from a3.inai.de (a3.inai.de [IPv6:2a01:4f8:10b:45d8::f5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5963419F
        for <netfilter-devel@vger.kernel.org>; Thu, 26 Oct 2023 01:55:12 -0700 (PDT)
Received: by a3.inai.de (Postfix, from userid 65534)
        id D3FF458726694; Thu, 26 Oct 2023 10:55:08 +0200 (CEST)
Received: from a4.inai.de (a4.inai.de [IPv6:2a01:4f8:10b:45d8::f8])
        by a3.inai.de (Postfix) with ESMTP id C4C4858726695;
        Thu, 26 Oct 2023 10:55:06 +0200 (CEST)
From:   Jan Engelhardt <jengelh@inai.de>
To:     netfilter-devel@vger.kernel.org
Cc:     phil@nwl.cc
Subject: [PATCH 09/10] man: use .TP for lists in xt_osf man page
Date:   Thu, 26 Oct 2023 10:55:05 +0200
Message-ID: <20231026085506.94343-9-jengelh@inai.de>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231026085506.94343-1-jengelh@inai.de>
References: <20231026085506.94343-1-jengelh@inai.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Phil Sutter <phil@nwl.cc>

Value and description are more clearly set apart. Using .RS/.RE
pairs also adds proper indenting.

Signed-off-by: Jan Engelhardt <jengelh@inai.de>
---
 extensions/libxt_osf.man | 34 ++++++++++++++++++++++------------
 1 file changed, 22 insertions(+), 12 deletions(-)

diff --git a/extensions/libxt_osf.man b/extensions/libxt_osf.man
index 8bd35554..85c1a3b4 100644
--- a/extensions/libxt_osf.man
+++ b/extensions/libxt_osf.man
@@ -8,24 +8,34 @@ Match an operating system genre by using a passive fingerprinting.
 \fB\-\-ttl\fP \fIlevel\fP
 Do additional TTL checks on the packet to determine the operating system.
 \fIlevel\fP can be one of the following values:
-.IP \(bu 4
-0 - True IP address and fingerprint TTL comparison. This generally works for
+.RS
+.TP
+\fB0\fP
+True IP address and fingerprint TTL comparison. This generally works for
 LANs.
-.IP \(bu 4
-1 - Check if the IP header's TTL is less than the fingerprint one. Works for
+.TP
+\fB1\fP
+Check if the IP header's TTL is less than the fingerprint one. Works for
 globally-routable addresses.
-.IP \(bu 4
-2 - Do not compare the TTL at all.
+.TP
+\fB2\fP
+Do not compare the TTL at all.
+.RE
 .TP
 \fB\-\-log\fP \fIlevel\fP
 Log determined genres into dmesg even if they do not match the desired one.
 \fIlevel\fP can be one of the following values:
-.IP \(bu 4
-0 - Log all matched or unknown signatures
-.IP \(bu 4
-1 - Log only the first one
-.IP \(bu 4
-2 - Log all known matched signatures
+.RS
+.TP
+\fB0\fP
+Log all matched or unknown signatures
+.TP
+\fB1\fP
+Log only the first one
+.TP
+\fB2\fP
+Log all known matched signatures
+.RE
 .PP
 You may find something like this in syslog:
 .PP
-- 
2.42.0

