From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Subject: [PATCH 1/4] netlink: Use the right datatype for verdict
Date: Thu,  2 Aug 2012 13:31:32 +0300
Message-ID: <1343903495-14486-2-git-send-email-tomasz.bursztyka@linux.intel.com>
References: <1343903495-14486-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Cc: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:51950 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750972Ab2HBKbk (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 2 Aug 2012 06:31:40 -0400
In-Reply-To: <1343903495-14486-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
---
 src/netlink.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/src/netlink.c b/src/netlink.c
index ebfd744..6459e54 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -898,7 +898,7 @@ static void list_setelem_cb(struct nl_object *obj, void *arg)
 		nld = nfnl_nft_setelem_get_data(nlse);
 
 		data = netlink_alloc_data(&internal_location, nld,
-					  set->datatype->type == EXPR_VERDICT ?
+					  set->datatype->type == TYPE_VERDICT ?
 					  NFT_REG_VERDICT : NFT_REG_1);
 		data->dtype = set->datatype;
 
-- 
1.7.8.6

