Return-Path: <SRS0=49hf=R5=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2D57C43381
	for <netfilter-devel@archiver.kernel.org>; Tue, 26 Mar 2019 18:03:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9FD6F2082F
	for <netfilter-devel@archiver.kernel.org>; Tue, 26 Mar 2019 18:03:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732193AbfCZSDr (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 26 Mar 2019 14:03:47 -0400
Received: from orbyte.nwl.cc ([151.80.46.58]:52896 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731940AbfCZSDr (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 26 Mar 2019 14:03:47 -0400
Received: from localhost ([::1]:37754 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1h8qQL-0006MG-4o; Tue, 26 Mar 2019 19:03:45 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH] man: iptables-save: Add note about module autoloading
Date:   Tue, 26 Mar 2019 19:03:43 +0100
Message-Id: <20190326180343.4253-1-phil@nwl.cc>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Using '-t' parameter in iptables-save might lead to kernel module
loading, just like with iptables itself. Copy the hint from iptables.8
to inform users.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/iptables-save.8.in | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/iptables/iptables-save.8.in b/iptables/iptables-save.8.in
index 51e11f3e7adca..29ef2829fb330 100644
--- a/iptables/iptables-save.8.in
+++ b/iptables/iptables-save.8.in
@@ -48,8 +48,11 @@ will log to STDOUT.
 include the current values of all packet and byte counters in the output
 .TP
 \fB\-t\fR, \fB\-\-table\fR \fItablename\fP
-restrict output to only one table. If not specified, output includes all
-available tables.
+restrict output to only one table. If the kernel is configured with automatic
+module loading, an attempt will be made to load the appropriate module for
+that table if it is not already there.
+.br
+If not specified, output includes all available tables.
 .SH BUGS
 None known as of iptables-1.2.1 release
 .SH AUTHORS
-- 
2.21.0

