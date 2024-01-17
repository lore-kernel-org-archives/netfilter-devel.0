Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1746C224C4;
	Wed, 17 Jan 2024 16:00:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705507251; cv=none; b=JeN1n6k+ED4j1qQcB2CZvtS4+TTZ7k639uMN+g/MPpSG3Kun1x2BDo4+tCNkPEBPuUSuvnDRdBDj71E44q6HBycgtyAYO8ghONdfw2vk2Jx+2Ozsdty4QbwFwKEKsLxNdI82y/WUOebt71ya+X3tN1m+ereOn/n7D2DhlxF+GTI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705507251; c=relaxed/simple;
	bh=bJxfJMx7+YX0jNcOnPpAyIUKLCrLCTQO/Za8hJRRhm8=;
	h=From:To:Cc:Subject:Date:Message-Id:X-Mailer:In-Reply-To:
	 References:MIME-Version:Content-Transfer-Encoding; b=T/k0aic61a9bXQJgYHopAecvwaCii6ZYM5WGLk8unOINWienEw7KsPXS9VwnYGM+PbKdCbuj7AaPPJf85Uteygjq0CD/vV5n8mc/KHJGAbINtyAchNjjluhdu+XcHvx+ca4aEJlGrncALamAy/fmckahGtJZVfOjUrZFYJw4kD0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de
Subject: [PATCH net 07/14] netfilter: propagate net to nf_bridge_get_physindev
Date: Wed, 17 Jan 2024 17:00:23 +0100
Message-Id: <20240117160030.140264-8-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20240117160030.140264-1-pablo@netfilter.org>
References: <20240117160030.140264-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Pavel Tikhomirov <ptikhomirov@virtuozzo.com>

This is a preparation patch for replacing physindev with physinif on
nf_bridge_info structure. We will use dev_get_by_index_rcu to resolve
device, when needed, and it requires net to be available.

Signed-off-by: Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/linux/netfilter_bridge.h           |  2 +-
 net/ipv4/netfilter/nf_reject_ipv4.c        |  2 +-
 net/ipv6/netfilter/nf_reject_ipv6.c        |  2 +-
 net/netfilter/ipset/ip_set_hash_netiface.c |  8 ++++----
 net/netfilter/nf_log_syslog.c              | 13 +++++++------
 net/netfilter/nf_queue.c                   |  2 +-
 net/netfilter/xt_physdev.c                 |  2 +-
 7 files changed, 16 insertions(+), 15 deletions(-)

diff --git a/include/linux/netfilter_bridge.h b/include/linux/netfilter_bridge.h
index f980edfdd278..e927b9a15a55 100644
--- a/include/linux/netfilter_bridge.h
+++ b/include/linux/netfilter_bridge.h
@@ -56,7 +56,7 @@ static inline int nf_bridge_get_physoutif(const struct sk_buff *skb)
 }
 
 static inline struct net_device *
