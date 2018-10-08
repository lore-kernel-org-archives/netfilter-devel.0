From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 21/31] netfilter: conntrack: clamp l4proto array size at largers supported protocol
Date: Tue,  9 Oct 2018 01:01:15 +0200
Message-ID: <20181008230125.2330-22-pablo@netfilter.org>
References: <20181008230125.2330-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181008230125.2330-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Florian Westphal <fw@strlen.de>

All higher l4proto numbers are handled by the generic tracker; the
l4proto lookup function already returns generic one in case the l4proto
number exceeds max size.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_conntrack_l4proto.h | 2 +-
 net/netfilter/nf_conntrack_proto.c           | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack_l4proto.h b/include/net/netfilter/nf_conntrack_l4proto.h
index d838a93430a1..eed04af9b75e 100644
--- a/include/net/netfilter/nf_conntrack_l4proto.h
+++ b/include/net/netfilter/nf_conntrack_l4proto.h
@@ -102,7 +102,7 @@ int nf_conntrack_icmpv6_error(struct nf_conn *tmpl,
 /* Existing built-in generic protocol */
 extern const struct nf_conntrack_l4proto nf_conntrack_l4proto_generic;
 
-#define MAX_NF_CT_PROTO 256
+#define MAX_NF_CT_PROTO IPPROTO_UDPLITE
 
 const struct nf_conntrack_l4proto *__nf_ct_l4proto_find(u8 l4proto);
 
diff --git a/net/netfilter/nf_conntrack_proto.c b/net/netfilter/nf_conntrack_proto.c
index 69d7170cfa8c..40643af7137e 100644
--- a/net/netfilter/nf_conntrack_proto.c
+++ b/net/netfilter/nf_conntrack_proto.c
@@ -43,7 +43,7 @@
 
 extern unsigned int nf_conntrack_net_id;
 
-static struct nf_conntrack_l4proto __rcu *nf_ct_protos[MAX_NF_CT_PROTO] __read_mostly;
+static struct nf_conntrack_l4proto __rcu *nf_ct_protos[MAX_NF_CT_PROTO + 1] __read_mostly;
 
 static DEFINE_MUTEX(nf_ct_proto_mutex);
 
-- 
2.11.0
