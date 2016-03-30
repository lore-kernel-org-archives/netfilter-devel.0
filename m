From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [PATCH 1/1] net: netfilter: Fix stack out of bounds when parsing TCP options
Date: Wed, 30 Mar 2016 11:34:35 +0200
Message-ID: <1459330475-2220-2-git-send-email-kadlec@blackhole.kfki.hu>
References: <1459330475-2220-1-git-send-email-kadlec@blackhole.kfki.hu>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp0.kfki.hu ([148.6.0.25]:44827 "EHLO smtp0.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750954AbcC3Jdn (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 30 Mar 2016 05:33:43 -0400
In-Reply-To: <1459330475-2220-1-git-send-email-kadlec@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Baozeng Ding reported a KASAN stack out of bounds issue - it uncovered that
the TCP option parsing routines in netfilter TCP connection tracking could
read one byte out of the buffer of the TCP options.  Therefore in the patch
we check that the available data length is large enough to parse both TCP
option code and size.

Reported-by: Baozeng Ding <sploving1@gmail.com>
Tested-by: Baozeng Ding <sploving1@gmail.com>
Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
---
 net/netfilter/nf_conntrack_proto_tcp.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/netfilter/nf_conntrack_proto_tcp.c b/net/netfilter/nf_conntrack_proto_tcp.c
index 278f3b9..7cc1d9c 100644
--- a/net/netfilter/nf_conntrack_proto_tcp.c
+++ b/net/netfilter/nf_conntrack_proto_tcp.c
@@ -410,6 +410,8 @@ static void tcp_options(const struct sk_buff *skb,
 			length--;
 			continue;
 		default:
+			if (length < 2)
+				return;
 			opsize=*ptr++;
 			if (opsize < 2) /* "silly options" */
 				return;
@@ -470,6 +472,8 @@ static void tcp_sack(const struct sk_buff *skb, unsigned int dataoff,
 			length--;
 			continue;
 		default:
+			if (length < 2)
+				return;
 			opsize = *ptr++;
 			if (opsize < 2) /* "silly options" */
 				return;
-- 
1.8.5.1

