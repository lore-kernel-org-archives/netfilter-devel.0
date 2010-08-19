From: Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [PATCH] netfilter: save the hash of the tuple in the original
 direction for latter use
Date: Thu, 19 Aug 2010 17:31:46 +0200
Message-ID: <1282231906.2549.45.camel@edumazet-laptop>
References: <1282029386-2952-1-git-send-email-xiaosuo@gmail.com>
	 <1282033817.2448.18.camel@edumazet-laptop>
	 <AANLkTinuUuZSqEzfQAF422x2gYsVLzFQtXZKNLhgw+9g@mail.gmail.com>
	 <1282035715.2448.24.camel@edumazet-laptop>
	 <AANLkTinqQ9wXK9Ed3VYTWj_trYJiU+=uTV-FnCxqFvNU@mail.gmail.com>
	 <20100819123545.GA4428@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Changli Gao <xiaosuo@gmail.com>, Patrick McHardy <kaber@trash.net>,
	"David S. Miller" <davem@davemloft.net>,
	netfilter-devel@vger.kernel.org, linux-kernel@vger.kernel.org
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20100819123545.GA4428@Krystal>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Le jeudi 19 ao=C3=BBt 2010 =C3=A0 08:35 -0400, Mathieu Desnoyers a =C3=A9=
crit :

> I made sure it was available on all architectures with that patchset,
> with the intended goal to used it (cmpxchg, cmpxchg_local for 32/64-b=
it
> and cmpxchg64, cmpxchg64_local for 64-bit) in arch-agnostic tracer co=
de.
>=20
> I added a cmpxchg emulated with irqs off for uniprocessor-only
> architectures that did not have CAS support. sparc32 has moved to a
> hashed locked scheme for its atomic operations long ago, which makes =
the
> full 32 bits available.
>=20
> So, all in all, I'd be surprised if an architecture would lack
> cmpxchg() today. It might be possible that a new architecture that ju=
st
> came in would not have taken care of deploying cmpxchg, but that shou=
ld
> be easily fixable.

Thats pretty cool, thanks for clarification !
