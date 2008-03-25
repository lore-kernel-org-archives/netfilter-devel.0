From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: commit 720350a38b1dbd43c907d5d81decd6edd6725d81
Date: Tue, 25 Mar 2008 19:06:04 +0100
Message-ID: <1206468391-368-2-git-send-email-jengelh@computergmbh.de>
References: <alpine.LNX.1.10.0803251903230.31276@fbirervta.pbzchgretzou.qr>
 <1206468391-368-1-git-send-email-jengelh@computergmbh.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:52532 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757617AbYCYSGd (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 25 Mar 2008 14:06:33 -0400
In-Reply-To: <1206468391-368-1-git-send-email-jengelh@computergmbh.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

    [NETFILTER]: annotate xtables targets with const and remove casts
    
    Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>
---
 net/ipv4/netfilter/ipt_CLUSTERIP.c   |   12 ++++++------
 net/ipv4/netfilter/ipt_ECN.c         |    2 +-
 net/ipv4/netfilter/ipt_LOG.c         |    3 ++-
 net/ipv4/netfilter/ipt_REJECT.c      |    6 ++++--
 net/ipv4/netfilter/ipt_recent.c      |    6 +++---
 net/ipv4/netfilter/nf_nat_rule.c     |    4 ++--
 net/ipv6/netfilter/ip6t_REJECT.c     |    3 ++-
 net/ipv6/netfilter/ip6t_ipv6header.c |    3 ++-
 net/ipv6/netfilter/ip6t_rt.c         |    3 ++-
 net/netfilter/xt_CONNSECMARK.c       |    2 +-
 net/netfilter/xt_RATEEST.c           |    2 +-
 net/netfilter/xt_connlimit.c         |    6 +++---
 net/netfilter/xt_dccp.c              |    3 ++-
 net/netfilter/xt_esp.c               |    3 ++-
 net/netfilter/xt_multiport.c         |    6 ++++--
 net/netfilter/xt_policy.c            |    2 +-
 net/netfilter/xt_rateest.c           |    4 ++--
 net/netfilter/xt_sctp.c              |    6 ++++--
 net/netfilter/xt_tcpmss.c            |    6 ++++--
 net/netfilter/xt_tcpudp.c            |    9 ++++++---
 net/netfilter/xt_time.c              |    2 +-
 21 files changed, 55 insertions(+), 38 deletions(-)

diff --git a/net/ipv4/netfilter/ipt_CLUSTERIP.c b/net/ipv4/netfilter/ipt_CLUSTERIP.c
index 1b10f36..421b537 100644
--- a/net/ipv4/netfilter/ipt_CLUSTERIP.c
+++ b/net/ipv4/netfilter/ipt_CLUSTERIP.c
@@ -142,7 +142,7 @@ clusterip_config_init_nodelist(struct clusterip_config *c,
 }
 
 static struct clusterip_config *
-clusterip_config_init(struct ipt_clusterip_tgt_info *i, __be32 ip,
+clusterip_config_init(const struct ipt_clusterip_tgt_info *i, __be32 ip,
 			struct net_device *dev)
 {
 	struct clusterip_config *c;
@@ -417,7 +417,7 @@ clusterip_tg_check(const char *tablename, const void *e_void,
 /* drop reference count of cluster config when rule is deleted */
 static void clusterip_tg_destroy(const struct xt_target *target, void *targinfo)
 {
-	struct ipt_clusterip_tgt_info *cipinfo = targinfo;
+	const struct ipt_clusterip_tgt_info *cipinfo = targinfo;
 
 	/* if no more entries are referencing the config, remove it
 	 * from the list and destroy the proc entry */
@@ -566,7 +566,7 @@ struct clusterip_seq_position {
 
 static void *clusterip_seq_start(struct seq_file *s, loff_t *pos)
 {
-	struct proc_dir_entry *pde = s->private;
+	const struct proc_dir_entry *pde = s->private;
 	struct clusterip_config *c = pde->data;
 	unsigned int weight;
 	u_int32_t local_nodes;
@@ -593,7 +593,7 @@ static void *clusterip_seq_start(struct seq_file *s, loff_t *pos)
 
 static void *clusterip_seq_next(struct seq_file *s, void *v, loff_t *pos)
 {
-	struct clusterip_seq_position *idx = (struct clusterip_seq_position *)v;
+	struct clusterip_seq_position *idx = v;
 
 	*pos = ++idx->pos;
 	if (*pos >= idx->weight) {
@@ -612,7 +612,7 @@ static void clusterip_seq_stop(struct seq_file *s, void *v)
 
 static int clusterip_seq_show(struct seq_file *s, void *v)
 {
-	struct clusterip_seq_position *idx = (struct clusterip_seq_position *)v;
+	struct clusterip_seq_position *idx = v;
 
 	if (idx->pos != 0)
 		seq_putc(s, ',');
@@ -668,7 +668,7 @@ static ssize_t clusterip_proc_write(struct file *file, const char __user *input,
 {
 #define PROC_WRITELEN	10
 	char buffer[PROC_WRITELEN+1];
-	struct proc_dir_entry *pde = PDE(file->f_path.dentry->d_inode);
+	const struct proc_dir_entry *pde = PDE(file->f_path.dentry->d_inode);
 	struct clusterip_config *c = pde->data;
 	unsigned long nodenum;
 
diff --git a/net/ipv4/netfilter/ipt_ECN.c b/net/ipv4/netfilter/ipt_ECN.c
index 21395bc..d60139c 100644
--- a/net/ipv4/netfilter/ipt_ECN.c
+++ b/net/ipv4/netfilter/ipt_ECN.c
@@ -100,7 +100,7 @@ ecn_tg_check(const char *tablename, const void *e_void,
              const struct xt_target *target, void *targinfo,
              unsigned int hook_mask)
 {
-	const struct ipt_ECN_info *einfo = (struct ipt_ECN_info *)targinfo;
+	const struct ipt_ECN_info *einfo = targinfo;
 	const struct ipt_entry *e = e_void;
 
 	if (einfo->operation & IPT_ECN_OP_MASK) {
diff --git a/net/ipv4/netfilter/ipt_LOG.c b/net/ipv4/netfilter/ipt_LOG.c
index b38d785..77300e9 100644
--- a/net/ipv4/netfilter/ipt_LOG.c
+++ b/net/ipv4/netfilter/ipt_LOG.c
@@ -76,7 +76,8 @@ static void dump_packet(const struct nf_loginfo *info,
 
 	if ((logflags & IPT_LOG_IPOPT)
 	    && ih->ihl * 4 > sizeof(struct iphdr)) {
-		unsigned char _opt[4 * 15 - sizeof(struct iphdr)], *op;
+		const unsigned char *op;
+		unsigned char _opt[4 * 15 - sizeof(struct iphdr)];
 		unsigned int i, optsize;
 
 		optsize = ih->ihl * 4 - sizeof(struct iphdr);
diff --git a/net/ipv4/netfilter/ipt_REJECT.c b/net/ipv4/netfilter/ipt_REJECT.c
index 22606e2..2639872 100644
--- a/net/ipv4/netfilter/ipt_REJECT.c
+++ b/net/ipv4/netfilter/ipt_REJECT.c
@@ -35,8 +35,10 @@ MODULE_DESCRIPTION("Xtables: packet \"rejection\" target for IPv4");
 static void send_reset(struct sk_buff *oldskb, int hook)
 {
 	struct sk_buff *nskb;
-	struct iphdr *oiph, *niph;
-	struct tcphdr _otcph, *oth, *tcph;
+	const struct iphdr *oiph;
+	struct iphdr *niph;
+	const struct tcphdr *oth;
+	struct tcphdr _otcph, *tcph;
 	unsigned int addr_type;
 
 	/* IP header checks: fragment. */
diff --git a/net/ipv4/netfilter/ipt_recent.c b/net/ipv4/netfilter/ipt_recent.c
index 8e8f042..3e62066 100644
--- a/net/ipv4/netfilter/ipt_recent.c
+++ b/net/ipv4/netfilter/ipt_recent.c
@@ -341,7 +341,7 @@ static void *recent_seq_start(struct seq_file *seq, loff_t *pos)
 static void *recent_seq_next(struct seq_file *seq, void *v, loff_t *pos)
 {
 	struct recent_iter_state *st = seq->private;
-	struct recent_table *t = st->table;
+	const struct recent_table *t = st->table;
 	struct recent_entry *e = v;
 	struct list_head *head = e->list.next;
 
@@ -362,7 +362,7 @@ static void recent_seq_stop(struct seq_file *s, void *v)
 
 static int recent_seq_show(struct seq_file *seq, void *v)
 {
-	struct recent_entry *e = v;
+	const struct recent_entry *e = v;
 	unsigned int i;
 
 	i = (e->index - 1) % ip_pkt_list_tot;
@@ -397,7 +397,7 @@ static int recent_seq_open(struct inode *inode, struct file *file)
 static ssize_t recent_proc_write(struct file *file, const char __user *input,
 				 size_t size, loff_t *loff)
 {
-	struct proc_dir_entry *pde = PDE(file->f_path.dentry->d_inode);
+	const struct proc_dir_entry *pde = PDE(file->f_path.dentry->d_inode);
 	struct recent_table *t = pde->data;
 	struct recent_entry *e;
 	char buf[sizeof("+255.255.255.255")], *c = buf;
diff --git a/net/ipv4/netfilter/nf_nat_rule.c b/net/ipv4/netfilter/nf_nat_rule.c
index f8fda57..600f6d7 100644
--- a/net/ipv4/netfilter/nf_nat_rule.c
+++ b/net/ipv4/netfilter/nf_nat_rule.c
@@ -143,7 +143,7 @@ static bool ipt_snat_checkentry(const char *tablename,
 				void *targinfo,
 				unsigned int hook_mask)
 {
-	struct nf_nat_multi_range_compat *mr = targinfo;
+	const struct nf_nat_multi_range_compat *mr = targinfo;
 
 	/* Must be a valid range */
 	if (mr->rangesize != 1) {
@@ -159,7 +159,7 @@ static bool ipt_dnat_checkentry(const char *tablename,
 				void *targinfo,
 				unsigned int hook_mask)
 {
-	struct nf_nat_multi_range_compat *mr = targinfo;
+	const struct nf_nat_multi_range_compat *mr = targinfo;
 
 	/* Must be a valid range */
 	if (mr->rangesize != 1) {
diff --git a/net/ipv6/netfilter/ip6t_REJECT.c b/net/ipv6/netfilter/ip6t_REJECT.c
index baf8290..44c8d65 100644
--- a/net/ipv6/netfilter/ip6t_REJECT.c
+++ b/net/ipv6/netfilter/ip6t_REJECT.c
@@ -41,7 +41,8 @@ static void send_reset(struct sk_buff *oldskb)
 	struct tcphdr otcph, *tcph;
 	unsigned int otcplen, hh_len;
 	int tcphoff, needs_ack;
-	struct ipv6hdr *oip6h = ipv6_hdr(oldskb), *ip6h;
+	const struct ipv6hdr *oip6h = ipv6_hdr(oldskb);
+	struct ipv6hdr *ip6h;
 	struct dst_entry *dst = NULL;
 	u8 proto;
 	struct flowi fl;
diff --git a/net/ipv6/netfilter/ip6t_ipv6header.c b/net/ipv6/netfilter/ip6t_ipv6header.c
index 3a94017..317a896 100644
--- a/net/ipv6/netfilter/ip6t_ipv6header.c
+++ b/net/ipv6/netfilter/ip6t_ipv6header.c
@@ -49,7 +49,8 @@ ipv6header_mt6(const struct sk_buff *skb, const struct net_device *in,
 	temp = 0;
 
 	while (ip6t_ext_hdr(nexthdr)) {
-		struct ipv6_opt_hdr _hdr, *hp;
+		const struct ipv6_opt_hdr *hp;
+		struct ipv6_opt_hdr _hdr;
 		int hdrlen;
 
 		/* Is there enough space for the next ext header? */
diff --git a/net/ipv6/netfilter/ip6t_rt.c b/net/ipv6/netfilter/ip6t_rt.c
index 12a9efe..81aaf7a 100644
--- a/net/ipv6/netfilter/ip6t_rt.c
+++ b/net/ipv6/netfilter/ip6t_rt.c
@@ -110,7 +110,8 @@ rt_mt6(const struct sk_buff *skb, const struct net_device *in,
 		!!(rtinfo->invflags & IP6T_RT_INV_TYP)));
 
 	if (ret && (rtinfo->flags & IP6T_RT_RES)) {
-		u_int32_t *rp, _reserved;
+		const u_int32_t *rp;
+		u_int32_t _reserved;
 		rp = skb_header_pointer(skb,
 					ptr + offsetof(struct rt0_hdr,
 						       reserved),
diff --git a/net/netfilter/xt_CONNSECMARK.c b/net/netfilter/xt_CONNSECMARK.c
index 1faa913..211189e 100644
--- a/net/netfilter/xt_CONNSECMARK.c
+++ b/net/netfilter/xt_CONNSECMARK.c
@@ -55,7 +55,7 @@ static void secmark_save(const struct sk_buff *skb)
 static void secmark_restore(struct sk_buff *skb)
 {
 	if (!skb->secmark) {
-		struct nf_conn *ct;
+		const struct nf_conn *ct;
 		enum ip_conntrack_info ctinfo;
 
 		ct = nf_ct_get(skb, &ctinfo);
diff --git a/net/netfilter/xt_RATEEST.c b/net/netfilter/xt_RATEEST.c
index 24c73ba..64d6ad3 100644
--- a/net/netfilter/xt_RATEEST.c
+++ b/net/netfilter/xt_RATEEST.c
@@ -96,7 +96,7 @@ xt_rateest_tg_checkentry(const char *tablename,
 			 void *targinfo,
 			 unsigned int hook_mask)
 {
-	struct xt_rateest_target_info *info = (void *)targinfo;
+	struct xt_rateest_target_info *info = targinfo;
 	struct xt_rateest *est;
 	struct {
 		struct nlattr		opt;
diff --git a/net/netfilter/xt_connlimit.c b/net/netfilter/xt_connlimit.c
index 3b01119..0ca9fe9 100644
--- a/net/netfilter/xt_connlimit.c
+++ b/net/netfilter/xt_connlimit.c
@@ -106,10 +106,10 @@ static int count_them(struct xt_connlimit_data *data,
 		      const union nf_inet_addr *mask,
 		      const struct xt_match *match)
 {
-	struct nf_conntrack_tuple_hash *found;
+	const struct nf_conntrack_tuple_hash *found;
 	struct xt_connlimit_conn *conn;
 	struct xt_connlimit_conn *tmp;
-	struct nf_conn *found_ct;
+	const struct nf_conn *found_ct;
 	struct list_head *hash;
 	bool addit = true;
 	int matches = 0;
@@ -256,7 +256,7 @@ connlimit_mt_check(const char *tablename, const void *ip,
 static void
 connlimit_mt_destroy(const struct xt_match *match, void *matchinfo)
 {
-	struct xt_connlimit_info *info = matchinfo;
+	const struct xt_connlimit_info *info = matchinfo;
 	struct xt_connlimit_conn *conn;
 	struct xt_connlimit_conn *tmp;
 	struct list_head *hash = info->data->iphash;
diff --git a/net/netfilter/xt_dccp.c b/net/netfilter/xt_dccp.c
index 667f45e..8b65221 100644
--- a/net/netfilter/xt_dccp.c
+++ b/net/netfilter/xt_dccp.c
@@ -98,7 +98,8 @@ dccp_mt(const struct sk_buff *skb, const struct net_device *in,
         const void *matchinfo, int offset, unsigned int protoff, bool *hotdrop)
 {
 	const struct xt_dccp_info *info = matchinfo;
-	struct dccp_hdr _dh, *dh;
+	const struct dccp_hdr *dh;
+	struct dccp_hdr _dh;
 
 	if (offset)
 		return false;
diff --git a/net/netfilter/xt_esp.c b/net/netfilter/xt_esp.c
index 71c7c37..a133eb9 100644
--- a/net/netfilter/xt_esp.c
+++ b/net/netfilter/xt_esp.c
@@ -47,7 +47,8 @@ esp_mt(const struct sk_buff *skb, const struct net_device *in,
        const struct net_device *out, const struct xt_match *match,
        const void *matchinfo, int offset, unsigned int protoff, bool *hotdrop)
 {
-	struct ip_esp_hdr _esp, *eh;
+	const struct ip_esp_hdr *eh;
+	struct ip_esp_hdr _esp;
 	const struct xt_esp *espinfo = matchinfo;
 
 	/* Must not be a fragment. */
diff --git a/net/netfilter/xt_multiport.c b/net/netfilter/xt_multiport.c
index 31daa81..fd88c48 100644
--- a/net/netfilter/xt_multiport.c
+++ b/net/netfilter/xt_multiport.c
@@ -100,7 +100,8 @@ multiport_mt_v0(const struct sk_buff *skb, const struct net_device *in,
                 const void *matchinfo, int offset, unsigned int protoff,
                 bool *hotdrop)
 {
-	__be16 _ports[2], *pptr;
+	const __be16 *pptr;
+	__be16 _ports[2];
 	const struct xt_multiport *multiinfo = matchinfo;
 
 	if (offset)
@@ -126,7 +127,8 @@ multiport_mt(const struct sk_buff *skb, const struct net_device *in,
              const void *matchinfo, int offset, unsigned int protoff,
              bool *hotdrop)
 {
-	__be16 _ports[2], *pptr;
+	const __be16 *pptr;
+	__be16 _ports[2];
 	const struct xt_multiport_v1 *multiinfo = matchinfo;
 
 	if (offset)
diff --git a/net/netfilter/xt_policy.c b/net/netfilter/xt_policy.c
index 9e918ad..d351582 100644
--- a/net/netfilter/xt_policy.c
+++ b/net/netfilter/xt_policy.c
@@ -136,7 +136,7 @@ policy_mt_check(const char *tablename, const void *ip_void,
                 const struct xt_match *match, void *matchinfo,
                 unsigned int hook_mask)
 {
-	struct xt_policy_info *info = matchinfo;
+	const struct xt_policy_info *info = matchinfo;
 
 	if (!(info->flags & (XT_POLICY_MATCH_IN|XT_POLICY_MATCH_OUT))) {
 		printk(KERN_ERR "xt_policy: neither incoming nor "
diff --git a/net/netfilter/xt_rateest.c b/net/netfilter/xt_rateest.c
index fdb86a5..ebd84f1 100644
--- a/net/netfilter/xt_rateest.c
+++ b/net/netfilter/xt_rateest.c
@@ -86,7 +86,7 @@ static bool xt_rateest_mt_checkentry(const char *tablename,
 				     void *matchinfo,
 				     unsigned int hook_mask)
 {
-	struct xt_rateest_match_info *info = (void *)matchinfo;
+	struct xt_rateest_match_info *info = matchinfo;
 	struct xt_rateest *est1, *est2;
 
 	if (hweight32(info->flags & (XT_RATEEST_MATCH_ABS |
@@ -130,7 +130,7 @@ err1:
 static void xt_rateest_mt_destroy(const struct xt_match *match,
 				  void *matchinfo)
 {
-	struct xt_rateest_match_info *info = (void *)matchinfo;
+	struct xt_rateest_match_info *info = matchinfo;
 
 	xt_rateest_put(info->est1);
 	if (info->est2)
diff --git a/net/netfilter/xt_sctp.c b/net/netfilter/xt_sctp.c
index b718ec6..e6e4681 100644
--- a/net/netfilter/xt_sctp.c
+++ b/net/netfilter/xt_sctp.c
@@ -46,7 +46,8 @@ match_packet(const struct sk_buff *skb,
 	     bool *hotdrop)
 {
 	u_int32_t chunkmapcopy[256 / sizeof (u_int32_t)];
-	sctp_chunkhdr_t _sch, *sch;
+	const sctp_chunkhdr_t *sch;
+	sctp_chunkhdr_t _sch;
 	int chunk_match_type = info->chunk_match_type;
 	const struct xt_sctp_flag_info *flag_info = info->flag_info;
 	int flag_count = info->flag_count;
@@ -121,7 +122,8 @@ sctp_mt(const struct sk_buff *skb, const struct net_device *in,
         const void *matchinfo, int offset, unsigned int protoff, bool *hotdrop)
 {
 	const struct xt_sctp_info *info = matchinfo;
-	sctp_sctphdr_t _sh, *sh;
+	const sctp_sctphdr_t *sh;
+	sctp_sctphdr_t _sh;
 
 	if (offset) {
 		duprintf("Dropping non-first fragment.. FIXME\n");
diff --git a/net/netfilter/xt_tcpmss.c b/net/netfilter/xt_tcpmss.c
index d7a5b27..6771bf0 100644
--- a/net/netfilter/xt_tcpmss.c
+++ b/net/netfilter/xt_tcpmss.c
@@ -31,9 +31,11 @@ tcpmss_mt(const struct sk_buff *skb, const struct net_device *in,
           bool *hotdrop)
 {
 	const struct xt_tcpmss_match_info *info = matchinfo;
-	struct tcphdr _tcph, *th;
+	const struct tcphdr *th;
+	struct tcphdr _tcph;
 	/* tcp.doff is only 4 bits, ie. max 15 * 4 bytes */
-	u8 _opt[15 * 4 - sizeof(_tcph)], *op;
+	const u_int8_t *op;
+	u8 _opt[15 * 4 - sizeof(_tcph)];
 	unsigned int i, optlen;
 
 	/* If we don't have the whole header, drop packet. */
diff --git a/net/netfilter/xt_tcpudp.c b/net/netfilter/xt_tcpudp.c
index 4fa3b66..951b06b 100644
--- a/net/netfilter/xt_tcpudp.c
+++ b/net/netfilter/xt_tcpudp.c
@@ -42,7 +42,8 @@ tcp_find_option(u_int8_t option,
 		bool *hotdrop)
 {
 	/* tcp.doff is only 4 bits, ie. max 15 * 4 bytes */
-	u_int8_t _opt[60 - sizeof(struct tcphdr)], *op;
+	const u_int8_t *op;
+	u_int8_t _opt[60 - sizeof(struct tcphdr)];
 	unsigned int i;
 
 	duprintf("tcp_match: finding option\n");
@@ -72,7 +73,8 @@ tcp_mt(const struct sk_buff *skb, const struct net_device *in,
        const struct net_device *out, const struct xt_match *match,
        const void *matchinfo, int offset, unsigned int protoff, bool *hotdrop)
 {
-	struct tcphdr _tcph, *th;
+	const struct tcphdr *th;
+	struct tcphdr _tcph;
 	const struct xt_tcp *tcpinfo = matchinfo;
 
 	if (offset) {
@@ -144,7 +146,8 @@ udp_mt(const struct sk_buff *skb, const struct net_device *in,
        const struct net_device *out, const struct xt_match *match,
        const void *matchinfo, int offset, unsigned int protoff, bool *hotdrop)
 {
-	struct udphdr _udph, *uh;
+	const struct udphdr *uh;
+	struct udphdr _udph;
 	const struct xt_udp *udpinfo = matchinfo;
 
 	/* Must not be a fragment. */
diff --git a/net/netfilter/xt_time.c b/net/netfilter/xt_time.c
index 9fa2e08..ed76baa 100644
--- a/net/netfilter/xt_time.c
+++ b/net/netfilter/xt_time.c
@@ -223,7 +223,7 @@ time_mt_check(const char *tablename, const void *ip,
               const struct xt_match *match, void *matchinfo,
               unsigned int hook_mask)
 {
-	struct xt_time_info *info = matchinfo;
+	const struct xt_time_info *info = matchinfo;
 
 	if (info->daytime_start > XT_TIME_MAX_DAYTIME ||
 	    info->daytime_stop > XT_TIME_MAX_DAYTIME) {
