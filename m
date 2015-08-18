From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next v5 2/2] netfilter: nf_conntrack: add efficient
 mark to zone mapping
Date: Wed, 19 Aug 2015 01:05:56 +0200
Message-ID: <20150818230556.GB17497@salvia>
References: <cover.1439559328.git.daniel@iogearbox.net>
 <bd41c7f8120e86cde496acc43feea600ad3537cb.1439559328.git.daniel@iogearbox.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tgraf@suug.ch, challa@noironetworks.com,
	netfilter-devel@vger.kernel.org
To: Daniel Borkmann <daniel@iogearbox.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:60565 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750893AbbHRW7o (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 18 Aug 2015 18:59:44 -0400
Content-Disposition: inline
In-Reply-To: <bd41c7f8120e86cde496acc43feea600ad3537cb.1439559328.git.daniel@iogearbox.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Aug 14, 2015 at 04:03:40PM +0200, Daniel Borkmann wrote:
> This work adds the possibility of deriving the zone id from the skb->mark
> field in a scalable manner. This allows for having only a single template
> serving hundreds/thousands of different zones, for example, instead of the
> need to have one match for each zone as an extra CT jump target.
> 
> Note that we'd need to have this information attached to the template as at
> the time when we're trying to lookup a possible ct object, we already need
> to know zone information for a possible match when going into
> __nf_conntrack_find_get(). This work provides a minimal implementation for
> a possible mapping.
> 
> In order to not add/expose an extra ct->status bit, the zone structure has
> been extended to carry a flag for deriving the mark.

Also applied, thanks. A slightly large comment below though.

[...]
> diff --git a/net/ipv4/netfilter/nf_conntrack_proto_icmp.c b/net/ipv4/netfilter/nf_conntrack_proto_icmp.c
> index 8a2f41c..cdde3ec 100644
> --- a/net/ipv4/netfilter/nf_conntrack_proto_icmp.c
> +++ b/net/ipv4/netfilter/nf_conntrack_proto_icmp.c
> @@ -135,9 +135,10 @@ icmp_error_message(struct net *net, struct nf_conn *tmpl, struct sk_buff *skb,
>  	const struct nf_conntrack_l4proto *innerproto;
>  	const struct nf_conntrack_tuple_hash *h;
>  	const struct nf_conntrack_zone *zone;
> +	struct nf_conntrack_zone tmp;
>  
>  	NF_CT_ASSERT(skb->nfct == NULL);
> -	zone = nf_ct_zone_tmpl(tmpl);
> +	zone = nf_ct_zone_tmpl(tmpl, skb, &tmp);

This change to nf_ct_zone_tmpl() is OK by now. I can see you're doing
this because we cannot use the template object to perform tmpl->mark =
skb->mark since the template is shared between all packets.

However, this is showing the limitations that we have in iptables
since we can't do mappings there, with nft we could do things in the
near future that look like:

        meta mark { 0x123 : ct template zone 1, ... }

I think this can be refined by having a scratchpad template object
per-cpu that we can modify from the CT target. This will also resolve
the existing limitations that we have: Only the first rule that uses
the CT target to attach a template actually applies, follow up rules
trying to attach a template are simply ignored.

This per-cpu template object should have a zone and timeout extension
area preallocated, so we skip that memory allocation overhead from the
packet path. Another alternative can be to add a struct nf_conn_tmpl
object whose layout until the status flag is the same, so we can place
the configuration there without the need of the extension areas, a
trick similar to what we have with reqsock and twsock objects.

Would you have a look into this so we can get this in better shape and
resolve the existing limitations by the next merge window? Thanks!
