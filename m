From: Dash Four <mr.dash.four@googlemail.com>
Subject: [PATCH 1/4] ipset: minor variable-naming corrections
Date: Wed, 29 May 2013 01:13:21 +0100
Message-ID: <51A54821.1060903@googlemail.com>
References: <51A54267.8050402-git-send-email-mr.dash.four@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Netfilter Core Team <netfilter-devel@vger.kernel.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wi0-f173.google.com ([209.85.212.173]:53421 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932409Ab3E2AN0 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 28 May 2013 20:13:26 -0400
Received: by mail-wi0-f173.google.com with SMTP id hi5so3039562wib.0
        for <netfilter-devel@vger.kernel.org>; Tue, 28 May 2013 17:13:25 -0700 (PDT)
In-Reply-To: <51A54267.8050402-git-send-email-mr.dash.four@googlemail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch corrects minor variable-naming inconsistencies in
net/netfilter/ipset/ip_set_getport.c

Signed-off-by: Dash Four <mr.dash.four@googlemail.com>
---
  kernel/net/netfilter/ipset/ip_set_getport.c |   10 +++++-----
  1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/kernel/net/netfilter/ipset/ip_set_getport.c b/kernel/net/netfilter/ipset/ip_set_getport.c
index 279a03c..6c019b3 100644
--- a/kernel/net/netfilter/ipset/ip_set_getport.c
+++ b/kernel/net/netfilter/ipset/ip_set_getport.c
@@ -133,7 +133,7 @@ bool
  ip_set_get_ip6_port(const struct sk_buff *skb, bool src,
  		    __be16 *port, u8 *proto)
  {
-	int protoff;
+	int protooff;
  	u8 nexthdr;
  #if LINUX_VERSION_CODE >= KERNEL_VERSION(3, 3, 0)
  	__be16 frag_off;
@@ -141,15 +141,15 @@ ip_set_get_ip6_port(const struct sk_buff *skb, bool src,

  	nexthdr = ipv6_hdr(skb)->nexthdr;
  #if LINUX_VERSION_CODE >= KERNEL_VERSION(3, 3, 0)
-	protoff = ipv6_skip_exthdr(skb, sizeof(struct ipv6hdr), &nexthdr,
+	protooff = ipv6_skip_exthdr(skb, sizeof(struct ipv6hdr), &nexthdr,
  				   &frag_off);
  #else
-	protoff = ipv6_skip_exthdr(skb, sizeof(struct ipv6hdr), &nexthdr);
+	protooff = ipv6_skip_exthdr(skb, sizeof(struct ipv6hdr), &nexthdr);
  #endif
-	if (protoff < 0)
+	if (protooff < 0)
  		return false;

-	return get_port(skb, nexthdr, protoff, src, port, proto);
+	return get_port(skb, nexthdr, protooff, src, port, proto);
  }
  EXPORT_SYMBOL_GPL(ip_set_get_ip6_port);
  #endif



