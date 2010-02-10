From: Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: ct: will ct be stalled in rcu read critical section?
Date: Wed, 10 Feb 2010 11:22:12 +0100
Message-ID: <1265797332.3047.1.camel@edumazet-laptop>
References: <412e6f7f1002091916h5663057bq56b81d6ceec478a7@mail.gmail.com>
	 <1265787791.2871.17.camel@edumazet-laptop>
	 <412e6f7f1002100043m4fed3cat4c9704f1d32d7f74@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Changli Gao <xiaosuo@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-bw0-f219.google.com ([209.85.218.219]:43872 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752657Ab0BJKWQ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 10 Feb 2010 05:22:16 -0500
Received: by bwz19 with SMTP id 19so1738245bwz.28
        for <netfilter-devel@vger.kernel.org>; Wed, 10 Feb 2010 02:22:14 -0800 (PST)
In-Reply-To: <412e6f7f1002100043m4fed3cat4c9704f1d32d7f74@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Le mercredi 10 f=C3=A9vrier 2010 =C3=A0 16:43 +0800, Changli Gao a =C3=A9=
crit :
> On Wed, Feb 10, 2010 at 3:43 PM, Eric Dumazet <eric.dumazet@gmail.com=
> wrote:
> > Le mercredi 10 f=C3=A9vrier 2010 =C3=A0 11:16 +0800, Changli Gao a =
=C3=A9crit :
> >
> > Because of lockless lookup (against writers), we must check the ent=
ry we
> > found - after getting a reference on it - is still matching the key=
s of
> > our lookup. If not, we retry the lookup, because the entry we found=
 is
> > not what we wanted, ie we probably were linked to another hash chai=
n.
> >
>=20
> As we use RCU mechanism to protect connntrack table and its elements,
> so when the code in the read critical section runs, its elements won'=
t
> be freed until the next quiescence period.

Please read about SLAB_DESTROY_BY_RCU, you dont know that part of RCU i=
t
seems.

>=20
>=20
> > In real situation, probability of a matching then vanishing element=
,
> > reallocated and reused (since we could atomic_inc_not_zero() it), i=
s
> > close to 0. Yet we must take care of this _very_ _unlikely_ event.
> >
>=20
> reallocated and reused? If it happens, GOD will know what will happen
> next. The memory will be used by the other subsystems in the kernel,
> and in some case( just allocated, and its content isn't modified), th=
e
> addition check here won't help much.
>=20

You obviously missed a part of RCU. No grace period has to be respected
in this case. Just read again the Changelog of the patch, all this was
explained.



--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
