From: Mr Dash Four <mr.dash.four@googlemail.com>
Subject: Re: [PATCH v2 3/3] ipset: change 'iface' part in hash:net,iface set
Date: Wed, 11 Jul 2012 00:41:44 +0100
Message-ID: <4FFCBDB8.9080101@googlemail.com>
References: <cover.1341871199.git.mr.dash.four@googlemail.com> <1341872622-5015-2-git-send-email-mr.dash.four@googlemail.com> <alpine.DEB.2.00.1207101721510.24998@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Netfilter Core Team <netfilter-devel@vger.kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Patrick McHardy <kaber@trash.net>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wg0-f42.google.com ([74.125.82.42]:40161 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755115Ab2GJXls (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 10 Jul 2012 19:41:48 -0400
Received: by wgbds11 with SMTP id ds11so4074756wgb.1
        for <netfilter-devel@vger.kernel.org>; Tue, 10 Jul 2012 16:41:47 -0700 (PDT)
In-Reply-To: <alpine.DEB.2.00.1207101721510.24998@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

>> +	IPSET_DIM_IFACE = 7, 
>>  };
> 
> It's not a dimension, please give it some other name,
> like IPSET_IFACE_INOUT_FLAG.
A bit like you then. Unless you think that including IPSET_DUMP_LAST in the "features" enum list describes an actual feature. Point taken though, will change it to something more appropriate.

>> +struct ip_set_req_get_features {
>> +	unsigned int op;
>> +	unsigned int version;
>> +	__u8 features;
>> +	union ip_set_name_index set;
>> +};
>> +
> 
> In spite of stuffing a u8 sized value into features, please make it an
> unsigned int. We don't spare anything with __u8 here.
We do. In ip_set.h, "features" is defines as u8 (a byte), so I am not "stuffing" anything up - I just use the same type of variable. Besides, you are well-aware that I store this in info->flags, which is also __u8 (a byte). If I use unsigned int (a word), then I have to do extra jiggling to get rid of the bits I don't need. 

Not to mention, that "features" as defined above currently contains a single bit (the IFACE feature), so to me, given the potential hazards I just described, it wasn't warranting unsigned int, unless you plan on expanding the "features" variable and use the same struct above.


> 
>>  #define IP_SET_OP_VERSION	0x00000100	/* Ask kernel version */
>>  struct ip_set_req_version {
>>  	unsigned int op;
>> diff --git a/net/netfilter/ipset/ip_set_bitmap_ipmac.c b/net/netfilter/ipset/ip_set_bitmap_ipmac.c
>> index d7eaf10..1d8d754 100644
>> --- a/net/netfilter/ipset/ip_set_bitmap_ipmac.c
>> +++ b/net/netfilter/ipset/ip_set_bitmap_ipmac.c
>> @@ -348,6 +348,10 @@ bitmap_ipmac_kadt(struct ip_set *set, const struct sk_buff *skb,
>>  	ipset_adtfn adtfn = set->variant->adt[adt];
>>  	struct ipmac data;
>>  
>> +	/* in|out not allowed in this set type, only src|dst */
>> +	if (opt->flags & IPSET_DIM_IFACE_INOUT)
>> +		return -EINVAL;
>> +
> 
> Drop this unnecessary checking: ipset doesn't care about iptables syntax.
This was a left-over from v1 of the patch and served to restrict matching when 'in' or 'out' is used in a list:set, or, when 'in' or 'out' was entered in 2+ dimensional sets as I didn't have the means to see what type of set I am dealing with in iptables. 

Now that the latter is being resolved via the get_set_byname_with_features function, I would still like to keep this and relax the restriction for 'in' and 'out' on the list:set as I am yet to get a reasonable and adequate explanation as to why that should not be allowed (the use of 'in' and 'out' in list:set)?

It gives me, as a user, a choice when I have a list:set with many different set types in it to apply that restriction (checking on in/out interfaces only) and use it when needed, instead of being restricted to just src/dst and have ipset reiterate through all members of each set - unnecessarily, when in practice I would have liked a match on the iface-type sets only. 

It also forces me to use two separate list:sets with duplicate members: one for the occasion when I want to use src/dst and match against all members of the set, and another, duplicate copy, which contains just the iface sets so that I could get a match just on them. Wasteful!

If I have a choice to use in/out, in addition to src/dst, I can deploy a single set (saves on memory and scanning is faster) and use this - it is much more elegant. 

The use of in/out is not in any way restrictive as whoever deploys it, clearly has a choice (I'd argue that the use of just src/dst is more restrictive as it doesn't give me that choice). That use of in/out can't be "confusing" either as the definition of it and what it matches against is pretty clear for everyone.

Just a couple of days ago you wanted to introduce in/out direction parameters everywhere - in every set and in every direction parameter. I would argue that was more confusing and hardly appropriate, if anything.

>> +static ip_set_id_t
>> +find_set_features(const char *name, __u8 *features)
>> +{
>> +	ip_set_id_t i, index = IPSET_INVALID_ID;
>> +	const struct ip_set *set;
>> +
>> +	for (i = 0; index == IPSET_INVALID_ID && i < ip_set_max; i++) {
>> +		set = ip_set_list[i];
>> +		if (set != NULL && STREQ(set->name, name)) {
>> +			index = i;
>> +			/* In theory, we could return the entire set of features
>> +			 * for a given set, though, for now, we only return 
>> +			 * the IPSET_TYPE_IFACE bit
>> +			 */
>> +			*features = set->type->features & IPSET_TYPE_IFACE;
> 
> I believe it's better to return the entire feature, not just 
> IPSET_TYPE_IFACE.
Agreed, though with the added caveat about versioning and the use of new parse/print etc functions - see my comments on this in the other email (about the iptables patch).

>> -	if (!ip_set_get_ip4_port(skb, opt->flags & IPSET_DIM_TWO_SRC,
>> +	if ((opt->flags & IPSET_DIM_IFACE_INOUT) || /* in|out not allowed in this set type, only src|dst */
>> +		!ip_set_get_ip4_port(skb, opt->flags & IPSET_DIM_TWO_SRC,
>>  				 &data.port, &data.proto))
>>  		return -EINVAL;
> 
> Drop this and all other checkings below:
See above - I'd like to keep it and relax the restrictions placed upon the list:set.

