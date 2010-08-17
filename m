From: Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [PATCH] netfilter: save the hash of the tuple in the original
 direction for latter use
Date: Tue, 17 Aug 2010 11:01:55 +0200
Message-ID: <1282035715.2448.24.camel@edumazet-laptop>
References: <1282029386-2952-1-git-send-email-xiaosuo@gmail.com>
	 <1282033817.2448.18.camel@edumazet-laptop>
	 <AANLkTinuUuZSqEzfQAF422x2gYsVLzFQtXZKNLhgw+9g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Patrick McHardy <kaber@trash.net>,
	"David S. Miller" <davem@davemloft.net>,
	netfilter-devel@vger.kernel.org, linux-kernel@vger.kernel.org
To: Changli Gao <xiaosuo@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <AANLkTinuUuZSqEzfQAF422x2gYsVLzFQtXZKNLhgw+9g@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Le mardi 17 ao=C3=BBt 2010 =C3=A0 16:46 +0800, Changli Gao a =C3=A9crit=
 :
> On Tue, Aug 17, 2010 at 4:30 PM, Eric Dumazet <eric.dumazet@gmail.com=
> wrote:
> >
> > Three variables ?
> >
> > static atomic_t rnd __read_mostly;
> >
> > if (unlikely(!atomic_read(&rnd))) {
> >        unsigned int val;
> >
> >        get_random_bytes(&val, sizeof(val));
> >        if (!val)
> >                val =3D 1;
> >        atomic_cmpxchg(&rnd, 0, val);
> > }
> >
>=20
>=20
> Good idea. However, atomic_t is a volatile variable, and it prevent
> ILP. I think maybe it hurts the likely case. cmpxchg() is an atomic
> operations, so is the bellow code better?
>=20

I am not sure what you mean by ILP.

On x86, reading twice same memory location is faster than
reading it and store in temp variable (on stack)
reading from stack

>  static unsigned long rnd __read_mostly;
>=20
>  if (unlikely(!rnd)) {
>         unsigned long val;
>=20
>         get_random_bytes(&val, sizeof(val));
>         if (!val)
>                 val =3D 1;
>         cmpxchg(&rnd, 0, val);
>  }
>=20
> Thanks.
>=20

I am not sure we must use a long (we really need 4 bytes only), and las=
t
time I tried to use cmpxchg(), I was being told it was not available on
all arches.

But seeing it used in kernel/pid.c, maybe its not true anymore (that is=
,
__HAVE_ARCH_CMPXCHG is always defined to 1)

Since its a recent change (in kernel/pid.c), I would wait a bit and see
if an arch maintainer complains ;)
