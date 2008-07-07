From: Patrick McHardy <kaber@trash.net>
Subject: textsearch 11/13: ts_fsm: return error on request for case insensitive search
Date: Mon,  7 Jul 2008 14:05:30 +0200 (MEST)
Message-ID: <20080707120529.4975.76963.sendpatchset@localhost.localdomain>
References: <20080707120514.4975.88670.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:58400 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753728AbYGGMFb (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 7 Jul 2008 08:05:31 -0400
In-Reply-To: <20080707120514.4975.88670.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

textsearch: ts_fsm: return error on request for case insensitive search

For fsm text search, handle case insensitive parameter as -EINVAL.

Signed-off-by: Joonwoo Park <joonwpark81@gmail.com>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 9506e421d3283116e5c0648be7a6233b7b841e35
tree 13a684be9ce821b10072f9b44573a913fcb623d3
parent f7bf6c69848b78c6244bf9d6d963c6d685e91a58
author Joonwoo Park <joonwpark81@gmail.com> Mon, 07 Jul 2008 13:00:18 +0200
committer Patrick McHardy <kaber@trash.net> Mon, 07 Jul 2008 13:00:18 +0200

 lib/ts_fsm.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/lib/ts_fsm.c b/lib/ts_fsm.c
index af575b6..5696a35 100644
--- a/lib/ts_fsm.c
+++ b/lib/ts_fsm.c
@@ -257,7 +257,7 @@ found_match:
 }
 
 static struct ts_config *fsm_init(const void *pattern, unsigned int len,
-				     gfp_t gfp_mask)
+				    gfp_t gfp_mask, int flags)
 {
 	int i, err = -EINVAL;
 	struct ts_config *conf;
@@ -269,6 +269,9 @@ static struct ts_config *fsm_init(const void *pattern, unsigned int len,
 	if (len  % sizeof(struct ts_fsm_token) || ntokens < 1)
 		goto errout;
 
+	if (flags & TS_IGNORECASE)
+		goto errout;
+
 	for (i = 0; i < ntokens; i++) {
 		struct ts_fsm_token *t = &tokens[i];
 
@@ -284,6 +287,7 @@ static struct ts_config *fsm_init(const void *pattern, unsigned int len,
 	if (IS_ERR(conf))
 		return conf;
 
+	conf->flags = flags;
 	fsm = ts_config_priv(conf);
 	fsm->ntokens = ntokens;
 	memcpy(fsm->tokens, pattern, len);
