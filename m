From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 11/12]: Add address family specific checksum helpers
Date: Thu,  6 Apr 2006 12:05:08 +0200 (MEST)
Message-ID: <20060406100508.17409.68682.sendpatchset@localhost.localdomain>
References: <20060406100452.17409.37120.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: davem@davemloft.net
In-Reply-To: <20060406100452.17409.37120.sendpatchset@localhost.localdomain>
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

[NETFILTER]: Add address family specific checksum helpers

Add checksum operation which takes care of verifying the checksum and
dealing with HW checksum errors and avoids multiple checksum operations
by setting ip_summed to CHECKSUM_UNNECESSARY after successful verification.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit b204de98f3e9d2f9d47141c6a1036a2a27729329
tree baf5ff3876cccf6b875f2c5d794d6fe9becd17b3
parent 6a870bcf3e2ee0394ee23cb1ca32de2195edf86d
author Patrick McHardy <kaber@trash.net> Thu, 06 Apr 2006 11:43:58 +0200
committer Patrick McHardy <kaber@trash.net> Thu, 06 Apr 2006 11:43:58 +0200

 include/linux/netfilter.h      |   17 +++++++++++++++++
 include/linux/netfilter_ipv4.h |    2 ++
 include/linux/netfilter_ipv6.h |    3 +++
 net/ipv4/netfilter.c           |   33 +++++++++++++++++++++++++++++++++
 net/ipv6/netfilter.c           |   34 ++++++++++++++++++++++++++++++++++
 5 files changed, 89 insertions(+), 0 deletions(-)

