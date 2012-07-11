From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH v2 3/3] ipset: change 'iface' part in hash:net,iface
 set
Date: Wed, 11 Jul 2012 22:25:38 +0200 (CEST)
Message-ID: <alpine.DEB.2.00.1207112154070.26540@blackhole.kfki.hu>
References: <cover.1341871199.git.mr.dash.four@googlemail.com> <1341872622-5015-2-git-send-email-mr.dash.four@googlemail.com> <alpine.DEB.2.00.1207101721510.24998@blackhole.kfki.hu> <4FFCBDB8.9080101@googlemail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Core Team <netfilter-devel@vger.kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Patrick McHardy <kaber@trash.net>
To: Mr Dash Four <mr.dash.four@googlemail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp1.kfki.hu ([148.6.0.26]:56427 "EHLO smtp1.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752109Ab2GKUZl (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 11 Jul 2012 16:25:41 -0400
In-Reply-To: <4FFCBDB8.9080101@googlemail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, 11 Jul 2012, Mr Dash Four wrote:

> >> +	IPSET_DIM_IFACE = 7, 
> >>  };
> > 
> > It's not a dimension, please give it some other name,
> > like IPSET_IFACE_INOUT_FLAG.
> A bit like you then. Unless you think that including IPSET_DUMP_LAST in 
> the "features" enum list describes an actual feature. Point taken 
> though, will change it to something more appropriate.

IPSET_DUMP_LAST is not named like IPSET_TYPE_DUMP_LAST, exactly because 
it's not a feature.
 
> >> +struct ip_set_req_get_features {
> >> +	unsigned int op;
> >> +	unsigned int version;
> >> +	__u8 features;
> >> +	union ip_set_name_index set;
> >> +};
> >> +
> > 
> > In spite of stuffing a u8 sized value into features, please make it an
> > unsigned int. We don't spare anything with __u8 here.

> We do. In ip_set.h, "features" is defines as u8 (a byte), so I am not 
> "stuffing" anything up - I just use the same type of variable.

I wrote "We don't spare anything with __u8 here", i.e. in the size of the 
ip_set_req_get_features structure. With __u8 there'd be a hole in it. 

> Besides, you are well-aware that I store this in info->flags, which is 
> also __u8 (a byte).

I wrote also that do not store the passed features in info->flags but 
define get_set_byname_with_features as non-void and just return the 
feature value by it.

> If I use unsigned int (a word), then I have to do extra 
> jiggling to get rid of the bits I don't need.

You can cast it back and forth, because the value is limited to u8.
 
> Not to mention, that "features" as defined above currently contains a 
> single bit (the IFACE feature), so to me, given the potential hazards I 
> just described, it wasn't warranting unsigned int, unless you plan on 
> expanding the "features" variable and use the same struct above.

I also wrote that probably it's better to pass the full feature value, not 
just the singe IPSET_TYPE_IFACE bit from it.
 
> >>  #define IP_SET_OP_VERSION	0x00000100	/* Ask kernel version */
> >>  struct ip_set_req_version {
> >>  	unsigned int op;
> >> diff --git a/net/netfilter/ipset/ip_set_bitmap_ipmac.c b/net/netfilter/ipset/ip_set_bitmap_ipmac.c
> >> index d7eaf10..1d8d754 100644
> >> --- a/net/netfilter/ipset/ip_set_bitmap_ipmac.c
> >> +++ b/net/netfilter/ipset/ip_set_bitmap_ipmac.c
> >> @@ -348,6 +348,10 @@ bitmap_ipmac_kadt(struct ip_set *set, const struct sk_buff *skb,
> >>  	ipset_adtfn adtfn = set->variant->adt[adt];
> >>  	struct ipmac data;
> >>  
> >> +	/* in|out not allowed in this set type, only src|dst */
> >> +	if (opt->flags & IPSET_DIM_IFACE_INOUT)
> >> +		return -EINVAL;
> >> +
> > 
> > Drop this unnecessary checking: ipset doesn't care about iptables syntax.

> This was a left-over from v1 of the patch and served to restrict 
> matching when 'in' or 'out' is used in a list:set, or, when 'in' or 
> 'out' was entered in 2+ dimensional sets as I didn't have the means to 
> see what type of set I am dealing with in iptables.
> 
> Now that the latter is being resolved via the 
> get_set_byname_with_features function, I would still like to keep this 
> and relax the restriction for 'in' and 'out' on the list:set as I am yet 
> to get a reasonable and adequate explanation as to why that should not 
> be allowed (the use of 'in' and 'out' in list:set)?
 
Go back and read my answer. I won't repeat myself any more again and again 
and again.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
