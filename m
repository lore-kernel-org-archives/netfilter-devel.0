From: Changli Gao <xiaosuo@gmail.com>
Subject: Re: [PATCH] netfilter: save the hash of the tuple in the original
 direction for latter use
Date: Tue, 17 Aug 2010 17:32:26 +0800
Message-ID: <AANLkTi=oP989w2pO8j5fdzOYhWCeSNEQuZLHefAgGa_Y@mail.gmail.com>
References: <1282029386-2952-1-git-send-email-xiaosuo@gmail.com>
 <1282033817.2448.18.camel@edumazet-laptop> <AANLkTinuUuZSqEzfQAF422x2gYsVLzFQtXZKNLhgw+9g@mail.gmail.com>
 <1282035715.2448.24.camel@edumazet-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Patrick McHardy <kaber@trash.net>,
	"David S. Miller" <davem@davemloft.net>,
	netfilter-devel@vger.kernel.org, linux-kernel@vger.kernel.org
To: Eric Dumazet <eric.dumazet@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:54422 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932160Ab0HQJcr convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 17 Aug 2010 05:32:47 -0400
In-Reply-To: <1282035715.2448.24.camel@edumazet-laptop>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Aug 17, 2010 at 5:01 PM, Eric Dumazet <eric.dumazet@gmail.com> =
wrote:
> Le mardi 17 ao=FBt 2010 =E0 16:46 +0800, Changli Gao a =E9crit :
>> On Tue, Aug 17, 2010 at 4:30 PM, Eric Dumazet <eric.dumazet@gmail.co=
m> wrote:
>> >
>> > Three variables ?
>> >
>> > static atomic_t rnd __read_mostly;
>> >
>> > if (unlikely(!atomic_read(&rnd))) {
>> > =A0 =A0 =A0 =A0unsigned int val;
>> >
>> > =A0 =A0 =A0 =A0get_random_bytes(&val, sizeof(val));
>> > =A0 =A0 =A0 =A0if (!val)
>> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0val =3D 1;
>> > =A0 =A0 =A0 =A0atomic_cmpxchg(&rnd, 0, val);
>> > }
>> >
>>
>>
>> Good idea. However, atomic_t is a volatile variable, and it prevent
>> ILP. I think maybe it hurts the likely case. cmpxchg() is an atomic
>> operations, so is the bellow code better?
>>
>
> I am not sure what you mean by ILP.

I mean http://en.wikipedia.org/wiki/Instruction_level_parallelism

and volatile will suppress compiler optimization.

>
> On x86, reading twice same memory location is faster than
> reading it and store in temp variable (on stack)
> reading from stack

Thanks for this info. But compiler may store it in a register. In
fact, we can't control the behavior of compiler in C.

>
>> =A0static unsigned long rnd __read_mostly;
>>
>> =A0if (unlikely(!rnd)) {
>> =A0 =A0 =A0 =A0 unsigned long val;
>>
>> =A0 =A0 =A0 =A0 get_random_bytes(&val, sizeof(val));
>> =A0 =A0 =A0 =A0 if (!val)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 val =3D 1;
>> =A0 =A0 =A0 =A0 cmpxchg(&rnd, 0, val);
>> =A0}
>>
>> Thanks.
>>
>
> I am not sure we must use a long (we really need 4 bytes only),

Yea, 4 bytes is enough.

> and last
> time I tried to use cmpxchg(), I was being told it was not available =
on
> all arches.
>
> But seeing it used in kernel/pid.c, maybe its not true anymore (that =
is,
> __HAVE_ARCH_CMPXCHG is always defined to 1)
>
> Since its a recent change (in kernel/pid.c), I would wait a bit and s=
ee
> if an arch maintainer complains ;)
>

Thanks. I saw it. These are two cmpxchg() in file:

include/asm-generic/cmpxchg.h

include/asm-generic/system.h

static inline unsigned long __cmpxchg(volatile unsigned long *m,
                                      unsigned long old, unsigned long =
new)
{
        unsigned long retval;
        unsigned long flags;

        local_irq_save(flags);
        retval =3D *m;
        if (retval =3D=3D old)
                *m =3D new;
        local_irq_restore(flags);
        return retval;
}

#define cmpxchg(ptr, o, n)                                      \
        ((__typeof__(*(ptr))) __cmpxchg((unsigned long *)(ptr), \
                                        (unsigned long)(o),     \
                                        (unsigned long)(n)))

This one seems buggy when using it to non unsigned long variables. And
in kernel/pid.c, the last_pid variable is int.

--=20
Regards,
Changli Gao(xiaosuo@gmail.com)
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
