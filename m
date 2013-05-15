From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Subject: Re: [iptables-nftables PATCH 6/6] xtables: add suport for DNAT rule
 translation to nft extensions
Date: Wed, 15 May 2013 16:24:04 +0300
Message-ID: <51938C74.3090905@linux.intel.com>
References: <519216B6.7060701@linux.intel.com> <1368528727-10127-1-git-send-email-tomasz.bursztyka@linux.intel.com> <1368528727-10127-7-git-send-email-tomasz.bursztyka@linux.intel.com> <20130514223035.GC10082@localhost> <51932FBC.1060904@linux.intel.com> <20130515125155.GB1349@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:46041 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932650Ab3EONYH (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 15 May 2013 09:24:07 -0400
In-Reply-To: <20130515125155.GB1349@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Pablo,
>> Why not, it's a design preference. I liked the idea extension don't
>> mess up with the rule and only provides its expression list.
>> it's less code on libnftables on your idea at least.
> We have to trust our iptables extensions.
>
> What extra sanity checking are you going to make anyway if the
> extension puzzles with this internal expr_list?

What do you mean?

Return 0/-1 instead of pointer/NULL is same.
As I said I am fine with your proposal in addition that it requires less 
code in libnftables.

>> Now on the reverse way, we don't know at all to which extension the
>> expression list belongs to, so which translation function to call.
>> Currently the only way I see it is to loop on all extensions until
>> one returns successfully.
> You need some dispatcher code that interprets the nft_expr and routes
> it to the right iptables extension. So you will need also one .c file
> per expression in the kernel, e.g. nft_nat.c, that performs this
> dispatching / routing to the right extension.

You lost me. Why kernel is involved here?

> Probably checking netlink_delinearize.c in nft can provide your some
> ideas.

Yes, and I actually use netlink_linearize.c to help for translation.

>> We should take care of the position in the expression list as well,
>> and here I see we will need some more functions from libnftables.
> You have the expression iterator already.

I believe it won't be sufficient. Let's see.


Tomasz
