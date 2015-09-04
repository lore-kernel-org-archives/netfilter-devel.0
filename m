From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft 1/2] netlink: flush stdout after each event in monitor mode
Date: Fri,  4 Sep 2015 18:53:03 +0200
Message-ID: <1441385584-7836-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net, fw@strlen.de, arturo.borrero.glez@gmail.com
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:33907 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760289AbbIDQqi (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 4 Sep 2015 12:46:38 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

So we get all events when redirecting them to file, ie.

	# nftables monitor > file

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/netlink.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/src/netlink.c b/src/netlink.c
index a905009..4371c0a 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -2143,6 +2143,7 @@ static int netlink_events_cb(const struct nlmsghdr *nlh, void *data)
 		ret = netlink_events_rule_cb(nlh, type, monh);
 		break;
 	}
+	fflush(stdout);
 
 	return ret;
 }
-- 
1.7.10.4

