From: Liping Zhang <zlpnobody@gmail.com>
Subject: Re: [PATCH nf] netfilter: nft_hash: do not dump the auto generated seed
Date: Sat, 8 Apr 2017 08:23:51 +0800
Message-ID: <CAML_gOewoMeAm_jsgZbvDCAKuAY6Q3xDBLVS8s=E0JZQWiRR5Q@mail.gmail.com>
References: <1491208478-6119-1-git-send-email-zlpnobody@163.com> <CAE=SJfBZmZD8YuEd0XzZ3ejuoVncfOGBOqh50fu1ENBWr7Qdww@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Cc: Liping Zhang <zlpnobody@163.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Netfilter Developer Mailing List
        <netfilter-devel@vger.kernel.org>
To: =?UTF-8?Q?Laura_Garc=C3=ADa_Li=C3=A9bana?=
        <laura.garcia@zevenet.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-vk0-f65.google.com ([209.85.213.65]:34615 "EHLO
        mail-vk0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752103AbdDHAXx (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 7 Apr 2017 20:23:53 -0400
Received: by mail-vk0-f65.google.com with SMTP id y16so11468863vky.1
        for <netfilter-devel@vger.kernel.org>; Fri, 07 Apr 2017 17:23:53 -0700 (PDT)
In-Reply-To: <CAE=SJfBZmZD8YuEd0XzZ3ejuoVncfOGBOqh50fu1ENBWr7Qdww@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Laura,

2017-04-08 5:19 GMT+08:00 Laura Garc=C3=ADa Li=C3=A9bana <laura.garcia@zeve=
net.com>:
> On Mon, Apr 3, 2017 at 10:34 AM, Liping Zhang <zlpnobody@163.com> wrote:
>>
>> From: Liping Zhang <zlpnobody@gmail.com>
>>
>> This can prevent the nft utility from printing out the auto generated
>> seed to the user, which is unnecessary and confusing.
>>
>> Signed-off-by: Liping Zhang <zlpnobody@gmail.com>
>> ---
>>  net/netfilter/nft_hash.c | 10 +++++++---
>>  1 file changed, 7 insertions(+), 3 deletions(-)
>>
>> diff --git a/net/netfilter/nft_hash.c b/net/netfilter/nft_hash.c
>> index eb2721a..c4dad12 100644
>> --- a/net/netfilter/nft_hash.c
>> +++ b/net/netfilter/nft_hash.c
>> @@ -21,6 +21,7 @@ struct nft_hash {
>>         enum nft_registers      sreg:8;
>>         enum nft_registers      dreg:8;
>>         u8                      len;
>> +       bool                    autogen_seed:1;
>
> Hi Liping, I don't think that hiding the seed value would be useful, and
> even adding this attribute doesn't worth it just to hide the seed.
>

If we don't do this thing, if the user inputting the following nft rules:
  # nft add rule x y ct mark set jhash ip saddr mod 2

Then nft list ruleset will display something like this, where 0xd6ab633c
is very unpredictable, and the user doesn't care the seed at all:
  ct mark set jhash ip saddr mod 2 seed 0xd6ab633c

This will cause annoying complain when running "nft-test.py ip/hash.t".

But another problem is this, I remember that Pablo is implementing a new
delete rule syntax, something like this:
"nft del rule x y ct mark set jhash ip saddr mod 2"

The unpredictable seed will cause the above rule failed, since the seed
is not the same, so we cannot find a matched nft rule.
