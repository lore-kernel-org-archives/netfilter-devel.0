From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 01/02]: nf_conntrack_tcp: fix connection reopening fix
Date: Thu, 18 Oct 2007 12:12:24 +0200 (MEST)
Message-ID: <20071018101200.28424.26306.sendpatchset@localhost.localdomain>
References: <20071018101159.28424.36079.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:33482 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755282AbXJRKMZ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 18 Oct 2007 06:12:25 -0400
In-Reply-To: <20071018101159.28424.36079.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

[NETFILTER]: nf_conntrack_tcp: fix connection reopening fix

Setting the last_dir parameter was missing from the previous one.

Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Tested-by: Krzysztof Piotr Oledzki <ole@ans.pl>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 9768fafed7a5588757d972b2f511cb17a874f496
tree f0a8526f52a503a1cff944c9dc3012e05763310a
parent d85714d81cc0408daddb68c10f7fd69eafe7c213
author Jozsef Kadlecsik <kadlec@blackhole.kfki.hu> Thu, 18 Oct 2007 12:09:51 +0200
committer Patrick McHardy <kaber@trash.net> Thu, 18 Oct 2007 12:09:51 +0200

 net/netfilter/nf_conntrack_proto_tcp.c |   11 +++++++----
 1 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/nf_conntrack_proto_tcp.c b/net/netfilter/nf_conntrack_proto_tcp.c
index c707534..4dc23ab 100644
--- a/net/netfilter/nf_conntrack_proto_tcp.c
+++ b/net/netfilter/nf_conntrack_proto_tcp.c
@@ -834,10 +834,12 @@ static int tcp_packet(struct nf_conn *conntrack,
 	case TCP_CONNTRACK_SYN_SENT:
 		if (old_state < TCP_CONNTRACK_TIME_WAIT)
 			break;
-		if (conntrack->proto.tcp.seen[!dir].flags &
-			IP_CT_TCP_FLAG_CLOSE_INIT) {
-			/* Attempt to reopen a closed connection.
-			* Delete this connection and look up again. */
+		if ((conntrack->proto.tcp.seen[!dir].flags &
+			IP_CT_TCP_FLAG_CLOSE_INIT)
+		    || (conntrack->proto.tcp.last_dir == dir
+		        && conntrack->proto.tcp.last_index == TCP_RST_SET)) {
+			/* Attempt to reopen a closed/aborted connection.
+			 * Delete this connection and look up again. */
 			write_unlock_bh(&tcp_lock);
 			if (del_timer(&conntrack->timeout))
 				conntrack->timeout.function((unsigned long)
@@ -925,6 +927,7 @@ static int tcp_packet(struct nf_conn *conntrack,
      in_window:
 	/* From now on we have got in-window packets */
 	conntrack->proto.tcp.last_index = index;
+	conntrack->proto.tcp.last_dir = dir;
 
 	pr_debug("tcp_conntracks: ");
 	NF_CT_DUMP_TUPLE(tuple);
