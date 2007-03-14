From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 21/22]: ctnetlink: add support for internal tcp
	connection tracking flags handling
Date: Wed, 14 Mar 2007 09:50:48 +0100 (MET)
Message-ID: <20070314085033.15282.37078.sendpatchset@localhost.localdomain>
References: <20070314084946.15282.58609.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
To: davem@davemloft.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <20070314084946.15282.58609.sendpatchset@localhost.localdomain>
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

[NETFILTER]: ctnetlink: add support for internal tcp connection tracking flags handling

This patch let userspace programs set the IP_CT_TCP_BE_LIBERAL flag to
force the pickup of established connections.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 95cddede9ae6fddfb993ab5d989f6d96cdf4e8e8
tree 760bf19f0f49fb668b24552e9243b5568b0a615e
parent 3607514396585a2be00d6d0aa3081a96532e5db7
author Pablo Neira Ayuso <pablo@netfilter.org> Wed, 14 Mar 2007 09:34:50 +0100
committer Patrick McHardy <kaber@trash.net> Wed, 14 Mar 2007 09:34:50 +0100

 include/linux/netfilter/nf_conntrack_tcp.h    |    5 +++
 include/linux/netfilter/nfnetlink_conntrack.h |    4 ++
 net/netfilter/nf_conntrack_proto_tcp.c        |   45 ++++++++++++++++++++++++-
 3 files changed, 53 insertions(+), 1 deletions(-)

diff --git a/include/linux/netfilter/nf_conntrack_tcp.h b/include/linux/netfilter/nf_conntrack_tcp.h
index 007af4c..22ce299 100644
--- a/include/linux/netfilter/nf_conntrack_tcp.h
+++ b/include/linux/netfilter/nf_conntrack_tcp.h
@@ -30,6 +30,11 @@ #define IP_CT_TCP_FLAG_CLOSE_INIT		0x04
 /* Be liberal in window checking */
 #define IP_CT_TCP_FLAG_BE_LIBERAL		0x08
 
+struct nf_ct_tcp_flags {
+	u_int8_t flags;
+	u_int8_t mask;
+};
+
 #ifdef __KERNEL__
 
 struct ip_ct_tcp_state {
diff --git a/include/linux/netfilter/nfnetlink_conntrack.h b/include/linux/netfilter/nfnetlink_conntrack.h
index b5883cc..d7c3503 100644
--- a/include/linux/netfilter/nfnetlink_conntrack.h
+++ b/include/linux/netfilter/nfnetlink_conntrack.h
@@ -83,6 +83,10 @@ #define CTA_PROTOINFO_MAX (__CTA_PROTOIN
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
diff --git a/net/netfilter/nf_conntrack_proto_tcp.c b/net/netfilter/nf_conntrack_proto_tcp.c
index a136362..8439768 100644
--- a/net/netfilter/nf_conntrack_proto_tcp.c
+++ b/net/netfilter/nf_conntrack_proto_tcp.c
@@ -1101,11 +1101,26 @@ static int tcp_to_nfattr(struct sk_buff 
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
@@ -1118,7 +1133,11 @@ nfattr_failure:
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
@@ -1142,6 +1161,30 @@ static int nfattr_to_tcp(struct nfattr *
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
