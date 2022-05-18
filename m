Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 369B7C433FE
	for <netfilter-devel@archiver.kernel.org>; Wed, 18 May 2022 22:03:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229591AbiERWDa (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 18 May 2022 18:03:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229614AbiERWDO (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 18 May 2022 18:03:14 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 20FC6286FD5
        for <netfilter-devel@vger.kernel.org>; Wed, 18 May 2022 14:54:08 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH libnftnl 2/2] set_elem: missing export symbol
Date:   Wed, 18 May 2022 23:54:03 +0200
Message-Id: <20220518215403.360178-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220518215403.360178-1-pablo@netfilter.org>
References: <20220518215403.360178-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

nftnl_set_elem_nlmsg_build_payload() is already available through .map
file and headers, add missing EXPORT_SYMBOL.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/set_elem.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/src/set_elem.c b/src/set_elem.c
index 12eadce1f8e0..95009acb17dc 100644
--- a/src/set_elem.c
+++ b/src/set_elem.c
@@ -300,6 +300,7 @@ err:
 	return NULL;
 }
 
+EXPORT_SYMBOL(nftnl_set_elem_nlmsg_build_payload);
 void nftnl_set_elem_nlmsg_build_payload(struct nlmsghdr *nlh,
 				      struct nftnl_set_elem *e)
 {
-- 
2.30.2

