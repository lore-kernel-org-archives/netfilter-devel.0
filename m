From: pablo@netfilter.org
Subject: [PATCH 2/2] netfilter: nf_ct_expect: fix possible invalid dereference while event reporting
Date: Fri, 10 Aug 2012 01:02:12 +0200
Message-ID: <1344553332-8536-3-git-send-email-pablo@netfilter.org>
References: <1344553332-8536-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:56226 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759767Ab2HIXDZ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 9 Aug 2012 19:03:25 -0400
In-Reply-To: <1344553332-8536-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Pablo Neira Ayuso <pablo@netfilter.org>

Bump expectation refcount to make sure it does not vanish while
reporting the event via ctnetlink. One user reported a crash
while on nf_ct_expect_related_report triggered by the SIP helper.

Reported-by: Rafal Fitt <rafalf@aplusc.com.pl>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_conntrack_expect.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/netfilter/nf_conntrack_expect.c b/net/netfilter/nf_conntrack_expect.c
index ec8bb0d..d5fccd3 100644
--- a/net/netfilter/nf_conntrack_expect.c
+++ b/net/netfilter/nf_conntrack_expect.c
@@ -444,8 +444,12 @@ int nf_ct_expect_related_report(struct nf_conntrack_expect *expect,
 	ret = nf_ct_expect_insert(expect);
 	if (ret < 0)
 		goto out;
+
+	atomic_inc(&expect->use);
 	spin_unlock_bh(&nf_conntrack_lock);
 	nf_ct_expect_event_report(IPEXP_NEW, expect, pid, report);
+	nf_ct_expect_put(expect);
+
 	return ret;
 out:
 	spin_unlock_bh(&nf_conntrack_lock);
-- 
1.7.10.4

