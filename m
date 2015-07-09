From: subashab@codeaurora.org
Subject: Re: [PATCH] netfilter: nf_nat: Fix possible null dereference
Date: Thu, 9 Jul 2015 23:16:05 -0000
Message-ID: <4acf7f20a629dd133bf5924886c0c4d0.squirrel@www.codeaurora.org>
References: <fea9df65d6768053838fb1eca1846ef7.squirrel@www.codeaurora.org>
    <20150709222456.GA4111@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Cc: netfilter-devel@vger.kernel.org
To: "Pablo Neira Ayuso" <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:34255 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750744AbbGIXQG (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 9 Jul 2015 19:16:06 -0400
In-Reply-To: <20150709222456.GA4111@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

> This function is called from nf_nat_ipv4_fn(), see do_chain().
>
> And we're accepting the packet with no NAT mangling if we fail to add
> the extension:
>
>         nat = nf_ct_nat_ext_add(ct);
>         if (nat == NULL)
>                 return NF_ACCEPT;
>
> Can you provide more information on what your static analysis software
> reports? Thanks.
>

Sure, here is the report

- In nf_nat_masquerade_ipv4.c line 40, 'nat' is assigned the value from
function 'nfct_nat'
- In nf_nat.h line 58, '__nf_ct_ext_find( (ct),  (NF_CT_EXT_NAT) )' is
assigned the return value from function '__nf_ct_ext_find'.
- In nf_conntrack_extend.h line 68, '__nf_ct_ext_find' explicitly returns
a NULL value.

- As a result, pointer 'nat' returned from call to function 'nfct_nat' at
line 40 may be NULL and may be dereferenced at line 59 'nat->masq_index =
out->ifindex;'


