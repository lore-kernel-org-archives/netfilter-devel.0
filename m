Return-Path: <SRS0=htyh=TJ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_NEOMUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9359AC04AB1
	for <netfilter-devel@archiver.kernel.org>; Thu,  9 May 2019 21:59:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6DF7C21479
	for <netfilter-devel@archiver.kernel.org>; Thu,  9 May 2019 21:59:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726790AbfEIV7p (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 9 May 2019 17:59:45 -0400
Received: from peace.netnation.com ([204.174.223.2]:45418 "EHLO
        peace.netnation.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726701AbfEIV7o (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 9 May 2019 17:59:44 -0400
X-Greylist: delayed 1077 seconds by postgrey-1.27 at vger.kernel.org; Thu, 09 May 2019 17:59:44 EDT
Received: from sim by peace.netnation.com with local (Exim 4.89)
        (envelope-from <sim@hostway.ca>)
        id 1hOqnS-0000Zl-9l; Thu, 09 May 2019 14:41:46 -0700
Date:   Thu, 9 May 2019 14:41:46 -0700
From:   Simon Kirby <sim@hostway.ca>
To:     netfilter-devel@vger.kernel.org
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [conntrack-tools PATCH] sync-mode: Also cancel flush timer in
 ALL_FLUSH_CACHE
Message-ID: <20190509214146.wvrhwzq7p4woakci@hostway.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This makes the behaviour of "conntrackd -f" match that of "conntrackd
-f internal" with resepect to stopping a timer ("conntrackd -t") from
possibly flushing again in the future.

Signed-off-by: Simon Kirby <sim@hostway.ca>
---
 src/sync-mode.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/src/sync-mode.c b/src/sync-mode.c
index 082e2ce..29bedd6 100644
--- a/src/sync-mode.c
+++ b/src/sync-mode.c
@@ -708,6 +708,8 @@ static int local_handler_sync(int fd, int type, void *data)
 				      "commit still in progress");
 			break;
 		}
+		/* inmediate flush, remove pending flush scheduled if any */
+		del_alarm(&STATE_SYNC(reset_cache_alarm));
 		dlog(LOG_NOTICE, "flushing caches");
 		STATE(mode)->internal->ct.flush();
 		STATE_SYNC(external)->ct.flush();
-- 
2.20.1
