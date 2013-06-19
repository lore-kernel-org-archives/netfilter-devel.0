From: Phil Oester <kernel@linuxace.com>
Subject: [PATCH] netfilter: nf_conntrack_ipv6: Plug sk_buff leak in fragment
 handling
Date: Wed, 19 Jun 2013 06:49:51 -0400
Message-ID: <20130619104950.GA1343@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="J2SCkAp4GZ/dPZZf"
Cc: pablo@netfilter.org, kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pa0-f49.google.com ([209.85.220.49]:34122 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934604Ab3FSXwi (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 19 Jun 2013 19:52:38 -0400
Received: by mail-pa0-f49.google.com with SMTP id ld11so5704288pab.36
        for <netfilter-devel@vger.kernel.org>; Wed, 19 Jun 2013 16:52:37 -0700 (PDT)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--J2SCkAp4GZ/dPZZf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

In commit 4cdd3408 ("netfilter: nf_conntrack_ipv6: improve fragmentation
handling"), an sk_buff leak was introduced when dealing with reassembled
packets by grabbing a reference to the original skb instead of the
reassembled skb.  At this point, the leak only impacted conntracks with an
associated helper.  

In commit 58a317f1 ("netfilter: ipv6: add IPv6 NAT support"), the bug was
expanded to include all reassembled packets with unconfirmed conntracks.

Fix this by grabbing a reference to the proper reassembled skb.  This closes
netfilter bugzilla #823.

Phil

Signed-off-by: Phil Oester <kernel@linuxace.com>



--J2SCkAp4GZ/dPZZf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=patch-ipv6_skb_leak

diff --git a/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c b/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c
index 97bcf2b..c9b6a6e 100644
--- a/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c
+++ b/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c
@@ -204,7 +204,7 @@ static unsigned int __ipv6_conntrack_in(struct net *net,
 		if (ct != NULL && !nf_ct_is_untracked(ct)) {
 			help = nfct_help(ct);
 			if ((help && help->helper) || !nf_ct_is_confirmed(ct)) {
-				nf_conntrack_get_reasm(skb);
+				nf_conntrack_get_reasm(reasm);
 				NF_HOOK_THRESH(NFPROTO_IPV6, hooknum, reasm,
 					       (struct net_device *)in,
 					       (struct net_device *)out,

--J2SCkAp4GZ/dPZZf--
