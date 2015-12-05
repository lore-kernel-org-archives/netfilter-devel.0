From: Shivani Bhardwaj <shivanib134@gmail.com>
Subject: Re: [PATCH] extensions: libxt_mark: Add translation to nft
Date: Sun, 6 Dec 2015 01:14:31 +0530
Message-ID: <CAKHNQQHnOgC4hpTP6Ma3m9bv3JWLWVrCyi-HuQUQe+EfH=u7VA@mail.gmail.com>
References: <1449321576-20705-1-git-send-email-shivanib134@gmail.com> <20151205191409.GA2830@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f50.google.com ([74.125.82.50]:33114 "EHLO
	mail-wm0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752580AbbLETow (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 5 Dec 2015 14:44:52 -0500
Received: by wmec201 with SMTP id c201so116468293wme.0
        for <netfilter-devel@vger.kernel.org>; Sat, 05 Dec 2015 11:44:50 -0800 (PST)
In-Reply-To: <20151205191409.GA2830@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, Dec 6, 2015 at 12:44 AM, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> Hi Shivani,
>
> On Sat, Dec 05, 2015 at 06:49:36PM +0530, Shivani Bhardwaj wrote:
>> Add translation of the metainformation mark to nft.
>>
>> Signed-off-by: Shivani Bhardwaj <shivanib134@gmail.com>
>> ---
>>  extensions/libxt_mark.c | 60 +++++++++++++++++++++++++++++++++++++++++++++++++
>>  1 file changed, 60 insertions(+)
>>
>> diff --git a/extensions/libxt_mark.c b/extensions/libxt_mark.c
>> index 7f8c995..5105bf9 100644
>> --- a/extensions/libxt_mark.c
>> +++ b/extensions/libxt_mark.c
>> @@ -102,6 +102,64 @@ mark_save(const void *ip, const struct xt_entry_match *match)
>>       print_mark(info->mark, info->mask);
>>  }
>>
>> +static void
>> +print_mark_xlate(struct xt_buf *buf,
>> +              unsigned int mark, unsigned int mask)
>> +{
>> +        if (mask != 0xffffffffU)
>> +                xt_buf_add(buf, " 0x%x/0x%x", mark, mask);
>
> In nftables this should be translated to &.
>

Do you mean this?

if (mask & 0xffffffffU)

>> +        else
>> +                xt_buf_add(buf, " 0x%x", mark);
>> +}
>> +
>> +static void
>> +mark_mt_xlate_print(const struct xt_entry_match *match,
>> +                 struct xt_buf *buf, int numeric)
>> +{
>> +     const struct xt_mark_mtinfo1 *info = (const void *)match->data;
>> +
>> +     if (info->invert)
>                          ^^^^^^
> There is a tab that is not needed there. Update your editor
> configuration to highlight unnecessary spaces before line break,
>

Done.

>> +             xt_buf_add(buf, " !");
>> +     print_mark_xlate(buf, info->mark, info->mask);
>> +}
>> +
>> +static int
>> +mark_mt_xlate(const struct xt_entry_match *match,
>> +           struct xt_buf *buf, int numeric)
>> +{
>> +     const struct xt_mark_mtinfo1 *info = (const void *)match->data;
>> +
>> +        xt_buf_add(buf, "ct mark %s", info->invert ? " !" : "");
>
> Invert in nft is '!='.
>
> Please, make sure that the suggested translation actually works in
> nft.
>
> But overall this looks good like a good start.

Thank you. I'll be sending version 2.
