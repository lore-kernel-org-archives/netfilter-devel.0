From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 08/12] netfilter: conntrack: reset tcp maxwin on re-register
Date: Tue, 11 Sep 2018 02:20:40 +0200
Message-ID: <20180911002044.9100-9-pablo@netfilter.org>
References: <20180911002044.9100-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180911002044.9100-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Florian Westphal <fw@strlen.de>

Doug Smythies says:
  Sometimes it is desirable to temporarily disable, or clear,
  the iptables rule set on a computer being controlled via a
  secure shell session (SSH). While unwise on an internet facing
  computer, I also do it often on non-internet accessible computers
  while testing. Recently, this has become problematic, with the
  SSH session being dropped upon re-load of the rule set.

The problem is that when all rules are deleted, conntrack hooks get
unregistered.

In case the rules are re-added later, its possible that tcp window
has moved far enough so that all packets are considered invalid (out of
window) until entry expires (which can take forever, default
established timeout is 5 days).

Fix this by clearing maxwin of existing tcp connections on register.

v2: don't touch entries on hook removal.
v3: remove obsolete expiry check.

Reported-by: Doug Smythies <dsmythies@telus.net>
Fixes: 4d3a57f23dec59 ("netfilter: conntrack: do not enable connection tracking unless needed")
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_conntrack_proto.c | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/net/netfilter/nf_conntrack_proto.c b/net/netfilter/nf_conntrack_proto.c
index 9f14b0df6960..51c5d7eec0a3 100644
--- a/net/netfilter/nf_conntrack_proto.c
+++ b/net/netfilter/nf_conntrack_proto.c
@@ -776,9 +776,26 @@ static const struct nf_hook_ops ipv6_conntrack_ops[] = {
 };
 #endif
 
+static int nf_ct_tcp_fixup(struct nf_conn *ct, void *_nfproto)
+{
+	u8 nfproto = (unsigned long)_nfproto;
+
+	if (nf_ct_l3num(ct) != nfproto)
+		return 0;
+
+	if (nf_ct_protonum(ct) == IPPROTO_TCP &&
+	    ct->proto.tcp.state == TCP_CONNTRACK_ESTABLISHED) {
+		ct->proto.tcp.seen[0].td_maxwin = 0;
+		ct->proto.tcp.seen[1].td_maxwin = 0;
+	}
+
+	return 0;
+}
+
 static int nf_ct_netns_do_get(struct net *net, u8 nfproto)
 {
 	struct nf_conntrack_net *cnet = net_generic(net, nf_conntrack_net_id);
+	bool fixup_needed = false;
 	int err = 0;
 
 	mutex_lock(&nf_ct_proto_mutex);
@@ -798,6 +815,8 @@ static int nf_ct_netns_do_get(struct net *net, u8 nfproto)
 					    ARRAY_SIZE(ipv4_conntrack_ops));
 		if (err)
 			cnet->users4 = 0;
+		else
+			fixup_needed = true;
 		break;
 #if IS_ENABLED(CONFIG_IPV6)
 	case NFPROTO_IPV6:
@@ -814,6 +833,8 @@ static int nf_ct_netns_do_get(struct net *net, u8 nfproto)
 					    ARRAY_SIZE(ipv6_conntrack_ops));
 		if (err)
 			cnet->users6 = 0;
+		else
+			fixup_needed = true;
 		break;
 #endif
 	default:
@@ -822,6 +843,11 @@ static int nf_ct_netns_do_get(struct net *net, u8 nfproto)
 	}
  out_unlock:
 	mutex_unlock(&nf_ct_proto_mutex);
+
+	if (fixup_needed)
+		nf_ct_iterate_cleanup_net(net, nf_ct_tcp_fixup,
+					  (void *)(unsigned long)nfproto, 0, 0);
+
 	return err;
 }
 
-- 
2.11.0
