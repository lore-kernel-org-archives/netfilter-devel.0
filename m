From: Shivani Bhardwaj <shivanib134@gmail.com>
Subject: Re: [PATCH v3] extensions: libxt_connmark: Add translation to nft
Date: Fri, 25 Dec 2015 20:09:40 +0530
Message-ID: <CAKHNQQGsMzYtziBfCQzdUXeNORaQys7UdCv_DPqiBoPKuvH8nw@mail.gmail.com>
References: <20151223143333.GA16694@gmail.com> <20151225121352.GA4822@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f47.google.com ([74.125.82.47]:36941 "EHLO
	mail-wm0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752925AbbLYOkB (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 25 Dec 2015 09:40:01 -0500
Received: by mail-wm0-f47.google.com with SMTP id p187so207189685wmp.0
        for <netfilter-devel@vger.kernel.org>; Fri, 25 Dec 2015 06:40:00 -0800 (PST)
In-Reply-To: <20151225121352.GA4822@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Dec 25, 2015 at 5:43 PM, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Wed, Dec 23, 2015 at 08:03:33PM +0530, Shivani Bhardwaj wrote:
>>  static struct xtables_match connmark_mt_reg[] = {
>>       {
>>               .family        = NFPROTO_UNSPEC,
>> @@ -135,6 +178,7 @@ static struct xtables_match connmark_mt_reg[] = {
>>               .save          = connmark_save,
>>               .x6_parse      = connmark_parse,
>>               .x6_options    = connmark_mt_opts,
>> +             .xlate         = connmark_xlate,
>>       },
>>       {
>>               .version       = XTABLES_VERSION,
>> @@ -148,6 +192,7 @@ static struct xtables_match connmark_mt_reg[] = {
>>               .save          = connmark_mt_save,
>>               .x6_parse      = connmark_mt_parse,
>>               .x6_options    = connmark_mt_opts,
>> +             .xlate         = connmark_mt_xlate,
>
> Careful.
>
> The different revisions use different structure definitions, ie. the
> structure binary layout is different, therefore you cannot reuse the
> same connmark_mt_xlate() for the two different revision.
>
> Let me make sure I clarify this, this is revision 0:
>
> struct xt_connmark_info {
>         unsigned long mark, mask;
>         uint8_t invert;
> };
>
> This is revision 1:
>
> struct xt_connmark_mtinfo1 {
>         __u32 mark, mask;
>         __u8 invert;
> };
>
> The size of unsigned long depends on the architecture, so this code
> will not work correctly.
>
> You have to add a connmark_mt_xlate_v0() and connmark_mt_xlate_v1(),
> in each of these functions you have to cast data to the right
> structure layout.
>
> Thanks.

Thanks for explaining. I understand it now but why is this patch
wrong? I have used connmark_xlate() and connmark_mt_xlate() in their
respective places. Do I still get it wrong?

I'm correcting this mistake for MARK.
Thank you
