From: Changli Gao <xiaosuo@gmail.com>
Subject: Re: ct: will ct be stalled in rcu read critical section?
Date: Wed, 10 Feb 2010 16:43:12 +0800
Message-ID: <412e6f7f1002100043m4fed3cat4c9704f1d32d7f74@mail.gmail.com>
References: <412e6f7f1002091916h5663057bq56b81d6ceec478a7@mail.gmail.com>
	<1265787791.2871.17.camel@edumazet-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Eric Dumazet <eric.dumazet@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-fx0-f220.google.com ([209.85.220.220]:57373 "EHLO
	mail-fx0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753001Ab0BJIne convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 10 Feb 2010 03:43:34 -0500
Received: by fxm20 with SMTP id 20so942764fxm.21
        for <netfilter-devel@vger.kernel.org>; Wed, 10 Feb 2010 00:43:32 -0800 (PST)
In-Reply-To: <1265787791.2871.17.camel@edumazet-laptop>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Feb 10, 2010 at 3:43 PM, Eric Dumazet <eric.dumazet@gmail.com> =
wrote:
> Le mercredi 10 f=C3=A9vrier 2010 =C3=A0 11:16 +0800, Changli Gao a =C3=
=A9crit :
>
> Because of lockless lookup (against writers), we must check the entry=
 we
> found - after getting a reference on it - is still matching the keys =
of
> our lookup. If not, we retry the lookup, because the entry we found i=
s
> not what we wanted, ie we probably were linked to another hash chain.
>

As we use RCU mechanism to protect connntrack table and its elements,
so when the code in the read critical section runs, its elements won't
be freed until the next quiescence period.


> In real situation, probability of a matching then vanishing element,
> reallocated and reused (since we could atomic_inc_not_zero() it), is
> close to 0. Yet we must take care of this _very_ _unlikely_ event.
>

reallocated and reused? If it happens, GOD will know what will happen
next. The memory will be used by the other subsystems in the kernel,
and in some case( just allocated, and its content isn't modified), the
addition check here won't help much.

--=20
Regards=EF=BC=8C
Changli Gao(xiaosuo@gmail.com)
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
