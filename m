From: KOVACS Krisztian <hidden@balabit.com>
Subject: [PATCH] netfilter: xt_socket: fix transparent match for IPv6 request sockets
Date: Tue, 20 Sep 2016 15:26:37 +0200
Message-ID: <20160920132637.221892-1-hidden@balabit.com>
Cc: Alex Badics <alex.badics@balabit.com>,
        KOVACS Krisztian <hidden@balabit.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from hq.balabit.com ([91.120.23.97]:51530 "EHLO mail.balabit.hu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754012AbcITNeK (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 20 Sep 2016 09:34:10 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The introduction of TCP_NEW_SYN_RECV state, and the addition of request
sockets to the ehash table seems to have broken the --transparent option
of the socket match for IPv6 (around commit a9407000).

Now that the socket lookup finds the TCP_NEW_SYN_RECV socket instead of the
listener, the --transparent option tries to match on the no_srccheck flag
of the request socket.

Unfortunately, that flag was only set for IPv4 sockets in tcp_v4_init_req()
by copying the transparent flag of the listener socket. This effectively
causes '-m socket --transparent' not match on the ACK packet sent by the
client in a TCP handshake.

This change adds the same code initializing no_srccheck to
tcp_v6_init_req(), rendering the above scenario working again.

Signed-off-by: Alex Badics <alex.badics@balabit.com>
Signed-off-by: KOVACS Krisztian <hidden@balabit.com>
---
 net/ipv6/tcp_ipv6.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index 94f4f89..21f2e5c 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -690,6 +690,7 @@ static void tcp_v6_init_req(struct request_sock *req,
 
 	ireq->ir_v6_rmt_addr = ipv6_hdr(skb)->saddr;
 	ireq->ir_v6_loc_addr = ipv6_hdr(skb)->daddr;
+	ireq->no_srccheck = inet_sk(sk_listener)->transparent;
 
 	/* So that link locals have meaning */
 	if (!sk_listener->sk_bound_dev_if &&
-- 
2.10.0

