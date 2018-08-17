From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 02/15] jiffies: add utility function to calculate delta in ms
Date: Fri, 17 Aug 2018 21:38:37 +0200
Message-ID: <20180817193850.2796-3-pablo@netfilter.org>
References: <20180817193850.2796-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180817193850.2796-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Matteo Croce <mcroce@redhat.com>

add jiffies_delta_to_msecs() helper func to calculate the delta between
two times and eventually 0 if negative.

Suggested-by: Eric Dumazet <eric.dumazet@gmail.com>
Signed-off-by: Matteo Croce <mcroce@redhat.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Acked-by: Simon Horman <horms@verge.net.au>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/linux/jiffies.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/include/linux/jiffies.h b/include/linux/jiffies.h
index a27cf6652327..fa928242567d 100644
--- a/include/linux/jiffies.h
+++ b/include/linux/jiffies.h
@@ -447,6 +447,11 @@ static inline clock_t jiffies_delta_to_clock_t(long delta)
 	return jiffies_to_clock_t(max(0L, delta));
 }
 
+static inline unsigned int jiffies_delta_to_msecs(long delta)
+{
+	return jiffies_to_msecs(max(0L, delta));
+}
+
 extern unsigned long clock_t_to_jiffies(unsigned long x);
 extern u64 jiffies_64_to_clock_t(u64 x);
 extern u64 nsec_to_clock_t(u64 x);
-- 
2.11.0
