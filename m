From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 10/31] netfilter: xtables: avoid BUG_ON
Date: Tue,  9 Oct 2018 01:01:04 +0200
Message-ID: <20181008230125.2330-11-pablo@netfilter.org>
References: <20181008230125.2330-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181008230125.2330-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Florian Westphal <fw@strlen.de>

I see no reason for them, label or timer cannot be NULL, and if they
were, we'll crash with null deref anyway.

For skb_header_pointer failure, just set hotdrop to true and toss
such packet.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/ipv6/netfilter/ip6t_ipv6header.c |  5 ++++-
 net/ipv6/netfilter/ip6t_rt.c         | 10 ++++++++--
 net/netfilter/xt_IDLETIMER.c         |  4 ----
 net/netfilter/xt_SECMARK.c           |  2 --
 4 files changed, 12 insertions(+), 9 deletions(-)

diff --git a/net/ipv6/netfilter/ip6t_ipv6header.c b/net/ipv6/netfilter/ip6t_ipv6header.c
index 8b147440fbdc..af737b47b9b5 100644
--- a/net/ipv6/netfilter/ip6t_ipv6header.c
+++ b/net/ipv6/netfilter/ip6t_ipv6header.c
@@ -65,7 +65,10 @@ ipv6header_mt6(const struct sk_buff *skb, struct xt_action_param *par)
 		}
 
 		hp = skb_header_pointer(skb, ptr, sizeof(_hdr), &_hdr);
-		BUG_ON(hp == NULL);
+		if (!hp) {
+			par->hotdrop = true;
+			return false;
+		}
 
 		/* Calculate the header length */
 		if (nexthdr == NEXTHDR_FRAGMENT)
diff --git a/net/ipv6/netfilter/ip6t_rt.c b/net/ipv6/netfilter/ip6t_rt.c
index 2c99b94eeca3..21bf6bf04323 100644
--- a/net/ipv6/netfilter/ip6t_rt.c
+++ b/net/ipv6/netfilter/ip6t_rt.c
@@ -137,7 +137,10 @@ static bool rt_mt6(const struct sk_buff *skb, struct xt_action_param *par)
 							sizeof(_addr),
 							&_addr);
 
-				BUG_ON(ap == NULL);
+				if (ap == NULL) {
+					par->hotdrop = true;
+					return false;
+				}
 
 				if (ipv6_addr_equal(ap, &rtinfo->addrs[i])) {
 					pr_debug("i=%d temp=%d;\n", i, temp);
@@ -166,7 +169,10 @@ static bool rt_mt6(const struct sk_buff *skb, struct xt_action_param *par)
 							+ temp * sizeof(_addr),
 							sizeof(_addr),
 							&_addr);
-				BUG_ON(ap == NULL);
+				if (ap == NULL) {
+					par->hotdrop = true;
+					return false;
+				}
 
 				if (!ipv6_addr_equal(ap, &rtinfo->addrs[temp]))
 					break;
diff --git a/net/netfilter/xt_IDLETIMER.c b/net/netfilter/xt_IDLETIMER.c
index 5ee859193783..c6acfc2d9c84 100644
--- a/net/netfilter/xt_IDLETIMER.c
+++ b/net/netfilter/xt_IDLETIMER.c
@@ -68,8 +68,6 @@ struct idletimer_tg *__idletimer_tg_find_by_label(const char *label)
 {
 	struct idletimer_tg *entry;
 
-	BUG_ON(!label);
-
 	list_for_each_entry(entry, &idletimer_tg_list, entry) {
 		if (!strcmp(label, entry->attr.attr.name))
 			return entry;
@@ -172,8 +170,6 @@ static unsigned int idletimer_tg_target(struct sk_buff *skb,
 	pr_debug("resetting timer %s, timeout period %u\n",
 		 info->label, info->timeout);
 
-	BUG_ON(!info->timer);
-
 	mod_timer(&info->timer->timer,
 		  msecs_to_jiffies(info->timeout * 1000) + jiffies);
 
diff --git a/net/netfilter/xt_SECMARK.c b/net/netfilter/xt_SECMARK.c
index 4ad5fe27e08b..f16202d26c20 100644
--- a/net/netfilter/xt_SECMARK.c
+++ b/net/netfilter/xt_SECMARK.c
@@ -35,8 +35,6 @@ secmark_tg(struct sk_buff *skb, const struct xt_action_param *par)
 	u32 secmark = 0;
 	const struct xt_secmark_target_info *info = par->targinfo;
 
-	BUG_ON(info->mode != mode);
-
 	switch (mode) {
 	case SECMARK_MODE_SEL:
 		secmark = info->secid;
-- 
2.11.0
