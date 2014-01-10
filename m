From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 1/4] nftables: shorten "could not process rule in batch" message
Date: Fri, 10 Jan 2014 09:31:31 +0000
Message-ID: <1389346294-7242-2-git-send-email-kaber@trash.net>
References: <1389346294-7242-1-git-send-email-kaber@trash.net>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:57688 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752844AbaAJJcZ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 10 Jan 2014 04:32:25 -0500
In-Reply-To: <1389346294-7242-1-git-send-email-kaber@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Remove the "in batch" part, it makes most messages exceed a single line, the
user doesn't care about this and we process even single rules in "batches".

Signed-off-by: Patrick McHardy <kaber@trash.net>
---
 src/main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/src/main.c b/src/main.c
index 32a991a..e8be423 100644
--- a/src/main.c
+++ b/src/main.c
@@ -183,8 +183,8 @@ static int nft_netlink(struct parser_state *state, struct list_head *msgs)
 			if (err->seqnum == cmd->seqnum ||
 			    err->seqnum == batch_seqnum) {
 				netlink_io_error(&ctx, &cmd->location,
-					"Could not process rule in batch: %s",
-					strerror(err->err));
+						 "Could not process rule: %s",
+						 strerror(err->err));
 				if (err->seqnum == cmd->seqnum) {
 					mnl_err_list_free(err);
 					break;
-- 
1.8.4.2

