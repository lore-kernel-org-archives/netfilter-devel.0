From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: Re: [NETFILTER 28/33]: x_tables: add port of hashlimit match for
 IPv4 and IPv6
Date: Sun, 03 Dec 2006 13:01:56 +0900 (JST)
Message-ID: <200612030401.kB341wW6018644@toshiba.co.jp>
References: <20061129020843.21082.69507.sendpatchset@localhost.localdomain>
	<20061129020926.21082.33516.sendpatchset@localhost.localdomain>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, davem@davemloft.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: kaber@trash.net
In-Reply-To: <20061129020926.21082.33516.sendpatchset@localhost.localdomain>
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


Hi, Patrick,

From: Patrick McHardy <kaber@trash.net>
Date: Wed, 29 Nov 2006 03:09:27 +0100 (MET)

> [NETFILTER]: x_tables: add port of hashlimit match for IPv4 and IPv6

ipv6_find_hdr() is in ip6_tables.c, then why about CONFIG_IP6_NF_IPTABLES ?

>From 2e05f9f301105d1b34bfda4b5826fb676b1e2c06 Mon Sep 17 00:00:00 2001
From: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>
Date: Sun, 3 Dec 2006 04:23:39 +0900
Subject: [NETFILTER]: xtables: fixes warning on compilation of hashlimit

To use ipv6_find_hdr(), IP6_NF_IPTABLES is necessary.

Signed-off-by: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>
---
 net/netfilter/xt_hashlimit.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/netfilter/xt_hashlimit.c b/net/netfilter/xt_hashlimit.c
index 46de566..604d7fe 100644
--- a/net/netfilter/xt_hashlimit.c
+++ b/net/netfilter/xt_hashlimit.c
@@ -388,7 +388,7 @@ hashlimit_init_dst(struct xt_hashlimit_h
 			return 0;
 		nexthdr = skb->nh.iph->protocol;
 		break;
-#if defined(CONFIG_IPV6) || defined(CONFIG_IPV6_MODULE)
+#if defined(CONFIG_IP6_NF_IPTABLES) || defined(CONFIG_IP6_NF_IPTABLES_MODULE)
 	case AF_INET6:
 		if (hinfo->cfg.mode & XT_HASHLIMIT_HASH_DIP)
 			memcpy(&dst->addr.ip6.dst, &skb->nh.ipv6h->daddr,
-- 
1.4.4
