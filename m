From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH -v3 3/8] locking: Introduce smp_acquire__after_ctrl_dep
Date: Wed, 1 Jun 2016 18:22:55 +0200
Message-ID: <20160601162255.GT3190@twins.programming.kicks-ass.net>
References: <20160531094134.606249808@infradead.org>
 <20160531094844.037298593@infradead.org>
 <20160601135214.GC30064@insomnia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	manfred@colorfullife.com, dave@stgolabs.net,
	paulmck@linux.vnet.ibm.com, will.deacon@arm.com,
	Waiman.Long@hpe.com, tj@kernel.org, pablo@netfilter.org,
	kaber@trash.net, davem@davemloft.net, oleg@redhat.com,
	netfilter-devel@vger.kernel.org, sasha.levin@oracle.com,
	hofrat@osadl.org
To: Boqun Feng <boqun.feng@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160601135214.GC30064@insomnia>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Wed, Jun 01, 2016 at 09:52:14PM +0800, Boqun Feng wrote:
> On Tue, May 31, 2016 at 11:41:37AM +0200, Peter Zijlstra wrote:

> > @@ -292,7 +282,7 @@ static void sem_wait_array(struct sem_ar
> >  		sem = sma->sem_base + i;
> >  		spin_unlock_wait(&sem->lock);
> >  	}
> > -	ipc_smp_acquire__after_spin_is_unlocked();
> > +	smp_acquire__after_ctrl_dep();
> 
> I wonder whether we can kill this barrier after updating
> spin_unlock_wait() to ACQUIRE?

See patch 5 doing that :-)
