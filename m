From: Florian Westphal <fw@strlen.de>
Subject: Re: nf_conntrack_count is increasing
Date: Wed, 9 Dec 2015 13:02:16 +0100
Message-ID: <20151209120216.GA11515@breakpoint.cc>
References: <3947861449660306@web9g.yandex.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: =?utf-8?B?0JPQsNCy0YDQuNC70L7QsiDQmNCz0L7RgNGM?=
	<iggorok@yandex.ua>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:44261 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753841AbbLIMCS (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 9 Dec 2015 07:02:18 -0500
Content-Disposition: inline
In-Reply-To: <3947861449660306@web9g.yandex.ru>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

=D0=93=D0=B0=D0=B2=D1=80=D0=B8=D0=BB=D0=BE=D0=B2 =D0=98=D0=B3=D0=BE=D1=80=
=D1=8C <iggorok@yandex.ua> wrote:
> 	if (!nf_ct_get_tuplepr(skb, skb_network_offset(skb), proto, &tuple))=
 \
>                 goto fallback;						\
>         zone.id =3D NF_CT_DEFAULT_ZONE_ID;				\
>         zone.dir =3D NF_CT_DEFAULT_ZONE_DIR;				\
> 									\
>         thash =3D nf_conntrack_find_get(dev_net(skb->dev), &zone, &tu=
ple);\
>         if (!thash) goto fallback;					\
>         ct =3D nf_ct_tuplehash_to_ctrack(thash);				\

> If nf_ct_get() fails to retrieve information from sk_buff, which is o=
bvious on ingress, I use nf_ct_get_tuplepr() and nf_conntrack_find_get(=
) like in net/sched/act_connmark.c, but I have encountered a problem - =
after a while traffic stops forwarding with the message "nf_conntrack: =
table is full" and conntrack -F doesn't help - nf_conntrack_count remai=
ns large - about 200k. Can anyone advise me how to fix this issue?

You need to nf_ct_put(ct) once you're done with ct.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
