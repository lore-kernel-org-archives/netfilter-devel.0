From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH nf-next 3/6] netfilter: nf_tables: disable old tracing if
 listener is present
Date: Wed, 25 Nov 2015 17:24:24 +0100
Message-ID: <20151125162424.GJ23215@breakpoint.cc>
References: <20151124103105.GE1740@breakpoint.cc>
 <20151124103938.GB3014@salvia>
 <20151124105300.GK2310@macbook.localdomain>
 <20151124111029.GH1740@breakpoint.cc>
 <20151124113341.GO2310@macbook.localdomain>
 <20151124151542.GA20972@breakpoint.cc>
 <20151124152649.GK14478@macbook.localdomain>
 <20151124153550.GC20972@breakpoint.cc>
 <20151124154241.GL14478@macbook.localdomain>
 <20151125150640.GE18449@macbook.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:34030 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752630AbbKYQY1 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 25 Nov 2015 11:24:27 -0500
Content-Disposition: inline
In-Reply-To: <20151125150640.GE18449@macbook.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Patrick McHardy <kaber@trash.net> wrote:
> On 24.11, Patrick McHardy wrote:
> > Sounds good. I'm having first success decoding headers using the nft internal
> > protocol structure. Needs more refinement but I expect to have a RFC later
> > today.
> 
> Just FYI, this is my current approach. Still WIP, just so you get the idea,
> in case you'd like to add some comments.
> 
> Basically for the headers, we allocate a constant expression using the
> header data, based on the hook and (not correctly done so far) ethertype
> we set up the proto ctx and start expanding the payload expression.

[..]

> All together this results in a quite small amount of code and reuses the
> parts we have.

Indeed.

> The current downside is mainly the output ordering and verbosity:
> 
> The ordering corresponds to the ordering of the header fields, f.i.:
> 
> trace id 85898000 ip ip length 60 ip id 220 ip ttl 64 ip protocol tcp ip saddr 192.168.122.1 ip daddr 192.168.122.84 tcp sport 39558 tcp dport 10000 iif ens3 
> trace id 85898000 ip filter input verdict 4294967295 iif ens3 
> trace id 85898000 rule tcp dport 10000 nftrace set 1 
> trace id 85898000 ip filter input verdict 4294967295 iif ens3 
> trace id 85898000 rule tcp dport 10000 counter packets 79 bytes 4740 
> trace id 85898000 ip filter input verdict 4294967295 iif ens3 
> trace id 85898000 rule tcp dport 10000 continue 
> trace id 85898000 ip filter input verdict 4294967295 mark 0x00000001 iif ens3 
> trace id 85898000 rule tcp dport 10000 mark set 0x00000001 
> trace id 85898000 ip filter input verdict 1 mark 0x00000001 iif ens3 
> 
> As you can see, the IP addresses are the last two members of the IP header
> that are dumped, which is not really ideal for readability. Not sure how
> to fix that yet. Any ideas?

Hmm, I think it actually increases readability, as all the other lines
you quoted above are a lot shorter the ip saddr part is a lot more
visible.

If nftrace netfilter rules are used properly (ie., with limit statement
or other means to narrow matching down) those long lines even sever as
kind-of delimiter to where a new round of trace output starts without
looking at the id.

As wrt. fixing it, I don't think this should be over-engineered.

I would propose to annotate the address fields in the protocol
description, similar to the filter you added, and then walk
header several times.

1st round dumps source address
2nd round dumps dst address
3rd round dumps the next protocol field
4th round dumps the rest that isn't 'blacklisted' (such as checksum).

Ugly, but given headers differ completely I don't see a better
solution.
Since headers are commonly small the overhead should not be
a big deal.

In case of ethernet, dst is first header field -- not sure if
we should re-order it so that src a:b.. dst d: .. is shown.

If you prefer to keep the real header ordering, then we don't
need to differentiate between these two.

> Comments welcome, especially regarding the current limitations we have.

Looks fantastic, I am leaning towards dropping the header formatting
from libnftl patch entirely.

> +	if (!nftnl_trace_is_set(nlt, attr))
>  		return;

Eeek, sorry about that.

> +static void trace_print_packet(const struct nftnl_trace *nlt)
> +{
> +	struct proto_ctx ctx;
> +
> +	proto_ctx_init(&ctx, nftnl_trace_get_u32(nlt, NFTNL_TRACE_FAMILY));
> +	// NFTA_TRACE_DEV_TYPE

This attribute should be exported already.

The limitation (same as with my patch) is that if we don't know the
value then we cannot pretty-print that L2 header.
I don't think thats a problem, we can just move on to NH.

> +static struct expr *trace_alloc_expr(const struct nftnl_trace *nlt,
> +				     unsigned int attr,
> +				     struct expr *lhs)
> +{
> +	struct expr *rhs, *rel;
> +	const void *data;
> +	uint32_t len;
> +
> +	data = nftnl_trace_get_data(nlt, attr, &len);
> +	rhs  = constant_expr_alloc(&netlink_location,
> +				   lhs->dtype, lhs->byteorder,
> +				   len * BITS_PER_BYTE, data);
> +	rel = relational_expr_alloc(&netlink_location, OP_EQ, lhs, rhs);
> +	expr_print(rel);
> +	printf(" ");
> +	return rel;
>  }
>  
>  static int netlink_events_trace_cb(const struct nlmsghdr *nlh, int type,
> @@ -2194,11 +2254,36 @@ static int netlink_events_trace_cb(const struct nlmsghdr *nlh, int type,
>  	if (nftnl_trace_nlmsg_parse(nlh, nlt) < 0)
>  		netlink_abi_error();
>  
> -	printf("trace ");
> -	nftnl_trace_fprintf(stdout, nlt, monh->format);
> +	printf("trace id %08x ", nftnl_trace_get_u32(nlt, NFTNL_TRACE_ID));
> +
> +	printf("%s ", family2str(nftnl_trace_get_u32(nlt, NFTNL_TRACE_FAMILY)));
> +	if (nftnl_trace_is_set(nlt, NFTNL_TRACE_TABLE))
> +		printf("%s ", nftnl_trace_get_str(nlt, NFTNL_TRACE_TABLE));
> +	if (nftnl_trace_is_set(nlt, NFTNL_TRACE_CHAIN))
> +		printf("%s ", nftnl_trace_get_str(nlt, NFTNL_TRACE_CHAIN));
> +
> +	// type
> +	if (nftnl_trace_is_set(nlt, NFTNL_TRACE_VERDICT))
> +		printf("verdict %u ", nftnl_trace_get_u32(nlt, NFTNL_TRACE_VERDICT));

I am working on this.

Dissecting the verdict will happen in libnftnl, so NFTNL_TRACE_VERDICT will return
a verdict without extra information.

I'll add NFTNL_TRACE_NFQUEUE_ID to store the upper 16 bits for QUEUE verdicts.

> diff --git a/src/proto.c b/src/proto.c
> index 28b93cb..88999a9 100644
> --- a/src/proto.c
> +++ b/src/proto.c
> @@ -503,6 +503,11 @@ const struct proto_desc proto_ip = {
>  		PROTO_LINK(IPPROTO_DCCP,	&proto_dccp),
>  		PROTO_LINK(IPPROTO_SCTP,	&proto_sctp),
>  	},
> +	.filter		= (1 << IPHDR_VERSION) |
> +			  (1 << IPHDR_HDRLENGTH) |
> +			  (1 << IPHDR_TOS) |
> +			  (1 << IPHDR_FRAG_OFF) |
> +			  (1 << IPHDR_CHECKSUM),

Good that we suppress checksum, it will cause lot of confusion
due to offloads anyway.
