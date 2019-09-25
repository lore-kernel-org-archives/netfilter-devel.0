Return-Path: <SRS0=+tY6=XU=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD476C432C2
	for <netfilter-devel@archiver.kernel.org>; Wed, 25 Sep 2019 21:27:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7C84B20673
	for <netfilter-devel@archiver.kernel.org>; Wed, 25 Sep 2019 21:27:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726427AbfIYV1n (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 25 Sep 2019 17:27:43 -0400
Received: from orbyte.nwl.cc ([151.80.46.58]:45884 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726355AbfIYV1n (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 25 Sep 2019 17:27:43 -0400
Received: from localhost ([::1]:58974 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1iDEp4-0005HW-2m; Wed, 25 Sep 2019 23:27:42 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH v2 23/24] xtables-restore: Allow lines without trailing newline character
Date:   Wed, 25 Sep 2019 23:26:04 +0200
Message-Id: <20190925212605.1005-24-phil@nwl.cc>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190925212605.1005-1-phil@nwl.cc>
References: <20190925212605.1005-1-phil@nwl.cc>
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
index 52730d8a6d526..01709288da5dc 100644
--- a/iptables/xshared.c
+++ b/iptables/xshared.c
@@ -549,6 +549,10 @@ void add_param_to_argv(char *parsestart, int line)
 		add_argv(param.buffer, 0);
 		param.len = 0;
 	}
+	if (param.len) {
+		param.buffer[param.len] = '\0';
+		add_argv(param.buffer, 0);
+	}
 }
 
 static const char *ipv4_addr_to_string(const struct in_addr *addr,
diff --git a/iptables/xtables-restore.c b/iptables/xtables-restore.c
index e9cdf2093bfcb..d065e1a921be7 100644
--- a/iptables/xtables-restore.c
+++ b/iptables/xtables-restore.c
@@ -98,7 +98,9 @@ static void xtables_restore_parse_line(struct nft_handle *h,
 		if (verbose)
 			fputs(buffer, stdout);
 		return;
-	} else if ((strcmp(buffer, "COMMIT\n") == 0) && (p->in_table)) {
+	} else if (p->in_table &&
+		   (strncmp(buffer, "COMMIT", 6) == 0) &&
+		   (buffer[6] == '\0' || buffer[6] == '\n')) {
 		if (!p->testing) {
 			/* Commit per table, although we support
 			 * global commit at once, stick by now to
-- 
2.23.0

