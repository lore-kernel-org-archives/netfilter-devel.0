From: Arushi Singhal <arushisinghal19971997@gmail.com>
Subject: [PATCH] net: netfilter: Merge assignment with return
Date: Thu, 29 Mar 2018 00:39:50 +0530
Message-ID: <20180328190950.GA3151@seema-Inspiron-15-3567>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: outreachy-kernel <outreachy-kernel@googlegroups.com>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Merge assignment with return statement to directly return the value.

Signed-off-by: Arushi Singhal <arushisinghal19971997@gmail.com>
---
 net/netfilter/nf_conntrack_netlink.c | 5 ++---
 net/netfilter/xt_hashlimit.c         | 3 +--
 2 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index dd177eb..bfa8b7f 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -1497,9 +1497,8 @@ ctnetlink_setup_nat(struct nf_conn *ct, const struct nlattr * const cda[])
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
index 66f5aca..9e8ba2e 100644
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
2.7.4
