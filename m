From: Patrick McHardy <kaber@trash.net>
Subject: netfilter 08/08: nf_conntrack_sctp: fix sparse warnings
Date: Mon, 21 Jul 2008 18:17:33 +0200 (MEST)
Message-ID: <20080721161733.28572.21079.sendpatchset@localhost.localdomain>
References: <20080721161722.28572.97957.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:41643 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751783AbYGUQRf (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 21 Jul 2008 12:17:35 -0400
In-Reply-To: <20080721161722.28572.97957.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

netfilter: nf_conntrack_sctp: fix sparse warnings

Introduced by a258860e (netfilter: ctnetlink: add full support for SCTP to ctnetlink):

net/netfilter/nf_conntrack_proto_sctp.c:483:2: warning: cast from restricted type
net/netfilter/nf_conntrack_proto_sctp.c:483:2: warning: incorrect type in argument 1 (different base types)
net/netfilter/nf_conntrack_proto_sctp.c:483:2:    expected unsigned int [unsigned] [usertype] x
net/netfilter/nf_conntrack_proto_sctp.c:483:2:    got restricted unsigned int const <noident>
net/netfilter/nf_conntrack_proto_sctp.c:483:2: warning: cast from restricted type
net/netfilter/nf_conntrack_proto_sctp.c:483:2: warning: cast from restricted type
net/netfilter/nf_conntrack_proto_sctp.c:483:2: warning: cast from restricted type
net/netfilter/nf_conntrack_proto_sctp.c:483:2: warning: cast from restricted type
net/netfilter/nf_conntrack_proto_sctp.c:487:2: warning: cast from restricted type
net/netfilter/nf_conntrack_proto_sctp.c:487:2: warning: incorrect type in argument 1 (different base types)
net/netfilter/nf_conntrack_proto_sctp.c:487:2:    expected unsigned int [unsigned] [usertype] x
net/netfilter/nf_conntrack_proto_sctp.c:487:2:    got restricted unsigned int const <noident>
net/netfilter/nf_conntrack_proto_sctp.c:487:2: warning: cast from restricted type
net/netfilter/nf_conntrack_proto_sctp.c:487:2: warning: cast from restricted type
net/netfilter/nf_conntrack_proto_sctp.c:487:2: warning: cast from restricted type
net/netfilter/nf_conntrack_proto_sctp.c:487:2: warning: cast from restricted type
net/netfilter/nf_conntrack_proto_sctp.c:532:42: warning: incorrect type in assignment (different base types)
net/netfilter/nf_conntrack_proto_sctp.c:532:42:    expected restricted unsigned int <noident>
net/netfilter/nf_conntrack_proto_sctp.c:532:42:    got unsigned int
net/netfilter/nf_conntrack_proto_sctp.c:534:39: warning: incorrect type in assignment (different base types)
net/netfilter/nf_conntrack_proto_sctp.c:534:39:    expected restricted unsigned int <noident>
net/netfilter/nf_conntrack_proto_sctp.c:534:39:    got unsigned int

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit dacf259f58aa88a90bbd35990a97a3ce92c4163b
tree 9e4cd810d7db2a492d57672507b683d9a25ab723
parent 414c518048d54280034629edba63b5930cae945c
author Patrick McHardy <kaber@trash.net> Mon, 21 Jul 2008 18:10:24 +0200
committer Patrick McHardy <kaber@trash.net> Mon, 21 Jul 2008 18:10:24 +0200

 net/netfilter/nf_conntrack_proto_sctp.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/nf_conntrack_proto_sctp.c b/net/netfilter/nf_conntrack_proto_sctp.c
index 41183a4..30aa5b9 100644
--- a/net/netfilter/nf_conntrack_proto_sctp.c
+++ b/net/netfilter/nf_conntrack_proto_sctp.c
@@ -482,11 +482,11 @@ static int sctp_to_nlattr(struct sk_buff *skb, struct nlattr *nla,
 
 	NLA_PUT_BE32(skb,
 		     CTA_PROTOINFO_SCTP_VTAG_ORIGINAL,
-		     htonl(ct->proto.sctp.vtag[IP_CT_DIR_ORIGINAL]));
+		     ct->proto.sctp.vtag[IP_CT_DIR_ORIGINAL]);
 
 	NLA_PUT_BE32(skb,
 		     CTA_PROTOINFO_SCTP_VTAG_REPLY,
-		     htonl(ct->proto.sctp.vtag[IP_CT_DIR_REPLY]));
+		     ct->proto.sctp.vtag[IP_CT_DIR_REPLY]);
 
 	read_unlock_bh(&sctp_lock);
 
@@ -530,9 +530,9 @@ static int nlattr_to_sctp(struct nlattr *cda[], struct nf_conn *ct)
 	write_lock_bh(&sctp_lock);
 	ct->proto.sctp.state = nla_get_u8(tb[CTA_PROTOINFO_SCTP_STATE]);
 	ct->proto.sctp.vtag[IP_CT_DIR_ORIGINAL] =
-		ntohl(nla_get_be32(tb[CTA_PROTOINFO_SCTP_VTAG_ORIGINAL]));
+		nla_get_be32(tb[CTA_PROTOINFO_SCTP_VTAG_ORIGINAL]);
 	ct->proto.sctp.vtag[IP_CT_DIR_REPLY] =
-		ntohl(nla_get_be32(tb[CTA_PROTOINFO_SCTP_VTAG_REPLY]));
+		nla_get_be32(tb[CTA_PROTOINFO_SCTP_VTAG_REPLY]);
 	write_unlock_bh(&sctp_lock);
 
 	return 0;
