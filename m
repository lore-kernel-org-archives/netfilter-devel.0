From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 09/15] netfilter: ipset: Limit max timeout value
Date: Mon, 11 Jun 2018 11:22:27 +0200
Message-ID: <20180611092233.3219-10-pablo@netfilter.org>
References: <20180611092233.3219-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180611092233.3219-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>

Due to the negative value condition in msecs_to_jiffies(), the real
max possible timeout value must be set to (UINT_MAX >> 1)/MSEC_PER_SEC.

Neutron Soutmun proposed the proper fix, but an insufficient one was
applied, see https://patchwork.ozlabs.org/patch/400405/.

Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
---
 include/linux/netfilter/ipset/ip_set_timeout.h | 10 ++++++----
 net/netfilter/xt_set.c                         |  8 ++++----
 2 files changed, 10 insertions(+), 8 deletions(-)

diff --git a/include/linux/netfilter/ipset/ip_set_timeout.h b/include/linux/netfilter/ipset/ip_set_timeout.h
index 7ad8ddf9ca8a..8ce271e187b6 100644
--- a/include/linux/netfilter/ipset/ip_set_timeout.h
+++ b/include/linux/netfilter/ipset/ip_set_timeout.h
@@ -23,6 +23,9 @@
 /* Set is defined with timeout support: timeout value may be 0 */
 #define IPSET_NO_TIMEOUT	UINT_MAX
 
+/* Max timeout value, see msecs_to_jiffies() in jiffies.h */
+#define IPSET_MAX_TIMEOUT	(UINT_MAX >> 1)/MSEC_PER_SEC
+
 #define ip_set_adt_opt_timeout(opt, set)	\
 ((opt)->ext.timeout != IPSET_NO_TIMEOUT ? (opt)->ext.timeout : (set)->timeout)
 
@@ -32,11 +35,10 @@ ip_set_timeout_uget(struct nlattr *tb)
 	unsigned int timeout = ip_set_get_h32(tb);
 
 	/* Normalize to fit into jiffies */
-	if (timeout > UINT_MAX/MSEC_PER_SEC)
-		timeout = UINT_MAX/MSEC_PER_SEC;
+	if (timeout > IPSET_MAX_TIMEOUT)
+		timeout = IPSET_MAX_TIMEOUT;
 
-	/* Userspace supplied TIMEOUT parameter: adjust crazy size */
-	return timeout == IPSET_NO_TIMEOUT ? IPSET_NO_TIMEOUT - 1 : timeout;
+	return timeout;
 }
 
 static inline bool
diff --git a/net/netfilter/xt_set.c b/net/netfilter/xt_set.c
index 07af7dbf7a30..bf2890b13212 100644
--- a/net/netfilter/xt_set.c
+++ b/net/netfilter/xt_set.c
@@ -372,8 +372,8 @@ set_target_v2(struct sk_buff *skb, const struct xt_action_param *par)
 
 	/* Normalize to fit into jiffies */
 	if (add_opt.ext.timeout != IPSET_NO_TIMEOUT &&
-	    add_opt.ext.timeout > UINT_MAX / MSEC_PER_SEC)
-		add_opt.ext.timeout = UINT_MAX / MSEC_PER_SEC;
+	    add_opt.ext.timeout > IPSET_MAX_TIMEOUT)
+		add_opt.ext.timeout = IPSET_MAX_TIMEOUT;
 	if (info->add_set.index != IPSET_INVALID_ID)
 		ip_set_add(info->add_set.index, skb, par, &add_opt);
 	if (info->del_set.index != IPSET_INVALID_ID)
@@ -407,8 +407,8 @@ set_target_v3(struct sk_buff *skb, const struct xt_action_param *par)
 
 	/* Normalize to fit into jiffies */
 	if (add_opt.ext.timeout != IPSET_NO_TIMEOUT &&
-	    add_opt.ext.timeout > UINT_MAX / MSEC_PER_SEC)
-		add_opt.ext.timeout = UINT_MAX / MSEC_PER_SEC;
+	    add_opt.ext.timeout > IPSET_MAX_TIMEOUT)
+		add_opt.ext.timeout = IPSET_MAX_TIMEOUT;
 	if (info->add_set.index != IPSET_INVALID_ID)
 		ip_set_add(info->add_set.index, skb, par, &add_opt);
 	if (info->del_set.index != IPSET_INVALID_ID)
-- 
2.11.0
