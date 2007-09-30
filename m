From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: [PATCH 05/13] Handle TCP SYN+ACK/ACK/RST transparency
Date: Sun, 30 Sep 2007 23:45:39 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0709302344450.7130@fbirervta.pbzchgretzou.qr>
References: <20070930205141.10969.27205.stgit@nessa.odu>
 <20070930205233.10969.32752.stgit@nessa.odu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org,
	Balazs Scheidler <bazsi@balabit.hu>,
	Toth Laszlo Attila <panther@balabit.hu>
To: KOVACS Krisztian <hidden@sch.bme.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:34305 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752658AbXI3Vpk (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 30 Sep 2007 17:45:40 -0400
In-Reply-To: <20070930205233.10969.32752.stgit@nessa.odu>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org


On Sep 30 2007 22:52, KOVACS Krisztian wrote:
>
>The TCP stack sends out SYN+ACK/ACK/RST reply packets in response to
>incoming packets. The non-local source address check on output bites
>us again, as replies for transparently redirected traffic won't have a
>chance to leave the node.
>
>This patch selectively sets the FLOWI_FLAG_ANYSRC flag when doing
>the route lookup for those replies. Transparent replies are enabled if
>the listening socket has the transparent socket flag set.

I needed to add extra patches to actually compile it cleanly....

> include/net/ip.h                |    3 +++
> include/net/request_sock.h      |    3 ++-
> net/ipv4/inet_connection_sock.c |    2 ++
> net/ipv4/ip_output.c            |    6 +++++-
> net/ipv4/syncookies.c           |    2 ++
> net/ipv4/tcp_ipv4.c             |   17 ++++++++++-------
> net/ipv4/tcp_minisocks.c        |    3 ++-
> net/ipv6/tcp_ipv6.c             |    5 +++--
> 8 files changed, 29 insertions(+), 12 deletions(-)
>

Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>

---
 net/dccp/dccp.h      |    3 ++-
 net/dccp/minisocks.c |    3 ++-
 2 files changed, 4 insertions(+), 2 deletions(-)

Index: linux-2.6.22.1/net/dccp/dccp.h
===================================================================
--- linux-2.6.22.1.orig/net/dccp/dccp.h
+++ linux-2.6.22.1/net/dccp/dccp.h
@@ -209,7 +209,8 @@ extern int  dccp_retransmit_skb(struct s
 
 extern void dccp_send_ack(struct sock *sk);
 extern void dccp_send_delayed_ack(struct sock *sk);
-extern void dccp_reqsk_send_ack(struct sk_buff *sk, struct request_sock *rsk);
+extern void dccp_reqsk_send_ack(struct sk_buff *sk, struct request_sock *rsk,
+	int reply_flags);
 
 extern void dccp_send_sync(struct sock *sk, const u64 seq,
 			   const enum dccp_pkt_type pkt_type);
Index: linux-2.6.22.1/net/dccp/minisocks.c
===================================================================
--- linux-2.6.22.1.orig/net/dccp/minisocks.c
+++ linux-2.6.22.1/net/dccp/minisocks.c
@@ -285,7 +285,8 @@ int dccp_child_process(struct sock *pare
 
 EXPORT_SYMBOL_GPL(dccp_child_process);
 
-void dccp_reqsk_send_ack(struct sk_buff *skb, struct request_sock *rsk)
+void dccp_reqsk_send_ack(struct sk_buff *skb, struct request_sock *rsk,
+    int reply_flags)
 {
 	DCCP_BUG("DCCP-ACK packets are never sent in LISTEN/RESPOND state");
 }
