From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 7/7] dynamic calculation of event message size for ctnetlin
Date: Wed, 30 Jul 2008 13:06:31 +0200
Message-ID: <48904B37.7090108@netfilter.org>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------080706070006010302070501"
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>,
	Fabian Hugelshofer <hugelshofer2006@gmx.ch>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:59598 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753275AbYG3LGl (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 30 Jul 2008 07:06:41 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multi-part message in MIME format.
--------------080706070006010302070501
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

[PATCH] dynamic calculation of event message size for ctnetlink

This patch adds dynamic message size calculation for ctnetlink. This
reduces CPU consumption since the overhead in the message trimming
is removed.

Note that if we create an entry in the connection tracking for
any layer 3 or 4 protocol helper that is not loaded, eg. SCTP,
DCCP, IPv6, the calculated size is not accurate.

Based on a suggestion from Patrick McHardy.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers

--------------080706070006010302070501
Content-Type: text/x-diff;
 name="07.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="07.patch"

[PATCH] dynamic calculation of event message size for ctnetlink

This patch adds dynamic message size calculation for ctnetlink. This 
reduces CPU consumption since the overhead in the message trimming
is removed.

Note that if we create an entry in the connection tracking for
any layer 3 or 4 protocol helper that is not loaded, eg. SCTP, 
DCCP, IPv6, the calculated size is not accurate.

Based on a suggestion from Patrick McHardy.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

Index: net-next-2.6.git/net/netfilter/nf_conntrack_netlink.c
===================================================================
--- net-next-2.6.git.orig/net/netfilter/nf_conntrack_netlink.c	2008-07-30 09:10:09.000000000 +0200
+++ net-next-2.6.git/net/netfilter/nf_conntrack_netlink.c	2008-07-30 09:12:11.000000000 +0200
@@ -402,6 +402,127 @@ nla_put_failure:
 }
 
 #ifdef CONFIG_NF_CONNTRACK_EVENTS
+static inline size_t calculate_tuple_room_size(const struct nf_conn *ct)
+{
+	size_t size = nla_total_size(0);		/* CTA_TUPLE_XYZ */
+
+	size += nla_total_size(0);			/* CTA_TUPLE_IP */
+	switch(nf_ct_l3num(ct)) {
+	case AF_INET:
+		size += nla_total_size(sizeof(u_int32_t))*2;
+		break;
+	case AF_INET6:
+		size += nla_total_size(sizeof(u_int32_t)*4)*2;
+		break;
+	}
+
+	size += nla_total_size(0);			/* CTA_TUPLE_PROTO */
+	size += nla_total_size(sizeof(u_int8_t));	/* CTA_PROTONUM */
+	switch(nf_ct_protonum(ct)) {
+	case IPPROTO_TCP:
+	case IPPROTO_UDP:
+	case IPPROTO_UDPLITE:
+	case IPPROTO_DCCP:
+	case IPPROTO_SCTP:
+		size += nla_total_size(sizeof(u_int16_t))*2;
+		break;
+	case IPPROTO_ICMP:
+	case IPPROTO_ICMPV6:
+		size += nla_total_size(sizeof(u_int8_t)) +
+			nla_total_size(sizeof(u_int8_t)) +
+			nla_total_size(sizeof(u_int16_t));
+		break;
+	}
+
+	return size;
+}
+
+static inline size_t calculate_protoinfo_room_size(const struct nf_conn *ct)
+{
+	size_t size = 0;
+
+	switch(nf_ct_protonum(ct)) {
+	case IPPROTO_TCP:
+		size += nla_total_size(0)*2 +		/* CTA_PROTOINFO */
+			nla_total_size(sizeof(u_int8_t)) +
+			nla_total_size(sizeof(u_int8_t)) +
+			nla_total_size(sizeof(u_int8_t)) +
+			nla_total_size(sizeof(struct nf_ct_tcp_flags)) +
+			nla_total_size(sizeof(struct nf_ct_tcp_flags));
+		break;
+	case IPPROTO_SCTP:
+		size += nla_total_size(0)*2 +		/* CTA_PROTOINFO */
+			nla_total_size(sizeof(u_int8_t)) +
+			nla_total_size(sizeof(u_int32_t)) +
+			nla_total_size(sizeof(u_int32_t));
+		break;
+	case IPPROTO_DCCP:
+		size += nla_total_size(0)*2 +		/* CTA_PROTOINFO */
+			nla_total_size(sizeof(u_int8_t));
+		break;
+	}
+	return size;
+}
+
+static inline size_t calculate_helper_room_size(const struct nf_conn *ct)
+{
+	const struct nf_conn_help *help = nfct_help(ct);
+	struct nf_conntrack_helper *helper;
+	size_t size = 0;
+
+	if (!help)
+		goto out;
+
+	rcu_read_lock();
+	helper = rcu_dereference(help->helper);
+	if (!helper)
+		goto out_unlock;
+
+	size += nla_total_size(0) + 			/* CTA_HELP */
+		nla_total_size(strlen(helper->name));
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
+	if (events & IPCT_DESTROY || (events & IPCT_COUNTER_FILLING)) {
+		size += nla_total_size(0) * 2 +
+			nla_total_size(sizeof(u_int32_t)) * 2 * 2;
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
@@ -435,7 +556,7 @@ static int ctnetlink_conntrack_event(str
 	if (!nfnetlink_has_listeners(group))
 		return NOTIFY_DONE;
 
-	skb = alloc_skb(NLMSG_GOODSIZE, GFP_ATOMIC);
+	skb = alloc_skb(ctnetlink_calculate_room_size(ct, events), GFP_ATOMIC);
 	if (!skb)
 		return NOTIFY_DONE;
 

--------------080706070006010302070501--
