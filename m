Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8DC9C04E83
	for <netfilter-devel@archiver.kernel.org>; Mon, 13 Nov 2023 10:44:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229480AbjKMKoI (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 13 Nov 2023 05:44:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229746AbjKMKoH (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 13 Nov 2023 05:44:07 -0500
Received: from a3.inai.de (a3.inai.de [IPv6:2a01:4f8:10b:45d8::f5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDC9710D2
        for <netfilter-devel@vger.kernel.org>; Mon, 13 Nov 2023 02:44:03 -0800 (PST)
Received: by a3.inai.de (Postfix, from userid 65534)
        id 8444B587270B6; Mon, 13 Nov 2023 11:44:02 +0100 (CET)
Received: from a4.inai.de (a4.inai.de [IPv6:2a01:4f8:10b:45d8::f8])
        by a3.inai.de (Postfix) with ESMTP id 439D058725FD8
        for <netfilter-devel@vger.kernel.org>; Mon, 13 Nov 2023 11:44:02 +0100 (CET)
From:   Jan Engelhardt <jengelh@inai.de>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH 3/7] man: layout and colorize synopsis similar to iptables
Date:   Mon, 13 Nov 2023 11:43:08 +0100
Message-ID: <20231113104357.59087-4-jengelh@inai.de>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231113104357.59087-1-jengelh@inai.de>
References: <20231113104357.59087-1-jengelh@inai.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Signed-off-by: Jan Engelhardt <jengelh@inai.de>
---
 ebtables-legacy.8.in | 57 +++++++++++++++++++++++++-------------------
 1 file changed, 32 insertions(+), 25 deletions(-)

diff --git a/ebtables-legacy.8.in b/ebtables-legacy.8.in
index c12f737..2a8e7ad 100644
--- a/ebtables-legacy.8.in
+++ b/ebtables-legacy.8.in
@@ -26,31 +26,38 @@
 .SH NAME
 ebtables-legacy \(em Ethernet bridge frame table administration (@PACKAGE_VERSION@)
 .SH SYNOPSIS
-.BR "ebtables " [ -t " table ] " - [ ACDI "] chain rule specification [match extensions] [watcher extensions] target"
-.br
-.BR "ebtables " [ -t " table ] " -P " chain " ACCEPT " | " DROP " | " RETURN
-.br
-.BR "ebtables " [ -t " table ] " -F " [chain]"
-.br
-.BR "ebtables " [ -t " table ] " -Z " [chain]"
-.br
-.BR "ebtables " [ -t " table ] " -L " [" -Z "] [chain] [ [" --Ln "] | [" --Lx "] ] [" --Lc "] [" --Lmac2 ]
-.br
-.BR "ebtables " [ -t " table ] " -N " chain [" "-P ACCEPT " | " DROP " | " RETURN" ]
-.br
-.BR "ebtables " [ -t " table ] " -X " [chain]"
-.br
-.BR "ebtables " [ -t " table ] " -E " old-chain-name new-chain-name"
-.br
-.BR "ebtables " [ -t " table ] " --init-table
-.br
-.BR "ebtables " [ -t " table ] [" --atomic-file " file] " --atomic-commit
-.br
-.BR "ebtables " [ -t " table ] [" --atomic-file " file] " --atomic-init
-.br
-.BR "ebtables " [ -t " table ] [" --atomic-file " file] " --atomic-save
-.br
-
+\fBebtables\fP [\fB\-t\fP \fItable\fP] {\fB\-A\fP|\fB\-C\fP|\fB\-D\fP}
+\fIchain\fP \fIrule-specification\fP
+.PP
+\fBebtables\fP [\fB\-t\fP \fItable\fP] \fB\-I\fP \fIchain\fP [\fIrulenum\fP]
+\fIrule-specification\fP
+.PP
+\fBebtables\fP [\fB\-t\fP \fItable\fP] \fB\-D\fP \fIchain rulenum\fP
+.PP
+\fBebtables\fP [\fB\-t\fP \fItable\fP] {\fB\-F\fP|\fB\-Z\fP} [\fIchain\fP
+[\fIrulenum\fP]]
+.PP
+\fBebtables\fP [\fB\-t\fP \fItable\fP] \fB\-L\fP [\fB\-\-Lc\fP]
+[\fB\-\-Lmac2\fP] [\fB\-\-Ln\fP] [\fB\-\-Lx\fP] [\fIchain\fP [\fIrulenum\fP]]
+.PP
+\fBebtables\fP [\fB\-t\fP \fItable\fP] \fB\-N\fP \fIchain\fP [\fB\-P\fP
+\fIpolicy\fP]
+.PP
+\fBebtables\fP [\fB\-t\fP \fItable\fP] \fB\-X\fP [\fIchain\fP]
+.PP
+\fBebtables\fP [\fB\-t\fP \fItable\fP] \fB\-P\fP \fIchain policy\fP
+.PP
+\fBebtables\fP [\fB\-t\fP \fItable\fP] \fB\-E\fP \fIold-chain-name
+new-chain-name\fP
+.PP
+\fBebtables\fP [\fB\-t\fP \fItable\fP] \fB\-\-init-table\fP
+.PP
+\fBebtables\fP [\fB\-t\fP \fItable\fP] [\fB\-\-atomic\-file\fP \fIfile\fP]
+{\fB\-\-atomic\-commit\fP|\fB\-\-atomic\-init\fP|\fB\-\-atomic\-save\fP}
+.PP
+rule-specification := [match-options] [watcher-options] [target]
+.PP
+target := \fB\-j\fP \fItargetname\fP [target-options]
 .SH LEGACY
 This tool uses the old xtables/setsockopt framework, and is a legacy version
 of ebtables. That means that a new, more modern tool exists with the same
-- 
2.42.1

