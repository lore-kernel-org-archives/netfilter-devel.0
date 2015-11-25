From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH nf-next 3/6] netfilter: nf_tables: disable old tracing if
 listener is present
Date: Wed, 25 Nov 2015 16:46:29 +0000
Message-ID: <20151125164629.GB30712@macbook.localdomain>
References: <20151124103938.GB3014@salvia>
 <20151124105300.GK2310@macbook.localdomain>
 <20151124111029.GH1740@breakpoint.cc>
 <20151124113341.GO2310@macbook.localdomain>
 <20151124151542.GA20972@breakpoint.cc>
 <20151124152649.GK14478@macbook.localdomain>
 <20151124153550.GC20972@breakpoint.cc>
 <20151124154241.GL14478@macbook.localdomain>
 <20151125150640.GE18449@macbook.localdomain>
 <20151125162424.GJ23215@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 161-169.trash.net ([213.144.137.169]:58798 "EHLO
	stinky.trash.net" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751320AbbKYQqe (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 25 Nov 2015 11:46:34 -0500
Content-Disposition: inline
In-Reply-To: <20151125162424.GJ23215@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 25.11, Florian Westphal wrote:
> Patrick McHardy <kaber@trash.net> wrote:
> > The ordering corresponds to the ordering of the header fields, f.i.:
> > 
> > trace id 85898000 ip ip length 60 ip id 220 ip ttl 64 ip protocol tcp ip saddr 192.168.122.1 ip daddr 192.168.122.84 tcp sport 39558 tcp dport 10000 iif ens3 
> > trace id 85898000 ip filter input verdict 4294967295 iif ens3 
> > trace id 85898000 rule tcp dport 10000 nftrace set 1 
> > trace id 85898000 ip filter input verdict 4294967295 iif ens3 
> > trace id 85898000 rule tcp dport 10000 counter packets 79 bytes 4740 
> > trace id 85898000 ip filter input verdict 4294967295 iif ens3 
> > trace id 85898000 rule tcp dport 10000 continue 
> > trace id 85898000 ip filter input verdict 4294967295 mark 0x00000001 iif ens3 
> > trace id 85898000 rule tcp dport 10000 mark set 0x00000001 
> > trace id 85898000 ip filter input verdict 1 mark 0x00000001 iif ens3 
> > 
> > As you can see, the IP addresses are the last two members of the IP header
> > that are dumped, which is not really ideal for readability. Not sure how
> > to fix that yet. Any ideas?
> 
> Hmm, I think it actually increases readability, as all the other lines
> you quoted above are a lot shorter the ip saddr part is a lot more
> visible.

They are actually still missing some minor parts from the original output :)

But if we want to shorten them, I would suggest f.i. to not repeat the
devices on every line. It seems to logically belong to the "packet" part,
same as vlan id. I guess the only thing we actually need to repeat is the
mark since that might change while we're within the ruleset.

> If nftrace netfilter rules are used properly (ie., with limit statement
> or other means to narrow matching down) those long lines even sever as
> kind-of delimiter to where a new round of trace output starts without
> looking at the id.

I agree, that part makes for a good delimiter.

> As wrt. fixing it, I don't think this should be over-engineered.
> 
> I would propose to annotate the address fields in the protocol
> description, similar to the filter you added, and then walk
> header several times.
> 
> 1st round dumps source address
> 2nd round dumps dst address
> 3rd round dumps the next protocol field
> 4th round dumps the rest that isn't 'blacklisted' (such as checksum).
> 
> Ugly, but given headers differ completely I don't see a better
> solution.
> Since headers are commonly small the overhead should not be
> a big deal.

I've also considered this and so far it was my favourite approach as
well. Unfortunately it requires annotations for all headers, but I guess
that's an acceptable tradeoff.

> In case of ethernet, dst is first header field -- not sure if
> we should re-order it so that src a:b.. dst d: .. is shown.
> 
> If you prefer to keep the real header ordering, then we don't
> need to differentiate between these two.

I personally generally prefer what I perceive as "logical ordering", which
is src, dst, ....

> > Comments welcome, especially regarding the current limitations we have.
> 
> Looks fantastic, I am leaning towards dropping the header formatting
> from libnftl patch entirely.

I agree, we could drop the header part and only print the meta data. So we
can see that something is happening and associate the events with decoded
messages, but full decoding seems unnecessary.

> > +	if (!nftnl_trace_is_set(nlt, attr))
> >  		return;
> 
> Eeek, sorry about that.
> 
> > +static void trace_print_packet(const struct nftnl_trace *nlt)
> > +{
> > +	struct proto_ctx ctx;
> > +
> > +	proto_ctx_init(&ctx, nftnl_trace_get_u32(nlt, NFTNL_TRACE_FAMILY));
> > +	// NFTA_TRACE_DEV_TYPE
> 
> This attribute should be exported already.

Yep, I just didn't integrate it properly yet.

> The limitation (same as with my patch) is that if we don't know the
> value then we cannot pretty-print that L2 header.
> I don't think thats a problem, we can just move on to NH.

It depends, f.i. for bridging we can infer it from the hook values. In fact
proto_ctx_init() already does that correctly for bridging.

> > +	if (nftnl_trace_is_set(nlt, NFTNL_TRACE_VERDICT))
> > +		printf("verdict %u ", nftnl_trace_get_u32(nlt, NFTNL_TRACE_VERDICT));
> 
> I am working on this.
> 
> Dissecting the verdict will happen in libnftnl, so NFTNL_TRACE_VERDICT will return
> a verdict without extra information.
> 
> I'll add NFTNL_TRACE_NFQUEUE_ID to store the upper 16 bits for QUEUE verdicts.

I don't think that's necessary. All the other verdict parts (actually nft_data)
simply return the numeric verdict code and also accept them, both for encoded
DROP_ERRNOS and queue numbers. Is there any reason to diverge from this?

Thanks for your feedback. I'll start incorporating it now.

Cheers,
Patrick
