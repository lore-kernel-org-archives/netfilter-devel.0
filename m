Return-Path: <SRS0=5AJI=YR=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C6B3CA9EAF
	for <netfilter-devel@archiver.kernel.org>; Thu, 24 Oct 2019 16:37:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6B565205C9
	for <netfilter-devel@archiver.kernel.org>; Thu, 24 Oct 2019 16:37:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503476AbfJXQh1 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 24 Oct 2019 12:37:27 -0400
Received: from orbyte.nwl.cc ([151.80.46.58]:58906 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2503426AbfJXQh1 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 24 Oct 2019 12:37:27 -0400
Received: from localhost ([::1]:43764 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1iNg74-0005CU-0a; Thu, 24 Oct 2019 18:37:26 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH v3 5/7] xtables-restore: Allow lines without trailing newline character
Date:   Thu, 24 Oct 2019 18:37:10 +0200
Message-Id: <20191024163712.22405-6-phil@nwl.cc>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191024163712.22405-1-phil@nwl.cc>
References: <20191024163712.22405-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Old code in add_param_to_argv() assumed the input line would always end
with a newline character. Without it, the last word of input wasn't
recognized. Fix this by adding a final check for param.len (indicating
leftover data in buffer).

In line parsing code itself, only COMMIT line check required presence of
trailing newline. The replaced conditional is not 100% accurate as it
allows for characters after newline to be present, but since fgets() is
used this shouldn't happen anyway.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/xshared.c         | 4 ++++
 iptables/xtables-restore.c | 4 +++-
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/iptables/xshared.c b/iptables/xshared.c
index 97f1b5d22fdbe..681a8fd314f86 100644
--- a/iptables/xshared.c
+++ b/iptables/xshared.c
@@ -530,6 +530,10 @@ void add_param_to_argv(struct argv_store *store, char *parsestart, int line)
 		param.len = 0;
 		quoted = 0;
 	}
+	if (param.len) {
+		param.buffer[param.len] = '\0';
+		add_argv(store, param.buffer, 0);
+	}
 }
 
 #ifdef DEBUG
diff --git a/iptables/xtables-restore.c b/iptables/xtables-restore.c
index 83e05102769a7..5a534ca227379 100644
--- a/iptables/xtables-restore.c
+++ b/iptables/xtables-restore.c
@@ -88,7 +88,9 @@ static void xtables_restore_parse_line(struct nft_handle *h,
 		if (verbose)
 			fputs(buffer, stdout);
 		return;
-	} else if ((strcmp(buffer, "COMMIT\n") == 0) && state->in_table) {
+	} else if (state->in_table &&
+		   (strncmp(buffer, "COMMIT", 6) == 0) &&
+		   (buffer[6] == '\0' || buffer[6] == '\n')) {
 		if (!p->testing) {
 			/* Commit per table, although we support
 			 * global commit at once, stick by now to
-- 
2.23.0

