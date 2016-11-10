From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 12/14] netfilter: conntrack: fix CT target for UNSPEC helpers
Date: Thu, 10 Nov 2016 01:23:45 +0100
Message-ID: <1478737427-1574-13-git-send-email-pablo@netfilter.org>
References: <1478737427-1574-1-git-send-email-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:37760 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932234AbcKJAYK (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 9 Nov 2016 19:24:10 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 178DE9B7F3
        for <netfilter-devel@vger.kernel.org>; Thu, 10 Nov 2016 01:24:10 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 055CCDA7F6
        for <netfilter-devel@vger.kernel.org>; Thu, 10 Nov 2016 01:24:10 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 0FD88DA801
        for <netfilter-devel@vger.kernel.org>; Thu, 10 Nov 2016 01:24:08 +0100 (CET)
In-Reply-To: <1478737427-1574-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Florian Westphal <fw@strlen.de>

Thomas reports its not possible to attach the H.245 helper:

iptables -t raw -A PREROUTING -p udp -j CT --helper H.245
iptables: No chain/target/match by that name.
xt_CT: No such helper "H.245"

This is because H.245 registers as NFPROTO_UNSPEC, but the CT target
passes NFPROTO_IPV4/IPV6 to nf_conntrack_helper_try_module_get.

We should treat UNSPEC as wildcard and ignore the l3num instead.

Reported-by: Thomas Woerner <twoerner@redhat.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_conntrack_helper.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/nf_conntrack_helper.c b/net/netfilter/nf_conntrack_helper.c
index 336e21559e01..7341adf7059d 100644
--- a/net/netfilter/nf_conntrack_helper.c
+++ b/net/netfilter/nf_conntrack_helper.c
@@ -138,9 +138,14 @@ __nf_conntrack_helper_find(const char *name, u16 l3num, u8 protonum)
 
 	for (i = 0; i < nf_ct_helper_hsize; i++) {
 		hlist_for_each_entry_rcu(h, &nf_ct_helper_hash[i], hnode) {
-			if (!strcmp(h->name, name) &&
-			    h->tuple.src.l3num == l3num &&
-			    h->tuple.dst.protonum == protonum)
+			if (strcmp(h->name, name))
+				continue;
+
+			if (h->tuple.src.l3num != NFPROTO_UNSPEC &&
+			    h->tuple.src.l3num != l3num)
+				continue;
+
+			if (h->tuple.dst.protonum == protonum)
 				return h;
 		}
 	}
-- 
2.1.4

