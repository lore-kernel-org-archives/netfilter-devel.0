From: Patrick McHardy <kaber@trash.net>
Subject: netfilter 04/06: nf_conntrack: don't try to deliver events for untracked connections
Date: Tue, 24 Feb 2009 15:52:49 +0100 (MET)
Message-ID: <20090224145248.9789.33395.sendpatchset@x2.localnet>
References: <20090224145243.9789.60678.sendpatchset@x2.localnet>
Cc: netdev@vger.kernel.org, Patrick McHardy <kaber@trash.net>,
	netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20090224145243.9789.60678.sendpatchset@x2.localnet>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

commit 5962fc6d5fff09c8e6fb8cadcb18327a0f4277f7
Author: Patrick McHardy <kaber@trash.net>
Date:   Wed Feb 18 15:30:34 2009 +0100

    netfilter: nf_conntrack: don't try to deliver events for untracked connections
    
    The untracked conntrack actually does usually have events marked for
    delivery as its not special-cased in that part of the code. Skip the
    actual delivery since it impacts performance noticeably.
    
    Signed-off-by: Patrick McHardy <kaber@trash.net>

diff --git a/include/net/netfilter/nf_conntrack_core.h b/include/net/netfilter/nf_conntrack_core.h
index e78afe7..c25068e 100644
--- a/include/net/netfilter/nf_conntrack_core.h
+++ b/include/net/netfilter/nf_conntrack_core.h
@@ -59,7 +59,7 @@ static inline int nf_conntrack_confirm(struct sk_buff *skb)
 	struct nf_conn *ct = (struct nf_conn *)skb->nfct;
 	int ret = NF_ACCEPT;
 
-	if (ct) {
+	if (ct && ct != &nf_conntrack_untracked) {
 		if (!nf_ct_is_confirmed(ct) && !nf_ct_is_dying(ct))
 			ret = __nf_conntrack_confirm(skb);
 		nf_ct_deliver_cached_events(ct);
