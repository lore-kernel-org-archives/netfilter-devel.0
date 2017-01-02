From: Davide Caratti <dcaratti@redhat.com>
Subject: [PATCH nf-next 1/2] netfilter: select LIBCRC32C together with SCTP conntrack
Date: Mon,  2 Jan 2017 13:29:40 +0100
Message-ID: <c4b47e21dcfae883d63dd1c43537346ee3bfa89d.1483355460.git.dcaratti@redhat.com>
References: <cover.1483355460.git.dcaratti@redhat.com>
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org
To: Pablo Neira Ayuso <pablo@netfilter.org>,
        Patrick McHardy <kaber@trash.net>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        "David S . Miller" <davem@davemloft.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40524 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751440AbdABMaJ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 2 Jan 2017 07:30:09 -0500
In-Reply-To: <cover.1483355460.git.dcaratti@redhat.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

nf_conntrack needs to compute crc32c when dealing with SCTP packets.
Moreover, NF_NAT_PROTO_SCTP (currently selecting LIBCRC32C) can be enabled
only if conntrack support for SCTP is enabled. Therefore, move enabling of
kernel support for crc32c so that it is selected when NF_CT_PROTO_SCTP=y.

Signed-off-by: Davide Caratti <dcaratti@redhat.com>
---
 net/netfilter/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index 63729b4..6d425e3 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -162,6 +162,7 @@ config NF_CT_PROTO_SCTP
 	bool 'SCTP protocol connection tracking support'
 	depends on NETFILTER_ADVANCED
 	default y
+	select LIBCRC32C
 	help
 	  With this option enabled, the layer 3 independent connection
 	  tracking code will be able to do state tracking on SCTP connections.
@@ -397,7 +398,6 @@ config NF_NAT_PROTO_SCTP
 	bool
 	default NF_NAT && NF_CT_PROTO_SCTP
 	depends on NF_NAT && NF_CT_PROTO_SCTP
-	select LIBCRC32C
 
 config NF_NAT_AMANDA
 	tristate
-- 
2.7.4