-nf_bridge_get_physindev(const struct sk_buff *skb)
+nf_bridge_get_physindev(const struct sk_buff *skb, struct net *net)
 {
 	const struct nf_bridge_info *nf_bridge = nf_bridge_info_get(skb);
 
diff --git a/net/ipv4/netfilter/nf_reject_ipv4.c b/net/ipv4/netfilter/nf_reject_ipv4.c
index f01b038fc1cd..86e7d390671a 100644
--- a/net/ipv4/netfilter/nf_reject_ipv4.c
+++ b/net/ipv4/netfilter/nf_reject_ipv4.c
@@ -289,7 +289,7 @@ void nf_send_reset(struct net *net, struct sock *sk, struct sk_buff *oldskb,
 	 * build the eth header using the original destination's MAC as the
 	 * source, and send the RST packet directly.
 	 */
-	br_indev = nf_bridge_get_physindev(oldskb);
+	br_indev = nf_bridge_get_physindev(oldskb, net);
 	if (br_indev) {
 		struct ethhdr *oeth = eth_hdr(oldskb);
 
diff --git a/net/ipv6/netfilter/nf_reject_ipv6.c b/net/ipv6/netfilter/nf_reject_ipv6.c
index d45bc54b7ea5..27b2164f4c43 100644
--- a/net/ipv6/netfilter/nf_reject_ipv6.c
+++ b/net/ipv6/netfilter/nf_reject_ipv6.c
@@ -354,7 +354,7 @@ void nf_send_reset6(struct net *net, struct sock *sk, struct sk_buff *oldskb,
 	 * build the eth header using the original destination's MAC as the
 	 * source, and send the RST packet directly.
 	 */
-	br_indev = nf_bridge_get_physindev(oldskb);
+	br_indev = nf_bridge_get_physindev(oldskb, net);
 	if (br_indev) {
 		struct ethhdr *oeth = eth_hdr(oldskb);
 
diff --git a/net/netfilter/ipset/ip_set_hash_netiface.c b/net/netfilter/ipset/ip_set_hash_netiface.c
index 95aeb31c60e0..30a655e5c4fd 100644
--- a/net/netfilter/ipset/ip_set_hash_netiface.c
+++ b/net/netfilter/ipset/ip_set_hash_netiface.c
@@ -138,9 +138,9 @@ hash_netiface4_data_next(struct hash_netiface4_elem *next,
 #include "ip_set_hash_gen.h"
 
 #if IS_ENABLED(CONFIG_BRIDGE_NETFILTER)
-static const char *get_physindev_name(const struct sk_buff *skb)
+static const char *get_physindev_name(const struct sk_buff *skb, struct net *net)
 {
-	struct net_device *dev = nf_bridge_get_physindev(skb);
+	struct net_device *dev = nf_bridge_get_physindev(skb, net);
 
 	return dev ? dev->name : NULL;
 }
@@ -177,7 +177,7 @@ hash_netiface4_kadt(struct ip_set *set, const struct sk_buff *skb,
 
 	if (opt->cmdflags & IPSET_FLAG_PHYSDEV) {
 #if IS_ENABLED(CONFIG_BRIDGE_NETFILTER)
-		const char *eiface = SRCDIR ? get_physindev_name(skb) :
+		const char *eiface = SRCDIR ? get_physindev_name(skb, xt_net(par)) :
 					      get_physoutdev_name(skb);
 
 		if (!eiface)
@@ -395,7 +395,7 @@ hash_netiface6_kadt(struct ip_set *set, const struct sk_buff *skb,
 
 	if (opt->cmdflags & IPSET_FLAG_PHYSDEV) {
 #if IS_ENABLED(CONFIG_BRIDGE_NETFILTER)
-		const char *eiface = SRCDIR ? get_physindev_name(skb) :
+		const char *eiface = SRCDIR ? get_physindev_name(skb, xt_net(par)) :
 					      get_physoutdev_name(skb);
 
 		if (!eiface)
diff --git a/net/netfilter/nf_log_syslog.c b/net/netfilter/nf_log_syslog.c
index c66689ad2b49..58402226045e 100644
--- a/net/netfilter/nf_log_syslog.c
+++ b/net/netfilter/nf_log_syslog.c
@@ -111,7 +111,8 @@ nf_log_dump_packet_common(struct nf_log_buf *m, u8 pf,
 			  unsigned int hooknum, const struct sk_buff *skb,
 			  const struct net_device *in,
 			  const struct net_device *out,
-			  const struct nf_loginfo *loginfo, const char *prefix)
+			  const struct nf_loginfo *loginfo, const char *prefix,
+			  struct net *net)
 {
 	const struct net_device *physoutdev __maybe_unused;
 	const struct net_device *physindev __maybe_unused;
@@ -121,7 +122,7 @@ nf_log_dump_packet_common(struct nf_log_buf *m, u8 pf,
 			in ? in->name : "",
 			out ? out->name : "");
 #if IS_ENABLED(CONFIG_BRIDGE_NETFILTER)
-	physindev = nf_bridge_get_physindev(skb);
+	physindev = nf_bridge_get_physindev(skb, net);
 	if (physindev && in != physindev)
 		nf_log_buf_add(m, "PHYSIN=%s ", physindev->name);
 	physoutdev = nf_bridge_get_physoutdev(skb);
@@ -148,7 +149,7 @@ static void nf_log_arp_packet(struct net *net, u_int8_t pf,
 		loginfo = &default_loginfo;
 
 	nf_log_dump_packet_common(m, pf, hooknum, skb, in, out, loginfo,
-				  prefix);
+				  prefix, net);
 	dump_arp_packet(m, loginfo, skb, skb_network_offset(skb));
 
 	nf_log_buf_close(m);
@@ -845,7 +846,7 @@ static void nf_log_ip_packet(struct net *net, u_int8_t pf,
 		loginfo = &default_loginfo;
 
 	nf_log_dump_packet_common(m, pf, hooknum, skb, in,
-				  out, loginfo, prefix);
+				  out, loginfo, prefix, net);
 
 	if (in)
 		dump_mac_header(m, loginfo, skb);
@@ -880,7 +881,7 @@ static void nf_log_ip6_packet(struct net *net, u_int8_t pf,
 		loginfo = &default_loginfo;
 
 	nf_log_dump_packet_common(m, pf, hooknum, skb, in, out,
-				  loginfo, prefix);
+				  loginfo, prefix, net);
 
 	if (in)
 		dump_mac_header(m, loginfo, skb);
@@ -916,7 +917,7 @@ static void nf_log_unknown_packet(struct net *net, u_int8_t pf,
 		loginfo = &default_loginfo;
 
 	nf_log_dump_packet_common(m, pf, hooknum, skb, in, out, loginfo,
-				  prefix);
+				  prefix, net);
 
 	dump_mac_header(m, loginfo, skb);
 
diff --git a/net/netfilter/nf_queue.c b/net/netfilter/nf_queue.c
index 3dfcb3ac5cb4..e2f334f70281 100644
--- a/net/netfilter/nf_queue.c
+++ b/net/netfilter/nf_queue.c
@@ -84,7 +84,7 @@ static void __nf_queue_entry_init_physdevs(struct nf_queue_entry *entry)
 	const struct sk_buff *skb = entry->skb;
 
 	if (nf_bridge_info_exists(skb)) {
-		entry->physin = nf_bridge_get_physindev(skb);
+		entry->physin = nf_bridge_get_physindev(skb, entry->state.net);
 		entry->physout = nf_bridge_get_physoutdev(skb);
 	} else {
 		entry->physin = NULL;
diff --git a/net/netfilter/xt_physdev.c b/net/netfilter/xt_physdev.c
index ec6ed6fda96c..343e65f377d4 100644
--- a/net/netfilter/xt_physdev.c
+++ b/net/netfilter/xt_physdev.c
@@ -59,7 +59,7 @@ physdev_mt(const struct sk_buff *skb, struct xt_action_param *par)
 	    (!!outdev ^ !(info->invert & XT_PHYSDEV_OP_BRIDGED)))
 		return false;
 
-	physdev = nf_bridge_get_physindev(skb);
+	physdev = nf_bridge_get_physindev(skb, xt_net(par));
 	indev = physdev ? physdev->name : NULL;
 
 	if ((info->bitmask & XT_PHYSDEV_OP_ISIN &&
-- 
2.30.2

