From: =?UTF-8?Q?Laura_Garc=C3=ADa_Li=C3=A9bana?=
        <laura.garcia@zevenet.com>
Subject: Re: [PATCH nf] netfilter: nft_hash: do not dump the auto generated seed
Date: Thu, 13 Apr 2017 01:55:30 +0200
Message-ID: <CAE=SJfDp13LaRfg0TM63xDhbQ6BWvJTFgDU=Gb8Ptj=KXKrKVA@mail.gmail.com>
References: <1491208478-6119-1-git-send-email-zlpnobody@163.com>
 <CAE=SJfBZmZD8YuEd0XzZ3ejuoVncfOGBOqh50fu1ENBWr7Qdww@mail.gmail.com>
 <CAML_gOewoMeAm_jsgZbvDCAKuAY6Q3xDBLVS8s=E0JZQWiRR5Q@mail.gmail.com> <20170412204325.GG27933@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Liping Zhang <zlpnobody@gmail.com>,
        Liping Zhang <zlpnobody@163.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Netfilter Developer Mailing List
        <netfilter-devel@vger.kernel.org>
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ua0-f181.google.com ([209.85.217.181]:33577 "EHLO
        mail-ua0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754721AbdDLXzc (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 12 Apr 2017 19:55:32 -0400
Received: by mail-ua0-f181.google.com with SMTP id q26so25227792uaa.0
        for <netfilter-devel@vger.kernel.org>; Wed, 12 Apr 2017 16:55:31 -0700 (PDT)
In-Reply-To: <20170412204325.GG27933@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Apr 12, 2017 at 10:43 PM, Florian Westphal <fw@strlen.de> wrote:
> Liping Zhang <zlpnobody@gmail.com> wrote:
>> >> +++ b/net/netfilter/nft_hash.c
>> >> @@ -21,6 +21,7 @@ struct nft_hash {
>> >>         enum nft_registers      sreg:8;
>> >>         enum nft_registers      dreg:8;
>> >>         u8                      len;
>> >> +       bool                    autogen_seed:1;
>> >
>> > Hi Liping, I don't think that hiding the seed value would be useful, and
>> > even adding this attribute doesn't worth it just to hide the seed.
>> >
>>
>> If we don't do this thing, if the user inputting the following nft rules:
>>   # nft add rule x y ct mark set jhash ip saddr mod 2
>>
>> Then nft list ruleset will display something like this, where 0xd6ab633c
>> is very unpredictable, and the user doesn't care the seed at all:
>>   ct mark set jhash ip saddr mod 2 seed 0xd6ab633c
>>
>> This will cause annoying complain when running "nft-test.py ip/hash.t".
>>
>> But another problem is this, I remember that Pablo is implementing a new
>> delete rule syntax, something like this:
>> "nft del rule x y ct mark set jhash ip saddr mod 2"
>>
>> The unpredictable seed will cause the above rule failed, since the seed
>> is not the same, so we cannot find a matched nft rule.
>
> FWIW I agree with Liping, we should eat the extra bool and
> supress seed dump.
>
> I also think most users should not ever have to even know of seed arg
> existence.
>
> In fact is there a use case where it is needed?
> We might want to ditch it completely and always just
> generate it privately in kernel (symhash f.e. uses
> a private seed) already.

In the case that is always generated in the kernel side, then we can
discard the seed parameter in nft and there is no need for an
additional bool.

Another option could be to relax the check of the seed attribute in
the tests and in the rules deletion.
