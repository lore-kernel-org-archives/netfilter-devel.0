From: Christophe Leroy <christophe.leroy@c-s.fr>
Subject: Re: Seeking help for implementing CT HELPER in nftables
Date: Tue, 20 Sep 2016 13:10:33 +0200
Message-ID: <2cfbf6f4-0031-36da-6d56-10f919d9eaf8@c-s.fr>
References: <56DAC502.2060809@c-s.fr>
 <20160307132011.GA7620@macbook.localdomain> <56DF5F61.2060000@c-s.fr>
 <570CFAB1.6090409@c-s.fr> <20160412135155.GA27975@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from pegase1.c-s.fr ([93.17.236.30]:18566 "EHLO pegase1.c-s.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752145AbcITLKi (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 20 Sep 2016 07:10:38 -0400
In-Reply-To: <20160412135155.GA27975@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello Florian and Patrick,

Le 12/04/2016 à 15:51, Florian Westphal a écrit :
> Christophe Leroy <christophe.leroy@c-s.fr> wrote:
>
> [ nft_ct helper set support ]
>
>> Patrick, can you help ?
>
> I have a few pending patches, one of them adds an immediate
> attr for ctlabel set support.
>
> Lets see if that approach is sane enough to be reused for helper
> support.
>
> I will post it soon.
>

I had a look but as far as I understood, the ctlabel works with bits.

For ct helper I need to retrieve the helper's name string in the 
nft_ct_set_init() function in order to call nf_ct_helper_ext_add()

Patrick suggested to add a new CT attribute, but I've not been able to 
find what has to be done for that exactly.

Is there any exemple in other parts of the kernel for doing that ?
Is it just to add a NFTA_CT_HELPER then add it in the nft_ct_policy 
structure as an NLA_STRING type and then retrieve it with nla_strl_cpy() ?
But how does it gets populated with the helper string passed in by nft ?

Thanks for your help,
Christophe
