From: =?UTF-8?B?QW5kZXJzIEdyYWZzdHLDtm0=?=
	<grfstrm@users.sourceforge.net>
Subject: Re: [PATCH] ipt_addrtype: Fix matching of inverted destination address
 type
Date: Sun, 03 Aug 2008 16:58:57 +0200
Message-ID: <4895C7B1.5060609@users.sourceforge.net>
References: <489381FB.8080502@users.sourceforge.net> <alpine.LNX.1.10.0808012234170.6855@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Jan Engelhardt <jengelh@medozas.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ernst.netinsight.se ([194.16.221.21]:48143 "HELO
	ernst.netinsight.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755390AbYHCO7H (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 3 Aug 2008 10:59:07 -0400
In-Reply-To: <alpine.LNX.1.10.0808012234170.6855@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[PATCH] ipt_addrtype: Fix matching of inverted destination address type

This patch fixes matching of inverted destination address type.

Signed-off-by: Anders Grafstr=C3=B6m <grfstrm@users.sourceforge.net>
---
Ok, here's the revised patch.

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

--=20
1.5.6.3

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
