From: Patrick McHardy <kaber@trash.net>
Subject: netfilter 02/06: ipt_addrtype: fix matching of inverted destination address type
Date: Mon, 18 Aug 2008 18:51:51 +0200 (MEST)
Message-ID: <20080818165150.18978.60746.sendpatchset@localhost.localdomain>
References: <20080818165147.18978.92208.sendpatchset@localhost.localdomain>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:59345 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753565AbYHRQvw (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 18 Aug 2008 12:51:52 -0400
In-Reply-To: <20080818165147.18978.92208.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

netfilter: ipt_addrtype: Fix matching of inverted destination address t=
ype

This patch fixes matching of inverted destination address type.

Signed-off-by: Anders Grafstr=F6m <grfstrm@users.sourceforge.net>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 132fbda27191848d809ac4c4e5841581371aafd8
tree 173c192bca62e2e89ba6a2e54fa85e6d2aa69b02
parent 4f5e031a4fb1872eb30d473fef4706eddf58aa8f
author Anders Grafstr=F6m <grfstrm@users.sourceforge.net> Mon, 18 Aug 2=
008 13:17:03 +0200
committer Patrick McHardy <kaber@trash.net> Mon, 18 Aug 2008 13:17:03 +=
0200

 net/ipv4/netfilter/ipt_addrtype.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/ipv4/netfilter/ipt_addrtype.c b/net/ipv4/netfilter/ipt=
_addrtype.c
index 49587a4..462a22c 100644
--- a/net/ipv4/netfilter/ipt_addrtype.c
+++ b/net/ipv4/netfilter/ipt_addrtype.c
@@ -70,7 +70,7 @@ addrtype_mt_v1(const struct sk_buff *skb, const struc=
t net_device *in,
 		       (info->flags & IPT_ADDRTYPE_INVERT_SOURCE);
 	if (ret && info->dest)
 		ret &=3D match_type(dev, iph->daddr, info->dest) ^
-		       (info->flags & IPT_ADDRTYPE_INVERT_DEST);
+		       !!(info->flags & IPT_ADDRTYPE_INVERT_DEST);
 	return ret;
 }
=20
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
