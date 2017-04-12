From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH nf] netfilter: nft_hash: do not dump the auto generated
 seed
Date: Wed, 12 Apr 2017 22:43:25 +0200
Message-ID: <20170412204325.GG27933@breakpoint.cc>
References: <1491208478-6119-1-git-send-email-zlpnobody@163.com>
 <CAE=SJfBZmZD8YuEd0XzZ3ejuoVncfOGBOqh50fu1ENBWr7Qdww@mail.gmail.com>
 <CAML_gOewoMeAm_jsgZbvDCAKuAY6Q3xDBLVS8s=E0JZQWiRR5Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Laura =?iso-8859-15?Q?Garc=EDa_Li=E9bana?=
        <laura.garcia@zevenet.com>, Liping Zhang <zlpnobody@163.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Netfilter Developer Mailing List
        <netfilter-devel@vger.kernel.org>
To: Liping Zhang <zlpnobody@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:46560 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752851AbdDLUoi (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 12 Apr 2017 16:44:38 -0400
Content-Disposition: inline
In-Reply-To: <CAML_gOewoMeAm_jsgZbvDCAKuAY6Q3xDBLVS8s=E0JZQWiRR5Q@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Liping Zhang <zlpnobody@gmail.com> wrote:
> >> +++ b/net/netfilter/nft_hash.c
> >> @@ -21,6 +21,7 @@ struct nft_hash {
> >>         enum nft_registers      sreg:8;
> >>         enum nft_registers      dreg:8;
> >>         u8                      len;
> >> +       bool                    autogen_seed:1;
> >
> > Hi Liping, I don't think that hiding the seed value would be useful, and
> > even adding this attribute doesn't worth it just to hide the seed.
> >
> 
> If we don't do this thing, if the user inputting the following nft rules:
>   # nft add rule x y ct mark set jhash ip saddr mod 2
> 
> Then nft list ruleset will display something like this, where 0xd6ab633c
> is very unpredictable, and the user doesn't care the seed at all:
>   ct mark set jhash ip saddr mod 2 seed 0xd6ab633c
> 
> This will cause annoying complain when running "nft-test.py ip/hash.t".
> 
> But another problem is this, I remember that Pablo is implementing a new
> delete rule syntax, something like this:
> "nft del rule x y ct mark set jhash ip saddr mod 2"
> 
> The unpredictable seed will cause the above rule failed, since the seed
> is not the same, so we cannot find a matched nft rule.

FWIW I agree with Liping, we should eat the extra bool and
supress seed dump.

I also think most users should not ever have to even know of seed arg
existence.

In fact is there a use case where it is needed?
We might want to ditch it completely and always just
generate it privately in kernel (symhash f.e. uses
a private seed) already.
