From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [CTNETLINK] add support for internal tcp connection tracking flags
 handling
Date: Thu, 15 Feb 2007 04:23:56 +0100
Message-ID: <45D3D24C.30108@netfilter.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------030004080706020603060104"
Cc: Patrick McHardy <kaber@trash.net>
To: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
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

This is a multi-part message in MIME format.
--------------030004080706020603060104
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

This patch let userspace programs set the IP_CT_TCP_BE_LIBERAL flag to
force the pickup of established connections.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

-- 
The dawn of the fourth age of Linux firewalling is coming; a time of
great struggle and heroic deeds -- J.Kadlecsik got inspired by J.Morris

--------------030004080706020603060104
Content-Type: text/plain;
 name="01pickup.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="01pickup.patch"

[CTNETLINK] add support for internal tcp connection tracking flags handling

This patch let userspace programs set the IP_CT_TCP_BE_LIBERAL flag to force
the pickup of established connections.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

Index: net-2.6.git/net/ipv4/netfilter/ip_conntrack_proto_tcp.c
===================================================================
--- net-2.6.git.orig/net/ipv4/netfilter/ip_conntrack_proto_tcp.c	2007-02-15 02:51:49.000000000 +0100
+++ net-2.6.git/net/ipv4/netfilter/ip_conntrack_proto_tcp.c	2007-02-15 03:00:16.000000000 +0100
@@ -337,11 +337,26 @@ static int tcp_to_nfattr(struct sk_buff 
 			 const struct ip_conntrack *ct)
 {
 	struct nfattr *nest_parms;
+	struct nf_ct_tcp_flags tmp = {};
 
 	read_lock_bh(&tcp_lock);
 	nest_parms = NFA_NEST(skb, CTA_PROTOINFO_TCP);
 	NFA_PUT(skb, CTA_PROTOINFO_TCP_STATE, sizeof(u_int8_t),
 		&ct->proto.tcp.state);
+
+	NFA_PUT(skb, CTA_PROTOINFO_TCP_WSCALE_ORIGINAL, sizeof(u_int8_t),
+		&ct->proto.tcp.seen[0].td_scale);
+
+	NFA_PUT(skb, CTA_PROTOINFO_TCP_WSCALE_REPLY, sizeof(u_int8_t),
+		&ct->proto.tcp.seen[1].td_scale);
+
+	tmp.flags = ct->proto.tcp.seen[0].flags;
+	NFA_PUT(skb, CTA_PROTOINFO_TCP_FLAGS_ORIGINAL, 
+		sizeof(struct nf_ct_tcp_flags), &tmp);
+
+	tmp.flags = ct->proto.tcp.seen[1].flags;
+	NFA_PUT(skb, CTA_PROTOINFO_TCP_FLAGS_REPLY,
+		sizeof(struct nf_ct_tcp_flags), &tmp);
 	read_unlock_bh(&tcp_lock);
 
 	NFA_NEST_END(skb, nest_parms);
@@ -354,7 +369,11 @@ nfattr_failure:
 }
 
 static const size_t cta_min_tcp[CTA_PROTOINFO_TCP_MAX] = {
-	[CTA_PROTOINFO_TCP_STATE-1]	= sizeof(u_int8_t),
+	[CTA_PROTOINFO_TCP_STATE-1]	      = sizeof(u_int8_t),
+	[CTA_PROTOINFO_TCP_WSCALE_ORIGINAL-1] = sizeof(u_int8_t),
+	[CTA_PROTOINFO_TCP_WSCALE_REPLY-1]    = sizeof(u_int8_t),
+	[CTA_PROTOINFO_TCP_FLAGS_ORIGINAL-1]  = sizeof(struct nf_ct_tcp_flags),
+	[CTA_PROTOINFO_TCP_FLAGS_REPLY-1]     = sizeof(struct nf_ct_tcp_flags)
 };
 
 static int nfattr_to_tcp(struct nfattr *cda[], struct ip_conntrack *ct)
