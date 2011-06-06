From: pablo@netfilter.org
Subject: [PATCH 7/7] netfilter: use unsigned variables for packet lengths in ip[6]_queue.
Date: Mon,  6 Jun 2011 02:11:40 +0200
Message-ID: <1307319100-21827-8-git-send-email-pablo@netfilter.org>
References: <1307319100-21827-1-git-send-email-pablo@netfilter.org>
Cc: davem@davemloft.net, Dave Jones <davej@redhat.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:54955 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752392Ab1FFAMI (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 5 Jun 2011 20:12:08 -0400
In-Reply-To: <1307319100-21827-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Dave Jones <davej@redhat.com>

Netlink message lengths can't be negative, so use unsigned variables.

Signed-off-by: Dave Jones <davej@redhat.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/ipv4/netfilter/ip_queue.c  |    3 ++-
 net/ipv6/netfilter/ip6_queue.c |    3 ++-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/netfilter/ip_queue.c b/net/ipv4/netfilter/ip_queue.c
index d2c1311..f7f9bd7 100644
--- a/net/ipv4/netfilter/ip_queue.c
+++ b/net/ipv4/netfilter/ip_queue.c
@@ -402,7 +402,8 @@ ipq_dev_drop(int ifindex)
 static inline void
 __ipq_rcv_skb(struct sk_buff *skb)
 {
-	int status, type, pid, flags, nlmsglen, skblen;
+	int status, type, pid, flags;
+	unsigned int nlmsglen, skblen;
 	struct nlmsghdr *nlh;
 
 	skblen = skb->len;
diff --git a/net/ipv6/netfilter/ip6_queue.c b/net/ipv6/netfilter/ip6_queue.c
index 413ab07..065fe40 100644
--- a/net/ipv6/netfilter/ip6_queue.c
+++ b/net/ipv6/netfilter/ip6_queue.c
@@ -403,7 +403,8 @@ ipq_dev_drop(int ifindex)
 static inline void
 __ipq_rcv_skb(struct sk_buff *skb)
 {
-	int status, type, pid, flags, nlmsglen, skblen;
+	int status, type, pid, flags;
+	unsigned int nlmsglen, skblen;
 	struct nlmsghdr *nlh;
 
 	skblen = skb->len;
-- 
1.7.2.5

