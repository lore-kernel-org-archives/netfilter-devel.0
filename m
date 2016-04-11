From: Phil Sutter <phil@nwl.cc>
Subject: [PATCH] netfilter: ebtables: Fix extension lookup with identical name
Date: Tue, 12 Apr 2016 01:31:14 +0200
Message-ID: <1460417474-8899-1-git-send-email-phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:34380 "EHLO mail.nwl.cc"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753166AbcDKXb3 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 11 Apr 2016 19:31:29 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

If a requested extension exists as module and is not loaded,
ebt_check_match() might accidentally use an NFPROTO_UNSPEC one with same
name and fail.

Reproduced with limit match: Given xt_limit and ebt_limit both built as
module, the following would fail:

  modprobe xt_limit
  ebtables -I INPUT --limit 1/s -j ACCEPT

The fix is to make ebt_check_match() distrust a found NFPROTO_UNSPEC
extension and retry after requesting an appropriate module.

Cc: Florian Westphal <fw@strlen.de>
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 net/bridge/netfilter/ebtables.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/net/bridge/netfilter/ebtables.c b/net/bridge/netfilter/ebtables.c
index 8570bc7744c25..5a61f35412a05 100644
--- a/net/bridge/netfilter/ebtables.c
+++ b/net/bridge/netfilter/ebtables.c
@@ -370,7 +370,11 @@ ebt_check_match(struct ebt_entry_match *m, struct xt_mtchk_param *par,
 	    left - sizeof(struct ebt_entry_match) < m->match_size)
 		return -EINVAL;
 
-	match = xt_request_find_match(NFPROTO_BRIDGE, m->u.name, 0);
+	match = xt_find_match(NFPROTO_BRIDGE, m->u.name, 0);
+	if (IS_ERR(match) || match->family != NFPROTO_BRIDGE) {
+		request_module("ebt_%s", m->u.name);
+		match = xt_find_match(NFPROTO_BRIDGE, m->u.name, 0);
+	}
 	if (IS_ERR(match))
 		return PTR_ERR(match);
 	m->u.match = match;
-- 
2.8.0

