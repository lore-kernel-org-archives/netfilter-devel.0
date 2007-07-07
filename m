From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 07/50]: add some consts, remove some casts
Date: Sat,  7 Jul 2007 14:23:10 +0200 (MEST)
Message-ID: <20070707122226.1589.891.sendpatchset@localhost.localdomain>
References: <20070707122215.1589.12100.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
To: davem@davemloft.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <20070707122215.1589.12100.sendpatchset@localhost.localdomain>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

[NETFILTER]: add some consts, remove some casts

Make a number of variables const and/or remove unneeded casts.

Signed-off-by: Jan Engelhardt <jengelh@gmx.de>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit a04b76f652ab27c1258a2809630389babf12ada4
tree 37d4c2927ff7dd01626ac27c9a27a500d45740bc
parent 2fdd500c971b1e3423264a0cddc3dc1c4a467914
author Jan Engelhardt <jengelh@gmx.de> Sat, 07 Jul 2007 12:15:15 +0200
committer Patrick McHardy <kaber@trash.net> Sat, 07 Jul 2007 12:15:15 +0200

 net/ipv4/netfilter/ipt_CLUSTERIP.c  |   11 ++++++-----
 net/ipv4/netfilter/ipt_LOG.c        |   26 +++++++++++++++++---------
 net/ipv4/netfilter/ipt_MASQUERADE.c |    8 ++++----
 net/ipv4/netfilter/ipt_REJECT.c     |    2 +-
 net/ipv4/netfilter/ipt_TTL.c        |    2 +-
 net/ipv4/netfilter/ipt_ULOG.c       |    6 +++---
 net/ipv4/netfilter/ipt_ah.c         |    3 ++-
 net/ipv4/netfilter/ipt_ecn.c        |    3 ++-
 net/ipv4/netfilter/ipt_recent.c     |    2 +-
 net/ipv4/netfilter/nf_nat_helper.c  |    4 ++--
 net/ipv6/netfilter/ip6t_HL.c        |    2 +-
 net/ipv6/netfilter/ip6t_LOG.c       |   27 ++++++++++++++++++---------
 net/ipv6/netfilter/ip6t_REJECT.c    |    2 +-
 net/ipv6/netfilter/ip6t_ah.c        |    3 ++-
 net/ipv6/netfilter/ip6t_frag.c      |    3 ++-
 net/ipv6/netfilter/ip6t_hbh.c       |    9 ++++++---
 net/ipv6/netfilter/ip6t_mh.c        |    3 ++-
 net/ipv6/netfilter/ip6t_rt.c        |   10 ++++++----
 net/netfilter/core.c                |    6 +++---
 net/netfilter/xt_CONNMARK.c         |    6 +++---
 net/netfilter/xt_CONNSECMARK.c      |    4 ++--
 net/netfilter/xt_MARK.c             |    8 ++++----
 net/netfilter/xt_NFLOG.c            |    2 +-
 net/netfilter/xt_connbytes.c        |    2 +-
 net/netfilter/xt_connmark.c         |    8 ++++----
 net/netfilter/xt_conntrack.c        |    8 ++++----
 net/netfilter/xt_dccp.c             |    2 +-
 net/netfilter/xt_hashlimit.c        |   30 ++++++++++++++++++------------
 net/netfilter/xt_helper.c           |    6 +++---
 net/netfilter/xt_limit.c            |    7 ++++---
 net/netfilter/xt_mark.c             |    4 ++--
 net/netfilter/xt_physdev.c          |    2 +-
 net/netfilter/xt_policy.c           |    6 +++---
 net/netfilter/xt_quota.c            |    5 +++--
 net/netfilter/xt_realm.c            |    2 +-
 net/netfilter/xt_statistic.c        |    2 +-
 36 files changed, 136 insertions(+), 100 deletions(-)

diff --git a/net/ipv4/netfilter/ipt_CLUSTERIP.c b/net/ipv4/netfilter/ipt_CLUSTERIP.c
index e82339a..2de7ae0 100644
--- a/net/ipv4/netfilter/ipt_CLUSTERIP.c
+++ b/net/ipv4/netfilter/ipt_CLUSTERIP.c
@@ -235,12 +235,13 @@ clusterip_del_node(struct clusterip_config *c, u_int16_t nodenum)
 #endif
 
 static inline u_int32_t
