From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 3/7] netfilter: ctnetlink: cleanup message building and
 size	calculation
Date: Tue, 02 Jun 2009 16:49:05 +0200
Message-ID: <4A253BE1.9090006@netfilter.org>
References: <20090602114933.7677.25219.stgit@Decadence> <20090602115235.7677.91307.stgit@Decadence> <4A252506.9050604@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:59051 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752544AbZFBOtN (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 2 Jun 2009 10:49:13 -0400
In-Reply-To: <4A252506.9050604@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Patrick McHardy wrote:
> Pablo Neira Ayuso wrote:
>> This patch is a cleanup. It removes unneeded verbose information
>> about the size calculation and it also replaces the old macros
>> to build Netlink messages with the new nlmsg_*() helper functions.
> 
> This one is really hard to review because of the mixed renames
> and code movals. Please split this into two patches.

OK, I'm splitting them now.

>> diff --git a/include/net/netfilter/nf_conntrack.h
>> b/include/net/netfilter/nf_conntrack.h
>> index 6c3f964..9aafe70 100644
>> --- a/include/net/netfilter/nf_conntrack.h
>> +++ b/include/net/netfilter/nf_conntrack.h
>> @@ -144,6 +144,12 @@ static inline u_int8_t nf_ct_protonum(const
>> struct nf_conn *ct)
>>      return ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.dst.protonum;
>>  }
>>  
>> +static inline const struct nf_conntrack_tuple *
>> +nf_ct_tuple(const struct nf_conn *ct, enum ip_conntrack_dir dir)
>> +{
>> +    return &ct->tuplehash[dir].tuple;
>> +}
> 
> This is a useful helper for other situations as well, so I think
> it shouldn't be const.

I get:

net/netfilter/nf_conntrack_netlink.c:370: warning: passing argument 1 of
'nf_ct_tuple' discards qualifiers from pointer target type
net/netfilter/nf_conntrack_netlink.c:377: warning: passing argument 1 of
'nf_ct_tuple' discards qualifiers from pointer target type

So I have to remove the 'const' from the last parameter of
ctnetlink_fill_info().

Or do some ugly casting in the nf_ct_tuple() calls to avoid the warning,
in that case I would prefer to leave that macro there.

Please, let me know what you prefer.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
