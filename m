From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next] netfilter: fix fallout from xt/nf osf separation
Date: Tue,  8 May 2018 10:05:38 +0200
Message-ID: <20180508080538.31992-1-fw@strlen.de>
References: <20180508102101.768d5c52@canb.auug.org.au>
Cc: sfr@canb.auug.org.au, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, ffmancera@riseup.net,
        Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180508102101.768d5c52@canb.auug.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Stephen Rothwell says:
  today's linux-next build (x86_64 allmodconfig) produced this warning:
  ./usr/include/linux/netfilter/nf_osf.h:25: found __[us]{8,16,32,64} type without #include <linux/types.h>

Fix that up and also move kernel-private struct out of uapi (it was not
exposed in any released kernel version).

tested via allmodconfig build + make headers_check.

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Fixes: bfb15f2a95cb ("netfilter: extract Passive OS fingerprint infrastructure from xt_osf")
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/linux/netfilter/nf_osf.h      | 6 ++++++
 include/uapi/linux/netfilter/nf_osf.h | 8 ++------
 2 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/include/linux/netfilter/nf_osf.h b/include/linux/netfilter/nf_osf.h
index a2b39602e87d..0e114c492fb8 100644
--- a/include/linux/netfilter/nf_osf.h
+++ b/include/linux/netfilter/nf_osf.h
@@ -21,6 +21,12 @@ enum osf_fmatch_states {
 	FMATCH_OPT_WRONG,
 };
 
+struct nf_osf_finger {
+	struct rcu_head			rcu_head;
+	struct list_head		finger_entry;
+	struct nf_osf_user_finger	finger;
+};
+
 bool nf_osf_match(const struct sk_buff *skb, u_int8_t family,
 		  int hooknum, struct net_device *in, struct net_device *out,
 		  const struct nf_osf_info *info, struct net *net,
diff --git a/include/uapi/linux/netfilter/nf_osf.h b/include/uapi/linux/netfilter/nf_osf.h
index 45376eae31ef..8f2f2f403183 100644
--- a/include/uapi/linux/netfilter/nf_osf.h
+++ b/include/uapi/linux/netfilter/nf_osf.h
@@ -1,6 +1,8 @@
 #ifndef _NF_OSF_H
 #define _NF_OSF_H
 
+#include <linux/types.h>
+
 #define MAXGENRELEN	32
 
 #define NF_OSF_GENRE	(1 << 0)
@@ -57,12 +59,6 @@ struct nf_osf_user_finger {
 	struct nf_osf_opt	opt[MAX_IPOPTLEN];
 };
 
-struct nf_osf_finger {
-	struct rcu_head			rcu_head;
-	struct list_head		finger_entry;
-	struct nf_osf_user_finger	finger;
-};
-
 struct nf_osf_nlmsg {
 	struct nf_osf_user_finger	f;
 	struct iphdr			ip;
-- 
2.16.1
