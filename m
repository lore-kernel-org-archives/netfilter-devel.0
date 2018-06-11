From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 08/15] netfilter: ipset: List timing out entries with "timeout 1" instead of zero
Date: Mon, 11 Jun 2018 11:22:26 +0200
Message-ID: <20180611092233.3219-9-pablo@netfilter.org>
References: <20180611092233.3219-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180611092233.3219-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>

When listing sets with timeout support, there's a probability that
just timing out entries with "0" timeout value is listed/saved.
However when restoring the saved list, the zero timeout value means
permanent elelements.

The new behaviour is that timing out entries are listed with "timeout 1"
instead of zero.

Fixes netfilter bugzilla #1258.

Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
---
 include/linux/netfilter/ipset/ip_set_timeout.h | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/include/linux/netfilter/ipset/ip_set_timeout.h b/include/linux/netfilter/ipset/ip_set_timeout.h
index bfb3531fd88a..7ad8ddf9ca8a 100644
--- a/include/linux/netfilter/ipset/ip_set_timeout.h
+++ b/include/linux/netfilter/ipset/ip_set_timeout.h
@@ -65,8 +65,14 @@ ip_set_timeout_set(unsigned long *timeout, u32 value)
 static inline u32
 ip_set_timeout_get(const unsigned long *timeout)
 {
-	return *timeout == IPSET_ELEM_PERMANENT ? 0 :
-		jiffies_to_msecs(*timeout - jiffies)/MSEC_PER_SEC;
+	u32 t;
+
+	if (*timeout == IPSET_ELEM_PERMANENT)
+		return 0;
+
+	t = jiffies_to_msecs(*timeout - jiffies)/MSEC_PER_SEC;
+	/* Zero value in userspace means no timeout */
+	return t == 0 ? 1 : t;
 }
 
 #endif	/* __KERNEL__ */
-- 
2.11.0
