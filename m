From: =?koi8-r?B?58HX0snMz9cg6cfP0tg=?= <iggorok@yandex.ua>
Subject: Re: nf_conntrack_count is increasing
Date: Wed, 09 Dec 2015 14:23:20 +0200
Message-ID: <281761449663800@web2g.yandex.ru>
References: <3947861449660306@web9g.yandex.ru> <20151209120216.GA11515@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from forward20p.cmail.yandex.net ([77.88.31.15]:49898 "EHLO
	forward20p.cmail.yandex.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751370AbbLIMbD (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 9 Dec 2015 07:31:03 -0500
In-Reply-To: <20151209120216.GA11515@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Thank you for your reply. As far I understand nf_ct_put() needed only w=
hen I use nf_conntrack_find_get(), and doesn't needed with nf_ct_get(sk=
b, &ctinfo).
And one more question - Is it possible to clear nf_conntrack_count, aft=
er those code usage without rebooting router?=20

09.12.2015, 14:02, "Florian Westphal" <fw@strlen.de>:
> =E7=C1=D7=D2=C9=CC=CF=D7 =E9=C7=CF=D2=D8 <iggorok@yandex.ua> wrote:
>> =9A=9A=9A=9A=9A=9A=9A=9A=9Aif (!nf_ct_get_tuplepr(skb, skb_network_o=
ffset(skb), proto, &tuple)) \
>> =9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9Agoto fallback; \
>> =9A=9A=9A=9A=9A=9A=9A=9A=9Azone.id =3D NF_CT_DEFAULT_ZONE_ID; \
>> =9A=9A=9A=9A=9A=9A=9A=9A=9Azone.dir =3D NF_CT_DEFAULT_ZONE_DIR; \
>> =9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=
=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=
=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=
=9A=9A\
>> =9A=9A=9A=9A=9A=9A=9A=9A=9Athash =3D nf_conntrack_find_get(dev_net(s=
kb->dev), &zone, &tuple);\
>> =9A=9A=9A=9A=9A=9A=9A=9A=9Aif (!thash) goto fallback; \
>> =9A=9A=9A=9A=9A=9A=9A=9A=9Act =3D nf_ct_tuplehash_to_ctrack(thash); =
\
>
>> =9AIf nf_ct_get() fails to retrieve information from sk_buff, which =
is obvious on ingress, I use nf_ct_get_tuplepr() and nf_conntrack_find_=
get() like in net/sched/act_connmark.c, but I have encountered a proble=
m - after a while traffic stops forwarding with the message "nf_conntra=
ck: table is full" and conntrack -F doesn't help - nf_conntrack_count r=
emains large - about 200k. Can anyone advise me how to fix this issue?
>
> You need to nf_ct_put(ct) once you're done with ct.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
