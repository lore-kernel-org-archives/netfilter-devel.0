Return-Path: <SRS0=ai/f=S3=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2986C10F03
	for <netfilter-devel@archiver.kernel.org>; Thu, 25 Apr 2019 13:00:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1A95120678
	for <netfilter-devel@archiver.kernel.org>; Thu, 25 Apr 2019 13:00:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728543AbfDYNAJ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 25 Apr 2019 09:00:09 -0400
Received: from orbyte.nwl.cc ([151.80.46.58]:55886 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727168AbfDYNAJ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 25 Apr 2019 09:00:09 -0400
Received: from localhost ([::1]:40744 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1hJdyx-0007uP-Qw; Thu, 25 Apr 2019 15:00:07 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [nft PATCH 1/4] tests: monitor: Adjust to changed events ordering
Date:   Thu, 25 Apr 2019 14:59:40 +0200
Message-Id: <20190425125943.15787-2-phil@nwl.cc>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190425125943.15787-1-phil@nwl.cc>
References: <20190425125943.15787-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

When replacing a rule, kernel nowadays seems to report rule add event
before rule delete one. Since both events belong to the same
transaction, this is harmless per definition and merely needs adjustment
in expected output.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 tests/monitor/testcases/simple.t | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tests/monitor/testcases/simple.t b/tests/monitor/testcases/simple.t
index 78d8f8b04bd36..78fd6616eb074 100644
--- a/tests/monitor/testcases/simple.t
+++ b/tests/monitor/testcases/simple.t
@@ -18,10 +18,10 @@ O add rule ip t c counter packets 0 bytes 0 accept
 J {"add": {"rule": {"family": "ip", "table": "t", "chain": "c", "handle": 0, "expr": [{"counter": {"packets": 0, "bytes": 0}}, {"accept": null}]}}}
 
 I replace rule ip t c handle 2 accept comment "foo bar"
-O delete rule ip t c handle 2
 O add rule ip t c accept comment "foo bar"
-J {"delete": {"rule": {"family": "ip", "table": "t", "chain": "c", "handle": 0, "expr": [{"accept": null}]}}}
+O delete rule ip t c handle 2
 J {"add": {"rule": {"family": "ip", "table": "t", "chain": "c", "handle": 0, "comment": "foo bar", "expr": [{"accept": null}]}}}
+J {"delete": {"rule": {"family": "ip", "table": "t", "chain": "c", "handle": 0, "expr": [{"accept": null}]}}}
 
 I add counter ip t cnt
 O add counter ip t cnt { packets 0 bytes 0 }
-- 
2.21.0

