From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: [PATCH 05/13] Handle TCP SYN+ACK/ACK/RST transparency
Date: Sun, 30 Sep 2007 23:46:11 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0709302345440.7130@fbirervta.pbzchgretzou.qr>
References: <20070930205141.10969.27205.stgit@nessa.odu>
 <20070930205233.10969.32752.stgit@nessa.odu>
 <Pine.LNX.4.64.0709302344450.7130@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org,
	Balazs Scheidler <bazsi@balabit.hu>,
	Toth Laszlo Attila <panther@balabit.hu>
To: KOVACS Krisztian <hidden@sch.bme.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:34309 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752765AbXI3VqM (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 30 Sep 2007 17:46:12 -0400
In-Reply-To: <Pine.LNX.4.64.0709302344450.7130@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org


>On Sep 30 2007 22:52, KOVACS Krisztian wrote:
>>
>>The TCP stack sends out SYN+ACK/ACK/RST reply packets in response to
>>incoming packets. The non-local source address check on output bites
>>us again, as replies for transparently redirected traffic won't have a
>>chance to leave the node.
>>
>>This patch selectively sets the FLOWI_FLAG_ANYSRC flag when doing
>>the route lookup for those replies. Transparent replies are enabled if
>>the listening socket has the transparent socket flag set.
>
>I needed to add extra patches to actually compile it cleanly....
>
>> include/net/ip.h                |    3 +++
>> include/net/request_sock.h      |    3 ++-
>> net/ipv4/inet_connection_sock.c |    2 ++
>> net/ipv4/ip_output.c            |    6 +++++-
>> net/ipv4/syncookies.c           |    2 ++
>> net/ipv4/tcp_ipv4.c             |   17 ++++++++++-------
>> net/ipv4/tcp_minisocks.c        |    3 ++-
>> net/ipv6/tcp_ipv6.c             |    5 +++--
>> 8 files changed, 29 insertions(+), 12 deletions(-)
>>

part 2/2.
>
>Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>
>
---
 net/ipv6/tcp_ipv6.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux-2.6.22.3/net/ipv6/tcp_ipv6.c
===================================================================
--- linux-2.6.22.3.orig/net/ipv6/tcp_ipv6.c
+++ linux-2.6.22.3/net/ipv6/tcp_ipv6.c
@@ -73,7 +73,7 @@
 static struct socket *tcp6_socket;
 
 static void	tcp_v6_send_reset(struct sock *sk, struct sk_buff *skb);
-static void	tcp_v6_reqsk_send_ack(struct sk_buff *skb, struct request_sock *req);
+static void	tcp_v6_reqsk_send_ack(struct sk_buff *skb, struct request_sock *req, int);
 static void	tcp_v6_send_check(struct sock *sk, int len,
 				  struct sk_buff *skb);
 
@@ -1195,7 +1195,7 @@ static void tcp_v6_timewait_ack(struct s
 	inet_twsk_put(tw);
 }
 
-static void tcp_v6_reqsk_send_ack(struct sk_buff *skb, struct request_sock *req)
+static void tcp_v6_reqsk_send_ack(struct sk_buff *skb, struct request_sock *req, int reply_flags)
 {
 	tcp_v6_send_ack(NULL, skb, tcp_rsk(req)->snt_isn + 1, tcp_rsk(req)->rcv_isn + 1, req->rcv_wnd, req->ts_recent);
 }
