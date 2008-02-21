From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: [NETFILTER]: xt_conntrack: fix IPv4 address comparison
Date: Thu, 21 Feb 2008 16:10:22 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0802211610030.26109@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:42817 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751539AbYBUPKX (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 21 Feb 2008 10:10:23 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

commit 58293ef3fa84c39093321a44ab11aa6cb7befbd8
Author: Jan Engelhardt <jengelh@computergmbh.de>
Date:   Thu Feb 21 15:41:05 2008 +0100

    [NETFILTER]: xt_conntrack: fix IPv4 address comparison
    
    Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>

diff --git a/net/netfilter/xt_conntrack.c b/net/netfilter/xt_conntrack.c
index dd192ac..0c50b28 100644
--- a/net/netfilter/xt_conntrack.c
+++ b/net/netfilter/xt_conntrack.c
@@ -122,7 +122,7 @@ conntrack_addrcmp(const union nf_inet_addr *kaddr,
                   const union nf_inet_addr *umask, unsigned int l3proto)
 {
 	if (l3proto == AF_INET)
-		return (kaddr->ip & umask->ip) == uaddr->ip;
+		return ((kaddr->ip ^ uaddr->ip) & umask->ip) == 0;
 	else if (l3proto == AF_INET6)
 		return ipv6_masked_addr_cmp(&kaddr->in6, &umask->in6,
 		       &uaddr->in6) == 0;

