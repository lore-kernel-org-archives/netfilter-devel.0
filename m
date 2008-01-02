From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: [PATCH 9/27] Extend nf_inet_addr with in{,6}_addr
Date: Wed, 2 Jan 2008 21:28:05 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0801022127510.14900@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0801022037090.14900@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:56920 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753688AbYABU2G (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 2 Jan 2008 15:28:06 -0500
In-Reply-To: <Pine.LNX.4.64.0801022037090.14900@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

commit 827c835ce662ee0e060b936ac4cb35a6b2e5c10a
Author: Jan Engelhardt <jengelh@computergmbh.de>
Date:   Wed Jan 2 17:54:52 2008 +0100

    [NETFILTER]: Extend nf_inet_addr with in{,6}_addr
    
    Extend union nf_inet_addr with struct in_addr and in6_addr. Useful
    because a lot of in-kernel IPv4 and IPv6 functions use
    in_addr/in6_addr.
    
    Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>

 include/linux/netfilter.h |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/include/linux/netfilter.h b/include/linux/netfilter.h
index d190d56..91ece5a 100644
--- a/include/linux/netfilter.h
+++ b/include/linux/netfilter.h
@@ -7,6 +7,8 @@
 #include <linux/skbuff.h>
 #include <linux/net.h>
 #include <linux/if.h>
+#include <linux/in.h>
+#include <linux/in6.h>
 #include <linux/wait.h>
 #include <linux/list.h>
 #endif
@@ -52,6 +54,8 @@ union nf_inet_addr {
 	u_int32_t	all[4];
 	__be32		ip;
 	__be32		ip6[4];
+	struct in_addr	in;
+	struct in6_addr	in6;
 };
 
 #ifdef __KERNEL__
