From: Thomas Woerner <twoerner@redhat.com>
Subject: [IPTABLES 1/2] iptables-compat: Allow to insert into rule_count+1 position
Date: Tue, 21 Jul 2015 15:45:41 +0200
Message-ID: <1437486342-6917-2-git-send-email-twoerner@redhat.com>
References: <1437486342-6917-1-git-send-email-twoerner@redhat.com>
Cc: Thomas Woerner <twoerner@redhat.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:47382 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932601AbbGUNpr (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 21 Jul 2015 09:45:47 -0400
Received: from int-mx13.intmail.prod.int.phx2.redhat.com (int-mx13.intmail.prod.int.phx2.redhat.com [10.5.11.26])
	by mx1.redhat.com (Postfix) with ESMTPS id E91CD19F208
	for <netfilter-devel@vger.kernel.org>; Tue, 21 Jul 2015 13:45:46 +0000 (UTC)
In-Reply-To: <1437486342-6917-1-git-send-email-twoerner@redhat.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

iptables allows to insert a rule into the next non existing rule number but
iptables-compat does not allow to do this

Signed-off-by: Thomas Woerner <twoerner@redhat.com>
---
:100644 100644 7cd56ef... 323f124... M	iptables/nft.c
 iptables/nft.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/iptables/nft.c b/iptables/nft.c
index 7cd56ef..323f124 100644
--- a/iptables/nft.c
+++ b/iptables/nft.c
@@ -1854,6 +1854,16 @@ int nft_rule_insert(struct nft_handle *h, const char *chain,
 
 		r = nft_rule_find(h, list, chain, table, data, rulenum);
 		if (r == NULL) {
+			/* special case: iptables allows to insert into
+			   rule_count+1 position */
+			r = nft_rule_find(h, list, chain, table, data,
+					  rulenum-1);
+			if (r != NULL) {
+				nft_rule_list_destroy(list);
+				return nft_rule_append(h, chain, table, data,
+						       0, verbose);
+			}
+
 			errno = ENOENT;
 			goto err;
 		}
-- 
2.4.3

