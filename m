From: Shivani Bhardwaj <shivanib134@gmail.com>
Subject: Re: [PATCH v2] extensions: libxt_mark: Add translation to nft
Date: Fri, 18 Dec 2015 03:56:01 +0530
Message-ID: <CAKHNQQEtTZ0Hg57VcgrOTaFZww-3T8nc8+P1WFq5Ms4Ap2qmbg@mail.gmail.com>
References: <20151206033214.GA5939@gmail.com> <20151209132600.GA29450@salvia> <CAKHNQQF3XFhMJaoi8gBLOeGTLJjxncPQ-s9Tke3nC0FNoGVJjg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f51.google.com ([74.125.82.51]:38095 "EHLO
	mail-wm0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933340AbbLQW0W (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 17 Dec 2015 17:26:22 -0500
Received: by mail-wm0-f51.google.com with SMTP id l126so41652327wml.1
        for <netfilter-devel@vger.kernel.org>; Thu, 17 Dec 2015 14:26:21 -0800 (PST)
In-Reply-To: <CAKHNQQF3XFhMJaoi8gBLOeGTLJjxncPQ-s9Tke3nC0FNoGVJjg@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Dec 16, 2015 at 2:49 PM, Shivani Bhardwaj <shivanib134@gmail.com> wrote:
> On Wed, Dec 9, 2015 at 6:56 PM, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
>> On Sun, Dec 06, 2015 at 09:02:14AM +0530, Shivani Bhardwaj wrote:
>>> Add translation of the metainformation mark to nft.
>>
>> Much better, but I still need some changes.
>>
>> Could you include in the description the commands and the result of
>> testing this, eg.
>>
>> $ iptables-xlate -I INPUT -m mark --mark 20
>> nft add rule filter INPUT mark 20
>>
>
> Hi Pablo,
>
> I don't get these results.
> I get the following:
> nft # -I INPUT -m mark --mark 123
>
> What could be the reason for this? A bug in the code or some
> dependency? I have checked the code. It seems to follow the correct
> pattern as per the latest 6 patches.
> Could you please help?
>
>> Several examples like that would be good covering all possible cases,
>> just to make sure you're testing all possible branches in the code
>> (even if this kind of manual way, there are better ways to cover-test
>> this in an automated way but this simple testing is fine by now).
>>
>> More comments below.
>>
>>> Signed-off-by: Shivani Bhardwaj <shivanib134@gmail.com>
>>> ---
>>> Changes in v2:
>>>       Fix syntax according to nft and remove trailing whitespaces
>>>
>>>  extensions/libxt_mark.c | 64 +++++++++++++++++++++++++++++++++++++++++++++++--
>>>  1 file changed, 62 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/extensions/libxt_mark.c b/extensions/libxt_mark.c
>>> index 7f8c995..b0c06c2 100644
>>> --- a/extensions/libxt_mark.c
>>> +++ b/extensions/libxt_mark.c
>>> @@ -75,7 +75,7 @@ mark_print(const void *ip, const struct xt_entry_match *match, int numeric)
>>>
>>>       if (info->invert)
>>>               printf(" !");
>>> -
>>> +
>>>       print_mark(info->mark, info->mask);
>>>  }
>>>
>>> @@ -97,11 +97,69 @@ mark_save(const void *ip, const struct xt_entry_match *match)
>>>
>>>       if (info->invert)
>>>               printf(" !");
>>> -
>>> +
>>>       printf(" --mark");
>>>       print_mark(info->mark, info->mask);
>>>  }
>>>
>>> +static void
>>> +print_mark_xlate(struct xt_buf *buf,
>>> +              unsigned int mark, unsigned int mask)
>>> +{
>>> +        if (mask != 0xffffffffU)
>>> +                xt_buf_add(buf, " & x%x == x%x", mark, mask);
>>> +        else
>>> +                xt_buf_add(buf, " & x%x", mark);
>>> +}
>>> +
>>> +static void
>>> +mark_mt_xlate_print(const struct xt_entry_match *match,
>>> +                 struct xt_buf *buf, int numeric)
>>> +{
>>> +     const struct xt_mark_mtinfo1 *info = (const void *)match->data;
>>> +
>>> +     if (info->invert)
>>> +             xt_buf_add(buf, " !=");
>>> +     print_mark_xlate(buf, info->mark, info->mask);
>>> +}
>>> +
>>> +static int
>>> +mark_mt_xlate(const struct xt_entry_match *match,
>>> +           struct xt_buf *buf, int numeric)
>>> +{
>>> +     const struct xt_mark_mtinfo1 *info = (const void *)match->data;
>>> +
>>> +     xt_buf_add(buf, "ct mark %s", info->invert ? " !=" : "");
>>> +        print_mark_xlate(buf, info->mark, info->mask);
>>> +        xt_buf_add(buf, " ");
>>    ^^^^^^^^
>>
>> This indentation is not correct.
>>
>
> I'm using checkpatch to look for indentation errors now. Sorry for the
> inconvenience caused.
>
> Thank you
>
>>> +
>>> +        return 1;
>>> +}
>>> +
>>> +static void
>>> +mark_xlate_print(const struct xt_entry_match *match,
>>> +              struct xt_buf *buf, int numeric)
>>> +{
>>> +     const struct xt_mark_info *info = (const void *)match->data;
>>> +
>>> +        if (info->invert)
>>> +                xt_buf_add(buf, " !=");
>>> +        print_mark_xlate(buf, info->mark, info->mask);
>>         ^^^
>>
>> Same here.
>>
>> Thanks.

Hi,

While writing another patch, I realized I've done some mismatch in the
name of print functions (comparing with the patch for libxt_tcp).
Could you please suggest me the correct naming convention for them if
this is the case. I've tried some but they don't seem to be working.

If the reason is something else please let me know.

Also, please tell how the functions are logged in the binary iptables-translate.

Thank you
