From: Florian Westphal <fw@strlen.de>
Subject: [PATCH 7/7] psd: add ipv6 support
Date: Mon, 17 Sep 2012 14:55:23 +0200
Message-ID: <1347886523-19356-8-git-send-email-fw@strlen.de>
References: <1347886523-19356-1-git-send-email-fw@strlen.de>
To: netfilter-devel <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:35824 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752206Ab2IQMxg (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 17 Sep 2012 08:53:36 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.72)
	(envelope-from <fw@breakpoint.cc>)
	id 1TDapT-0000Ln-7Z
	for netfilter-devel@vger.kernel.org; Mon, 17 Sep 2012 14:53:35 +0200
In-Reply-To: <1347886523-19356-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

because most users will probably only use ipv4 psd,
allocate most of the state6 storage when the first ipv6 psd
rule is added, and not at module load time via .bss.
---
 extensions/libxt_psd.c |    2 +-
 extensions/xt_psd.c    |  234 ++++++++++++++++++++++++++++++++++++++++++++---
 2 files changed, 220 insertions(+), 16 deletions(-)

diff --git a/extensions/libxt_psd.c b/extensions/libxt_psd.c
index bd03480..3f88ac4 100644
--- a/extensions/libxt_psd.c
+++ b/extensions/libxt_psd.c
@@ -142,7 +142,7 @@ static struct xtables_match psd_mt_reg = {
 	.name           = "psd",
 	.version        = XTABLES_VERSION,
 	.revision       = 1,
-	.family         = NFPROTO_IPV4,
+	.family         = NFPROTO_UNSPEC,
 	.size           = XT_ALIGN(sizeof(struct xt_psd_info)),
 	.userspacesize	= XT_ALIGN(sizeof(struct xt_psd_info)),
 	.help           = psd_mt_help,
diff --git a/extensions/xt_psd.c b/extensions/xt_psd.c
index fbb9e22..53eeb66 100644
--- a/extensions/xt_psd.c
+++ b/extensions/xt_psd.c
@@ -22,13 +22,13 @@
 
 #define pr_fmt(x) KBUILD_MODNAME ": " x
 #include <linux/module.h>
-#include <linux/moduleparam.h>
 #include <linux/skbuff.h>
-#include <linux/ip.h>
-#include <net/tcp.h>
+#include <linux/types.h>
+#include <linux/tcp.h>
 #include <linux/spinlock.h>
-#include <linux/netfilter_ipv4/ip_tables.h>
 #include <linux/netfilter/x_tables.h>
+#include <net/ip.h>
+#include <net/ipv6.h>
 #include "xt_psd.h"
 #include "compat_xtables.h"
 
@@ -39,6 +39,7 @@ MODULE_AUTHOR("Jan Rekorajski <baggins@pld.org.pl>");
 MODULE_AUTHOR(" Mohd Nawawi Mohamad Jamili <nawawi@tracenetworkcorporation.com>");
 MODULE_DESCRIPTION("Xtables: PSD - portscan detection");
 MODULE_ALIAS("ipt_psd");
+MODULE_ALIAS("ip6t_psd");
 
 /*
  * Keep track of up to LIST_SIZE source addresses, using a hash table of
@@ -50,6 +51,10 @@ MODULE_ALIAS("ipt_psd");
 #define HASH_SIZE			(1 << HASH_LOG)
 #define HASH_MAX			0x10
 
+#if defined(CONFIG_IP6_NF_IPTABLES) || defined(CONFIG_IP6_NF_IPTABLES_MODULE)
+#	define WITH_IPV6 1
+#endif
+
 /*
  * Information we keep per each target port
  */
@@ -87,8 +92,13 @@ static struct host4 *host_to_host4(const struct host *h)
 	return (struct host4 *) h;
 }
 
