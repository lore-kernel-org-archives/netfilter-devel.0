From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 44/47] netfilter: Merge assignment with return
Date: Fri, 30 Mar 2018 13:46:16 +0200
Message-ID: <20180330114619.18797-5-pablo@netfilter.org>
References: <20180330114619.18797-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180330114619.18797-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Arushi Singhal <arushisinghal19971997@gmail.com>

Merge assignment with return statement to directly return the value.

Signed-off-by: Arushi Singhal <arushisinghal19971997@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_conntrack_netlink.c | 5 ++---
 net/netfilter/xt_hashlimit.c         | 3 +--
 2 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 11ef85a57244..b00e84bf4107 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -1527,9 +1527,8 @@ ctnetlink_setup_nat(struct nf_conn *ct, const struct nlattr * const cda[])
 	if (ret < 0)
 		return ret;
 
-	ret = ctnetlink_parse_nat_setup(ct, NF_NAT_MANIP_SRC,
-					cda[CTA_NAT_SRC]);
-	return ret;
+	return ctnetlink_parse_nat_setup(ct, NF_NAT_MANIP_SRC,
+					 cda[CTA_NAT_SRC]);
 #else
 	if (!cda[CTA_NAT_DST] && !cda[CTA_NAT_SRC])
 		return 0;
diff --git a/net/netfilter/xt_hashlimit.c b/net/netfilter/xt_hashlimit.c
index db2fe0911740..64fc3721d74c 100644
--- a/net/netfilter/xt_hashlimit.c
+++ b/net/netfilter/xt_hashlimit.c
@@ -534,8 +534,7 @@ static u64 user2rate_bytes(u32 user)
 	u64 r;
 
 	r = user ? U32_MAX / user : U32_MAX;
-	r = (r - 1) << XT_HASHLIMIT_BYTE_SHIFT;
-	return r;
+	return (r - 1) << XT_HASHLIMIT_BYTE_SHIFT;
 }
 
 static void rateinfo_recalc(struct dsthash_ent *dh, unsigned long now,
-- 
2.11.0
