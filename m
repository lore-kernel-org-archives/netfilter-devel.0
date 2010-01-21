From: Patrick McHardy <kaber@trash.net>
Subject: netfilter: ctnetlink: fix expectation mask dump
Date: Thu, 21 Jan 2010 11:19:23 +0100
Message-ID: <4B582A2B.10105@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------080102010406060503070702"
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
To: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:56641 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752974Ab0AUKTb (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 21 Jan 2010 05:19:31 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multi-part message in MIME format.
--------------080102010406060503070702
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit

I'm about to commit the following two bugfixes to nf-2.6.git.

I'll wait for a few hours in case someone wants to comment or
add an Ack.

--------------080102010406060503070702
Content-Type: text/x-patch;
 name="01.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="01.diff"

commit 0f682015a83fad33869f49b941adf682b4b4394c
Author: Patrick McHardy <kaber@trash.net>
Date:   Thu Jan 21 11:08:52 2010 +0100

    netfilter: ctnetlink: fix expectation mask dump
    
    The protocol number is not initialized, so userspace can't interpret
    the layer 4 data properly.
    
    Signed-off-by: Patrick McHardy <kaber@trash.net>

diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 79478df..5443a04 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -1446,8 +1446,9 @@ ctnetlink_exp_dump_mask(struct sk_buff *skb,
 	struct nlattr *nest_parms;
 
 	memset(&m, 0xFF, sizeof(m));
-	m.src.u.all = mask->src.u.all;
 	memcpy(&m.src.u3, &mask->src.u3, sizeof(m.src.u3));
+	m.src.u.all = mask->src.u.all;
+	m.dst.protonum = tuple->dst.protonum;
 
 	nest_parms = nla_nest_start(skb, CTA_EXPECT_MASK | NLA_F_NESTED);
 	if (!nest_parms)

--------------080102010406060503070702--
