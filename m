From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft 1/3] main: propagate error to shell
Date: Wed, 23 Jul 2014 23:49:51 +0200
Message-ID: <1406152193-11497-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:49763 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933386AbaGWVtp (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 23 Jul 2014 17:49:45 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Before:

 # nft add rule ip test input ip hdrlength 3
 <cmdline>:1:1-37: Error: Could not process rule: Invalid argument
 add rule ip test input ip hdrlength 3
 ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
 # echo $?
 0

After:

 # nft add rule ip test input ip hdrlength 3
 <cmdline>:1:1-37: Error: Could not process rule: Invalid argument
 add rule ip test input ip hdrlength 3
 ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
 # echo $?
 1

Reported-by: Ana Rey Botello <anarey@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/main.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/src/main.c b/src/main.c
index bd8feee..04a98e3 100644
--- a/src/main.c
+++ b/src/main.c
@@ -200,6 +200,8 @@ static int nft_netlink(struct parser_state *state, struct list_head *msgs)
 				netlink_io_error(&ctx, &cmd->location,
 						 "Could not process rule: %s",
 						 strerror(err->err));
+				ret = -1;
+				errno = err->err;
 				if (err->seqnum == cmd->seqnum) {
 					mnl_err_list_free(err);
 					break;
-- 
1.7.10.4

