From: Weongyo Jeong <weongyo.linux@gmail.com>
Subject: [PATCH] netfilter: nf_conntrack: Uses pr_fmt() for logging.
Date: Tue, 15 Mar 2016 10:57:44 -0700
Message-ID: <20160315175741.GA11458@jwg>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pf0-f176.google.com ([209.85.192.176]:34028 "EHLO
	mail-pf0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751069AbcCOR5r (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 15 Mar 2016 13:57:47 -0400
Received: by mail-pf0-f176.google.com with SMTP id x3so38055072pfb.1
        for <netfilter-devel@vger.kernel.org>; Tue, 15 Mar 2016 10:57:46 -0700 (PDT)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Uses pr_fmt() macro for debugging messages of nf_conntrack module.

Signed-off-by: Weongyo Jeong <weongyo.linux@gmail.com>
---
 net/netfilter/nf_conntrack_core.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index f60b4fd..be79af0 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -12,6 +12,8 @@
  * published by the Free Software Foundation.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/types.h>
 #include <linux/netfilter.h>
 #include <linux/module.h>
@@ -968,7 +970,7 @@ init_conntrack(struct net *net, struct nf_conn *tmpl,
 
 	if (!l4proto->new(ct, skb, dataoff, timeouts)) {
 		nf_conntrack_free(ct);
-		pr_debug("init conntrack: can't track with proto module\n");
+		pr_debug("can't track with proto module\n");
 		return NULL;
 	}
 
@@ -990,7 +992,7 @@ init_conntrack(struct net *net, struct nf_conn *tmpl,
 		spin_lock(&nf_conntrack_expect_lock);
 		exp = nf_ct_find_expectation(net, zone, tuple);
 		if (exp) {
-			pr_debug("conntrack: expectation arrives ct=%p exp=%p\n",
+			pr_debug("expectation arrives ct=%p exp=%p\n",
 				 ct, exp);
 			/* Welcome, Mr. Bond.  We've been expecting you... */
 			__set_bit(IPS_EXPECTED_BIT, &ct->status);
@@ -1055,7 +1057,7 @@ resolve_normal_ct(struct net *net, struct nf_conn *tmpl,
 	if (!nf_ct_get_tuple(skb, skb_network_offset(skb),
 			     dataoff, l3num, protonum, net, &tuple, l3proto,
 			     l4proto)) {
-		pr_debug("resolve_normal_ct: Can't get tuple\n");
+		pr_debug("Can't get tuple\n");
 		return NULL;
 	}
 
@@ -1081,14 +1083,13 @@ resolve_normal_ct(struct net *net, struct nf_conn *tmpl,
 	} else {
 		/* Once we've had two way comms, always ESTABLISHED. */
 		if (test_bit(IPS_SEEN_REPLY_BIT, &ct->status)) {
-			pr_debug("nf_conntrack_in: normal packet for %p\n", ct);
+			pr_debug("normal packet for %p\n", ct);
 			*ctinfo = IP_CT_ESTABLISHED;
 		} else if (test_bit(IPS_EXPECTED_BIT, &ct->status)) {
-			pr_debug("nf_conntrack_in: related packet for %p\n",
-				 ct);
+			pr_debug("related packet for %p\n", ct);
 			*ctinfo = IP_CT_RELATED;
 		} else {
-			pr_debug("nf_conntrack_in: new packet for %p\n", ct);
+			pr_debug("new packet for %p\n", ct);
 			*ctinfo = IP_CT_NEW;
 		}
 		*set_reply = 0;
-- 
2.1.3

