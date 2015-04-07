From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [nft PATCH] monitor: fix missing space after chain name
Date: Tue, 07 Apr 2015 17:05:14 +0200
Message-ID: <20150407150514.1615.70626.stgit@nfdev2.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp4.cica.es ([150.214.5.182]:40195 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753811AbbDGPFY (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 7 Apr 2015 11:05:24 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Due to change f3ff9e9 ("rule: delete extra space in rule indentation") in
function rule_print(), a missing space happens in monitor.

before this patch:
 % nft monitor
 add rule ip test-table test-chainip protocol tcp

after this patch:
 % nft monitor
 add rule ip test-table test-chain ip protocol tcp

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 src/netlink.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/netlink.c b/src/netlink.c
index f957295..c118502 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -1869,7 +1869,7 @@ static int netlink_events_rule_cb(const struct nlmsghdr *nlh, int type,
 			r = netlink_delinearize_rule(monh->ctx, nlr);
 			nlr_for_each_set(nlr, rule_map_decompose_cb, NULL);
 
-			printf("add rule %s %s %s", family, table, chain);
+			printf("add rule %s %s %s ", family, table, chain);
 			rule_print(r);
 			printf("\n");
 

