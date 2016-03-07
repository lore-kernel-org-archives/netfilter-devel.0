From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCHv2] extensions: libip6t_icmp6: Add translation to nft
Date: Mon, 7 Mar 2016 19:25:04 +0100
Message-ID: <20160307182504.GA7325@salvia>
References: <20160306222308.GA20846@sonyv>
 <20160307171119.GA29573@salvia>
 <20160307180850.GB22851@sonyv>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, shivanib134@gmail.com,
	outreachy-kernel@googlegroups.com
To: Laura Garcia <nevola@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:58948 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753102AbcCGSZM (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 7 Mar 2016 13:25:12 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id A3B8313C0E7
	for <netfilter-devel@vger.kernel.org>; Mon,  7 Mar 2016 19:25:11 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 96FA5DA399
	for <netfilter-devel@vger.kernel.org>; Mon,  7 Mar 2016 19:25:11 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 94D20DA385
	for <netfilter-devel@vger.kernel.org>; Mon,  7 Mar 2016 19:25:09 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20160307180850.GB22851@sonyv>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Mar 07, 2016 at 07:08:51PM +0100, Laura Garcia wrote:
> On Mon, Mar 07, 2016 at 06:11:19PM +0100, Pablo Neira Ayuso wrote:
> > 
> > #define XT_ICMPV6_TYPE(type)    (ND_ROUTER_SOLICIT - type)
> > 
> > static const char *icmp6_type_xlate_array[] = {
> >         [XT_ICMPV6_TYPE(ND_ROUTER_SOLICIT))]    = "nd-router-solicit",
> >         [XT_ICMPV6_TYPE(ND_ROUTER_ADVERT)]      = "nd-router-advert",
> >         ...
> >         [XT_ICMPV6_TYPE(ND_REDIRECT)]           = "nd-redirect",
> > };
> > 
> > static const char *icmp6_type_xlate(unsigned int type)
> > {
> >         unsigned type
> > 
> >         if (type < ND_ROUTER_SOLICIT || type > ND_REDIRECT))
> >                 return NULL;
> > 
> >         return icmp6_type_xlate_array[XT_ICMPV6_TYPE(type)];
> > }
> > 
> > Then, from type_xlate_print() use this icmp6_type_xlate().
> > 
> 
> Ok
> 
> > > +	default:
> > > +		for (i = 0; ARRAY_SIZE(icmpv6_codes); ++i)
> >                                                            ^
> > BTW, missing opening bracket here
> > 
> > > +			if (icmpv6_codes[i].type == icmptype &&
> > > +			    icmpv6_codes[i].code_min == code_min &&
> > > +			    icmpv6_codes[i].code_max == code_max)
> > > +				break;
> > > +			xt_xlate_add(xl, icmpv6_codes[i].name);
> > 
> > and closing bracket here '}'
> > 
> > BTW, do you really need this code now that we just skip when we get an
> > icmp code?
> > 
> 
> Same thing here, the brackets are not needed. It's only a indentation
> problem in the function xt_xlate_add.

Ok, thanks for explaining.

Please, send a v3 with the proposed changes above and resubmit.
Thanks.
