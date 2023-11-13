Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9BCB7C05021
	for <netfilter-devel@archiver.kernel.org>; Mon, 13 Nov 2023 10:32:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229633AbjKMKc0 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 13 Nov 2023 05:32:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229602AbjKMKcZ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 13 Nov 2023 05:32:25 -0500
Received: from a3.inai.de (a3.inai.de [IPv6:2a01:4f8:10b:45d8::f5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 831DAD78
        for <netfilter-devel@vger.kernel.org>; Mon, 13 Nov 2023 02:32:20 -0800 (PST)
Received: by a3.inai.de (Postfix, from userid 65534)
        id CFAB658725FCB; Mon, 13 Nov 2023 11:32:16 +0100 (CET)
Received: from a4.inai.de (a4.inai.de [IPv6:2a01:4f8:10b:45d8::f8])
        by a3.inai.de (Postfix) with ESMTP id C2D2058725FD6
        for <netfilter-devel@vger.kernel.org>; Mon, 13 Nov 2023 11:32:14 +0100 (CET)
From:   Jan Engelhardt <jengelh@inai.de>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH 2/7] man: remove lone .nh command
Date:   Mon, 13 Nov 2023 11:30:07 +0100
Message-ID: <20231113103156.57745-3-jengelh@inai.de>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231113103156.57745-1-jengelh@inai.de>
References: <20231113103156.57745-1-jengelh@inai.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

No other manpage files use .nh, and I cannot see a reason
iptables-apply would exceptionally need it.

Signed-off-by: Jan Engelhardt <jengelh@inai.de>
---
 iptables/iptables-apply.8.in | 2 --
 1 file changed, 2 deletions(-)

diff --git a/iptables/iptables-apply.8.in b/iptables/iptables-apply.8.in
index 5485199c..33fd79fe 100644
--- a/iptables/iptables-apply.8.in
+++ b/iptables/iptables-apply.8.in
@@ -3,8 +3,6 @@
 .\"      Date: May 10, 2010
 .\"
 .TH IPTABLES\-APPLY 8 "" "@PACKAGE_STRING@" "@PACKAGE_STRING@"
-.\" disable hyphenation
-.nh
 .SH NAME
 iptables-apply \(em a safer way to update iptables remotely
 .SH SYNOPSIS
-- 
2.42.1

