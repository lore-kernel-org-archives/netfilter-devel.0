Return-Path: <SRS0=n11Q=TD=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC55BC43219
	for <netfilter-devel@archiver.kernel.org>; Fri,  3 May 2019 10:39:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C6D7F2081C
	for <netfilter-devel@archiver.kernel.org>; Fri,  3 May 2019 10:39:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726546AbfECKjq (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 3 May 2019 06:39:46 -0400
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:50502 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726267AbfECKjq (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 3 May 2019 06:39:46 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.89)
        (envelope-from <fw@breakpoint.cc>)
        id 1hMVbU-0002oK-5g; Fri, 03 May 2019 12:39:44 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH iptables] extensions: SYNPROXY: should not be needed anymore on current kernels
Date:   Fri,  3 May 2019 12:35:38 +0200
Message-Id: <20190503103538.3426-1-fw@strlen.de>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

SYN packets do not require taking the listener socket lock anymore
as of 4.4 kernel, i.e. this target should not be needed anymore.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 extensions/libxt_SYNPROXY.man | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/extensions/libxt_SYNPROXY.man b/extensions/libxt_SYNPROXY.man
index 25325fc284ae..30a71ed2d6a5 100644
--- a/extensions/libxt_SYNPROXY.man
+++ b/extensions/libxt_SYNPROXY.man
@@ -1,6 +1,8 @@
 This target will process TCP three-way-handshake parallel in netfilter
 context to protect either local or backend system. This target requires
 connection tracking because sequence numbers need to be translated.
+The kernels ability to absorb SYNFLOOD was greatly improved starting with
+Linux 4.4, so this target should not be needed anymore to protect Linux servers.
 .TP
 \fB\-\-mss\fP \fImaximum segment size\fP
 Maximum segment size announced to clients. This must match the backend.
-- 
2.21.0

