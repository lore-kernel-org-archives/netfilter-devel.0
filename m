From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 11/16] netfilter: nfnetlink_cttimeout: fetch timeouts for udplite and gre, too
Date: Wed, 28 Nov 2018 11:17:36 +0100
Message-ID: <20181128101741.20924-12-pablo@netfilter.org>
References: <20181128101741.20924-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181128101741.20924-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Florian Westphal <fw@strlen.de>

syzbot was able to trigger the WARN in cttimeout_default_get() by
passing UDPLITE as l4protocol.  Alias UDPLITE to UDP, both use
same timeout values.

Furthermore, also fetch GRE timeouts.  GRE is a bit more complicated,
as it still can be a module and its netns_proto_gre struct layout isn't
visible outside of the gre module. Can't move timeouts around, it
appears conntrack sysctl unregister assumes net_generic() returns
nf_proto_net, so we get crash. Expose layout of netns_proto_gre instead.

A followup nf-next patch could make gre tracker be built-in as well
if needed, its not that large.

Last, make the WARN() mention the missing protocol value in case
anything else is missing.

Reported-by: syzbot+2fae8fa157dd92618cae@syzkaller.appspotmail.com
Fixes: 8866df9264a3 ("netfilter: nfnetlink_cttimeout: pass default timeout policy to obj_to_nlattr")
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/linux/netfilter/nf_conntrack_proto_gre.h | 13 +++++++++++++
 net/netfilter/nf_conntrack_proto_gre.c           | 14 ++------------
 net/netfilter/nfnetlink_cttimeout.c              | 15 +++++++++++++--
 3 files changed, 28 insertions(+), 14 deletions(-)

diff --git a/include/linux/netfilter/nf_conntrack_proto_gre.h b/include/linux/netfilter/nf_conntrack_proto_gre.h
index b8d95564bd53..14edb795ab43 100644
--- a/include/linux/netfilter/nf_conntrack_proto_gre.h
+++ b/include/linux/netfilter/nf_conntrack_proto_gre.h
@@ -21,6 +21,19 @@ struct nf_ct_gre_keymap {
 	struct nf_conntrack_tuple tuple;
 };
 
+enum grep_conntrack {
+	GRE_CT_UNREPLIED,
+	GRE_CT_REPLIED,
+	GRE_CT_MAX
+};
+
+struct netns_proto_gre {
+	struct nf_proto_net	nf;
+	rwlock_t		keymap_lock;
+	struct list_head	keymap_list;
+	unsigned int		gre_timeouts[GRE_CT_MAX];
+};
+
 /* add new tuple->key_reply pair to keymap */
 int nf_ct_gre_keymap_add(struct nf_conn *ct, enum ip_conntrack_dir dir,
 			 struct nf_conntrack_tuple *t);
diff --git a/net/netfilter/nf_conntrack_proto_gre.c b/net/netfilter/nf_conntrack_proto_gre.c
index 9b48dc8b4b88..2a5e56c6d8d9 100644
--- a/net/netfilter/nf_conntrack_proto_gre.c
+++ b/net/netfilter/nf_conntrack_proto_gre.c
@@ -43,24 +43,12 @@
 #include <linux/netfilter/nf_conntrack_proto_gre.h>
 #include <linux/netfilter/nf_conntrack_pptp.h>
 
-enum grep_conntrack {
-	GRE_CT_UNREPLIED,
-	GRE_CT_REPLIED,
-	GRE_CT_MAX
-};
-
 static const unsigned int gre_timeouts[GRE_CT_MAX] = {
 	[GRE_CT_UNREPLIED]	= 30*HZ,
 	[GRE_CT_REPLIED]	= 180*HZ,
 };
 
 static unsigned int proto_gre_net_id __read_mostly;
-struct netns_proto_gre {
-	struct nf_proto_net	nf;
-	rwlock_t		keymap_lock;
-	struct list_head	keymap_list;
-	unsigned int		gre_timeouts[GRE_CT_MAX];
-};
 
 static inline struct netns_proto_gre *gre_pernet(struct net *net)
 {
@@ -402,6 +390,8 @@ static int __init nf_ct_proto_gre_init(void)
 {
 	int ret;
 
+	BUILD_BUG_ON(offsetof(struct netns_proto_gre, nf) != 0);
+
 	ret = register_pernet_subsys(&proto_gre_net_ops);
 	if (ret < 0)
 		goto out_pernet;
diff --git a/net/netfilter/nfnetlink_cttimeout.c b/net/netfilter/nfnetlink_cttimeout.c
index a518eb162344..109b0d27345a 100644
--- a/net/netfilter/nfnetlink_cttimeout.c
+++ b/net/netfilter/nfnetlink_cttimeout.c
@@ -455,7 +455,8 @@ static int cttimeout_default_get(struct net *net, struct sock *ctnl,
 	case IPPROTO_TCP:
 		timeouts = nf_tcp_pernet(net)->timeouts;
 		break;
-	case IPPROTO_UDP:
+	case IPPROTO_UDP: /* fallthrough */
+	case IPPROTO_UDPLITE:
 		timeouts = nf_udp_pernet(net)->timeouts;
 		break;
 	case IPPROTO_DCCP:
@@ -471,11 +472,21 @@ static int cttimeout_default_get(struct net *net, struct sock *ctnl,
 		timeouts = nf_sctp_pernet(net)->timeouts;
 #endif
 		break;
+	case IPPROTO_GRE:
+#ifdef CONFIG_NF_CT_PROTO_GRE
+		if (l4proto->net_id) {
+			struct netns_proto_gre *net_gre;
+
+			net_gre = net_generic(net, *l4proto->net_id);
+			timeouts = net_gre->gre_timeouts;
+		}
+#endif
+		break;
 	case 255:
 		timeouts = &nf_generic_pernet(net)->timeout;
 		break;
 	default:
-		WARN_ON_ONCE(1);
+		WARN_ONCE(1, "Missing timeouts for proto %d", l4proto->l4proto);
 		break;
 	}
 
-- 
2.11.0
