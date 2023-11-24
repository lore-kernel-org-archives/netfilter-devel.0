Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBE52A2;
	Fri, 24 Nov 2023 02:16:10 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1r6TEG-00034E-Nd; Fri, 24 Nov 2023 11:16:08 +0100
Date: Fri, 24 Nov 2023 11:16:08 +0100
From: Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org,
	lorenzo@kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH nf-next 0/8] netfilter: make nf_flowtable lifetime differ
 from container struct
Message-ID: <20231124101608.GA11463@breakpoint.cc>
References: <20231121122800.13521-1-fw@strlen.de>
 <ZWBx4Em+8acC3JJN@calendula>
 <20231124095512.GB13062@breakpoint.cc>
 <ZWB2rxcMmoKUPLPb@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZWB2rxcMmoKUPLPb@calendula>
User-Agent: Mutt/1.10.1 (2018-07-13)

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > The work queue for hw offload (or ndo ops) are not used.
> 
> OK, but is it possible to combine this XDP approach with hardware
> offload?

Yes.  We could disallow it if you prefer.

Ordering is, for ingress packet processing:
HW -> XDP -> nf flowtable -> classic forward path

instead of:

HW -> nf flowtable -> classic forward path

For the existing design.

> > If the xdp program can't handle it packet will be pushed up the stack,
> > i.e. nf ingress hook will handle it next.
> 
> Then, only very simple scenarios will benefit from this acceleration.

Yes.  I don't see a reason to worry about more complex things right now.
E.g. PPPoE encap can be added later.

Or do you think this has to be added right from the very beginning?

I hope not.

> > > My understand is that XDP is all about programmibility, if user
> > > decides to go for XDP then simply fully implement the fast path is the
> > > XDP framework? I know of software already does so and they are
> > > perfectly fine with this approach.
> > 
> > I don't understand, you mean no integration at all?
> 
> I mean, fully implement a fastpath in XDP/BPF using the datastructures
> that it provides.

I think its very bad for netfilter.
