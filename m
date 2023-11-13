Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3ACF6C072AB
	for <netfilter-devel@archiver.kernel.org>; Mon, 13 Nov 2023 10:32:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229459AbjKMKc1 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 13 Nov 2023 05:32:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229727AbjKMKc0 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 13 Nov 2023 05:32:26 -0500
Received: from a3.inai.de (a3.inai.de [IPv6:2a01:4f8:10b:45d8::f5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 493AAD75
        for <netfilter-devel@vger.kernel.org>; Mon, 13 Nov 2023 02:32:23 -0800 (PST)
Received: by a3.inai.de (Postfix, from userid 65534)
        id 1AC8958725FE8; Mon, 13 Nov 2023 11:32:17 +0100 (CET)
Received: from a4.inai.de (a4.inai.de [IPv6:2a01:4f8:10b:45d8::f8])
        by a3.inai.de (Postfix) with ESMTP id 0438E58725FE9
        for <netfilter-devel@vger.kernel.org>; Mon, 13 Nov 2023 11:32:15 +0100 (CET)
From:   Jan Engelhardt <jengelh@inai.de>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH 6/7] man: limit targets for -P option synopsis
Date:   Mon, 13 Nov 2023 11:30:11 +0100
Message-ID: <20231113103156.57745-7-jengelh@inai.de>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231113103156.57745-1-jengelh@inai.de>
References: <20231113103156.57745-1-jengelh@inai.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Do not suggest that -P could be used with arbitrary targets.

Signed-off-by: Jan Engelhardt <jengelh@inai.de>
---
 iptables/arptables-nft.8 | 2 +-
 iptables/iptables.8.in   | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/iptables/arptables-nft.8 b/iptables/arptables-nft.8
index 8b403ee8..444b0015 100644
--- a/iptables/arptables-nft.8
+++ b/iptables/arptables-nft.8
@@ -42,7 +42,7 @@ rule-specification\fP
 .PP
 \fBarptables\fP [\fB\-t\fP \fItable\fP] \fB\-X\fP [\fIchain\fP]
 .PP
-\fBarptables\fP [\fB\-t\fP \fItable\fP] \fB\-P\fP \fIchain target\fP
+\fBarptables\fP [\fB\-t\fP \fItable\fP] \fB\-P\fP \fIchain policy\fP
 .PP
 \fBarptables\fP [\fB\-t\fP \fItable\fP] \fB\-E\fP \fIold-chain-name
 new-chain-name\fP
diff --git a/iptables/iptables.8.in b/iptables/iptables.8.in
index 90417e89..21fb891d 100644
--- a/iptables/iptables.8.in
+++ b/iptables/iptables.8.in
@@ -45,7 +45,7 @@ iptables/ip6tables \(em administration tool for IPv4/IPv6 packet filtering and N
 .PP
 \fBiptables\fP [\fB\-t\fP \fItable\fP] \fB\-X\fP [\fIchain\fP]
 .PP
-\fBiptables\fP [\fB\-t\fP \fItable\fP] \fB\-P\fP \fIchain target\fP
+\fBiptables\fP [\fB\-t\fP \fItable\fP] \fB\-P\fP \fIchain policy\fP
 .PP
 \fBiptables\fP [\fB\-t\fP \fItable\fP] \fB\-E\fP \fIold-chain-name new-chain-name\fP
 .PP
-- 
2.42.1

