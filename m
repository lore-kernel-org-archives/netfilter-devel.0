Return-Path: <SRS0=20nZ=ZY=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79EAEC432C0
	for <netfilter-devel@archiver.kernel.org>; Mon,  2 Dec 2019 22:24:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 582152073C
	for <netfilter-devel@archiver.kernel.org>; Mon,  2 Dec 2019 22:24:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726008AbfLBWYW (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 2 Dec 2019 17:24:22 -0500
Received: from orbyte.nwl.cc ([151.80.46.58]:54612 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725834AbfLBWYW (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 2 Dec 2019 17:24:22 -0500
Received: from localhost ([::1]:39470 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1ibu7A-0000EK-Ud; Mon, 02 Dec 2019 23:24:20 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [libnftnl PATCH 1/4] flowtable: Fix memleak in error path of nftnl_flowtable_parse_devs()
Date:   Mon,  2 Dec 2019 23:23:58 +0100
Message-Id: <20191202222401.867-2-phil@nwl.cc>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191202222401.867-1-phil@nwl.cc>
References: <20191202222401.867-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

In error case, allocated dev_array is not freed.

Fixes: 7f99639dd9217 ("flowtable: device array dynamic allocation")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 src/flowtable.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/src/flowtable.c b/src/flowtable.c
index 324e80f7e6ad6..db319434b51c0 100644
--- a/src/flowtable.c
+++ b/src/flowtable.c
@@ -419,6 +419,7 @@ static int nftnl_flowtable_parse_devs(struct nlattr *nest,
 err:
 	while (len--)
 		xfree(dev_array[len]);
+	xfree(dev_array);
 	return -1;
 }
 
-- 
2.24.0

