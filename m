From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 03/05]: xt_conntrack: fix IPv4 address comparison
Date: Wed, 27 Feb 2008 14:14:23 +0100 (MET)
Message-ID: <20080227131431.26831.57401.sendpatchset@localhost.localdomain>
References: <20080227131427.26831.51195.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:53806 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756133AbYB0NOY (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 27 Feb 2008 08:14:24 -0500
In-Reply-To: <20080227131427.26831.51195.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[NETFILTER]: xt_conntrack: fix IPv4 address comparison

Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 54b4910d81a787d932d0a3237a8a15879f8eb8b8
tree c1551c39ec76a38a5ee9cb92af07e98ade545bbb
parent bcc67d744bd9df15cb4e2d590b30ddadebd5a867
author Jan Engelhardt <jengelh@computergmbh.de> Wed, 27 Feb 2008 13:23:57 +0100
committer Patrick McHardy <kaber@trash.net> Wed, 27 Feb 2008 13:23:57 +0100

 net/netfilter/xt_conntrack.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

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
