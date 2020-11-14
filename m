Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61A9FC4742C
	for <netfilter-devel@archiver.kernel.org>; Sat, 14 Nov 2020 02:23:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 151402225E
	for <netfilter-devel@archiver.kernel.org>; Sat, 14 Nov 2020 02:23:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726116AbgKNCW4 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 13 Nov 2020 21:22:56 -0500
Received: from alexa-out-sd-01.qualcomm.com ([199.106.114.38]:17286 "EHLO
        alexa-out-sd-01.qualcomm.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725981AbgKNCW4 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 13 Nov 2020 21:22:56 -0500
Received: from unknown (HELO ironmsg01-sd.qualcomm.com) ([10.53.140.141])
  by alexa-out-sd-01.qualcomm.com with ESMTP; 13 Nov 2020 18:22:55 -0800
X-QCInternal: smtphost
Received: from stranche-lnx.qualcomm.com ([129.46.14.77])
  by ironmsg01-sd.qualcomm.com with ESMTP; 13 Nov 2020 18:22:55 -0800
Received: by stranche-lnx.qualcomm.com (Postfix, from userid 383980)
        id 32F5B3626; Fri, 13 Nov 2020 18:22:55 -0800 (PST)
From:   Sean Tranchetti <stranche@codeaurora.org>
To:     pablo@netfilter.org, netfilter-devel@vger.kernel.org, fw@strlen.de
Cc:     subashab@codeaurora.org, Sean Tranchetti <stranche@codeaurora.org>
Subject: [PATCH nf] x_tables: Properly close read section with read_seqcount_retry
Date:   Fri, 13 Nov 2020 18:21:56 -0800
Message-Id: <1605320516-17810-1-git-send-email-stranche@codeaurora.org>
X-Mailer: git-send-email 2.7.4
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

xtables uses a modified version of a seqcount lock for synchronization
between replacing private table information and the packet processing
path (i.e. XX_do_table). The main modification is in the "write"
semantics, where instead of adding 1 for each write, the write side will
add 1 only if it finds no other writes ongoing, and adds 1 again (thereby
clearing the LSB) when it finishes.

This allows the read side to avoid calling read_seqcount_begin() in a loop
if a write is detected, since the value is guaranteed to only increment
once all writes have completed. As such, it is only necessary to check if
the initial value of the sequence count has changed to inform the reader
that all writes are finished.

However, the current check for the changed value uses the wrong API;
raw_seqcount_read() is protected by smp_rmb() in the same way as
read_seqcount_begin(), making it appropriate for ENTERING read-side
critical sections, but not exiting them. For that, read_seqcount_rety()
must be used to ensure the proper barrier placement for synchronization
with xt_write_recseq_end() (itself modeled after write_seqcount_end()).

Signed-off-by: Sean Tranchetti <stranche@codeaurora.org>
---
 net/netfilter/x_tables.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/x_tables.c b/net/netfilter/x_tables.c
index af22dbe..39f1f2b 100644
--- a/net/netfilter/x_tables.c
+++ b/net/netfilter/x_tables.c
@@ -1404,7 +1404,7 @@ xt_replace_table(struct xt_table *table,
 			do {
 				cond_resched();
 				cpu_relax();
-			} while (seq == raw_read_seqcount(s));
+			} while (!read_seqcount_retry(s, seq));
 		}
 	}
 
-- 
2.7.4

