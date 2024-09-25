Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3F551EEE9
	for <netfilter-devel@vger.kernel.org>; Wed, 25 Sep 2024 17:25:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727285155; cv=none; b=M28KHkVG9PTuygrkRA89g5+QQ07mmxr+8XF4JJQ6GKQ+zSXJGLjv7XJE6KKple3s0oDvFiK2g9kSDTDZ1xPWJOOM0F4cwe5oK8f3tLi31DqwhtdV273pagFXttoRszRedleoEg/hg440Kqoo7dOGWZ5RXnHS2p70vL9DJMUEo1w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727285155; c=relaxed/simple;
	bh=WxAiyajicd+x6eZzH/tXFrzC9otefypDocRKpU8lDtI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=clfS6K/ZSrDIq00d9W23JVADH7IhAVVnwsGOVVrRyxycmFa/cr9NCYBkoBmCNGzPAZtbdVIY6242cq+jpZ00LS89wJayl6xHRVh79aF/mTudkfz5orVmkIjEzO4apMQ4yXQ0PeU6yhrkes5etRr3o703ZYtfkUGPFfvrXVKJQVg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=AzsUrAsw; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="AzsUrAsw"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=p5897G2iJco2QJMVHI37t131UKZ0iZR3CfllQ323ReE=; b=AzsUrAswNMLf+dyWsS8Yhc0aVY
	6nITUZej0Ys38i6rMUb6HF6z0tkafgvwOGqs7iT8Dt6Fkh/tCuS1UZKSSd6r0XlWLxFjqRiuC430p
	1suU8TciQhuhXLqSWr8ZukmK2pJAV1GqHyFnNM+etT1XHwpok4xqEFGoDo61cXGgzAN2TRFdI2no4
	I6Mp/xpC0F2DQyC7IdNCLt7nlikcM8T68rUqz6dVzJkxTl+ZMIiOdg07DQe++qA2akIrjRolexvJr
	j/9C5Ox2uJmtw7E/qNpD7aI8y+hhNqdOuHpyg+9BQPbm4HtIeddUSBVPTelshEnq9bMOrLyDV60Xk
	YSmV4fTg==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1stVlo-000000008Bf-1Mal;
	Wed, 25 Sep 2024 19:25:44 +0200
Date: Wed, 25 Sep 2024 19:25:44 +0200
From: Phil Sutter <phil@nwl.cc>
To: Florian Westphal <fw@strlen.de>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org, Eric Garver <e@erig.me>
Subject: Re: [nf-next PATCH v4 15/16] netfilter: nf_tables: Add notications
 for hook changes
Message-ID: <ZvRHmHn6wllDFukN@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org, Eric Garver <e@erig.me>
References: <20240920202347.28616-1-phil@nwl.cc>
 <20240920202347.28616-16-phil@nwl.cc>
 <20240921091034.GA5023@breakpoint.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240921091034.GA5023@breakpoint.cc>

On Sat, Sep 21, 2024 at 11:10:34AM +0200, Florian Westphal wrote:
> Phil Sutter <phil@nwl.cc> wrote:
> > Notify user space if netdev hooks are updated due to netdev add/remove
> > events. Send minimal notification messages by introducing
> > NFT_MSG_NEWDEV/DELDEV message types describing a single device only.
> > 
> > Signed-off-by: Phil Sutter <phil@nwl.cc>
> > ---
> >  include/net/netfilter/nf_tables.h        |  2 +
> >  include/uapi/linux/netfilter/nf_tables.h |  5 +++
> >  net/netfilter/nf_tables_api.c            | 56 ++++++++++++++++++++++++
> >  net/netfilter/nft_chain_filter.c         |  1 +
> >  4 files changed, 64 insertions(+)
> > 
> > diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
> > index eaf2f5184bdf..f8da38e45277 100644
> > --- a/include/net/netfilter/nf_tables.h
> > +++ b/include/net/netfilter/nf_tables.h
> > @@ -1132,6 +1132,8 @@ int nft_setelem_validate(const struct nft_ctx *ctx, struct nft_set *set,
> >  int nft_set_catchall_validate(const struct nft_ctx *ctx, struct nft_set *set);
> >  int nf_tables_bind_chain(const struct nft_ctx *ctx, struct nft_chain *chain);
> >  void nf_tables_unbind_chain(const struct nft_ctx *ctx, struct nft_chain *chain);
> > +void nf_tables_chain_device_notify(const struct nft_chain *chain,
> > +				   const struct net_device *dev, int event);
> >  
> >  enum nft_chain_types {
> >  	NFT_CHAIN_T_DEFAULT = 0,
> > diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
> > index d6476ca5d7a6..3a874febf1ac 100644
> > --- a/include/uapi/linux/netfilter/nf_tables.h
> > +++ b/include/uapi/linux/netfilter/nf_tables.h
> > @@ -142,6 +142,8 @@ enum nf_tables_msg_types {
> >  	NFT_MSG_DESTROYOBJ,
> >  	NFT_MSG_DESTROYFLOWTABLE,
> >  	NFT_MSG_GETSETELEM_RESET,
> > +	NFT_MSG_NEWDEV,
> > +	NFT_MSG_DELDEV,
> 
> This relies on implicit NFNL_CB_UNSPEC == 0 and nfnetlink
> bailing out whe NFT_MSG_NEWDEV appears in a netlink message
> coming from userspace.

I guess with 'implicit NFNL_CB_UNSPEC == 0' you mean the extra
nf_tables_cb array fields' 'type' value being 0 (nfnetlink.h explicitly
defines NFNL_CB_UNSPEC value as 0). I don't see the connection here
though, probably I miss nfnetlink_rcv_msg() relying on that field value
or so.

I do see implicit dependency on attr_count field being 0 via
nla_parse_deprecated().

> Is there precedence for this?
> If not, maybe better to add explicit entries to the
> nf_tables_cb[] array?
> 
> AFAICS its fine as-is, nfnetlink won't blindly invoke
> NULL ->call() pointer, but I'm not sure this was designed
> to be this way or if this is a coincidence.

I see at least NFNL_MSG_ACCT_OVERQUOTA missing from nfnl_acct_cb. The
former was introduced in 2014. May I claim grandfathering? ;)

Cheers, Phil
