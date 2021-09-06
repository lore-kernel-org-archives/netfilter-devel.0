Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A35DAC433F5
	for <netfilter-devel@archiver.kernel.org>; Mon,  6 Sep 2021 11:20:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8A3FF60F9E
	for <netfilter-devel@archiver.kernel.org>; Mon,  6 Sep 2021 11:20:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241004AbhIFLVg (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 6 Sep 2021 07:21:36 -0400
Received: from mail.netfilter.org ([217.70.188.207]:39438 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237040AbhIFLVg (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 6 Sep 2021 07:21:36 -0400
Received: from localhost.localdomain (unknown [78.30.35.141])
        by mail.netfilter.org (Postfix) with ESMTPSA id D16FE6001D
        for <netfilter-devel@vger.kernel.org>; Mon,  6 Sep 2021 13:19:24 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft] doc: refer to ulogd manpage
Date:   Mon,  6 Sep 2021 13:20:26 +0200
Message-Id: <20210906112026.14526-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Refer to the ulogd daemon in the log statement section.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 doc/statements.txt | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/doc/statements.txt b/doc/statements.txt
index 6c4ba4f7e2b5..646311d19831 100644
--- a/doc/statements.txt
+++ b/doc/statements.txt
@@ -95,8 +95,9 @@ dmesg(1) or read in the syslog).
 In the second form of invocation (if 'nflog_group' is specified), the Linux
 kernel will pass the packet to nfnetlink_log which will multicast the packet
 through a netlink socket to the specified multicast group. One or more userspace
-processes may subscribe to the group to receive the packets, see
-libnetfilter_log documentation for details.
+processes may subscribe to the group to receive the packets, see man(8) ulogd
+for the Netfilter userspace log daemon and libnetfilter_log documentation for
+details in case you would like to develop a custom program to digest your logs.
 
 In the third form of invocation (if level audit is specified), the Linux
 kernel writes a message into the audit buffer suitably formatted for reading
-- 
2.20.1

