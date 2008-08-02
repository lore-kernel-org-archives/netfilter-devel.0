From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH] ipt_addrtype: Fix matching of inverted destination
 address type
Date: Fri, 1 Aug 2008 22:35:04 -0400 (EDT)
Message-ID: <alpine.LNX.1.10.0808012234170.6855@fbirervta.pbzchgretzou.qr>
References: <489381FB.8080502@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: =?UTF-8?Q?Anders_Grafstr=C3=B6m?= <grfstrm@users.sourceforge.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:37496 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752224AbYHBCfG (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 1 Aug 2008 22:35:06 -0400
In-Reply-To: <489381FB.8080502@users.sourceforge.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Friday 2008-08-01 17:36, Anders Grafstr=C3=B6m wrote:
> +++ b/net/ipv4/netfilter/ipt_addrtype.c
> @@ -70,7 +70,7 @@ addrtype_mt_v1(const struct sk_buff *skb, const str=
uct
> net_device *in,
> 		       (info->flags & IPT_ADDRTYPE_INVERT_SOURCE);
> 	if (ret && info->dest)
> 		ret &=3D match_type(dev, iph->daddr, info->dest) ^
> -		       (info->flags & IPT_ADDRTYPE_INVERT_DEST);
> +		       (info->flags & IPT_ADDRTYPE_INVERT_DEST) >> 1;

I'd just use !!(info->flags & IPT_ADDRTYPE_INVERT_DEST);
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
