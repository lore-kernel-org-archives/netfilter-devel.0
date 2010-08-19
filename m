From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: Re: [PATCH] netfilter: save the hash of the tuple in the original
	direction for latter use
Date: Thu, 19 Aug 2010 08:35:45 -0400
Message-ID: <20100819123545.GA4428@Krystal>
References: <1282029386-2952-1-git-send-email-xiaosuo@gmail.com> <1282033817.2448.18.camel@edumazet-laptop> <AANLkTinuUuZSqEzfQAF422x2gYsVLzFQtXZKNLhgw+9g@mail.gmail.com> <1282035715.2448.24.camel@edumazet-laptop> <AANLkTinqQ9wXK9Ed3VYTWj_trYJiU+=uTV-FnCxqFvNU@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: Eric Dumazet <eric.dumazet@gmail.com>,
	Patrick McHardy <kaber@trash.net>,
	"David S. Miller" <davem@davemloft.net>,
	netfilter-devel@vger.kernel.org, linux-kernel@vger.kernel.org
To: Changli Gao <xiaosuo@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <AANLkTinqQ9wXK9Ed3VYTWj_trYJiU+=uTV-FnCxqFvNU@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

* Changli Gao (xiaosuo@gmail.com) wrote:
> On Tue, Aug 17, 2010 at 5:01 PM, Eric Dumazet <eric.dumazet@gmail.com> wrote:
> >
> > I am not sure we must use a long (we really need 4 bytes only), and last
> > time I tried to use cmpxchg(), I was being told it was not available on
> > all arches.
> >
> > But seeing it used in kernel/pid.c, maybe its not true anymore (that is,
> > __HAVE_ARCH_CMPXCHG is always defined to 1)
> >
> > Since its a recent change (in kernel/pid.c), I would wait a bit and see
> > if an arch maintainer complains ;)
> >
> >
> 
> I searched the code, and found ext4, btrfs, lockdep, perf and trace
> all use cmpxchg(). And after this patch serial
> (http://linux.derkeiler.com/Mailing-Lists/Kernel/2007-08/msg05032.html)
> was merged, maybe cmpxchg() is generic. Is there an SMP processor
> doesn't support cmpxchg()?

I made sure it was available on all architectures with that patchset,
with the intended goal to used it (cmpxchg, cmpxchg_local for 32/64-bit
and cmpxchg64, cmpxchg64_local for 64-bit) in arch-agnostic tracer code.

I added a cmpxchg emulated with irqs off for uniprocessor-only
architectures that did not have CAS support. sparc32 has moved to a
hashed locked scheme for its atomic operations long ago, which makes the
full 32 bits available.

So, all in all, I'd be surprised if an architecture would lack
cmpxchg() today. It might be possible that a new architecture that just
came in would not have taken care of deploying cmpxchg, but that should
be easily fixable.

Please see Documentation/atomic_ops.txt for details.

Thanks,

Mathieu

> 
> -- 
> Regards,
> Changli Gao(xiaosuo@gmail.com)

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
