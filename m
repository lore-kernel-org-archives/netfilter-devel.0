From: pablo@netfilter.org
Subject: [PATCH 3/8] netfilter: ebtables: only call xt_compat_add_offset once per rule
Date: Tue, 10 May 2011 12:05:54 +0200
Message-ID: <1305021959-2980-4-git-send-email-pablo@netfilter.org>
References: <1305021959-2980-1-git-send-email-pablo@netfilter.org>
Cc: davem@davemloft.net, Florian Westphal <fw@strlen.de>,
	Patrick McHardy <kaber@trash.net>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:48571 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755417Ab1EJKGY (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 10 May 2011 06:06:24 -0400
In-Reply-To: <1305021959-2980-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Florian Westphal <fw@strlen.de>

The optimizations in commit 255d0dc34068a976
(netfilter: x_table: speedup compat operations) assume that
xt_compat_add_offset is called once per rule.

ebtables however called it for each match/target found in a rule.

The match/watcher/target parser already returns the needed delta, so it
is sufficient to move the xt_compat_add_offset call to a more reasonable
location.

While at it, also get rid of the unused COMPAT iterator macros.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Patrick McHardy <kaber@trash.net>
---
 net/bridge/netfilter/ebtables.c |   61 ++++++---------------------------------
 1 files changed, 9 insertions(+), 52 deletions(-)

diff --git a/net/bridge/netfilter/ebtables.c b/net/bridge/netfilter/ebtables.c
index 9707079..1a92b36 100644
--- a/net/bridge/netfilter/ebtables.c
+++ b/net/bridge/netfilter/ebtables.c
@@ -1882,7 +1882,7 @@ static int compat_mtw_from_user(struct compat_ebt_entry_mwt *mwt,
 	struct xt_match *match;
 	struct xt_target *wt;
 	void *dst = NULL;
-	int off, pad = 0, ret = 0;
+	int off, pad = 0;
 	unsigned int size_kern, entry_offset, match_size = mwt->match_size;
 
 	strlcpy(name, mwt->u.name, sizeof(name));
@@ -1935,13 +1935,6 @@ static int compat_mtw_from_user(struct compat_ebt_entry_mwt *mwt,
 		break;
 	}
 
-	if (!dst) {
-		ret = xt_compat_add_offset(NFPROTO_BRIDGE, entry_offset,
-					off + ebt_compat_entry_padsize());
-		if (ret < 0)
-			return ret;
-	}
-
 	state->buf_kern_offset += match_size + off;
 	state->buf_user_offset += match_size;
 	pad = XT_ALIGN(size_kern) - size_kern;
@@ -2016,50 +2009,6 @@ static int ebt_size_mwt(struct compat_ebt_entry_mwt *match32,
 	return growth;
 }
 
-#define EBT_COMPAT_WATCHER_ITERATE(e, fn, args...)          \
-({                                                          \
-	unsigned int __i;                                   \
-	int __ret = 0;                                      \
-	struct compat_ebt_entry_mwt *__watcher;             \
-	                                                    \
-	for (__i = e->watchers_offset;                      \
-	     __i < (e)->target_offset;                      \
-	     __i += __watcher->watcher_size +               \
-	     sizeof(struct compat_ebt_entry_mwt)) {         \
-		__watcher = (void *)(e) + __i;              \
-		__ret = fn(__watcher , ## args);            \
-		if (__ret != 0)                             \
-			break;                              \
-	}                                                   \
-	if (__ret == 0) {                                   \
-		if (__i != (e)->target_offset)              \
-			__ret = -EINVAL;                    \
-	}                                                   \
-	__ret;                                              \
-})
-
-#define EBT_COMPAT_MATCH_ITERATE(e, fn, args...)            \
-({                                                          \
-	unsigned int __i;                                   \
-	int __ret = 0;                                      \
-	struct compat_ebt_entry_mwt *__match;               \
-	                                                    \
-	for (__i = sizeof(struct ebt_entry);                \
-	     __i < (e)->watchers_offset;                    \
-	     __i += __match->match_size +                   \
-	     sizeof(struct compat_ebt_entry_mwt)) {         \
-		__match = (void *)(e) + __i;                \
-		__ret = fn(__match , ## args);              \
-		if (__ret != 0)                             \
-			break;                              \
-	}                                                   \
-	if (__ret == 0) {                                   \
-		if (__i != (e)->watchers_offset)            \
-			__ret = -EINVAL;                    \
-	}                                                   \
-	__ret;                                              \
-})
-
 /* called for all ebt_entry structures. */
 static int size_entry_mwt(struct ebt_entry *entry, const unsigned char *base,
 			  unsigned int *total,
@@ -2132,6 +2081,14 @@ static int size_entry_mwt(struct ebt_entry *entry, const unsigned char *base,
 		}
 	}
 
+	if (state->buf_kern_start == NULL) {
+		unsigned int offset = buf_start - (char *) base;
+
+		ret = xt_compat_add_offset(NFPROTO_BRIDGE, offset, new_offset);
+		if (ret < 0)
+			return ret;
+	}
+
 	startoff = state->buf_user_offset - startoff;
 
 	BUG_ON(*total < startoff);
-- 
1.7.2.3

