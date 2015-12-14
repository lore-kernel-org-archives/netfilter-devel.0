From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH -stable-*] netfilter: nf_conntrack: Support expectations in different zones
Date: Mon, 14 Dec 2015 13:18:22 +0100
Message-ID: <1450095502-24949-1-git-send-email-pablo@netfilter.org>
Cc: stable@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <stable-owner@vger.kernel.org>
Sender: stable-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Joe Stringer <joestringer@nicira.com>

[ upstream commit 4b31814d20cbe5cd4ccf18089751e77a04afe4f2 ]

When zones were originally introduced, the expectation functions were
all extended to perform lookup using the zone. However, insertion was
not modified to check the zone. This means that two expectations which
are intended to apply for different connections that have the same tuple
but exist in different zones cannot both be tracked.

Fixes: 5d0aa2ccd4 (netfilter: nf_conntrack: add support for "conntrack zones")
Cc: <stable@vger.kernel.org> # 3.2.x
Cc: <stable@vger.kernel.org> # 3.4.x
Cc: <stable@vger.kernel.org> # 3.12.x
Cc: <stable@vger.kernel.org> # 3.14.x
Cc: <stable@vger.kernel.org> # 3.18.x
Cc: <stable@vger.kernel.org> # 4.1.x
Signed-off-by: Joe Stringer <joestringer@nicira.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_conntrack_expect.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nf_conntrack_expect.c b/net/netfilter/nf_conntrack_expect.c
index 7a17070..b45a422 100644
--- a/net/netfilter/nf_conntrack_expect.c
+++ b/net/netfilter/nf_conntrack_expect.c
@@ -219,7 +219,8 @@ static inline int expect_clash(const struct nf_conntrack_expect *a,
 			a->mask.src.u3.all[count] & b->mask.src.u3.all[count];
 	}
 
-	return nf_ct_tuple_mask_cmp(&a->tuple, &b->tuple, &intersect_mask);
+	return nf_ct_tuple_mask_cmp(&a->tuple, &b->tuple, &intersect_mask) &&
+	       nf_ct_zone(a->master) == nf_ct_zone(b->master);
 }
 
 static inline int expect_matches(const struct nf_conntrack_expect *a,
-- 
1.7.10.4
