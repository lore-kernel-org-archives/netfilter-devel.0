From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 3/7] netfilter: ctnetlink: cleanup message building and
 size	calculation
Date: Tue, 02 Jun 2009 16:52:26 +0200
Message-ID: <4A253CAA.4090906@trash.net>
References: <20090602114933.7677.25219.stgit@Decadence> <20090602115235.7677.91307.stgit@Decadence> <4A252506.9050604@trash.net> <4A253BE1.9090006@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:41495 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752166AbZFBOw3 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 2 Jun 2009 10:52:29 -0400
In-Reply-To: <4A253BE1.9090006@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso wrote:
> Patrick McHardy wrote:
>> This one is really hard to review because of the mixed renames
>> and code movals. Please split this into two patches.
> 
> OK, I'm splitting them now.

Thanks.

>>> +static inline const struct nf_conntrack_tuple *
>>> +nf_ct_tuple(const struct nf_conn *ct, enum ip_conntrack_dir dir)
>>> +{
>>> +    return &ct->tuplehash[dir].tuple;
>>> +}
>> This is a useful helper for other situations as well, so I think
>> it shouldn't be const.
> 
> I get:
> 
> net/netfilter/nf_conntrack_netlink.c:370: warning: passing argument 1 of
> 'nf_ct_tuple' discards qualifiers from pointer target type
> net/netfilter/nf_conntrack_netlink.c:377: warning: passing argument 1 of
> 'nf_ct_tuple' discards qualifiers from pointer target type
> 
> So I have to remove the 'const' from the last parameter of
> ctnetlink_fill_info().
> 
> Or do some ugly casting in the nf_ct_tuple() calls to avoid the warning,
> in that case I would prefer to leave that macro there.
> 
> Please, let me know what you prefer.

The best way is probably to keep using a macro since there's
no other way to handle this properly. But I'm all in favour
of renaming that macro and making it globally available as
you did.