+struct host6 {
+	struct host host;
+	struct in6_addr saddr;
+};
+
 /**
- * State information.
+ * State information for IPv4 portscan detection.
  * @list:	list of source addresses
  * @hash:	pointers into the list
  * @index:	oldest entry to be replaced
@@ -100,6 +110,46 @@ static struct {
 	int index;
 } state;
 
+#ifdef WITH_IPV6
+/**
+ * State information for IPv6 portscan detection.
+ * @list:	list of source addresses
+ * @hash:	pointers into the list
+ * @index:	oldest entry to be replaced
+ */
+static struct {
+	spinlock_t lock;
+	struct host6 *list;
+	struct host **hash;
+	int index;
+} state6;
+
+static struct host6 *host_to_host6(const struct host *h)
+{
+	return (struct host6 *) h;
+}
+
+/**
+ * allocate state6 memory only when needed
+ */
+static bool state6_alloc_mem(void)
+{
+	if (state6.hash != NULL)
+		return true;
+
+	state6.list = vzalloc(LIST_SIZE * sizeof(struct host6));
+	if (state6.list == NULL)
+		return false;
+
+	state6.hash = vzalloc(HASH_SIZE * sizeof(struct host*));
+	if (state6.hash == NULL) {
+		vfree(state6.list);
+		return false;
+	}
+	return true;
+}
+#endif
+
 /*
  * Convert an IP address into a hash table index.
  */
@@ -117,6 +167,12 @@ static unsigned int hashfunc(__be32 addr)
 	return hash & (HASH_SIZE - 1);
 }
 
+static inline unsigned int hashfunc6(const struct in6_addr *addr)
+{
+	__be32 h = addr->s6_addr32[0] ^ addr->s6_addr32[1];
+	return hashfunc(h ^ addr->s6_addr32[2] ^ addr->s6_addr32[3]);
+}
+
 static bool port_in_list(struct host *host, uint8_t proto, uint16_t port)
 {
 	unsigned int i;
@@ -339,6 +395,126 @@ xt_psd_match(const struct sk_buff *pskb, struct xt_action_param *match)
 	return matched;
 }
 
+#ifdef WITH_IPV6
+static bool
+handle_packet6(const struct ipv6hdr *ip6h, const struct tcphdr *tcph,
+	       const struct xt_psd_info *psdinfo, uint8_t proto, int hash)
+{
+	unsigned long now;
+	struct host *curr, *last = NULL, **head;
+	struct host6 *curr6;
+	int count = 0;
+
+	now = jiffies;
+	head = &state6.hash[hash];
+
+	curr = *head;
+	while (curr != NULL) {
+		curr6 = host_to_host6(curr);
+		if (ipv6_addr_equal(&curr6->saddr, &ip6h->saddr))
+			break;
+		count++;
+		curr = host_get_next(curr, &last);
+	}
+
+	if (curr != NULL) {
+		if (entry_is_recent(curr, psdinfo->delay_threshold, now))
+			return is_portscan(curr, psdinfo, tcph, proto);
+		curr6 = host_to_host6(curr);
+		memset(&curr6->saddr, 0, sizeof(curr6->saddr));
+		ht_unlink(head, last);
+		last = NULL;
+	}
+
+	if (proto == IPPROTO_TCP && tcph->ack)
+		return false;
+
+	if (count >= HASH_MAX && last != NULL)
+		last->next = NULL;
+
+	if (!ipv6_addr_any(&state6.list[state6.index].saddr))
+		head = &state6.hash[hashfunc6(&state6.list[state6.index].saddr)];
+	else
+		head = &last;
+
+	curr6 = &state6.list[state6.index++];
+	curr = &curr6->host;
+	remove_oldest(head, curr);
+	if (state6.index >= LIST_SIZE)
+		state6.index = 0;
+
+	head = &state6.hash[hash];
+	curr->next = *head;
+	*head = curr;
+
+	curr6 = host_to_host6(curr);
+	curr6->saddr = ip6h->saddr;
+	curr->timestamp = now;
+	curr->count = 1;
+	curr->weight = get_port_weight(psdinfo, tcph->dest);
+	curr->ports[0].number = tcph->dest;
+	curr->ports[0].proto = proto;
+	return false;
+}
+
+static void *
+get_header_pointer6(const struct sk_buff *skb, void *mem, uint8_t *proto)
+{
+	static const uint8_t types[] = {IPPROTO_TCP,
+				        IPPROTO_UDP, IPPROTO_UDPLITE};
+	unsigned int i, offset = 0;
+	int err;
+	size_t hdrlen;
+
+	for (i = 0; i < ARRAY_SIZE(types); ++i) {
+		err = ipv6_find_hdr(skb, &offset, types[i], NULL, NULL);
+		if (err < 0)
+			continue;
+
+		switch (types[i]) {
+		case IPPROTO_TCP:
+			hdrlen = sizeof(struct tcphdr);
+			break;
+		case IPPROTO_UDP:
+		case IPPROTO_UDPLITE:
+			hdrlen = sizeof(struct udphdr);
+			break;
+		default:
+			return NULL;
+		}
+		*proto = types[i];
+		return skb_header_pointer(skb, offset, hdrlen, mem);
+	}
+	return NULL;
+}
+
+static bool
+xt_psd_match6(const struct sk_buff *pskb, struct xt_action_param *match)
+{
+	const struct ipv6hdr *ip6h = ipv6_hdr(pskb);
+	struct tcphdr _tcph;
+	struct tcphdr *tcph;
+	uint8_t proto = 0;
+	bool matched;
+	int hash;
+	const struct xt_psd_info *psdinfo = match->matchinfo;
+
+	if (ipv6_addr_any(&ip6h->saddr))
+		return false;
+
+	tcph = get_header_pointer6(pskb, &_tcph, &proto);
+	if (tcph == NULL)
+		return false;
+
+	hash = hashfunc6(&ip6h->saddr);
+
+	spin_lock(&state6.lock);
+	matched = handle_packet6(ip6h, tcph, psdinfo, proto, hash);
+	spin_unlock(&state6.lock);
+	return matched;
+}
+#endif
+
 static int psd_mt_check(const struct xt_mtchk_param *par)
 {
 	const struct xt_psd_info *info = par->matchinfo;
@@ -360,25 +536,53 @@ static int psd_mt_check(const struct xt_mtchk_param *par)
 	return 0;
 }
 
