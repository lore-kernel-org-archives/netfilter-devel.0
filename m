From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 08/39]: ip6table_mangle: reroute when nfmark changes in
	NF_IP6_LOCAL_OUT
Date: Wed, 20 Sep 2006 10:24:01 +0200 (MEST)
Message-ID: <20060920082453.14636.8024.sendpatchset@localhost.localdomain>
References: <20060920082442.14636.6806.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: davem@davemloft.net
In-Reply-To: <20060920082442.14636.6806.sendpatchset@localhost.localdomain>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

[NETFILTER]: ip6table_mangle: reroute when nfmark changes in NF_IP6_LOCAL_OUT

Now that IPv6 supports policy routing we need to reroute in NF_IP6_LOCAL_OUT
when the mark value changes.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 488390a83da9b1bee0eabf6bf31d9fd1bca88b7d
tree f5b9e7754ec69ded1930ced6a901f2ec5250e745
parent 9bab1a93f9739bf8346f256181e971dabf0ea775
author Patrick McHardy <kaber@trash.net> Wed, 20 Sep 2006 09:28:22 +0200
committer Patrick McHardy <kaber@trash.net> Wed, 20 Sep 2006 09:28:22 +0200

 include/linux/netfilter_ipv6.h       |    1 +
 include/net/ip6_route.h              |    2 --
 net/ipv6/netfilter/ip6table_mangle.c |    8 ++------
 3 files changed, 3 insertions(+), 8 deletions(-)

diff --git a/include/linux/netfilter_ipv6.h b/include/linux/netfilter_ipv6.h
index 52a7b9e..d97e268 100644
--- a/include/linux/netfilter_ipv6.h
+++ b/include/linux/netfilter_ipv6.h
@@ -73,6 +73,7 @@ enum nf_ip6_hook_priorities {
 };
 
 #ifdef CONFIG_NETFILTER
+extern int ip6_route_me_harder(struct sk_buff *skb);
 extern unsigned int nf_ip6_checksum(struct sk_buff *skb, unsigned int hook,
 				    unsigned int dataoff, u_int8_t protocol);
 
diff --git a/include/net/ip6_route.h b/include/net/ip6_route.h
index 2979095..6ca6b71 100644
--- a/include/net/ip6_route.h
+++ b/include/net/ip6_route.h
@@ -57,8 +57,6 @@ extern void			ip6_route_input(struct sk_
 extern struct dst_entry *	ip6_route_output(struct sock *sk,
 						 struct flowi *fl);
 
-extern int			ip6_route_me_harder(struct sk_buff *skb);
-
 extern void			ip6_route_init(void);
 extern void			ip6_route_cleanup(void);
 
diff --git a/net/ipv6/netfilter/ip6table_mangle.c b/net/ipv6/netfilter/ip6table_mangle.c
index 32db04f..386ea26 100644
--- a/net/ipv6/netfilter/ip6table_mangle.c
+++ b/net/ipv6/netfilter/ip6table_mangle.c
@@ -180,12 +180,8 @@ #endif
 		&& (memcmp(&(*pskb)->nh.ipv6h->saddr, &saddr, sizeof(saddr))
 		    || memcmp(&(*pskb)->nh.ipv6h->daddr, &daddr, sizeof(daddr))
 		    || (*pskb)->nfmark != nfmark
-		    || (*pskb)->nh.ipv6h->hop_limit != hop_limit)) {
-
-		/* something which could affect routing has changed */
-
-		DEBUGP("ip6table_mangle: we'd need to re-route a packet\n");
-	}
+		    || (*pskb)->nh.ipv6h->hop_limit != hop_limit))
+		return ip6_route_me_harder(*pskb) == 0 ? ret : NF_DROP;
 
 	return ret;
 }
