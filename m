From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: [PATCH] nf_conntrack_proto_gre: spread __exit
Date: Thu, 20 Nov 2008 12:01:20 +0300
Message-ID: <20081120090120.GC1927@x200.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.172]:26939 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754000AbYKTI5i (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 20 Nov 2008 03:57:38 -0500
Received: by ug-out-1314.google.com with SMTP id 39so209323ugf.37
        for <netfilter-devel@vger.kernel.org>; Thu, 20 Nov 2008 00:57:36 -0800 (PST)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 net/netfilter/nf_conntrack_proto_gre.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

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
