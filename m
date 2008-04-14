From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 31/41]: nf_conntrack_tcp: catch invalid state updates over ctnetlink
Date: Mon, 14 Apr 2008 12:17:00 +0200 (MEST)
Message-ID: <20080414101657.32717.65093.sendpatchset@localhost.localdomain>
References: <20080414101614.32717.35526.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:36337 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753855AbYDNKRD (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 14 Apr 2008 06:17:03 -0400
In-Reply-To: <20080414101614.32717.35526.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[NETFILTER]: nf_conntrack_tcp: catch invalid state updates over ctnetlink

Invalid states can cause out-of-bound memory accesses of the state table.
Also don't insist on having a new state contained in the netlink message.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 887a1a991c8d75bcbb6ccf4cbac7559ea12cda7a
tree c68aa6d733b23652e4757aa7a30e36020974e331
parent 5c5f11539fad5dacee3edb96279dda0785252b66
author Patrick McHardy <kaber@trash.net> Mon, 14 Apr 2008 12:10:55 +0200
committer Patrick McHardy <kaber@trash.net> Mon, 14 Apr 2008 12:10:55 +0200

 net/netfilter/nf_conntrack_proto_tcp.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_conntrack_proto_tcp.c b/net/netfilter/nf_conntrack_proto_tcp.c
index 6256795..57831c7 100644
--- a/net/netfilter/nf_conntrack_proto_tcp.c
+++ b/net/netfilter/nf_conntrack_proto_tcp.c
@@ -1129,11 +1129,13 @@ static int nlattr_to_tcp(struct nlattr *cda[], struct nf_conn *ct)
 	if (err < 0)
 		return err;
 
-	if (!tb[CTA_PROTOINFO_TCP_STATE])
+	if (tb[CTA_PROTOINFO_TCP_STATE] &&
+	    nla_get_u8(tb[CTA_PROTOINFO_TCP_STATE]) >= TCP_CONNTRACK_MAX)
 		return -EINVAL;
 
 	write_lock_bh(&tcp_lock);
-	ct->proto.tcp.state = nla_get_u8(tb[CTA_PROTOINFO_TCP_STATE]);
+	if (tb[CTA_PROTOINFO_TCP_STATE])
+		ct->proto.tcp.state = nla_get_u8(tb[CTA_PROTOINFO_TCP_STATE]);
 
 	if (tb[CTA_PROTOINFO_TCP_FLAGS_ORIGINAL]) {
 		struct nf_ct_tcp_flags *attr =
