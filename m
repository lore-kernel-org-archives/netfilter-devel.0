From: Phil Sutter <phil@nwl.cc>
Subject: [libnftnl PATCH 6/6] src/trace: Check return value of mnl_attr_parse_nested()
Date: Thu, 14 Dec 2017 20:40:25 +0100
Message-ID: <20171214194025.21334-7-phil@nwl.cc>
References: <20171214194025.21334-1-phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:58076 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751952AbdLNTk6 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 14 Dec 2017 14:40:58 -0500
In-Reply-To: <20171214194025.21334-1-phil@nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is done everywhere else as well, so certainly not a bad thing here
either.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 src/trace.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/src/trace.c b/src/trace.c
index bd05d3c58d2fa..b016e723a7ded 100644
--- a/src/trace.c
+++ b/src/trace.c
@@ -301,7 +301,8 @@ static int nftnl_trace_parse_verdict(const struct nlattr *attr,
 {
 	struct nlattr *tb[NFTA_VERDICT_MAX+1];
 
-	mnl_attr_parse_nested(attr, nftnl_trace_parse_verdict_cb, tb);
+	if (mnl_attr_parse_nested(attr, nftnl_trace_parse_verdict_cb, tb) < 0)
+		return -1;
 
 	if (!tb[NFTA_VERDICT_CODE])
 		abi_breakage();
-- 
2.13.1

