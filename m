Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56B7CC433F5
	for <netfilter-devel@archiver.kernel.org>; Tue, 11 Jan 2022 15:05:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244019AbiAKPFI (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 11 Jan 2022 10:05:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244013AbiAKPFI (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 11 Jan 2022 10:05:08 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DD56C06173F
        for <netfilter-devel@vger.kernel.org>; Tue, 11 Jan 2022 07:05:08 -0800 (PST)
Received: from localhost ([::1]:59130 helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1n7Ihu-0007X7-Kf; Tue, 11 Jan 2022 16:05:06 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH v2 02/11] xtables: Pull table validity check out of do_parse()
Date:   Tue, 11 Jan 2022 16:04:20 +0100
Message-Id: <20220111150429.29110-3-phil@nwl.cc>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220111150429.29110-1-phil@nwl.cc>
References: <20220111150429.29110-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Makes do_parse() more generic, error codes don't change so this should
be safe.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/xtables.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/iptables/xtables.c b/iptables/xtables.c
index 5c48bd94644f3..ac864eb24a35e 100644
--- a/iptables/xtables.c
+++ b/iptables/xtables.c
@@ -514,10 +514,6 @@ void do_parse(struct nft_handle *h, int argc, char *argv[],
 				xtables_error(PARAMETER_PROBLEM,
 					      "The -t option cannot be used in %s.\n",
 					      xt_params->program_name);
-			if (!nft_table_builtin_find(h, optarg))
-				xtables_error(VERSION_PROBLEM,
-					      "table '%s' does not exist",
-					      optarg);
 			p->table = optarg;
 			table_set = true;
 			break;
@@ -720,6 +716,10 @@ int do_commandx(struct nft_handle *h, int argc, char *argv[], char **table,
 
 	do_parse(h, argc, argv, &p, &cs, &args);
 
+	if (!nft_table_builtin_find(h, p.table))
+		xtables_error(VERSION_PROBLEM,
+			      "table '%s' does not exist",
+			      p.table);
 	switch (p.command) {
 	case CMD_APPEND:
 		ret = h->ops->add_entry(h, p.chain, p.table, &cs, &args,
-- 
2.34.1

