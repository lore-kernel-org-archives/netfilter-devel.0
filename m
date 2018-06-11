From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 11/15] netfilter: ebtables: reject non-bridge targets
Date: Mon, 11 Jun 2018 11:22:29 +0200
Message-ID: <20180611092233.3219-12-pablo@netfilter.org>
References: <20180611092233.3219-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180611092233.3219-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Florian Westphal <fw@strlen.de>

the ebtables evaluation loop expects targets to return
positive values (jumps), or negative values (absolute verdicts).

This is completely different from what xtables does.
In xtables, targets are expected to return the standard netfilter
verdicts, i.e. NF_DROP, NF_ACCEPT, etc.

ebtables will consider these as jumps.

Therefore reject any target found due to unspec fallback.
v2: also reject watchers.  ebtables ignores their return value, so
a target that assumes skb ownership (and returns NF_STOLEN) causes
use-after-free.

The only watchers in the 'ebtables' front-end are log and nflog;
both have AF_BRIDGE specific wrappers on kernel side.

Reported-by: syzbot+2b43f681169a2a0d306a@syzkaller.appspotmail.com
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/bridge/netfilter/ebtables.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/net/bridge/netfilter/ebtables.c b/net/bridge/netfilter/ebtables.c
index 5f459c8b7937..08a65e4a77d0 100644
--- a/net/bridge/netfilter/ebtables.c
+++ b/net/bridge/netfilter/ebtables.c
@@ -396,6 +396,12 @@ ebt_check_watcher(struct ebt_entry_watcher *w, struct xt_tgchk_param *par,
 	watcher = xt_request_find_target(NFPROTO_BRIDGE, w->u.name, 0);
 	if (IS_ERR(watcher))
 		return PTR_ERR(watcher);
+
+	if (watcher->family != NFPROTO_BRIDGE) {
+		module_put(watcher->me);
+		return -ENOENT;
+	}
+
 	w->u.watcher = watcher;
 
 	par->target   = watcher;
@@ -715,6 +721,13 @@ ebt_check_entry(struct ebt_entry *e, struct net *net,
 		goto cleanup_watchers;
 	}
 
+	/* Reject UNSPEC, xtables verdicts/return values are incompatible */
+	if (target->family != NFPROTO_BRIDGE) {
+		module_put(target->me);
+		ret = -ENOENT;
+		goto cleanup_watchers;
+	}
+
 	t->u.target = target;
 	if (t->u.target == &ebt_standard_target) {
 		if (gap < sizeof(struct ebt_standard_target)) {
-- 
2.11.0
