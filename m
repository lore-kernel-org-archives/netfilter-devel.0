From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH nf-next 1/6] netfilter: nf_tables: extend tracing
 infrastructure
Date: Wed, 25 Nov 2015 09:35:54 +0000
Message-ID: <20151125093554.GA31023@macbook.localdomain>
References: <1448359331-12692-1-git-send-email-fw@strlen.de>
 <1448359331-12692-2-git-send-email-fw@strlen.de>
 <20151125005523.GB27315@macbook.localdomain>
 <20151125083907.GF23215@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 161-169.trash.net ([213.144.137.169]:55080 "EHLO
	stinky.trash.net" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750699AbbKYJf6 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 25 Nov 2015 04:35:58 -0500
Content-Disposition: inline
In-Reply-To: <20151125083907.GF23215@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 25.11, Florian Westphal wrote:
> Patrick McHardy <kaber@trash.net> wrote:
> > 
> > The ordering appears to be a bit random (or I'm missing something), I'd
> > expect basic information like TABLE/CHAIN/RULE_HANDLE to be at the beginning
> > (in that order), similar for TYPE, VERDICT etc.
> 
> NFTA_TRACE_UNSPEC,
> NFTA_TRACE_TABLE,
> NFTA_TRACE_CHAIN,
> NFTA_TRACE_RULE_HANDLE,
> NFTA_TRACE_TYPE,
> NFTA_TRACE_VERDICT,
> NFTA_TRACE_DEV_TYPE,
> NFTA_TRACE_ID,
> NFTA_TRACE_LL_HEADER,
> NFTA_TRACE_NETWORK_HEADER,
> NFTA_TRACE_TRANSPORT_HEADER,
> NFTA_TRACE_TRANSPORT_PROTO,
> NFTA_TRACE_IIF,
> NFTA_TRACE_OIF,
> NFTA_TRACE_MARK,
> NFTA_TRACE_VLAN_TAG,
> 
> better?  If not, please just tell me what ordering you'd prefer and
> thats what I'll use.

Yep looks good.

> > > +     if (nla_put_be32(skb, NFTA_TRACE_ID, htonl(hash32_ptr(pkt->skb)))) 
> 
> > This could lead to duplicate IDs quite quickly. I can't think of any other
> > values where we know for sure they will stay constant while the skb is within
> > netfilter. How about combining this with a per CPU counter or something
> > similar?
> 
> I would not mind, it would result in ID change though for nfqueue case.
> If thats ok I'll use a pcpu counter that gets incremented when nft_meta
> sets skb->nftrace=1 and use __this_cpu_read(trace_id) instead (if we
> have pcpu id counter, is there any point in also using skb address...?)

Not sure, I guess not.

> > > +	switch (type) {
> > > +	case NFT_TRACETYPE_POLICY:
> > > +	case NFT_TRACETYPE_RETURN:
> > > +	case NFT_TRACETYPE_RULE:
> > > +		if (nla_put_be32(skb, NFTA_TRACE_VERDICT, htonl(verdict)))
> > > +			goto nla_put_failure;
> > 
> > It would be nice to have the full verdict available, IOW also the jump target.
> > 
> > You could simply pass struct nft_verdict to this function and adapt
> > nft_verdict_dump() to take the attribute value as parameter.
> 
> Will add NFTA_TRACE_JUMP/NFTA_TRACE_GOTO for that, ok?

Any reason not to use the standard verdict encoding? We even have an almost
ready to use function for that.
