From: Sebastian Siewior <sebastian@breakpoint.cc>
Subject: Re: [RFC] SLOB breaks netfilter
Date: Wed, 8 Jun 2011 09:10:31 +0200
Message-ID: <20110608071031.GA2892@breakpoint.cc>
References: <20110607210651.GA11159@Chamillionaire.breakpoint.cc>
 <20110607.141810.2159514423065256050.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: kaber@trash.net, netfilter-devel@vger.kernel.org,
	netfilter@vger.kernel.org, coreteam@netfilter.org,
	tglx@linutronix.de
To: David Miller <davem@davemloft.net>
Return-path: <netfilter-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20110607.141810.2159514423065256050.davem@davemloft.net>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

* Thus spake David Miller (davem@davemloft.net):
> From: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
> Date: Tue, 7 Jun 2011 23:06:51 +0200
> 
> > and SLOB defines:
> > 
> > |#ifdef ARCH_DMA_MINALIGN
> > |#define ARCH_KMALLOC_MINALIGN ARCH_DMA_MINALIGN
> > |#else
> > |#define ARCH_KMALLOC_MINALIGN __alignof__(unsigned long)
> > |#endif
> 
> SLOB should really use "unsigned long long" I think.
> 
> An allocator needs to provide memory with the maximum
> alignment that might be required for types on a given
> architecture.

The larger alignment is due to u64 in the counter struct. However, it still
needs two loads/stores for it on my 32bit powerpc here.

Sebastian
