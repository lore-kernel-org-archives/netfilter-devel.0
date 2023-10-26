Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1912BC25B70
	for <netfilter-devel@archiver.kernel.org>; Thu, 26 Oct 2023 08:55:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344709AbjJZIzU (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 26 Oct 2023 04:55:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234863AbjJZIzS (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 26 Oct 2023 04:55:18 -0400
Received: from a3.inai.de (a3.inai.de [IPv6:2a01:4f8:10b:45d8::f5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BECB21B4
        for <netfilter-devel@vger.kernel.org>; Thu, 26 Oct 2023 01:55:11 -0700 (PDT)
Received: by a3.inai.de (Postfix, from userid 65534)
        id 779CB587266A6; Thu, 26 Oct 2023 10:55:08 +0200 (CEST)
Received: from a4.inai.de (a4.inai.de [IPv6:2a01:4f8:10b:45d8::f8])
        by a3.inai.de (Postfix) with ESMTP id 9BC595872668E;
        Thu, 26 Oct 2023 10:55:06 +0200 (CEST)
From:   Jan Engelhardt <jengelh@inai.de>
To:     netfilter-devel@vger.kernel.org
Cc:     phil@nwl.cc
Subject: [PATCH 06/10] man: consistent casing of "IPv[46]"
Date:   Thu, 26 Oct 2023 10:55:02 +0200
Message-ID: <20231026085506.94343-6-jengelh@inai.de>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231026085506.94343-1-jengelh@inai.de>
References: <20231026085506.94343-1-jengelh@inai.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Signed-off-by: Jan Engelhardt <jengelh@inai.de>
---
 extensions/libipt_ULOG.man     | 2 +-
 extensions/libxt_connlimit.man | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/extensions/libipt_ULOG.man b/extensions/libipt_ULOG.man
index c828b45e..eb37d4fb 100644
--- a/extensions/libipt_ULOG.man
+++ b/extensions/libipt_ULOG.man
@@ -1,4 +1,4 @@
-This is the deprecated ipv4-only predecessor of the NFLOG target.
+This is the deprecated IPv4-only predecessor of the NFLOG target.
 It provides userspace logging of matching packets.  When this
 target is set for a rule, the Linux kernel will multicast this packet
 through a
diff --git a/extensions/libxt_connlimit.man b/extensions/libxt_connlimit.man
index 2292e9cc..980bf6c5 100644
--- a/extensions/libxt_connlimit.man
+++ b/extensions/libxt_connlimit.man
@@ -33,7 +33,7 @@ iptables \-p tcp \-\-syn \-\-dport 80 \-m connlimit \-\-connlimit\-above 16
 \-\-connlimit\-mask 24 \-j REJECT
 .TP
 # limit the number of parallel HTTP requests to 16 for the link local network
-(ipv6)
+(IPv6)
 ip6tables \-p tcp \-\-syn \-\-dport 80 \-s fe80::/64 \-m connlimit \-\-connlimit\-above
 16 \-\-connlimit\-mask 64 \-j REJECT
 .TP
-- 
2.42.0

