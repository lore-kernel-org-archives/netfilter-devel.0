From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 07/07]: Use __u32 in struct nf_inet_addr
Date: Tue, 19 Feb 2008 17:25:53 +0100 (MET)
Message-ID: <20080219162541.13631.48514.sendpatchset@localhost.localdomain>
References: <20080219162532.13631.71318.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:50478 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753189AbYBSQZy (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 19 Feb 2008 11:25:54 -0500
In-Reply-To: <20080219162532.13631.71318.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[NETFILTER]: Use __u32 in struct nf_inet_addr

As reported by David Woodhouse <dwmw2@infradead.org>, using u_int32_t in
struct nf_inet_addr breaks the busybox build. Fix by using __u32.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 4f4e9be33da8cc1a297c4d7ef51c1fa1effcbace
tree a856969ae8edeebca7c8018e18e4304cd198e529
parent 5a090319a35aac1052102d97c431230d3140daf1
author Patrick McHardy <kaber@trash.net> Tue, 19 Feb 2008 17:15:29 +0100
committer Patrick McHardy <kaber@trash.net> Tue, 19 Feb 2008 17:15:29 +0100

 include/linux/netfilter.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/netfilter.h b/include/linux/netfilter.h
index d74e79b..b74b615 100644
--- a/include/linux/netfilter.h
+++ b/include/linux/netfilter.h
@@ -51,7 +51,7 @@ enum nf_inet_hooks {
 };
 
 union nf_inet_addr {
-	u_int32_t	all[4];
+	__u32		all[4];
 	__be32		ip;
 	__be32		ip6[4];
 	struct in_addr	in;
