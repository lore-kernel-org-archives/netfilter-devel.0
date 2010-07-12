From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 1/2] netfilter: nf_ct_tcp: fix flow recovery with TCP window
	tracking enabled
Date: Mon, 12 Jul 2010 18:59:53 +0200
Message-ID: <20100712165953.4026.90708.stgit@decadence>
References: <20100712165241.4026.83949.stgit@decadence>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:41175 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756083Ab0GLRAE (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 12 Jul 2010 13:00:04 -0400
In-Reply-To: <20100712165241.4026.83949.stgit@decadence>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch adds the missing bits to support the recovery of TCP flows
without disabling window tracking (aka be_liberal). To ensure a
successful recovery, we have to inject the window scale factor via
ctnetlink.

This patch has been tested with a development snapshot of conntrackd
and the new clause `TCPWindowTracking' that allows to perform strict
TCP window tracking recovery across fail-overs.

With this patch, we don't update the receiver's window until it's not
initiated. We require this to perform a successful recovery. Jozsef
confirmed in a private email that this spotted a real issue since that
should not happen.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Acked-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
---
 net/netfilter/nf_conntrack_proto_tcp.c |   10 +++++++++-
 1 files changed, 9 insertions(+), 1 deletions(-)

diff --git a/net/netfilter/nf_conntrack_proto_tcp.c b/net/netfilter/nf_conntrack_proto_tcp.c
index 802dbff..c4c885d 100644
--- a/net/netfilter/nf_conntrack_proto_tcp.c
+++ b/net/netfilter/nf_conntrack_proto_tcp.c
@@ -585,8 +585,16 @@ static bool tcp_in_window(const struct nf_conn *ct,
 			 * Let's try to use the data from the packet.
 			 */
 			sender->td_end = end;
+			win <<= sender->td_scale;
 			sender->td_maxwin = (win == 0 ? 1 : win);
 			sender->td_maxend = end + sender->td_maxwin;
+			/*
+			 * We haven't seen traffic in the other direction yet
+			 * but we have to tweak window tracking to pass III
+			 * and IV until that happens.
+			 */
+			if (receiver->td_maxwin == 0)
+				receiver->td_end = receiver->td_maxend = sack;
 		}
 	} else if (((state->state == TCP_CONNTRACK_SYN_SENT
 		     && dir == IP_CT_DIR_ORIGINAL)
@@ -680,7 +688,7 @@ static bool tcp_in_window(const struct nf_conn *ct,
 		/*
 		 * Update receiver data.
 		 */
-		if (after(end, sender->td_maxend))
+		if (receiver->td_maxwin != 0 && after(end, sender->td_maxend))
 			receiver->td_maxwin += end - sender->td_maxend;
 		if (after(sack + win, receiver->td_maxend - 1)) {
 			receiver->td_maxend = sack + win;

