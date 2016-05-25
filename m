From: Tejun Heo <tj@kernel.org>
Subject: Re: [RFC][PATCH 2/3] locking: Annotate spin_unlock_wait() users
Date: Wed, 25 May 2016 15:28:07 -0400
Message-ID: <20160525192807.GG3354@mtj.duckdns.org>
References: <20160524142723.178148277@infradead.org>
 <20160524143649.608476390@infradead.org>
 <CA+55aFyyHbPVMx8cZbKONy5cevxsYA0qbwapboA0dD8hPSwPWg@mail.gmail.com>
 <20160524162207.GB3354@mtj.duckdns.org>
 <20160524165836.GC15189@worktop.bitpit.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Manfred Spraul <manfred@colorfullife.com>,
	Davidlohr Bueso <dave@stgolabs.net>,
	Paul McKenney <paulmck@linux.vnet.ibm.com>,
	Will Deacon <will.deacon@arm.com>,
	Boqun Feng <boqun.feng@gmail.com>,
	Waiman Long <Waiman.Long@hpe.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Patrick McHardy <kaber@trash.net>,
	David Miller <davem@davemloft.net>,
	Oleg Nesterov <oleg@redhat.com>,
	netfilter-devel@vger.kernel.org,
	Sasha Levin <sasha.levin@oracle.com>, hofrat@osadl.org
To: Peter Zijlstra <peterz@infradead.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160524165836.GC15189@worktop.bitpit.net>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Tue, May 24, 2016 at 06:58:36PM +0200, Peter Zijlstra wrote:
> On Tue, May 24, 2016 at 12:22:07PM -0400, Tejun Heo wrote:
> > A delta but that particular libata usage is probably not needed now.
> > The path was used while libata was gradually adding error handlers to
> > the low level drivers.  I don't think we don't have any left w/o one
> > at this point.  I'll verify and get rid of that usage.
> 
> OK, that would be great; I was sorta lost in there, but it looked like
> if you need the spin_unlock_wait() you also need the extra barrier
> thing.
> 
> If you can remove it, better still.

Unfortunately, ipr SAS driver is still using the old error handling
path, so please include libata in the conversion for now.  I'll see if
ipr can be converted.

Thanks.

-- 
tejun
