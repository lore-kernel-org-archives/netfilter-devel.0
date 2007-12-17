From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 43/64]: nf_nat: sprinkle a few __read_mostlys
Date: Tue, 18 Dec 2007 00:47:11 +0100 (MET)
Message-ID: <20071217234711.23601.78004.sendpatchset@localhost.localdomain>
References: <20071217234612.23601.6979.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:39014 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754782AbXLQXrM (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 17 Dec 2007 18:47:12 -0500
In-Reply-To: <20071217234612.23601.6979.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[NETFILTER]: nf_nat: sprinkle a few __read_mostlys

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 2c4956d3c5e45fca0caa5f7c431d1c45d27ece49
tree 744cd193e410ca60c057e0ebc02941438f3adaf1
parent 7f35f5edca069881dc4bf771d08e192cd8704483
author Patrick McHardy <kaber@trash.net> Mon, 17 Dec 2007 14:58:31 +0100
committer Patrick McHardy <kaber@trash.net> Tue, 18 Dec 2007 00:24:57 +0100

 net/ipv4/netfilter/nf_nat_core.c |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/net/ipv4/netfilter/nf_nat_core.c b/net/ipv4/netfilter/nf_nat_core.c
index a772445..7cc179c 100644
--- a/net/ipv4/netfilter/nf_nat_core.c
+++ b/net/ipv4/netfilter/nf_nat_core.c
@@ -33,16 +33,17 @@
 
 static DEFINE_RWLOCK(nf_nat_lock);
 
-static struct nf_conntrack_l3proto *l3proto = NULL;
+static struct nf_conntrack_l3proto *l3proto __read_mostly;
 
 /* Calculated at init based on memory size */
-static unsigned int nf_nat_htable_size;
+static unsigned int nf_nat_htable_size __read_mostly;
 static int nf_nat_vmalloced;
 
-static struct hlist_head *bysource;
+static struct hlist_head *bysource __read_mostly;
 
 #define MAX_IP_NAT_PROTO 256
-static const struct nf_nat_protocol *nf_nat_protos[MAX_IP_NAT_PROTO];
+static const struct nf_nat_protocol *nf_nat_protos[MAX_IP_NAT_PROTO]
+						__read_mostly;
 
 static inline const struct nf_nat_protocol *
 __nf_nat_proto_find(u_int8_t protonum)
