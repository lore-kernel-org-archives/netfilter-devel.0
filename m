Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E301C433EF
	for <netfilter-devel@archiver.kernel.org>; Mon,  6 Sep 2021 20:34:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F1B7361077
	for <netfilter-devel@archiver.kernel.org>; Mon,  6 Sep 2021 20:34:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229766AbhIFUgB (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 6 Sep 2021 16:36:01 -0400
Received: from mail.netfilter.org ([217.70.188.207]:40338 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229717AbhIFUgA (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 6 Sep 2021 16:36:00 -0400
Received: from localhost.localdomain (unknown [78.30.35.141])
        by mail.netfilter.org (Postfix) with ESMTPSA id 486506001B
        for <netfilter-devel@vger.kernel.org>; Mon,  6 Sep 2021 22:33:50 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft] doc: nfnetlink_log allows one single process through unicast
Date:   Mon,  6 Sep 2021 22:34:50 +0200
Message-Id: <20210906203450.30891-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

nfnetlink_log uses netlink unicast to send logs to one single process in
userspace.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 doc/statements.txt | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/doc/statements.txt b/doc/statements.txt
index 646311d19831..d402da7061a1 100644
--- a/doc/statements.txt
+++ b/doc/statements.txt
@@ -93,11 +93,11 @@ packets, such as header fields, via the kernel log (where it can be read with
 dmesg(1) or read in the syslog).
 
 In the second form of invocation (if 'nflog_group' is specified), the Linux
-kernel will pass the packet to nfnetlink_log which will multicast the packet
-through a netlink socket to the specified multicast group. One or more userspace
-processes may subscribe to the group to receive the packets, see man(8) ulogd
-for the Netfilter userspace log daemon and libnetfilter_log documentation for
-details in case you would like to develop a custom program to digest your logs.
+kernel will pass the packet to nfnetlink_log which will send the log through a
+netlink socket to the specified group. One userspace process may subscribe to
+the group to receive the logs, see man(8) ulogd for the Netfilter userspace log
+daemon and libnetfilter_log documentation for details in case you would like to
+develop a custom program to digest your logs.
 
 In the third form of invocation (if level audit is specified), the Linux
 kernel writes a message into the audit buffer suitably formatted for reading
-- 
2.20.1

