From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 2/3] netfilter: nf_conntrack_tcp: Fix stack out of bounds when parsing TCP options
Date: Thu, 14 Apr 2016 00:54:53 +0200
Message-ID: <1460588094-3933-3-git-send-email-pablo@netfilter.org>
References: <1460588094-3933-1-git-send-email-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:40588 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754741AbcDMWzM (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 13 Apr 2016 18:55:12 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 1C5DB73EF
	for <netfilter-devel@vger.kernel.org>; Thu, 14 Apr 2016 00:55:10 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 0DD8CC21A8
	for <netfilter-devel@vger.kernel.org>; Thu, 14 Apr 2016 00:55:10 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id F2909C21A2
	for <netfilter-devel@vger.kernel.org>; Thu, 14 Apr 2016 00:55:07 +0200 (CEST)
In-Reply-To: <1460588094-3933-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>

Baozeng Ding reported a KASAN stack out of bounds issue - it uncovered that
the TCP option parsing routines in netfilter TCP connection tracking could
read one byte out of the buffer of the TCP options.  Therefore in the patch
we check that the available data length is large enough to parse both TCP
option code and size.

Reported-by: Baozeng Ding <sploving1@gmail.com>
Tested-by: Baozeng Ding <sploving1@gmail.com>
Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
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
2.1.4

