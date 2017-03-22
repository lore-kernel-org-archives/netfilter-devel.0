From: Liping Zhang <zlpnobody@163.com>
Subject: [PATCH libnetfilter_cthelper] examples: kill the "invalid argument" error in nftc-helper-add
Date: Wed, 22 Mar 2017 21:00:47 +0800
Message-ID: <1490187647-61659-1-git-send-email-zlpnobody@163.com>
Cc: netfilter-devel@vger.kernel.org, Liping Zhang <zlpnobody@gmail.com>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mproxygzc3.163.com ([218.107.63.211]:50566 "EHLO
        mproxygzc3.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1758899AbdCVNTV (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 22 Mar 2017 09:19:21 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Liping Zhang <zlpnobody@gmail.com>

NFCTH_PRIV_DATA_LEN is a must attribute required by the kernel when
creating the cthelper, add it now. Otherwise -EINVAL will be returned.

Signed-off-by: Liping Zhang <zlpnobody@gmail.com>
---
 examples/nfct-helper-add.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/examples/nfct-helper-add.c b/examples/nfct-helper-add.c
index cb7291e..79e0963 100644
--- a/examples/nfct-helper-add.c
+++ b/examples/nfct-helper-add.c
@@ -31,6 +31,7 @@ int main(int argc, char *argv[])
 	nfct_helper_attr_set_u32(nfct_helper, NFCTH_ATTR_QUEUE_NUM, atoi(argv[2]));
 	nfct_helper_attr_set_u16(nfct_helper, NFCTH_ATTR_PROTO_L3NUM, AF_INET);
 	nfct_helper_attr_set_u8(nfct_helper, NFCTH_ATTR_PROTO_L4NUM, IPPROTO_TCP);
+	nfct_helper_attr_set_u32(nfct_helper, NFCTH_ATTR_PRIV_DATA_LEN, 0);
 
 	/* Will be freed by nfct_helper_free. */
 	p = nfct_helper_policy_alloc();
-- 
2.5.5


