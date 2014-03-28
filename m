From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH] netfilter: nf_tables: set names cannot be larger than 15
 bytes
Date: Fri, 28 Mar 2014 14:18:39 +0100
Message-ID: <20140328131839.GH21741@breakpoint.cc>
References: <1395670237-3841-1-git-send-email-pablo@netfilter.org>
 <20140324224105.GA21741@breakpoint.cc>
 <20140325204537.GA3501@localhost>
 <20140326003250.GC21741@breakpoint.cc>
 <20140328112058.GA12878@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org,
	giuseppelng@gmail.com, kaber@trash.net
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:44217 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751417AbaC1NSl (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 28 Mar 2014 09:18:41 -0400
Content-Disposition: inline
In-Reply-To: <20140328112058.GA12878@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > > This is what I originally thought. But all of the nla_* functions use
> > > the nla_len to know length of the string coming from userspace, so
> > > they don't rely on the trailing nul-termination.
> > 
> > Indeed.  I reviewed this again but only 'bug' I spotted:
> > 
> > nf_tables_chain_type_lookup() does:
> > request_module("nft-chain-%u-%*.s", ....
> > 
> > ('%.*s' was probably intended).  Its harmless though as NFTA_CHAIN_TYPE is
> > NLA_NUL_STR so the erroneous fmt could also be changed to plain %s.
> 
> I think we can change that to NLA_STRING to make it consistent with
> other attributes. libnftnl is anyway sending the nul-termination all
> the time, so nothing should break IMO.

Right, but the kernel shouldn't rely on that :)

I see no problem converting it to NLA_STRING (if request_module args are
fixed).
