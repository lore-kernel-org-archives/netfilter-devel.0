From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 10/38]: Extend nf_inet_addr with in{,6}_addr
Date: Tue, 15 Jan 2008 07:19:25 +0100 (MET)
Message-ID: <20080115061920.3184.73909.sendpatchset@localhost.localdomain>
References: <20080115061907.3184.39432.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:62185 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752327AbYAOGT0 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 15 Jan 2008 01:19:26 -0500
In-Reply-To: <20080115061907.3184.39432.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[NETFILTER]: Extend nf_inet_addr with in{,6}_addr

Extend union nf_inet_addr with struct in_addr and in6_addr. Useful
because a lot of in-kernel IPv4 and IPv6 functions use
in_addr/in6_addr.

Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit eecfb07f489d73875a46d4a7c9270f92596adf88
tree bd09665b0b785bc99bf7ca4bf97d3a817c42592b
parent e1b4563007f6a292af1b18b575f5c36f998155c0
author Jan Engelhardt <jengelh@computergmbh.de> Mon, 14 Jan 2008 06:51:30 +0100
committer Patrick McHardy <kaber@trash.net> Tue, 15 Jan 2008 06:23:25 +0100

 include/linux/netfilter.h |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/include/linux/netfilter.h b/include/linux/netfilter.h
index c41f643..d74e79b 100644
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
