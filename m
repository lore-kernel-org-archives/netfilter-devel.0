From: Laura Garcia <nevola@gmail.com>
Subject: Re: [PATCHv2] extensions: libip6t_icmp6: Add translation to nft
Date: Mon, 7 Mar 2016 19:08:51 +0100
Message-ID: <20160307180850.GB22851@sonyv>
References: <20160306222308.GA20846@sonyv>
 <20160307171119.GA29573@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, shivanib134@gmail.com,
	outreachy-kernel@googlegroups.com
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f48.google.com ([74.125.82.48]:35871 "EHLO
	mail-wm0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753411AbcCGSI4 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 7 Mar 2016 13:08:56 -0500
Received: by mail-wm0-f48.google.com with SMTP id n186so98190652wmn.1
        for <netfilter-devel@vger.kernel.org>; Mon, 07 Mar 2016 10:08:55 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <20160307171119.GA29573@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Mar 07, 2016 at 06:11:19PM +0100, Pablo Neira Ayuso wrote:
> On Sun, Mar 06, 2016 at 11:23:10PM +0100, Laura Garcia Liebana wrote:
> > Add translation for icmpv6 to nftables. Not supported types in nftables
> > are: no-route, communication-prohibited, beyond-scope,
> > address-unreachable, port-unreachable, failed-policy, reject-route,
> > ttl-zero-during-transit, ttl-zero-during-reassembly, bad-header,
> > unknown-header-type and unknown-option.
> > 
> > Examples:
> > 
> > $ ip6tables-translate -t filter -A INPUT -m icmp6 --icmpv6-type 1 -j LOG
> > nft add rule ip6 filter INPUT icmpv6 type destination-unreachable counter log level warn
> > 
> > $ ip6tables-translate -t filter -A INPUT -m icmp6 --icmpv6-type neighbour-advertisement -j LOG
> > nft add rule ip6 filter INPUT icmpv6 type nd-neighbor-advert counter log level warn
> > 
> > $ ip6tables-translate -t filter -A INPUT -m icmp6 ! --icmpv6-type packet-too-big -j LOG
> > nft add rule ip6 filter INPUT icmpv6 type != packet-too-big counter log level warn
> > 
> > Signed-off-by: Laura Garcia Liebana <nevola@gmail.com>
> > ---
> > v2:
> > 	- Detection of not supported types in nftables, as Shivani suggested.
> > 
> >  extensions/libip6t_icmp6.c | 53 ++++++++++++++++++++++++++++++++++++++++++++++
> >  1 file changed, 53 insertions(+)
> > 
> > diff --git a/extensions/libip6t_icmp6.c b/extensions/libip6t_icmp6.c
> > index e183ce6..70f9c21 100644
> > --- a/extensions/libip6t_icmp6.c
> > +++ b/extensions/libip6t_icmp6.c
> > @@ -222,6 +222,58 @@ static void icmp6_save(const void *ip, const struct xt_entry_match *match)
> >  		printf("/%u", icmpv6->code[0]);
> >  }
> >  
> > +static unsigned int type_xlate_print(struct xt_xlate *xl, unsigned int icmptype,
> > +			     unsigned int code_min, unsigned int code_max)
> > +{
> > +	unsigned int i;
> > +
> > +	if (code_min == code_max)
> > +		return 0;
> > +
> > +	switch (icmptype) {
> > +	case 133:
> > +		xt_xlate_add(xl, "nd-router-solicit");
> > +		break;
> > +	case 134:
> > +		xt_xlate_add(xl, "nd-router-advert");
> > +		break;
> > +	case 135:
> > +		xt_xlate_add(xl, "nd-neighbor-solicit");
> > +		break;
> > +	case 136:
> > +		xt_xlate_add(xl, "nd-neighbor-advert");
> > +		break;
> > +	case 137:
> > +		xt_xlate_add(xl, "nd-redirect");
> > +		break;
> 
> Could you generalize this code a bit?
> 
> #define XT_ICMPV6_TYPE(type)    (ND_ROUTER_SOLICIT - type)
> 
> static const char *icmp6_type_xlate_array[] = {
>         [XT_ICMPV6_TYPE(ND_ROUTER_SOLICIT))]    = "nd-router-solicit",
>         [XT_ICMPV6_TYPE(ND_ROUTER_ADVERT)]      = "nd-router-advert",
>         ...
>         [XT_ICMPV6_TYPE(ND_REDIRECT)]           = "nd-redirect",
> };
> 
> static const char *icmp6_type_xlate(unsigned int type)
> {
>         unsigned type
> 
>         if (type < ND_ROUTER_SOLICIT || type > ND_REDIRECT))
>                 return NULL;
> 
>         return icmp6_type_xlate_array[XT_ICMPV6_TYPE(type)];
> }
> 
> Then, from type_xlate_print() use this icmp6_type_xlate().
> 

Ok

> > +	default:
> > +		for (i = 0; ARRAY_SIZE(icmpv6_codes); ++i)
>                                                            ^
> BTW, missing opening bracket here
> 
> > +			if (icmpv6_codes[i].type == icmptype &&
> > +			    icmpv6_codes[i].code_min == code_min &&
> > +			    icmpv6_codes[i].code_max == code_max)
> > +				break;
> > +			xt_xlate_add(xl, icmpv6_codes[i].name);
> 
> and closing bracket here '}'
> 
> BTW, do you really need this code now that we just skip when we get an
> icmp code?
> 

Same thing here, the brackets are not needed. It's only a indentation
problem in the function xt_xlate_add.

This piece is not for icmp codes, but icmp types. We're ensuring that
at the begining of the function:

+   if (code_min == code_max)
+           return 0;


> > +	}
> > +
> > +	return 1;
> > +}
> > +
> > +static int icmp6_xlate(const struct xt_entry_match *match, struct xt_xlate *xl,
> > +		       int numeric)
> > +{
> > +	const struct ip6t_icmp *info = (struct ip6t_icmp *)match->data;
> > +
> > +	xt_xlate_add(xl, "icmpv6 type%s ",
> > +		     (info->invflags & IP6T_ICMP_INV) ? " !=" : "");
> > +
> > +	if (!type_xlate_print(xl, info->type, info->code[0], info->code[1]))
> > +		return 0;
> > +
> > +	xt_xlate_add(xl, " ");
> > +
> > +	return 1;
> > +}
> > +
> >  static struct xtables_match icmp6_mt6_reg = {
> >  	.name 		= "icmp6",
> >  	.version 	= XTABLES_VERSION,
> > @@ -234,6 +286,7 @@ static struct xtables_match icmp6_mt6_reg = {
> >  	.save		= icmp6_save,
> >  	.x6_parse	= icmp6_parse,
> >  	.x6_options	= icmp6_opts,
> > +	.xlate		= icmp6_xlate,
> >  };
> >  
> >  void _init(void)
> > -- 
> > 2.7.0
> > 
