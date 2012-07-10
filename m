From: Mr Dash Four <mr.dash.four@googlemail.com>
Subject: Re: [PATCH v2 1/3] iptables: change 'iface' part in hash:net,iface
 set
Date: Wed, 11 Jul 2012 00:41:33 +0100
Message-ID: <4FFCBDAD.5010206@googlemail.com>
References: <cover.1341871199.git.mr.dash.four@googlemail.com> <09f86300bb1913aa4c6063618fbbcd84fac2e608.1341871200.git.mr.dash.four@googlemail.com> <alpine.DEB.2.00.1207101735540.24998@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Netfilter Core Team <netfilter-devel@vger.kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Patrick McHardy <kaber@trash.net>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:44732 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755210Ab2GJXlj (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 10 Jul 2012 19:41:39 -0400
Received: by weyx8 with SMTP id x8so449213wey.19
        for <netfilter-devel@vger.kernel.org>; Tue, 10 Jul 2012 16:41:37 -0700 (PDT)
In-Reply-To: <alpine.DEB.2.00.1207101735540.24998@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

>> @@ -206,15 +206,20 @@ print_target(const char *prefix, const struct xt_set_info *info)
>>  {
>>  	int i;
>>  	char setname[IPSET_MAXNAMELEN];
>> +	char *ptr;
>>  
>>  	if (info->index == IPSET_INVALID_ID)
>>  		return;
>>  	get_set_byid(setname, info->index);
>>  	printf(" %s %s", prefix, setname);
>>  	for (i = 1; i <= info->dim; i++) {
>> +		if ((info->flags & IPSET_DIM_IFACE_INOUT) && i == IPSET_DIM_TWO)
>> +			ptr = (info->flags & (1 << i) ? "in" : "out");
>> +		else
>> +			ptr = (info->flags & (1 << i) ? "src" : "dst");
>>  		printf("%s%s",
>>  		       i == 1 ? " " : ",",
>> -		       info->flags & (1 << i) ? "src" : "dst");
>> +			ptr);
>>  	}
>>  }
> 
> Introduce a new, revision 3 target with its own parse, print functions.
> Don't forget to add it to the kernel part.
I am not completely clear I understand you. 

If I introduce a new version and register it with the kernel, how is the "new iptables - old kernel" combination going to function? Similarly, if I rename the new functions to something else, won't that cause compatibility issues where other programs are going to look for these functions (from what I remember these functions are defined in the C header files, so, potentially, after this change they are bound to break something!). Could you elaborate a bit more please?


>> -specifications and there can be no more than six of them.
>> +with the exception of hash:ip,iface where in addition to the above flags, the following is also allowed for the 'iface' part of that set:
> 
> Too long line, please break these up.
I tried to do that initially, but the man page, when displayed, gives me long spaces in the places where I have inserted a new lines, which I find rather annoying. Is this a "feature" of the man (the program), or is there a way to avoid all this? That was the sole reason to collapse everything and use single lines (I have done this across all man pages).

>> @@ -182,9 +183,13 @@ print_match(const char *prefix, const struct xt_set_info *info)
>>  	       prefix,
>>  	       setname); 
>>  	for (i = 1; i <= info->dim; i++) {		
>> +		if ((info->flags & IPSET_DIM_IFACE_INOUT) && i == IPSET_DIM_TWO)
>> +			ptr = (info->flags & (1 << i) ? "in" : "out");
>> +		else
>> +			ptr = (info->flags & (1 << i) ? "src" : "dst");
>>  		printf("%s%s",
>>  		       i == 1 ? " " : ",",
>> -		       info->flags & (1 << i) ? "src" : "dst");
>> +		       ptr);
>>  	}
>>  }
> 
> Introduce a new, revision 2 match with its own parse, print functions and 
> add it to the kernel part as well.
See above - I need to understand how this works and how the compatibility is protected.

