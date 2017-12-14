From: Phil Sutter <phil@nwl.cc>
Subject: [libnftnl PATCH 1/6] nftnl_data_reg_snprintf: Add a missing break
Date: Thu, 14 Dec 2017 20:40:20 +0100
Message-ID: <20171214194025.21334-2-phil@nwl.cc>
References: <20171214194025.21334-1-phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:58064 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751952AbdLNTkr (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 14 Dec 2017 14:40:47 -0500
In-Reply-To: <20171214194025.21334-1-phil@nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The code works fine as-is, but if reg_type == DATA_VALUE &&
output_format == NFTNL_OUTPUT_XML, we fall through to DATA_CHAIN case
and therefore pointlessly check output_format again.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 src/expr/data_reg.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/src/expr/data_reg.c b/src/expr/data_reg.c
index a246952f7f01b..c087d792a8af6 100644
--- a/src/expr/data_reg.c
+++ b/src/expr/data_reg.c
@@ -207,6 +207,7 @@ int nftnl_data_reg_snprintf(char *buf, size_t size,
 		default:
 			break;
 		}
+		break;
 	case DATA_VERDICT:
 	case DATA_CHAIN:
 		switch(output_format) {
-- 
2.13.1

