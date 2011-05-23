From: JP Abgrall <jpa@google.com>
Subject: Force socket error on iptables reject with icmp semantics?
Date: Mon, 23 May 2011 16:16:33 -0700
Message-ID: <BANLkTi=APDmR7c8eqVySKofXx_wMtgPGOw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:4916 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755272Ab1EWXQz (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 23 May 2011 19:16:55 -0400
Received: from kpbe12.cbf.corp.google.com (kpbe12.cbf.corp.google.com [172.25.105.76])
	by smtp-out.google.com with ESMTP id p4NNGsW8031740
	for <netfilter-devel@vger.kernel.org>; Mon, 23 May 2011 16:16:54 -0700
Received: from gyf1 (gyf1.prod.google.com [10.243.50.65])
	by kpbe12.cbf.corp.google.com with ESMTP id p4NNGreb001793
	(version=TLSv1/SSLv3 cipher=RC4-SHA bits=128 verify=NOT)
	for <netfilter-devel@vger.kernel.org>; Mon, 23 May 2011 16:16:53 -0700
Received: by gyf1 with SMTP id 1so2488710gyf.6
        for <netfilter-devel@vger.kernel.org>; Mon, 23 May 2011 16:16:53 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Before I go bug the kernel people, I'd like to know if this seems
reasonable from a netfilter perspective.

>From e8b45cfd66ccc1be0bc406fc9662f0f1e7a94283 Mon Sep 17 00:00:00 2001
From: JP Abgrall <jpa@google.com>
Date: Thu, 19 May 2011 19:30:02 -0700
Subject: [PATCH] netfilter: have ip*t REJECT set the sock err when an
icmp is to be sent

Allow the REJECT --reject-with icmp*blabla to also set the matching error
locally on the socket affected by the reject.
This allows the process to see an error as if it received it via ICMP.
It avoids the local process who's packet is rejected to have to wait
for a pseudo-eternity until some timeout kicks in.
---
 net/ipv4/netfilter/ipt_REJECT.c  |    6 ++++++
 net/ipv6/netfilter/ip6t_REJECT.c |    7 +++++++
 2 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/net/ipv4/netfilter/ipt_REJECT.c b/net/ipv4/netfilter/ipt_REJECT.c
index 43eec80..5b27d4b 100644
--- a/net/ipv4/netfilter/ipt_REJECT.c
+++ b/net/ipv4/netfilter/ipt_REJECT.c
@@ -134,6 +134,12 @@ static void send_reset(struct sk_buff *oldskb, int hook)
 static inline void send_unreach(struct sk_buff *skb_in, int code)
 {
        icmp_send(skb_in, ICMP_DEST_UNREACH, code, 0);
+       if (skb_in->sk) {
+               skb_in->sk->sk_err = icmp_err_convert[code].errno;
+               skb_in->sk->sk_error_report(skb_in->sk);
+               pr_debug("ipt_REJECT: sk_err=%d for skb=%p sk=%p\n",
+                       skb_in->sk->sk_err, skb_in, skb_in->sk);
+       }
 }

 static unsigned int
diff --git a/net/ipv6/netfilter/ip6t_REJECT.c b/net/ipv6/netfilter/ip6t_REJECT.c
index 2933396..89a5512 100644
--- a/net/ipv6/netfilter/ip6t_REJECT.c
+++ b/net/ipv6/netfilter/ip6t_REJECT.c
@@ -174,6 +174,13 @@ send_unreach(struct net *net, struct sk_buff
*skb_in, unsigned char code,
                skb_in->dev = net->loopback_dev;

        icmpv6_send(skb_in, ICMPV6_DEST_UNREACH, code, 0);
+       if (skb_in->sk) {
+               icmpv6_err_convert(ICMP_DEST_UNREACH, code,
+                                  &skb_in->sk->sk_err);
+               skb_in->sk->sk_error_report(skb_in->sk);
+               pr_debug("ip6t_REJECT: sk_err=%d for skb=%p sk=%p\n",
+                       skb_in->sk->sk_err, skb_in, skb_in->sk);
+       }
 }

 static unsigned int
--
1.7.3.1
