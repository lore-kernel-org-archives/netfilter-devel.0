Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="A3lHsitD"
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13844DB
	for <netfilter-devel@vger.kernel.org>; Wed, 13 Dec 2023 13:51:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=/ahNqAGFVhic2PcmOcy1GJd0IJVh3CVuN1ERCpVohHA=; b=A3lHsitD/5Pv2g+fL6oFMGJmnP
	hh9EUyVDozfN5riEDDZCAj1/zCc2b6HjqERlEbIai0Aj5CBNK3uX/Vk+jFcQTdnhshH8ZL0zP/6pD
	xDf6GVIgyWxq591n22ZP2Gw7XYww9S269YODF5TrJp3MONtt243x6vITKc+gQhwCkOdpBUkovTCOE
	6BiMscOBcGJfFJ4PJYf1O6laxr2kagjZWZcfu11SDE333QW2vWjYPbyNTGmJ3trDjhJji1a0Wh+DF
	NuXEy0Qg8KAFeOMHjVD7ilmd5EC8wNzepn5s46h1xkKvVKqJwQvDxjrMhnXiDV7LqFlh5xTrsuPPc
	7HjBF4Cg==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
	(envelope-from <phil@nwl.cc>)
	id 1rDX8N-0008Ul-JJ; Wed, 13 Dec 2023 22:51:15 +0100
Date: Wed, 13 Dec 2023 22:51:15 +0100
From: Phil Sutter <phil@nwl.cc>
To: Florian Westphal <fw@strlen.de>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
Subject: Re: [libnftnl RFC 2/2] expr: Introduce struct expr_ops::attr_policy
Message-ID: <ZXonUyedK70ZMkFY@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
References: <20231213190222.3681-1-phil@nwl.cc>
 <20231213190222.3681-2-phil@nwl.cc>
 <20231213202035.GA6601@breakpoint.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231213202035.GA6601@breakpoint.cc>

On Wed, Dec 13, 2023 at 09:20:35PM +0100, Florian Westphal wrote:
> Phil Sutter <phil@nwl.cc> wrote:
> > Similar to kernel's nla_policy, enable expressions to inform about
> > restrictions on attribute use. This allows the generic expression code
> > to perform sanity checks before dispatching to expression ops.
> > 
> > For now, this holds only the maximum data len which may be passed to
> > nftnl_expr_set().
> > 
> > Signed-off-by: Phil Sutter <phil@nwl.cc>
> > ---
> >  include/expr_ops.h   |  5 +++++
> >  src/expr.c           |  6 ++++++
> >  src/expr/bitwise.c   | 11 +++++++++++
> >  src/expr/byteorder.c |  9 +++++++++
> >  src/expr/immediate.c |  9 +++++++++
> >  5 files changed, 40 insertions(+)
> > 
> > diff --git a/include/expr_ops.h b/include/expr_ops.h
> > index 51b221483552c..6c95297bfcd58 100644
> > --- a/include/expr_ops.h
> > +++ b/include/expr_ops.h
> > @@ -8,10 +8,15 @@ struct nlattr;
> >  struct nlmsghdr;
> >  struct nftnl_expr;
> >  
> > +struct attr_policy {
> > +	size_t maxlen;
> 
> I'd make this an uint32_t since that is also whats
> passed to expr_set().

ACK.

> > +		if (expr->ops->attr_policy &&
> > +		    type <= expr->ops->nftnl_max_attr &&
> > +		    expr->ops->attr_policy[type].maxlen &&
> > +		    expr->ops->attr_policy[type].maxlen < data_len)
> > +			return -1;
> > +
> 
> I'd make this more strict, is there a reason to call ops->set
> if type > ->nftnl_max_attr?

Indeed. We might even drop the default case from expressions' set
callbacks, if we assert type >= NFTNL_EXPR_BASE, too.

> Something like:
> 
> !attr_policy -> return -1;

Which means I can't procrastinate writing the policies for all 40
expressions. ;)

> type > nftnl_max_attr -> return -1:
> data_len > maxlen -> return -1.

I wanted to make this an opt-in approach, so I'd rather go with
maxlen && maxlen < data_len -> return -1.

> We could also define a minlen to disallow setting
> e.g. 1 byte of something that is internally an u32.

This at least may easily be added later, or now but with the default
minlen of 0 for most attributes.

> But I admit that this might break compatibility
> or otherwise leak internals into the api.

It's not entirely straightforward, anyway. NFTNL_EXPR_IMM_CHAIN for
instance accepts literally anything as long as it's a NUL-terminated
string. I was unsure whether libnftnl should enforce
NFT_CHAIN_MAXNAMELEN there or not.

Thanks, Phil
