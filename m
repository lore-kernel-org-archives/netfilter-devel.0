Return-Path: <SRS0=BTt+=XF=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2A9EC3A5A2
	for <netfilter-devel@archiver.kernel.org>; Tue, 10 Sep 2019 12:06:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C15952089F
	for <netfilter-devel@archiver.kernel.org>; Tue, 10 Sep 2019 12:06:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727122AbfIJMGk (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 10 Sep 2019 08:06:40 -0400
Received: from orbyte.nwl.cc ([151.80.46.58]:36428 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726720AbfIJMGk (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 10 Sep 2019 08:06:40 -0400
Received: from localhost ([::1]:49518 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1i7eus-0003mB-DH; Tue, 10 Sep 2019 14:06:38 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [conntrack-tools PATCH] nfct: helper: Fix NFCTH_ATTR_PROTO_L4NUM size
Date:   Tue, 10 Sep 2019 14:06:31 +0200
Message-Id: <20190910120631.20817-1-phil@nwl.cc>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Kernel defines NFCTH_TUPLE_L4PROTONUM as of type NLA_U8. When adding a
helper, NFCTH_ATTR_PROTO_L4NUM attribute is correctly set using
nfct_helper_attr_set_u8(), though when deleting
nfct_helper_attr_set_u32() was incorrectly used. Due to alignment, this
causes trouble only on Big Endian.

Fixes: 5e8f64f46cb1d ("conntrackd: add cthelper infrastructure (+ example FTP helper)")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 src/nfct-extensions/helper.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/nfct-extensions/helper.c b/src/nfct-extensions/helper.c
index 0569827612f06..e5d8d0a905df0 100644
--- a/src/nfct-extensions/helper.c
+++ b/src/nfct-extensions/helper.c
@@ -284,7 +284,7 @@ nfct_cmd_helper_delete(struct mnl_socket *nl, int argc, char *argv[])
 			nfct_perror("unsupported layer 4 protocol");
 			return -1;
 		}
-		nfct_helper_attr_set_u32(t, NFCTH_ATTR_PROTO_L4NUM, l4proto);
+		nfct_helper_attr_set_u8(t, NFCTH_ATTR_PROTO_L4NUM, l4proto);
 	}
 
 	seq = time(NULL);
-- 
2.22.0

