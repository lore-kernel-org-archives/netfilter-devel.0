From: Sabrina Dubroca <sd@queasysnail.net>
Subject: [PATCH nf] netfilter: ebtables: put module reference when an incorrect extension is found
Date: Tue, 23 Aug 2016 10:20:31 +0200
Message-ID: <9117dc544fa8d93e00e1d6aeb2db97ffea89155f.1471939966.git.sd@queasysnail.net>
Cc: Florian Westphal <fw@strlen.de>, Phil Sutter <phil@nwl.cc>,
        Sabrina Dubroca <sd@queasysnail.net>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:60948 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1757439AbcHWIUq (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 23 Aug 2016 04:20:46 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

commit bcf493428840 ("netfilter: ebtables: Fix extension lookup with
identical name") added a second lookup in case the extension that was
found during the first lookup matched another extension with the same
name, but didn't release the reference on the incorrect module.

Fixes: bcf493428840 ("netfilter: ebtables: Fix extension lookup with identical name")
Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
---
 net/bridge/netfilter/ebtables.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/bridge/netfilter/ebtables.c b/net/bridge/netfilter/ebtables.c
index cceac5bb658f..0833c251aef7 100644
--- a/net/bridge/netfilter/ebtables.c
+++ b/net/bridge/netfilter/ebtables.c
@@ -368,6 +368,8 @@ ebt_check_match(struct ebt_entry_match *m, struct xt_mtchk_param *par,
 
 	match = xt_find_match(NFPROTO_BRIDGE, m->u.name, 0);
 	if (IS_ERR(match) || match->family != NFPROTO_BRIDGE) {
+		if (!IS_ERR(match))
+			module_put(match->me);
 		request_module("ebt_%s", m->u.name);
 		match = xt_find_match(NFPROTO_BRIDGE, m->u.name, 0);
 	}
-- 
2.9.3

