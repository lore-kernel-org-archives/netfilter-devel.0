From: Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: unaligned ip header due to
 ip_route_me_harder()->pskb_expand_head()
Date: Wed, 09 Nov 2011 10:48:22 +0100
Message-ID: <1320832102.2315.10.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
References: <4EB9449D.8020701@tilera.com>
	 <1320771494.3444.8.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
	 <4EBA48F3.8040906@tilera.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: Paul Guo <ggang@tilera.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:37596 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750981Ab1KIJs1 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 9 Nov 2011 04:48:27 -0500
Received: by bke11 with SMTP id 11so1172927bke.19
        for <netfilter-devel@vger.kernel.org>; Wed, 09 Nov 2011 01:48:25 -0800 (PST)
In-Reply-To: <4EBA48F3.8040906@tilera.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Le mercredi 09 novembre 2011 =C3=A0 17:33 +0800, Paul Guo a =C3=A9crit =
:

> > or=20
> >=20
> > pskb_expand_head(skb, HH_DATA_ALIGN(hh_len - skb_headroom(skb)), 0,=
 GFP_ATOMIC))
>=20
> Thanks. This looks better.

Could you submit an official patch ?

Thanks !



--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
