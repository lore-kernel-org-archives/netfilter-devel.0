Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1F05C25B6F
	for <netfilter-devel@archiver.kernel.org>; Thu, 26 Oct 2023 08:55:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234939AbjJZIzS (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 26 Oct 2023 04:55:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344743AbjJZIzN (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 26 Oct 2023 04:55:13 -0400
Received: from a3.inai.de (a3.inai.de [IPv6:2a01:4f8:10b:45d8::f5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E44C61AA
        for <netfilter-devel@vger.kernel.org>; Thu, 26 Oct 2023 01:55:08 -0700 (PDT)
Received: by a3.inai.de (Postfix, from userid 65534)
        id 734A7587266A4; Thu, 26 Oct 2023 10:55:07 +0200 (CEST)
Received: from a4.inai.de (a4.inai.de [IPv6:2a01:4f8:10b:45d8::f8])
        by a3.inai.de (Postfix) with ESMTP id 7EC955872668A;
        Thu, 26 Oct 2023 10:55:06 +0200 (CEST)
From:   Jan Engelhardt <jengelh@inai.de>
To:     netfilter-devel@vger.kernel.org
Cc:     phil@nwl.cc
Subject: [PATCH 04/10] man: encode hyphens the way groff/man requires it
Date:   Thu, 26 Oct 2023 10:55:00 +0200
Message-ID: <20231026085506.94343-4-jengelh@inai.de>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231026085506.94343-1-jengelh@inai.de>
References: <20231026085506.94343-1-jengelh@inai.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Edit a few spots where indeed a hyphens (U+2010) rather than U+002D is desired.
("set-name" is not something you input, it is a placeholder in the context of
documentation. "out-of-flow" is part of the regular flowed text, so should not
use anything but hyphens.)

Signed-off-by: Jan Engelhardt <jengelh@inai.de>
---
 extensions/libxt_SET.man      | 2 +-
 extensions/libxt_SYNPROXY.man | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/extensions/libxt_SET.man b/extensions/libxt_SET.man
index c4713378..28a0bbe5 100644
--- a/extensions/libxt_SET.man
+++ b/extensions/libxt_SET.man
@@ -25,7 +25,7 @@ one from the set definition
 when adding an entry if it already exists, reset the timeout value
 to the specified one or to the default from the set definition
 .TP
-\fB\-\-map\-set\fP \fIset\-name\fP
+\fB\-\-map\-set\fP \fIset-name\fP
 the set-name should be created with --skbinfo option
 \fB\-\-map\-mark\fP
 map firewall mark to packet by lookup of value in the set
diff --git a/extensions/libxt_SYNPROXY.man b/extensions/libxt_SYNPROXY.man
index 30a71ed2..8b232e85 100644
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