@@ -378,6 +397,30 @@ static int nfattr_to_tcp(struct nfattr *
 	write_lock_bh(&tcp_lock);
 	ct->proto.tcp.state =
 		*(u_int8_t *)NFA_DATA(tb[CTA_PROTOINFO_TCP_STATE-1]);
+
+	if (tb[CTA_PROTOINFO_TCP_FLAGS_ORIGINAL-1]) {
+		struct nf_ct_tcp_flags *attr =
+			NFA_DATA(tb[CTA_PROTOINFO_TCP_FLAGS_ORIGINAL-1]);
+		ct->proto.tcp.seen[0].flags &= ~attr->mask;
+		ct->proto.tcp.seen[0].flags |= attr->flags & attr->mask;
+	}
+
+	if (tb[CTA_PROTOINFO_TCP_FLAGS_REPLY-1]) {
+		struct nf_ct_tcp_flags *attr =
+			NFA_DATA(tb[CTA_PROTOINFO_TCP_FLAGS_REPLY-1]);
+		ct->proto.tcp.seen[1].flags &= ~attr->mask;
+		ct->proto.tcp.seen[1].flags |= attr->flags & attr->mask;
+	}
+
+	if (tb[CTA_PROTOINFO_TCP_WSCALE_ORIGINAL-1] &&
+	    tb[CTA_PROTOINFO_TCP_WSCALE_REPLY-1] &&
+	    ct->proto.tcp.seen[0].flags & IP_CT_TCP_FLAG_WINDOW_SCALE &&
+	    ct->proto.tcp.seen[1].flags & IP_CT_TCP_FLAG_WINDOW_SCALE) {
+		ct->proto.tcp.seen[0].td_scale = *(u_int8_t *)
+			NFA_DATA(tb[CTA_PROTOINFO_TCP_WSCALE_ORIGINAL-1]);
+		ct->proto.tcp.seen[1].td_scale = *(u_int8_t *)
+			NFA_DATA(tb[CTA_PROTOINFO_TCP_WSCALE_REPLY-1]);
+	}
 	write_unlock_bh(&tcp_lock);
 
 	return 0;
Index: net-2.6.git/net/netfilter/nf_conntrack_proto_tcp.c
===================================================================
--- net-2.6.git.orig/net/netfilter/nf_conntrack_proto_tcp.c	2007-02-15 02:51:49.000000000 +0100
+++ net-2.6.git/net/netfilter/nf_conntrack_proto_tcp.c	2007-02-15 02:57:33.000000000 +0100
@@ -1110,11 +1110,26 @@ static int tcp_to_nfattr(struct sk_buff 
 			 const struct nf_conn *ct)
 {
 	struct nfattr *nest_parms;
+	struct nf_ct_tcp_flags tmp = {};
 
 	read_lock_bh(&tcp_lock);
 	nest_parms = NFA_NEST(skb, CTA_PROTOINFO_TCP);
 	NFA_PUT(skb, CTA_PROTOINFO_TCP_STATE, sizeof(u_int8_t),
 		&ct->proto.tcp.state);
+
+	NFA_PUT(skb, CTA_PROTOINFO_TCP_WSCALE_ORIGINAL, sizeof(u_int8_t),
+		&ct->proto.tcp.seen[0].td_scale);
+
+	NFA_PUT(skb, CTA_PROTOINFO_TCP_WSCALE_REPLY, sizeof(u_int8_t),
+		&ct->proto.tcp.seen[1].td_scale);
+
+	tmp.flags = ct->proto.tcp.seen[0].flags;
+	NFA_PUT(skb, CTA_PROTOINFO_TCP_FLAGS_ORIGINAL,
+		sizeof(struct nf_ct_tcp_flags), &tmp);
+
+	tmp.flags = ct->proto.tcp.seen[1].flags;
+	NFA_PUT(skb, CTA_PROTOINFO_TCP_FLAGS_REPLY,
+		sizeof(struct nf_ct_tcp_flags), &tmp);
 	read_unlock_bh(&tcp_lock);
 
 	NFA_NEST_END(skb, nest_parms);
@@ -1127,7 +1142,11 @@ nfattr_failure:
 }
 
 static const size_t cta_min_tcp[CTA_PROTOINFO_TCP_MAX] = {
-	[CTA_PROTOINFO_TCP_STATE-1]	= sizeof(u_int8_t),
+	[CTA_PROTOINFO_TCP_STATE-1]	      = sizeof(u_int8_t),
+	[CTA_PROTOINFO_TCP_WSCALE_ORIGINAL-1] = sizeof(u_int8_t),
+	[CTA_PROTOINFO_TCP_WSCALE_REPLY-1]    = sizeof(u_int8_t),
+	[CTA_PROTOINFO_TCP_FLAGS_ORIGINAL-1]  = sizeof(struct nf_ct_tcp_flags),
+	[CTA_PROTOINFO_TCP_FLAGS_REPLY-1]     = sizeof(struct nf_ct_tcp_flags)
 };
 
 static int nfattr_to_tcp(struct nfattr *cda[], struct nf_conn *ct)
@@ -1151,6 +1170,30 @@ static int nfattr_to_tcp(struct nfattr *
 	write_lock_bh(&tcp_lock);
 	ct->proto.tcp.state =
 		*(u_int8_t *)NFA_DATA(tb[CTA_PROTOINFO_TCP_STATE-1]);
+
+	if (tb[CTA_PROTOINFO_TCP_FLAGS_ORIGINAL-1]) {
+		struct nf_ct_tcp_flags *attr =
+			NFA_DATA(tb[CTA_PROTOINFO_TCP_FLAGS_ORIGINAL-1]);
+		ct->proto.tcp.seen[0].flags &= ~attr->mask;
+		ct->proto.tcp.seen[0].flags |= attr->flags & attr->mask;
+	}
+
+	if (tb[CTA_PROTOINFO_TCP_FLAGS_REPLY-1]) {
+		struct nf_ct_tcp_flags *attr =
+			NFA_DATA(tb[CTA_PROTOINFO_TCP_FLAGS_REPLY-1]);
+		ct->proto.tcp.seen[1].flags &= ~attr->mask;
+		ct->proto.tcp.seen[1].flags |= attr->flags & attr->mask;
+	}
+
+	if (tb[CTA_PROTOINFO_TCP_WSCALE_ORIGINAL-1] &&
+	    tb[CTA_PROTOINFO_TCP_WSCALE_REPLY-1] &&
+	    ct->proto.tcp.seen[0].flags & IP_CT_TCP_FLAG_WINDOW_SCALE &&
+	    ct->proto.tcp.seen[1].flags & IP_CT_TCP_FLAG_WINDOW_SCALE) {
+		ct->proto.tcp.seen[0].td_scale = *(u_int8_t *)
+			NFA_DATA(tb[CTA_PROTOINFO_TCP_WSCALE_ORIGINAL-1]);
+		ct->proto.tcp.seen[1].td_scale = *(u_int8_t *)
+			NFA_DATA(tb[CTA_PROTOINFO_TCP_WSCALE_REPLY-1]);
+	}
 	write_unlock_bh(&tcp_lock);
 
 	return 0;
Index: net-2.6.git/include/linux/netfilter/nfnetlink_conntrack.h
===================================================================
--- net-2.6.git.orig/include/linux/netfilter/nfnetlink_conntrack.h	2007-02-15 02:51:43.000000000 +0100
+++ net-2.6.git/include/linux/netfilter/nfnetlink_conntrack.h	2007-02-15 02:55:18.000000000 +0100
@@ -83,6 +83,10 @@ enum ctattr_protoinfo {
 enum ctattr_protoinfo_tcp {
 	CTA_PROTOINFO_TCP_UNSPEC,
 	CTA_PROTOINFO_TCP_STATE,
+	CTA_PROTOINFO_TCP_WSCALE_ORIGINAL,
+	CTA_PROTOINFO_TCP_WSCALE_REPLY,
+	CTA_PROTOINFO_TCP_FLAGS_ORIGINAL,
+	CTA_PROTOINFO_TCP_FLAGS_REPLY,
 	__CTA_PROTOINFO_TCP_MAX
 };
 #define CTA_PROTOINFO_TCP_MAX (__CTA_PROTOINFO_TCP_MAX - 1)
Index: net-2.6.git/include/linux/netfilter/nf_conntrack_tcp.h
===================================================================
--- net-2.6.git.orig/include/linux/netfilter/nf_conntrack_tcp.h	2007-02-15 02:51:43.000000000 +0100
+++ net-2.6.git/include/linux/netfilter/nf_conntrack_tcp.h	2007-02-15 02:55:18.000000000 +0100
@@ -30,6 +30,11 @@ enum tcp_conntrack {
 /* Be liberal in window checking */
 #define IP_CT_TCP_FLAG_BE_LIBERAL		0x08
 
+struct nf_ct_tcp_flags {
+	u_int8_t flags;
+	u_int8_t mask;
+};
+
 #ifdef __KERNEL__
 
 struct ip_ct_tcp_state {

--------------030004080706020603060104--