diff --git a/include/linux/netfilter.h b/include/linux/netfilter.h
index 6ee168c..b31a9bc 100644
--- a/include/linux/netfilter.h
+++ b/include/linux/netfilter.h
@@ -285,6 +285,8 @@ extern int skb_make_writable(struct sk_b
 
 struct nf_afinfo {
 	unsigned short	family;
+	unsigned int	(*checksum)(struct sk_buff *skb, unsigned int hook,
+				    unsigned int dataoff, u_int8_t protocol);
 	void		(*saveroute)(const struct sk_buff *skb,
 				     struct nf_info *info);
 	int		(*reroute)(struct sk_buff **skb,
@@ -298,6 +300,21 @@ static inline struct nf_afinfo *nf_get_a
 	return rcu_dereference(nf_afinfo[family]);
 }
 
+static inline unsigned int
+nf_checksum(struct sk_buff *skb, unsigned int hook, unsigned int dataoff,
+	    u_int8_t protocol, unsigned short family)
+{
+	struct nf_afinfo *afinfo;
+	unsigned int csum = 0;
+
+	rcu_read_lock();
+	afinfo = nf_get_afinfo(family);
+	if (afinfo)
+		csum = afinfo->checksum(skb, hook, dataoff, protocol);
+	rcu_read_unlock();
+	return csum;
+}
+
 extern int nf_register_afinfo(struct nf_afinfo *afinfo);
 extern void nf_unregister_afinfo(struct nf_afinfo *afinfo);
 
diff --git a/include/linux/netfilter_ipv4.h b/include/linux/netfilter_ipv4.h
index 43c09d7..85301c5 100644
--- a/include/linux/netfilter_ipv4.h
+++ b/include/linux/netfilter_ipv4.h
@@ -80,6 +80,8 @@ enum nf_ip_hook_priorities {
 #ifdef __KERNEL__
 extern int ip_route_me_harder(struct sk_buff **pskb);
 extern int ip_xfrm_me_harder(struct sk_buff **pskb);
+extern unsigned int nf_ip_checksum(struct sk_buff *skb, unsigned int hook,
+				   unsigned int dataoff, u_int8_t protocol);
 #endif /*__KERNEL__*/
 
 #endif /*__LINUX_IP_NETFILTER_H*/
diff --git a/include/linux/netfilter_ipv6.h b/include/linux/netfilter_ipv6.h
index 14f2bd0..52a7b9e 100644
--- a/include/linux/netfilter_ipv6.h
+++ b/include/linux/netfilter_ipv6.h
@@ -73,6 +73,9 @@ enum nf_ip6_hook_priorities {
 };
 
 #ifdef CONFIG_NETFILTER
+extern unsigned int nf_ip6_checksum(struct sk_buff *skb, unsigned int hook,
+				    unsigned int dataoff, u_int8_t protocol);
+
 extern int ipv6_netfilter_init(void);
 extern void ipv6_netfilter_fini(void);
 #else /* CONFIG_NETFILTER */
diff --git a/net/ipv4/netfilter.c b/net/ipv4/netfilter.c
index b25339c..6a9e34b 100644
--- a/net/ipv4/netfilter.c
+++ b/net/ipv4/netfilter.c
@@ -161,8 +161,41 @@ static int nf_ip_reroute(struct sk_buff 
 	return 0;
 }
 
+unsigned int nf_ip_checksum(struct sk_buff *skb, unsigned int hook,
+			    unsigned int dataoff, u_int8_t protocol)
+{
+	struct iphdr *iph = skb->nh.iph;
+	unsigned int csum = 0;
+
+	switch (skb->ip_summed) {
+	case CHECKSUM_HW:
+		if (hook != NF_IP_PRE_ROUTING && hook != NF_IP_LOCAL_IN)
+			break;
+		if ((protocol == 0 && !(u16)csum_fold(skb->csum)) ||
+		    !csum_tcpudp_magic(iph->saddr, iph->daddr,
+			    	       skb->len - dataoff, protocol,
+				       skb->csum)) {
+			skb->ip_summed = CHECKSUM_UNNECESSARY;
+			break;
+		}
+		/* fall through */
+	case CHECKSUM_NONE:
+		if (protocol == 0)
+			skb->csum = 0;
+		else
+			skb->csum = csum_tcpudp_nofold(iph->saddr, iph->daddr,
+						       skb->len - dataoff,
+						       protocol, 0);
+		csum = __skb_checksum_complete(skb);
+	}
+	return csum;
+}
+
+EXPORT_SYMBOL(nf_ip_checksum);
+
 static struct nf_afinfo nf_ip_afinfo = {
 	.family		= AF_INET,
+	.checksum	= nf_ip_checksum,
 	.saveroute	= nf_ip_saveroute,
 	.reroute	= nf_ip_reroute,
 	.route_key_size	= sizeof(struct ip_rt_info),
diff --git a/net/ipv6/netfilter.c b/net/ipv6/netfilter.c
index f514a01..3e9ecfa 100644
--- a/net/ipv6/netfilter.c
+++ b/net/ipv6/netfilter.c
@@ -79,8 +79,42 @@ static int nf_ip6_reroute(struct sk_buff
 	return 0;
 }
 
+unsigned int nf_ip6_checksum(struct sk_buff *skb, unsigned int hook,
+			     unsigned int dataoff, u_int8_t protocol)
+{
+	struct ipv6hdr *ip6h = skb->nh.ipv6h;
+	unsigned int csum = 0;
+
+	switch (skb->ip_summed) {
+	case CHECKSUM_HW:
+		if (hook != NF_IP6_PRE_ROUTING && hook != NF_IP6_LOCAL_IN)
+			break;
+		if (!csum_ipv6_magic(&ip6h->saddr, &ip6h->daddr,
+			    	     skb->len - dataoff, protocol,
+				     csum_sub(skb->csum,
+					      skb_checksum(skb, 0,
+							   dataoff, 0)))) {
+			skb->ip_summed = CHECKSUM_UNNECESSARY;
+			break;
+		}
+		/* fall through */
+	case CHECKSUM_NONE:
+		skb->csum = ~csum_ipv6_magic(&ip6h->saddr, &ip6h->daddr,
+					     skb->len - dataoff,
+					     protocol,
+					     csum_sub(0,
+						      skb_checksum(skb, 0,
+							           dataoff, 0)));
+		csum = __skb_checksum_complete(skb);
+	}
+	return csum;
+}
+
+EXPORT_SYMBOL(nf_ip6_checksum);
+
 static struct nf_afinfo nf_ip6_afinfo = {
 	.family		= AF_INET6,
+	.checksum	= nf_ip6_checksum,
 	.saveroute	= nf_ip6_saveroute,
 	.reroute	= nf_ip6_reroute,
 	.route_key_size	= sizeof(struct ip6_rt_info),
