Return-Path: <SRS0=eJXe=SP=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 887E3C10F11
	for <netfilter-devel@archiver.kernel.org>; Sat, 13 Apr 2019 21:28:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5AF57208E3
	for <netfilter-devel@archiver.kernel.org>; Sat, 13 Apr 2019 21:28:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727177AbfDMV2c (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 13 Apr 2019 17:28:32 -0400
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:46386 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727042AbfDMV2c (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 13 Apr 2019 17:28:32 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.89)
        (envelope-from <fw@breakpoint.cc>)
        id 1hFQCM-0000nc-6f; Sat, 13 Apr 2019 23:28:30 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nf] netfilter: nat: fix icmp id endianness when protocol mapping was given
Date:   Sat, 13 Apr 2019 23:23:26 +0200
Message-Id: <20190413212326.31187-1-fw@strlen.de>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

net/netfilter/nf_nat_core.c:422:29: sparse: incorrect type in assignment (different base types)
net/netfilter/nf_nat_core.c:422:29:    expected unsigned int [unsigned] [assigned] min
net/netfilter/nf_nat_core.c:422:29:    got restricted __be16 const [usertype] id

The warning is correct, this needs ntohs treatment.

Reported-by: kbuild test robot <lkp@intel.com>
Fixes: 203f2e78200c27e ("netfilter: nat: remove l4proto->unique_tuple")
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 Pablo, feel free to squash this with commit 57be8a51f2a8ba390f7c5a03d2ae812a1b39c9bb
 ("netfilter: nat: fix icmp id randomization"), it touched this area
 already (and moved the faulty line to its current place).

 net/netfilter/nf_nat_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nf_nat_core.c b/net/netfilter/nf_nat_core.c
index f79f77d6850b..000952719adf 100644
--- a/net/netfilter/nf_nat_core.c
+++ b/net/netfilter/nf_nat_core.c
@@ -419,7 +419,7 @@ static void nf_nat_l4proto_unique_tuple(struct nf_conntrack_tuple *tuple,
 			min = 0;
 			range_size = 65536;
 		} else {
-			min = range->min_proto.icmp.id;
+			min = ntohs(range->min_proto.icmp.id);
 			range_size = ntohs(range->max_proto.icmp.id) -
 				     ntohs(range->min_proto.icmp.id) + 1;
 		}
-- 
2.21.0

