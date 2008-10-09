From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 7/8] [PATCH] dynamic calculation of event message size
 for	ctnetlink
Date: Thu, 09 Oct 2008 18:45:49 +0200
Message-ID: <48EE353D.7030805@netfilter.org>
References: <20081009083339.9824.24056.stgit@Decadence> <20081009083559.9824.53525.stgit@Decadence>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------080302030502010903030005"
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:53335 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752773AbYJIQ5i (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 9 Oct 2008 12:57:38 -0400
In-Reply-To: <20081009083559.9824.53525.stgit@Decadence>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multi-part message in MIME format.
--------------080302030502010903030005
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Pablo Neira Ayuso wrote:
> This patch adds dynamic message size calculation for ctnetlink. This
> reduces CPU consumption since the overhead in the message trimming
> is removed.

Please, take this patch instead. I just noticed one uninitilized
variable in calculate_helper_room_size().

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers

--------------080302030502010903030005
Content-Type: text/x-diff;
 name="07.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="07.patch"

[PATCH] dynamic calculation of event message size for ctnetlink

From: Pablo Neira Ayuso <pablo@netfilter.org>

This patch adds dynamic message size calculation for ctnetlink. This
reduces CPU consumption since the overhead in the message trimming
is removed.

Based on a suggestion from Patrick McHardy.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---

 include/net/netfilter/nf_conntrack_l3proto.h   |    2 
 include/net/netfilter/nf_conntrack_l4proto.h   |    3 +
 net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c |    6 +
 net/ipv4/netfilter/nf_conntrack_proto_icmp.c   |    8 ++
 net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c |    6 +
 net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c |    8 ++
 net/netfilter/nf_conntrack_core.c              |    6 +
 net/netfilter/nf_conntrack_netlink.c           |  103 ++++++++++++++++++++++++
 net/netfilter/nf_conntrack_proto_dccp.c        |   10 ++
 net/netfilter/nf_conntrack_proto_gre.c         |    1 
 net/netfilter/nf_conntrack_proto_sctp.c        |   12 +++
 net/netfilter/nf_conntrack_proto_tcp.c         |   14 +++
 net/netfilter/nf_conntrack_proto_udp.c         |    2 
 net/netfilter/nf_conntrack_proto_udplite.c     |    2 
 14 files changed, 182 insertions(+), 1 deletions(-)


diff --git a/include/net/netfilter/nf_conntrack_l3proto.h b/include/net/netfilter/nf_conntrack_l3proto.h
index 0378676..e0007f9 100644
--- a/include/net/netfilter/nf_conntrack_l3proto.h
+++ b/include/net/netfilter/nf_conntrack_l3proto.h
@@ -55,6 +55,8 @@ struct nf_conntrack_l3proto
 
 	int (*nlattr_to_tuple)(struct nlattr *tb[],
 			       struct nf_conntrack_tuple *t);
+
+	size_t (*nlattr_size)(void);
 	const struct nla_policy *nla_policy;
 
 #ifdef CONFIG_SYSCTL
diff --git a/include/net/netfilter/nf_conntrack_l4proto.h b/include/net/netfilter/nf_conntrack_l4proto.h
index 7f2f43c..3c80479 100644
--- a/include/net/netfilter/nf_conntrack_l4proto.h
+++ b/include/net/netfilter/nf_conntrack_l4proto.h
@@ -72,6 +72,8 @@ struct nf_conntrack_l4proto
 			       const struct nf_conntrack_tuple *t);
 	int (*nlattr_to_tuple)(struct nlattr *tb[],
 			       struct nf_conntrack_tuple *t);
+	size_t (*nlattr_size)(void);
+	size_t (*nlattr_protoinfo_size)(void);
 	const struct nla_policy *nla_policy;
 
 #ifdef CONFIG_SYSCTL
@@ -115,6 +117,7 @@ extern int nf_ct_port_tuple_to_nlattr(struct sk_buff *skb,
 				      const struct nf_conntrack_tuple *tuple);
 extern int nf_ct_port_nlattr_to_tuple(struct nlattr *tb[],
 				      struct nf_conntrack_tuple *t);
+extern size_t nf_ct_port_nlattr_size(void);
 extern const struct nla_policy nf_ct_port_nla_policy[];
 
 #ifdef CONFIG_SYSCTL
