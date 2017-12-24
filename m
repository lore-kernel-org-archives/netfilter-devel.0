From: Harsha Sharma <harshasharmaiitr@gmail.com>
Subject: Re: [PATCH] src: print 'handle' attribute in tables
Date: Sun, 24 Dec 2017 20:27:16 +0530
Message-ID: <CANMOCy03a3bNyVe4zhrishJ+n2WrQ45+k2mDqJRH=Vjxr2g9Xg@mail.gmail.com>
References: <20171223194525.6058-1-harshasharmaiitr@gmail.com> <50aa4371-2e39-9a95-89db-01d77dca18e4@free.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
To: Adel Belhouane <bugs.a.b@free.fr>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ua0-f179.google.com ([209.85.217.179]:34588 "EHLO
        mail-ua0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751574AbdLXO5S (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 24 Dec 2017 09:57:18 -0500
Received: by mail-ua0-f179.google.com with SMTP id v22so4659253uaj.1
        for <netfilter-devel@vger.kernel.org>; Sun, 24 Dec 2017 06:57:17 -0800 (PST)
In-Reply-To: <50aa4371-2e39-9a95-89db-01d77dca18e4@free.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, Dec 24, 2017 at 8:07 PM, Adel Belhouane <bugs.a.b@free.fr> wrote:
> Hello,
>
> Le 23/12/2017 =C3=A0 20:45, Harsha Sharma a =C3=A9crit :
>> Print 'handle' attribute in tables, when listing via '-a' option
>>
>> For eg.
>> nft list ruleset -a
>>
>> table ip test-ip4 {
>>       chain input {
>>               ip saddr 8.8.8.8 counter packets 0 bytes 0 # handle 3
>>       }
>>  # handle 1}
>
> [...]
>
>> diff --git a/src/rule.c b/src/rule.c
>> index bb9add0..e875816 100644
>> --- a/src/rule.c
>> +++ b/src/rule.c
>> @@ -820,6 +820,8 @@ static void table_print(const struct table *table, s=
truct output_ctx *octx)
>>               chain_print(chain, octx);
>>               delim =3D "\n";
>>       }
>> +     if (octx->handle > 0)
>> +             nft_print(octx, " # handle %" PRIu64, table->handle.handle=
.id);
>>       nft_print(octx, "}\n");
>>  }
>>
>>
>
> I'm wonderning if it wouldn't be easier (for something parsing "nft list =
ruleset -a" 's output) to have the " # handle ..." after the closing brace =
instead of before. It makes sence to consider "#" as a start of comment unt=
il end of line, and in such case the last "}" would be in the comment and m=
issing (for something choosing to ignore all such "comments").
>
> So the example would become instead:
>
> nft list ruleset -a
>
> table ip test-ip4 {
>         chain input {
>                 ip saddr 8.8.8.8 counter packets 0 bytes 0 # handle 3
>         }
> } # handle 1
>
> What do you think?
>

Yes.Makes sense to me.
Thanks.

> regards,
> Adel Belhouane.
