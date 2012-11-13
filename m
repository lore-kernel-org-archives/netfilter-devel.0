From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 3/3] netfilter: ipv6: add getsockopt to retrieve origdst
Date: Tue, 13 Nov 2012 10:39:50 +0100
Message-ID: <20121113093950.GA24755@1984>
References: <1352765203-4160-1-git-send-email-pablo@netfilter.org>
 <1352765203-4160-4-git-send-email-pablo@netfilter.org>
 <50A1BEA0.8070504@linux-ipv6.org>
 <20121113085930.GE20678@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>,
	netfilter-devel@vger.kernel.org, davem@davemloft.net,
	netdev@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20121113085930.GE20678@breakpoint.cc>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Tue, Nov 13, 2012 at 09:59:30AM +0100, Florian Westphal wrote:
> YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org> wrote:
> > pablo@netfilter.org wrote:
> > > From: Florian Westphal <fw@strlen.de>
> > > +	sin6.sin6_scope_id = sk->sk_bound_dev_if;
> > > +
> > > +	nf_ct_put(ct);
> > > +	return copy_to_user(user, &sin6, sizeof(sin6)) ? -EFAULT : 0;
> > > +}
> > > +
> > 
> > I think we should set sin6_scope_id to sk->sk_bound_dev_if only if the
> > destination is link-local address.
> 
> Right, I see that getpeer/sockname has this test.
> 
> Dave, please either apply the patch as is (I'd submit a fixup)
> or discard i, I'll then send a V2 with added
> ipv6_addr_type(&sin->sin6_addr) & IPV6_ADDR_LINKLOCAL
> test to Pablo.

Please, send me a follow-up patch, I'll apply and request a new pull
request.

Thanks.