diff --git a/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c b/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
index 4a7c352..7b354e5 100644
--- a/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
+++ b/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
@@ -330,6 +330,11 @@ static int ipv4_nlattr_to_tuple(struct nlattr *tb[],
 
 	return 0;
 }
+
+static size_t ipv4_nlattr_size(void)
+{
+	return nla_total_size(sizeof(u_int32_t))*2;
+}
 #endif
 
 static struct nf_sockopt_ops so_getorigdst = {
@@ -350,6 +355,7 @@ struct nf_conntrack_l3proto nf_conntrack_l3proto_ipv4 __read_mostly = {
 #if defined(CONFIG_NF_CT_NETLINK) || defined(CONFIG_NF_CT_NETLINK_MODULE)
 	.tuple_to_nlattr = ipv4_tuple_to_nlattr,
 	.nlattr_to_tuple = ipv4_nlattr_to_tuple,
+	.nlattr_size	 = ipv4_nlattr_size,
 	.nla_policy	 = ipv4_nla_policy,
 #endif
 #if defined(CONFIG_SYSCTL) && defined(CONFIG_NF_CONNTRACK_PROC_COMPAT)
diff --git a/net/ipv4/netfilter/nf_conntrack_proto_icmp.c b/net/ipv4/netfilter/nf_conntrack_proto_icmp.c
index 4e88792..9e6bb21 100644
--- a/net/ipv4/netfilter/nf_conntrack_proto_icmp.c
+++ b/net/ipv4/netfilter/nf_conntrack_proto_icmp.c
@@ -262,6 +262,13 @@ static int icmp_nlattr_to_tuple(struct nlattr *tb[],
 
 	return 0;
 }
+
+static size_t icmp_nlattr_size(void)
+{
+	return nla_total_size(sizeof(u_int8_t)) +
+	       nla_total_size(sizeof(u_int8_t)) +
+	       nla_total_size(sizeof(u_int16_t));
+}
 #endif
 
 #ifdef CONFIG_SYSCTL
@@ -310,6 +317,7 @@ struct nf_conntrack_l4proto nf_conntrack_l4proto_icmp __read_mostly =
 #if defined(CONFIG_NF_CT_NETLINK) || defined(CONFIG_NF_CT_NETLINK_MODULE)
 	.tuple_to_nlattr	= icmp_tuple_to_nlattr,
 	.nlattr_to_tuple	= icmp_nlattr_to_tuple,
+	.nlattr_size		= icmp_nlattr_size,
 	.nla_policy		= icmp_nla_policy,
 #endif
 #ifdef CONFIG_SYSCTL
diff --git a/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c b/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c
index e91db16..3bc103d 100644
--- a/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c
+++ b/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c
@@ -342,6 +342,11 @@ static int ipv6_nlattr_to_tuple(struct nlattr *tb[],
 
 	return 0;
 }
+
+static size_t ipv6_nlattr_size(void)
+{
+	return nla_total_size(sizeof(u_int32_t)*4)*2;
+}
 #endif
 
 struct nf_conntrack_l3proto nf_conntrack_l3proto_ipv6 __read_mostly = {
@@ -354,6 +359,7 @@ struct nf_conntrack_l3proto nf_conntrack_l3proto_ipv6 __read_mostly = {
 #if defined(CONFIG_NF_CT_NETLINK) || defined(CONFIG_NF_CT_NETLINK_MODULE)
 	.tuple_to_nlattr	= ipv6_tuple_to_nlattr,
 	.nlattr_to_tuple	= ipv6_nlattr_to_tuple,
+	.nlattr_size		= ipv6_nlattr_size,
 	.nla_policy		= ipv6_nla_policy,
 #endif
 #ifdef CONFIG_SYSCTL
diff --git a/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c b/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c
index 0572617..1c32c71 100644
--- a/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c
+++ b/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c
@@ -243,6 +243,13 @@ static int icmpv6_nlattr_to_tuple(struct nlattr *tb[],
 
 	return 0;
 }
+
+static size_t icmpv6_nlattr_size(void)
+{
+	return nla_total_size(sizeof(u_int8_t)) +
+	       nla_total_size(sizeof(u_int8_t)) +
+	       nla_total_size(sizeof(u_int16_t));
+}
 #endif
 
 #ifdef CONFIG_SYSCTL
@@ -275,6 +282,7 @@ struct nf_conntrack_l4proto nf_conntrack_l4proto_icmpv6 __read_mostly =
 #if defined(CONFIG_NF_CT_NETLINK) || defined(CONFIG_NF_CT_NETLINK_MODULE)
 	.tuple_to_nlattr	= icmpv6_tuple_to_nlattr,
 	.nlattr_to_tuple	= icmpv6_nlattr_to_tuple,
+	.nlattr_size		= icmpv6_nlattr_size,
 	.nla_policy		= icmpv6_nla_policy,
 #endif
 #ifdef CONFIG_SYSCTL
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 8c482c4..d44b225 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -897,6 +897,12 @@ int nf_ct_port_nlattr_to_tuple(struct nlattr *tb[],
 	return 0;
 }
 EXPORT_SYMBOL_GPL(nf_ct_port_nlattr_to_tuple);
+
+size_t nf_ct_port_nlattr_size(void)
+{
+	return nla_total_size(sizeof(u_int16_t))*2;
+}
+EXPORT_SYMBOL_GPL(nf_ct_port_nlattr_size);
 #endif
 
 /* Used by ipt_REJECT and ip6t_REJECT. */
diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 4316e1f..2d4dbc7 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -404,6 +404,107 @@ nla_put_failure:
 }
 
 #ifdef CONFIG_NF_CONNTRACK_EVENTS
+static inline size_t calculate_tuple_room_size(const struct nf_conn *ct)
+{
+	struct nf_conntrack_l3proto *l3proto;
+        struct nf_conntrack_l4proto *l4proto;
+	size_t size;
+
+	rcu_read_lock();
+	/* nested attributes CTA_TUPLE_[ORIG|REPLY] plus CTA_TUPLE_IP */
+	size = nla_total_size(0) * 2;
+	l3proto = __nf_ct_l3proto_find(nf_ct_l3num(ct));
+	if (likely(l3proto->nlattr_size))
+		size += l3proto->nlattr_size();
+
+	/* nested attributes CTA_TUPLE_PROTO plus CTA_PROTONUM */
+	size += nla_total_size(0) + nla_total_size(sizeof(u_int8_t));
+	l4proto = __nf_ct_l4proto_find(nf_ct_l3num(ct), nf_ct_protonum(ct));
+	if (likely(l4proto->nlattr_size))
+		size += l4proto->nlattr_size();
+
+	rcu_read_unlock();
+	return size;
+}
+
+static inline size_t calculate_protoinfo_room_size(const struct nf_conn *ct)
+{
+	size_t size = 0;
+	struct nf_conntrack_l4proto *l4proto;
+
+	rcu_read_lock();
+	l4proto = __nf_ct_l4proto_find(nf_ct_l3num(ct), nf_ct_protonum(ct));
+	if (l4proto->nlattr_protoinfo_size)
+		size = l4proto->nlattr_protoinfo_size();
+	rcu_read_unlock();
+
+	return size;
+}
+
+static inline size_t calculate_helper_room_size(const struct nf_conn *ct)
+{
+	const struct nf_conn_help *help = nfct_help(ct);
+	struct nf_conntrack_helper *helper;
+	size_t size;
+
+	if (!help)
+		goto out;
+
+	rcu_read_lock();
+	helper = rcu_dereference(help->helper);
+	if (!helper)
+		goto out_unlock;
+
+	size = nla_total_size(0) + 			/* CTA_HELP */
+	       nla_total_size(strlen(helper->name));
+out_unlock:
+	rcu_read_unlock();
+out:
+	return size;
+}
+
+static inline size_t
+ctnetlink_calculate_room_size(const struct nf_conn *ct, unsigned long events)
+{
+	size_t size = NLMSG_SPACE(sizeof(struct nfgenmsg));
+
+	size += calculate_tuple_room_size(ct) * 2 +  /* original and reply */
+		nla_total_size(sizeof(u_int32_t)) +  /* status */
+		nla_total_size(sizeof(u_int32_t));   /* id */
+
+#ifdef CONFIG_NF_CONNTRACK_MARK
+	if (events & IPCT_MARK || ct->mark)
+		size += nla_total_size(sizeof(u_int32_t));
+#endif
+
+	if (events & IPCT_DESTROY) {
+		const struct nf_conn_counter *acct;
+
+		acct = nf_conn_acct_find(ct);
+		if (acct) {
+			size += nla_total_size(0) * 2 +
+				nla_total_size(sizeof(u_int64_t)) * 2 * 2;
+		}
+		return size;
+	}
+
+	size += nla_total_size(sizeof(u_int32_t));	/* CTA_TIMEOUT */
+	if (events & IPCT_PROTOINFO) {
+		size += calculate_protoinfo_room_size(ct);
+	}if (events & IPCT_HELPER || nfct_help(ct))
+		size += calculate_helper_room_size(ct);
+	if (events & IPCT_RELATED)
+		size += calculate_tuple_room_size(ct->master);
+	if (events & IPCT_NATSEQADJ)
+		size += nla_total_size(0) * 2 +
+			nla_total_size(sizeof(u_int32_t)) * 3 * 2;
+#ifdef CONFIG_NF_CONNTRACK_SECMARK
+	if (events & IPCT_SECMARK || ct->secmark)
+		size += nla_total_size(sizeof(u_int32_t));
+#endif
+	return size;
+}
+
 static int ctnetlink_conntrack_event(struct notifier_block *this,
 				     unsigned long events, void *ptr)
 {
@@ -437,7 +538,7 @@ static int ctnetlink_conntrack_event(struct notifier_block *this,
 	if (!nfnetlink_has_listeners(group))
 		return NOTIFY_DONE;
 
-	skb = alloc_skb(NLMSG_GOODSIZE, GFP_ATOMIC);
+	skb = alloc_skb(ctnetlink_calculate_room_size(ct, events), GFP_ATOMIC);
 	if (!skb)
 		return NOTIFY_DONE;
 
diff --git a/net/netfilter/nf_conntrack_proto_dccp.c b/net/netfilter/nf_conntrack_proto_dccp.c
index 8fcf176..6694173 100644
--- a/net/netfilter/nf_conntrack_proto_dccp.c
+++ b/net/netfilter/nf_conntrack_proto_dccp.c
@@ -657,6 +657,12 @@ static int nlattr_to_dccp(struct nlattr *cda[], struct nf_conn *ct)
 	write_unlock_bh(&dccp_lock);
 	return 0;
 }
+
+static size_t dccp_nlattr_protoinfo_size(void)
+{
+	return nla_total_size(0)*2 +	/* CTA_PROTOINFO */
+	       nla_total_size(sizeof(u_int8_t));
+}
 #endif
 
 #ifdef CONFIG_SYSCTL
@@ -749,6 +755,8 @@ static struct nf_conntrack_l4proto dccp_proto4 __read_mostly = {
 	.from_nlattr		= nlattr_to_dccp,
 	.tuple_to_nlattr	= nf_ct_port_tuple_to_nlattr,
 	.nlattr_to_tuple	= nf_ct_port_nlattr_to_tuple,
+	.nlattr_size		= nf_ct_port_nlattr_size,
+	.nlattr_protoinfo_size	= dccp_nlattr_protoinfo_size,
 	.nla_policy		= nf_ct_port_nla_policy,
 #endif
 #ifdef CONFIG_SYSCTL
@@ -774,6 +782,8 @@ static struct nf_conntrack_l4proto dccp_proto6 __read_mostly = {
 	.from_nlattr		= nlattr_to_dccp,
 	.tuple_to_nlattr	= nf_ct_port_tuple_to_nlattr,
 	.nlattr_to_tuple	= nf_ct_port_nlattr_to_tuple,
+	.nlattr_size		= nf_ct_port_nlattr_size,
+	.nlattr_protoinfo_size	= dccp_nlattr_protoinfo_size,
 	.nla_policy		= nf_ct_port_nla_policy,
 #endif
 #ifdef CONFIG_SYSCTL
diff --git a/net/netfilter/nf_conntrack_proto_gre.c b/net/netfilter/nf_conntrack_proto_gre.c
index a2cdbcb..6e381c9 100644
--- a/net/netfilter/nf_conntrack_proto_gre.c
+++ b/net/netfilter/nf_conntrack_proto_gre.c
@@ -294,6 +294,7 @@ static struct nf_conntrack_l4proto nf_conntrack_l4proto_gre4 __read_mostly = {
 #if defined(CONFIG_NF_CT_NETLINK) || defined(CONFIG_NF_CT_NETLINK_MODULE)
 	.tuple_to_nlattr = nf_ct_port_tuple_to_nlattr,
 	.nlattr_to_tuple = nf_ct_port_nlattr_to_tuple,
+	.nlattr_size	 = nf_ct_port_nlattr_size,
 	.nla_policy	 = nf_ct_port_nla_policy,
 #endif
 };
diff --git a/net/netfilter/nf_conntrack_proto_sctp.c b/net/netfilter/nf_conntrack_proto_sctp.c
index ae8c260..a867849 100644
--- a/net/netfilter/nf_conntrack_proto_sctp.c
+++ b/net/netfilter/nf_conntrack_proto_sctp.c
@@ -537,6 +537,14 @@ static int nlattr_to_sctp(struct nlattr *cda[], struct nf_conn *ct)
 
 	return 0;
 }
+
+static size_t sctp_nlattr_protoinfo_size(void)
+{
+	return nla_total_size(0)*2 +           /* CTA_PROTOINFO */
+	       nla_total_size(sizeof(u_int8_t)) +
+	       nla_total_size(sizeof(u_int32_t)) +
+	       nla_total_size(sizeof(u_int32_t));
+}
 #endif
 
 #ifdef CONFIG_SYSCTL
@@ -671,6 +679,8 @@ static struct nf_conntrack_l4proto nf_conntrack_l4proto_sctp4 __read_mostly = {
 	.from_nlattr		= nlattr_to_sctp,
 	.tuple_to_nlattr	= nf_ct_port_tuple_to_nlattr,
 	.nlattr_to_tuple	= nf_ct_port_nlattr_to_tuple,
+	.nlattr_size		= nf_ct_port_nlattr_size,
+	.nlattr_protoinfo_size	= sctp_nlattr_protoinfo_size,
 	.nla_policy		= nf_ct_port_nla_policy,
 #endif
 #ifdef CONFIG_SYSCTL
@@ -699,6 +709,8 @@ static struct nf_conntrack_l4proto nf_conntrack_l4proto_sctp6 __read_mostly = {
 	.from_nlattr		= nlattr_to_sctp,
 	.tuple_to_nlattr	= nf_ct_port_tuple_to_nlattr,
 	.nlattr_to_tuple	= nf_ct_port_nlattr_to_tuple,
+	.nlattr_size		= nf_ct_port_nlattr_size,
+	.nlattr_protoinfo_size	= sctp_nlattr_protoinfo_size,
 	.nla_policy		= nf_ct_port_nla_policy,
 #endif
 #ifdef CONFIG_SYSCTL
diff --git a/net/netfilter/nf_conntrack_proto_tcp.c b/net/netfilter/nf_conntrack_proto_tcp.c
index f947ec4..ddc87a3 100644
--- a/net/netfilter/nf_conntrack_proto_tcp.c
+++ b/net/netfilter/nf_conntrack_proto_tcp.c
@@ -1181,6 +1181,16 @@ static int nlattr_to_tcp(struct nlattr *cda[], struct nf_conn *ct)
 
 	return 0;
 }
+
+static size_t tcp_nlattr_protoinfo_size(void)
+{
+	return nla_total_size(0)*2 +	/* CTA_PROTOINFO */
+	       nla_total_size(sizeof(u_int8_t)) +
+	       nla_total_size(sizeof(u_int8_t)) +
+	       nla_total_size(sizeof(u_int8_t)) +
+	       nla_total_size(sizeof(struct nf_ct_tcp_flags)) +
+	       nla_total_size(sizeof(struct nf_ct_tcp_flags));
+}
 #endif
 
 #ifdef CONFIG_SYSCTL
@@ -1399,6 +1409,8 @@ struct nf_conntrack_l4proto nf_conntrack_l4proto_tcp4 __read_mostly =
 	.from_nlattr		= nlattr_to_tcp,
 	.tuple_to_nlattr	= nf_ct_port_tuple_to_nlattr,
 	.nlattr_to_tuple	= nf_ct_port_nlattr_to_tuple,
+	.nlattr_size		= nf_ct_port_nlattr_size,
+	.nlattr_protoinfo_size	= tcp_nlattr_protoinfo_size,
 	.nla_policy		= nf_ct_port_nla_policy,
 #endif
 #ifdef CONFIG_SYSCTL
@@ -1429,6 +1441,8 @@ struct nf_conntrack_l4proto nf_conntrack_l4proto_tcp6 __read_mostly =
 	.from_nlattr		= nlattr_to_tcp,
 	.tuple_to_nlattr	= nf_ct_port_tuple_to_nlattr,
 	.nlattr_to_tuple	= nf_ct_port_nlattr_to_tuple,
+	.nlattr_size		= nf_ct_port_nlattr_size,
+	.nlattr_protoinfo_size	= tcp_nlattr_protoinfo_size,
 	.nla_policy		= nf_ct_port_nla_policy,
 #endif
 #ifdef CONFIG_SYSCTL
diff --git a/net/netfilter/nf_conntrack_proto_udp.c b/net/netfilter/nf_conntrack_proto_udp.c
index 7c2ca48..549da2c 100644
--- a/net/netfilter/nf_conntrack_proto_udp.c
+++ b/net/netfilter/nf_conntrack_proto_udp.c
@@ -193,6 +193,7 @@ struct nf_conntrack_l4proto nf_conntrack_l4proto_udp4 __read_mostly =
 #if defined(CONFIG_NF_CT_NETLINK) || defined(CONFIG_NF_CT_NETLINK_MODULE)
 	.tuple_to_nlattr	= nf_ct_port_tuple_to_nlattr,
 	.nlattr_to_tuple	= nf_ct_port_nlattr_to_tuple,
+	.nlattr_size		= nf_ct_port_nlattr_size,
 	.nla_policy		= nf_ct_port_nla_policy,
 #endif
 #ifdef CONFIG_SYSCTL
@@ -220,6 +221,7 @@ struct nf_conntrack_l4proto nf_conntrack_l4proto_udp6 __read_mostly =
 #if defined(CONFIG_NF_CT_NETLINK) || defined(CONFIG_NF_CT_NETLINK_MODULE)
 	.tuple_to_nlattr	= nf_ct_port_tuple_to_nlattr,
 	.nlattr_to_tuple	= nf_ct_port_nlattr_to_tuple,
+	.nlattr_size		= nf_ct_port_nlattr_size,
 	.nla_policy		= nf_ct_port_nla_policy,
 #endif
 #ifdef CONFIG_SYSCTL
diff --git a/net/netfilter/nf_conntrack_proto_udplite.c b/net/netfilter/nf_conntrack_proto_udplite.c
index d22d839..70a21ff 100644
--- a/net/netfilter/nf_conntrack_proto_udplite.c
+++ b/net/netfilter/nf_conntrack_proto_udplite.c
@@ -181,6 +181,7 @@ static struct nf_conntrack_l4proto nf_conntrack_l4proto_udplite4 __read_mostly =
 #if defined(CONFIG_NF_CT_NETLINK) || defined(CONFIG_NF_CT_NETLINK_MODULE)
 	.tuple_to_nlattr	= nf_ct_port_tuple_to_nlattr,
 	.nlattr_to_tuple	= nf_ct_port_nlattr_to_tuple,
+	.nlattr_size		= nf_ct_port_nlattr_size,
 	.nla_policy		= nf_ct_port_nla_policy,
 #endif
 #ifdef CONFIG_SYSCTL
@@ -204,6 +205,7 @@ static struct nf_conntrack_l4proto nf_conntrack_l4proto_udplite6 __read_mostly =
 #if defined(CONFIG_NF_CT_NETLINK) || defined(CONFIG_NF_CT_NETLINK_MODULE)
 	.tuple_to_nlattr	= nf_ct_port_tuple_to_nlattr,
 	.nlattr_to_tuple	= nf_ct_port_nlattr_to_tuple,
+	.nlattr_size		= nf_ct_port_nlattr_size,
 	.nla_policy		= nf_ct_port_nla_policy,
 #endif
 #ifdef CONFIG_SYSCTL

--------------080302030502010903030005--