>> +	if (res != 0 && errno== EBADMSG) { /* IP_SET_OP_GET_FEATURES not supported, revert back to IP_SET_OP_GET_BYNAME */
>> +		get_set_byname(setname, info);
> 
> With the new target/match revisions, there's no need to call the old 
> interface.
Agreed. It was done solely for compatibility reasons just in case "new iptables - old kernel" combination is used, since I am not clear how the new "versioning" is going to work.

>> +		info->index = req.set.index;
>> +		info->flags |= req.features;
> 
> Better do not mix the received features with the info flags. Make 
> get_set_byname_with_features non-void and just return the value to the 
> caller.
Again, this was done out of necessity as: 1) I only used a single bit from "features" and didn't need anything else; 2) The "features" itself was __u8, so that variable was adequate to hold whatever information I wanted from that function; and 3) this was done for the sake of compatibility as I didn't know if I introduce changes to this function whether anything else is going to brake (I am sure Mr Engelhardt would have been on my case in an instant if that was so). 

Provided I could use a new version and know the implications of that, of course, I'll change it and use the new version.

> Keep the old parse_dir (rename to parse_dirs_v1) and introduce a new one. 
> Isn't there a comma missing from the error message, i.e:
> 
> You must specify (comma separated list of) src'|'dst',
> or 'in'|'out' just for the interface part of hash:net,iface set, if used.
> 
> And maybe it'd be good to print it in two lines, like here.
No, I have something different in mind, which is much better and will be introduced with the next set of patches.

>> +	IPSET_DIM_IFACE = 7, 
>>  };
> 
> Rename here and below.
Noted, will do.

>> +/* Set features */
>> +enum ip_set_feature {
>> +	IPSET_TYPE_IP_FLAG = 0,
>> +	IPSET_TYPE_IP = (1 << IPSET_TYPE_IP_FLAG),
>> +	IPSET_TYPE_PORT_FLAG = 1,
>> +	IPSET_TYPE_PORT = (1 << IPSET_TYPE_PORT_FLAG),
>> +	IPSET_TYPE_MAC_FLAG = 2,
>> +	IPSET_TYPE_MAC = (1 << IPSET_TYPE_MAC_FLAG),
>> +	IPSET_TYPE_IP2_FLAG = 3,
>> +	IPSET_TYPE_IP2 = (1 << IPSET_TYPE_IP2_FLAG),
>> +	IPSET_TYPE_NAME_FLAG = 4,
>> +	IPSET_TYPE_NAME = (1 << IPSET_TYPE_NAME_FLAG),
>> +	IPSET_TYPE_IFACE_FLAG = 5,
>> +	IPSET_TYPE_IFACE = (1 << IPSET_TYPE_IFACE_FLAG),
>> +	/* Strictly speaking not a feature, but a flag for dumping:
>> +	 * this settype must be dumped last */
>> +	IPSET_DUMP_LAST_FLAG = 7,
>> +	IPSET_DUMP_LAST = (1 << IPSET_DUMP_LAST_FLAG),
>> +};
> 
> The header files in include/linux/netfilter are the same as the kernel 
> ones with the parts protected by "#ifdef __KERNEL__" ripped out. So please
> move this enum definition in the kernel include file outside of the kernel 
> specific part, according to the placement here. 
I am not sure I understand this either! This is iptables' ip_set.h (userspace) and is more-or-less a carbon copy of the "essential" data structures from the "real" ip_set.h from ipset (kernel).  Could you clarify please?

>> +#define IP_SET_OP_GET_FEATURES	0x00000008	/* Get set features by name */
>> +struct ip_set_req_get_features {
>> +	unsigned int op;
>> +	unsigned int version;
>> +	__u8 features;
>> +	union ip_set_name_index set;
>> +};
> 
> Let features be unsigned int here too.
As I already explained, the original "features" field from the ip_set struct, I think, has u8 (a byte), not unsigned int (a word). If I had introduced it, I would have broken half the code in the parse/print functions. I still don't see any sense in encapsulating something which is u8 (features in ip_set struct) as unsigned int here. Why would you want to do this Jozsef?

