From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Subject: Re: [iptables-nftables PATCH 6/6] xtables: add suport for DNAT rule
 translation to nft extensions
Date: Wed, 15 May 2013 09:48:28 +0300
Message-ID: <51932FBC.1060904@linux.intel.com>
References: <519216B6.7060701@linux.intel.com> <1368528727-10127-1-git-send-email-tomasz.bursztyka@linux.intel.com> <1368528727-10127-7-git-send-email-tomasz.bursztyka@linux.intel.com> <20130514223035.GC10082@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:57949 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754889Ab3EOGsb (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 15 May 2013 02:48:31 -0400
In-Reply-To: <20130514223035.GC10082@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Pablo,
>> +static struct nft_rule_expr_list *
>> +create_nat_expr_list(const struct nf_nat_range *r)
>> +{
>> +	struct nft_rule_expr_list *expr_list;
>> +	struct nft_rule_expr *nat_expr;
>> +	int registers = 1;
>> +
>> +	expr_list = nft_rule_expr_list_alloc();
>> +	if (expr_list == NULL)
>> +		return NULL;
> Better allocate this list in nft.c and pass it as parameter. All
> extensions will require this, and after that change you can return -1
> on error / 0 on success.
>
> Or simply pass the struct nft_rule object? Then, you can skip patch
> [libnftables PATCH 6/7]?

Why not, it's a design preference. I liked the idea extension don't mess 
up with the rule and only provides its expression list.
it's less code on libnftables on your idea at least.

>> +	.x6_options	  = DNAT_opts,
>> +	.translate_to_nft = DNAT_to_nft,
> nft_to_translate is missing, right? We need it to print the rule that
> is expressed in native format.

Read the very first mail of this thread. It's actually an issue here.
I had the idea of doing the reverse function indeed, but there is a problem:
 From iptables to nftables it's easy, since we get a target made by the 
right extension, so we directly get the right translation function. 
That's what I did.

Now on the reverse way, we don't know at all to which extension the 
expression list belongs to, so which translation function to call.
Currently the only way I see it is to loop on all extensions until one 
returns successfully.
We should take care of the position in the expression list as well, and 
here I see we will need some more functions from libnftables.

I will try a PoC

> Probably you can call this xt_to_nft or struct_to_nft? It would be
> shorter and won't require realigning dnat_tg_reg I would like to skip
> those to avoid possible conflicts when merging this, we have more than
> 100 extensions.
>
> BTW, some short description on the patches is a good idea, a couple of
> lines description the intention after this (I know well what you're
> making but others may not).

Sure.


Tomasz
