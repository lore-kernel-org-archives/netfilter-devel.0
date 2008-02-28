From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 08/32]: nf_conntrack_sip: fix IPv6 address parsing
Date: Thu, 28 Feb 2008 13:00:07 +0100 (MET)
Message-ID: <20080228115958.29267.54740.sendpatchset@localhost.localdomain>
References: <20080228115948.29267.34361.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:49981 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757226AbYB1MAI (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 28 Feb 2008 07:00:08 -0500
In-Reply-To: <20080228115948.29267.34361.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[NETFILTER]: nf_conntrack_sip: fix IPv6 address parsing

IPv6 addresses are enclosed in [].

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 2d238255870c937f703d8ccbf60e7be8924e1ff2
tree 098e3653056c79ffdf5a826a6ee1eeb02720bc93
parent 21eb86674a1b26ff842b7d449c34c747c897fe90
author Patrick McHardy <kaber@trash.net> Thu, 28 Feb 2008 12:08:15 +0100
committer Patrick McHardy <kaber@trash.net> Thu, 28 Feb 2008 12:08:15 +0100

 net/netfilter/nf_conntrack_sip.c |   17 +++++++++++++----
 1 files changed, 13 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/nf_conntrack_sip.c b/net/netfilter/nf_conntrack_sip.c
index d38f953..b6848b7 100644
--- a/net/netfilter/nf_conntrack_sip.c
+++ b/net/netfilter/nf_conntrack_sip.c
@@ -252,21 +252,30 @@ static int parse_addr(const struct nf_conn *ct, const char *cp,
 {
 	const char *end;
 	int family = ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.l3num;
-	int ret = 0;
+	int ret;
 
+	memset(addr, 0, sizeof(*addr));
 	switch (family) {
 	case AF_INET:
 		ret = in4_pton(cp, limit - cp, (u8 *)&addr->ip, -1, &end);
+		if (ret == 0 || end == cp)
+			return 0;
 		break;
 	case AF_INET6:
-		ret = in6_pton(cp, limit - cp, (u8 *)&addr->ip6, -1, &end);
+		if (cp >= limit || *cp != '[')
+			return 0;
+		cp++;
+		ret = in6_pton(cp, limit - cp, (u8 *)&addr->ip6, ']', &end);
+		if (ret == 0 && end == cp)
+			return 0;
+		if (end >= limit || *end != ']')
+			return 0;
+		end++;
 		break;
 	default:
 		BUG();
 	}
 
-	if (ret == 0 || end == cp)
-		return 0;
 	if (endp)
 		*endp = end;
 	return 1;
