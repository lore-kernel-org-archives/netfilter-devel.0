From: akong@redhat.com
Subject: [PATCH] net: fix checking boundary of valid vlan id
Date: Sun, 30 Dec 2012 17:21:47 +0800
Message-ID: <1356859307-26205-1-git-send-email-akong@redhat.com>
Cc: pablo@netfilter.org, kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:38239 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753733Ab2L3JWl (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 30 Dec 2012 04:22:41 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Amos Kong <akong@redhat.com>

According to IEEE 802.1Q, 4096 is not a valid vlan id, 4095 is reserved.

Signed-off-by: Amos Kong <akong@redhat.com>
---
 net/bridge/netfilter/ebt_vlan.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/bridge/netfilter/ebt_vlan.c b/net/bridge/netfilter/ebt_vlan.c
index eae67bf..5bdebc3 100644
--- a/net/bridge/netfilter/ebt_vlan.c
+++ b/net/bridge/netfilter/ebt_vlan.c
@@ -121,8 +121,8 @@ static int ebt_vlan_mt_check(const struct xt_mtchk_param *par)
 	 * if_vlan.h: VLAN_N_VID 4096. */
 	if (GET_BITMASK(EBT_VLAN_ID)) {
 		if (!!info->id) { /* if id!=0 => check vid range */
-			if (info->id > VLAN_N_VID) {
-				pr_debug("id %d is out of range (1-4096)\n",
+			if (info->id >= VLAN_N_VID - 1) {
+				pr_debug("id %d is out of range (1-4094)\n",
 					 info->id);
 				return -EINVAL;
 			}
-- 
1.7.11.7

