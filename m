From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nf] netfilter: nf_conntrack: silent warning when adding extensions to templates
Date: Mon, 20 Jul 2015 10:49:57 +0200
Message-ID: <1437382197-3515-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:36568 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754500AbbGTIoP (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 20 Jul 2015 04:44:15 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[   12.602995] ------------[ cut here ]------------
[   12.604390] WARNING: CPU: 0 PID: 1 at net/netfilter/nf_conntrack_extend.c:80 __nf_ct_ext_add_length+0x2a/0x230()

Templates need to be unconfirmed when adding extensions to avoid this warning.

Fixes: 579502f10880 ("netfilter: fix netns dependencies with conntrack templates")
Reported-by: kernel test robot <ying.huang@intel.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_conntrack_core.c |    2 +-
 net/netfilter/nf_synproxy_core.c  |    1 +
 net/netfilter/xt_CT.c             |    1 +
 3 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 3d12eb7..651039a 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -296,7 +296,7 @@ struct nf_conn *nf_ct_tmpl_alloc(struct net *net, u16 zone, gfp_t flags)
 	if (tmpl == NULL)
 		return NULL;
 
-	tmpl->status = IPS_TEMPLATE | IPS_CONFIRMED;
+	tmpl->status = IPS_TEMPLATE;
 	write_pnet(&tmpl->ct_net, net);
 
 #ifdef CONFIG_NF_CONNTRACK_ZONES
diff --git a/net/netfilter/nf_synproxy_core.c b/net/netfilter/nf_synproxy_core.c
index 5fb14b9..71f1e9f 100644
--- a/net/netfilter/nf_synproxy_core.c
+++ b/net/netfilter/nf_synproxy_core.c
@@ -363,6 +363,7 @@ static int __net_init synproxy_net_init(struct net *net)
 	if (!nfct_synproxy_ext_add(ct))
 		goto err2;
 
+	__set_bit(IPS_CONFIRMED_BIT, &ct->status);
 	nf_conntrack_get(&ct->ct_general);
 	snet->tmpl = ct;
 
diff --git a/net/netfilter/xt_CT.c b/net/netfilter/xt_CT.c
index 20b9cb0..c663003 100644
--- a/net/netfilter/xt_CT.c
+++ b/net/netfilter/xt_CT.c
@@ -225,6 +225,7 @@ static int xt_ct_tg_check(const struct xt_tgchk_param *par,
 		if (ret < 0)
 			goto err3;
 	}
+	__set_bit(IPS_CONFIRMED_BIT, &ct->status);
 	nf_conntrack_get(&ct->ct_general);
 out:
 	info->ct = ct;
-- 
1.7.10.4

