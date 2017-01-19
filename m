From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH nf] netfilter: nf_tables: report error if stateful obj's
 name is truncated
Date: Thu, 19 Jan 2017 16:22:40 +0100
Message-ID: <20170119152240.GC16765@breakpoint.cc>
References: <1484834420-55121-1-git-send-email-zlpnobody@163.com>
 <20170119140914.GA11241@salvia>
 <CAML_gOc=0wpF9ERvvC5Vp3ncMdijrt9hOkSci1tc4tMUoR2uQg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
        Liping Zhang <zlpnobody@163.com>,
        Netfilter Developer Mailing List
        <netfilter-devel@vger.kernel.org>
To: Liping Zhang <zlpnobody@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:38302 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753866AbdASQeU (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 19 Jan 2017 11:34:20 -0500
Content-Disposition: inline
In-Reply-To: <CAML_gOc=0wpF9ERvvC5Vp3ncMdijrt9hOkSci1tc4tMUoR2uQg@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Liping Zhang <zlpnobody@gmail.com> wrote:
> > At quick glance, I can see other spots lacking this validation:
> >
> > static const struct nla_policy nft_chain_policy[NFTA_CHAIN_MAX + 1] =
> > {
> >         [NFTA_CHAIN_TABLE]      = { .type = NLA_STRING },
> >
> > Probably review and fix them in one go?
> 
> The nft table name's size is limited at this place:
> static const struct nla_policy nft_table_policy[NFTA_TABLE_MAX + 1] = {
>         [NFTA_TABLE_NAME] = { .type = NLA_STRING,
>                                                    .len =
> NFT_TABLE_MAXNAMELEN - 1 },
> 
> If NFTA_CHAIN_TABLE's size exceeded 31, nf_tables_table_lookup will
> fail eventually.
> 
> So I think adding the validation of NFTA_CHAIN_TABLE's size is not
> important.

Perhaps but its better to have it anyway so that you don't need this
extra context to understand that its limited in practice.
