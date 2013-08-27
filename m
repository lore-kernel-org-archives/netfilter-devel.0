From: Florian Westphal <fw@strlen.de>
Subject: [PATCH next] netfilter: ctnetlink: fix uninitialized variable
Date: Tue, 27 Aug 2013 11:47:26 +0200
Message-ID: <1377596846-1790-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:33573 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752738Ab3H0Jrf (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 27 Aug 2013 05:47:35 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

net/netfilter/nf_conntrack_netlink.c: In function 'ctnetlink_nfqueue_attach_expect':
'helper' may be used uninitialized in this function

It was only initialized in if CTA_EXPECT_HELP_NAME attribute was
present, it must be NULL otherwise.

Problem added recently in bd077937
(netfilter: nfnetlink_queue: allow to attach expectations to conntracks).

Signed-off-by: Florian Westphal <fw@strlen.de>
---
diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index fa61fea..1f4ffa2 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -2170,7 +2170,7 @@ ctnetlink_nfqueue_attach_expect(const struct nlattr *attr, struct nf_conn *ct,
 {
 	struct nlattr *cda[CTA_EXPECT_MAX+1];
 	struct nf_conntrack_tuple tuple, mask;
-	struct nf_conntrack_helper *helper;
+	struct nf_conntrack_helper *helper = NULL;
 	struct nf_conntrack_expect *exp;
 	int err;
 
-- 
1.7.8.6

