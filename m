From: Weongyo Jeong <weongyo.linux@gmail.com>
Subject: [PATCH] Shows proper function name for pr_debug() messages.
Date: Mon, 14 Mar 2016 13:07:36 -0700
Message-ID: <20160314200733.GA8907@jwg>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pa0-f49.google.com ([209.85.220.49]:36642 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753263AbcCNUHi (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 14 Mar 2016 16:07:38 -0400
Received: by mail-pa0-f49.google.com with SMTP id tt10so164668882pab.3
        for <netfilter-devel@vger.kernel.org>; Mon, 14 Mar 2016 13:07:38 -0700 (PDT)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

It seems pr_debug() calls didn't be updated while code was refactoring.

Signed-off-by: Weongyo Jeong <weongyo.linux@gmail.com>
---
 net/netfilter/nf_conntrack_core.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index f60b4fd..ebd4d23 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -1081,14 +1081,15 @@ resolve_normal_ct(struct net *net, struct nf_conn *tmpl,
 	} else {
 		/* Once we've had two way comms, always ESTABLISHED. */
 		if (test_bit(IPS_SEEN_REPLY_BIT, &ct->status)) {
-			pr_debug("nf_conntrack_in: normal packet for %p\n", ct);
+			pr_debug("resolve_normal_ct: normal packet for %p\n",
+			    ct);
 			*ctinfo = IP_CT_ESTABLISHED;
 		} else if (test_bit(IPS_EXPECTED_BIT, &ct->status)) {
-			pr_debug("nf_conntrack_in: related packet for %p\n",
+			pr_debug("resolve_normal_ct: related packet for %p\n",
 				 ct);
 			*ctinfo = IP_CT_RELATED;
 		} else {
-			pr_debug("nf_conntrack_in: new packet for %p\n", ct);
+			pr_debug("resolve_normal_ct: new packet for %p\n", ct);
 			*ctinfo = IP_CT_NEW;
 		}
 		*set_reply = 0;
-- 
2.1.3

