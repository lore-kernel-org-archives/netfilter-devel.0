From: =?ISO-8859-1?Q?Anders_Grafstr=F6m?= <grfstrm@users.sourceforge.net>
Subject: [PATCH] ipt_addrtype: Fix matching of inverted destination address
 type
Date: Fri, 01 Aug 2008 23:36:59 +0200
Message-ID: <489381FB.8080502@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ernst.netinsight.se ([194.16.221.21]:14638 "HELO
	ernst.netinsight.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755996AbYHAVrL (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 1 Aug 2008 17:47:11 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch fixes matching of inverted destination address type.

Signed-off-by: Anders Grafstr=F6m <grfstrm@users.sourceforge.net>
---
  net/ipv4/netfilter/ipt_addrtype.c |    2 +-
  1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/ipv4/netfilter/ipt_addrtype.c b/net/ipv4/netfilter/ipt=
_addrtype.c
index 49587a4..1f7e005 100644
--- a/net/ipv4/netfilter/ipt_addrtype.c
+++ b/net/ipv4/netfilter/ipt_addrtype.c
@@ -70,7 +70,7 @@ addrtype_mt_v1(const struct sk_buff *skb, const struc=
t net_device *in,
  		       (info->flags & IPT_ADDRTYPE_INVERT_SOURCE);
  	if (ret && info->dest)
  		ret &=3D match_type(dev, iph->daddr, info->dest) ^
-		       (info->flags & IPT_ADDRTYPE_INVERT_DEST);
+		       (info->flags & IPT_ADDRTYPE_INVERT_DEST) >> 1;
  	return ret;
  }

--=20
1.5.6.3
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
