From: Patrick McHardy <kaber@trash.net>
Subject: netfilter: nf_conntrack_sctp: fix sparse warnings
Date: Mon, 21 Jul 2008 18:11:36 +0200
Message-ID: <4884B538.4060908@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------090706070605060709020206"
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:41465 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750881AbYGUQLl (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 21 Jul 2008 12:11:41 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multi-part message in MIME format.
--------------090706070605060709020206
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

I just queued this fix. Please *always* run sparse endianess
checks before sending netfilter patches.


--------------090706070605060709020206
Content-Type: text/plain;
 name="x"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="x"

commit dacf259f58aa88a90bbd35990a97a3ce92c4163b
Author: Patrick McHardy <kaber@trash.net>
Date:   Mon Jul 21 18:10:24 2008 +0200

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

--------------090706070605060709020206--
