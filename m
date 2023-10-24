Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F66FC25B48
	for <netfilter-devel@archiver.kernel.org>; Tue, 24 Oct 2023 13:19:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234285AbjJXNTY (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 24 Oct 2023 09:19:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234262AbjJXNTY (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 24 Oct 2023 09:19:24 -0400
Received: from a3.inai.de (a3.inai.de [IPv6:2a01:4f8:10b:45d8::f5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A37F8E8
        for <netfilter-devel@vger.kernel.org>; Tue, 24 Oct 2023 06:19:21 -0700 (PDT)
Received: by a3.inai.de (Postfix, from userid 65534)
        id 2E94658783417; Tue, 24 Oct 2023 15:19:20 +0200 (CEST)
Received: from a4.inai.de (a4.inai.de [IPv6:2a01:4f8:10b:45d8::f8])
        by a3.inai.de (Postfix) with ESMTP id 7A82A58783FC6
        for <netfilter-devel@vger.kernel.org>; Tue, 24 Oct 2023 15:19:19 +0200 (CEST)
From:   Jan Engelhardt <jengelh@inai.de>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH 3/6] man: encode hyphens the way groff/man requires it
Date:   Tue, 24 Oct 2023 15:19:16 +0200
Message-ID: <20231024131919.28665-3-jengelh@inai.de>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231024131919.28665-1-jengelh@inai.de>
References: <20231024131919.28665-1-jengelh@inai.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Here is one instance in SYNPROXY.man where we want hyphens (U+2010)
rather than U+002D.
---
 extensions/libxt_SYNPROXY.man | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/extensions/libxt_SYNPROXY.man b/extensions/libxt_SYNPROXY.man
index 521a1d28..bc2b3eec 100644
--- a/extensions/libxt_SYNPROXY.man
+++ b/extensions/libxt_SYNPROXY.man
@@ -40,7 +40,7 @@ telnet 192.0.2.42 80
 .br
     length 0
 .PP
-Switch tcp_loose mode off, so conntrack will mark out\-of\-flow
+Switch tcp_loose mode off, so conntrack will mark out-of-flow
 packets as state INVALID.
 .IP
 echo 0 > /proc/sys/net/netfilter/nf_conntrack_tcp_loose
-- 
2.42.0

