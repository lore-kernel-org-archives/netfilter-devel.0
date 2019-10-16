Return-Path: <SRS0=cZSN=YJ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5E1FFA3728
	for <netfilter-devel@archiver.kernel.org>; Wed, 16 Oct 2019 23:03:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BD940207FF
	for <netfilter-devel@archiver.kernel.org>; Wed, 16 Oct 2019 23:03:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389825AbfJPXDd (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 16 Oct 2019 19:03:33 -0400
Received: from orbyte.nwl.cc ([151.80.46.58]:40190 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731616AbfJPXDd (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 16 Oct 2019 19:03:33 -0400
Received: from localhost ([::1]:53280 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1iKsKJ-0005e4-KM; Thu, 17 Oct 2019 01:03:31 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [nft PATCH 3/4] tests/monitor: Fix for changed ct timeout format
Date:   Thu, 17 Oct 2019 01:03:21 +0200
Message-Id: <20191016230322.24432-4-phil@nwl.cc>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191016230322.24432-1-phil@nwl.cc>
References: <20191016230322.24432-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Commit a9b0c385a1d5e ("rule: print space between policy and timeout")
changed spacing in ct timeout objects but missed to adjust related test
case.

Fixes: a9b0c385a1d5e ("rule: print space between policy and timeout")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 tests/monitor/testcases/object.t | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tests/monitor/testcases/object.t b/tests/monitor/testcases/object.t
index dacfed29d639e..2afe33c812571 100644
--- a/tests/monitor/testcases/object.t
+++ b/tests/monitor/testcases/object.t
@@ -37,7 +37,7 @@ I delete ct helper ip t cth
 O -
 J {"delete": {"ct helper": {"family": "ip", "name": "cth", "table": "t", "handle": 0, "type": "sip", "protocol": "tcp", "l3proto": "ip"}}}
 
-I add ct timeout ip t ctt { protocol udp; l3proto ip; policy = { unreplied: 15, replied: 12 }; }
+I add ct timeout ip t ctt { protocol udp; l3proto ip; policy = { unreplied : 15, replied : 12 }; }
 O -
 J {"add": {"ct timeout": {"family": "ip", "name": "ctt", "table": "t", "handle": 0, "protocol": "udp", "l3proto": "ip", "policy": {"unreplied": 15, "replied": 12}}}}
 
-- 
2.23.0