-clusterip_hashfn(struct sk_buff *skb, struct clusterip_config *config)
+clusterip_hashfn(const struct sk_buff *skb,
+		 const struct clusterip_config *config)
 {
-	struct iphdr *iph = ip_hdr(skb);
+	const struct iphdr *iph = ip_hdr(skb);
 	unsigned long hashval;
 	u_int16_t sport, dport;
-	u_int16_t *ports;
+	const u_int16_t *ports;
 
 	switch (iph->protocol) {
 	case IPPROTO_TCP:
@@ -249,7 +250,7 @@ clusterip_hashfn(struct sk_buff *skb, struct clusterip_config *config)
 	case IPPROTO_SCTP:
 	case IPPROTO_DCCP:
 	case IPPROTO_ICMP:
-		ports = (void *)iph+iph->ihl*4;
+		ports = (const void *)iph+iph->ihl*4;
 		sport = ports[0];
 		dport = ports[1];
 		break;
@@ -289,7 +290,7 @@ clusterip_hashfn(struct sk_buff *skb, struct clusterip_config *config)
 }
 
 static inline int
-clusterip_responsible(struct clusterip_config *config, u_int32_t hash)
+clusterip_responsible(const struct clusterip_config *config, u_int32_t hash)
 {
 	return test_bit(hash - 1, &config->local_nodes);
 }
diff --git a/net/ipv4/netfilter/ipt_LOG.c b/net/ipv4/netfilter/ipt_LOG.c
index bbff6c3..bcc43a6 100644
--- a/net/ipv4/netfilter/ipt_LOG.c
+++ b/net/ipv4/netfilter/ipt_LOG.c
@@ -41,7 +41,8 @@ static void dump_packet(const struct nf_loginfo *info,
 			const struct sk_buff *skb,
 			unsigned int iphoff)
 {
-	struct iphdr _iph, *ih;
+	struct iphdr _iph;
+	const struct iphdr *ih;
 	unsigned int logflags;
 
 	if (info->type == NF_LOG_TYPE_LOG)
@@ -100,7 +101,8 @@ static void dump_packet(const struct nf_loginfo *info,
 
 	switch (ih->protocol) {
 	case IPPROTO_TCP: {
-		struct tcphdr _tcph, *th;
+		struct tcphdr _tcph;
+		const struct tcphdr *th;
 
 		/* Max length: 10 "PROTO=TCP " */
 		printk("PROTO=TCP ");
@@ -151,7 +153,7 @@ static void dump_packet(const struct nf_loginfo *info,
 		if ((logflags & IPT_LOG_TCPOPT)
 		    && th->doff * 4 > sizeof(struct tcphdr)) {
 			unsigned char _opt[4 * 15 - sizeof(struct tcphdr)];
-			unsigned char *op;
+			const unsigned char *op;
 			unsigned int i, optsize;
 
 			optsize = th->doff * 4 - sizeof(struct tcphdr);
@@ -173,7 +175,8 @@ static void dump_packet(const struct nf_loginfo *info,
 	}
 	case IPPROTO_UDP:
 	case IPPROTO_UDPLITE: {
-		struct udphdr _udph, *uh;
+		struct udphdr _udph;
+		const struct udphdr *uh;
 
 		if (ih->protocol == IPPROTO_UDP)
 			/* Max length: 10 "PROTO=UDP "     */
@@ -200,7 +203,8 @@ static void dump_packet(const struct nf_loginfo *info,
 		break;
 	}
 	case IPPROTO_ICMP: {
-		struct icmphdr _icmph, *ich;
+		struct icmphdr _icmph;
+		const struct icmphdr *ich;
 		static const size_t required_len[NR_ICMP_TYPES+1]
 			= { [ICMP_ECHOREPLY] = 4,
 			    [ICMP_DEST_UNREACH]
@@ -285,7 +289,8 @@ static void dump_packet(const struct nf_loginfo *info,
 	}
 	/* Max Length */
 	case IPPROTO_AH: {
-		struct ip_auth_hdr _ahdr, *ah;
+		struct ip_auth_hdr _ahdr;
+		const struct ip_auth_hdr *ah;
 
 		if (ntohs(ih->frag_off) & IP_OFFSET)
 			break;
@@ -307,7 +312,8 @@ static void dump_packet(const struct nf_loginfo *info,
 		break;
 	}
 	case IPPROTO_ESP: {
-		struct ip_esp_hdr _esph, *eh;
+		struct ip_esp_hdr _esph;
+		const struct ip_esp_hdr *eh;
 
 		/* Max length: 10 "PROTO=ESP " */
 		printk("PROTO=ESP ");
@@ -385,11 +391,13 @@ ipt_log_packet(unsigned int pf,
 	       out ? out->name : "");
 #ifdef CONFIG_BRIDGE_NETFILTER
 	if (skb->nf_bridge) {
-		struct net_device *physindev = skb->nf_bridge->physindev;
-		struct net_device *physoutdev = skb->nf_bridge->physoutdev;
+		const struct net_device *physindev;
+		const struct net_device *physoutdev;
 
+		physindev = skb->nf_bridge->physindev;
 		if (physindev && in != physindev)
 			printk("PHYSIN=%s ", physindev->name);
+		physoutdev = skb->nf_bridge->physoutdev;
 		if (physoutdev && out != physoutdev)
 			printk("PHYSOUT=%s ", physoutdev->name);
 	}
diff --git a/net/ipv4/netfilter/ipt_MASQUERADE.c b/net/ipv4/netfilter/ipt_MASQUERADE.c
index b5b2164..846a0e7 100644
--- a/net/ipv4/netfilter/ipt_MASQUERADE.c
+++ b/net/ipv4/netfilter/ipt_MASQUERADE.c
@@ -70,7 +70,7 @@ masquerade_target(struct sk_buff **pskb,
 	enum ip_conntrack_info ctinfo;
 	struct nf_nat_range newrange;
 	const struct nf_nat_multi_range_compat *mr;
-	struct rtable *rt;
+	const struct rtable *rt;
 	__be32 newsrc;
 
 	NF_CT_ASSERT(hooknum == NF_IP_POST_ROUTING);
@@ -112,7 +112,7 @@ masquerade_target(struct sk_buff **pskb,
 static inline int
 device_cmp(struct nf_conn *i, void *ifindex)
 {
-	struct nf_conn_nat *nat = nfct_nat(i);
+	const struct nf_conn_nat *nat = nfct_nat(i);
 	int ret;
 
 	if (!nat)
@@ -129,7 +129,7 @@ static int masq_device_event(struct notifier_block *this,
 			     unsigned long event,
 			     void *ptr)
 {
-	struct net_device *dev = ptr;
+	const struct net_device *dev = ptr;
 
 	if (event == NETDEV_DOWN) {
 		/* Device was downed.  Search entire table for
@@ -147,7 +147,7 @@ static int masq_inet_event(struct notifier_block *this,
 			   unsigned long event,
 			   void *ptr)
 {
-	struct net_device *dev = ((struct in_ifaddr *)ptr)->ifa_dev->dev;
+	const struct net_device *dev = ((struct in_ifaddr *)ptr)->ifa_dev->dev;
 
 	if (event == NETDEV_DOWN) {
 		/* IP address was deleted.  Search entire table for
diff --git a/net/ipv4/netfilter/ipt_REJECT.c b/net/ipv4/netfilter/ipt_REJECT.c
index 5c3270d..90f7b70 100644
--- a/net/ipv4/netfilter/ipt_REJECT.c
+++ b/net/ipv4/netfilter/ipt_REJECT.c
@@ -122,7 +122,7 @@ static void send_reset(struct sk_buff *oldskb, int hook)
 	tcph->check = 0;
 	tcph->check = tcp_v4_check(sizeof(struct tcphdr),
 				   niph->saddr, niph->daddr,
-				   csum_partial((char *)tcph,
+				   csum_partial(tcph,
 						sizeof(struct tcphdr), 0));
 
 	/* Set DF, id = 0 */
diff --git a/net/ipv4/netfilter/ipt_TTL.c b/net/ipv4/netfilter/ipt_TTL.c
index 96b6e35..f53f2c4 100644
--- a/net/ipv4/netfilter/ipt_TTL.c
+++ b/net/ipv4/netfilter/ipt_TTL.c
@@ -68,7 +68,7 @@ static bool ipt_ttl_checkentry(const char *tablename,
 		void *targinfo,
 		unsigned int hook_mask)
 {
-	struct ipt_TTL_info *info = targinfo;
+	const struct ipt_TTL_info *info = targinfo;
 
 	if (info->mode > IPT_TTL_MAXMODE) {
 		printk(KERN_WARNING "ipt_TTL: invalid or unknown Mode %u\n",
diff --git a/net/ipv4/netfilter/ipt_ULOG.c b/net/ipv4/netfilter/ipt_ULOG.c
index dfa7afd..282eb00 100644
--- a/net/ipv4/netfilter/ipt_ULOG.c
+++ b/net/ipv4/netfilter/ipt_ULOG.c
@@ -334,7 +334,7 @@ static bool ipt_ulog_checkentry(const char *tablename,
 				void *targinfo,
 				unsigned int hookmask)
 {
-	struct ipt_ulog_info *loginfo = (struct ipt_ulog_info *) targinfo;
+	const struct ipt_ulog_info *loginfo = targinfo;
 
 	if (loginfo->prefix[sizeof(loginfo->prefix) - 1] != '\0') {
 		DEBUGP("ipt_ULOG: prefix term %i\n",
@@ -359,7 +359,7 @@ struct compat_ipt_ulog_info {
 
 static void compat_from_user(void *dst, void *src)
 {
-	struct compat_ipt_ulog_info *cl = src;
+	const struct compat_ipt_ulog_info *cl = src;
 	struct ipt_ulog_info l = {
 		.nl_group	= cl->nl_group,
 		.copy_range	= cl->copy_range,
@@ -372,7 +372,7 @@ static void compat_from_user(void *dst, void *src)
 
 static int compat_to_user(void __user *dst, void *src)
 {
-	struct ipt_ulog_info *l = src;
+	const struct ipt_ulog_info *l = src;
 	struct compat_ipt_ulog_info cl = {
 		.nl_group	= l->nl_group,
 		.copy_range	= l->copy_range,
diff --git a/net/ipv4/netfilter/ipt_ah.c b/net/ipv4/netfilter/ipt_ah.c
index 6b5b7c9..49d503c 100644
--- a/net/ipv4/netfilter/ipt_ah.c
+++ b/net/ipv4/netfilter/ipt_ah.c
@@ -46,7 +46,8 @@ match(const struct sk_buff *skb,
       unsigned int protoff,
       bool *hotdrop)
 {
-	struct ip_auth_hdr _ahdr, *ah;
+	struct ip_auth_hdr _ahdr;
+	const struct ip_auth_hdr *ah;
 	const struct ipt_ah *ahinfo = matchinfo;
 
 	/* Must not be a fragment. */
diff --git a/net/ipv4/netfilter/ipt_ecn.c b/net/ipv4/netfilter/ipt_ecn.c
index ba4f549..3129e31 100644
--- a/net/ipv4/netfilter/ipt_ecn.c
+++ b/net/ipv4/netfilter/ipt_ecn.c
@@ -32,7 +32,8 @@ static inline bool match_tcp(const struct sk_buff *skb,
 			     const struct ipt_ecn_info *einfo,
 			     bool *hotdrop)
 {
-	struct tcphdr _tcph, *th;
+	struct tcphdr _tcph;
+	const struct tcphdr *th;
 
 	/* In practice, TCP match does this, so can't fail.  But let's
 	 * be good citizens.
diff --git a/net/ipv4/netfilter/ipt_recent.c b/net/ipv4/netfilter/ipt_recent.c
index d632e0e..d03e6a6 100644
--- a/net/ipv4/netfilter/ipt_recent.c
+++ b/net/ipv4/netfilter/ipt_recent.c
@@ -323,7 +323,7 @@ struct recent_iter_state {
 static void *recent_seq_start(struct seq_file *seq, loff_t *pos)
 {
 	struct recent_iter_state *st = seq->private;
-	struct recent_table *t = st->table;
+	const struct recent_table *t = st->table;
 	struct recent_entry *e;
 	loff_t p = *pos;
 
diff --git a/net/ipv4/netfilter/nf_nat_helper.c b/net/ipv4/netfilter/nf_nat_helper.c
index b1aa598..ef0a99e 100644
--- a/net/ipv4/netfilter/nf_nat_helper.c
+++ b/net/ipv4/netfilter/nf_nat_helper.c
@@ -190,7 +190,7 @@ nf_nat_mangle_tcp_packet(struct sk_buff **pskb,
 			tcph->check = 0;
 			tcph->check = tcp_v4_check(datalen,
 						   iph->saddr, iph->daddr,
-						   csum_partial((char *)tcph,
+						   csum_partial(tcph,
 								datalen, 0));
 		}
 	} else
@@ -278,7 +278,7 @@ nf_nat_mangle_udp_packet(struct sk_buff **pskb,
 			udph->check = 0;
 			udph->check = csum_tcpudp_magic(iph->saddr, iph->daddr,
 							datalen, IPPROTO_UDP,
-							csum_partial((char *)udph,
+							csum_partial(udph,
 								     datalen, 0));
 			if (!udph->check)
 				udph->check = CSUM_MANGLED_0;
diff --git a/net/ipv6/netfilter/ip6t_HL.c b/net/ipv6/netfilter/ip6t_HL.c
index 82966c0..20047ff 100644
--- a/net/ipv6/netfilter/ip6t_HL.c
+++ b/net/ipv6/netfilter/ip6t_HL.c
@@ -64,7 +64,7 @@ static bool ip6t_hl_checkentry(const char *tablename,
 		void *targinfo,
 		unsigned int hook_mask)
 {
-	struct ip6t_HL_info *info = targinfo;
+	const struct ip6t_HL_info *info = targinfo;
 
 	if (info->mode > IP6T_HL_MAXMODE) {
 		printk(KERN_WARNING "ip6t_HL: invalid or unknown Mode %u\n",
diff --git a/net/ipv6/netfilter/ip6t_LOG.c b/net/ipv6/netfilter/ip6t_LOG.c
index aa4b9a1..996168d 100644
--- a/net/ipv6/netfilter/ip6t_LOG.c
+++ b/net/ipv6/netfilter/ip6t_LOG.c
@@ -48,7 +48,8 @@ static void dump_packet(const struct nf_loginfo *info,
 {
 	u_int8_t currenthdr;
 	int fragment;
-	struct ipv6hdr _ip6h, *ih;
+	struct ipv6hdr _ip6h;
+	const struct ipv6hdr *ih;
 	unsigned int ptr;
 	unsigned int hdrlen = 0;
 	unsigned int logflags;
@@ -78,7 +79,8 @@ static void dump_packet(const struct nf_loginfo *info,
 	ptr = ip6hoff + sizeof(struct ipv6hdr);
 	currenthdr = ih->nexthdr;
 	while (currenthdr != NEXTHDR_NONE && ip6t_ext_hdr(currenthdr)) {
-		struct ipv6_opt_hdr _hdr, *hp;
+		struct ipv6_opt_hdr _hdr;
+		const struct ipv6_opt_hdr *hp;
 
 		hp = skb_header_pointer(skb, ptr, sizeof(_hdr), &_hdr);
 		if (hp == NULL) {
@@ -92,7 +94,8 @@ static void dump_packet(const struct nf_loginfo *info,
 
 		switch (currenthdr) {
 		case IPPROTO_FRAGMENT: {
-			struct frag_hdr _fhdr, *fh;
+			struct frag_hdr _fhdr;
+			const struct frag_hdr *fh;
 
 			printk("FRAG:");
 			fh = skb_header_pointer(skb, ptr, sizeof(_fhdr),
@@ -131,7 +134,8 @@ static void dump_packet(const struct nf_loginfo *info,
 		/* Max Length */
 		case IPPROTO_AH:
 			if (logflags & IP6T_LOG_IPOPT) {
-				struct ip_auth_hdr _ahdr, *ah;
+				struct ip_auth_hdr _ahdr;
+				const struct ip_auth_hdr *ah;
 
 				/* Max length: 3 "AH " */
 				printk("AH ");
@@ -162,7 +166,8 @@ static void dump_packet(const struct nf_loginfo *info,
 			break;
 		case IPPROTO_ESP:
 			if (logflags & IP6T_LOG_IPOPT) {
-				struct ip_esp_hdr _esph, *eh;
+				struct ip_esp_hdr _esph;
+				const struct ip_esp_hdr *eh;
 
 				/* Max length: 4 "ESP " */
 				printk("ESP ");
@@ -202,7 +207,8 @@ static void dump_packet(const struct nf_loginfo *info,
 
 	switch (currenthdr) {
 	case IPPROTO_TCP: {
-		struct tcphdr _tcph, *th;
+		struct tcphdr _tcph;
+		const struct tcphdr *th;
 
 		/* Max length: 10 "PROTO=TCP " */
 		printk("PROTO=TCP ");
@@ -250,7 +256,8 @@ static void dump_packet(const struct nf_loginfo *info,
 
 		if ((logflags & IP6T_LOG_TCPOPT)
 		    && th->doff * 4 > sizeof(struct tcphdr)) {
-			u_int8_t _opt[60 - sizeof(struct tcphdr)], *op;
+			u_int8_t _opt[60 - sizeof(struct tcphdr)];
+			const u_int8_t *op;
 			unsigned int i;
 			unsigned int optsize = th->doff * 4
 					       - sizeof(struct tcphdr);
@@ -273,7 +280,8 @@ static void dump_packet(const struct nf_loginfo *info,
 	}
 	case IPPROTO_UDP:
 	case IPPROTO_UDPLITE: {
-		struct udphdr _udph, *uh;
+		struct udphdr _udph;
+		const struct udphdr *uh;
 
 		if (currenthdr == IPPROTO_UDP)
 			/* Max length: 10 "PROTO=UDP "     */
@@ -298,7 +306,8 @@ static void dump_packet(const struct nf_loginfo *info,
 		break;
 	}
 	case IPPROTO_ICMPV6: {
-		struct icmp6hdr _icmp6h, *ic;
+		struct icmp6hdr _icmp6h;
+		const struct icmp6hdr *ic;
 
 		/* Max length: 13 "PROTO=ICMPv6 " */
 		printk("PROTO=ICMPv6 ");
diff --git a/net/ipv6/netfilter/ip6t_REJECT.c b/net/ipv6/netfilter/ip6t_REJECT.c
index 8639a05..4df07f0 100644
--- a/net/ipv6/netfilter/ip6t_REJECT.c
+++ b/net/ipv6/netfilter/ip6t_REJECT.c
@@ -159,7 +159,7 @@ static void send_reset(struct sk_buff *oldskb)
 	tcph->check = csum_ipv6_magic(&ipv6_hdr(nskb)->saddr,
 				      &ipv6_hdr(nskb)->daddr,
 				      sizeof(struct tcphdr), IPPROTO_TCP,
-				      csum_partial((char *)tcph,
+				      csum_partial(tcph,
 						   sizeof(struct tcphdr), 0));
 
 	nf_ct_attach(nskb, oldskb);
diff --git a/net/ipv6/netfilter/ip6t_ah.c b/net/ipv6/netfilter/ip6t_ah.c
index 8fc00bd..b4b1d28 100644
--- a/net/ipv6/netfilter/ip6t_ah.c
+++ b/net/ipv6/netfilter/ip6t_ah.c
@@ -51,7 +51,8 @@ match(const struct sk_buff *skb,
       unsigned int protoff,
       bool *hotdrop)
 {
-	struct ip_auth_hdr *ah, _ah;
+	struct ip_auth_hdr _ah;
+	const struct ip_auth_hdr *ah;
 	const struct ip6t_ah *ahinfo = matchinfo;
 	unsigned int ptr;
 	unsigned int hdrlen = 0;
diff --git a/net/ipv6/netfilter/ip6t_frag.c b/net/ipv6/netfilter/ip6t_frag.c
index f0aed89..e0e416b 100644
--- a/net/ipv6/netfilter/ip6t_frag.c
+++ b/net/ipv6/netfilter/ip6t_frag.c
@@ -50,7 +50,8 @@ match(const struct sk_buff *skb,
       unsigned int protoff,
       bool *hotdrop)
 {
-	struct frag_hdr _frag, *fh;
+	struct frag_hdr _frag;
+	const struct frag_hdr *fh;
 	const struct ip6t_frag *fraginfo = matchinfo;
 	unsigned int ptr;
 	int err;
diff --git a/net/ipv6/netfilter/ip6t_hbh.c b/net/ipv6/netfilter/ip6t_hbh.c
index 6fdd797..bbd2615 100644
--- a/net/ipv6/netfilter/ip6t_hbh.c
+++ b/net/ipv6/netfilter/ip6t_hbh.c
@@ -57,14 +57,17 @@ match(const struct sk_buff *skb,
       unsigned int protoff,
       bool *hotdrop)
 {
-	struct ipv6_opt_hdr _optsh, *oh;
+	struct ipv6_opt_hdr _optsh;
+	const struct ipv6_opt_hdr *oh;
 	const struct ip6t_opts *optinfo = matchinfo;
 	unsigned int temp;
 	unsigned int ptr;
 	unsigned int hdrlen = 0;
 	bool ret = false;
-	u8 _opttype, *tp = NULL;
-	u8 _optlen, *lp = NULL;
+	u8 _opttype;
+	u8 _optlen;
+	const u_int8_t *tp = NULL;
+	const u_int8_t *lp = NULL;
 	unsigned int optlen;
 	int err;
 
diff --git a/net/ipv6/netfilter/ip6t_mh.c b/net/ipv6/netfilter/ip6t_mh.c
index a3008b4..e94fdd8 100644
--- a/net/ipv6/netfilter/ip6t_mh.c
+++ b/net/ipv6/netfilter/ip6t_mh.c
@@ -47,7 +47,8 @@ match(const struct sk_buff *skb,
 	 unsigned int protoff,
 	 bool *hotdrop)
 {
-	struct ip6_mh _mh, *mh;
+	struct ip6_mh _mh;
+	const struct ip6_mh *mh;
 	const struct ip6t_mh *mhinfo = matchinfo;
 
 	/* Must not be a fragment. */
diff --git a/net/ipv6/netfilter/ip6t_rt.c b/net/ipv6/netfilter/ip6t_rt.c
index e991ed4..bc5ff4b 100644
--- a/net/ipv6/netfilter/ip6t_rt.c
+++ b/net/ipv6/netfilter/ip6t_rt.c
@@ -52,13 +52,15 @@ match(const struct sk_buff *skb,
       unsigned int protoff,
       bool *hotdrop)
 {
-	struct ipv6_rt_hdr _route, *rh;
+	struct ipv6_rt_hdr _route;
+	const struct ipv6_rt_hdr *rh;
 	const struct ip6t_rt *rtinfo = matchinfo;
 	unsigned int temp;
 	unsigned int ptr;
 	unsigned int hdrlen = 0;
 	bool ret = false;
-	struct in6_addr *ap, _addr;
+	struct in6_addr _addr;
+	const struct in6_addr *ap;
 	int err;
 
 	err = ipv6_find_hdr(skb, &ptr, NEXTHDR_ROUTING, NULL);
@@ -100,9 +102,9 @@ match(const struct sk_buff *skb,
 		 !!(rtinfo->invflags & IP6T_RT_INV_LEN))));
 	DEBUGP("res %02X %02X %02X ",
 	       (rtinfo->flags & IP6T_RT_RES),
-	       ((struct rt0_hdr *)rh)->reserved,
+	       ((const struct rt0_hdr *)rh)->reserved,
 	       !((rtinfo->flags & IP6T_RT_RES) &&
-		 (((struct rt0_hdr *)rh)->reserved)));
+		 (((const struct rt0_hdr *)rh)->reserved)));
 
 	ret = (rh != NULL)
 	      &&
diff --git a/net/netfilter/core.c b/net/netfilter/core.c
index 3aaabec..381a77c 100644
--- a/net/netfilter/core.c
+++ b/net/netfilter/core.c
@@ -231,13 +231,13 @@ void nf_proto_csum_replace4(__sum16 *sum, struct sk_buff *skb,
 {
 	__be32 diff[] = { ~from, to };
 	if (skb->ip_summed != CHECKSUM_PARTIAL) {
-		*sum = csum_fold(csum_partial((char *)diff, sizeof(diff),
+		*sum = csum_fold(csum_partial(diff, sizeof(diff),
 				~csum_unfold(*sum)));
 		if (skb->ip_summed == CHECKSUM_COMPLETE && pseudohdr)
-			skb->csum = ~csum_partial((char *)diff, sizeof(diff),
+			skb->csum = ~csum_partial(diff, sizeof(diff),
 						~skb->csum);
 	} else if (pseudohdr)
-		*sum = ~csum_fold(csum_partial((char *)diff, sizeof(diff),
+		*sum = ~csum_fold(csum_partial(diff, sizeof(diff),
 				csum_unfold(*sum)));
 }
 EXPORT_SYMBOL(nf_proto_csum_replace4);
diff --git a/net/netfilter/xt_CONNMARK.c b/net/netfilter/xt_CONNMARK.c
index 4e8aa1b..4284a59 100644
--- a/net/netfilter/xt_CONNMARK.c
+++ b/net/netfilter/xt_CONNMARK.c
@@ -83,7 +83,7 @@ checkentry(const char *tablename,
 	   void *targinfo,
 	   unsigned int hook_mask)
 {
-	struct xt_connmark_target_info *matchinfo = targinfo;
+	const struct xt_connmark_target_info *matchinfo = targinfo;
 
 	if (nf_ct_l3proto_try_module_get(target->family) < 0) {
 		printk(KERN_WARNING "can't load conntrack support for "
@@ -121,7 +121,7 @@ struct compat_xt_connmark_target_info {
 
 static void compat_from_user(void *dst, void *src)
 {
-	struct compat_xt_connmark_target_info *cm = src;
+	const struct compat_xt_connmark_target_info *cm = src;
 	struct xt_connmark_target_info m = {
 		.mark	= cm->mark,
 		.mask	= cm->mask,
@@ -132,7 +132,7 @@ static void compat_from_user(void *dst, void *src)
 
 static int compat_to_user(void __user *dst, void *src)
 {
-	struct xt_connmark_target_info *m = src;
+	const struct xt_connmark_target_info *m = src;
 	struct compat_xt_connmark_target_info cm = {
 		.mark	= m->mark,
 		.mask	= m->mask,
diff --git a/net/netfilter/xt_CONNSECMARK.c b/net/netfilter/xt_CONNSECMARK.c
index ab2f0d0..8d5e154 100644
--- a/net/netfilter/xt_CONNSECMARK.c
+++ b/net/netfilter/xt_CONNSECMARK.c
@@ -33,7 +33,7 @@ MODULE_ALIAS("ip6t_CONNSECMARK");
  * If the packet has a security mark and the connection does not, copy
  * the security mark from the packet to the connection.
  */
-static void secmark_save(struct sk_buff *skb)
+static void secmark_save(const struct sk_buff *skb)
 {
 	if (skb->secmark) {
 		struct nf_conn *ct;
@@ -89,7 +89,7 @@ static bool checkentry(const char *tablename, const void *entry,
 		       const struct xt_target *target, void *targinfo,
 		       unsigned int hook_mask)
 {
-	struct xt_connsecmark_target_info *info = targinfo;
+	const struct xt_connsecmark_target_info *info = targinfo;
 
 	if (nf_ct_l3proto_try_module_get(target->family) < 0) {
 		printk(KERN_WARNING "can't load conntrack support for "
diff --git a/net/netfilter/xt_MARK.c b/net/netfilter/xt_MARK.c
index bd9cdf2..6b7369f 100644
--- a/net/netfilter/xt_MARK.c
+++ b/net/netfilter/xt_MARK.c
@@ -72,7 +72,7 @@ checkentry_v0(const char *tablename,
 	      void *targinfo,
 	      unsigned int hook_mask)
 {
-	struct xt_mark_target_info *markinfo = targinfo;
+	const struct xt_mark_target_info *markinfo = targinfo;
 
 	if (markinfo->mark > 0xffffffff) {
 		printk(KERN_WARNING "MARK: Only supports 32bit wide mark\n");
@@ -88,7 +88,7 @@ checkentry_v1(const char *tablename,
 	      void *targinfo,
 	      unsigned int hook_mask)
 {
-	struct xt_mark_target_info_v1 *markinfo = targinfo;
+	const struct xt_mark_target_info_v1 *markinfo = targinfo;
 
 	if (markinfo->mode != XT_MARK_SET
 	    && markinfo->mode != XT_MARK_AND
@@ -114,7 +114,7 @@ struct compat_xt_mark_target_info_v1 {
 
 static void compat_from_user_v1(void *dst, void *src)
 {
-	struct compat_xt_mark_target_info_v1 *cm = src;
+	const struct compat_xt_mark_target_info_v1 *cm = src;
 	struct xt_mark_target_info_v1 m = {
 		.mark	= cm->mark,
 		.mode	= cm->mode,
@@ -124,7 +124,7 @@ static void compat_from_user_v1(void *dst, void *src)
 
 static int compat_to_user_v1(void __user *dst, void *src)
 {
-	struct xt_mark_target_info_v1 *m = src;
+	const struct xt_mark_target_info_v1 *m = src;
 	struct compat_xt_mark_target_info_v1 cm = {
 		.mark	= m->mark,
 		.mode	= m->mode,
diff --git a/net/netfilter/xt_NFLOG.c b/net/netfilter/xt_NFLOG.c
index 0c6f283..20e55d5 100644
--- a/net/netfilter/xt_NFLOG.c
+++ b/net/netfilter/xt_NFLOG.c
@@ -43,7 +43,7 @@ nflog_checkentry(const char *tablename, const void *entry,
 		 const struct xt_target *target, void *targetinfo,
 		 unsigned int hookmask)
 {
-	struct xt_nflog_info *info = targetinfo;
+	const struct xt_nflog_info *info = targetinfo;
 
 	if (info->flags & ~XT_NFLOG_MASK)
 		return false;
diff --git a/net/netfilter/xt_connbytes.c b/net/netfilter/xt_connbytes.c
index 1254178..99c246e 100644
--- a/net/netfilter/xt_connbytes.c
+++ b/net/netfilter/xt_connbytes.c
@@ -26,7 +26,7 @@ match(const struct sk_buff *skb,
       bool *hotdrop)
 {
 	const struct xt_connbytes_info *sinfo = matchinfo;
-	struct nf_conn *ct;
+	const struct nf_conn *ct;
 	enum ip_conntrack_info ctinfo;
 	u_int64_t what = 0;	/* initialize to make gcc happy */
 	u_int64_t bytes = 0;
diff --git a/net/netfilter/xt_connmark.c b/net/netfilter/xt_connmark.c
index 94d5251..71f3c1a 100644
--- a/net/netfilter/xt_connmark.c
+++ b/net/netfilter/xt_connmark.c
@@ -41,7 +41,7 @@ match(const struct sk_buff *skb,
       bool *hotdrop)
 {
 	const struct xt_connmark_info *info = matchinfo;
-	struct nf_conn *ct;
+	const struct nf_conn *ct;
 	enum ip_conntrack_info ctinfo;
 
 	ct = nf_ct_get(skb, &ctinfo);
@@ -58,7 +58,7 @@ checkentry(const char *tablename,
 	   void *matchinfo,
 	   unsigned int hook_mask)
 {
-	struct xt_connmark_info *cm = matchinfo;
+	const struct xt_connmark_info *cm = matchinfo;
 
 	if (cm->mark > 0xffffffff || cm->mask > 0xffffffff) {
 		printk(KERN_WARNING "connmark: only support 32bit mark\n");
@@ -88,7 +88,7 @@ struct compat_xt_connmark_info {
 
 static void compat_from_user(void *dst, void *src)
 {
-	struct compat_xt_connmark_info *cm = src;
+	const struct compat_xt_connmark_info *cm = src;
 	struct xt_connmark_info m = {
 		.mark	= cm->mark,
 		.mask	= cm->mask,
@@ -99,7 +99,7 @@ static void compat_from_user(void *dst, void *src)
 
 static int compat_to_user(void __user *dst, void *src)
 {
-	struct xt_connmark_info *m = src;
+	const struct xt_connmark_info *m = src;
 	struct compat_xt_connmark_info cm = {
 		.mark	= m->mark,
 		.mask	= m->mask,
diff --git a/net/netfilter/xt_conntrack.c b/net/netfilter/xt_conntrack.c
index 87364f5..9e3ec31 100644
--- a/net/netfilter/xt_conntrack.c
+++ b/net/netfilter/xt_conntrack.c
@@ -30,11 +30,11 @@ match(const struct sk_buff *skb,
       bool *hotdrop)
 {
 	const struct xt_conntrack_info *sinfo = matchinfo;
-	struct nf_conn *ct;
+	const struct nf_conn *ct;
 	enum ip_conntrack_info ctinfo;
 	unsigned int statebit;
 
-	ct = nf_ct_get((struct sk_buff *)skb, &ctinfo);
+	ct = nf_ct_get(skb, &ctinfo);
 
 #define FWINV(bool,invflg) ((bool) ^ !!(sinfo->invflags & invflg))
 
@@ -150,7 +150,7 @@ struct compat_xt_conntrack_info
 
 static void compat_from_user(void *dst, void *src)
 {
-	struct compat_xt_conntrack_info *cm = src;
+	const struct compat_xt_conntrack_info *cm = src;
 	struct xt_conntrack_info m = {
 		.statemask	= cm->statemask,
 		.statusmask	= cm->statusmask,
@@ -167,7 +167,7 @@ static void compat_from_user(void *dst, void *src)
 
 static int compat_to_user(void __user *dst, void *src)
 {
-	struct xt_conntrack_info *m = src;
+	const struct xt_conntrack_info *m = src;
 	struct compat_xt_conntrack_info cm = {
 		.statemask	= m->statemask,
 		.statusmask	= m->statusmask,
diff --git a/net/netfilter/xt_dccp.c b/net/netfilter/xt_dccp.c
index 2489590..1b77c5b 100644
--- a/net/netfilter/xt_dccp.c
+++ b/net/netfilter/xt_dccp.c
@@ -39,7 +39,7 @@ dccp_find_option(u_int8_t option,
 		 bool *hotdrop)
 {
 	/* tcp.doff is only 4 bits, ie. max 15 * 4 bytes */
-	unsigned char *op;
+	const unsigned char *op;
 	unsigned int optoff = __dccp_hdr_len(dh);
 	unsigned int optlen = dh->dccph_doff*4 - __dccp_hdr_len(dh);
 	unsigned int i;
diff --git a/net/netfilter/xt_hashlimit.c b/net/netfilter/xt_hashlimit.c
index a1b5996..deb5890 100644
--- a/net/netfilter/xt_hashlimit.c
+++ b/net/netfilter/xt_hashlimit.c
@@ -95,7 +95,7 @@ static HLIST_HEAD(hashlimit_htables);
 static struct kmem_cache *hashlimit_cachep __read_mostly;
 
 static inline bool dst_cmp(const struct dsthash_ent *ent,
-			   struct dsthash_dst *b)
+			   const struct dsthash_dst *b)
 {
 	return !memcmp(&ent->dst, b, sizeof(ent->dst));
 }
@@ -107,7 +107,8 @@ hash_dst(const struct xt_hashlimit_htable *ht, const struct dsthash_dst *dst)
 }
 
 static struct dsthash_ent *
-dsthash_find(const struct xt_hashlimit_htable *ht, struct dsthash_dst *dst)
+dsthash_find(const struct xt_hashlimit_htable *ht,
+	     const struct dsthash_dst *dst)
 {
 	struct dsthash_ent *ent;
 	struct hlist_node *pos;
@@ -123,7 +124,8 @@ dsthash_find(const struct xt_hashlimit_htable *ht, struct dsthash_dst *dst)
 
 /* allocate dsthash_ent, initialize dst, put in htable and lock it */
 static struct dsthash_ent *
-dsthash_alloc_init(struct xt_hashlimit_htable *ht, struct dsthash_dst *dst)
+dsthash_alloc_init(struct xt_hashlimit_htable *ht,
+		   const struct dsthash_dst *dst)
 {
 	struct dsthash_ent *ent;
 
@@ -228,19 +230,21 @@ static int htable_create(struct xt_hashlimit_info *minfo, int family)
 	return 0;
 }
 
-static bool select_all(struct xt_hashlimit_htable *ht, struct dsthash_ent *he)
+static bool select_all(const struct xt_hashlimit_htable *ht,
+		       const struct dsthash_ent *he)
 {
 	return 1;
 }
 
-static bool select_gc(struct xt_hashlimit_htable *ht, struct dsthash_ent *he)
+static bool select_gc(const struct xt_hashlimit_htable *ht,
+		      const struct dsthash_ent *he)
 {
 	return (jiffies >= he->expires);
 }
 
 static void htable_selective_cleanup(struct xt_hashlimit_htable *ht,
-				bool (*select)(struct xt_hashlimit_htable *ht,
-					      struct dsthash_ent *he))
+			bool (*select)(const struct xt_hashlimit_htable *ht,
+				      const struct dsthash_ent *he))
 {
 	unsigned int i;
 
@@ -283,7 +287,8 @@ static void htable_destroy(struct xt_hashlimit_htable *hinfo)
 	vfree(hinfo);
 }
 
-static struct xt_hashlimit_htable *htable_find_get(char *name, int family)
+static struct xt_hashlimit_htable *htable_find_get(const char *name,
+						   int family)
 {
 	struct xt_hashlimit_htable *hinfo;
 	struct hlist_node *pos;
@@ -368,7 +373,8 @@ static inline void rateinfo_recalc(struct dsthash_ent *dh, unsigned long now)
 }
 
 static int
-hashlimit_init_dst(struct xt_hashlimit_htable *hinfo, struct dsthash_dst *dst,
+hashlimit_init_dst(const struct xt_hashlimit_htable *hinfo,
+		   struct dsthash_dst *dst,
 		   const struct sk_buff *skb, unsigned int protoff)
 {
 	__be16 _ports[2], *ports;
@@ -443,8 +449,8 @@ hashlimit_match(const struct sk_buff *skb,
 		unsigned int protoff,
 		bool *hotdrop)
 {
-	struct xt_hashlimit_info *r =
-		((struct xt_hashlimit_info *)matchinfo)->u.master;
+	const struct xt_hashlimit_info *r =
+		((const struct xt_hashlimit_info *)matchinfo)->u.master;
 	struct xt_hashlimit_htable *hinfo = r->hinfo;
 	unsigned long now = jiffies;
 	struct dsthash_ent *dh;
@@ -543,7 +549,7 @@ hashlimit_checkentry(const char *tablename,
 static void
 hashlimit_destroy(const struct xt_match *match, void *matchinfo)
 {
-	struct xt_hashlimit_info *r = matchinfo;
+	const struct xt_hashlimit_info *r = matchinfo;
 
 	htable_put(r->hinfo);
 }
diff --git a/net/netfilter/xt_helper.c b/net/netfilter/xt_helper.c
index a2688b8..047d004 100644
--- a/net/netfilter/xt_helper.c
+++ b/net/netfilter/xt_helper.c
@@ -39,12 +39,12 @@ match(const struct sk_buff *skb,
       bool *hotdrop)
 {
 	const struct xt_helper_info *info = matchinfo;
-	struct nf_conn *ct;
-	struct nf_conn_help *master_help;
+	const struct nf_conn *ct;
+	const struct nf_conn_help *master_help;
 	enum ip_conntrack_info ctinfo;
 	bool ret = info->invert;
 
-	ct = nf_ct_get((struct sk_buff *)skb, &ctinfo);
+	ct = nf_ct_get(skb, &ctinfo);
 	if (!ct) {
 		DEBUGP("xt_helper: Eek! invalid conntrack?\n");
 		return ret;
diff --git a/net/netfilter/xt_limit.c b/net/netfilter/xt_limit.c
index 2717aa6..b042419 100644
--- a/net/netfilter/xt_limit.c
+++ b/net/netfilter/xt_limit.c
@@ -67,7 +67,8 @@ ipt_limit_match(const struct sk_buff *skb,
 		unsigned int protoff,
 		bool *hotdrop)
 {
-	struct xt_rateinfo *r = ((struct xt_rateinfo *)matchinfo)->master;
+	struct xt_rateinfo *r =
+		((const struct xt_rateinfo *)matchinfo)->master;
 	unsigned long now = jiffies;
 
 	spin_lock_bh(&limit_lock);
@@ -144,7 +145,7 @@ struct compat_xt_rateinfo {
  * master pointer, which does not need to be preserved. */
 static void compat_from_user(void *dst, void *src)
 {
-	struct compat_xt_rateinfo *cm = src;
+	const struct compat_xt_rateinfo *cm = src;
 	struct xt_rateinfo m = {
 		.avg		= cm->avg,
 		.burst		= cm->burst,
@@ -158,7 +159,7 @@ static void compat_from_user(void *dst, void *src)
 
 static int compat_to_user(void __user *dst, void *src)
 {
-	struct xt_rateinfo *m = src;
+	const struct xt_rateinfo *m = src;
 	struct compat_xt_rateinfo cm = {
 		.avg		= m->avg,
 		.burst		= m->burst,
diff --git a/net/netfilter/xt_mark.c b/net/netfilter/xt_mark.c
index 83ed806..b8ab794 100644
--- a/net/netfilter/xt_mark.c
+++ b/net/netfilter/xt_mark.c
@@ -60,7 +60,7 @@ struct compat_xt_mark_info {
 
 static void compat_from_user(void *dst, void *src)
 {
-	struct compat_xt_mark_info *cm = src;
+	const struct compat_xt_mark_info *cm = src;
 	struct xt_mark_info m = {
 		.mark	= cm->mark,
 		.mask	= cm->mask,
@@ -71,7 +71,7 @@ static void compat_from_user(void *dst, void *src)
 
 static int compat_to_user(void __user *dst, void *src)
 {
-	struct xt_mark_info *m = src;
+	const struct xt_mark_info *m = src;
 	struct compat_xt_mark_info cm = {
 		.mark	= m->mark,
 		.mask	= m->mask,
diff --git a/net/netfilter/xt_physdev.c b/net/netfilter/xt_physdev.c
index 34f0d3e..467b2dc 100644
--- a/net/netfilter/xt_physdev.c
+++ b/net/netfilter/xt_physdev.c
@@ -36,7 +36,7 @@ match(const struct sk_buff *skb,
 	const struct xt_physdev_info *info = matchinfo;
 	bool ret;
 	const char *indev, *outdev;
-	struct nf_bridge_info *nf_bridge;
+	const struct nf_bridge_info *nf_bridge;
 
 	/* Not a bridged IP packet or no info available yet:
 	 * LOCAL_OUT/mangle and LOCAL_OUT/nat don't know if
diff --git a/net/netfilter/xt_policy.c b/net/netfilter/xt_policy.c
index 1534de5..5ab6d71 100644
--- a/net/netfilter/xt_policy.c
+++ b/net/netfilter/xt_policy.c
@@ -34,7 +34,7 @@ xt_addr_cmp(const union xt_policy_addr *a1, const union xt_policy_addr *m,
 }
 
 static inline bool
-match_xfrm_state(struct xfrm_state *x, const struct xt_policy_elem *e,
+match_xfrm_state(const struct xfrm_state *x, const struct xt_policy_elem *e,
 		 unsigned short family)
 {
 #define MATCH_ADDR(x,y,z)	(!e->match.x ||			       \
@@ -55,7 +55,7 @@ match_policy_in(const struct sk_buff *skb, const struct xt_policy_info *info,
 		unsigned short family)
 {
 	const struct xt_policy_elem *e;
-	struct sec_path *sp = skb->sp;
+	const struct sec_path *sp = skb->sp;
 	int strict = info->flags & XT_POLICY_MATCH_STRICT;
 	int i, pos;
 
@@ -85,7 +85,7 @@ match_policy_out(const struct sk_buff *skb, const struct xt_policy_info *info,
 		 unsigned short family)
 {
 	const struct xt_policy_elem *e;
-	struct dst_entry *dst = skb->dst;
+	const struct dst_entry *dst = skb->dst;
 	int strict = info->flags & XT_POLICY_MATCH_STRICT;
 	int i, pos;
 
diff --git a/net/netfilter/xt_quota.c b/net/netfilter/xt_quota.c
index e13d62a..feb130d 100644
--- a/net/netfilter/xt_quota.c
+++ b/net/netfilter/xt_quota.c
@@ -22,7 +22,8 @@ match(const struct sk_buff *skb,
       const struct xt_match *match, const void *matchinfo,
       int offset, unsigned int protoff, bool *hotdrop)
 {
-	struct xt_quota_info *q = ((struct xt_quota_info *)matchinfo)->master;
+	struct xt_quota_info *q =
+		((const struct xt_quota_info *)matchinfo)->master;
 	bool ret = q->flags & XT_QUOTA_INVERT;
 
 	spin_lock_bh(&quota_lock);
@@ -43,7 +44,7 @@ checkentry(const char *tablename, const void *entry,
 	   const struct xt_match *match, void *matchinfo,
 	   unsigned int hook_mask)
 {
-	struct xt_quota_info *q = (struct xt_quota_info *)matchinfo;
+	struct xt_quota_info *q = matchinfo;
 
 	if (q->flags & ~XT_QUOTA_MASK)
 		return false;
diff --git a/net/netfilter/xt_realm.c b/net/netfilter/xt_realm.c
index ad82c13..44b807d 100644
--- a/net/netfilter/xt_realm.c
+++ b/net/netfilter/xt_realm.c
@@ -32,7 +32,7 @@ match(const struct sk_buff *skb,
       bool *hotdrop)
 {
 	const struct xt_realm_info *info = matchinfo;
-	struct dst_entry *dst = skb->dst;
+	const struct dst_entry *dst = skb->dst;
 
 	return (info->id == (dst->tclassid & info->mask)) ^ info->invert;
 }
diff --git a/net/netfilter/xt_statistic.c b/net/netfilter/xt_statistic.c
index 0af4289..3da4978 100644
--- a/net/netfilter/xt_statistic.c
+++ b/net/netfilter/xt_statistic.c
@@ -57,7 +57,7 @@ checkentry(const char *tablename, const void *entry,
 	   const struct xt_match *match, void *matchinfo,
 	   unsigned int hook_mask)
 {
-	struct xt_statistic_info *info = (struct xt_statistic_info *)matchinfo;
+	struct xt_statistic_info *info = matchinfo;
 
 	if (info->mode > XT_STATISTIC_MODE_MAX ||
 	    info->flags & ~XT_STATISTIC_MASK)
