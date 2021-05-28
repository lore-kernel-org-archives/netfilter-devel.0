Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35FF7C4708C
	for <netfilter-devel@archiver.kernel.org>; Fri, 28 May 2021 12:38:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 09A2C611C2
	for <netfilter-devel@archiver.kernel.org>; Fri, 28 May 2021 12:37:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234367AbhE1Mjb (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 28 May 2021 08:39:31 -0400
Received: from mail.netfilter.org ([217.70.188.207]:52964 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235827AbhE1Miq (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 28 May 2021 08:38:46 -0400
Received: from localhost.localdomain (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id CEBB2644BC
        for <netfilter-devel@vger.kernel.org>; Fri, 28 May 2021 14:36:07 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH conntrackd] cthelper: fix overlapping queue numbers in example file
Date:   Fri, 28 May 2021 14:37:03 +0200
Message-Id: <20210528123703.147023-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Userspace helpers cannot have overlapping queue number, update the
example file to fix the existing overlap.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 doc/helper/conntrackd.conf | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/doc/helper/conntrackd.conf b/doc/helper/conntrackd.conf
index cbcb284aa92d..efa318a36b2d 100644
--- a/doc/helper/conntrackd.conf
+++ b/doc/helper/conntrackd.conf
@@ -83,7 +83,7 @@ Helper {
 		}
 	}
 	Type mdns inet udp {
-		QueueNum 6
+		QueueNum 5
 		QueueLen 10240
 		Policy mdns {
 			ExpectMax 8
@@ -91,7 +91,7 @@ Helper {
 		}
 	}
 	Type ssdp inet udp {
-		QueueNum 5
+		QueueNum 6
 		QueueLen 10240
 		Policy ssdp {
 			ExpectMax 8
@@ -99,7 +99,7 @@ Helper {
 		}
 	}
 	Type ssdp inet tcp {
-		QueueNum 5
+		QueueNum 7
 		QueueLen 10240
 		Policy ssdp {
 			ExpectMax 8
@@ -107,7 +107,7 @@ Helper {
 		}
 	}
 	Type slp inet udp {
-		QueueNum 7
+		QueueNum 8
 		QueueLen 10240
 		Policy slp {
 			ExpectMax 8
-- 
2.30.2

