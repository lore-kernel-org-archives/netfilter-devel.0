Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB14EC4167D
	for <netfilter-devel@archiver.kernel.org>; Mon, 13 Nov 2023 10:44:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229459AbjKMKoH (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 13 Nov 2023 05:44:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229480AbjKMKoG (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 13 Nov 2023 05:44:06 -0500
Received: from a3.inai.de (a3.inai.de [IPv6:2a01:4f8:10b:45d8::f5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA2FC10CC
        for <netfilter-devel@vger.kernel.org>; Mon, 13 Nov 2023 02:44:03 -0800 (PST)
Received: by a3.inai.de (Postfix, from userid 65534)
        id 5E63658725FE8; Mon, 13 Nov 2023 11:44:02 +0100 (CET)
Received: from a4.inai.de (a4.inai.de [IPv6:2a01:4f8:10b:45d8::f8])
        by a3.inai.de (Postfix) with ESMTP id 28A1A58725FCB
        for <netfilter-devel@vger.kernel.org>; Mon, 13 Nov 2023 11:44:02 +0100 (CET)
From:   Jan Engelhardt <jengelh@inai.de>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH 1/7] man: make TH word match Name line
Date:   Mon, 13 Nov 2023 11:43:06 +0100
Message-ID: <20231113104357.59087-2-jengelh@inai.de>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231113104357.59087-1-jengelh@inai.de>
References: <20231113104357.59087-1-jengelh@inai.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The .TH first argument needs to match all the words preceding
the first dash in the Name section for mandb(8) to recognize
the summary (and for apropos(1) to then show it).

Before:

$ apropos ebtables
ebtables-legacy (8)  - (unknown subject)

After:

$ apropos ebtables
ebtables-legacy (8)  - Ethernet bridge frame table administration (legacy)

Signed-off-by: Jan Engelhardt <jengelh@inai.de>
---
 ebtables-legacy.8.in | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/ebtables-legacy.8.in b/ebtables-legacy.8.in
index 3417045..762ff67 100644
--- a/ebtables-legacy.8.in
+++ b/ebtables-legacy.8.in
@@ -1,4 +1,4 @@
-.TH EBTABLES 8  "@PACKAGE_DATE@"
+.TH EBTABLES-LEGACY 8 "@PACKAGE_DATE@"
 .\"
 .\" Man page written by Bart De Schuymer <bdschuym@pandora.be>
 .\" It is based on the iptables man page.
@@ -24,7 +24,7 @@
 .\"     
 .\"
 .SH NAME
-ebtables-legacy (@PACKAGE_VERSION@) \- Ethernet bridge frame table administration (legacy)
+ebtables-legacy \- Ethernet bridge frame table administration (@PACKAGE_VERSION@)
 .SH SYNOPSIS
 .BR "ebtables " [ -t " table ] " - [ ACDI "] chain rule specification [match extensions] [watcher extensions] target"
 .br
-- 
2.42.1

