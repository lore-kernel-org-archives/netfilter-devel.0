From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] netfilter: nf_conntrack_tstamp: add flow-based timestamp
 extension
Date: Fri, 14 Jan 2011 13:15:20 +0100
Message-ID: <4D303E58.40703@trash.net>
References: <20110113123030.3407.59986.stgit@decadence> <4D2F4E1F.4070403@trash.net> <4D303A7D.30002@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:34078 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757107Ab1ANMPV (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 14 Jan 2011 07:15:21 -0500
In-Reply-To: <4D303A7D.30002@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 14.01.2011 12:58, Pablo Neira Ayuso wrote:
>>> +static inline
>>> +struct nf_conn_tstamp *nf_ct_tstamp_ext_add(struct nf_conn *ct, gfp_t gfp)
>>> +{
>>> +	struct net *net = nf_ct_net(ct);
>>> +
>>> +	if (!net->ct.sysctl_tstamp)
>>> +		return NULL;
>>> +
>>> +	return nf_ct_ext_add(ct, NF_CT_EXT_TSTAMP, gfp);
>>
>> How about making this configurable at compile time to avoid any overhead
>> (memory in ct_extend and runtime) for anyone not needing it like most
>> of the other ct_extend options?
> 
> I'm fine with this, I'll add it.
> 
> Looking at the source, should we do the same with the accounting? I
> remember that we decided to remove this compile-time option time ago.

I see no reason why not.
