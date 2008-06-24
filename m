From: Patrick McHardy <kaber@trash.net>
Subject: netfilter: ip6table_mangle: don't reroute in LOCAL_IN
Date: Tue, 24 Jun 2008 14:07:13 +0200
Message-ID: <4860E371.7090401@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------060606060208080805020303"
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: "David S. Miller" <davem@davemloft.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:49500 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751810AbYFXMHT (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 24 Jun 2008 08:07:19 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multi-part message in MIME format.
--------------060606060208080805020303
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

Attached is a single fix for 2.6.26 that corrects the LOCAL_IN
hook function in ip6table_mangle. Please apply, thanks.


--------------060606060208080805020303
Content-Type: text/x-diff;
 name="01.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="01.diff"

commit 0a9d392f66ab6d4bf0efbfa1b22330548b931498
Author: Patrick McHardy <kaber@trash.net>
Date:   Tue Jun 24 13:58:23 2008 +0200

    netfilter: ip6table_mangle: don't reroute in LOCAL_IN
    
    Rerouting should only happen in LOCAL_OUT, in INPUT its useless
    since the packet has already chosen its final destination.
    
    Noticed by Alexey Dobriyan <adobriyan@gmail.com>.
    
    Signed-off-by: Patrick McHardy <kaber@trash.net>

diff --git a/net/ipv6/netfilter/ip6table_mangle.c b/net/ipv6/netfilter/ip6table_mangle.c
index 27a5e8b..f405cea 100644
--- a/net/ipv6/netfilter/ip6table_mangle.c
+++ b/net/ipv6/netfilter/ip6table_mangle.c
@@ -129,7 +129,7 @@ static struct nf_hook_ops ip6t_ops[] __read_mostly = {
 		.priority	= NF_IP6_PRI_MANGLE,
 	},
 	{
-		.hook		= ip6t_local_hook,
+		.hook		= ip6t_route_hook,
 		.owner		= THIS_MODULE,
 		.pf		= PF_INET6,
 		.hooknum	= NF_INET_LOCAL_IN,

--------------060606060208080805020303--
