From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf] netfilter: nfnetlink_cttimeout: fetch timeouts for udplite and gre, too
Date: Sat, 17 Nov 2018 11:32:29 +0100
Message-ID: <20181117103229.24678-1-fw@strlen.de>
References: <0000000000004f5883057acf6af2@google.com>
Cc: syzkaller-bugs@googlegroups.com, <netdev@vger.kernel.org>,
        Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <0000000000004f5883057acf6af2@google.com>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

syzbot was able to trigger the WARN in cttimeout_default_get() by
passing UDPLITE as l4protocol.  Alias UDPLITE to UDP, both use
same timeout values.

Furthermore, also fetch GRE timeouts.  GRE is a bit more complicated,
as it still can be a module and its netns_proto_gre struct layout isn't
visible outside of the gre module.

Work around this by forcing the timeouts to be the first structure
member, then use plain net_generic().

A followup nf-next patch could make gre tracker be built-in as well
if needed, its not that large.

Last, make the WARN() mention the missing protocol value in case
anything else is missing.

Reported-by: syzbot+2fae8fa157dd92618cae@syzkaller.appspotmail.com
Fixes: 8866df9264a3 ("netfilter: nfnetlink_cttimeout: pass default timeout policy to obj_to_nlattr")
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nf_conntrack_proto_gre.c |  4 +++-
 net/netfilter/nfnetlink_cttimeout.c    | 11 +++++++++--
 2 files changed, 12 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/nf_conntrack_proto_gre.c b/net/netfilter/nf_conntrack_proto_gre.c
index 9b48dc8b4b88..dd8db7fbc437 100644
--- a/net/netfilter/nf_conntrack_proto_gre.c
+++ b/net/netfilter/nf_conntrack_proto_gre.c
@@ -56,10 +56,10 @@ static const unsigned int gre_timeouts[GRE_CT_MAX] = {
 
 static unsigned int proto_gre_net_id __read_mostly;
 struct netns_proto_gre {
+	unsigned int		gre_timeouts[GRE_CT_MAX];
 	struct nf_proto_net	nf;
 	rwlock_t		keymap_lock;
 	struct list_head	keymap_list;
-	unsigned int		gre_timeouts[GRE_CT_MAX];
 };
 
 static inline struct netns_proto_gre *gre_pernet(struct net *net)
@@ -402,6 +402,8 @@ static int __init nf_ct_proto_gre_init(void)
 {
 	int ret;
 
+	BUILD_BUG_ON(offsetof(struct netns_proto_gre, gre_timeouts));
+
 	ret = register_pernet_subsys(&proto_gre_net_ops);
 	if (ret < 0)
 		goto out_pernet;
diff --git a/net/netfilter/nfnetlink_cttimeout.c b/net/netfilter/nfnetlink_cttimeout.c
index a518eb162344..1643faa35f56 100644
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
@@ -469,13 +470,19 @@ static int cttimeout_default_get(struct net *net, struct sock *ctnl,
 	case IPPROTO_SCTP:
 #ifdef CONFIG_NF_CT_PROTO_SCTP
 		timeouts = nf_sctp_pernet(net)->timeouts;
+#endif
+		break;
+	case IPPROTO_GRE:
+#ifdef CONFIG_NF_CT_PROTO_GRE
+		if (l4proto->net_id)
+			timeouts = net_generic(net, *l4proto->net_id);
 #endif
 		break;
 	case 255:
 		timeouts = &nf_generic_pernet(net)->timeout;
 		break;
 	default:
-		WARN_ON_ONCE(1);
+		WARN_ONCE(1, "Missing timeouts for proto %d", l4proto->l4proto);
 		break;
 	}
 
-- 
2.18.1
