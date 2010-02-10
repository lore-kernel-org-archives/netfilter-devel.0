From: Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: ct: will ct be stalled in rcu read critical section?
Date: Wed, 10 Feb 2010 08:43:11 +0100
Message-ID: <1265787791.2871.17.camel@edumazet-laptop>
References: <412e6f7f1002091916h5663057bq56b81d6ceec478a7@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Changli Gao <xiaosuo@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-bw0-f219.google.com ([209.85.218.219]:58869 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750749Ab0BJHnS (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 10 Feb 2010 02:43:18 -0500
Received: by bwz19 with SMTP id 19so1633110bwz.28
        for <netfilter-devel@vger.kernel.org>; Tue, 09 Feb 2010 23:43:16 -0800 (PST)
In-Reply-To: <412e6f7f1002091916h5663057bq56b81d6ceec478a7@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Le mercredi 10 f=C3=A9vrier 2010 =C3=A0 11:16 +0800, Changli Gao a =C3=A9=
crit :
> in http://git.kernel.org/?p=3Dlinux/kernel/git/next/linux-next.git;a=3D=
commitdiff;h=3Dea781f197d6a835cbb93a0bf88ee1696296ed8aa#patch6
> , I don't understand the patch bellow.
>=20
> @@ -275,11 +291,18 @@ nf_conntrack_find_get(struct net *net, const
> struct nf_conntrack_tuple *tuple)
>         struct nf_conn *ct;
>=20
>         rcu_read_lock();
> +begin:
>         h =3D __nf_conntrack_find(net, tuple);
>         if (h) {
>                 ct =3D nf_ct_tuplehash_to_ctrack(h);
>                 if (unlikely(!atomic_inc_not_zero(&ct->ct_general.use=
)))
>                         h =3D NULL;
> +               else {
> +                       if (unlikely(!nf_ct_tuple_equal(tuple, &h->tu=
ple))) {
> +                               nf_ct_put(ct);
> +                               goto begin;
> +                       }
> +               }
>         }
>         rcu_read_unlock();
>=20
> will ct be stalled in rcu read critical section?
>=20
> Would you explain it for me? Thanks!
>=20

I must confess I dont understand your question.

If your question is "Can we loop forever, with RCU hold", the answer is
no.

Because of lockless lookup (against writers), we must check the entry w=
e
found - after getting a reference on it - is still matching the keys of
our lookup. If not, we retry the lookup, because the entry we found is
not what we wanted, ie we probably were linked to another hash chain.

In real situation, probability of a matching then vanishing element,
reallocated and reused (since we could atomic_inc_not_zero() it), is
close to 0. Yet we must take care of this _very_ _unlikely_ event.



--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
