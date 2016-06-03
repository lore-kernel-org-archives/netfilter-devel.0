From: Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH -v4 5/7] locking, arch: Update spin_unlock_wait()
Date: Fri, 3 Jun 2016 18:35:37 +0100
Message-ID: <20160603173537.GR9915@arm.com>
References: <20160602115157.249037373@infradead.org>
 <20160602115439.085385545@infradead.org>
 <20160602142440.GE30064@insomnia>
 <20160602144424.GV3193@twins.programming.kicks-ass.net>
 <20160602163425.GV3205@twins.programming.kicks-ass.net>
 <20160602175659.GB7697@arm.com>
 <20160602215119.GF3190@twins.programming.kicks-ass.net>
 <20160603124734.GK9915@arm.com>
 <20160603134249.GA3693@twins.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Boqun Feng <boqun.feng@gmail.com>, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, manfred@colorfullife.com,
	dave@stgolabs.net, paulmck@linux.vnet.ibm.com, Waiman.Long@hpe.com,
	tj@kernel.org, pablo@netfilter.org, kaber@trash.net,
	davem@davemloft.net, oleg@redhat.com,
	netfilter-devel@vger.kernel.org, sasha.levin@oracle.com,
	hofrat@osadl.org, jejb@parisc-linux.org, chris@zankel.net,
	rth@twiddle.net, dhowells@redhat.com, schwidefsky@de.ibm.com,
	mpe@ellerman.id.au, ralf@linux-mips.org, linux@armlinux.org.uk,
	rkuo@codeaurora.org, vgupta@synopsys.com, james.hogan@imgtec.com,
	realmz6@gmail.com, ysato@users.sourceforge.jp, tony.luck@intel.com,
	cmetcalf@mellanox.com, "H. Peter Anvin" <hpa@zytor.com>
To: Peter Zijlstra <peterz@infradead.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160603134249.GA3693@twins.programming.kicks-ass.net>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Fri, Jun 03, 2016 at 03:42:49PM +0200, Peter Zijlstra wrote:
> On Fri, Jun 03, 2016 at 01:47:34PM +0100, Will Deacon wrote:
> > Even on x86, I think you need a fence here:
> > 
> > X86 lock
> > {
> > }
> >  P0                | P1                ;
> >  MOV EAX,$1        | MOV EAX,$1        ;
> >  LOCK XCHG [x],EAX | LOCK XCHG [y],EAX ;
> >  MOV EBX,[y]       | MOV EBX,[x]       ;
> > exists
> > (0:EAX=0 /\ 0:EBX=0 /\ 1:EAX=0 /\ 1:EBX=0)
> > 
> > is permitted by herd.
> 
> I am puzzled.. this should not be. You say adding MFENCE after LOCK XCHG
> makes it 'work', but we assume LOCK <op> is a full fence all over the
> place.
> 
> I'm thinking herd is busted.

FWIW -- I spoke to the Herd authors and they confirmed that this is a
regresion in herd (fixed in the bleeding edge version).

Will
