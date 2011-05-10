From: pablo@netfilter.org
Subject: [PATCH 2/8] netfilter: fix ebtables compat support
Date: Tue, 10 May 2011 12:05:53 +0200
Message-ID: <1305021959-2980-3-git-send-email-pablo@netfilter.org>
References: <1305021959-2980-1-git-send-email-pablo@netfilter.org>
Cc: davem@davemloft.net, Eric Dumazet <eric.dumazet@gmail.com>,
	Patrick McHardy <kaber@trash.net>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:48545 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755377Ab1EJKGU (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 10 May 2011 06:06:20 -0400
In-Reply-To: <1305021959-2980-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Eric Dumazet <eric.dumazet@gmail.com>

commit 255d0dc34068a976 (netfilter: x_table: speedup compat operations)
made ebtables not working anymore.

1) xt_compat_calc_jump() is not an exact match lookup
2) compat_table_info() has a typo in xt_compat_init_offsets() call
3) compat_do_replace() misses a xt_compat_init_offsets() call

Reported-by: dann frazier <dannf@dannf.org>
Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
Signed-off-by: Patrick McHardy <kaber@trash.net>
---
 net/bridge/netfilter/ebtables.c |    3 ++-
 net/netfilter/x_tables.c        |    4 ++--
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/net/bridge/netfilter/ebtables.c b/net/bridge/netfilter/ebtables.c
index 893669c..9707079 100644
--- a/net/bridge/netfilter/ebtables.c
+++ b/net/bridge/netfilter/ebtables.c
@@ -1766,7 +1766,7 @@ static int compat_table_info(const struct ebt_table_info *info,
 
 	newinfo->entries_size = size;
 
-	xt_compat_init_offsets(AF_INET, info->nentries);
+	xt_compat_init_offsets(NFPROTO_BRIDGE, info->nentries);
 	return EBT_ENTRY_ITERATE(entries, size, compat_calc_entry, info,
 							entries, newinfo);
 }
@@ -2240,6 +2240,7 @@ static int compat_do_replace(struct net *net, void __user *user,
 
 	xt_compat_lock(NFPROTO_BRIDGE);
 
+	xt_compat_init_offsets(NFPROTO_BRIDGE, tmp.nentries);
 	ret = compat_copy_entries(entries_tmp, tmp.entries_size, &state);
 	if (ret < 0)
 		goto out_unlock;
diff --git a/net/netfilter/x_tables.c b/net/netfilter/x_tables.c
index a9adf4c..8a025a5 100644
--- a/net/netfilter/x_tables.c
+++ b/net/netfilter/x_tables.c
@@ -455,6 +455,7 @@ void xt_compat_flush_offsets(u_int8_t af)
 		vfree(xt[af].compat_tab);
 		xt[af].compat_tab = NULL;
 		xt[af].number = 0;
+		xt[af].cur = 0;
 	}
 }
 EXPORT_SYMBOL_GPL(xt_compat_flush_offsets);
@@ -473,8 +474,7 @@ int xt_compat_calc_jump(u_int8_t af, unsigned int offset)
 		else
 			return mid ? tmp[mid - 1].delta : 0;
 	}
-	WARN_ON_ONCE(1);
-	return 0;
+	return left ? tmp[left - 1].delta : 0;
 }
 EXPORT_SYMBOL_GPL(xt_compat_calc_jump);
 
-- 
1.7.2.3

