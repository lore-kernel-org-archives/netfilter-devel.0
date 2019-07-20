Return-Path: <SRS0=YHPx=VR=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5079C76195
	for <netfilter-devel@archiver.kernel.org>; Sat, 20 Jul 2019 16:31:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8C17C2085A
	for <netfilter-devel@archiver.kernel.org>; Sat, 20 Jul 2019 16:31:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726659AbfGTQbI (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 20 Jul 2019 12:31:08 -0400
Received: from orbyte.nwl.cc ([151.80.46.58]:40910 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726300AbfGTQbI (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 20 Jul 2019 12:31:08 -0400
Received: from localhost ([::1]:54000 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1hosGI-0005TW-LE; Sat, 20 Jul 2019 18:31:06 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 10/12] xtables-save: Pass format flags to do_output()
Date:   Sat, 20 Jul 2019 18:30:24 +0200
Message-Id: <20190720163026.15410-11-phil@nwl.cc>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190720163026.15410-1-phil@nwl.cc>
References: <20190720163026.15410-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Let callers define the flags to pass to nft_rule_save() instead of just
setting the counters boolean.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/xtables-save.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/iptables/xtables-save.c b/iptables/xtables-save.c
index 249b396091af4..980a80ff06f96 100644
--- a/iptables/xtables-save.c
+++ b/iptables/xtables-save.c
@@ -66,7 +66,7 @@ static const struct option ebt_save_options[] = {
 static bool ebt_legacy_counter_format;
 
 struct do_output_data {
-	bool counters;
+	unsigned int format;
 	bool commit;
 };
 
@@ -98,7 +98,7 @@ __do_output(struct nft_handle *h, const char *tablename, void *data)
 	/* Dump out chain names first,
 	 * thereby preventing dependency conflicts */
 	nft_chain_save(h, chain_list);
-	nft_rule_save(h, tablename, d->counters ? 0 : FMT_NOCOUNTS);
+	nft_rule_save(h, tablename, d->format);
 	if (d->commit)
 		printf("COMMIT\n");
 
@@ -139,7 +139,9 @@ xtables_save_main(int family, int argc, char *argv[],
 {
 	const struct builtin_table *tables;
 	const char *tablename = NULL;
-	struct do_output_data d = {};
+	struct do_output_data d = {
+		.format = FMT_NOCOUNTS,
+	};
 	bool dump = false;
 	struct nft_handle h = {
 		.family	= family,
@@ -162,7 +164,7 @@ xtables_save_main(int family, int argc, char *argv[],
 			fprintf(stderr, "-b/--binary option is not implemented\n");
 			break;
 		case 'c':
-			d.counters = true;
+			d.format &= ~FMT_NOCOUNTS;
 			break;
 
 		case 't':
-- 
2.22.0