-static struct xt_match xt_psd_reg __read_mostly = {
-	.name       = "psd",
-	.family     = NFPROTO_IPV4,
-	.revision   = 1,
-	.checkentry = psd_mt_check,
-	.match      = xt_psd_match,
-	.matchsize  = sizeof(struct xt_psd_info),
-	.me         = THIS_MODULE,
+#ifdef WITH_IPV6
+static int psd_mt_check6(const struct xt_mtchk_param *par)
+{
+	if (!state6_alloc_mem())
+		return -ENOMEM;
+	return psd_mt_check(par);
+}
+#endif
+
+static struct xt_match xt_psd_reg[] __read_mostly = {
+	{
+		.name       = "psd",
+		.family     = NFPROTO_IPV4,
+		.revision   = 1,
+		.checkentry = psd_mt_check,
+		.match      = xt_psd_match,
+		.matchsize  = sizeof(struct xt_psd_info),
+		.me         = THIS_MODULE,
+#ifdef WITH_IPV6
+	}, {
+		.name       = "psd",
+		.family     = NFPROTO_IPV6,
+		.revision   = 1,
+		.checkentry = psd_mt_check6,
+		.match      = xt_psd_match6,
+		.matchsize  = sizeof(struct xt_psd_info),
+		.me         = THIS_MODULE,
+#endif
+	}
 };
 
 static int __init xt_psd_init(void)
 {
 	spin_lock_init(&(state.lock));
-	return xt_register_match(&xt_psd_reg);
+#ifdef WITH_IPV6
+	spin_lock_init(&(state6.lock));
+#endif
+	return xt_register_matches(xt_psd_reg, ARRAY_SIZE(xt_psd_reg));
 }
 
 static void __exit xt_psd_exit(void)
 {
-        xt_unregister_match(&xt_psd_reg);
+        xt_unregister_matches(xt_psd_reg, ARRAY_SIZE(xt_psd_reg));
+#ifdef WITH_IPV6
+	vfree(state6.list);
+	vfree(state6.hash);
+#endif
 }
 
 module_init(xt_psd_init);
-- 
1.7.8.6

