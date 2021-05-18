Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0A11C433ED
	for <netfilter-devel@archiver.kernel.org>; Tue, 18 May 2021 12:34:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A7E706124C
	for <netfilter-devel@archiver.kernel.org>; Tue, 18 May 2021 12:34:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243977AbhERMfo (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 18 May 2021 08:35:44 -0400
Received: from mail.netfilter.org ([217.70.188.207]:42770 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243361AbhERMfm (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 18 May 2021 08:35:42 -0400
Received: from localhost.localdomain (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id 084AA6415E
        for <netfilter-devel@vger.kernel.org>; Tue, 18 May 2021 14:33:27 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nftables 1/2] src: use PRIu64 format
Date:   Tue, 18 May 2021 14:34:17 +0200
Message-Id: <20210518123418.64560-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Fix the following compilation warnings on x86_32.

datatype.c: In function ‘cgroupv2_type_print’:
datatype.c:1387:22: warning: format ‘%lu’ expects argument of type ‘long unsigned int’, but argument 3 has type ‘uint64_t’ {aka ‘long long unsigned int’} [-Wformat=]
   nft_print(octx, "%lu", id);
                    ~~^   ~~
                    %llu

meta.c: In function ‘date_type_print’:
meta.c:411:21: warning: format ‘%lu’ expects argument of type ‘long unsigned int’, but argument 3 has type ‘uint64_t’ {aka ‘long long unsigned int’} [-Wformat=]
  nft_print(octx, "%lu", tstamp);
                   ~~^   ~~~~~~
                   %llu

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/datatype.c | 2 +-
 src/meta.c     | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/src/datatype.c b/src/datatype.c
index c4e66c4633f8..743505de44b6 100644
--- a/src/datatype.c
+++ b/src/datatype.c
@@ -1384,7 +1384,7 @@ static void cgroupv2_type_print(const struct expr *expr,
 	if (cgroup_path)
 		nft_print(octx, "\"%s\"", cgroup_path);
 	else
-		nft_print(octx, "%lu", id);
+		nft_print(octx, "%" PRIu64, id);
 
 	xfree(cgroup_path);
 }
diff --git a/src/meta.c b/src/meta.c
index 73d58b1f53b5..fdbeba26291a 100644
--- a/src/meta.c
+++ b/src/meta.c
@@ -408,7 +408,7 @@ static void date_type_print(const struct expr *expr, struct output_ctx *octx)
 	 * Do our own printing. The default print function will print in
 	 * nanoseconds, which is ugly.
 	 */
-	nft_print(octx, "%lu", tstamp);
+	nft_print(octx, "%" PRIu64, tstamp);
 }
 
 static time_t parse_iso_date(const char *sym)
-- 
2.30.2

