From: Christophe Leroy <christophe.leroy@c-s.fr>
Subject: Re: Seeking help for implementing CT HELPER in nftables
Date: Fri, 23 Sep 2016 12:45:06 +0200
Message-ID: <c93e2f7e-fe6b-b43d-c1d4-0c57287ff06c@c-s.fr>
References: <56DAC502.2060809@c-s.fr>
 <20160307132011.GA7620@macbook.localdomain> <56DF5F61.2060000@c-s.fr>
 <570CFAB1.6090409@c-s.fr> <20160412135155.GA27975@breakpoint.cc>
 <2cfbf6f4-0031-36da-6d56-10f919d9eaf8@c-s.fr>
 <20160920153846.GB22503@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Transfer-Encoding: 8bit
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>, Patrick McHardy <kaber@trash.net>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from pegase1.c-s.fr ([93.17.236.30]:54942 "EHLO pegase1.c-s.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1759021AbcIWKpM (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 23 Sep 2016 06:45:12 -0400
In-Reply-To: <20160920153846.GB22503@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>



Le 20/09/2016 à 17:38, Florian Westphal a écrit :
> Christophe Leroy <christophe.leroy@c-s.fr> wrote:
>> Hello Florian and Patrick,
>>
>> Le 12/04/2016 à 15:51, Florian Westphal a écrit :
>>> Christophe Leroy <christophe.leroy@c-s.fr> wrote:
>>>
>>> [ nft_ct helper set support ]
>>>
>>>> Patrick, can you help ?
>>>
>>> I have a few pending patches, one of them adds an immediate
>>> attr for ctlabel set support.
>>>
>>> Lets see if that approach is sane enough to be reused for helper
>>> support.
>>>
>>> I will post it soon.
>>>
>>
>> I had a look but as far as I understood, the ctlabel works with bits.
>
> The immediate idea was tossed and we ended up using SREG just like mark.
>
>> For ct helper I need to retrieve the helper's name string in the
>> nft_ct_set_init() function in order to call nf_ct_helper_ext_add()
>>
>> Patrick suggested to add a new CT attribute, but I've not been able to find
>> what has to be done for that exactly.
>
>> Is there any exemple in other parts of the kernel for doing that ?
>> Is it just to add a NFTA_CT_HELPER then add it in the nft_ct_policy
>
> add NFTA_CT_HELPER to nft_ct_attributes, add to nft_ct_policy, yes.
>
>> structure as an NLA_STRING type and then retrieve it with nla_strl_cpy() ?
>> But how does it gets populated with the helper string passed in by nft ?
>
> nft will need to populate this (or rather, libnftnl will do this on
> behalf of nft).
>
> Currently we do this:
> nft --debug=netlink add rule filter i ct helper set foo
> ip filter i
>   [ immediate reg 1 0x006f6f66 0x00000000 0x00000000 0x00000000 ]
>   [ ct set helper with reg 1 ]
>
> So the string ('foo') turns into immediate and ct set uses the register.
>
> I'd suggest to change netlink_gen_ct_stmt() (in nftables
> src/netlink_linearize.c) to skip register allocation and pass the
> expr string directly instead.
>
> Perhaps one could add a function similar to
>
> bool ct_stmt_uses_register(const struct stmt *stmt);
>
> It would return false in case key is NFT_CT_HELPER so the linearization
> step would not allocate a register and also skip the immediate
> expression (and it keeps the ct details wrt. what needs the register
> allocation out of the netlink code).
>
> Instead, you would use nftnl_expr_set_str(nle, NFTNL_EXPR_CT_HELPER_NAME
> to pass the string expression content to the kernel.
>
> For reverse, you will need to make netlink_parse_ct_stmt not fail when
> no register is present and create a immediate/string instead using
> what is in the NFTNL_EXPR_CT_HELPER_NAME attribute.
>

Is that really needed to do so many modifications and especially modify 
the NETLINK interface ?

Don't we have a way to retrieve the helper name from the immediate 
register in the nft_ct_set_init() function ?

I've seen that the string is available in nft_ct_set_eval() through 
&regs->data[priv->sreg], but that's too late. nft_ct_set_eval() is 
called when we get the first IP packet, not when adding the rule.

The immediate register is handled prior to calling nft_ct_set_init(), so 
there must be a way to get access to it from nft_ct_set_init(), no ?

Thanks
Christophe
