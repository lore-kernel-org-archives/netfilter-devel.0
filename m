From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH V2] audit: normalize NETFILTER_PKT
Date: Thu, 23 Feb 2017 06:20:15 +0100
Message-ID: <20170223052015.GE11144@breakpoint.cc>
References: <9504740e9333a0b7074abe0dddfc487aeeae6cff.1487813996.git.rgb@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Netfilter Developer Mailing List
        <netfilter-devel@vger.kernel.org>, linux-audit@redhat.com,
        Thomas Graf <tgraf@infradead.org>,
        Eric Paris <eparis@redhat.com>, Paul Moore <pmoore@redhat.com>,
        Steve Grubb <sgrubb@redhat.com>
To: Richard Guy Briggs <rgb@redhat.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:40464 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750877AbdBWFVc (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 23 Feb 2017 00:21:32 -0500
Content-Disposition: inline
In-Reply-To: <9504740e9333a0b7074abe0dddfc487aeeae6cff.1487813996.git.rgb@redhat.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Richard Guy Briggs <rgb@redhat.com> wrote:
> Simplify and eliminate flipping in and out of message fields, relying on nfmark
> the way we do for audit_key.
> 
> +struct nfpkt_par {
> +	int ipv;
> +	const void *saddr;
> +	const void *daddr;
> +	u8 proto;
> +};

This is problematic, see below for why.

> -static void audit_ip4(struct audit_buffer *ab, struct sk_buff *skb)
> +static void audit_ip4(struct audit_buffer *ab, struct sk_buff *skb, struct nfpkt_par *apar)
>  {
>  	struct iphdr _iph;
>  	const struct iphdr *ih;
>  
> +	apar->ipv = 4;
>  	ih = skb_header_pointer(skb, 0, sizeof(_iph), &_iph);
> -	if (!ih) {
> -		audit_log_format(ab, " truncated=1");
> +	if (!ih)
>  		return;

Removing this "truncated" has the consequence that this can later log
"saddr=0.0.0.0 daddr=0.0.0.0" if we return here.

This cannot happen for ip(6)tables because ip stack discards broken l3 headers
before the netfilter hooks get called, but its possible with NFPROTO_BRIDGE.

Perhaps you will need to change audit_ip4/6 to return "false" when it can't
get the l3 information now so we only log zero addresses when the packet
really did contain them.

> -	audit_log_format(ab, " saddr=%pI4 daddr=%pI4 ipid=%hu proto=%hhu",
> -		&ih->saddr, &ih->daddr, ntohs(ih->id), ih->protocol);

Alternatively, one could keep this around. In fact, why is this (re)moved
in first place?  This move of audit_log_format() seems to only reason
why *apar struct is required.

AFAICS this now does:
  ab = new()
  log(ab, mark);
  audit_ip4(&apar);
  log(&apar);

so might as well keep the log() call within the audit_ip4/6 function.

> -	audit_proto(ab, skb, ih->protocol, ih->ihl * 4);
> +	apar->saddr = &ih->saddr;
> +	apar->daddr = &ih->daddr;
> +	apar->proto = ih->protocol;
>  }

Caution.  skb_header_pointer() may copy from non-linear skb part
into _iph, which is on stack, so apar->saddr may be stale once
function returns. So if you really want to remove the audit_log_format()
of the saddr/daddr then you need to copy the ip addresses here.

(We guarantee its linear for ip stack but not for NFPROTO_BRIDGE and this function
is also called for the bridge version of the target).

>  static unsigned int
>  audit_tg(struct sk_buff *skb, const struct xt_action_param *par)
>  {
> -	const struct xt_audit_info *info = par->targinfo;
>  	struct audit_buffer *ab;
> +	struct nfpkt_par apar = {
> +		-1, NULL, NULL, -1,
> +	};

I suggest to use
	struct nfpkt_par apar = {
		.family = par->family,
	};

if apar is required for some reason.

>  	ab = audit_log_start(NULL, GFP_ATOMIC, AUDIT_NETFILTER_PKT);
>  	if (ab == NULL)
>  		goto errout;
>  
> -	audit_log_format(ab, "action=%hhu hook=%u len=%u inif=%s outif=%s",
> -			 info->type, par->hooknum, skb->len,
> -			 par->in ? par->in->name : "?",
> -			 par->out ? par->out->name : "?");
> -
> -	if (skb->mark)
> -		audit_log_format(ab, " mark=%#x", skb->mark);
> +	audit_log_format(ab, " mark=%#x", skb->mark ?: -1);

-1 will be logged as 0xffffffff, no?  whats wrong with
	audit_log_format(ab, " mark=%#x", skb->mark); ?

>  	if (skb->dev && skb->dev->type == ARPHRD_ETHER) {
> -		audit_log_format(ab, " smac=%pM dmac=%pM macproto=0x%04x",
> -				 eth_hdr(skb)->h_source, eth_hdr(skb)->h_dest,
> -				 ntohs(eth_hdr(skb)->h_proto));
> -

This ARPHDR_ETHER test is no longer needed after logging
of ether addresses is removed.
