Return-Path: <SRS0=37uZ=Q4=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09A59C43381
	for <netfilter-devel@archiver.kernel.org>; Thu, 21 Feb 2019 14:38:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D738E2084D
	for <netfilter-devel@archiver.kernel.org>; Thu, 21 Feb 2019 14:38:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728727AbfBUOil (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 21 Feb 2019 09:38:41 -0500
Received: from orbyte.nwl.cc ([151.80.46.58]:59850 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728705AbfBUOil (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 21 Feb 2019 09:38:41 -0500
Received: from localhost ([::1]:44708 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1gwpUl-0003hv-E8; Thu, 21 Feb 2019 15:38:39 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH] extensions: AUDIT: Document ineffective --type option
Date:   Thu, 21 Feb 2019 15:38:47 +0100
Message-Id: <20190221143847.28821-1-phil@nwl.cc>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 extensions/libxt_AUDIT.man | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/extensions/libxt_AUDIT.man b/extensions/libxt_AUDIT.man
index cd796967c431a..4f5562e8ca425 100644
--- a/extensions/libxt_AUDIT.man
+++ b/extensions/libxt_AUDIT.man
@@ -3,12 +3,14 @@ It can be used to record accepted, dropped, and rejected packets. See
 auditd(8) for additional details.
 .TP
 \fB\-\-type\fP {\fBaccept\fP|\fBdrop\fP|\fBreject\fP}
-Set type of audit record.
+Set type of audit record. Starting with linux-4.12, this option has no effect
+on generated audit messages anymore. It is still accepted by iptables for
+compatibility reasons, but ignored.
 .PP
 Example:
 .IP
 iptables \-N AUDIT_DROP
 .IP
-iptables \-A AUDIT_DROP \-j AUDIT \-\-type drop
+iptables \-A AUDIT_DROP \-j AUDIT
 .IP
 iptables \-A AUDIT_DROP \-j DROP
-- 
2.20.1

