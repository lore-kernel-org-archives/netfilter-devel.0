Return-Path: <SRS0=ut36=Z4=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A637C43603
	for <netfilter-devel@archiver.kernel.org>; Fri,  6 Dec 2019 11:47:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EAF0821823
	for <netfilter-devel@archiver.kernel.org>; Fri,  6 Dec 2019 11:47:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726313AbfLFLrs (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 6 Dec 2019 06:47:48 -0500
Received: from orbyte.nwl.cc ([151.80.46.58]:34918 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726134AbfLFLrs (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 6 Dec 2019 06:47:48 -0500
Received: from localhost ([::1]:48008 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1idC5L-0002mA-2X; Fri, 06 Dec 2019 12:47:47 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 2/6] extensions: time: Avoid undefined shift
Date:   Fri,  6 Dec 2019 12:47:07 +0100
Message-Id: <20191206114711.6015-3-phil@nwl.cc>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191206114711.6015-1-phil@nwl.cc>
References: <20191206114711.6015-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Value 1 is signed 32-bit by default and left-shifting that by 31 is
undefined. Fix this by marking the value as unsigned.

Fixes: ad326ef9f734a ("Add the libxt_time iptables match")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 extensions/libxt_time.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/extensions/libxt_time.c b/extensions/libxt_time.c
index 5a8cc5de13031..d001f5b7f448f 100644
--- a/extensions/libxt_time.c
+++ b/extensions/libxt_time.c
@@ -330,7 +330,7 @@ static void time_print_monthdays(uint32_t mask, bool human_readable)
 
 	printf(" ");
 	for (i = 1; i <= 31; ++i)
-		if (mask & (1 << i)) {
+		if (mask & (1u << i)) {
 			if (nbdays++ > 0)
 				printf(",");
 			printf("%u", i);
-- 
2.24.0

