From: Patrick McHardy <kaber@trash.net>
Subject: netfilter 22/29: nf_conntrack_proto_gre: spread __exit
Date: Thu, 27 Nov 2008 17:15:33 +0100 (MET)
Message-ID: <20081127161532.13891.92929.sendpatchset@x2.localnet>
References: <20081127161503.13891.62766.sendpatchset@x2.localnet>
Cc: netdev@vger.kernel.org, Patrick McHardy <kaber@trash.net>,
	netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20081127161503.13891.62766.sendpatchset@x2.localnet>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

commit 56bc0f9603e45cf13db51e554e1541e289a7f8e9
Author: Alexey Dobriyan <adobriyan@gmail.com>
Date:   Thu Nov 20 10:01:37 2008 +0100

    netfilter: nf_conntrack_proto_gre: spread __exit
    
    Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
    Signed-off-by: Patrick McHardy <kaber@trash.net>

diff --git a/net/netfilter/nf_conntrack_proto_gre.c b/net/netfilter/nf_conntrack_proto_gre.c
index 4ab62ad..1b279f9 100644
--- a/net/netfilter/nf_conntrack_proto_gre.c
+++ b/net/netfilter/nf_conntrack_proto_gre.c
@@ -341,7 +341,7 @@ static int __init nf_ct_proto_gre_init(void)
 	return rv;
 }
 
-static void nf_ct_proto_gre_fini(void)
+static void __exit nf_ct_proto_gre_fini(void)
 {
 	nf_conntrack_l4proto_unregister(&nf_conntrack_l4proto_gre4);
 	unregister_pernet_gen_subsys(proto_gre_net_id, &proto_gre_net_ops);
