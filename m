From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft] netlink: don't bug on unknown events
Date: Fri, 14 Nov 2014 18:42:33 +0100
Message-ID: <1415986953-10548-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net, arturo.borrero.glez@gmail.com
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:46287 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161175AbaKNRkj (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 14 Nov 2014 12:40:39 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

We will likely have new ones in the future, silently skip them. If the
user wants to see them, it just needs to upgrade.

This is currently causing us problems with kernels that deliver the
generation counter event.

term1# nft add table test

term2# nft monitor
nft: netlink.c:2063: netlink_events_cb: Assertion `0' failed.
Aborted

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/netlink.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/src/netlink.c b/src/netlink.c
index 33e77ab..23f38b0 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -2030,7 +2030,7 @@ static void netlink_events_cache_update(struct netlink_mon_handler *monh,
 static int netlink_events_cb(const struct nlmsghdr *nlh, void *data)
 {
 	int ret = MNL_CB_OK;
-	int type = nlh->nlmsg_type & 0xFF;
+	uint16_t type = NFNL_MSG_TYPE(nlh->nlmsg_type);
 	struct netlink_mon_handler *monh = (struct netlink_mon_handler *)data;
 
 	netlink_events_cache_update(monh, nlh, type);
@@ -2059,9 +2059,6 @@ static int netlink_events_cb(const struct nlmsghdr *nlh, void *data)
 	case NFT_MSG_DELRULE:
 		ret = netlink_events_rule_cb(nlh, type, monh);
 		break;
-	default:
-		BUG("Unknow event received from netlink.\n");
-		break;
 	}
 
 	return ret;
-- 
1.7.10.4

