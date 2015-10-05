From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nf 3/3] netfilter: xt_CT: don't put back reference to timeout policy object
Date: Mon,  5 Oct 2015 16:51:03 +0200
Message-ID: <1444056663-5913-3-git-send-email-pablo@netfilter.org>
References: <1444056663-5913-1-git-send-email-pablo@netfilter.org>
Cc: stephen@networkplumber.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:46843 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752541AbbJEOoO (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 5 Oct 2015 10:44:14 -0400
In-Reply-To: <1444056663-5913-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On success, this shouldn't put back the timeout policy object, otherwise
we may have module refcount overflow and we allow deletion of timeout
that are still in use.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/xt_CT.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/netfilter/xt_CT.c b/net/netfilter/xt_CT.c
index b43bf13..e8ac8e0 100644
--- a/net/netfilter/xt_CT.c
+++ b/net/netfilter/xt_CT.c
@@ -171,6 +171,9 @@ xt_ct_set_timeout(struct nf_conn *ct, const struct xt_tgchk_param *par,
 	if (timeout_ext == NULL)
 		ret = -ENOMEM;
 
+	rcu_read_unlock();
+	return 0;
+
 err_put_timeout:
 	__xt_ct_tg_timeout_put(timeout);
 out:
-- 
2.1.4

