Return-Path: <SRS0=dCSv=65=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A32DC433E1
	for <netfilter-devel@archiver.kernel.org>; Fri, 15 May 2020 14:04:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 02C3920671
	for <netfilter-devel@archiver.kernel.org>; Fri, 15 May 2020 14:04:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726212AbgEOOEi (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 15 May 2020 10:04:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726198AbgEOOEi (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 15 May 2020 10:04:38 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70BB3C061A0C
        for <netfilter-devel@vger.kernel.org>; Fri, 15 May 2020 07:04:38 -0700 (PDT)
Received: from localhost ([::1]:52366 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1jZax3-0006sA-8V; Fri, 15 May 2020 16:04:37 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH v2 2/2] nfnl_osf: Improve error handling
Date:   Fri, 15 May 2020 16:03:30 +0200
Message-Id: <20200515140330.13669-3-phil@nwl.cc>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200515140330.13669-1-phil@nwl.cc>
References: <20200515140330.13669-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

For some error cases, no log message was created - hence apart from the
return code there was no indication of failing execution.

If a line load fails, don't abort but continue with the remaining
file contents. The current pf.os file in this repository serves as
proof-of-concept:

Lines 700 and 701: Duplicates of lines 698 and 699 because 'W*' and 'W0'
parse into the same data.

Line 704: Duplicate of line 702 because apart from 'W*' and 'W0', only
the first three fields on right-hand side are sent to the kernel.

When loading, these dups are ignored (they would bounce if NLM_F_EXCL
was given). Upon deletion, they cause ENOENT response from kernel.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
Changes since v1:
- Don't use ulog_err() when complaining about missing fingerprints
  argument, the use of strerror() with zero errno is misleading.
- Don't print error on osf_load_line() failure when deleting and errno
  is ENOENT. Upon add, NLM_F_EXCL is not set so EEXIST is basically
  ignored, be equally error-tolerant upon deletion.
---
 utils/nfnl_osf.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/utils/nfnl_osf.c b/utils/nfnl_osf.c
index 922d90ac135b7..4183d66c22d16 100644
--- a/utils/nfnl_osf.c
+++ b/utils/nfnl_osf.c
@@ -392,7 +392,7 @@ static int osf_load_line(char *buffer, int len, int del)
 static int osf_load_entries(char *path, int del)
 {
 	FILE *inf;
-	int err = 0;
+	int err = 0, lineno = 0;
 	char buf[1024];
 
 	inf = fopen(path, "r");
@@ -402,7 +402,9 @@ static int osf_load_entries(char *path, int del)
 	}
 
 	while(fgets(buf, sizeof(buf), inf)) {
-		int len;
+		int len, rc;
+
+		lineno++;
 
 		if (buf[0] == '#' || buf[0] == '\n' || buf[0] == '\r')
 			continue;
@@ -414,9 +416,11 @@ static int osf_load_entries(char *path, int del)
 
 		buf[len] = '\0';
 
-		err = osf_load_line(buf, len, del);
-		if (err)
-			break;
+		rc = osf_load_line(buf, len, del);
+		if (rc && (!del || errno == ENOENT)) {
+			ulog_err("Failed to load line %d", lineno);
+			err = rc;
+		}
 
 		memset(buf, 0, sizeof(buf));
 	}
@@ -448,6 +452,7 @@ int main(int argc, char *argv[])
 
 	if (!fingerprints) {
 		err = -ENOENT;
+		ulog("Missing fingerprints file argument.\n");
 		goto err_out_exit;
 	}
 
-- 
2.26.2

