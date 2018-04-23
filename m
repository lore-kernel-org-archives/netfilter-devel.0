From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 01/12] netfilter: nf_conntrack_sip: allow duplicate SDP expectations
Date: Mon, 23 Apr 2018 19:57:03 +0200
Message-ID: <20180423175714.9794-2-pablo@netfilter.org>
References: <20180423175714.9794-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180423175714.9794-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Florian Westphal <fw@strlen.de>

Callum Sinclair reported SIP IP Phone errors that he tracked down to
such phones sending session descriptions for different media types but
with same port numbers.

The expect core will only 'refresh' existing expectation if it is
from same master AND same expectation class (media type).
As expectation class is different, we get an error.

The SIP connection tracking code will then

1). drop the SDP packet
2). if an rtp expectation was already installed successfully,
    error on rtcp expectation will cancel the rtp one.

Make the expect core report back to caller when the conflict is due
to different expectation class and have SIP tracker ignore soft-error.

Reported-by: Callum Sinclair <Callum.Sinclair@alliedtelesis.co.nz>
Tested-by: Callum Sinclair <Callum.Sinclair@alliedtelesis.co.nz>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_conntrack_expect.c |  5 ++++-
 net/netfilter/nf_conntrack_sip.c    | 16 ++++++++++++----
 2 files changed, 16 insertions(+), 5 deletions(-)

diff --git a/net/netfilter/nf_conntrack_expect.c b/net/netfilter/nf_conntrack_expect.c
index 8ef21d9f9a00..4b2b3d53acfc 100644
--- a/net/netfilter/nf_conntrack_expect.c
+++ b/net/netfilter/nf_conntrack_expect.c
@@ -252,7 +252,7 @@ static inline int expect_clash(const struct nf_conntrack_expect *a,
 static inline int expect_matches(const struct nf_conntrack_expect *a,
 				 const struct nf_conntrack_expect *b)
 {
-	return a->master == b->master && a->class == b->class &&
+	return a->master == b->master &&
 	       nf_ct_tuple_equal(&a->tuple, &b->tuple) &&
 	       nf_ct_tuple_mask_equal(&a->mask, &b->mask) &&
 	       net_eq(nf_ct_net(a->master), nf_ct_net(b->master)) &&
@@ -421,6 +421,9 @@ static inline int __nf_ct_expect_check(struct nf_conntrack_expect *expect)
 	h = nf_ct_expect_dst_hash(net, &expect->tuple);
 	hlist_for_each_entry_safe(i, next, &nf_ct_expect_hash[h], hnode) {
 		if (expect_matches(i, expect)) {
+			if (i->class != expect->class)
+				return -EALREADY;
+
 			if (nf_ct_remove_expect(i))
 				break;
 		} else if (expect_clash(i, expect)) {
diff --git a/net/netfilter/nf_conntrack_sip.c b/net/netfilter/nf_conntrack_sip.c
index 4dbb5bad4363..908e51e2dc2b 100644
--- a/net/netfilter/nf_conntrack_sip.c
+++ b/net/netfilter/nf_conntrack_sip.c
@@ -938,11 +938,19 @@ static int set_expected_rtp_rtcp(struct sk_buff *skb, unsigned int protoff,
 				       datalen, rtp_exp, rtcp_exp,
 				       mediaoff, medialen, daddr);
 	else {
-		if (nf_ct_expect_related(rtp_exp) == 0) {
-			if (nf_ct_expect_related(rtcp_exp) != 0)
-				nf_ct_unexpect_related(rtp_exp);
-			else
+		/* -EALREADY handling works around end-points that send
+		 * SDP messages with identical port but different media type,
+		 * we pretend expectation was set up.
+		 */
+		int errp = nf_ct_expect_related(rtp_exp);
+
+		if (errp == 0 || errp == -EALREADY) {
+			int errcp = nf_ct_expect_related(rtcp_exp);
+
+			if (errcp == 0 || errcp == -EALREADY)
 				ret = NF_ACCEPT;
+			else if (errp == 0)
+				nf_ct_unexpect_related(rtp_exp);
 		}
 	}
 	nf_ct_expect_put(rtcp_exp);
-- 
2.11.0
