From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: Re: [RFC] nftables: reverse path filtering for nft
Date: Wed, 14 Sep 2016 20:23:57 +0200
Message-ID: <CAOkSjBheup7MmfT74FF0ZE3irCf=7OFGL5acWfMen5dkxvOy8Q@mail.gmail.com>
References: <20160910200102.GA11377@breakpoint.cc> <20160912120437.GA9323@salvia>
 <20160912122107.GB27566@breakpoint.cc> <20160912185228.GA10862@salvia>
 <20160912190025.GB11685@breakpoint.cc> <20160912191438.GA11229@salvia> <20160914174515.GA4925@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
        Netfilter Development Mailing list
        <netfilter-devel@vger.kernel.org>
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f50.google.com ([74.125.82.50]:37401 "EHLO
        mail-wm0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751676AbcINSYT (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 14 Sep 2016 14:24:19 -0400
Received: by mail-wm0-f50.google.com with SMTP id k186so23541636wmd.0
        for <netfilter-devel@vger.kernel.org>; Wed, 14 Sep 2016 11:24:19 -0700 (PDT)
In-Reply-To: <20160914174515.GA4925@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Florian,

thanks for working on this, here my comments.

On 14 September 2016 at 19:45, Florian Westphal <fw@strlen.de> wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
>> On Mon, Sep 12, 2016 at 09:00:25PM +0200, Florian Westphal wrote:
>> > Pablo Neira Ayuso <pablo@netfilter.org> wrote:
>> > >         fib lookup ip daddr . oif
>> > >
>> > > As you are basically looking for the route based on IPv4 address and
>> > > the output interface, so this boils down to:
>> > >
>> > >         fib lookup $expr $flags
>> >
>> > How would the kernel disentangle the register data?
>>
>> What I'm proposing is to represent this as a concatenation, since this
>> represents the tuple that you use to look up for route.
>>
>> > (i.e., how do i know where in the sreg e.g. the daddr is
>> >  that i need to stuff in the flowi struct?)
>>
>> You can iterate over the concatenation compound from the
>> netlink_linearize path, it is just a list of expressions. Then, you
>> can set the NFTA_FIB_* netlink attribute using them.
>
> I found this to be ugly and cumbersome, I'd propose following
> syntax instead:
>
> FIB     fib_type     fib_family   '{' fib_addr fib_key_flags '}'
>
> The {} are needed because I'd like to use 'mark' and 'oif' in flags but
> these can also be expressions, i.e. I need something that tells
> the parser when end of FIB flags are reached (so instead of { }
> it could also use single ';' or something else ...)
>
> This gives following examples:
>
>  fib oif { saddr }  # ip route get $saddr, place ifindex into register)
>  fib oif { saddr mark,saddr,oif } # same, but populate flowi .saddr,mark,=
oif
>                                     members as well
>
>  fib oif { daddr mark,saddr,oif } # same, except that flowi.daddr is set
>                                   # to iph->daddr)
>


Using {} in the syntax for something which is not a set or a map seems
a bit confusing to me.

I'm sorry I have no sensible alternatives ATM.

--=20
Arturo Borrero Gonz=C3=A1lez
