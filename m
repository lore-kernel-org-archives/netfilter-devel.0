From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 34/51] netfilter: ebtables: add ebt_get_target and ebt_get_target_c
Date: Mon,  7 May 2018 00:46:52 +0200
Message-ID: <20180506224709.29100-35-pablo@netfilter.org>
References: <20180506224709.29100-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180506224709.29100-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Taehee Yoo <ap420073@gmail.com>

ebt_get_target similar to {ip/ip6/arp}t_get_target.
and ebt_get_target_c similar to {ip/ip6/arp}t_get_target_c.

Signed-off-by: Taehee Yoo <ap420073@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/uapi/linux/netfilter_bridge/ebtables.h |  6 ++++++
 net/bridge/netfilter/ebtables.c                | 22 +++++++++++++---------
 2 files changed, 19 insertions(+), 9 deletions(-)

diff --git a/include/uapi/linux/netfilter_bridge/ebtables.h b/include/uapi/linux/netfilter_bridge/ebtables.h
index 0c7dc8315013..3b86c14ea49d 100644
--- a/include/uapi/linux/netfilter_bridge/ebtables.h
+++ b/include/uapi/linux/netfilter_bridge/ebtables.h
@@ -191,6 +191,12 @@ struct ebt_entry {
 	unsigned char elems[0] __attribute__ ((aligned (__alignof__(struct ebt_replace))));
 };
 
+static __inline__ struct ebt_entry_target *
+ebt_get_target(struct ebt_entry *e)
+{
+	return (void *)e + e->target_offset;
+}
+
 /* {g,s}etsockopt numbers */
 #define EBT_BASE_CTL            128
 
diff --git a/net/bridge/netfilter/ebtables.c b/net/bridge/netfilter/ebtables.c
index 7c07221369c0..9be240129448 100644
--- a/net/bridge/netfilter/ebtables.c
+++ b/net/bridge/netfilter/ebtables.c
@@ -177,6 +177,12 @@ struct ebt_entry *ebt_next_entry(const struct ebt_entry *entry)
 	return (void *)entry + entry->next_offset;
 }
 
+static inline const struct ebt_entry_target *
+ebt_get_target_c(const struct ebt_entry *e)
+{
+	return ebt_get_target((struct ebt_entry *)e);
+}
+
 /* Do some firewalling */
 unsigned int ebt_do_table(struct sk_buff *skb,
 			  const struct nf_hook_state *state,
@@ -230,8 +236,7 @@ unsigned int ebt_do_table(struct sk_buff *skb,
 		 */
 		EBT_WATCHER_ITERATE(point, ebt_do_watcher, skb, &acpar);
 
-		t = (struct ebt_entry_target *)
-		   (((char *)point) + point->target_offset);
+		t = ebt_get_target_c(point);
 		/* standard target */
 		if (!t->u.target->target)
 			verdict = ((struct ebt_standard_target *)t)->verdict;
@@ -637,7 +642,7 @@ ebt_cleanup_entry(struct ebt_entry *e, struct net *net, unsigned int *cnt)
 		return 1;
 	EBT_WATCHER_ITERATE(e, ebt_cleanup_watcher, net, NULL);
 	EBT_MATCH_ITERATE(e, ebt_cleanup_match, net, NULL);
-	t = (struct ebt_entry_target *)(((char *)e) + e->target_offset);
+	t = ebt_get_target(e);
 
 	par.net      = net;
 	par.target   = t->u.target;
@@ -716,7 +721,7 @@ ebt_check_entry(struct ebt_entry *e, struct net *net,
 	ret = EBT_WATCHER_ITERATE(e, ebt_check_watcher, &tgpar, &j);
 	if (ret != 0)
 		goto cleanup_watchers;
-	t = (struct ebt_entry_target *)(((char *)e) + e->target_offset);
+	t = ebt_get_target(e);
 	gap = e->next_offset - e->target_offset;
 
 	target = xt_request_find_target(NFPROTO_BRIDGE, t->u.name, 0);
@@ -789,8 +794,7 @@ static int check_chainloops(const struct ebt_entries *chain, struct ebt_cl_stack
 			if (pos == nentries)
 				continue;
 		}
-		t = (struct ebt_entry_target *)
-		   (((char *)e) + e->target_offset);
+		t = ebt_get_target_c(e);
 		if (strcmp(t->u.name, EBT_STANDARD_TARGET))
 			goto letscontinue;
 		if (e->target_offset + sizeof(struct ebt_standard_target) >
@@ -1396,7 +1400,7 @@ static inline int ebt_entry_to_user(struct ebt_entry *e, const char *base,
 		return -EFAULT;
 
 	hlp = ubase + (((char *)e + e->target_offset) - base);
-	t = (struct ebt_entry_target *)(((char *)e) + e->target_offset);
+	t = ebt_get_target_c(e);
 
 	ret = EBT_MATCH_ITERATE(e, ebt_match_to_user, base, ubase);
 	if (ret != 0)
@@ -1737,7 +1741,7 @@ static int compat_copy_entry_to_user(struct ebt_entry *e, void __user **dstptr,
 		return ret;
 	target_offset = e->target_offset - (origsize - *size);
 
-	t = (struct ebt_entry_target *) ((char *) e + e->target_offset);
+	t = ebt_get_target(e);
 
 	ret = compat_target_to_user(t, dstptr, size);
 	if (ret)
@@ -1785,7 +1789,7 @@ static int compat_calc_entry(const struct ebt_entry *e,
 	EBT_MATCH_ITERATE(e, compat_calc_match, &off);
 	EBT_WATCHER_ITERATE(e, compat_calc_watcher, &off);
 
-	t = (const struct ebt_entry_target *) ((char *) e + e->target_offset);
+	t = ebt_get_target_c(e);
 
 	off += xt_compat_target_offset(t->u.target);
 	off += ebt_compat_entry_padsize();
-- 
2.11.0
