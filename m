Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72BFFC6FD18
	for <netfilter-devel@archiver.kernel.org>; Tue, 25 Apr 2023 14:54:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234049AbjDYOyi (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 25 Apr 2023 10:54:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234421AbjDYOyf (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 25 Apr 2023 10:54:35 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7AF4FE71
        for <netfilter-devel@vger.kernel.org>; Tue, 25 Apr 2023 07:54:34 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft] mnl: incomplete extended error reporting for singleton device in chain
Date:   Tue, 25 Apr 2023 16:54:31 +0200
Message-Id: <20230425145431.2870-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Fix error reporting when single device is specifies in chain:

 # nft add chain netdev filter ingress '{ devices = { x }; }'
 add chain netdev filter ingress { devices = { x }; }
                                               ^

Fixes: a66b5ad9540d ("src: allow for updating devices on existing netdev chain")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/mnl.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/src/mnl.c b/src/mnl.c
index 5dcfd9a04c4b..adc0bd3d61cf 100644
--- a/src/mnl.c
+++ b/src/mnl.c
@@ -790,6 +790,7 @@ static void mnl_nft_chain_devs_build(struct nlmsghdr *nlh, struct cmd *cmd)
 
 	dev_array = nft_dev_array(dev_expr, &num_devs);
 	if (num_devs == 1) {
+		cmd_add_loc(cmd, nlh->nlmsg_len, dev_array[0].location);
 		mnl_attr_put_strz(nlh, NFTA_HOOK_DEV, dev_array[0].ifname);
 	} else {
 		nest_dev = mnl_attr_nest_start(nlh, NFTA_HOOK_DEVS);
-- 
2.30.2

