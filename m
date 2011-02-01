From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH] netfilter: ctnetlink: fix ctnetlink_parse_tuple() warning
Date: Tue, 01 Feb 2011 17:51:21 +0100
Message-ID: <4D483A09.8000202@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------040405000401070505000001"
To: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:45692 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751432Ab1BAQvY (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 1 Feb 2011 11:51:24 -0500
Received: from x100e.localnet (localhost [127.0.0.1])
	by stinky.trash.net (Postfix) with ESMTP id 0F0D1B2C43
	for <netfilter-devel@vger.kernel.org>; Tue,  1 Feb 2011 17:51:21 +0100 (MET)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multi-part message in MIME format.
--------------040405000401070505000001
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit


--------------040405000401070505000001
Content-Type: text/plain;
 name="x"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="x"

commit a00f1f3686d6a062b5295c092a9dff059adbdbf5
Author: Patrick McHardy <kaber@trash.net>
Date:   Tue Feb 1 17:26:37 2011 +0100

    netfilter: ctnetlink: fix ctnetlink_parse_tuple() warning
    
    net/netfilter/nf_conntrack_netlink.c: In function 'ctnetlink_parse_tuple':
    net/netfilter/nf_conntrack_netlink.c:832:11: warning: comparison between 'enum ctattr_tuple' and 'enum ctattr_type'
    
    Use ctattr_type for the 'type' parameter since that's the type of all attributes
    passed to this function.
    
    Signed-off-by: Patrick McHardy <kaber@trash.net>

diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 61c7394..cb1a819 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -803,7 +803,7 @@ static const struct nla_policy tuple_nla_policy[CTA_TUPLE_MAX+1] = {
 static int
 ctnetlink_parse_tuple(const struct nlattr * const cda[],
 		      struct nf_conntrack_tuple *tuple,
-		      enum ctattr_tuple type, u_int8_t l3num)
+		      enum ctattr_type type, u_int8_t l3num)
 {
 	struct nlattr *tb[CTA_TUPLE_MAX+1];
 	int err;

--------------040405000401070505000001--
