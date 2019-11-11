Return-Path: <SRS0=qfGK=ZD=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84973C17445
	for <netfilter-devel@archiver.kernel.org>; Mon, 11 Nov 2019 17:20:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 617E8214DB
	for <netfilter-devel@archiver.kernel.org>; Mon, 11 Nov 2019 17:20:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726928AbfKKRUH (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 11 Nov 2019 12:20:07 -0500
Received: from orbyte.nwl.cc ([151.80.46.58]:45932 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726878AbfKKRUH (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 11 Nov 2019 12:20:07 -0500
Received: from localhost ([::1]:59022 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1iUDMD-0007tX-MA; Mon, 11 Nov 2019 18:20:05 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, Ash Hughes <sehguh.hsa@gmail.com>
Subject: [conntrack-tools PATCH] helpers: Fix for warning when compiling against libtirpc
Date:   Mon, 11 Nov 2019 18:20:01 +0100
Message-Id: <20191111172001.14319-1-phil@nwl.cc>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Fix for the following warning:

In file included from rpc.c:29:
/usr/include/tirpc/rpc/rpc_msg.h:214:52: warning: 'struct rpc_err' declared inside parameter list will not be visible outside of this definition or declaration
  214 | extern void _seterr_reply(struct rpc_msg *, struct rpc_err *);
      |                                                    ^~~~~~~

Struct rpc_err is declared in rpc/clnt.h which also declares rpc_call(),
therefore rename the local version.

Fixes: 5ededc4476f27 ("conntrackd: search for RPC headers")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 src/helpers/rpc.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/src/helpers/rpc.c b/src/helpers/rpc.c
index 3a7b337135f04..bd24dd3269c8e 100644
--- a/src/helpers/rpc.c
+++ b/src/helpers/rpc.c
@@ -26,6 +26,7 @@
 
 #include <errno.h>
 
+#include <rpc/clnt.h>
 #include <rpc/rpc_msg.h>
 #include <rpc/pmap_prot.h>
 #define _GNU_SOURCE
@@ -114,8 +115,8 @@ nf_nat_rpc(struct pkt_buff *pkt, int dir, struct nf_expect *exp,
 #define ROUNDUP(n)	((((n) + 3)/4)*4)
 
 static int
-rpc_call(const uint32_t *data, uint32_t offset, uint32_t datalen,
-	 struct rpc_info *rpc_info)
+rpc_parse_call(const uint32_t *data, uint32_t offset, uint32_t datalen,
+	       struct rpc_info *rpc_info)
 {
 	uint32_t p, r;
 
@@ -393,7 +394,7 @@ rpc_helper_cb(struct pkt_buff *pkt, uint32_t protoff,
 	}
 
 	if (rm_dir == CALL) {
-		if (rpc_call(data, offset, datalen, rpc_info) < 0)
+		if (rpc_parse_call(data, offset, datalen, rpc_info) < 0)
 			goto out;
 
 		rpc_info->xid = xid;
-- 
2.24.0

