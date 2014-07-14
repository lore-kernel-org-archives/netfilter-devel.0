From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [nft PATCH 2/2] monitor: fix how rules with intervals are printed
Date: Mon, 14 Jul 2014 13:56:52 +0200
Message-ID: <20140714115651.10384.23718.stgit@nfdev.cica.es>
References: <20140714115646.10384.69637.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:55131 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754326AbaGNL5A (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 14 Jul 2014 07:57:00 -0400
In-Reply-To: <20140714115646.10384.69637.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Previous to this patch, if we add a rule like this:
 nft add rule filter test ip saddr { 1.1.1.1-2.2.2.2 }

The monitor operation output shows:
 add rule ip filter test ip saddr { 0.0.0.0, 1.1.1.1, 2.2.2.3}

The fix suggested by Pablo is to call interval_map_decompose().

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 src/netlink.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/src/netlink.c b/src/netlink.c
index 1a5d07b..83a13c3 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -1723,6 +1723,12 @@ out:
 	return MNL_CB_OK;
 }
 
+static void rule_map_decompose_cb(struct set *s, void *data)
+{
+	if (s->flags & NFT_SET_INTERVAL)
+		interval_map_decompose(s->init);
+}
+
 static int netlink_events_rule_cb(const struct nlmsghdr *nlh, int type,
 				  struct netlink_mon_handler *monh)
 {
@@ -1743,6 +1749,7 @@ static int netlink_events_rule_cb(const struct nlmsghdr *nlh, int type,
 
 		if (type == NFT_MSG_NEWRULE) {
 			r = netlink_delinearize_rule(monh->ctx, nlr);
+			nlr_for_each_set(nlr, rule_map_decompose_cb, NULL);
 
 			printf("add rule %s %s %s", family, table, chain);
 			rule_print(r);

