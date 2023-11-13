Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0CA87C04E83
	for <netfilter-devel@archiver.kernel.org>; Mon, 13 Nov 2023 10:32:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229602AbjKMKc1 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 13 Nov 2023 05:32:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbjKMKc0 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 13 Nov 2023 05:32:26 -0500
Received: from a3.inai.de (a3.inai.de [IPv6:2a01:4f8:10b:45d8::f5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 418A0CB
        for <netfilter-devel@vger.kernel.org>; Mon, 13 Nov 2023 02:32:23 -0800 (PST)
Received: by a3.inai.de (Postfix, from userid 65534)
        id 0AAE958725FE7; Mon, 13 Nov 2023 11:32:17 +0100 (CET)
Received: from a4.inai.de (a4.inai.de [IPv6:2a01:4f8:10b:45d8::f8])
        by a3.inai.de (Postfix) with ESMTP id EB2D058725FE8
        for <netfilter-devel@vger.kernel.org>; Mon, 13 Nov 2023 11:32:14 +0100 (CET)
From:   Jan Engelhardt <jengelh@inai.de>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH 5/7] man: copy synopsis markup from iptables.8 to arptables-nft.8
Date:   Mon, 13 Nov 2023 11:30:10 +0100
Message-ID: <20231113103156.57745-6-jengelh@inai.de>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231113103156.57745-1-jengelh@inai.de>
References: <20231113103156.57745-1-jengelh@inai.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Signed-off-by: Jan Engelhardt <jengelh@inai.de>
---
 iptables/arptables-nft.8 | 42 ++++++++++++++++++++++++++--------------
 1 file changed, 28 insertions(+), 14 deletions(-)

diff --git a/iptables/arptables-nft.8 b/iptables/arptables-nft.8
index 84775a86..8b403ee8 100644
--- a/iptables/arptables-nft.8
+++ b/iptables/arptables-nft.8
@@ -24,20 +24,34 @@
 .SH NAME
 arptables \(em ARP table administration (nft-based)
 .SH SYNOPSIS
-.BR "arptables " [ "-t table" ] " -" [ AD ] " chain rule-specification " [ options ]
-.br
-.BR "arptables " [ "-t table" ] " -" [ RI ] " chain rulenum rule-specification " [ options ]
-.br
-.BR "arptables " [ "-t table" ] " -D chain rulenum " [ options ]
-.br
-.BR "arptables " [ "-t table" ] " -" [ "LFZ" ] " " [ chain ] " " [ options ]
-.br
-.BR "arptables " [ "-t table" ] " -" [ "NX" ] " chain"
-.br
-.BR "arptables " [ "-t table" ] " -E old-chain-name new-chain-name"
-.br
-.BR "arptables " [ "-t table" ] " -P chain target " [ options ]
-
+\fBarptables\fP [\fB\-t\fP \fItable\fP] {\fB\-A|\-D\fP} \fIchain\fP
+\fIrule-specification\fP [options...]
+.PP
+\fBarptables\fP [\fB\-t\fP \fItable\fP] \fB\-I\fP \fIchain\fP [\fIrulenum\fP]
+\fIrule-specification\fP
+.PP
+\fBarptables\fP [\fB\-t\fP \fItable\fP] \fB\-R\fP \fIchain rulenum
+rule-specification\fP
+.PP
+\fBarptables\fP [\fB\-t\fP \fItable\fP] \fB\-D\fP \fIchain rulenum\fP
+.PP
+\fBarptables\fP [\fB\-t\fP \fItable\fP] {\fB\-F\fP|\fB\-L\fP|\fB\-Z\fP}
+[\fIchain\fP [\fIrulenum\fP]] [\fIoptions...\fP]
+.PP
+\fBarptables\fP [\fB\-t\fP \fItable\fP] \fB\-N\fP \fIchain\fP
+.PP
+\fBarptables\fP [\fB\-t\fP \fItable\fP] \fB\-X\fP [\fIchain\fP]
+.PP
+\fBarptables\fP [\fB\-t\fP \fItable\fP] \fB\-P\fP \fIchain target\fP
+.PP
+\fBarptables\fP [\fB\-t\fP \fItable\fP] \fB\-E\fP \fIold-chain-name
+new-chain-name\fP
+.PP
+rule-specification := [matches...] [target]
+.PP
+match := \fB\-m\fP \fImatchname\fP [per-match-options]
+.PP
+target := \fB\-j\fP \fItargetname\fP [per-target-options]
 .SH DESCRIPTION
 .B arptables
 is a user space tool, it is used to set up and maintain the
-- 
2.42.1

