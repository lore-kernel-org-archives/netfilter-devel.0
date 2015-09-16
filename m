From: "Eric W. Biederman" <ebiederm@xmission.com>
Subject: [PATCH next 01/30] netfilter: Remove !CONFIG_NETFITLER definition of nf_hook_thresh
Date: Tue, 15 Sep 2015 20:03:49 -0500
Message-ID: <1442365458-16349-1-git-send-email-ebiederm@xmission.com>
References: <87mvwn18my.fsf@x220.int.ebiederm.org>
Cc: netfilter-devel@vger.kernel.org, <netdev@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	David Miller <davem@davemloft.net>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <87mvwn18my.fsf@x220.int.ebiederm.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

The !CONFIG_NETFILTER definition of nf_hook_thresh calls okfn when
the CONFIG_NETFITLER defintion does not, making it buggy.

As the !CONFIG_NETFILTER defintion of nf_hook_thresh is not used remove
it rather than fix it.

Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---
 include/linux/netfilter.h | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/include/linux/netfilter.h b/include/linux/netfilter.h
index 36a652531791..1abac85ec907 100644
--- a/include/linux/netfilter.h
+++ b/include/linux/netfilter.h
@@ -344,15 +344,6 @@ nf_nat_decode_session(struct sk_buff *skb, struct flowi *fl, u_int8_t family)
 #else /* !CONFIG_NETFILTER */
 #define NF_HOOK(pf, hook, sk, skb, indev, outdev, okfn) (okfn)(sk, skb)
 #define NF_HOOK_COND(pf, hook, sk, skb, indev, outdev, okfn, cond) (okfn)(sk, skb)
-static inline int nf_hook_thresh(u_int8_t pf, unsigned int hook,
-				 struct sock *sk,
-				 struct sk_buff *skb,
-				 struct net_device *indev,
-				 struct net_device *outdev,
-				 int (*okfn)(struct sock *sk, struct sk_buff *), int thresh)
-{
-	return okfn(sk, skb);
-}
 static inline int nf_hook(u_int8_t pf, unsigned int hook, struct sock *sk,
 			  struct sk_buff *skb, struct net_device *indev,
 			  struct net_device *outdev,
-- 
2.2.1
