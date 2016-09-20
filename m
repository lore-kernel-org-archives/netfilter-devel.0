From: Florian Westphal <fw@strlen.de>
Subject: Re: Seeking help for implementing CT HELPER in nftables
Date: Tue, 20 Sep 2016 17:38:46 +0200
Message-ID: <20160920153846.GB22503@breakpoint.cc>
References: <56DAC502.2060809@c-s.fr>
 <20160307132011.GA7620@macbook.localdomain>
 <56DF5F61.2060000@c-s.fr>
 <570CFAB1.6090409@c-s.fr>
 <20160412135155.GA27975@breakpoint.cc>
 <2cfbf6f4-0031-36da-6d56-10f919d9eaf8@c-s.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 8bit
Cc: Florian Westphal <fw@strlen.de>, Patrick McHardy <kaber@trash.net>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
To: Christophe Leroy <christophe.leroy@c-s.fr>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:33564 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932124AbcITPjn (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 20 Sep 2016 11:39:43 -0400
Content-Disposition: inline
In-Reply-To: <2cfbf6f4-0031-36da-6d56-10f919d9eaf8@c-s.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Christophe Leroy <christophe.leroy@c-s.fr> wrote:
> Hello Florian and Patrick,
> 
> Le 12/04/2016 à 15:51, Florian Westphal a écrit :
> >Christophe Leroy <christophe.leroy@c-s.fr> wrote:
> >
> >[ nft_ct helper set support ]
> >
> >>Patrick, can you help ?
> >
> >I have a few pending patches, one of them adds an immediate
> >attr for ctlabel set support.
> >
> >Lets see if that approach is sane enough to be reused for helper
> >support.
> >
> >I will post it soon.
> >
> 
> I had a look but as far as I understood, the ctlabel works with bits.

The immediate idea was tossed and we ended up using SREG just like mark.

> For ct helper I need to retrieve the helper's name string in the
> nft_ct_set_init() function in order to call nf_ct_helper_ext_add()
> 
> Patrick suggested to add a new CT attribute, but I've not been able to find
> what has to be done for that exactly.

> Is there any exemple in other parts of the kernel for doing that ?
> Is it just to add a NFTA_CT_HELPER then add it in the nft_ct_policy

add NFTA_CT_HELPER to nft_ct_attributes, add to nft_ct_policy, yes.

> structure as an NLA_STRING type and then retrieve it with nla_strl_cpy() ?
> But how does it gets populated with the helper string passed in by nft ?

nft will need to populate this (or rather, libnftnl will do this on
behalf of nft).

Currently we do this:
nft --debug=netlink add rule filter i ct helper set foo
ip filter i
  [ immediate reg 1 0x006f6f66 0x00000000 0x00000000 0x00000000 ]
  [ ct set helper with reg 1 ]

So the string ('foo') turns into immediate and ct set uses the register.

I'd suggest to change netlink_gen_ct_stmt() (in nftables
src/netlink_linearize.c) to skip register allocation and pass the
expr string directly instead.

Perhaps one could add a function similar to

bool ct_stmt_uses_register(const struct stmt *stmt);

It would return false in case key is NFT_CT_HELPER so the linearization
step would not allocate a register and also skip the immediate
expression (and it keeps the ct details wrt. what needs the register
allocation out of the netlink code).

Instead, you would use nftnl_expr_set_str(nle, NFTNL_EXPR_CT_HELPER_NAME
to pass the string expression content to the kernel.

For reverse, you will need to make netlink_parse_ct_stmt not fail when
no register is present and create a immediate/string instead using
what is in the NFTNL_EXPR_CT_HELPER_NAME attribute.

Thanks,
Florian
